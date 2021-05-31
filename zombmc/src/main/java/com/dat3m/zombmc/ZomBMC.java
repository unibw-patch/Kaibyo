package com.dat3m.zombmc;

import static com.dat3m.dartagnan.compiler.Mitigation.NOBRANCHSPECULATION;
import static com.dat3m.zombmc.utils.Encodings.encodeLeakage;
import static com.dat3m.zombmc.utils.Result.UNSAFE;
import static com.dat3m.zombmc.utils.Result.SAFE;
import static com.dat3m.zombmc.utils.Result.TIMEOUT;
import static com.dat3m.zombmc.utils.options.ZomBMCOptions.BRANCHSPECULATIONSTRING;
import static com.dat3m.zombmc.utils.options.ZomBMCOptions.ONLYSPECULATIVESTRING;
import static com.microsoft.z3.Status.SATISFIABLE;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.apache.commons.cli.HelpFormatter;

import com.dat3m.dartagnan.compiler.Arch;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ParserAsmX86;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.dat3m.zombmc.utils.Result;
import com.dat3m.zombmc.utils.options.ZomBMCOptions;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Params;
import com.microsoft.z3.Solver;

public class ZomBMC {

    public static void main(String[] args) throws IOException {

        ZomBMCOptions options = new ZomBMCOptions();
        try {
            options.parse(args);
        }
        catch (Exception e){
        	System.out.println(e.getMessage());
            new HelpFormatter().printHelp("Zom-B-MC", options);
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
        
        if(options.print()) {
        	System.out.println(new Printer().print(p));
    		System.exit(1);
            return;
        }
        
        Context ctx = new Context();
        long t1 = System.currentTimeMillis();
        Result result = testMemorySafety(ctx, p, mcm, options);
        long t2 = System.currentTimeMillis();
        System.out.println(result);
        System.out.println("Solved in " + (new SimpleDateFormat("mm:ss:SS")).format(new Date(t2-t1)) + " (m:s:ms)");
		ctx.close();
    }

    public static Result testMemorySafety(Context ctx, Program program, Wmm wmm, ZomBMCOptions options) {
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

		if(!options.getAliasSpeculativeOption() && wmm.getRelationRepository().getRelation("srf").isUsed()) {
			for(Tuple t : wmm.getRelationRepository().getRelation("srf").getMaxTupleSet()) {
				MemEvent m1 = (MemEvent) t.getFirst();
				MemEvent m2 = (MemEvent) t.getSecond();
				BoolExpr sameAddress = ctx.mkEq(m1.getMemAddressExpr(), m2.getMemAddressExpr());
				solver.add(ctx.mkEq(Utils.alias(m1, m2, ctx), sameAddress));
			}
		}

        switch(solver.check()) {
        	case SATISFIABLE:
            	solver.add(program.encodeNoBoundEventExec(ctx));
    			return solver.check() == SATISFIABLE ? UNSAFE : Result.UNKNOWN;
        	case UNSATISFIABLE:
            	solver.pop();
    			solver.add(ctx.mkNot(program.encodeNoBoundEventExec(ctx)));
    			return solver.check() == SATISFIABLE ? Result.UNKNOWN : SAFE;
        	default:
        		return solver.getReasonUnknown().equals("canceled") ? TIMEOUT : Result.UNKNOWN;
        }
    }
}