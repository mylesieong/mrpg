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
                String pa1 = pa.substring(0, iMul);
                String pa2 = pa.substring(iMul + 1, pa.length());

                o1.setOperator(op);
                o1.setParameter(pa1);

                o2.setOperator(op);
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

}
