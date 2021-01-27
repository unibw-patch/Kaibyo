package com.dat3m.zombmc;

import static com.dat3m.dartagnan.compiler.Mitigation.LFENCE;
import static com.dat3m.dartagnan.compiler.Mitigation.NOSPECULATION;
import static com.dat3m.dartagnan.compiler.Mitigation.SLH;
import static com.dat3m.zombmc.utils.Encodings.encodeLeakage;
import static com.dat3m.zombmc.utils.Result.SAFE;
import static com.dat3m.zombmc.utils.Result.UNKNOWN;
import static com.dat3m.zombmc.utils.Result.UNSAFE;
import static com.microsoft.z3.Status.SATISFIABLE;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.cli.HelpFormatter;

import com.dat3m.dartagnan.compiler.Arch;
import com.dat3m.dartagnan.compiler.Mitigation;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Settings;
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
        
        Wmm mcm = new ParserCat().parse(new File(System.getenv().get("DAT3M_HOME") + "/cat/sc.cat"));
		Program p = new ProgramParser().parse(new File(options.getProgramFilePath()));		
        Arch target = Arch.NONE;
        
        Context ctx = new Context();
        List<Mitigation> mitigations = new ArrayList<Mitigation>();
        if(options.getNoSpeculationOption()) {
            mitigations.add(NOSPECULATION);
        }
        if(options.getLfenceOption()) {
            mitigations.add(LFENCE);
        }
        if(options.getSLHOption()) {
            mitigations.add(SLH);
        }
        Result result = testMemorySafety(ctx, p, mcm, target, mitigations, options.getSpecLeakOption(), options.getSettings());
        System.out.println(result);
		ctx.close();
    }

    public static Result testMemorySafety(Context ctx, Program program, Wmm wmm, Arch target, List<Mitigation> mitigations, boolean onlySpecLeak, Settings settings) {
    	program.unroll(settings.getBound(), 0);
        program.compile(target, mitigations, 0);

        Solver solver = ctx.mkSolver();
        solver.add(program.encodeSCF(ctx, mitigations));
        solver.add(wmm.encode(program, ctx, settings));
        solver.add(wmm.consistent(program, ctx));
        solver.push();
        solver.add(encodeLeakage(program, ctx, "spectre_secret", onlySpecLeak));

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