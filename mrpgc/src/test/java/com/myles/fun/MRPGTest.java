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
     * Atomize: A=A+B+C
     */
    public void testAtomize1()throws Exception{
        String input = "A=A+B+C";
        MRPG mrpg = new MRPG(input);
        mrpg.atomize(); // simplify its statements into atoms
        String expect = "";
        expect += "A=A+B";
        expect += "\n";
        expect += "A=A+C";
        expect += "\n";
        String output = mrpg.toString();
        assertTrue(expect.compareTo(output) == 0);
    }

    /**
     * Atomize: A=A+B*C
     */
    public void testAtomize2()throws Exception{
        String input = "A=A+B*C";
        MRPG mrpg = new MRPG(input);
        mrpg.atomize(); // simplify its statements into atoms
        String expect = "";
        expect += "A=A+B";
        expect += "\n";
        expect += "A=A*C";
        expect += "\n";
        String output = mrpg.toString();
        assertTrue(expect.compareTo(output) == 0);
    }

    /**
     * Atomize: A=A*B+C
     */
    public void testAtomize3()throws Exception{
        String input = "A=A*B+C";
        MRPG mrpg = new MRPG(input);
        mrpg.atomize(); // simplify its statements into atoms
        String expect = "";
        expect += "A=A*B";
        expect += "\n";
        expect += "A=A+C";
        expect += "\n";
        String output = mrpg.toString();
        assertTrue(expect.compareTo(output) == 0);
    }

    /**
     * Helper function 
     */
    private void echo(String s){
        System.out.println("***DEBUG***" + s);
    }

}
