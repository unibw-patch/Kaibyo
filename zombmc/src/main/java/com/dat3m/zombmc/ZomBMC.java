package com.dat3m.zombmc;

import static com.dat3m.zombmc.utils.Encodings.encodeLeakage;
import static com.dat3m.zombmc.utils.Result.SAFE;
import static com.dat3m.zombmc.utils.Result.UNKNOWN;
import static com.dat3m.zombmc.utils.Result.UNSAFE;
import static com.microsoft.z3.Status.SATISFIABLE;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.apache.commons.cli.HelpFormatter;

import com.dat3m.dartagnan.compiler.Arch;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.zombmc.utils.Result;
import com.dat3m.zombmc.utils.options.ZomBMCOptions;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

public class ZomBMC {

    public static void main(String[] args) throws IOException {

        ZomBMCOptions options = new ZomBMCOptions();
        try {
            options.parse(args);
        }
        catch (Exception e){
            if(e instanceof UnsupportedOperationException){
                System.out.println(e.getMessage());
            }
            new HelpFormatter().printHelp("Zom-B-MC", options);
            System.exit(1);
            return;
        }

        if(System.getenv().get("DAT3M_HOME") == null) {
        	throw new RuntimeException("DAT3M_HOME variable is not set");
        }
        
        Wmm mcm = new ParserCat().parse(new File(options.getTargetModelFilePath()));
		Program p = new ProgramParser().parse(new File(options.getProgramFilePath()));		
        
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
        solver.add(program.encodeSCF(ctx, options.getMitigations()));
        solver.add(wmm.encode(program, ctx, options.getSettings()));
        solver.add(wmm.consistent(program, ctx));
        solver.push();
        solver.add(encodeLeakage(program, wmm, options, ctx));

		if(solver.check() == SATISFIABLE) {
        	solver.add(program.encodeNoBoundEventExec(ctx));
			return solver.check() == SATISFIABLE ? UNSAFE : UNKNOWN;
        } else {
        	solver.pop();
			solver.add(ctx.mkNot(program.encodeNoBoundEventExec(ctx)));
        	return solver.check() == SATISFIABLE ? UNKNOWN : SAFE;
        }
    }
}