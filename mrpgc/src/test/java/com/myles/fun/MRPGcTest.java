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
        assertTrue(files != null);
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
        assertTrue(true);
    }

    /**
     * Case 3:PFA = PFA + PFB
     */
    public void testCase3()throws Exception{
        String input = "PFA=PFA+PFB";
        assertTrue(true);
    }

    /**
     * Case 4:PFA = PFB * ( FB001 = P )
     */
    public void testCase4()throws Exception{
        String input = "PFA=PFB*(FB001=P)";
        assertTrue(true);
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
