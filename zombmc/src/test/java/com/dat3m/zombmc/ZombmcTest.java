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
import static com.dat3m.zombmc.ZomBMC.testMemorySafety;
import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class ZombmcTest {

    private String path;
    private ZomBMCOptions options;
    private Result expected;

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {        

        Settings s = new Settings(Mode.KNASTER, Alias.CFIS, 1, true);

        List<Object[]> data = new ArrayList<>();
        
        for(int i = 1; i <= 15; i++) {
        	for(int o = 0; o <= 2; o+=2) {
        		// Some benchmarks needs unroll 2
        		if ((i == 5 && o ==0) || (i == 9 && o == 2) || (i == 10) || (i == 11 && o == 0)) {
        			s = new Settings(Mode.KNASTER, Alias.CFIS, 2, true);
        		}

        		String secret = "secret";
        		boolean onlySpeculative = true;
        		boolean alias = false;
        		
        		ZomBMCOptions noneO = new ZomBMCOptions(secret, onlySpeculative, alias, new ArrayList<Mitigation>(), s);
        		ZomBMCOptions lfenceO = new ZomBMCOptions(secret, onlySpeculative, alias, Collections.singletonList(Mitigation.LFENCE), s);
        		ZomBMCOptions slhO = new ZomBMCOptions(secret, onlySpeculative, alias, Collections.singletonList(Mitigation.SLH), s);
        		
        		// v05 has an input dependent loop thus we cannot prove it correct
        		if(i != 5) {
            		data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/kocher/v" + i + ".o" + o + ".bpl", lfenceO, SAFE});
            		data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/kocher/v" + i + ".o" + o + ".bpl", slhO, SAFE});
        		} else {
            		data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/kocher/v" + i + ".o" + o + ".bpl", lfenceO, UNKNOWN});
            		data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/kocher/v" + i + ".o" + o + ".bpl", slhO, UNKNOWN});
        		}
        		// v08.02 is safe
        		if(i == 8 && o == 2) {
        			data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/kocher/v" + i + ".o" + o + ".bpl", noneO, SAFE});
        		} else {
            		data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/kocher/v" + i + ".o" + o + ".bpl", noneO, UNSAFE});        			
        		}
        	}
        }
        return data;
    }
    
    public ZombmcTest(String path, ZomBMCOptions options, Result expected) {
        this.path = path;
        this.options = options;
        this.expected = expected;
    }

    @Test(timeout = 180000)
    public void Spectre_v1() {
        try {
        	Wmm wmm = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/sc.cat"));
            Program program = new ProgramParser().parse(new File(path));
            Context ctx = new Context();
            assertTrue(testMemorySafety(ctx, program, wmm, options).equals(expected));
            ctx.close();
        } catch (IOException e){
            fail("Missing resource file");
        }
    }
}