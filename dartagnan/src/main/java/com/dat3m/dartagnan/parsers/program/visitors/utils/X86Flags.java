package com.dat3m.dartagnan.parsers.program.visitors.utils;

import static com.dat3m.dartagnan.expression.op.COpBin.GTE;
import static com.dat3m.dartagnan.expression.op.COpBin.LT;
import static com.dat3m.dartagnan.expression.op.COpBin.ULT;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.expression.BExprBin;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.expression.op.COpBin;

public enum X86Flags {
	CF, OF, SF, ZF;
	
	public String getName() {
		return toString().toLowerCase();
	}
	
	public BExpr getFlagDef(ExprInterface op1, ExprInterface op2) {
		IConst zero = new IConst(0, -1);
		Atom a1 = new Atom(op1, GTE, op2);
		Atom a2 = new Atom(op1, LT, zero);
		Atom a3 = new Atom(op2, GTE, zero);
		Atom a4 = new Atom(op1, GTE, zero);
		Atom a5 = new Atom(op2, LT, zero);
		BExprBin b23 = new BExprBin(a2, BOpBin.AND, a3);
		BExprBin b45 = new BExprBin(a4, BOpBin.AND, a5);
		BExprBin or = new BExprBin(b23, BOpBin.OR, b45);
		switch(this) {
		case CF:
			return new Atom(op1, ULT, op2);
		case OF:
			return new BExprBin(a1, BOpBin.AND, or);
		case SF:
			return new Atom(op1, LT, op2);
		case ZF:
			return new Atom(op1, COpBin.EQ, op2);
		default:
			 throw new UnsupportedOperationException("getFlagDef() not supported for " + this);
		}
	}
}
