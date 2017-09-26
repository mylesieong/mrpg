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
            ControlDefinition loop = new ControlDefinition();
            loop.setType(ControlDefinition.CONTROL_LOOP_FILE);
            loop.setParameter(assignor);

            ControlDefinition eval = new ControlDefinition();
            eval.setType(ControlDefinition.CONTROL_EVAL);
            eval.setParameter(mrpg.getEvalStatement(assignee, assignor));

            ControlDefinition write = new ControlDefinition();
            write.setType(ControlDefinition.CONTROL_WRITE);
            write.setParameter(assignee);

            loop.addEmbed(eval);
            loop.addEmbed(write);
            rpg.addControl(loop);
        }

        return rpg;
    }

    /**
     * helper function
     */
    private static void echo(String s){
        System.out.println("***debug***");
        System.out.println(s);
    }

}
