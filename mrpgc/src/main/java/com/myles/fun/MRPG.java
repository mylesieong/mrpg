package com.myles.fun;

import java.util.List;
import java.util.ArrayList;

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
}
