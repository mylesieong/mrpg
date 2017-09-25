package com.myles.fun;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import com.myles.fun.RPG;
import com.myles.fun.RPG.FileDefinition;
import com.myles.fun.RPG.ControlDefinition;

/**
 *
 */
public class RPGTest extends TestCase{

    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public RPGTest( String testName ){
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite(){
        return new TestSuite( RPGTest.class );
    }

    /**
     * Test toString File Definition
     */
    public void testFileDefinition()throws Exception{
        RPG rpg = new RPG();
        FileDefinition fda = new FileDefinition("PFA", FileDefinition.FILE_UPDATE_N_ADD);
        FileDefinition fdb = new FileDefinition("PFB", FileDefinition.FILE_INQUIRY);
        rpg.addFile(fda);
        rpg.addFile(fdb);

        String expect1 = "";
        expect1 += "FPFA UF A E K DISK";
        expect1 += "\n";
        expect1 += "FPFB IF   E K DISK";
        expect1 += "\n";
        String output1 = rpg.toString();

        assertTrue(expect1.compareTo(output1) == 0);
    }

    /**
     * Test toString Control Definition: Delete
     */
    public void testControlDefinitionDelete()throws Exception{

        RPG rpg = new RPG();

        FileDefinition fd = new FileDefinition("PFA", FileDefinition.FILE_UPDATE_N_ADD);
        rpg.addFile(fd);

        ControlDefinition loop = new ControlDefinition();
        loop.setType(ControlDefinition.CONTROL_LOOP_FILE);
        loop.setParameter("PFA");

        ControlDefinition delete = new ControlDefinition();
        delete.setType(ControlDefinition.CONTROL_DELETE);
        delete.setParameter("PFA");
        loop.addEmbed(delete);
        rpg.addControl(loop);

        String expect1 = "";
        expect1 += "FPFA UF A E K DISK";
        expect1 += "\n";
        expect1 += "C READ PFA";
        expect1 += "\n";
        expect1 += "C DOW NOT %EOF(PFA)";
        expect1 += "\n";
        expect1 += "C DELETE PFA";
        expect1 += "\n";
        expect1 += "C READ PFA";
        expect1 += "\n";
        expect1 += "C ENDDO";
        expect1 += "\n";
        String output1 = rpg.toString();

        assertTrue(expect1.compareTo(output1) == 0);
    }

    /**
     * Test toString Control Definition: Update 
     */
    public void testControlDefinitionUpdate()throws Exception{

        RPG rpg = new RPG();
        FileDefinition fd = new FileDefinition("PFA", FileDefinition.FILE_UPDATE_ONLY);
        rpg.addFile(fd);

        ControlDefinition loop = new ControlDefinition();
        loop.setType(ControlDefinition.CONTROL_LOOP_FILE);
        loop.setParameter("PFA");

        ControlDefinition update = new ControlDefinition();
        update.setType(ControlDefinition.CONTROL_UPDATE);
        update.setParameter("PFA");

        ControlDefinition eval = new ControlDefinition();
        eval.setType(ControlDefinition.CONTROL_EVAL);
        eval.setParameter("FA001=P");

        loop.addEmbed(eval);
        loop.addEmbed(update);
        rpg.addControl(loop);

        String expect1 = "";
        expect1 += "FPFA UF   E K DISK";
        expect1 += "\n";
        expect1 += "C READ PFA";
        expect1 += "\n";
        expect1 += "C DOW NOT %EOF(PFA)";
        expect1 += "\n";
        expect1 += "C EVAL FA001=P";
        expect1 += "\n";
        expect1 += "C UPDATE PFA";
        expect1 += "\n";
        expect1 += "C READ PFA";
        expect1 += "\n";
        expect1 += "C ENDDO";
        expect1 += "\n";
        String output1 = rpg.toString();

        assertTrue(expect1.compareTo(output1) == 0);
    }

    /**
     * Test toString Control Definition: IF + WRITE
     */
    public void testControlDefinitionIfWrite()throws Exception{

        RPG rpg = new RPG();
        FileDefinition fda = new FileDefinition("PFA", FileDefinition.FILE_UPDATE_ONLY);
        FileDefinition fdb = new FileDefinition("PFB", FileDefinition.FILE_INQUIRY);
        rpg.addFile(fda);
        rpg.addFile(fdb);

        ControlDefinition loop = new ControlDefinition();
        loop.setType(ControlDefinition.CONTROL_LOOP_FILE);
        loop.setParameter("PFB");

        ControlDefinition write = new ControlDefinition();
        write.setType(ControlDefinition.CONTROL_WRITE);
        write.setParameter("PFA");

        ControlDefinition ifClause = new ControlDefinition();
        ifClause.setType(ControlDefinition.CONTROL_IF);
        ifClause.setParameter("FB001=P");

        ControlDefinition eval = new ControlDefinition();
        eval.setType(ControlDefinition.CONTROL_EVAL);
        eval.setParameter("FA001=FB001");

        loop.addEmbed(ifClause);
        ifClause.addEmbed(eval);
        ifClause.addEmbed(write);
        rpg.addControl(loop);

        String expect1 = "";
        expect1 += "FPFA UF   E K DISK";
        expect1 += "\n";
        expect1 += "FPFB IF   E K DISK";
        expect1 += "\n";
        expect1 += "C READ PFB";
        expect1 += "\n";
        expect1 += "C DOW NOT %EOF(PFB)";
        expect1 += "\n";
        expect1 += "C IF FB001=P";
        expect1 += "\n";
        expect1 += "C EVAL FA001=FB001";
        expect1 += "\n";
        expect1 += "C WRITE PFA";
        expect1 += "\n";
        expect1 += "C ENDIF";
        expect1 += "\n";
        expect1 += "C READ PFB";
        expect1 += "\n";
        expect1 += "C ENDDO";
        expect1 += "\n";
        String output1 = rpg.toString();

        echo(expect1);
        echo(output1);

        assertTrue(expect1.compareTo(output1) == 0);
    }
    /**
     * Helper function 
     */
    private void echo(String s){
        System.out.println("***DEBUG***" + s);
    }

}
