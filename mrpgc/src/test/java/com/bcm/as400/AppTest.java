package com.bcm.as400;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * Unit test for simple App.
 */
public class AppTest extends TestCase{

    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public AppTest( String testName ){
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite(){
        return new TestSuite( AppTest.class );
    }

    /**
     * Case 1: PFA = PFB
     */
    public void testCase1()throws Exception{
        String input = "PFA=PFB";
        MCompiler c = new MCompiler(input);
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

        System.out.println("###expect outcome###");
        System.out.println(expectOutput);
        String output = c.compile();
        assertTrue(expectOutput.compareTo(output) == 0);
    }

    /**
     * Case 2: PFA = PFB + PFC
    public void testCase2(){
        String input = "PFA=PFB+PFC";
        MCompiler c = new MCompiler(input);
        String expectOutput = "";
        expectOutput += "FPFA UF A E K DISK";
        expectOutput += "FPFB IF E K DISK";
        expectOutput += "FPFC IF E K DISK";
        expectOutput += "C READ PFA";
        expectOutput += "C DOW NOT %EOF(PFA)";
        expectOutput += "C DELETE PFA";
        expectOutput += "C READ PFA";
        expectOutput += "C ENDDO";
        expectOutput += "C READ PFB";
        expectOutput += "C DOW NOT %EOF(PFB)";
        expectOutput += "C EVAL FA001 = FB001";
        expectOutput += "C WRITE PFA";
        expectOutput += "C READ PFB";
        expectOutput += "C ENDDO";
        expectOutput += "C READ PFC";
        expectOutput += "C DOW NOT %EOF(PFC)";
        expectOutput += "C EVAL FA001 = FC001";
        expectOutput += "C WRITE PFA";
        expectOutput += "C READ PFC";
        expectOutput += "C ENDDO";
        String output = c.compile();
        assertTrue(expectOutput.compareTo(output) == 0);
    }
     */

    /**
     * Case 3:PFA = PFA + PFB
    public void testCase3(){
        String input = "PFA=PFA+PFB";
        MCompiler c = new MCompiler(input);
        String expectOutput = "";

        expectOutput += "FPFA UF A E K DISK";
        expectOutput += "FPFB IF E K DISK";
        expectOutput += "C READ PFB";
        expectOutput += "C DOW NOT %EOF(PFB)";
        expectOutput += "C EVAL FA001 = FB001";
        expectOutput += "C WRITE PFA";
        expectOutput += "C READ PFB";
        expectOutput += "C ENDDO";
        String output = c.compile();
        assertTrue(expectOutput.compareTo(output) == 0);
    }
     */

}
