package com.dat3m.dartagnan.parsers.program.visitors;

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
import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.AsmX86BaseVisitor;
import com.dat3m.dartagnan.parsers.AsmX86Parser;
import com.dat3m.dartagnan.parsers.AsmX86Parser.ArrayinitContext;
import com.dat3m.dartagnan.parsers.AsmX86Parser.ArraysizeContext;
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
    
    private Map<String, List<Event>> functions = new HashMap<>();
    private String current_function = "main";
    
	private BExpr cf;
	private BExpr of;
	private BExpr zf;
	private BExpr sf;
	
	private int stackUpperBound = 8;
	private int stackLowerBound = 12;
	
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
		for(ArrayinitContext gblCtx : ctx.line().stream().filter(c -> c.lbl() != null).map(c -> c.lbl().arrayinit()).collect(Collectors.toList())) {
			if(gblCtx != null) {
				visitArrayinit(gblCtx);
			}
		}
		for(ArraysizeContext gblCtx : ctx.line().stream().filter(c -> c.lbl() != null).map(c -> c.lbl().arraysize()).collect(Collectors.toList())) {
			if(gblCtx != null) {
				visitArraysize(gblCtx);
			}
		}
		for(VardefContext gblCtx : ctx.line().stream().filter(c -> c.lbl() != null).map(c -> c.lbl().vardef()).collect(Collectors.toList())) {
			if(gblCtx != null) {
				visitVardef(gblCtx);
			}
		}
		for(X86Registers reg : X86Registers.values()) {
			programBuilder.getOrCreateRegister(currenThread, reg.getName(), PRECISION);
		}
		// Before calling the entry point, the stack is initialized we nondet  values
		// TODO: here we fix the size of the stack to 10. This should be handle better
		// i.e. compute the actual size of make it parametric
		int stackSize = stackLowerBound + stackUpperBound;
