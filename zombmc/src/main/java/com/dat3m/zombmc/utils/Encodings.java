package com.dat3m.zombmc.utils;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Init;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.dat3m.zombmc.utils.options.ZomBMCOptions;
import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;

public class Encodings {
	
    public static BoolExpr encodeLeakage(Program p, Wmm wmm, ZomBMCOptions options, Context ctx) {    	
    	BoolExpr enc = ctx.mkFalse();
    	for(Event r : p.getCache().getEvents(FilterBasic.get(EType.READ))){
    		for(Init w : getSecretInit(p, options.getSecretOption())) {
    			if(!wmm.getRelationRepository().getRelation("rf").getMaxTupleSet().contains(new Tuple(w,r))) {
    				continue;
    			}
    			BoolExpr exec = options.getOnlySpeculativeOption() ? r.se() : r.exec();
    			enc = ctx.mkOr(enc, ctx.mkAnd(exec, Utils.edge("rf", w, r, ctx)));
    		}
    	}
    	if(enc.isFalse()) {
    		throw new RuntimeException("The program does not contain secrets");
    	}
    	return enc;
    }

    public static BoolExpr encodeAlias(Program p, ZomBMCOptions options, Context ctx) {    	
    	BoolExpr enc = ctx.mkTrue();
    	if(!options.getAliasOption()) {
        	for(Event e1 : p.getCache().getEvents(FilterBasic.get(EType.READ))){
        		for(Event e2 : p.getCache().getEvents(FilterBasic.get(EType.WRITE))){
                    MemEvent r = (MemEvent)e1;
                    MemEvent w = (MemEvent)e2;
                    IntExpr a1 = w.getMemAddressExpr().isBV() ? ctx.mkBV2Int((BitVecExpr)w.getMemAddressExpr(), false) : (IntExpr)w.getMemAddressExpr();
                    IntExpr a2 = r.getMemAddressExpr().isBV() ? ctx.mkBV2Int((BitVecExpr)r.getMemAddressExpr(), false) : (IntExpr)r.getMemAddressExpr();
                    BoolExpr sameAddress = ctx.mkEq(a1, a2);
        			enc = ctx.mkAnd(enc, ctx.mkEq(sameAddress, Utils.alias(w, r, ctx)));
        		}
        	}    		
    	}
    	return enc;
    }

    public static List<Init> getSecretInit(Program p, String secret) {
    	try {
    		List<Address> secretAddr = p.getMemory().getArrayAddresses(secret);
            return p.getCache().getEvents(FilterBasic.get(EType.INIT)).stream().
            		filter(e -> secretAddr.contains(((Init)e).getAddress())).
            		map(e -> (Init)e).
            		collect(Collectors.toList());
    	} catch (Exception e1) {
    		try {
        		List<Address> secretAddr = Arrays.asList(p.getMemory().getLocation(secret).getAddress());
                return p.getCache().getEvents(FilterBasic.get(EType.INIT)).stream().
                		filter(f -> secretAddr.contains(((Init)f).getAddress())).
                		map(f -> (Init)f).
                		collect(Collectors.toList());    			
    		} catch (Exception e2) {
        		throw new RuntimeException("The program does not contain secrets");
        	}
		}
    }
}