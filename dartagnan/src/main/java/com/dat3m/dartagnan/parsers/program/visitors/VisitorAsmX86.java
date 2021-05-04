package com.dat3m.dartagnan.parsers.program.visitors;

import static com.dat3m.dartagnan.expression.INonDetTypes.UINT;
import static com.dat3m.dartagnan.expression.op.BOpUn.NOT;
import static com.dat3m.dartagnan.expression.op.IOpBin.AND;
import static com.dat3m.dartagnan.expression.op.IOpBin.AR_SHIFT;
import static com.dat3m.dartagnan.expression.op.IOpBin.DIV;
import static com.dat3m.dartagnan.expression.op.IOpBin.L_SHIFT;
import static com.dat3m.dartagnan.expression.op.IOpBin.MINUS;
import static com.dat3m.dartagnan.expression.op.IOpBin.MOD;
import static com.dat3m.dartagnan.expression.op.IOpBin.MULT;
import static com.dat3m.dartagnan.expression.op.IOpBin.OR;
import static com.dat3m.dartagnan.expression.op.IOpBin.PLUS;
import static com.dat3m.dartagnan.expression.op.IOpBin.XOR;
import static com.dat3m.dartagnan.parsers.program.visitors.utils.X86Flags.CF;
import static com.dat3m.dartagnan.parsers.program.visitors.utils.X86Flags.OF;
import static com.dat3m.dartagnan.parsers.program.visitors.utils.X86Flags.SF;
import static com.dat3m.dartagnan.parsers.program.visitors.utils.X86Flags.ZF;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.expression.BExprBin;
import com.dat3m.dartagnan.expression.BExprUn;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.AsmX86BaseVisitor;
import com.dat3m.dartagnan.parsers.AsmX86Parser;
import com.dat3m.dartagnan.parsers.AsmX86Parser.ExpressionContext;
import com.dat3m.dartagnan.parsers.AsmX86Parser.VardefContext;
import com.dat3m.dartagnan.parsers.AsmX86Visitor;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.utils.X86Registers;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.FunCall;
import com.dat3m.dartagnan.program.event.FunRet;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.memory.Location;

