package dartagnan.program.event.rmw.opt;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.IExpr;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.utils.RegReaderData;

public class RMWStoreOpt extends RMWStore implements RegReaderData {

    public RMWStoreOpt(RMWLoad loadEvent, IExpr address, ExprInterface value, String atomic){
        super(loadEvent, address, value, atomic);
    }

    @Override
    public BoolExpr encodeCF(Context ctx) {
        return ctx.mkImplies(ctx.mkNot(ctx.mkBoolConst(cfVar())), ctx.mkNot(executes(ctx)));
    }

    @Override
    public RMWStoreOpt clone() {
        if(clone == null){
            RMWLoad newLoad = loadEvent != null ? loadEvent.clone() : null;
            clone = new RMWStoreOpt(newLoad, address.clone(), value.clone(), atomic);
            afterClone();
        }
        return (RMWStoreOpt)clone;
    }

    @Override
    public BoolExpr encodeDF(Context ctx) {
        BoolExpr enc = super.encodeDF(ctx);
        if(loadEvent == null){
            enc = ctx.mkAnd(enc, ctx.mkNot(executes(ctx)));
        } else {
            enc = ctx.mkImplies(executes(ctx), ctx.mkEq(addressExpr, loadEvent.getAddressExpr()));
        }
        return enc;
    }
}
