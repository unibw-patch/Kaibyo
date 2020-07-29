package com.dat3m.zombmc.utils.options;

import java.util.Arrays;
import java.util.Set;

import org.apache.commons.cli.*;

import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.google.common.collect.ImmutableSet;

public class ZomBMCOptions extends BaseOptions {

    protected Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("bpl"));
    
    private boolean lfence = false;
    
    public ZomBMCOptions(){
        super();
        Option lfenceOption = new Option("lfence", false,
                "Full Speculative Execution Mitigation");
        addOption(lfenceOption);
    }

	
    public void parse(String[] args) throws ParseException, RuntimeException {
    	super.parse(args);
        if(supportedFormats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }
    	CommandLine cmd = new DefaultParser().parse(this, args);
        lfence = cmd.hasOption("lfence");
    }
    
    public boolean getLfenceOption(){
        return lfence;
    }
}