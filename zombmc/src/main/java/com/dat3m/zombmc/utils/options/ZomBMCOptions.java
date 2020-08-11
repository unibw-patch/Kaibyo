package com.dat3m.zombmc.utils.options;

import java.util.Arrays;
import java.util.Set;

import org.apache.commons.cli.*;

import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.google.common.collect.ImmutableSet;

public class ZomBMCOptions extends BaseOptions {

    protected Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("bpl"));
    
    private boolean lfence = false;
    private boolean slh = false;
    
    public ZomBMCOptions(){
        super();
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
    	lfence = cmd.hasOption("lfence");
    	slh = cmd.hasOption("slh");
    }
    
    public boolean getLfenceOption(){
        return lfence;
    }

    public boolean getSLHOption(){
        return slh;
    }
}