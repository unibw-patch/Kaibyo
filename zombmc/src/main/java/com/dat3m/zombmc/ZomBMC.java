package com.dat3m.zombmc;

import static com.dat3m.dartagnan.compiler.Mitigation.LFENCE;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.zombmc.utils.Encodings.encodeSpectre;

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
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.zombmc.utils.options.ZomBMCOptions;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import com.microsoft.z3.Status;

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

        Wmm mcm = new ParserCat().parse(new File("./cat/sc.cat"));
		Program p = new ProgramParser().parse(new File(options.getProgramFilePath()));		
        Arch target = Arch.NONE;
        
        Context ctx = new Context();
        List<Mitigation> mitigations = new ArrayList<Mitigation>();
        if(options.getLfenceOption()) {
            mitigations.add(LFENCE);        	
        }
        Result result = testProgramSpeculatively(ctx, p, mcm, target, mitigations, options.getSettings());
        System.out.println(result);
		ctx.close();
    }

    public static Result testProgramSpeculatively(Context ctx, Program program, Wmm wmm, Arch target, List<Mitigation> mitigations, Settings settings) {

        program.unroll(settings.getBound(), 0);
    	program.compile(target, mitigations, 0);
        
        Solver solver = ctx.mkSolver();
        solver.add(program.encodeSCF(ctx));
        solver.add(wmm.encode(program, ctx, settings));
        solver.add(wmm.consistent(program, ctx));
        solver.add(encodeSpectre(program, ctx));
		
		return solver.check() == Status.SATISFIABLE ? FAIL : PASS;
    }
}