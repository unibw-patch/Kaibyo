package com.dat3m.zombmc;

import com.dat3m.dartagnan.compiler.Mitigation;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.zombmc.utils.Result;
import com.dat3m.zombmc.utils.options.ZomBMCOptions;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.microsoft.z3.Context;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static com.dat3m.zombmc.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.zombmc.utils.Result.SAFE;
import static com.dat3m.zombmc.utils.Result.UNKNOWN;
import static com.dat3m.zombmc.utils.Result.UNSAFE;
import static com.dat3m.zombmc.utils.ResourceHelper.CAT_RESOURCE_PATH;
import static com.dat3m.dartagnan.compiler.Mitigation.NOBRANCHSPECULATION;
import static com.dat3m.zombmc.ZomBMC.testMemorySafety;
import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class ZombmcTest {

    private String path;
    private Wmm wmm;
    private ZomBMCOptions options;
    private Result expected;

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {        

        Settings s = new Settings(Mode.KNASTER, Alias.CFIS, 1, false);

        List<Object[]> data = new ArrayList<>();
        
        Wmm sc = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/sc.cat"));
        Wmm stl = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/stl.cat"));
        Wmm srf = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/srf.cat"));
        
        for(int i = 1; i <= 15; i++) {
        	for(int o = 0; o <= 2; o+=2) {
        		// Some benchmarks needs unroll 2
        		if ((i == 5 && o ==0) || (i == 9 && o == 2) || (i == 10) || (i == 11 && o == 0)) {
        			s = new Settings(Mode.KNASTER, Alias.CFIS, 2, false);
        		}

        		String secret = "secret";
        		boolean onlySpeculative = true;
        		
        		ZomBMCOptions noneO = new ZomBMCOptions(secret, onlySpeculative, new ArrayList<Mitigation>(), s);
        		ZomBMCOptions lfenceO = new ZomBMCOptions(secret, onlySpeculative, Collections.singletonList(Mitigation.LFENCE), s);
        		ZomBMCOptions slhO = new ZomBMCOptions(secret, onlySpeculative, Collections.singletonList(Mitigation.SLH), s);
        		
        		// v05 has an input dependent loop thus we cannot prove it correct
        		if(i != 5) {
            		data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/spectre-pht-v" + i + ".o" + o + ".bpl", sc, lfenceO, SAFE});
            		data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/spectre-pht-v" + i + ".o" + o + ".bpl", sc, slhO, SAFE});
        		} else {
            		data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/spectre-pht-v" + i + ".o" + o + ".bpl", sc, lfenceO, UNKNOWN});
            		data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/spectre-pht-v" + i + ".o" + o + ".bpl", sc, slhO, UNKNOWN});
        		}
        		// v08.02 is safe
        		if(i == 8 && o == 2) {
        			data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/spectre-pht-v" + i + ".o" + o + ".bpl", sc, noneO, SAFE});
        		} else {
            		data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/spectre-pht-v" + i + ".o" + o + ".bpl", sc, noneO, UNSAFE});        			
        		}
        	}
        }
        
        for(int i = 1; i <= 14; i++) {
        	s = new Settings(Mode.KNASTER, Alias.CFIS, 1, false);
    		String secret = "secretarray";
    		boolean onlySpeculative = false;
    		ArrayList<Mitigation> mitigations = new ArrayList<Mitigation>();
    		mitigations.add(NOBRANCHSPECULATION);
    		ZomBMCOptions options = new ZomBMCOptions(secret, onlySpeculative, mitigations, s);
    		    		
    		switch(i) {
    		case 1:
    		case 2:
    		case 4:
    		case 5:
    		case 6:
    		case 7:
    		case 8:
        		data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/spectre-stl-v" + i + ".bpl", sc, options, SAFE});
    			data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/spectre-stl-v" + i + ".bpl", stl, options, UNSAFE});
    			break;
    		case 3:
    		case 10:
    		case 11:
    		case 12:
    		case 13:
        		data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/spectre-stl-v" + i + ".bpl", sc, options, SAFE});
    			data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/spectre-stl-v" + i + ".bpl", stl, options, SAFE});
    			break;
    		case 9:
    			data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/spectre-stl-v" + i + ".bpl", sc, options, UNKNOWN});
    			data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/spectre-stl-v" + i + ".bpl", stl, options, UNKNOWN});
    			break;
    		case 14:
        		data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/spectre-stl-v" + i + ".bpl", sc, options, SAFE});
    			data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/spectre-stl-v" + i + ".bpl", srf, options, UNSAFE});
    			break;
    		}
        }
        
        return data;
    }
    
    public ZombmcTest(String path, Wmm wmm, ZomBMCOptions options, Result expected) {
        this.path = path;
        this.wmm = wmm;
        this.options = options;
        this.expected = expected;
    }

    @Test(timeout = 180000)
    public void litmus() {
        try {
            Program program = new ProgramParser().parse(new File(path));
            Context ctx = new Context();
            assertTrue(testMemorySafety(ctx, program, wmm, options).equals(expected));
            ctx.close();
        } catch (IOException e){
            fail("Missing resource file");
        }
    }
}