//		programBuilder.addDeclarationArray("stack", Collections.nCopies(stackSize, new INonDet(UINT, -1)));
		programBuilder.addDeclarationArray("stack", Collections.nCopies(stackSize, new IConst(16, PRECISION)));
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
			String name = ctx.getText().substring(2, ctx.getText().length()-1);
			functions.get(current_function).add(programBuilder.getOrCreateLabel(name));
			return null;			
		}
		if(ctx.COLON() != null) {
			String name = ctx.getText().substring(0, ctx.getText().length()-1);
			if(functions.containsKey(name)) {
				current_function = name;
			}
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
		if(opcode.equals("ret")) {
			functions.get(current_function).add(new Local(esp, new IExprBin(esp, PLUS, new IConst(4, PRECISION))));
			functions.get(current_function).add(new FunRet(current_function));
			return null;
		}
		if(opcode.equals("lfence")) {
			functions.get(current_function).add(new Fence("lfence"));
			return null;
		}
		// TODO: treat properly different instructions (based on type of extension)
		if(opcode.startsWith("mov")) {
			ExprInterface op1 = (ExprInterface)ctx.expressionlist().expression(0).accept(this);
			ExprInterface op2 = (ExprInterface)ctx.expressionlist().expression(1).accept(this);
			if(ctx.expressionlist().expression(0).multiplyingExpression(0).argument(0).address() != null) {
				IExpr address = (IExpr)ctx.expressionlist().expression(0).accept(this);
				functions.get(current_function).add(new Store(address, (ExprInterface)op2, "NA"));
				return null;
			}
			if(ctx.expressionlist().expression(1).multiplyingExpression(0).argument(0).address() != null) {
				IExpr address = (IExpr)ctx.expressionlist().expression(1).accept(this);
				functions.get(current_function).add(new Load((Register)op1, address, "NA"));
				return null;
			}
			functions.get(current_function).add(new Local((Register)op1, op2));
			return null;
		}
		if(ctx.expressionlist() != null && ctx.expressionlist().expression().size() == 1) {
			Register reg = programBuilder.getRegister(currenThread, ctx.expressionlist().getText());
			String name = ctx.expressionlist().getText().substring(2);
			Label label = programBuilder.getOrCreateLabel(name);
			switch(opcode) {
			case "push":
				functions.get(current_function).add(new Local(esp, new IExprBin(esp, MINUS, new IConst(4, PRECISION))));
				functions.get(current_function).add(new Store(esp, reg, "NA"));
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
			case "call":
				String function_name = ctx.expressionlist().expression(0).getText();
				functions.get(current_function).add(new Local(esp, new IExprBin(esp, MINUS, new IConst(4, PRECISION))));
				functions.get(current_function).add(new FunCall(function_name));
				break;
			default:
				System.out.println("WARNING-2: " + ctx.getText());
				return null;
			}
			return null;
		}
		if(ctx.expressionlist() != null && ctx.expressionlist().expression().size() == 2) {
			ExprInterface v1 = (ExprInterface)ctx.expressionlist().expression(0).accept(this);
			if(ctx.expressionlist().expression(0).multiplyingExpression(0).argument(0).address() !=  null) {
				Register dummy = programBuilder.getOrCreateRegister(currenThread, null, PRECISION);
				functions.get(current_function).add(new Load(dummy, (IExpr)v1, "NA"));
				v1 = dummy;
			}
			ExprInterface v2 = (ExprInterface)ctx.expressionlist().expression(1).accept(this);
			if(ctx.expressionlist().expression(1).multiplyingExpression(0).argument(0).address() !=  null) {
				Register dummy = programBuilder.getOrCreateRegister(currenThread, null, PRECISION);
				functions.get(current_function).add(new Load(dummy, (IExpr)v2, "NA"));
				v2 = dummy;
			}
			ExprInterface exp;
			switch(opcode) {
			case "shl":
				exp = new IExprBin(v1, L_SHIFT, v2);
				break;
			case "sar":
				exp = new IExprBin(v1, AR_SHIFT, v2);
				break;
			case "imul":
				exp = new IExprBin(v1, MULT, v2);
				break;
			case "xor":
				exp = new IExprBin(v1, XOR, v2);
				break;
			case "and":
				exp = new IExprBin(v1, AND, v2);
				break;
			case "or":
				exp = new IExprBin(v1, OR, v2);
				break;
			case "add":
				exp = new IExprBin(v1, PLUS, v2);
				break;
			case "sub":
				exp = new IExprBin(v1, MINUS, v2);
				break;
			case "lea":
				exp = (ExprInterface)ctx.expressionlist().expression(1).multiplyingExpression(0).argument(0).expression().accept(this);
				break;
			case "cmp":
				cf = CF.getFlagDef(v1, v2);
				of = OF.getFlagDef(v1, v2);
				zf = ZF.getFlagDef(v1, v2);
				sf = SF.getFlagDef(v1, v2);
				return null;
			default:
				System.out.println("WARNING-3: " + ctx.getText());
				return null;
			}
			functions.get(current_function).add(new Local((Register)v1, exp));
			return null;
		}
		System.out.println("WARNING-4: " + ctx.getText());
		return visitChildren(ctx);
	}
	
	@Override
	public Object visitArraysize(AsmX86Parser.ArraysizeContext ctx) {
		String name = ctx.expressionlist().expression(0).getText();
		if(!arrays.contains(name)) {
			int size = Integer.decode(ctx.expressionlist().expression(1).getText());
			programBuilder.addDeclarationArray(name, Collections.nCopies(size, new IConst(0, PRECISION)));
			arrays.add(name);
		}
		return null;
	}

	@Override
	public Object visitArrayinit(AsmX86Parser.ArrayinitContext ctx) {
		List<ExpressionContext> exprs = ctx.expressionlist().expression();
		String name = exprs.remove(0).getText();
		if(!arrays.contains(name)) {
			List<IConst> values = exprs.stream().map(e -> (IConst)e.accept(this)).collect(Collectors.toList());
			programBuilder.addDeclarationArray(name, values);
			arrays.add(name);
		}
		return null;
	}

	@Override 
	public Object visitVarinit(AsmX86Parser.VarinitContext ctx) {
		String name = ctx.expressionlist().expression(0).getText();
		IConst value = (IConst)ctx.expressionlist().expression(1).accept(this);
		programBuilder.initLocEqConst(name, value);
		return visitChildren(ctx);
	}

	@Override
	public Object visitVardef(AsmX86Parser.VardefContext ctx) {
		if(ctx.type().getText().equals("object")) {
			String name = ctx.variable().getText();
			if(!arrays.contains(name) && programBuilder.getLocation(ctx.variable().getText()) == null) {
				programBuilder.getOrCreateLocation(ctx.variable().getText(), PRECISION);				
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

	@Override
	public Object visitAddress(AsmX86Parser.AddressContext ctx) {
		return (IExpr)ctx.expression().accept(this);
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
		try {
			return new IConst(Integer.decode(ctx.getText()), PRECISION);			
		} catch (Exception e) {
			System.out.println("WARNING: " + ctx.getText() + " cannot be parsed");
			return null;
		}
	}
}