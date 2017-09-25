package com.myles.fun;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 *
 */
public class MRPGTest extends TestCase{

    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public MRPGTest( String testName ){
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite(){
        return new TestSuite( MRPGTest.class );
    }

    /**
     * Case 1: Test toString of PFA=PFB
     */
    public void testAssignOneToOneWSetter()throws Exception{
        MRPG mrpg = new MRPG();
        mrpg.setAssignee("PFA");
        mrpg.setAssignor("PFB");
        String expectOutput = "PFA=PFB"; 
        String output = mrpg.toString();
        assertTrue(expectOutput.compareTo(output) == 0);
    }

    /**
     * Case 1: Test toString of PFA=PFB
     */
    public void testAssignOneToOneWConstructor()throws Exception{
        MRPG mrpg = new MRPG("PFA=PFB");
        String expectOutput = "PFA=PFB"; 
        String output = mrpg.toString();
        assertTrue(expectOutput.compareTo(output) == 0);
    }

    private void echo(String s){
        System.out.println("***DEBUG***" + s);
    }

}
