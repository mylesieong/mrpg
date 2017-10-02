package com.myles.fun;

import java.util.Scanner;

/**
 *
 */
public class App {

    public static void main( String[] args ){
        System.out.println("Please enter a valid mrpg statement:");
        Scanner scanner = new Scanner(System.in);
        String input = scanner.next();
        //String input = "PFA=PFB+PFC";
        MRPG mrpg = new MRPG(input);
        RPG rpg = MRPGc.compile(mrpg);
        System.out.println(rpg.toString());
    }

}
