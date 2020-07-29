package com.dat3m.zombmc.utils;

import java.util.List;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.EncodingConf;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.FuncDecl;
import com.microsoft.z3.Sort;
import com.microsoft.z3.Symbol;

public class Encodings {
	
	public static String SEC_LEVEL_FUN = "secLevel";
	
	public static FuncDecl secLevel(Context ctx) {
		return ctx.mkFuncDecl(SEC_LEVEL_FUN, ctx.mkIntSort(), ctx.mkBoolSort());	
	}

    public static BoolExpr encodeSpectre(Program p, EncodingConf conf) {
    	
    	Context ctx = conf.getCtx();
    	
    	List<Address> addresses = p.getMemory().getAllAddresses().asList();
    	int size = addresses.size();
    	
    	Sort[] types = new Sort[size];
        Symbol[] names = new Symbol[size];
        Expr[] xs = new Expr[size];
        BoolExpr body = ctx.mkTrue();
        BoolExpr safe = ctx.mkTrue();
        
		for (int j = 0; j < size ; j++) {
            types[j] = ctx.getIntSort();
            names[j] = ctx.mkSymbol("memory_" + addresses.get(j).hashCode());
            xs[j] = addresses.get(j).toZ3Int(conf);
            body = ctx.mkAnd(body, ctx.mkImplies(ctx.mkNot(ctx.mkEq(ctx.mkIntConst("i"), xs[j])), ctx.mkNot((BoolExpr) ctx.mkApp(secLevel(ctx), ctx.mkIntConst("i")))));
            safe = ctx.mkAnd(safe, (BoolExpr)ctx.mkApp(secLevel(ctx), xs[j]));
        }

		BoolExpr forall = ctx.mkForall(new Sort[]{ctx.mkIntSort()}, new Symbol[]{ctx.mkSymbol("i")}, body, 1, null, null, null, null);
    	
    	BoolExpr gadget = ctx.mkFalse();
    	for(Event r : p.getCache().getEvents(FilterBasic.get(EType.READ))){
    		BoolExpr unSafe = ctx.mkNot((BoolExpr)ctx.mkApp(secLevel(ctx), ((Load)r).getMemAddressExpr()));
			gadget = ctx.mkOr(gadget, ctx.mkAnd(unSafe, r.exec()));
    	}
    	System.out.println(ctx.mkAnd(safe, forall, gadget));
        return ctx.mkAnd(safe, forall, gadget);  	
    }    
}