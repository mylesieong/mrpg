package com.myles.fun;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 *
 */
public class MRPGStatementTest extends TestCase{

    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public MRPGStatementTest( String testName ){
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite(){
        return new TestSuite( MRPGStatementTest.class );
    }

    /**
     * Test toString of PFA=PFB
     */
    public void testAssignOneToOneWSetter()throws Exception{
        MRPGStatement m = new MRPGStatement();
        m.setAssignee("PFA");
        m.setAssignor("PFB");
        String expectOutput = "PFA=PFB"; 
        String output = m.toString();
        assertTrue(expectOutput.compareTo(output) == 0);
    }

    /**
     * Test toString of PFA=PFB
     */
    public void testAssignOneToOneWConstructor()throws Exception{
        MRPGStatement m = new MRPGStatement("PFA=PFB");

        String expect1 = "PFA=PFB"; 
        String output1 = m.toString();

        String expect2 = "PFB";
        String output2 = m.getAssignor();

        String expect3 = "PFA";
        String output3 = m.getAssignee();

        assertTrue(expect1.compareTo(output1)==0
                && expect2.compareTo(output2)==0
                && expect3.compareTo(output3)==0);
    }

    /**
     * Test toString of PFA=PFB+PFC
     */
    public void testAssignOneToTwoWConstructor()throws Exception{
        MRPGStatement m = new MRPGStatement("PFA=PFB+PFC");

        String expect1 = "PFA=PFB+PFC"; 
        String output1 = m.toString();

        String expect2 = "PFA";
        String output2 = m.getAssignee();

        String expect3 = "PFB";
        String output3 = m.getAssignor();

        String expect4 = "+";
        String output4 = m.getOperation().getOperator();

        String expect5 = "PFC";
        String output5 = m.getOperation().getParameter();

        assertTrue(expect1.compareTo(output1)==0
                && expect2.compareTo(output2)==0
                && expect3.compareTo(output3)==0
                && expect4.compareTo(output4)==0
                && expect5.compareTo(output5)==0);
    }

    /**
     * Test toString of PFA=PFA*PFB
     */
    public void testAssignOneToTwoIncludeSelfWConstructor()throws Exception{
        MRPGStatement m = new MRPGStatement("PFA=PFA*PFB");

        String expect1 = "PFA=PFA*PFB"; 
        String output1 = m.toString();

        String expect2 = "PFA";
        String output2 = m.getAssignee();

        String expect3 = "PFA";
        String output3 = m.getAssignor();

        String expect4 = "*";
        String output4 = m.getOperation().getOperator();

        String expect5 = "PFB";
        String output5 = m.getOperation().getParameter();

        assertTrue(expect1.compareTo(output1)==0
                && expect2.compareTo(output2)==0
                && expect3.compareTo(output3)==0
                && expect4.compareTo(output4)==0
                && expect5.compareTo(output5)==0);
    }

    /**
     * Helper function
     */
    private void echo(String s){
        System.out.println("***DEBUG***" + s);
    }

}
