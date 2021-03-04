package com.dat3m.zombmc.utils.options;

import static com.dat3m.dartagnan.compiler.Mitigation.LFENCE;
import static com.dat3m.dartagnan.compiler.Mitigation.NOSPECULATION;
import static com.dat3m.dartagnan.compiler.Mitigation.SLH;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;

import org.apache.commons.cli.*;

import com.dat3m.dartagnan.compiler.Mitigation;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.google.common.collect.ImmutableSet;

public class ZomBMCOptions extends BaseOptions {

    protected Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("bpl"));
    
    private String secret = "spectre_secret";
    private boolean noSpeculation = true;
    private boolean lfence = false;
    private boolean slh = false;
    private boolean sleak = false;
    private boolean alias = false;
    
    public ZomBMCOptions(){
        super();
        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        Option secretOption = new Option("secret", true,
                "Name of the secret variable (default: spectre_secret)");
        addOption(secretOption);

        Option noSpecOption = new Option("nospeculation", false,
                "Disable speculative execution");
        addOption(noSpecOption);

        Option aliasOption = new Option("alias_speculation", false,
                "Allow alias speculation");
        addOption(aliasOption);

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

    public ZomBMCOptions(String secret, boolean sleak, boolean alias, List<Mitigation> mitigations, Settings settings){
        this.secret = secret;
        this.sleak = sleak;
        this.alias = alias;
        this.lfence = mitigations.contains(LFENCE);
        this.slh = mitigations.contains(SLH);
        this.noSpeculation = mitigations.contains(NOSPECULATION);
        this.settings = settings;
    }
	
    public void parse(String[] args) throws ParseException, RuntimeException {
    	super.parse(args);
        if(supportedFormats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }
    	CommandLine cmd = new DefaultParser().parse(this, args);
    	secret = cmd.getOptionValue("secret");
    	noSpeculation = cmd.hasOption("nospeculation");
    	lfence = cmd.hasOption("lfence");
    	slh = cmd.hasOption("slh");
    	sleak = cmd.hasOption("sleak");
    	alias = cmd.hasOption("alias_speculation");
    }
    
    public String getSecretOption(){
        return secret;
    }

    public boolean getNoSpeculationOption(){
        return noSpeculation;
    }

    public boolean getSpecLeakOption(){
        return sleak;
    }

    public boolean getAliasOption(){
        return alias;
    }

    public boolean getLfenceOption(){
        return lfence;
    }

    public boolean getSLHOption(){
        return slh;
    }
    
    public List<Mitigation> getMitigations() {
        List<Mitigation> mitigations = new ArrayList<Mitigation>();
        if(noSpeculation) {
            mitigations.add(NOSPECULATION);
        }
        if(lfence) {
            mitigations.add(LFENCE);
        }
        if(slh) {
            mitigations.add(SLH);
        }
        return mitigations;
    }
}