package com.dat3m.zombmc;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.zombmc.utils.Encodings.encodeSpectre;

import java.io.File;
import java.io.IOException;
import org.apache.commons.cli.HelpFormatter;

import com.dat3m.dartagnan.asserts.AbstractAssert;
import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Init;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.zombmc.utils.options.ZomBMCOptions;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;
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
		
        Arch target = p.getArch();
        if(target == null){
            target = options.getTarget();
        }
        if(target == null) {
            System.out.println("Compilation target cannot be inferred");
            System.exit(0);
            return;
        }
        
        Context ctx = new Context();
        Result result = testProgramSpeculatively(ctx, p, mcm, target, options.getSettings());
        System.out.println(result);
		ctx.close();
    }

    public static Result testProgramSpeculatively(Context ctx, Program program, Wmm wmm, Arch target, Settings settings) {
        Solver solver = ctx.mkSolver();

        Printer p = new Printer();
        System.out.println(p.print(program));
        
    	program.unroll(settings.getBound(), 0);
        program.compile(target, 0);

		solver.add(program.encodeSCF(ctx));
		solver.add(wmm.encode(program, ctx, settings));
		solver.add(wmm.consistent(program, ctx));
		solver.add(encodeSpectre(program, ctx));
		
		System.out.println("Solving");
		Result res = solver.check() == Status.SATISFIABLE ? FAIL : PASS;
		System.out.println(res);
		if(res == FAIL) {
			Model m = solver.getModel();
			
			for(Address a : program.getMemory().getAllAddresses()) {
				System.out.println(a);
				System.out.println(m.getConstInterp(a.toZ3Int(ctx)));
				System.out.println("===");
			}
			
			for(Event e : program.getCache().getEvents(FilterBasic.get(EType.READ))) {
				System.out.println(e.repr());
				System.out.println(m.getConstInterp(((Load)e).getMemAddressExpr()));
//				System.out.println(m.getConstInterp(((Load)e).getMemValueExpr()));
				System.out.println("===");
//				if(Integer.parseInt(m.getConstInterp(e.stepSE()).toString()) > -1) {
//					System.out.println(e.repr());
//					System.out.println(m.getConstInterp(e.stepSE()));
			}
		}		
		return res;
    }
}