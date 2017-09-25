package com.myles.fun;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

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
        rpg.addFile("PFA", RPG.FILE_UPDATE_N_ADD);
        rpg.addFile("PFB", RPG.FILE_INQUIRY);

        String expect1 = "";
        expect1 += "FPFA UF A E K DISK";
        expect1 += "\n";
        expect1 += "FPFB IF   E K DISK";
        expect1 += "\n";
        String output1 = rpg.toString();

        assertTrue(expect1.compareTo(output1) == 0);
    }

    /**
     * Test toString Control Definition
     */
    public void testControlDefinition()throws Exception{

        RPG rpg = new RPG();
        rpg.addFile("PFA", RPG.FILE_UPDATE_N_ADD);
        rpg.addControl("PFA", RPG.CONTROL_DELETE);

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
