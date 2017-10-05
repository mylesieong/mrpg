package com.myles.fun;

import java.util.List;
import java.util.ArrayList;
import com.myles.fun.MRPGStatement.Operation;

/**
 *
 */
public class MRPG {

    private List<MRPGStatement> _stmts = new ArrayList<MRPGStatement>();

    public MRPG(){
    }

    public MRPG(String article){
        String[] stmts = article.split("\n");

        for (String s: stmts){
            if (!s.matches(".*=.*")){
                // Non-Statement type actions
                // TODO

            }else{
                // Statement type actions
                MRPGStatement ms = new MRPGStatement(s);
                addStatement(ms);
            }
        }

    }

    public MRPGStatement getStatement(int i){
        return _stmts.get(i);
    }

    public List<MRPGStatement> getAllStatement(){
        return _stmts;
    }

    public void addStatement(MRPGStatement ms){
        _stmts.add(ms);
    }

    public void atomize(){
        
        int i = 0;
        while (i < _stmts.size()){

            MRPGStatement m = _stmts.get(i);

            // Find non-atomic statements and split
            if (!m.isAtomic()){

                _stmts.remove(i);

                // Split non-atomic statements into 2
                MRPGStatement m1 = new MRPGStatement();
                MRPGStatement m2 = new MRPGStatement();

                Operation o1 = new Operation();
                Operation o2 = new Operation();

                String op = m.getOperation().getOperator();
                String pa = m.getOperation().getParameter();

                int iMul = pa.indexOf(MRPGStatement.OPERATOR_MUL);
                int iAdd = pa.indexOf(MRPGStatement.OPERATOR_ADD);
                int index;
                String pa1;
                String pa2;
                String op1;
                String op2;
                if (iMul > 0 && iAdd > 0){
                    index = iMul > iAdd ? iAdd: iMul;
                    op2 = iMul > iAdd ? MRPGStatement.OPERATOR_ADD: MRPGStatement.OPERATOR_MUL;
                }else{
                    index = iMul > 0 ? iMul: iAdd;
                    op2 = iMul > 0 ? MRPGStatement.OPERATOR_MUL: MRPGStatement.OPERATOR_ADD;
                }

                pa1 = pa.substring(0, index);
                pa2 = pa.substring(index + 1, pa.length());
                op1 = op;

                o1.setOperator(op1);
                o1.setParameter(pa1);

                o2.setOperator(op2);
                o2.setParameter(pa2);

                m1.setAssignee(m.getAssignee());
                m1.setAssignor(m.getAssignor());
                m1.setOperation(o1);

                m2.setAssignee(m.getAssignee());
                m2.setAssignor(m.getAssignor());
                m2.setOperation(o2);

                _stmts.add(i, m1);
                _stmts.add(i + 1, m2);
                i = i + 2;

            }else{

                i = i + 1;
                
            }

        }

    }

    private void echo(String s){
        System.out.println(s);
    }

    @Override 
    public String toString(){
        String result = "";
        for (MRPGStatement m: _stmts){
            result = result + m.toString() + "\n";
        }
        return result;
    }
}
