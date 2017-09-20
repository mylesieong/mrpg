1.00 0       ************************************************************************  
2.00 160620       * REFERENCE NO. : CHG-0200-16 (D6200)                                  *  
3.00 0       * AUTHOR        : Myles Ieong                                          *  
4.00 0       * USER ID.      : BI77PGM                                              *  
5.00 0       * DATE WRITTEN  : 22 Apr 2016                                          *  
6.00 160617       * DESCRPITION   : Update P flags daily when next payment day change    *  
7.00 0       *                 LNSTFPSTF-'P':postpone fee posting(will be activated)*  
8.00 160810 6200B *                           'X':fee posting at the day end(execute)    *  
9.00 0       *                           'C':fee posting actin finished             *  
10.00 0       *                           'N':not need to post fee                   *  
11.00 0       *                 LNSTFPSTGL-'P':postpone GL posting(will be activated)*  
12.00 160810 6200B *                           'X':GL posting at the day end(execute)     *  
13.00 0       *                           'C':GL posting action finished             *  
14.00 0       *                           'N':not need to post GL                    *  
15.00 0       *                 LNSTFSMS- 'P':postpone SMS alert (will be activated) *  
16.00 160810 6200B *                           'X':SMS alert at the day end(execute)      *  
17.00 0       *                           'C':SMS alert action finished              *  
18.00 0       *                           'N':not need to send SMS alert             *  
19.00 0       ************************************************************************  
20.00 0      H DATEDIT(*YMD) DATFMT(*ISO) TIMFMT(*HMS)                                  
21.00 160617      FLNP003    IF   E           K DISK                                         
22.00 160617      FLNSTPF    UF   E           K DISK                                         
23.00 160617      D********************************************************************      
24.00 160617      D*                      VARIABLE DEFINITION                         *      
25.00 160617      D********************************************************************      
26.00 0      DTODAY            S              8P 0                                      
27.00 160617      DFTODAY           S               D   DATFMT(*ISO) INZ(*SYS)               
28.00 160617      DNPD              S              8P 0                                      
29.00 160617      DFNPD             S               D   DATFMT(*ISO) INZ(*SYS)               
30.00 160617      C********************************************************************      
31.00 160617      C*                         FILE KEY LIST                            *      
32.00 160617      C********************************************************************      
33.00 160617      C     KLNP003       KLIST                                                  
34.00 160617      C                   KFLD                    KLNBK             3 0          
35.00 160617      C                   KFLD                    KLNNOTE          12 0          
36.00 160617      C                   KFLD                    KLNINDR           1            
37.00 160617      C*                                                                         
38.00 160617      C********************************************************************      
39.00 160617      C*                          MAIN ROUTINE                            *      
40.00 160617      C********************************************************************      
41.00 160617      C*                                                                         
42.00 160617      C*    Get today in YYYYMMDD                                                
43.00 160617      C*                                                                         
44.00 0      C                   CALL      'DICBSYMD'                                   
45.00 160506      C                   PARM                    TODAY                          
47.00 160617      C                   MOVE      TODAY         FTODAY                         
48.00 160617      C*                                                                         
49.00 160617      C*    Iterate lnstpf and process all record with P flag with NPD           
50.00 160617      C*                                                                         
51.00 0      C                   READ      LNSTPF                                       
52.00 160422      C                   DOW       NOT %EOF(LNSTPF)                             
53.00 160617      C**                                                                        
54.00 160617      C**   Chain LNP003 to get NPD                                              
55.00 160617      C**                                                                        
56.00 160617      C                   MOVE      1             KLNBK                          
57.00 160617      C                   MOVE      LNSTLNNOTE    KLNNOTE                        
58.00 160617      C                   MOVE      ' '           KLNINDR                        
59.00 160617      C                                                                          
60.00 160617      C     KLNP003       CHAIN     LNP003                                       
61.00 160617      C                   IF        %FOUND(LNP003)                               
62.00 160617      C                                                                          
62.01 160720      C                   EVAL      NPD = -1                                     
63.00 160617      C                   IF        LNBLDT<>0                                    
64.00 160617      C                   CALL      'DFDDTOYY'                                   
65.00 160617      C                   PARM                    LNBLDT                         
66.00 160617      C                   PARM                    NPD                            
67.00 160617      C                   MOVE      NPD           FNPD                           
68.00 160617      C                   ELSE                                                   
69.00 160617      C                   CALL      'DFJJTOYY'                                   
70.00 160617      C                   PARM                    LNSCDT                         
71.00 160617      C                   PARM                    NPD                            
72.00 160617      C                   MOVE      NPD           FNPD                           
73.00 160617      C                   ENDIF                                                  
74.00 160617      C                                                                          
75.00 160617      C                   ELSE                                                   
76.00 160617      C                                                                          
77.00 160617      C                   EVAL      NPD=-1                                       
78.00 160617      C                                                                          
79.00 160617      C                   ENDIF                                                  
80.00 160617      C                                                                          
81.00 160617      C**                                                                        
82.00 160617      C**   Update flag lnstfpstf                                                
83.00 160617      C**                                                                        
84.00 160720      C                   IF        LNSTFPSTF='P' AND (%SUBDT(FNPD:*MONTHS)<>    
85.00 160720      C                             %SUBDT(FTODAY:*MONTHS) or NPD=TODAY)         
86.00 160810 6200BC                   EVAL      LNSTFPSTF='X'                                
87.00 0      C                   ENDIF                                                  
88.00 160617      C**                                                                        
89.00 160617      C**   Update flag lnstfpstgl                                               
90.00 160617      C**                                                                        
91.00 160720      C                   IF        LNSTFPSTGL='P' AND (%SUBDT(FNPD:*MONTHS)<>   
92.00 160720      C                             %SUBDT(FTODAY:*MONTHS) or NPD=TODAY)         
93.00 160810 6200BC                   EVAL      LNSTFPSTGL='X'                               
94.00 0      C                   ENDIF                                                  
95.00 160617      C**                                                                        
96.00 160617      C**   Update flag lnstfsms                                                 
97.00 160617      C**                                                                        
98.00 160720      C                   IF        LNSTFSMS='P' AND (%SUBDT(FNPD:*MONTHS)<>     
99.00 160720      C                             %SUBDT(FTODAY:*MONTHS) or NPD=TODAY)         
100.00 160810 6200BC                   EVAL      LNSTFSMS='X'                                 
101.00 0      C                   ENDIF                                                  
102.00 160617      C**                                                                        
103.00 160617      C**   Update the pf                                                        
104.00 160617      C**                                                                        
105.00 160422      C                   UPDATE    RLNSTPF                                      
106.00 160617      C**                                                                        
107.00 160617      C**   Read next record in pf                                               
108.00 160617      C**                                                                        
109.00 160422      C                   READ      LNSTPF                                       
110.00 160617      C                                                                          
111.00 0      C                   ENDDO                                                  
112.00 160617      C                                                                          
113.00 0      C                   SETON                                        LR        
114.00 160617      C*                                                                         
