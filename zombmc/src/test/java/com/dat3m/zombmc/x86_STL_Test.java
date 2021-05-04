package com.dat3m.zombmc;

import com.dat3m.dartagnan.compiler.Mitigation;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ParserAsmX86;
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
import java.util.List;

import static com.dat3m.zombmc.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.zombmc.utils.Result.SAFE;
import static com.dat3m.zombmc.utils.Result.UNSAFE;
import static com.dat3m.zombmc.utils.ResourceHelper.CAT_RESOURCE_PATH;
import static com.dat3m.zombmc.ZomBMC.testMemorySafety;
import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class x86_STL_Test {

    private Program program;
    private Wmm wmm;
    private ZomBMCOptions options;
    private Result expected;

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {        
        List<Object[]> data = new ArrayList<>();

        Settings s = new Settings(Mode.KNASTER, Alias.CFIS, 1, false);
        Wmm stl = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/stl.cat"));
		ZomBMCOptions none = new ZomBMCOptions("secretarray", false, new ArrayList<Mitigation>(), s);
        
        for(int i = 1; i <= 13; i++) {
        	Program program = new ParserAsmX86("victim_function_v" + i).parse(new File(TEST_RESOURCE_PATH + "spectre-stl.s"));
        	switch(i) {
        	case 3:
        	case 12:
        	case 13:
        		data.add(new Object[]{program, stl, none, SAFE});
        		break;
        	case 9:
        		data.add(new Object[]{program, stl, none, Result.UNKNOWN});
        		break;
        	default:
        		data.add(new Object[]{program, stl, none, UNSAFE});
        	}
        }
        return data;
    }
    
    public x86_STL_Test(Program program, Wmm wmm, ZomBMCOptions options, Result expected) {
        this.program = program;
        this.wmm = wmm;
        this.options = options;
        this.expected = expected;
    }

    @Test(timeout = 60000)
    public void litmus() {
        Context ctx = new Context();
		assertEquals(expected, testMemorySafety(ctx, program, wmm, options));
		ctx.close();
    }
}