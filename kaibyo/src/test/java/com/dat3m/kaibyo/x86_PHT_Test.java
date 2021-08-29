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

import static com.dat3m.kaibyo.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.kaibyo.Kaibyo.testMemorySafety;
import static com.dat3m.kaibyo.utils.Result.SAFE;
import static com.dat3m.kaibyo.utils.Result.UNSAFE;
import static com.dat3m.kaibyo.utils.ResourceHelper.CAT_RESOURCE_PATH;
import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class x86_PHT_Test {

    private Program program;
    private Wmm wmm;
    private KaibyoOptions options;
    private Result expected;

	@Parameterized.Parameters(name = "{index}: {0} {2}")
    public static Iterable<Object[]> data() throws IOException {        
        List<Object[]> data = new ArrayList<>();

        Settings s1 = new Settings(Mode.KNASTER, Alias.NONE, 1, false);
        Settings s2 = new Settings(Mode.KNASTER, Alias.NONE, 2, false);
        Wmm sc = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/inorder.cat"));
		KaibyoOptions noneBoth = new KaibyoOptions("secretarray", false, new ArrayList<Mitigation>(), s1, -1);
		KaibyoOptions noneBoth2 = new KaibyoOptions("secretarray", false, new ArrayList<Mitigation>(), s2, -1);
		KaibyoOptions noneSpec = new KaibyoOptions("secretarray", true, new ArrayList<Mitigation>(), s1, -1);

        for(int i = 1; i <= 15; i++) {
        	Program program = new ParserAsmX86("victim_function_v" + i).parse(new File(TEST_RESOURCE_PATH + "spectre-pht.s"));
        	switch(i) {
        	case 5:
        		data.add(new Object[]{program, sc, noneBoth2, UNSAFE});
        		break;
        	default:
        		data.add(new Object[]{program, sc, noneBoth, UNSAFE});
        	}
        }

        for(int i = 1; i <= 15; i++) {
        	Program program = new ParserAsmX86("victim_function_v" + i).parse(new File(TEST_RESOURCE_PATH + "spectre-pht-lfence.s"));
        	switch(i) {
        	case 5:
        		// We cannot handle it because it has input dependent loop
        		break;
        	default:
        		data.add(new Object[]{program, sc, noneSpec, SAFE});
        	}
	
        }
        
        return data;
    }
    
    public x86_PHT_Test(Program program, Wmm wmm, KaibyoOptions options, Result expected) {
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