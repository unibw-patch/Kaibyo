package com.dat3m.zombmc;

import static com.dat3m.dartagnan.compiler.Mitigation.LFENCE;
import static com.dat3m.dartagnan.compiler.Mitigation.SLH;
import static com.dat3m.zombmc.utils.Encodings.encodeSpectre;
import static com.dat3m.zombmc.utils.Result.SAFE;
import static com.dat3m.zombmc.utils.Result.UNSAFE;
import static com.microsoft.z3.Status.SATISFIABLE;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.cli.HelpFormatter;

import com.dat3m.dartagnan.compiler.Arch;
import com.dat3m.dartagnan.compiler.Mitigation;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.zombmc.utils.Result;
import com.dat3m.zombmc.utils.options.ZomBMCOptions;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;
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
        if(options.getLfenceOption()) {
            mitigations.add(LFENCE);        	
        }
        if(options.getSLHOption()) {
            mitigations.add(SLH);        	
        }
        Result result = testProgramSpeculatively(ctx, p, mcm, target, mitigations, options.getSettings());
        System.out.println(result);
		ctx.close();
    }

    public static Result testProgramSpeculatively(Context ctx, Program program, Wmm wmm, Arch target, List<Mitigation> mitigations, Settings settings) {
        program.unroll(settings.getBound(), 0);
    	program.compile(target, mitigations, 0);
    	
    	Printer p = new Printer();
    	System.out.println(p.print(program));
    	
        Solver solver = ctx.mkSolver();
        solver.add(program.encodeSCF(ctx));
        solver.add(wmm.encode(program, ctx, settings));
        solver.add(wmm.consistent(program, ctx));
        solver.add(encodeSpectre(program, ctx, "spectre_secret"));
		solver.check();
		Model m = solver.getModel();
		for(Event e : program.getCache().getEvents(FilterBasic.get(EType.LOCAL))) {
			if(m.getConstInterp(e.cf()).isTrue() && ((Local)e).getExpr() instanceof INonDet) {
				System.out.println(e);
				System.out.println(m.getConstInterp(((Local)e).getResultRegisterExpr()));
				System.out.println();
			}
		}
		for(Event e : program.getCache().getEvents(FilterBasic.get(EType.LOCAL))) {
			if(m.getConstInterp(e.cf()).isTrue()) {
				if(((Local)e).getResultRegister().getName().contains("4:$i0") || ((Local)e).getResultRegister().getName().contains("$p4")) {
					System.out.println(e);
					System.out.println(m.getConstInterp(((Local)e).getResultRegisterExpr()));
					System.out.println();
				}
			}
		}
		for(Address a : program.getMemory().getAllAddresses()) {
			if(a.getValue() == 1 || a.getValue() == 17) {
				System.out.println(a);
				System.out.println(m.getConstInterp(a.toZ3Int(ctx)));
				System.out.println();				
			}
		}
		return solver.check() == SATISFIABLE ? UNSAFE : SAFE;
    }
}