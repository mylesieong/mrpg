package com.myles.fun;

import java.util.List;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import com.myles.fun.RPG.FileDefinition;
import com.myles.fun.RPG.ControlDefinition;

/**
 * Unit test for simple App.
 */
public class MRPGcTest extends TestCase{

    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public MRPGcTest( String testName ){
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite(){
        return new TestSuite( MRPGcTest.class );
    }

    /**
     * Case 1: PFA = PFB
     */
    public void testCase1()throws Exception{
        String input = "PFA=PFB";
        MRPG mrpg = new MRPG(input);
        RPG rpg = MRPGc.compile(mrpg);

        // Check file definitions
        List<FileDefinition> files = rpg.getFileDefinitions();
        assertTrue(files.size()==2);
        for (FileDefinition fd: files){
            String filename = fd.getFile();
            assertTrue(filename.compareTo("PFA") == 0
                    || filename.compareTo("PFB") == 0);
            if (filename.compareTo("PFA") == 0){
                assertTrue(fd.getType() == FileDefinition.FILE_UPDATE_N_ADD);
            }
            if (filename.compareTo("PFB") == 0){
                assertTrue(fd.getType() == FileDefinition.FILE_INQUIRY);
            }
        }

        // Check loop control definitions
        List<ControlDefinition> controls = rpg.getControlDefinitions();
        assertTrue(controls.size()==1);
        ControlDefinition loopControl = controls.get(0);
        assertTrue(loopControl.getType()==ControlDefinition.CONTROL_LOOP_FILE);
        assertTrue(loopControl.getParameter().compareTo("PFB")==0);

        // Check eval & write controls 
        List<ControlDefinition> inLoopControls = loopControl.getEmbeds();
        assertTrue(inLoopControls.size()==2);
        ControlDefinition evalControl = inLoopControls.get(0);
        assertTrue(evalControl.getType()==ControlDefinition.CONTROL_EVAL);
        assertTrue(evalControl.getParameter().compareTo("PFA001=PFB001")==0);
        ControlDefinition writeControl = inLoopControls.get(1);
        assertTrue(writeControl.getType()==ControlDefinition.CONTROL_WRITE);
        assertTrue(writeControl.getParameter().compareTo("PFA")==0);

    }

    /**
     * Case 2: PFA = PFB + PFC
     */
    public void testCase2()throws Exception{
        String input = "PFA=PFB+PFC";
        MRPG mrpg = new MRPG(input);
        RPG rpg = MRPGc.compile(mrpg);

        // Check file definitions
        List<FileDefinition> files = rpg.getFileDefinitions();
        assertTrue(files.size()==3);
        for (FileDefinition fd: files){
            String filename = fd.getFile();
            assertTrue(filename.compareTo("PFA") == 0
                    || filename.compareTo("PFB") == 0
                    || filename.compareTo("PFC") == 0
                    );
            if (filename.compareTo("PFA") == 0){
                assertTrue(fd.getType() == FileDefinition.FILE_UPDATE_N_ADD);
            }
            if (filename.compareTo("PFB") == 0){
                assertTrue(fd.getType() == FileDefinition.FILE_INQUIRY);
            }
            if (filename.compareTo("PFC") == 0){
                assertTrue(fd.getType() == FileDefinition.FILE_INQUIRY);
            }
        }

        // Check loop control definitions
        List<ControlDefinition> controls = rpg.getControlDefinitions();
        assertTrue(controls.size()==2);
        ControlDefinition loop1 = controls.get(0);
        assertTrue(loop1.getType()==ControlDefinition.CONTROL_LOOP_FILE);
        assertTrue(loop1.getParameter().compareTo("PFB")==0);
        ControlDefinition loop2 = controls.get(1);
        assertTrue(loop2.getType()==ControlDefinition.CONTROL_LOOP_FILE);
        assertTrue(loop2.getParameter().compareTo("PFC")==0);

        // Check eval & write controls in loop1
        List<ControlDefinition> inLoopControls = loop1.getEmbeds();
        assertTrue(inLoopControls.size()==2);
        ControlDefinition evalControl = inLoopControls.get(0);
        assertTrue(evalControl.getType()==ControlDefinition.CONTROL_EVAL);
        assertTrue(evalControl.getParameter().compareTo("PFA001=PFB001")==0);
        ControlDefinition writeControl = inLoopControls.get(1);
        assertTrue(writeControl.getType()==ControlDefinition.CONTROL_WRITE);
        assertTrue(writeControl.getParameter().compareTo("PFA")==0);

        // Check eval & write controls in loop2
        inLoopControls = loop2.getEmbeds();
        assertTrue(inLoopControls.size()==2);
        evalControl = inLoopControls.get(0);
        assertTrue(evalControl.getType()==ControlDefinition.CONTROL_EVAL);
        assertTrue(evalControl.getParameter().compareTo("PFA001=PFC001")==0);
        writeControl = inLoopControls.get(1);
        assertTrue(writeControl.getType()==ControlDefinition.CONTROL_WRITE);
        assertTrue(writeControl.getParameter().compareTo("PFA")==0);
    }

    /**
     * Case 3:PFA = PFA + PFB
     */
    public void testCase3()throws Exception{
        String input = "PFA=PFA+PFB";
        MRPG mrpg = new MRPG(input);
        RPG rpg = MRPGc.compile(mrpg);

        // Check file definitions
        List<FileDefinition> files = rpg.getFileDefinitions();
        assertTrue(files.size()==2);
        for (FileDefinition fd: files){
            String filename = fd.getFile();
            assertTrue(filename.compareTo("PFA") == 0
                    || filename.compareTo("PFB") == 0
                    );
            if (filename.compareTo("PFA") == 0){
                assertTrue(fd.getType() == FileDefinition.FILE_UPDATE_N_ADD);
            }
            if (filename.compareTo("PFB") == 0){
                assertTrue(fd.getType() == FileDefinition.FILE_INQUIRY);
            }
        }

        // Check loop control definitions
        List<ControlDefinition> controls = rpg.getControlDefinitions();
        assertTrue(controls.size()==2);
        ControlDefinition loop1 = controls.get(0);
        assertTrue(loop1.getType()==ControlDefinition.CONTROL_LOOP_FILE);
        assertTrue(loop1.getParameter().compareTo("PFA")==0);
        ControlDefinition loop2 = controls.get(1);
        assertTrue(loop2.getType()==ControlDefinition.CONTROL_LOOP_FILE);
        assertTrue(loop2.getParameter().compareTo("PFB")==0);

        // Check eval & write controls in loop1
        List<ControlDefinition> inLoopControls = loop1.getEmbeds();
        assertTrue(inLoopControls.size()==2);
        ControlDefinition eval = inLoopControls.get(0);
        assertTrue(eval.getType()==ControlDefinition.CONTROL_EVAL);
        assertTrue(eval.getParameter().compareTo("PFA001=PFA001")==0);
        ControlDefinition update = inLoopControls.get(1);
        assertTrue(update.getType()==ControlDefinition.CONTROL_UPDATE);
        assertTrue(update.getParameter().compareTo("PFA")==0);

        // Check eval & write controls in loop2
        inLoopControls = loop2.getEmbeds();
        assertTrue(inLoopControls.size()==2);
        eval = inLoopControls.get(0);
        assertTrue(eval.getType()==ControlDefinition.CONTROL_EVAL);
        assertTrue(eval.getParameter().compareTo("PFA001=PFB001")==0);
        ControlDefinition write = inLoopControls.get(1);
        assertTrue(write.getType()==ControlDefinition.CONTROL_WRITE);
        assertTrue(write.getParameter().compareTo("PFA")==0);

    }

    /**
     * Case 4:PFA = PFB * ( PFB001 = P )
     */
    public void testCase4()throws Exception{
        String input = "PFA=PFB*(PFB001=P)";
        MRPG mrpg = new MRPG(input);
        RPG rpg = MRPGc.compile(mrpg);

        echo(rpg.toString());

        // Check file definitions
        List<FileDefinition> files = rpg.getFileDefinitions();
        assertTrue(files.size()==2);
        for (FileDefinition fd: files){
            String filename = fd.getFile();
            assertTrue(filename.compareTo("PFA") == 0
                    || filename.compareTo("PFB") == 0
                    );
            if (filename.compareTo("PFA") == 0){
                assertTrue(fd.getType() == FileDefinition.FILE_UPDATE_N_ADD);
            }
            if (filename.compareTo("PFB") == 0){
                assertTrue(fd.getType() == FileDefinition.FILE_INQUIRY);
            }
        }

        // Check loop control definitions
        List<ControlDefinition> controls = rpg.getControlDefinitions();
        assertTrue(controls.size()==1);
        ControlDefinition loop1 = controls.get(0);
        assertTrue(loop1.getType()==ControlDefinition.CONTROL_LOOP_FILE);
        assertTrue(loop1.getParameter().compareTo("PFB")==0);

        // Check delete in loop1
        // TODO
        /*
        List<ControlDefinition> inLoopControls;
        inLoopControls = loop1.getEmbeds();
        assertTrue(inLoopControls.size()==1);
        ControlDefinition delete = inLoopControls.get(0);
        assertTrue(delete.getType()==ControlDefinition.CONTROL_DELETE);
        assertTrue(delete.getParameter().compareTo("PFA")==0);
        */

        // Check eval & write controls in loop2
        List<ControlDefinition> inLoopControls = loop1.getEmbeds();
        assertTrue(inLoopControls.size()==3);
        ControlDefinition eval1 = inLoopControls.get(0);
        assertTrue(eval1.getType()==ControlDefinition.CONTROL_EVAL);
        assertTrue(eval1.getParameter().compareTo("PFB001=P")==0);
        ControlDefinition eval2 = inLoopControls.get(1);
        assertTrue(eval2.getType()==ControlDefinition.CONTROL_EVAL);
        assertTrue(eval2.getParameter().compareTo("PFA001=PFB001")==0);
        ControlDefinition write = inLoopControls.get(2);
        assertTrue(write.getType()==ControlDefinition.CONTROL_WRITE);
        assertTrue(write.getParameter().compareTo("PFA")==0);

    }

    /**
     * Case 5:PFA = PFA * ( FA001 = P )
     */
    public void testCase5()throws Exception{
        String input = "PFA=PFA*(FA001=P)";
        assertTrue(true);
    }

    /**
     * helper function 
     */
    private void echo(String s){
        System.out.println("***debug***" + s);
    }

}
