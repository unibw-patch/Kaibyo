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
	
    public static BoolExpr encodeLeakage(Program p, Context ctx, String secret, boolean onlySpeculative) {
    	BoolExpr enc = ctx.mkFalse();
    	Address secretAddr;
    	try {
        	secretAddr = p.getMemory().getLocation(secret).getAddress();
        	for(Event r : p.getCache().getEvents(FilterBasic.get(EType.READ))){
        		BoolExpr exec = onlySpeculative ? r.se() : r.exec();
    			enc = ctx.mkOr(enc, ctx.mkAnd(ctx.mkEq(((Load)r).getMemAddressExpr(), secretAddr.toZ3Int(ctx)), exec));
        	}    		
    	} catch (Exception e1) {
    		try {
            	secretAddr = p.getMemory().getArrayAddress(secret);
            	for(Event r : p.getCache().getEvents(FilterBasic.get(EType.READ))){
            		BoolExpr exec = onlySpeculative ? r.se() : r.exec();
        			enc = ctx.mkOr(enc, ctx.mkAnd(ctx.mkEq(((Load)r).getMemAddressExpr(), secretAddr.toZ3Int(ctx)), exec));
            	}    		    			
    		} catch (Exception e2) {
        		throw new RuntimeException("The program does not contain secrets");
			}
    	}
    	return enc;
    }    
}