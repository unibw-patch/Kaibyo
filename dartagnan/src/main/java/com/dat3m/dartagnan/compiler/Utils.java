package com.dat3m.dartagnan.compiler;

import static com.dat3m.dartagnan.expression.op.IOpBin.AND;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;

public class Utils {

    public static void slh(Program p, Context ctx) {
        for(Event e : p.getCache().getEvents(FilterBasic.get(EType.MEMORY))){
        	MemEvent m = ((MemEvent)e);
        	IExpr address = m.getAddress();
        	Expr mask0 = new IExprBin(address, AND, new IConst(0, address.getPrecision())).toZ3Int(m, ctx);
        	Expr mask1 = new IExprBin(address, AND, new IConst(1, address.getPrecision())).toZ3Int(m, ctx);
            m.setMemAddressExpr(ctx.mkITE(m.cf(), mask0, mask1));
        }
    }
}
