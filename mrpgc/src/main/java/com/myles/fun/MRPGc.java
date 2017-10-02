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

    private MRPGc(){
        // Declare as an util class
    }

    public static RPG compile(MRPG mrpg){
        RPG rpg = new RPG();

        // Inject assignee
        String assignee = mrpg.getAssignee();
        FileDefinition fdAssignee = new FileDefinition(assignee, FileDefinition.FILE_UPDATE_N_ADD);
        rpg.addFile(fdAssignee);

        // Inject assignor
        String assignor = mrpg.getAssignor();
        FileDefinition fdAssignor = new FileDefinition(assignor, FileDefinition.FILE_INQUIRY);
        rpg.addFile(fdAssignor);

        // Check if pf should be clear
        if (shouldFileBeClear(mrpg, assignee)){
            addClearLoop(rpg, assignee);
        }

        // Inject Controls
        if (mrpg.getOperation()== null){

            // This must be a single file assignment
            String eval = mrpg.getEvalStatement(assignee, assignor);
            addLoop(rpg, assignee, assignor, eval);

        }else{

            String operator = mrpg.getOperation().getOperator();

            // Process + Operation
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

            // Process * Operation
            if (operator.compareTo(MRPG.OPERATOR_MUL) == 0){

                List<String> ops = new ArrayList<String>();

                // Set lambda stmt
                String lambda = mrpg.getOperation().getParameter(); 
                int bracketOpen = lambda.indexOf("(");
                int bracketClose = lambda.indexOf(")");
                lambda = lambda.substring(bracketOpen + 1, bracketClose);
                ops.add(lambda);

                // Set update/write stmt
                String eval = mrpg.getEvalStatement(assignee, assignor);
                ops.add(eval);

                addLoop(rpg, assignee, assignor, ops); 
            }

        }

        return rpg;
    }

    private static boolean shouldFileBeClear(MRPG mrpg, String file){
        String assignee = mrpg.getAssignee();
        String assignor = mrpg.getAssignor();
        return file.compareTo(assignee) == 0 && file.compareTo(assignor) != 0;
    }

    private static void addClearLoop(RPG rpg, String file){
        
        ControlDefinition loop = new ControlDefinition();
        loop.setType(ControlDefinition.CONTROL_LOOP_FILE);
        loop.setParameter(file);

        ControlDefinition delete = new ControlDefinition();
        delete.setType(ControlDefinition.CONTROL_DELETE);
        delete.setParameter(file);
        loop.addEmbed(delete);

        rpg.addControl(loop);

    }

    private static void addLoop(RPG rpg, String assignee, String assignor, String eval){
        List<String> l = new ArrayList<String>();
        l.add(eval);
        addLoop(rpg, assignee, assignor, l);
    }

    private static void addLoop(RPG rpg, String assignee, String assignor, List<String> evals){
        
        ControlDefinition loop = new ControlDefinition();
        loop.setType(ControlDefinition.CONTROL_LOOP_FILE);
        loop.setParameter(assignor);

        if (assignor.compareTo(assignee) == 0){
            // It is an update loop
            for (String e: evals){
                ControlDefinition eval = new ControlDefinition();
                eval.setType(ControlDefinition.CONTROL_EVAL);
                eval.setParameter(e);
                loop.addEmbed(eval);
            }

            ControlDefinition update = new ControlDefinition();
            update.setType(ControlDefinition.CONTROL_UPDATE);
            update.setParameter(assignee);
            loop.addEmbed(update);

        }else{
            // It is an write loop
            for (String e: evals){
                ControlDefinition eval = new ControlDefinition();
                eval.setType(ControlDefinition.CONTROL_EVAL);
                eval.setParameter(e);
                loop.addEmbed(eval);
            }

            ControlDefinition write = new ControlDefinition();
            write.setType(ControlDefinition.CONTROL_WRITE);
            write.setParameter(assignee);
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
