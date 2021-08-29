package com.dat3m.kaibyo.utils;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Init;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterMinus;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.dat3m.kaibyo.utils.options.KaibyoOptions;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class Encodings {
	
    public static BoolExpr encodeLeakage(Program p, Wmm wmm, KaibyoOptions options, Context ctx) {
    	BoolExpr enc = ctx.mkTrue();
    	BoolExpr or = ctx.mkFalse();
    	String rel = wmm.toString().contains("srf") ? "srf" : "rf";
    	List<Event> writes = options.getReadFrom() == -1 ? getSecretInit(p, options.getSecretOption()) : 
    		p.getCache().getEvents(FilterBasic.get(EType.WRITE)).stream().filter(e -> e.getOId() == options.getReadFrom()).collect(Collectors.toList());
    	for(Event r : p.getCache().getEvents(FilterMinus.get(FilterBasic.get(EType.READ), FilterBasic.get(EType.STACK)))){
    		for(Event w : writes) {
    			if(!wmm.getRelationRepository().getRelation(rel).getMaxTupleSet().contains(new Tuple(w,r))) {
    				continue;
    			}
    			// We use the AND to avoid cases where r.se() is not constrained anywhere else 
    			// (e.g. speculation execution if off) and the solver can make it trivially true 
    			// without affecting the execution of the instruction
    			BoolExpr exec = options.getOnlySpeculativeOption() ? ctx.mkAnd(r.se(), r.exec()) : r.exec();
    			or = ctx.mkOr(or, ctx.mkAnd(exec, Utils.edge(rel, w, r, ctx)));
    		}
    	}
    	if(or.isFalse()) {
    		throw new RuntimeException("The program does not contain secrets");
    	}
    	return ctx.mkAnd(enc, or);
    }

    public static List<Event> getSecretInit(Program p, String secret) {
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