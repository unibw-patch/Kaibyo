package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.Settings;
import com.microsoft.z3.BoolExpr;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterMinus;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.dat3m.dartagnan.wmm.utils.Utils;

import java.util.*;

import static com.dat3m.dartagnan.wmm.utils.Utils.edge;

public class RelSRf extends RelRf {

    public RelSRf(){
        term = "srf";
        forceDoEncode = true;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
        	used = true;
            maxTupleSet = new TupleSet();

            List<Event> eventsLoad = program.getCache().getEvents(FilterBasic.get(EType.READ));
            List<Event> eventsInit = program.getCache().getEvents(FilterBasic.get(EType.INIT));
            List<Event> eventsStore = program.getCache().getEvents(FilterMinus.get(
                    FilterBasic.get(EType.WRITE),
                    FilterBasic.get(EType.INIT)
            ));

            for(Event e1 : eventsInit){
                for(Event e2 : eventsLoad){
                	maxTupleSet.add(new Tuple(e1, e2));
                }
            }

            for(Event e1 : eventsStore){
                for(Event e2 : eventsLoad){
                    maxTupleSet.add(new Tuple(e1, e2));
                }
            }
        }
        return maxTupleSet;
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

            if(w.getSuccessors().stream().filter(e -> e.getCId() < r.getCId()).anyMatch(e -> e instanceof Fence)) {
            	BoolExpr sameAddress = ctx.mkEq(w.getMemAddressExpr(), r.getMemAddressExpr());
            	enc = ctx.mkAnd(enc, ctx.mkEq(Utils.alias(w, r, ctx), sameAddress));
            }
            
            BoolExpr sameValue = ctx.mkEq(w.getMemValueExpr(), r.getMemValueExpr());

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
