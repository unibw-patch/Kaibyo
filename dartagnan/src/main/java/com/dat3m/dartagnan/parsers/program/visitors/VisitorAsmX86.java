package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.parsers.AsmX86BaseVisitor;
import com.dat3m.dartagnan.parsers.AsmX86Parser;
import com.dat3m.dartagnan.parsers.AsmX86Visitor;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;

public class VisitorAsmX86
        extends AsmX86BaseVisitor<Object>
        implements AsmX86Visitor<Object> {

    private ProgramBuilder programBuilder;

    public VisitorAsmX86(ProgramBuilder pb){
        this.programBuilder = pb;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

	@Override public Program visitMain(AsmX86Parser.MainContext ctx) {
		visitChildren(ctx);
		return programBuilder.build();
	}
	
	@Override public Object visitAssemblerdirective(AsmX86Parser.AssemblerdirectiveContext ctx) {
//		System.out.println("A" + ctx.getText());
		return visitChildren(ctx);
	}

	@Override public Object visitInstruction(AsmX86Parser.InstructionContext ctx) {
//		System.out.println("B" + ctx.getText());
		return visitChildren(ctx);
	}
	
	@Override public Object visitLbl(AsmX86Parser.LblContext ctx) {
//		System.out.println("C" + ctx.getText());
		return visitChildren(ctx);
	}

	@Override public Object visitNumber(AsmX86Parser.NumberContext ctx) {
		System.out.println(ctx.getText());
		return visitChildren(ctx);
	}
}