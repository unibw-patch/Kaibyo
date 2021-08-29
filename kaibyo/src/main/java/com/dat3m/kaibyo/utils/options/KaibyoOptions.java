package com.dat3m.kaibyo.utils.options;

import static com.dat3m.dartagnan.compiler.Mitigation.NOBRANCHSPECULATION;
import static com.dat3m.dartagnan.wmm.utils.Mode.KNASTER;
import static com.dat3m.dartagnan.wmm.utils.alias.Alias.NONE;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;

import org.apache.commons.cli.*;

import com.dat3m.dartagnan.compiler.Mitigation;
import com.dat3m.dartagnan.utils.Settings;
import com.google.common.collect.ImmutableSet;

public class KaibyoOptions extends Options {

	public static String ENTRYSTRING = "entry";
	public static String SECRETSTRING = "secret";
	public static String SECRETEVENTSTRING = "read_from";
	public static String BRANCHSPECULATIONSTRING = "branch_speculation";
	public static String ONLYSPECULATIVESTRING = "branch_speculation_error";
	public static String ALIASSPECULATIONSTRING = "alias_speculation";
	public static String TIMEOUT = "timeout";
	
    protected Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("bpl", "s"));
    
    protected String programFilePath;
    protected String targetModelFilePath;
    protected Settings settings;

    private String secret = "secret";
    private int read_from = -1;
    private boolean branchSpeculation;
    private boolean onlySpeculative;
    private boolean aliasSpeculation;
    private String entry = "main";
    private int timoeut = -1;
    
    public KaibyoOptions(){
        super();
        Option inputOption = new Option("input", true,
                "Path to the file with input program");
        inputOption.setRequired(true);
        addOption(inputOption);

        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        addOption(new Option("unroll", true,
                "Unrolling bound <integer>"));

        Option entryOption = new Option(ENTRYSTRING, true,
                "Name of the entry procedure (default: " + entry + ")");
        addOption(entryOption);

        Option secretOption = new Option(SECRETSTRING, true,
                "Secret variable (default: " + secret + ")");
        addOption(secretOption);

        Option secretEventOption = new Option(SECRETEVENTSTRING, true,
                "ID of the secret event to read from");
        addOption(secretEventOption);

        Option noSpecOption = new Option(BRANCHSPECULATIONSTRING, false,
                "Allow branch speculation");
        addOption(noSpecOption);

        Option aliasOption = new Option(ALIASSPECULATIONSTRING, false,
                "Allow alias speculation");
        addOption(aliasOption);

        Option onlySpeculativeOption = new Option(ONLYSPECULATIVESTRING, false,
                "Check for isolation violations only due to branch misprediction (requires option " + BRANCHSPECULATIONSTRING + ")");
        addOption(onlySpeculativeOption);
    }

    public KaibyoOptions(String secret, boolean onlySpeculative, List<Mitigation> mitigations, Settings settings, int timeout){
        this.secret = secret;
        this.branchSpeculation = !mitigations.contains(NOBRANCHSPECULATION);
        this.onlySpeculative = onlySpeculative;
        this.settings = settings;
        this.timoeut= timeout;
        this.aliasSpeculation = false;
    }
	
    public KaibyoOptions(String secret, boolean onlySpeculative, boolean aliasSpeculation, List<Mitigation> mitigations, Settings settings, int timeout){
    	this(secret, onlySpeculative, mitigations, settings, timeout);
    	this.aliasSpeculation = aliasSpeculation; 
    }
    
    public KaibyoOptions(int read_from, boolean onlySpeculative, List<Mitigation> mitigations, Settings settings, int timeout){
        this.read_from = read_from;
        this.branchSpeculation = !mitigations.contains(NOBRANCHSPECULATION);
        this.onlySpeculative = onlySpeculative;
        this.settings = settings;
        this.timoeut= timeout;
        this.aliasSpeculation = false;
    }
	
    public void parse(String[] args) throws ParseException, RuntimeException {
    	CommandLine cmd = new DefaultParser().parse(this, args);
        programFilePath = cmd.getOptionValue("input");
        targetModelFilePath = cmd.getOptionValue("cat");

        if(supportedFormats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }
    	
        int bound = 1;
        if(cmd.hasOption("unroll")){
            try {
                bound = Math.max(1, Integer.parseInt(cmd.getOptionValue("unroll")));
            } catch (NumberFormatException e){
                throw new UnsupportedOperationException("Illegal unroll value");
            }
        }
        settings = new Settings(KNASTER, NONE, bound);
        
    	if(cmd.hasOption(ENTRYSTRING)) {    		
        	entry = cmd.getOptionValue(ENTRYSTRING);
    	}
    	if(cmd.hasOption(SECRETSTRING)) {    		
    		secret = cmd.getOptionValue(SECRETSTRING);
    	}
    	if(cmd.hasOption(SECRETEVENTSTRING)) {
        	read_from = Integer.parseInt(cmd.getOptionValue(SECRETEVENTSTRING));    		
    	}
    	branchSpeculation = cmd.hasOption(BRANCHSPECULATIONSTRING);
    	onlySpeculative = cmd.hasOption(ONLYSPECULATIVESTRING);
    	aliasSpeculation = cmd.hasOption(ALIASSPECULATIONSTRING);
    }
    
    public String getProgramFilePath() {
        return programFilePath;
    }

    public String getTargetModelFilePath(){
        return targetModelFilePath;
    }

    public Settings getSettings(){
        return settings;
    }

    public String getEntry(){
        return entry;
    }

    public String getSecretOption(){
        return secret;
    }

    public int getReadFrom(){
        return read_from;
    }

    public boolean getBranchSpeculativeOption(){
        return branchSpeculation;
    }

    public boolean getAliasSpeculativeOption(){
        return aliasSpeculation;
    }

    public boolean getOnlySpeculativeOption(){
        return onlySpeculative;
    }

    public int getTimeout(){
        return timoeut;
    }
    
    public List<Mitigation> getMitigations() {
        List<Mitigation> mitigations = new ArrayList<Mitigation>();
        if(!branchSpeculation) {
            mitigations.add(NOBRANCHSPECULATION);
        }
        return mitigations;
    }
    
    @Override
    public String toString() {
		return 
				"bound: " + getSettings().getBound() + ", " +
				SECRETSTRING + ": " + secret + ", " + 
				ONLYSPECULATIVESTRING + ": " + onlySpeculative + 
				", mitigations: " + getMitigations() + ", " +
				ALIASSPECULATIONSTRING + ": " + aliasSpeculation + ", " +
				TIMEOUT + ": " + timoeut;
    }
}