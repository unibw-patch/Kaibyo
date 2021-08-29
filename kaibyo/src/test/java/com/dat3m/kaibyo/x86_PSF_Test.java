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
import java.util.Collections;
import java.util.List;

import static com.dat3m.kaibyo.Kaibyo.testMemorySafety;
import static com.dat3m.kaibyo.utils.ResourceHelper.CAT_RESOURCE_PATH;
import static com.dat3m.kaibyo.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.kaibyo.utils.Result.SAFE;
import static com.dat3m.kaibyo.utils.Result.UNSAFE;
import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class x86_PSF_Test {

    private Program program;
    private Wmm wmm;
    private KaibyoOptions options;
    private Result expected;

	@Parameterized.Parameters(name = "{index}: {0} options={2}")
    public static Iterable<Object[]> data() throws IOException {        
        List<Object[]> data = new ArrayList<>();

        Settings s = new Settings(Mode.KNASTER, Alias.CFIS, 1, false);
        Wmm srf = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/psf.cat"));
		
        KaibyoOptions branch_noalias = new KaibyoOptions("secretarray", false, false, new ArrayList<Mitigation>(), s, -1);
        KaibyoOptions branch_alias = new KaibyoOptions("secretarray", false, true, new ArrayList<Mitigation>(), s, -1);
        KaibyoOptions nobranch_noalias = new KaibyoOptions("secretarray", false, false, Collections.singletonList(Mitigation.NOBRANCHSPECULATION), s, -1);
        KaibyoOptions nobranch_alias = new KaibyoOptions("secretarray", false, true, Collections.singletonList(Mitigation.NOBRANCHSPECULATION), s, -1);
        
        Program p1;
        Program p2;
        Program p3;

        // None speculation
        p1 = new ParserAsmX86("victim_function_v1").parse(new File(TEST_RESOURCE_PATH + "spectre-psf.s"));
        data.add(new Object[]{p1, srf, nobranch_noalias, SAFE});
        p2 = new ParserAsmX86("victim_function_v1").parse(new File(TEST_RESOURCE_PATH + "spectre-psf-lfence-pht.s"));
        data.add(new Object[]{p2, srf, nobranch_noalias, SAFE});
        p3 = new ParserAsmX86("victim_function_v1").parse(new File(TEST_RESOURCE_PATH + "spectre-psf-lfence-both.s"));
        data.add(new Object[]{p3, srf, nobranch_noalias, SAFE});
        
        // CF speculation
        p1 = new ParserAsmX86("victim_function_v1").parse(new File(TEST_RESOURCE_PATH + "spectre-psf.s"));
        data.add(new Object[]{p1, srf, branch_noalias, UNSAFE});
        p2 = new ParserAsmX86("victim_function_v1").parse(new File(TEST_RESOURCE_PATH + "spectre-psf-lfence-pht.s"));
        data.add(new Object[]{p2, srf, branch_noalias, SAFE});
        p3 = new ParserAsmX86("victim_function_v1").parse(new File(TEST_RESOURCE_PATH + "spectre-psf-lfence-both.s"));
        data.add(new Object[]{p3, srf, branch_noalias, SAFE});
        
        // Alias speculation
        p1 = new ParserAsmX86("victim_function_v1").parse(new File(TEST_RESOURCE_PATH + "spectre-psf.s"));
        data.add(new Object[]{p1, srf, nobranch_alias, UNSAFE});
        p2 = new ParserAsmX86("victim_function_v1").parse(new File(TEST_RESOURCE_PATH + "spectre-psf-lfence-pht.s"));
        data.add(new Object[]{p2, srf, nobranch_alias, UNSAFE});
        p3 = new ParserAsmX86("victim_function_v1").parse(new File(TEST_RESOURCE_PATH + "spectre-psf-lfence-both.s"));
        data.add(new Object[]{p3, srf, nobranch_alias, SAFE});

        // Both speculations
        p1 = new ParserAsmX86("victim_function_v1").parse(new File(TEST_RESOURCE_PATH + "spectre-psf.s"));
        data.add(new Object[]{p1, srf, branch_alias, UNSAFE});
        p2 = new ParserAsmX86("victim_function_v1").parse(new File(TEST_RESOURCE_PATH + "spectre-psf-lfence-pht.s"));
        data.add(new Object[]{p2, srf, branch_alias, UNSAFE});
        p3 = new ParserAsmX86("victim_function_v1").parse(new File(TEST_RESOURCE_PATH + "spectre-psf-lfence-both.s"));
        data.add(new Object[]{p3, srf, branch_alias, SAFE});

        return data;
    }
    
    public x86_PSF_Test(Program program, Wmm wmm, KaibyoOptions options, Result expected) {
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