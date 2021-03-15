package com.dat3m.dartagnan.parsers.program.visitors;

import static com.dat3m.dartagnan.expression.op.BOpUn.NOT;
import static com.dat3m.dartagnan.expression.op.IOpBin.AND;
import static com.dat3m.dartagnan.expression.op.IOpBin.DIV;
import static com.dat3m.dartagnan.expression.op.IOpBin.MINUS;
import static com.dat3m.dartagnan.expression.op.IOpBin.MOD;
import static com.dat3m.dartagnan.expression.op.IOpBin.MULT;
import static com.dat3m.dartagnan.expression.op.IOpBin.PLUS;
import static com.dat3m.dartagnan.expression.op.IOpBin.XOR;
import static com.dat3m.dartagnan.parsers.program.visitors.utils.X86Registers.CF;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Stack;
import java.util.stream.Collectors;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BExprUn;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.AsmX86BaseVisitor;
import com.dat3m.dartagnan.parsers.AsmX86Parser;
import com.dat3m.dartagnan.parsers.AsmX86Parser.VardefContext;
import com.dat3m.dartagnan.parsers.AsmX86Visitor;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.utils.X86Registers;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.assembler.event.Pop;
import com.dat3m.dartagnan.program.assembler.event.Push;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.FunCall;
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
    
    private Map<String, List<Event>> functions = new HashMap<>();
    private String current_function = "main";
    
    private Stack<Register> stack = new Stack<Register>();

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
		if(!functions.containsKey(entry)) {
    		throw new ParsingException("Entry procedure " + entry + " has not been found");
		}
		for(Event e : functions.get(entry)) {
			if(e instanceof Push || e instanceof Pop) {
				push_pop(e);
				continue;
			}
			programBuilder.addChild(currenThread, e);
			if(e instanceof FunCall) {
				// External functions are called but never defined.
				if(functions.containsKey(((FunCall)e).getFunctionName())) {
					for(Event e2 : functions.get(((FunCall)e).getFunctionName())) {
						if(e2 instanceof Push || e2 instanceof Pop) {
							push_pop(e2);
							continue;
						}
						programBuilder.addChild(currenThread, e2);
					}					
				}
			}
		}
		return programBuilder.build();
	}
	
	private void push_pop(Event e) {
		if(e instanceof Push) {
			Register sReg = programBuilder.getOrCreateRegister(currenThread, "stack(" + stack.size() + ")", -1);
			stack.push(sReg);	
			programBuilder.addChild(currenThread, new Local(sReg, ((Push)e).getValue()));				
		} else {
			Register sReg = stack.pop();
			programBuilder.addChild(currenThread, new Local(((Pop)e).getRegister(), sReg));			
		}
	}
	
	@Override public Object visitLbl(AsmX86Parser.LblContext ctx) {
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
	
	@Override public Object visitInstruction(AsmX86Parser.InstructionContext ctx) {
		if(ctx.expressionlist() != null && ctx.expressionlist().expression().size() == 1) {
			Register reg;
			switch(ctx.opcode().getText()) {
			case "push":
				reg = programBuilder.getRegister(currenThread, ctx.expressionlist().getText());
				functions.get(current_function).add(new Push(reg));
				break;
			case "pop":
				reg = programBuilder.getRegister(currenThread, ctx.expressionlist().getText());
				functions.get(current_function).add(new Pop(reg));
				break;
			case "jae":
				String name = ctx.expressionlist().getText().substring(2);
				Label label = programBuilder.getOrCreateLabel(name);
				reg = programBuilder.getOrCreateRegister(currenThread, CF.getName(), -1);
				functions.get(current_function).add(new CondJump(new BExprUn(NOT, reg), label));
				break;
			case "call":
				String function_name = ctx.expressionlist().expression(0).getText();
				functions.get(current_function).add(new FunCall(function_name));
				break;
			default:
				System.out.println("WARNING-2: " + ctx.getText());
				return null;
			}
		}
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
				exp = new Atom(op1, COpBin.GTE, op2);
				break;
			case "lea":
				reg = (Register)op1;
				exp = (ExprInterface)ctx.expressionlist().expression(1).multiplyingExpression(0).argument(0).expression().accept(this);
				break;
			case "mov":
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
				reg = (Register)op1;
				exp = op2;
				break;
			default:
				System.out.println("WARNING-3: " + ctx.getText());
				return null;
			}
			functions.get(current_function).add(new Local(reg, exp));
			return null;
		}
		return visitChildren(ctx);
	}
	
	@Override public Object visitVardef(AsmX86Parser.VardefContext ctx) {
		if(ctx.type().getText().equals("object")) {
			programBuilder.getOrCreateLocation(ctx.variable().getText(), -1);
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