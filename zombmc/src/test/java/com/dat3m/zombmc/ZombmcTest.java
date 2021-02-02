package com.dat3m.zombmc;

import com.dat3m.dartagnan.compiler.Arch;
import com.dat3m.dartagnan.compiler.Mitigation;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.zombmc.utils.Result;
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
import static com.dat3m.zombmc.utils.Result.UNSAFE;
import static com.dat3m.zombmc.utils.ResourceHelper.CAT_RESOURCE_PATH;
import static com.dat3m.zombmc.ZomBMC.testMemorySafety;
import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class ZombmcTest {

    private String path;
    private List<Mitigation> mitigations;
    private Settings settings;
    private Result expected;

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {        

        Settings s = new Settings(Mode.KNASTER, Alias.CFIS, 1, true);

        List<Object[]> data = new ArrayList<>();
        
        List<Mitigation> none = new ArrayList<Mitigation>();
        List<Mitigation> lfence = Collections.singletonList(Mitigation.LFENCE);
        List<Mitigation> slh = Collections.singletonList(Mitigation.SLH);

        for(int i = 1; i <= 15; i++) {
        	for(int o = 0; o <= 2; o+=2) {
        		if ((i == 5 && o ==0) || (i == 9 && o == 2) || (i == 10) || (i == 11 && o == 0)) {
        			s = new Settings(Mode.KNASTER, Alias.CFIS, 2, true);
        		}
        		data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/kocher/v0" + i + ".o" + o + ".bpl", lfence, SAFE, s});
        		data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/kocher/v0" + i + ".o" + o + ".bpl", slh, SAFE, s});        	
        		if(i == 8 && o == 2) {
        			continue;
        		}
        		data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/kocher/v0" + i + ".o" + o + ".bpl", none, UNSAFE, s});
        	}
        }
        return data;
    }
    
    public ZombmcTest(String path, List<Mitigation> mitigations, Result expected, Settings settings) {
        this.path = path;
        this.mitigations = mitigations;
        this.expected = expected;
        this.settings = settings;
    }

    @Test(timeout = 180000)
    public void test() {
        try {
        	Wmm wmm = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/sc.cat"));
            Program program = new ProgramParser().parse(new File(path));
            Context ctx = new Context();
            assertTrue(testMemorySafety(ctx, program, wmm, Arch.NONE, mitigations, true, settings).equals(expected));
            ctx.close();
        } catch (IOException e){
            fail("Missing resource file");
        }
    }
}