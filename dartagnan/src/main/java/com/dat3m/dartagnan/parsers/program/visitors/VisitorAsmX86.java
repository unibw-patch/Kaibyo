package com.dat3m.dartagnan.parsers.program.visitors;

import static com.dat3m.dartagnan.expression.op.COpBin.GTE;
import static com.dat3m.dartagnan.expression.op.IOpBin.AND;
import static com.dat3m.dartagnan.expression.op.IOpBin.DIV;
import static com.dat3m.dartagnan.expression.op.IOpBin.MINUS;
import static com.dat3m.dartagnan.expression.op.IOpBin.MOD;
import static com.dat3m.dartagnan.expression.op.IOpBin.MULT;
import static com.dat3m.dartagnan.expression.op.IOpBin.PLUS;
import static com.dat3m.dartagnan.expression.op.IOpBin.XOR;
import static com.dat3m.dartagnan.parsers.program.visitors.utils.X86Registers.CF;

import java.util.stream.Collectors;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.AsmX86BaseVisitor;
import com.dat3m.dartagnan.parsers.AsmX86Parser;
import com.dat3m.dartagnan.parsers.AsmX86Parser.VardefContext;
import com.dat3m.dartagnan.parsers.AsmX86Visitor;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.utils.X86Registers;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.memory.Location;

public class VisitorAsmX86
        extends AsmX86BaseVisitor<Object>
        implements AsmX86Visitor<Object> {

    private ProgramBuilder programBuilder;
    private int currenThread = 0;

    public VisitorAsmX86(ProgramBuilder pb){
        this.programBuilder = pb;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

	@Override public Program visitMain(AsmX86Parser.MainContext ctx) {
		for(VardefContext gblCtx : ctx.line().stream().filter(c -> c.lbl() != null).map(c -> c.lbl().vardef()).collect(Collectors.toList())) {
			if(gblCtx != null) {
				visitVardef(gblCtx);
			}
		}
		for(X86Registers reg : X86Registers.values()) {
			programBuilder.getOrCreateRegister(currenThread, reg.getName(), -1);
		}
		visitChildren(ctx);
		return programBuilder.build();
	}
	
	@Override public Object visitInstruction(AsmX86Parser.InstructionContext ctx) {
		if(ctx.expressionlist() != null && ctx.expressionlist().expression().size() == 2) {
			ExprInterface op1 = (ExprInterface)ctx.expressionlist().expression(0).accept(this);
			ExprInterface op2 = (ExprInterface)ctx.expressionlist().expression(1).accept(this);
			Register reg = null;
			ExprInterface exp = null;
			switch(ctx.opcode().getText()) {
			case "xor":
				reg = (Register)op1;
				exp = new IExprBin(op1, XOR, op2);
				break;
			case "and":
				reg = (Register)op1;
				exp = new IExprBin(op1, AND, op2);
				break;
			case "add":
				reg = (Register)op1;
				exp = new IExprBin(op1, PLUS, op2);
				break;
			case "sub":
				reg = (Register)op1;
				exp = new IExprBin(op1, MINUS, op2);
				break;
			case "cmp":
				reg = programBuilder.getRegister(currenThread, CF.getName());
				exp = new Atom(op1, GTE, op2);
				break;
			case "lea":
				reg = (Register)op1;
				exp = (ExprInterface)ctx.expressionlist().expression(1).multiplyingExpression(0).argument(0).expression().accept(this);
				break;
			case "mov":
				if(ctx.expressionlist().expression(0).multiplyingExpression(0).argument(0).address() != null) {
					IExpr address = (IExpr)ctx.expressionlist().expression(0).accept(this);
					programBuilder.addChild(currenThread, new Store(address, (ExprInterface)op2, "NA"));
					return null;
				}
				if(ctx.expressionlist().expression(1).multiplyingExpression(0).argument(0).address() != null) {
					IExpr address = (IExpr)ctx.expressionlist().expression(1).accept(this);
					programBuilder.addChild(currenThread, new Load((Register)op1, address, "NA"));
					return null;
				}
				reg = (Register)op1;
				exp = op2;
				break;
			default:
				System.out.println("WARNING-1: " + ctx.getText());
				return null;
			}
			programBuilder.addChild(currenThread, new Local(reg, exp));
			return null;
		}
		return visitChildren(ctx);
	}
	
	@Override public Object visitVardef(AsmX86Parser.VardefContext ctx) {
		if(ctx.type().getText().equals("object")) {
			programBuilder.getOrCreateLocation(ctx.variable().getText(), -1);
		}
		return null;
	}

	@Override public Object visitName(AsmX86Parser.NameContext ctx) {
		Location loc = programBuilder.getLocation(ctx.getText());
		if(loc != null) {
			return loc.getAddress();
		}
		return visitChildren(ctx);
	}

	@Override public Object visitAddress(AsmX86Parser.AddressContext ctx) {
		return (IExpr)ctx.expression().accept(this);
	}

	@Override public Object visitExpression(AsmX86Parser.ExpressionContext ctx) {
		Location loc = programBuilder.getLocation(ctx.getText());
		if(loc != null) {
			return loc.getAddress();
		}
		if(!ctx.SIGN().isEmpty()) {
			ExprInterface op1 = (ExprInterface)ctx.multiplyingExpression(0).accept(this);
			ExprInterface op2 = (ExprInterface)ctx.multiplyingExpression(1).accept(this);
			IOpBin op = ctx.SIGN().get(0).toString().equals("+") ? PLUS : MINUS;
			return new IExprBin(op1, op, op2);
		}
		return visitChildren(ctx);
	}
	@Override public Object visitMultiplyingExpression(AsmX86Parser.MultiplyingExpressionContext ctx) {
		if(!ctx.MULT().isEmpty()) {
			ExprInterface op1 = (ExprInterface)ctx.argument(0).accept(this);
			ExprInterface op2 = (ExprInterface)ctx.argument(1).accept(this);
			IOpBin op = null;
			switch(ctx.MULT().get(0).toString()) {
				case "*":
					op = MULT;
					break;
				case "/":
					op = DIV;
					break;
				case "mod":
					op = MOD;
					break;
			}
			return new IExprBin(op1, op, op2);			
		}
		return visitChildren(ctx);
	}

	@Override public Register visitRegister_(AsmX86Parser.Register_Context ctx) {
		return programBuilder.getRegister(currenThread, ctx.getText());
	}

	@Override public IConst visitNumber(AsmX86Parser.NumberContext ctx) {
		return new IConst(Integer.decode(ctx.getText()), -1);
	}
}