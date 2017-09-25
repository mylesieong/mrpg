package com.myles.fun;

/**
 *
 */
public class MRPG {

    /**
     * Assume _original only have below forms:
     * 1. A = B
     * 1. A = A ? B 
     */
    final static String OPERATOR_EQ = "=";
    final static String OPERATOR_ADD = "+";
    final static String OPERATOR_RED = "-";
    final static String OPERATOR_MUL = "*";
    final static String OPERATOR_DIV = "/";

    private String _assignee;
    private String _assignor;
    private Operation _operation;

    public MRPG(){ 
        _assignee = "";
        _assignor = "";
        _operation = null;
    }

    public MRPG(String s){
        int indexEQ = s.indexOf(OPERATOR_EQ);

        int indexADD = s.indexOf(OPERATOR_ADD);
        int indexRED = s.indexOf(OPERATOR_RED);
        int indexMUL = s.indexOf(OPERATOR_MUL);
        int indexDIV = s.indexOf(OPERATOR_DIV);

        int index = indexADD!=-1?indexADD:0 
           + indexRED!=-1?indexRED:0 
           + indexMUL!=-1?indexMUL:0 
           + indexDIV!=-1?indexDIV:0;

        _assignee = s.substring(0, indexEQ);

        if (indexADD == -1 && indexRED == -1 
                && indexMUL == -1 && indexDIV == -1){
            _assignor = s.substring(indexEQ + 1);
        }else{
            _assignor = s.substring(indexEQ, index);
        } 

        _operation = null; //TODO
    }

    public void setAssignor(String s){
        _assignor = s;
    }

    public void setAssignee(String s){
        _assignee = s;
    }

    public String getAssignor(){
        return _assignor;
    }

    public String getAssignee(){
        return _assignee;
    }

    @Override 
    public String toString(){
        StringBuilder sb = new StringBuilder();
        sb.append(_assignee);
        sb.append(OPERATOR_EQ);
        sb.append(_assignor);
        //TODO operation appending
        return sb.toString();
    }

    /**
     *
     */
    public class Operation {
        
        private String _operator;
        private String _parameter;

    }

}
