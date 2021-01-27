package com.dat3m.zombmc.utils.options;

import java.util.Arrays;
import java.util.Set;

import org.apache.commons.cli.*;

import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.google.common.collect.ImmutableSet;

public class ZomBMCOptions extends BaseOptions {

    protected Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("bpl"));
    
    private boolean noSpeculation = true;
    private boolean lfence = false;
    private boolean slh = false;
    private boolean sleak = false;
    
    public ZomBMCOptions(){
        super();
        Option noSpecOption = new Option("nospeculation", false,
                "Disable speculative execution");
        addOption(noSpecOption);

        Option onlySpecLeackOption = new Option("sleak", false,
                "Detect only speculative leaks");
        addOption(onlySpecLeackOption);

        Option lfenceOption = new Option("lfence", false,
                "Fence after every branch mitigation");
        addOption(lfenceOption);

        Option slhOption = new Option("slh", false,
                "Speculative Load Hardening mitigation");
        addOption(slhOption);
    }

	
    public void parse(String[] args) throws ParseException, RuntimeException {
    	super.parse(args);
        if(supportedFormats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }
    	CommandLine cmd = new DefaultParser().parse(this, args);
    	noSpeculation = cmd.hasOption("nospeculation");
    	lfence = cmd.hasOption("lfence");
    	slh = cmd.hasOption("slh");
    	sleak = cmd.hasOption("sleak");
    }
    
    public boolean getNoSpeculationOption(){
        return noSpeculation;
    }

    public boolean getSpecLeakOption(){
        return sleak;
    }

    public boolean getLfenceOption(){
        return lfence;
    }

    public boolean getSLHOption(){
        return slh;
    }
}