package com.bcm.as400;

/**
 * Hello world!
 *
 */
public class App {
    public static void main( String[] args ){
        case1();
    }

    public static void case1() {
        String input = "PFA = PFB";
        String output = compile(input);
        System.out.println(output);
    }

    public static String compile(String input){
        String output = "";
        output += "FPFB IF E K DISK";
        output += "\n";
        output += "C READ PFB";
        output += "\n";
        output += "C DOW NOT %EOF(PFB)";
        output += "\n";
        output += "C EVAL FA001 = FB001";
        output += "\n";
        output += "C WRITE PFA";
        output += "\n";
        output += "C READ PFB";
        output += "\n";
        output += "C ENDDO";
        return output;
    }
}
