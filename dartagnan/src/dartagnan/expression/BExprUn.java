package dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.op.BOpUn;
import dartagnan.program.Register;
import dartagnan.program.event.Event;

import java.util.HashSet;
import java.util.Set;

public class BExprUn extends BExpr {

    private final ExprInterface b;
    private final BOpUn op;

    public BExprUn(BOpUn op, ExprInterface b) {
        this.b = b;
        this.op = op;
    }

    @Override
    public BoolExpr toZ3Bool(Event e, Context ctx) {
        return op.encode(b.toZ3Bool(e, ctx), ctx);
    }

    @Override
    public Set<Register> getRegs() {
        return new HashSet<>(b.getRegs());
    }

    public BExprUn clone() {
        return new BExprUn(op, b.clone());
    }

    public String toString() {
        return "(" + op + " " + b + ")";
    }
}
