1.00 170227      H DATEDIT(*YMD) DATFMT(*ISO) TIMFMT(*HMS)                                                      
2.00 170227       **************************************************************************                    
3.00 170906       * REFERENCE NO. : CHG-0266-16 (D7266)                                                         
4.00 170227       * PROGRAM ID.   : CQRXEXT                                                                     
5.00 170828       * DESC          : Cheque QR Envelope Number Update PGM                                        
6.00 170227       * AUTHOR        : Myles Ieong                                                                 
7.00 170227       * USER ID.      : BI77PGM                                                                     
8.00 170828       * DATE WRITTEN  : 28/08/17                                                                    
9.00 170706       *                                                                                             
10.00 170227       **************************************************************************                    
11.00 170227      F**********************************************************************                        
12.00 170227      F*                         File Specification                         *                        
13.00 170227      F**********************************************************************                        
14.00 170906      FCQRXPF    IF   E           K DISK                                                             
15.00 170828      FCQRXENV   UF A E           K DISK                                                             
16.00 170227      F*                                                                                             
17.00 170227      C**********************************************************************                        
18.00 170227      C*                          MAIN PROGRAM                              *                        
19.00 170706      C**********************************************************************                        
20.00 170906       *    Iterate CQRXPF and write envelope number into CQRXENV                                    
21.00 170906      C                   READ      CQRXPF                                                           
22.00 170906      C                   DOW       NOT %EOF(CQRXPF)                                                 
23.00 170706      C                                                                                              
24.00 170906      C                   IF        CXENV <> ''                                                      
25.00 170906      C                   EVAL      CXEENV = CXENV                                                   
26.00 170906      C                   EVAL      CXEOBNK = CXOBNK                                                 
27.00 170906      C                   EVAL      CXETYP = CXTYP                                                   
28.00 170906      C                   EVAL      CXECPET = CXCPET                                                 
29.00 170906      C                   EVAL      CXECHQ = CXCHQ                                                   
30.00 170906      C                   EVAL      CXEAMT = CXAMT                                                   
31.00 170906      C                   EVAL      CXEONAM = CXONAM                                                 
32.00 170906      C                   EVAL      CXEOACT = CXOACT                                                 
33.00 170906      C                   EVAL      CXESTS = CXSTS                                                   
34.00 170906      C                   WRITE     RCQRXENV                                                         
35.00 170906      C                   ENDIF                                                                      
36.00 170906      C                                                                                              
37.00 170906      C                   READ      CQRXPF                                                           
38.00 170706      C                                                                                              
39.00 170706      C                   ENDDO                                                                      
40.00 170227      C                   SETON                                        LR                            
41.00 170906       **                                                                                            
