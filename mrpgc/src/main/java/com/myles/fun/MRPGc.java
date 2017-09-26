package com.myles.fun;

import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.regex.Pattern;

import com.myles.fun.RPG.FileDefinition;
import com.myles.fun.RPG.ControlDefinition;

/**
 *
 */
public class MRPGc {

    String statement;
    String assignee;
    List<String> assignors;
    String lambda;

    private MRPGc(){
        // Declare as an util class
    }

    public static RPG compile(MRPG mrpg){
        RPG rpg = new RPG();

        // Inject assignee
        String assignee = mrpg.getAssignee();
        FileDefinition fdAssignee =
            new FileDefinition(assignee, FileDefinition.FILE_UPDATE_N_ADD);
        rpg.addFile(fdAssignee);

        // Inject assignor
        String assignor = mrpg.getAssignor();
        FileDefinition fdAssignor =
            new FileDefinition(assignor, FileDefinition.FILE_INQUIRY);
        rpg.addFile(fdAssignor);

        // Inject Controls
        if (mrpg.getOperation()== null){

            // This must be a single file assignment
            String eval = mrpg.getEvalStatement(assignee, assignor);
            addLoop(rpg, assignee, assignor, eval);

        }else{

            String operator = mrpg.getOperation().getOperator();

            if (operator.compareTo(MRPG.OPERATOR_ADD) == 0){
                String secondAssignor = mrpg.getOperation().getParameter();
                // Parse addition operation file definition
                FileDefinition secondAssignorFD =
                    new FileDefinition(secondAssignor, FileDefinition.FILE_INQUIRY);
                rpg.addFile(secondAssignorFD);
                
                // Parse addition operation control definition
                String eval1 = mrpg.getEvalStatement(assignee, assignor);
                String eval2 = mrpg.getEvalStatement(assignee, secondAssignor);
                addLoop(rpg, assignee, assignor, eval1);
                addLoop(rpg, assignee, secondAssignor, eval2);
            }
        }

        return rpg;
    }

    private static void addLoop(RPG rpg, String assignee, String assignor, String evalStatement){
        
        ControlDefinition loop = new ControlDefinition();
        loop.setType(ControlDefinition.CONTROL_LOOP_FILE);
        loop.setParameter(assignor);

        if (assignor.compareTo(assignee) == 0){
            // It is an update loop
            ControlDefinition eval = new ControlDefinition();
            eval.setType(ControlDefinition.CONTROL_EVAL);
            eval.setParameter(evalStatement);

            ControlDefinition update = new ControlDefinition();
            update.setType(ControlDefinition.CONTROL_UPDATE);
            update.setParameter(assignee);

            loop.addEmbed(eval);
            loop.addEmbed(update);
        }else{
            // It is an write loop
            ControlDefinition eval = new ControlDefinition();
            eval.setType(ControlDefinition.CONTROL_EVAL);
            eval.setParameter(evalStatement);

            ControlDefinition write = new ControlDefinition();
            write.setType(ControlDefinition.CONTROL_WRITE);
            write.setParameter(assignee);

            loop.addEmbed(eval);
            loop.addEmbed(write);
        }

        rpg.addControl(loop);
    }

    /**
     * helper function
     */
    private static void echo(String s){
        System.out.println("***debug***");
        System.out.println(s);
    }

}
