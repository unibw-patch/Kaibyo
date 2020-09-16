package com.dat3m.dartagnan.program.event;

import static com.dat3m.dartagnan.compiler.Mitigation.LFENCE;

import java.util.List;

import com.dat3m.dartagnan.compiler.Arch;
import com.dat3m.dartagnan.compiler.Mitigation;
import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class CondJump extends Event implements RegReaderData {

    private Label label;
    private Label label4Copy;
    private final BExpr expr;
    private final ImmutableSet<Register> dataRegs;

    public CondJump(BExpr expr, Label label){
        if(label == null){
            throw new IllegalArgumentException("CondJump event requires non null label event");
        }
        if(expr == null){
            throw new IllegalArgumentException("CondJump event requires non null expression");
        }
        this.label = label;
        this.label.addListener(this);
        this.expr = expr;
        dataRegs = expr.getRegs();
        addFilters(EType.ANY, EType.JUMP, EType.REG_READER);
    }

    protected CondJump(CondJump other) {
		super(other);
		this.label = other.label4Copy;
		this.expr = other.expr;
		this.dataRegs = other.dataRegs;
		Event notifier = label != null ? label : other.label;
		notifier.addListener(this);
    }
    
    public Label getLabel(){
        return label;
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
    }

    @Override
    public String toString(){
    	if(expr instanceof BConst && ((BConst)expr).getValue()) {
            return "goto " + label;
    	}
        return "if(" + expr + "); then goto " + label;
    }

    @Override
    public void notify(Event label) {
    	if(this.label == null) {
        	this.label = (Label)label;
    	} else if (oId > label.getOId()) {
    		this.label4Copy = (Label)label;
    	}
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public void unroll(int bound, Event predecessor) {
        if(label.getOId() < oId){
        	if(bound > 1) {
        		predecessor = copyPath(label, successor, predecessor);
        	}
        	Event next = predecessor;
        	if(bound == 1) {
            	next = new BoundEvent();
        		predecessor.setSuccessor(next);        		
        	}
        	if(successor != null) {
        		successor.unroll(bound, next);
        	}
    	    return;
        }
        super.unroll(bound, predecessor);
    }


    @Override
    public CondJump getCopy(){
    	return new CondJump(this);
    }

    
    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int compile(Arch target, List<Mitigation> mitigations, int nextId, Event predecessor) {
        cId = nextId++;
        if(successor == null){
            throw new RuntimeException("Malformed CondJump event");
        }
        if(mitigations.contains(LFENCE)) {
            Fence mfence = new Fence("Mfence");
            mfence.setSuccessor(successor);
            successor = mfence;
        }
        cf.add(expr);
        label.cf.add(expr);        	
        successor.cf.addAll(cf);
        return successor.compile(target, mitigations, nextId, this);
    }


    // Encoding
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public BoolExpr encodeCF(Context ctx, BoolExpr cond) {
        if(cfEnc == null){
            cfCond = (cfCond == null) ? cond : ctx.mkOr(cfCond, cond);
            BoolExpr ifCond = expr.toZ3Bool(this, ctx);
            label.addCfCond(ctx, ctx.mkAnd(ifCond, cfVar));
            cfEnc = ctx.mkAnd(ctx.mkEq(cfVar, cfCond), encodeExec(ctx));
            cfEnc = ctx.mkAnd(cfEnc, successor.encodeCF(ctx, ctx.mkAnd(ctx.mkNot(ifCond), cfVar)));
        }
        return cfEnc;
    }

    @Override
	public BoolExpr encodeSCF(Context ctx, BoolExpr cond, BoolExpr cond2) {
        if(cfEnc == null){
            cfCond = (cfCond == null) ? cond : ctx.mkOr(cfCond, cond);
			seCond = (seCond == null) ? cond2 : ctx.mkOr(seCond, cond2);            
			BoolExpr ifCond = expr.toZ3Bool(this, ctx);
            cfEnc = ctx.mkAnd(ctx.mkEq(cfVar, cfCond), encodeSpecExec(ctx));
            if(ifCond.isTrue()) {
            	// Only conditional jumps can start speculation
            	cfEnc = ctx.mkAnd(cfEnc, ctx.mkNot(startSEVar));
            } else {
            	cfEnc = ctx.mkAnd(cfEnc, ctx.mkEq(startSEVar, seVar));
            }
            // Jump if (cond /\ !spec) 
            label.addCfCond(ctx, ctx.mkAnd(ifCond, ctx.mkNot(startSEVar), cfVar));
            // Jump speculatively if (!cond /\ spec) 
            label.addCfCond(ctx, ctx.mkAnd(ctx.mkNot(ifCond), startSEVar, cfVar));
            // Continue if (!cond /\ !spec)
            BoolExpr cont = ctx.mkAnd(ctx.mkNot(ifCond), ctx.mkNot(startSEVar));
            cfEnc = ctx.mkAnd(cfEnc, successor.encodeSCF(ctx, ctx.mkAnd(cont, cfVar), seVar));            
        }
        return cfEnc;
    }
}
