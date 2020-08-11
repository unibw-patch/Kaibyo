package com.dat3m.zombmc.utils;


import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class Encodings {
	
    public static BoolExpr encodeSpectre(Program p, Context ctx) {
    	BoolExpr gadget = ctx.mkFalse();
    	try {
        	Address secret = p.getMemory().getLocation("spectre_secret").getAddress();
        	for(Event r : p.getCache().getEvents(FilterBasic.get(EType.READ))){
    			gadget = ctx.mkOr(gadget, ctx.mkAnd(ctx.mkEq(((Load)r).getMemAddressExpr(), secret.toZ3Int(ctx)), r.exec()));
        	}    		
    	} catch (Exception e) {
    		throw new RuntimeException("The program does not contain secrets");
    	}
    	BoolExpr speculation = ctx.mkFalse();
    	for(Event j : p.getCache().getEvents(FilterBasic.get(EType.JUMP))){
    		speculation = ctx.mkOr(speculation, j.startSE());
    	}
    	return ctx.mkAnd(gadget, speculation);
    }    
}