public class VisitorAsmX86
        extends AsmX86BaseVisitor<Object>
        implements AsmX86Visitor<Object> {

    private ProgramBuilder programBuilder;
    private int currenThread = 0;
    private String entry = "main";
    private Set<String> arrays = new HashSet<>();
    
    private List<IConst> currentInitValues = new ArrayList<>();
    private String varToInit = null;
    
    private Map<String, List<Event>> functions = new HashMap<>();
    private String current_function = "main";
    
	private BExpr cf;
	private BExpr of;
	private BExpr zf;
	private BExpr sf;
	
	private int stackUpperBound = 8;
	private int stackLowerBound = 36;
	
	public static final int PRECISION = 32;

    public VisitorAsmX86(ProgramBuilder pb){
        this.programBuilder = pb;
    }

    public VisitorAsmX86(ProgramBuilder pb, String entry){
        this.programBuilder = pb;
        this.entry = entry;
        this.current_function = entry;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

	@Override
	public Program visitMain(AsmX86Parser.MainContext ctx) {
		for(VardefContext gblCtx : ctx.line().stream().filter(c -> c.lbl() != null).map(c -> c.lbl().vardef()).collect(Collectors.toList())) {
			if(gblCtx != null) {
				visitVardef(gblCtx);
			}
		}
		for(X86Registers reg : X86Registers.values()) {
			programBuilder.getOrCreateRegister(currenThread, reg.getName(), PRECISION);
		}
		// Before calling the entry point, the stack is initialized we nondet  values
		// TODO: here we fix the size of the stack based on the stackLowerBound and 
		// stackUpperBound variables (which are had-coded). This should be handle better
		int stackSize = stackLowerBound + stackUpperBound + 1;
		programBuilder.addDeclarationArray("stack", Collections.nCopies(stackSize, new INonDet(UINT, PRECISION)));
		programBuilder.initRegEqArrayPtr(currenThread, "esp", "stack", stackLowerBound, PRECISION);
		visitChildren(ctx);
		if(!functions.containsKey(entry)) {
    		throw new ParsingException("Entry procedure " + entry + " has not been found");
		}
		programBuilder.addChild(currenThread, new FunCall(entry));
		for(Event e : functions.get(entry)) {
			programBuilder.addChild(currenThread, e);
			if(e instanceof FunCall) {
				// External functions are called but never defined.
				if(functions.containsKey(((FunCall)e).getFunctionName())) {
					for(Event e2 : functions.get(((FunCall)e).getFunctionName())) {
						programBuilder.addChild(currenThread, e2);
					}					
				}
			}
		}
		return programBuilder.build();
	}
	
	@Override
	public Object visitLbl(AsmX86Parser.LblContext ctx) {
		if(ctx.LABEL() != null) {
			String name = ctx.getText().substring(1, ctx.getText().length()-1);
			functions.get(current_function).add(programBuilder.getOrCreateLabel(name));
			return null;			
		}
		if(ctx.COLON() != null) {
			String name = ctx.getText().substring(0, ctx.getText().length()-1);
			if(functions.containsKey(name)) {
				current_function = name;
			}
		}
		if(ctx.slabel() != null && (ctx.slabel().getText().contains(".byte") || ctx.slabel().getText().contains(".long")) && ctx.expressionlist() != null) {
			currentInitValues.add((IConst)ctx.expressionlist().accept(this));
		}
		if(ctx.slabel() != null && ctx.slabel().getText().contains(".zero")) {
			int nZeros = Integer.parseInt(ctx.expressionlist().getText());
			currentInitValues.addAll(Collections.nCopies(nZeros, new IConst(0, PRECISION)));
		}
		return visitChildren(ctx);
	}
	
	@Override public Object visitLine(AsmX86Parser.LineContext ctx) {
		return visitChildren(ctx);
	}

	@Override
	public Object visitInstruction(AsmX86Parser.InstructionContext ctx) {
		Register esp = programBuilder.getRegister(currenThread, "esp");
		String opcode = ctx.opcode().getText();
		
		// Operations with no arguments
		switch(opcode) {
			case "nop":
				return  null;
			case "ret":
				functions.get(current_function).add(new Local(esp, new IExprBin(esp, PLUS, new IConst(4, PRECISION))));
				functions.get(current_function).add(new FunRet(current_function));
				return null;
			case "lfence":
				functions.get(current_function).add(new Fence("lfence"));
				return null;
		}

		ExpressionContext e1 = ctx.expressionlist().expression(0);
		ExpressionContext e2 = ctx.expressionlist().expression(1);
		
		ExprInterface op1 = e1 != null ? (ExprInterface)e1.accept(this) : null;
		ExprInterface op2 = e2 != null ? (ExprInterface)e2.accept(this) : null;

		Register dummy = null;

		// TODO: treat properly different instructions (based on type of extension)
		if(opcode.startsWith("mov")) {
			if(e2.multiplyingExpression(0).argument(0).ptr() != null) {
				if(op1 instanceof Register) {
					functions.get(current_function).add(new Load((Register)op1, (IExpr)op2, "NA"));
					return null;
				}
				dummy = programBuilder.getOrCreateRegister(currenThread, null, PRECISION);
				functions.get(current_function).add(new Load(dummy, (IExpr)op2, "NA"));
			}
			if(e1.multiplyingExpression(0).argument(0).ptr() != null) {
				ExprInterface value = dummy == null ? op2 :  dummy;
				functions.get(current_function).add(new Store((IExpr)op1, value, "NA"));
				return null;
			}
			ExprInterface value = dummy == null ? op2 : dummy; 
			functions.get(current_function).add(new Local((Register)op1, value));
			return null;
		}

		if(ctx.expressionlist() != null && ctx.expressionlist().expression().size() == 1) {
			ExprInterface value = op1;
			if(e1.multiplyingExpression(0).argument(0).ptr() != null) {
				dummy = programBuilder.getOrCreateRegister(currenThread, null, PRECISION);
				functions.get(current_function).add(new Load(dummy, (IExpr)op1, "NA"));
				value = dummy;
			}
			Register reg = programBuilder.getRegister(currenThread, ctx.expressionlist().getText());
			String name = ctx.expressionlist().getText().substring(1);
			Label label = programBuilder.getOrCreateLabel(name);
			switch(opcode) {
				case "push":
					functions.get(current_function).add(new Local(esp, new IExprBin(esp, MINUS, new IConst(4, PRECISION))));
					functions.get(current_function).add(new Store(esp, value, "NA"));
					break;
				case "pop":
					functions.get(current_function).add(new Load(reg, esp, "NA"));
					functions.get(current_function).add(new Local(esp, new IExprBin(esp, PLUS, new IConst(4, PRECISION))));
					break;
				case "jae":
					functions.get(current_function).add(new CondJump(new BExprUn(NOT, cf), label));
					break;
				case "jmp":
					functions.get(current_function).add(new CondJump(new BConst(true), label));
					break;
				case "jle":
					functions.get(current_function).add(new CondJump(new BExprBin(new BExprBin(sf, BOpBin.XOR, of), BOpBin.OR, zf), label));
					break;
				case "jge":				
					functions.get(current_function).add(new CondJump(new Atom(sf, COpBin.EQ, of), label));
					break;
				case "jl":
					functions.get(current_function).add(new CondJump(new BExprBin(sf, BOpBin.XOR, of), label));
					break;
				case "jne":
					functions.get(current_function).add(new CondJump(new BExprUn(BOpUn.NOT, zf), label));
					break;
				case "je":
					functions.get(current_function).add(new CondJump(zf, label));
					break;
				case "jbe":
					functions.get(current_function).add(new CondJump(new BExprBin(cf, BOpBin.OR, zf), label));
					break;
				case "call":
					String function_name = e1.getText();
					functions.get(current_function).add(new Local(esp, new IExprBin(esp, MINUS, new IConst(4, PRECISION))));
					functions.get(current_function).add(new FunCall(function_name));
					break;
				case "dec":
					functions.get(current_function).add(new Local(reg, new IExprBin(reg, MINUS, new IConst(1, PRECISION))));
					break;
				case "inc":
					functions.get(current_function).add(new Local(reg, new IExprBin(reg, PLUS, new IConst(1, PRECISION))));
					break;
				default:
					System.out.println("WARNING-2: " + ctx.getText());
					return null;
			}
			return null;
		}

		if(ctx.expressionlist() != null && ctx.expressionlist().expression().size() == 2) {
			
			if(opcode.equals("lea")) {
				functions.get(current_function).add(new Local((Register)op1, op2));
				return null;
			}
			
			Register dummy1 = null;
			Register dummy2 = null;
			
			if(e1.multiplyingExpression(0).argument(0).ptr() != null) {
				dummy1 = programBuilder.getOrCreateRegister(currenThread, null, PRECISION);
				functions.get(current_function).add(new Load(dummy1, (IExpr)op1, "NA"));
			}
			
			if(e2.multiplyingExpression(0).argument(0).ptr() != null) {
				dummy2 = programBuilder.getOrCreateRegister(currenThread, null, PRECISION);
				functions.get(current_function).add(new Load(dummy2, (IExpr)op2, "NA"));
			}
			
			ExprInterface v1p = dummy1 == null ? op1 : dummy1;
			ExprInterface v2p = dummy2 == null ? op2 : dummy2;
			ExprInterface exp;

			switch(opcode) {
				case "shl":
					exp = new IExprBin(v1p, L_SHIFT, v2p);
					break;
				case "sar":
					exp = new IExprBin(v1p, AR_SHIFT, v2p);
					break;
				case "imul":
					exp = new IExprBin(v1p, MULT, v2p);
					break;
				case "xor":
					exp = new IExprBin(v1p, XOR, v2p);
					break;
				case "and":
					exp = new IExprBin(v1p, AND, v2p);
					break;
				case "or":
					exp = new IExprBin(v1p, OR, v2p);
					break;
				case "add":
					exp = new IExprBin(v1p, PLUS, v2p);
					break;
				case "sub":
					exp = new IExprBin(v1p, MINUS, v2p);
					break;
				case "cmp":
					cf = CF.getFlagDef(v1p, v2p);
					of = OF.getFlagDef(v1p, v2p);
					zf = ZF.getFlagDef(v1p, v2p);
					sf = SF.getFlagDef(v1p, v2p);
					return null;
				default:
					System.out.println("WARNING-3: " + ctx.getText());
					return null;
			}
			
			if(e1.multiplyingExpression(0).argument(0).ptr() != null) {
				ExprInterface value = dummy == null ? exp :  dummy;
				functions.get(current_function).add(new Store((IExpr)op1, value, "NA"));
				return null;
			}
			functions.get(current_function).add(new Local((Register)v1p, exp));
			return null;
		}
		System.out.println("WARNING-4: " + ctx.getText());
		return null;
	}
	
	@Override
	public Object visitVardef(AsmX86Parser.VardefContext ctx) {
		if(ctx.type().getText().equals("object")) {
			String name = ctx.variable().getText();
			if(programBuilder.getLocation(name) == null) {
				programBuilder.getOrCreateLocation(name, PRECISION);
			}
			return null;
		}
		if(ctx.type().getText().equals("function")) {
			String name = ctx.variable().getText();
			if(!functions.containsKey(name)) {
				functions.put(name, new ArrayList<Event>());				
			}
		}
		return null;
	}

	@Override
	public Object visitGlobal(AsmX86Parser.GlobalContext ctx) {
		if(currentInitValues.size() == 1) {
			programBuilder.initLocEqConst(varToInit, currentInitValues.get(0));
		} else if (currentInitValues.size() > 1) {
			programBuilder.addDeclarationArray(varToInit, currentInitValues);
			arrays.add(varToInit);
		}
		currentInitValues = new ArrayList<>();
		varToInit = ctx.NAME().toString();
		return null;
	}

	@Override
	public Object visitName(AsmX86Parser.NameContext ctx) {
		if(arrays.contains(ctx.getText())) {
			return programBuilder.getPointer(ctx.getText());
		}
		Location loc = programBuilder.getLocation(ctx.getText());
		if(loc != null) {
			return loc.getAddress();
		}
		return visitChildren(ctx);
	}

	@Override public Object visitArrayAccess(AsmX86Parser.ArrayAccessContext ctx) {
		if(ctx.name() != null) {
			IExpr base = (IExpr)ctx.name().accept(this);
			IExpr index = (IExpr)ctx.expression().accept(this);
			return new IExprBin(base, PLUS, index);
		}
		return ctx.expression().accept(this);
	}
	
	@Override
	public Object visitExpression(AsmX86Parser.ExpressionContext ctx) {
		if(!ctx.SIGN().isEmpty()) {
			ExprInterface op1 = (ExprInterface)ctx.multiplyingExpression(0).accept(this);
			ExprInterface op2 = (ExprInterface)ctx.multiplyingExpression(1).accept(this);
			IOpBin op = ctx.SIGN().get(0).toString().equals("+") ? PLUS : MINUS;
			return new IExprBin(op1, op, op2);
		}
		return visitChildren(ctx);
	}
	
	@Override
	public Object visitMultiplyingExpression(AsmX86Parser.MultiplyingExpressionContext ctx) {
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

	@Override
	public Register visitRegister_(AsmX86Parser.Register_Context ctx) {
		return programBuilder.getRegister(currenThread, ctx.getText());
	}

	@Override
	public IConst visitNumber(AsmX86Parser.NumberContext ctx) {
		return new IConst(ctx.getText(), PRECISION);
	}
}