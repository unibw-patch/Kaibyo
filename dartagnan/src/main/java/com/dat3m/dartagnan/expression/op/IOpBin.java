package com.dat3m.dartagnan.expression.op;

import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;

public enum IOpBin {
    PLUS, MINUS, MULT, DIV, UDIV, MOD, AND, OR, XOR, L_SHIFT, R_SHIFT, AR_SHIFT, SREM, UREM;
	
    @Override
    public String toString() {
        switch(this){
            case PLUS:
                return "+";
            case MINUS:
                return "-";
            case MULT:
                return "*";
            case DIV:
                return "/";
            case MOD:
                return "%";
            case AND:
                return "&";
            case OR:
                return "|";
            case XOR:
                return "^";
            case L_SHIFT:
                return "<<";
            case R_SHIFT:
                return ">>>";
            case AR_SHIFT:
                return ">>";
            default:
            	return super.toString();        	
        }
    }

    public String toLinuxName(){
        switch(this){
            case PLUS:
                return "add";
            case MINUS:
                return "sub";
            case AND:
                return "and";
            case OR:
                return "or";
            case XOR:
                return "xor";
            default:
            	throw new UnsupportedOperationException("Linux op name is not defined for " + this);
        }
    }

    public Expr encode(Expr e1, Expr e2, Context ctx){
    	if(e1.isBV() != e2.isBV()) {
    		throw new UnsupportedOperationException(e1 + " and " + e2 + " have different types");
    	}
		switch(this){
            case PLUS:
            	return ctx.mkBVAdd((BitVecExpr)e1, (BitVecExpr)e2);            		
            case MINUS:
            	return ctx.mkBVSub((BitVecExpr)e1, (BitVecExpr)e2);
            case MULT:
            	return ctx.mkBVMul((BitVecExpr)e1, (BitVecExpr)e2);
            case DIV:
            	return ctx.mkBVSDiv((BitVecExpr)e1, (BitVecExpr)e2);
            case UDIV:
            	return ctx.mkBVUDiv((BitVecExpr)e1, (BitVecExpr)e2);
            case MOD:
            	return ctx.mkBVSMod((BitVecExpr)e1, (BitVecExpr)e2);
            case AND:
            	return ctx.mkBVAND((BitVecExpr)e1, (BitVecExpr)e2);	
            case OR:
            	return ctx.mkBVOR((BitVecExpr)e1, (BitVecExpr)e2);	
            case XOR:
            	return ctx.mkBVXOR((BitVecExpr)e1, (BitVecExpr)e2);
            case L_SHIFT:
            	return ctx.mkBVSHL((BitVecExpr)e1, (BitVecExpr)e2);
            case R_SHIFT:
            	return ctx.mkBVLSHR((BitVecExpr)e1, (BitVecExpr)e2);
            case AR_SHIFT:
            	return ctx.mkBVASHR((BitVecExpr)e1, (BitVecExpr)e2);
            case SREM:
            	return ctx.mkBVSRem((BitVecExpr)e1, (BitVecExpr)e2);
            case UREM:
            	return ctx.mkBVURem((BitVecExpr)e1, (BitVecExpr)e2);
        }
        throw new UnsupportedOperationException("Encoding of not supported for IOpBin " + this);
    }

    public int combine(int a, int b){
        switch(this){
            case PLUS:
                return a + b;
            case MINUS:
                return a - b;
            case MULT:
                return a * b;
            case DIV:
            case UDIV:
                return a / b;
            case MOD:
            case SREM:
            case UREM:
                return a % b;
            case AND:
                return a & b;
            case OR:
                return a | b;
            case XOR:
                return a ^ b;
            case L_SHIFT:
                return a << b;
            case R_SHIFT:
                return a >>> b;
            case AR_SHIFT:
                return a >> b;
        }
        throw new UnsupportedOperationException("Illegal operator " + this + " in IOpBin");
    }
}
