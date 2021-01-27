package com.dat3m.dartagnan.program.arch.linux.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.linux.utils.Mo;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.rmw.RMWLoad;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.arch.linux.utils.EType;
import com.dat3m.dartagnan.compiler.Arch;
import com.dat3m.dartagnan.compiler.Mitigation;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

public class RMWOp extends RMWAbstract implements RegWriter, RegReaderData {

    private final IOpBin op;

    public RMWOp(IExpr address, Register register, ExprInterface value, IOpBin op) {
        super(address, register, value, Mo.RELAXED);
        this.op = op;
        addFilters(EType.NORETURN);
    }

    private RMWOp(RMWOp other){
        super(other);
        this.op = other.op;
    }

    @Override
    public String toString() {
        return "atomic_" + op.toLinuxName() + "(" + value + ", " + address + ")";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMWOp getCopy(){
        return new RMWOp(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int compile(Arch target, List<Mitigation> mitigations, int nextId, Event predecessor) {
        if(target == Arch.NONE) {
            RMWLoad load = new RMWLoad(resultRegister, address, Mo.RELAXED);
            RMWStore store = new RMWStore(load, address, new IExprBin(resultRegister, op, value), Mo.RELAXED);
            load.addFilters(EType.NORETURN);
            LinkedList<Event> events = new LinkedList<>(Arrays.asList(load, store));
            return compileSequence(target, mitigations, nextId, predecessor, events);
        }
        return super.compile(target, mitigations, nextId, predecessor);
    }
}
