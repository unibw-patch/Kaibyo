package com.dat3m.kaibyo;

import static com.dat3m.dartagnan.compiler.Mitigation.NOBRANCHSPECULATION;
import static com.dat3m.kaibyo.utils.Encodings.encodeLeakage;
import static com.dat3m.kaibyo.utils.options.KaibyoOptions.BRANCHSPECULATIONSTRING;
import static com.dat3m.kaibyo.utils.options.KaibyoOptions.ONLYSPECULATIVESTRING;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import org.apache.commons.cli.HelpFormatter;

import com.dat3m.dartagnan.compiler.Arch;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ParserAsmX86;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.dat3m.kaibyo.utils.Result;
import com.dat3m.kaibyo.utils.options.KaibyoOptions;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Params;
import com.microsoft.z3.Solver;

public class Kaibyo {

    public static void main(String[] args) throws IOException {

        KaibyoOptions options = new KaibyoOptions();
        try {
            options.parse(args);
        }
        catch (Exception e){
        	System.out.println(e.getMessage());
            new HelpFormatter().printHelp("Kaibyo", options);
            System.exit(1);
            return;
        }
    	if(options.getOnlySpeculativeOption() && !options.getBranchSpeculativeOption()) {
    		System.out.println("\"" + ONLYSPECULATIVESTRING + "\" option requires \"" + BRANCHSPECULATIONSTRING + "\" option");
    		System.exit(1);
            return;
    	}

        if(System.getenv().get("DAT3M_HOME") == null) {
        	System.out.println("DAT3M_HOME variable is not set");
    		System.exit(1);
            return;
        }
        
        Wmm mcm = new ParserCat().parse(new File(options.getTargetModelFilePath()));
		Program p = new ParserAsmX86(options.getEntry()).parse(new File(options.getProgramFilePath()));		
        
        Context ctx = new Context();
        testMemorySafety(ctx, p, mcm, options);
		ctx.close();
    }

    public static Result testMemorySafety(Context ctx, Program program, Wmm wmm, KaibyoOptions options) {
    	System.out.println(new Printer().print(program));
    	program.unroll(options.getSettings().getBound(), 0);
        program.compile(Arch.NONE, options.getMitigations(), 0);
        
        Solver solver = ctx.mkSolver();
        if(options.getTimeout() > 0) {
            Params p = ctx.mkParams();
    		p.add("timeout", options.getTimeout()*1000);
    		solver.setParameters(p);        	
        }

		solver.add(program.encodeSCF(ctx, options.getMitigations()));
		if(options.getMitigations().contains(NOBRANCHSPECULATION)) {
			for(Event e : program.getEvents()){
				solver.add(ctx.mkNot(e.se()));
	        }			
		}
		
        solver.add(wmm.encode(program, ctx, options.getSettings()));
        solver.add(wmm.consistent(program, ctx));
        solver.push();
        solver.add(encodeLeakage(program, wmm, options, ctx));

        if(wmm.getRelationRepository().getRelation("srf").isUsed()) {
    		for(Tuple t : wmm.getRelationRepository().getRelation("srf").getMaxTupleSet()) {
    			MemEvent m1 = (MemEvent) t.getFirst();
    			MemEvent m2 = (MemEvent) t.getSecond();
    	    	if(!options.getAliasSpeculativeOption() || m1.is(EType.INIT) || m2.is(EType.INIT)) {
    	    		BoolExpr sameAddress = ctx.mkEq(m1.getMemAddressExpr(), m2.getMemAddressExpr());
    	   			solver.add(ctx.mkEq(Utils.alias(m1, m2, ctx), sameAddress));
    	   		}        	
    		}
        }

		try {
			BufferedWriter writer = new BufferedWriter(new FileWriter(System.getenv().get("DAT3M_HOME") + "/output/" + program.getName() + ".smt2"));
	        writer.write(ctx.benchmarkToSMTString(program.getName(), "ALL", "unknown", "", solver.getAssertions(), ctx.mkTrue()));
	        writer.close();
	        System.out.println("Formula written in " + System.getenv().get("DAT3M_HOME") + "/output/" + program.getName() + ".smt2");
		} catch (IOException ignore) {}

		// Dummy result, not currently used since the encoding is written to a file.
		return Result.UNKNOWN;
    }
}