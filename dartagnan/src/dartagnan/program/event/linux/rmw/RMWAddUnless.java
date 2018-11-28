package dartagnan.program.event.linux.rmw;

import dartagnan.expression.AExpr;
import dartagnan.expression.Atom;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.op.AOpBin;
import dartagnan.expression.op.COpBin;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.Local;
import dartagnan.program.event.rmw.cond.RMWReadCondUnless;
import dartagnan.program.event.rmw.cond.RMWStoreCond;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;

import java.util.Set;

public class RMWAddUnless extends RMWAbstract implements RegWriter, RegReaderData, RegReaderAddress {
    private ExprInterface cmp;

    public RMWAddUnless(Register address, Register register, ExprInterface cmp, ExprInterface value) {
        super(address, register, value, "Mb");
        this.cmp = cmp;
    }

    @Override
    public Set<Register> getDataRegs(){
        Set<Register> regs = super.getDataRegs();
        if(cmp instanceof Register){
            regs.add((Register) cmp);
        }
        return regs;
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc")) {
            Register dummy = new Register(null);
            RMWReadCondUnless load = new RMWReadCondUnless(dummy, cmp, address, "Relaxed");
            RMWStoreCond store = new RMWStoreCond(load, address, new AExpr(dummy, AOpBin.PLUS, value), "Relaxed");
            Local local = new Local(reg, new Atom(dummy, COpBin.NEQ, cmp));

            compileBasic(load);
            compileBasic(store);

            Thread result = new Seq(load, new Seq(store, local));
            return insertCondFencesOnMb(result, load);
        }
        return super.compile(target, ctrl, leading);
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + reg + " := atomic_add_unless" + "(" + loc + ", " + value + "," + cmp + ")";
    }

    @Override
    public RMWAddUnless clone() {
        if(clone == null){
            Register newReg = reg.clone();
            ExprInterface newValue = reg == value ? newReg : value.clone();
            ExprInterface newCmp = reg == cmp ? newReg : ((value == cmp) ? newValue : value.clone());
            clone = new RMWAddUnless((Register) address.clone(), newReg, newCmp, newValue);
            afterClone();
        }
        return (RMWAddUnless)clone;
    }
}
