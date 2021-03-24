package com.dat3m.zombmc;

import static com.dat3m.zombmc.utils.Encodings.encodeLeakage;
import static com.dat3m.zombmc.utils.Result.UNKNOWN;
import static com.dat3m.zombmc.utils.Result.UNSAFE;
import static com.dat3m.zombmc.utils.Result.SAFE;
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
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.zombmc.utils.Result;
import com.dat3m.zombmc.utils.options.ZomBMCOptions;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;
import com.microsoft.z3.Params;
import com.microsoft.z3.Solver;
import com.microsoft.z3.Status;

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
    	if(options.getOnlySpeculativeOption() && !options.getbranchSpeculativeOption()) {
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
    	System.out.println(new Printer().print(program));

        Solver solver = ctx.mkSolver();
        Params p = ctx.mkParams();
		p.add("timeout", 10000);
		solver.setParameters(p);

		solver.add(program.encodeSCF(ctx, options.getMitigations()));
        solver.add(wmm.encode(program, ctx, options.getSettings()));
        solver.add(wmm.consistent(program, ctx));
//        solver.add(encodeLeakage(program, wmm, options, ctx));

//        if(solver.check() == SATISFIABLE) {
//        	Model m = solver.getModel();
//        	for(Event e : program.getCache().getEvents(FilterBasic.get(EType.REG_WRITER))) {
//        		RegWriter w = (RegWriter)e;
//        		if(m.getConstInterp(e.exec()).isTrue()) {
//        			System.out.println(e);
//        			System.out.println(m.getConstInterp(w.getResultRegisterExpr()));
//        			System.out.println("=====");
//        		}
//        	}
//        	for(Address a : program.getMemory().getAllAddresses()) {
//        		if(program.getMemory().getLocationForAddress(a) != null) {
//            		System.out.println("Address " + a + " contains location " + program.getMemory().getLocationForAddress(a));        			
//        		}
//        		System.out.println("Address " + a + " is in " + m.getConstInterp(a.toZ3Int(ctx)));	
//        	}
//        	System.out.println("Secret address " + m.getConstInterp(program.getMemory().getLocation("secret").getAddress().toZ3Int(ctx)));
//        }
        switch(solver.check()) {
        	case SATISFIABLE: 
        		return UNSAFE;
        	case UNSATISFIABLE: 
        		return SAFE;
        	default:
        		return UNKNOWN;	
        }

//		if(solver.check() == SATISFIABLE) {
//        	solver.add(program.encodeNoBoundEventExec(ctx));
//			return solver.check() == SATISFIABLE ? UNSAFE : UNKNOWN;
//        } else {
//        	solver.pop();
//			solver.add(ctx.mkNot(program.encodeNoBoundEventExec(ctx)));
//        	return solver.check() == SATISFIABLE ? UNKNOWN : SAFE;
//        }
    }
}