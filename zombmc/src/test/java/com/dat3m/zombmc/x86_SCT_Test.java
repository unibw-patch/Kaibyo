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
public class x86_SCT_Test {

    private Program program;
    private Wmm wmm;
    private ZomBMCOptions options;
    private Result expected;

	@Parameterized.Parameters(name = "{index}: {0} options={2}")
    public static Iterable<Object[]> data() throws IOException {        
        List<Object[]> data = new ArrayList<>();

        Settings s = new Settings(Mode.KNASTER, Alias.CFIS, 1, false);
        Wmm sc = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/sc.cat"));
        Wmm srf = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/srf.cat"));
		
        ZomBMCOptions noAliasSpec = new ZomBMCOptions("secretarray", false, false, new ArrayList<Mitigation>(), s, -1);
        ZomBMCOptions aliasSpec = new ZomBMCOptions("secretarray", false, true, new ArrayList<Mitigation>(), s, -1);
        
        // Unsafe under SC if CF speculation is enabled
        Program p1 = new ParserAsmX86("victim_function_v1").parse(new File(TEST_RESOURCE_PATH + "spectre-sct.s"));
        data.add(new Object[]{p1, sc, noAliasSpec, UNSAFE});

        // Safe under SC if CF speculation is stopped
        Program p2 = new ParserAsmX86("victim_function_v1").parse(new File(TEST_RESOURCE_PATH + "spectre-sct-pht-lfence.s"));
        data.add(new Object[]{p2, sc, noAliasSpec, SAFE});

        // Unsafe under SRF even if CF speculation is stopped
        Program p3 = new ParserAsmX86("victim_function_v1").parse(new File(TEST_RESOURCE_PATH + "spectre-sct-pht-lfence.s"));
        data.add(new Object[]{p3, srf, aliasSpec, UNSAFE});

        // Safe under SRF if both speculations are stopped
        Program p4 = new ParserAsmX86("victim_function_v1").parse(new File(TEST_RESOURCE_PATH + "spectre-sct-lfences.s"));
        data.add(new Object[]{p4, srf, aliasSpec, SAFE});

        return data;
    }
    
    public x86_SCT_Test(Program program, Wmm wmm, ZomBMCOptions options, Result expected) {
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