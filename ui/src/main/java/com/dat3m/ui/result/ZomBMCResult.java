package com.dat3m.ui.result;


import static com.dat3m.zombmc.ZomBMC.testMemorySafety;

import java.util.ArrayList;

import com.dat3m.dartagnan.compiler.Arch;
import com.dat3m.dartagnan.compiler.Mitigation;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Graph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.ui.utils.UiOptions;
import com.dat3m.zombmc.utils.Result;
import com.dat3m.zombmc.utils.options.ZomBMCOptions;
import com.microsoft.z3.Context;

public class ZomBMCResult {

    private final Program program;
    private final Wmm wmm;
    private final UiOptions options;

    private Graph graph;
    private String verdict;

    public ZomBMCResult(Program program, Wmm wmm, UiOptions options){
        this.program = program;
        this.wmm = wmm;
        this.options = options;
        run();
    }
    
    public Graph getGraph(){
        return graph;
    }

    public String getVerdict(){
        return verdict;
    }

    private void run(){
    	program.setArch(Arch.NONE);
     	Context ctx = new Context();
     	ArrayList<Mitigation> mitigations = new ArrayList<>();
		ZomBMCOptions zombmcO = new ZomBMCOptions(options.getSecret(), true, mitigations, options.getSettings());
     	Result result = testMemorySafety(ctx, program, wmm, zombmcO);
        StringBuilder sb = new StringBuilder();
        sb.append(result).append("\n");
        verdict = sb.toString();
    }
}
