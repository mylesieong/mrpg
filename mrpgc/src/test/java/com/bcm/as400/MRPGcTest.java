package com.bcm.as400;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

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
        MRPGc c = new MRPGc(input);
        String expectOutput = ""; 

        expectOutput += "FPFA UF A E K DISK";
        expectOutput += "\n";
        expectOutput += "FPFB IF   E K DISK";
        expectOutput += "\n";
        expectOutput += "C READ PFA";
        expectOutput += "\n";
        expectOutput += "C DOW NOT %EOF(PFA)";
        expectOutput += "\n";
        expectOutput += "C DELETE PFA";
        expectOutput += "\n";
        expectOutput += "C READ PFA";
        expectOutput += "\n";
        expectOutput += "C ENDDO";
        expectOutput += "\n";
        expectOutput += "C READ PFB";
        expectOutput += "\n";
        expectOutput += "C DOW NOT %EOF(PFB)";
        expectOutput += "\n";
        expectOutput += "C EVAL PFA = PFB";
        expectOutput += "\n";
        expectOutput += "C WRITE PFA";
        expectOutput += "\n";
        expectOutput += "C READ PFB";
        expectOutput += "\n";
        expectOutput += "C ENDDO";
        expectOutput += "\n";

        String output = c.compile();
        assertTrue(expectOutput.compareTo(output) == 0);
    }

    /**
     * Case 2: PFA = PFB + PFC
     */
    public void testCase2()throws Exception{
        String input = "PFA=PFB+PFC";
        MRPGc c = new MRPGc(input);
        String expectOutput = "";
        expectOutput += "FPFA UF A E K DISK";
        expectOutput += "\n";
        expectOutput += "FPFB IF   E K DISK";
        expectOutput += "\n";
        expectOutput += "FPFC IF   E K DISK";
        expectOutput += "\n";
        expectOutput += "C READ PFA";
        expectOutput += "\n";
        expectOutput += "C DOW NOT %EOF(PFA)";
        expectOutput += "\n";
        expectOutput += "C DELETE PFA";
        expectOutput += "\n";
        expectOutput += "C READ PFA";
        expectOutput += "\n";
        expectOutput += "C ENDDO";
        expectOutput += "\n";
        expectOutput += "C READ PFB";
        expectOutput += "\n";
        expectOutput += "C DOW NOT %EOF(PFB)";
        expectOutput += "\n";
        expectOutput += "C EVAL PFA = PFB";
        expectOutput += "\n";
        expectOutput += "C WRITE PFA";
        expectOutput += "\n";
        expectOutput += "C READ PFB";
        expectOutput += "\n";
        expectOutput += "C ENDDO";
        expectOutput += "\n";
        expectOutput += "C READ PFC";
        expectOutput += "\n";
        expectOutput += "C DOW NOT %EOF(PFC)";
        expectOutput += "\n";
        expectOutput += "C EVAL PFA = PFC";
        expectOutput += "\n";
        expectOutput += "C WRITE PFA";
        expectOutput += "\n";
        expectOutput += "C READ PFC";
        expectOutput += "\n";
        expectOutput += "C ENDDO";
        expectOutput += "\n";

        String output = c.compile();
        assertTrue(expectOutput.compareTo(output) == 0);
    }

    /**
     * Case 3:PFA = PFA + PFB
     */
    public void testCase3()throws Exception{
        String input = "PFA=PFA+PFB";
        MRPGc c = new MRPGc(input);
        String expectOutput = "";

        expectOutput += "FPFA UF A E K DISK";
        expectOutput += "\n";
        expectOutput += "FPFB IF   E K DISK";
        expectOutput += "\n";
        expectOutput += "C READ PFB";
        expectOutput += "\n";
        expectOutput += "C DOW NOT %EOF(PFB)";
        expectOutput += "\n";
        expectOutput += "C EVAL PFA = PFB";
        expectOutput += "\n";
        expectOutput += "C WRITE PFA";
        expectOutput += "\n";
        expectOutput += "C READ PFB";
        expectOutput += "\n";
        expectOutput += "C ENDDO";
        expectOutput += "\n";

        String output = c.compile();
        assertTrue(expectOutput.compareTo(output) == 0);
    }

    /**
     * Case 4:PFA = PFB * ( FB001 = P )
     */
    public void testCase4()throws Exception{
        String input = "PFA=PFB*(FB001=P)";
        MRPGc c = new MRPGc(input);
        String expectOutput = "";

        expectOutput += "FPFA UF A E K DISK";
        expectOutput += "\n";
        expectOutput += "FPFB IF   E K DISK";
        expectOutput += "\n";
        expectOutput += "C READ PFA";
        expectOutput += "\n";
        expectOutput += "C DOW NOT %EOF(PFA)";
        expectOutput += "\n";
        expectOutput += "C DELETE PFA";
        expectOutput += "\n";
        expectOutput += "C READ PFA";
        expectOutput += "\n";
        expectOutput += "C ENDDO";
        expectOutput += "\n";
        expectOutput += "C READ PFB";
        expectOutput += "\n";
        expectOutput += "C DOW NOT %EOF(PFB)";
        expectOutput += "\n";
        expectOutput += "C EVAL FB001=P";
        expectOutput += "\n";
        expectOutput += "C EVAL PFA = PFB";
        expectOutput += "\n";
        expectOutput += "C WRITE PFA";
        expectOutput += "\n";
        expectOutput += "C READ PFB";
        expectOutput += "\n";
        expectOutput += "C ENDDO";
        expectOutput += "\n";

        String output = c.compile();
        assertTrue(expectOutput.compareTo(output) == 0);
    }

    /**
     * Case 5:PFA = PFA * ( FA001 = P )
     */
    public void testCase5()throws Exception{
        String input = "PFA=PFA*(FA001=P)";
        MRPGc c = new MRPGc(input);
        String expectOutput = "";

        expectOutput += "FPFA UF A E K DISK";
        expectOutput += "\n";
        expectOutput += "C READ PFA";
        expectOutput += "\n";
        expectOutput += "C DOW NOT %EOF(PFA)";
        expectOutput += "\n";
        expectOutput += "C EVAL FA001=P";
        expectOutput += "\n";
        expectOutput += "C UPDATE PFA";
        expectOutput += "\n";
        expectOutput += "C READ PFA";
        expectOutput += "\n";
        expectOutput += "C ENDDO";
        expectOutput += "\n";

        System.out.println("###expect outcome-case###");
        System.out.println(expectOutput);
        String output = c.compile();
        System.out.println("###actual outcome-case###");
        System.out.println(output);
        assertTrue(expectOutput.compareTo(output) == 0);
    }

}
