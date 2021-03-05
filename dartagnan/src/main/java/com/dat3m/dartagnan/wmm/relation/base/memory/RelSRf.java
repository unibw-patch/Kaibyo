package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.Settings;
import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.IntExpr;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.Utils;

import java.util.*;

import static com.dat3m.dartagnan.wmm.utils.Utils.edge;

public class RelSRf extends RelRf {

    public RelSRf(){
        term = "srf";
        forceDoEncode = true;
    }

    @Override
    protected BoolExpr encodeApprox() {
        BoolExpr enc = ctx.mkTrue();
        Map<MemEvent, List<BoolExpr>> edgeMap = new HashMap<>();
        Map<MemEvent, BoolExpr> memInitMap = new HashMap<>();

        boolean canAccNonInitMem = settings.getFlag(Settings.FLAG_CAN_ACCESS_UNINITIALIZED_MEMORY);
        boolean useSeqEncoding = settings.getFlag(Settings.FLAG_USE_SEQ_ENCODING_REL_RF);

        for(Tuple tuple : getMaxTupleSet()){
            MemEvent w = (MemEvent) tuple.getFirst();
            MemEvent r = (MemEvent) tuple.getSecond();
            BoolExpr edge = edge(term, w, r, ctx);
                        
            IntExpr v1 = w.getMemValueExpr().isBV() ? ctx.mkBV2Int((BitVecExpr)w.getMemValueExpr(), false) : (IntExpr)w.getMemValueExpr();
            IntExpr v2 = r.getMemValueExpr().isBV() ? ctx.mkBV2Int((BitVecExpr)r.getMemValueExpr(), false) : (IntExpr)r.getMemValueExpr();
            BoolExpr sameValue = ctx.mkEq(v1, v2);

            edgeMap.putIfAbsent(r, new ArrayList<>());
            edgeMap.get(r).add(edge);
            if(canAccNonInitMem && w.is(EType.INIT)){
                memInitMap.put(r, ctx.mkOr(memInitMap.getOrDefault(r, ctx.mkFalse()), Utils.alias(w, r, ctx)));
            }
            enc = ctx.mkAnd(enc, ctx.mkImplies(edge, ctx.mkAnd(w.exec(), r.exec(), Utils.alias(w, r, ctx), sameValue)));
        }

        for(MemEvent r : edgeMap.keySet()){
            enc = ctx.mkAnd(enc, useSeqEncoding
                    ? encodeEdgeSeq(r, memInitMap.get(r), edgeMap.get(r))
                    : encodeEdgeNaive(r, memInitMap.get(r), edgeMap.get(r)));
        }
        return enc;
    }
}
