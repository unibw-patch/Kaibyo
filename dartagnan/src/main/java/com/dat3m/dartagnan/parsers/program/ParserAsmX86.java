package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.compiler.Arch;
import com.dat3m.dartagnan.parsers.AsmX86Lexer;
import com.dat3m.dartagnan.parsers.AsmX86Parser;
import com.dat3m.dartagnan.parsers.program.utils.ParserErrorListener;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorAsmX86;
import com.dat3m.dartagnan.program.Program;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import org.antlr.v4.runtime.*;

public class ParserAsmX86 implements ParserInterface {

	private String entry;
	
	public ParserAsmX86(String entry) {
		this.entry = entry;
	}
	
	public ParserAsmX86() {
		this.entry = "main";
	}
	
    public Program parse(File file) throws IOException {
        FileInputStream stream = new FileInputStream(file);
        CharStream charStream = CharStreams.fromStream(stream);
        Program program = parse(charStream);
        stream.close();
        return program;
    }

    public Program parse(String raw) {
    	return parse(CharStreams.fromString(raw));
    }

    @Override
    public Program parse(CharStream charStream) {
    	AsmX86Lexer lexer = new AsmX86Lexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        AsmX86Parser parser = new AsmX86Parser(tokenStream);
        parser.addErrorListener(new ParserErrorListener());
        ProgramBuilder pb = new ProgramBuilder();
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorAsmX86 visitor = new VisitorAsmX86(pb, entry);

        Program program = (Program) parserEntryPoint.accept(visitor);
        program.setArch(Arch.TSO);
        return program;
    }
}