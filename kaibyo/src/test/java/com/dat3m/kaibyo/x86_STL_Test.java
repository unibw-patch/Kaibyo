package com.dat3m.kaibyo;

import com.dat3m.dartagnan.compiler.Mitigation;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ParserAsmX86;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.dat3m.kaibyo.utils.Result;
import com.dat3m.kaibyo.utils.options.KaibyoOptions;
import com.microsoft.z3.Context;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static com.dat3m.kaibyo.Kaibyo.testMemorySafety;
import static com.dat3m.kaibyo.utils.ResourceHelper.CAT_RESOURCE_PATH;
import static com.dat3m.kaibyo.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.kaibyo.utils.Result.SAFE;
import static com.dat3m.kaibyo.utils.Result.UNSAFE;
import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class x86_STL_Test {

    private Program program;
    private Wmm wmm;
    private KaibyoOptions options;
    private Result expected;

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {        
        List<Object[]> data = new ArrayList<>();

        Settings s = new Settings(Mode.KNASTER, Alias.CFIS, 1, false);
        Settings s200 = new Settings(Mode.KNASTER, Alias.CFIS, 200, false);
        Wmm stl = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/stl.cat"));
		KaibyoOptions none = new KaibyoOptions("secretarray", false, new ArrayList<Mitigation>(), s, -1);
		KaibyoOptions none200 = new KaibyoOptions("secretarray", false, new ArrayList<Mitigation>(), s200, -1);
        
        for(int i = 1; i <= 13; i++) {
        	Program program = new ParserAsmX86("victim_function_v" + i).parse(new File(TEST_RESOURCE_PATH + "spectre-stl.s"));
        	switch(i) {
        	case 3:
        	case 12:
        		data.add(new Object[]{program, stl, none, SAFE});
        		break;
        	case 9:
        		data.add(new Object[]{program, stl, none200, SAFE});
        		break;
        	default:
        		data.add(new Object[]{program, stl, none, UNSAFE});
        	}
        }

        for(int i = 1; i <= 13; i++) {
        	Program program = new ParserAsmX86("victim_function_v" + i).parse(new File(TEST_RESOURCE_PATH + "spectre-stl-lfence.s"));
        	switch(i) {
        	case 9:
        		data.add(new Object[]{program, stl, none200, SAFE});
        		break;
        	default:
        		data.add(new Object[]{program, stl, none, SAFE});
        	}
        }
        return data;
    }
    
    public x86_STL_Test(Program program, Wmm wmm, KaibyoOptions options, Result expected) {
        this.program = program;
        this.wmm = wmm;
        this.options = options;
        this.expected = expected;
    }

    @Test
    public void dummy() {
		assert(true);
    }

//    @Test(timeout = 30000)
    public void litmus() {
        Context ctx = new Context();
		assertEquals(expected, testMemorySafety(ctx, program, wmm, options));
		ctx.close();
    }
}