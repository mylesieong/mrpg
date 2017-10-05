package com.myles.fun;

/**
 *
 */
public class MRPGStatement {

    /**
     * Assume _original only have below forms:
     * 1) A = B
     * 1) A = A ? B 
     */
    final static String OPERATOR_EQ = "=";
    final static String OPERATOR_ADD = "+";
    final static String OPERATOR_RED = "-";
    final static String OPERATOR_MUL = "*";
    final static String OPERATOR_DIV = "/";

    private String _assignee;
    private String _assignor;
    private Operation _operation;

    public MRPGStatement(){ 
        this.setAssignee("");
        this.setAssignor("");
        this.setOperation(null);
    }

    public MRPGStatement(String s){
        int iEQ = s.indexOf(OPERATOR_EQ);

        int iADD = s.indexOf(OPERATOR_ADD);
        int iRED = s.indexOf(OPERATOR_RED);
        int iMUL = s.indexOf(OPERATOR_MUL);
        int iDIV = s.indexOf(OPERATOR_DIV);

        boolean hasNoOperation = iADD==-1&&iRED==-1&&iMUL==-1&&iDIV==-1;

        this.setAssignee(s.substring(0, iEQ));

        if (hasNoOperation){

            this.setAssignor(s.substring(iEQ + 1));
            this.setOperation(null);

        }else{

            int index = 9999;
            String operator = null;
            String parameter = null;

            // Locate the first operator
            if (iADD > 0 && iADD < index){
                index = iADD;
                operator = OPERATOR_ADD;
            }

            if (iRED > 0 && iRED < index){
                index = iRED;
                operator = OPERATOR_RED;
            }
           
            if (iMUL > 0 && iMUL < index){
                index = iMUL;
                operator = OPERATOR_MUL;
            }
            
            if (iDIV > 0 && iDIV < index){
                index = iDIV;
                operator = OPERATOR_DIV;
            }

            parameter = s.substring(index + 1);
            this.setAssignor(s.substring(iEQ + 1, index));
            this.setOperation(new Operation(operator, parameter));

        } 

    }

    public void setAssignor(String s){
        _assignor = s;
    }

    public String getAssignor(){
        return _assignor;
    }

    public void setAssignee(String s){
        _assignee = s;
    }

    public String getAssignee(){
        return _assignee;
    }

    public String getEvalStatement(String a, String b){
        String fieldA = a + "001";
        String fieldB = b + "001";
        return fieldA + "=" + fieldB;
    }

    public void setOperation(Operation o){
        _operation = o;
    }

    public Operation getOperation(){
        return _operation;
    }

    public boolean isAtomic(){

        if (_operation == null){
            return true;
        }

        String p = _operation.getParameter();
        int iADD = p.indexOf(OPERATOR_ADD);
        int iRED = p.indexOf(OPERATOR_RED);
        int iMUL = p.indexOf(OPERATOR_MUL);
        int iDIV = p.indexOf(OPERATOR_DIV);
        return iADD==-1 && iRED==-1 && iMUL==-1 && iDIV==-1;
        
    }

    @Override 
    public String toString(){
        StringBuilder sb = new StringBuilder();
        sb.append(_assignee);
        sb.append(OPERATOR_EQ);
        sb.append(_assignor);
        if (_operation != null){
            sb.append(_operation.getOperator());
            sb.append(_operation.getParameter());
        }
        return sb.toString();
    }

    /**
     *
     */
    public static class Operation {
        
        private String _operator;
        private String _parameter;

        public Operation(){
            _operator = null;
            _parameter = null;
        }

        public Operation(String operator, String parameter){
            _operator = operator;
            _parameter = parameter;
        }

        public void setOperator(String s){
            _operator = s;
        }

        public String getOperator(){
            return _operator;
        }

        public void setParameter(String s){
            _parameter = s;
        }

        public String getParameter(){
            return _parameter;
        }
    }

    private void echo(String s){
        System.out.println("***debug MRPGStatement ***");
        System.out.println(s);
    }

    private void echo(int i){
        System.out.println("***debug MRPGStatement ***");
        System.out.println(i);
    }
}
