package com.myles.fun;

import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.regex.Pattern;

/**
 *
 */
public class MRPGc {

    final String OPERATOR_EQ = "=";
    final String OPERATOR_ADD = "+";
    final String OPERATOR_MUL = "*";

    final int FILE_INQUIRY = 0;
    final int FILE_UPDATE_N_ADD = 1;

    final int ASSIGN_TYPE_ADD = 1;
    final int ASSIGN_TYPE_MUL = 2;

    final String FD_FORMAT = "F%s %sF %s E K DISK";
    final String CD_READ_FORMAT = "C READ %s";
    final String CD_DOW_BEG_FORMAT = "C DOW NOT %EOF";
    final String CD_DOW_END_FORMAT = "(%s)";
    final String CD_DELETE_FORMAT = "C DELETE %s";
    final String CD_WRITE_FORMAT = "C WRITE %s";
    final String CD_UPDATE_FORMAT = "C UPDATE %s";
    final String CD_EVAL_FORMAT = "C EVAL %s = %s";
    final String CD_EVAL_LAMBDA_FORMAT = "C EVAL %s";
    final String CD_ENDDO_FORMAT = "C ENDDO";

    String statement;
    String assignee;
    List<String> assignors;
    String lambda;
 
    public MRPGc(String s)throws Exception{
        statement = s;
        assignee = getAssignee(statement);
        assignors = getAssignors(statement);
        lambda = getLambda(statement);
    }

    public String compile()throws Exception {
        if (getAssignType(statement) == ASSIGN_TYPE_ADD){
            return compileAdd();
        }else{
            return compileMul();
        }
    }

    public String compileMul(){
        String output = "";

        // Write file declaration of assignee
        output += getFileDeclaration(assignee, FILE_UPDATE_N_ADD);
        output += "\n";
        
        // Write file declaration of assignors
        for (String a: assignors){
            if (a.compareTo(assignee) != 0){
                output += getFileDeclaration(a, FILE_INQUIRY);
                output += "\n";
            }
        }

        // Control: clear assignee if not in assignor list
        if (assignors.indexOf(assignee) == -1){
            output += getClearFile(assignee);
            output += "\n";
        }

        // Control: assign (assume only 1 assignor)
        output += getLambdaAssign(assignee, assignors.get(0), lambda);
        output += "\n";

        return output;
    }

    public String compileAdd() {
        String output = "";

        // Write file declaration of assignee
        output += getFileDeclaration(assignee, FILE_UPDATE_N_ADD);
        output += "\n";
        
        // Write file declaration of assignors
        for (String a: assignors){
            if (a.compareTo(assignee) != 0){
                output += getFileDeclaration(a, FILE_INQUIRY);
                output += "\n";
            }
        }

        // Control: clear assignee if not in assignor list
        if (assignors.indexOf(assignee) == -1){
            output += getClearFile(assignee);
            output += "\n";
        }

        // Control: loop and assign
        for (String a: assignors){
            if (a.compareTo(assignee) != 0){
                output += getAssignFile(assignee, a);
                output += "\n";
            }
        }

        return output;
    }

    public String getLambdaAssign(String assignee, String assignor, String lambda){
        String r = "";
        r += String.format(CD_READ_FORMAT, assignor);
        r += "\n";
        r += CD_DOW_BEG_FORMAT;
        r += String.format(CD_DOW_END_FORMAT, assignor);
        r += "\n";
        r += String.format(CD_EVAL_LAMBDA_FORMAT, lambda);
        r += "\n";
        if (assignor.compareTo(assignee) == 0){
            r += String.format(CD_UPDATE_FORMAT, assignee);
            r += "\n";
        }else{
            r += String.format(CD_EVAL_FORMAT, assignee, assignor);
            r += "\n";
            r += String.format(CD_WRITE_FORMAT, assignee);
            r += "\n";
        }
        r += String.format(CD_READ_FORMAT, assignor);
        r += "\n";
        r += String.format(CD_ENDDO_FORMAT);
        return r;
    }

    public String getClearFile(String file){
        String r = "";
        r += String.format(CD_READ_FORMAT, file);
        r += "\n";
        r += CD_DOW_BEG_FORMAT;
        r += String.format(CD_DOW_END_FORMAT, file);
        r += "\n";
        r += String.format(CD_DELETE_FORMAT, file);
        r += "\n";
        r += String.format(CD_READ_FORMAT, file);
        r += "\n";
        r += String.format(CD_ENDDO_FORMAT);
        return r;
    }

    public String getAssignFile(String assignee, String assignor){
        String r = "";
        r += String.format(CD_READ_FORMAT, assignor);
        r += "\n";
        r += CD_DOW_BEG_FORMAT;
        r += String.format(CD_DOW_END_FORMAT, assignor);
        r += "\n";
        r += String.format(CD_EVAL_FORMAT, assignee, assignor);
        r += "\n";
        r += String.format(CD_WRITE_FORMAT, assignee);
        r += "\n";
        r += String.format(CD_READ_FORMAT, assignor);
        r += "\n";
        r += String.format(CD_ENDDO_FORMAT);
        return r;
    }

    public String getFileDeclaration(String file, int action){
        String t1 = file;
        String t2 = action==FILE_INQUIRY ? "I" : "U";
        String t3 = action==FILE_UPDATE_N_ADD ? "A" : " ";
        return String.format(FD_FORMAT, t1, t2, t3);
    }

    public String getAssignee(String s)throws Exception{
        String r = s.split(OPERATOR_EQ)[0];
        return r;
    }

    public List<String> getAssignors(String s)throws Exception{
        
        String body = getBody(s);
        List<String> r = new ArrayList<String>();

        // Only one assignor
        if (body.indexOf(OPERATOR_ADD) == -1 && body.indexOf(OPERATOR_MUL) == -1){
            r.add(body);
        }

        // Two assignor with add operation
        if (body.indexOf(OPERATOR_ADD) != -1){
            r = Arrays.asList(body.split(Pattern.quote(OPERATOR_ADD)));
        }

        // Multiply operation
        if (body.indexOf(OPERATOR_MUL) != -1){
            String assignor = body.split(Pattern.quote(OPERATOR_MUL))[0];
            r.add(assignor);
        }

        return r;
    }

    public String getLambda(String s)throws Exception{
        String body = getBody(s);
        String result = "";
        if (body.indexOf(OPERATOR_MUL) != -1){
            //extract lambda expression from body
            result = takeOfBrackets(body.split(Pattern.quote(OPERATOR_MUL))[1]);
        }
        return result;
    }

    private String takeOfBrackets(String s){
        return s.substring(1, s.length() - 1);
    }

    public String getBody(String s)throws Exception{
        String body = s.substring(s.indexOf(OPERATOR_EQ) + 1);
        return body;
    }

    public int getAssignType(String s)throws Exception{
        int result = 0;
        String body = s.split(OPERATOR_EQ)[1];
        // Judge what is the assign type (assume only 1 type in a statement)
        if (body.indexOf(OPERATOR_ADD) != -1){
            result = ASSIGN_TYPE_ADD;
        }else if (body.indexOf(OPERATOR_MUL) != -1){
            result = ASSIGN_TYPE_MUL;
        }else{
            result = ASSIGN_TYPE_ADD;
        }
        return result;
    }

    private void echo(String s){
        System.out.println("***debug***");
        System.out.println(s);
    }

}
