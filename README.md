# mrpg project introduction 

Project mrpg (mask-rpgle) is a trial of a handy language wrapper mrpg that wraps rpgle to make it more simple and expressive. This project is inspired by python and panda.

The objective of this trial is to simplify the rpgle coding process while increase the productivity and reliablity of rpgle codes. And since it is not aimming to replace rpgle, mrpg does not cover all rpgle feature and might not be able to be deploy without a manual rpgle finishing. 

## How does mrpg simplify rpgle coding

Language wrapper mrpg is designed with these features:
1. Use equation to replace file reading and iteration
1. Use FILE / STMT to represent a selection
1. Use FILE - FILE to delete record 
1. Use FILE + FILE to represent a sum
1. Use FILE = FILE to clear and add 
1. Use FILE * STMT to represent a record-level action
1. Use FILE * FILE to represent a joint
1. Use FILE & FILE to represent a merge
1. Provide temp file varaible
1. Auto generate the file declaration
1. Implicit file field matching in FILE = FILE statement
1. Use key of file to joint, delete and update
1. Let user explicit define key on a file dynamically with []

## Showcases

Below present 3 cases that  demostrate the syntax od mrpg. For more case, please see other sample files in this repo.

### Case 1: Update a field in file

* RPGLE code that iterate PFA and update its field FA001 to 'A' if FA002 is 'B'
    ```
    FPFA UF E K DISK
    C READ PFA
    C DOW NOT %EOF(PFA)
    C IF FA002 = 'B'
    C EVAL FA001 = 'A'
    C ENDIF
    C READ PFA
    C ENDDO
    ```

* MRPG code that do the same thing
    ```
    PFA *= ($FA002 == 'B' ? $FA001 = 'A1' : $FA001 = 'A2')
    ```

### Case 2: Clear file

* RPGLE code that clear PFB 
    ```
    FPFA UF E K DISK
    * Clear PFA 
    C READ PFA
    C DOW NOT %EOF(PFA)
    C DELETE RPFA
    C READ PFA
    C ENDDO
    ```

* MRPG code that do the same thing
    ```
    PFA = 0
    ```

### Case 3: Iterates PFA to add new record to PFB if field FA001 <> ""

* RPGLE code 
    ```
    FPFA IF E K DISK
    FPFB UF A E K DISK
    * Iterate PFA
    C READ PFA
    C DOW NOT %EOF(PFA)
    C
    C IF FA001 <> ""
    C EVAL FB001 = FA001
    C EVAL FB002 = FA002
    C EVAL FB003 = FA003
    C EVAL FB004 = FA004
    C EVAL FB005 = FA003 * FA004
    C WRITE RPFB
    C ENDIF
    C
    C ENDDO
    ```

* MRPG code that do the same thing
    ```
    PFB += PFA / ($FA001 <> "") * ($FB005 = FB003 * FB004)
    ```
