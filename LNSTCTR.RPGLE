1.00 160620      H DATEDIT(*YMD) DATFMT(*ISO) TIMFMT(*HMS)                                  
2.00 0       ************************************************************************  
3.00 160620       * REFERENCE NO. : CHG-0200-16 (D6200)                                  *  
4.00 0       * AUTHOR        : Myles Ieong                                          *  
5.00 0       * USER ID.      : BI77PGM                                              *  
6.00 0       * DATE WRITTEN  : 29 Mar 2016                                          *  
7.00 0       * DESCRPITION   : Count transaction quantity and upate master LNSTPF   *  
7.01 160810 6200B *                 LNSTFPSTF-'P':postpone fee posting(will be activated)*  
7.02 160810 6200B *                           'X':fee posting at the day end             *  
7.03 160810 6200B *                           'C':fee posting actin finished             *  
7.04 160810 6200B *                           'N':not need to post fee                   *  
7.05 160810 6200B *                 LNSTFPSTGL-'P':postpone GL posting(will be activated)*  
7.06 160810 6200B *                           'X':GL posting at the day end              *  
7.07 160810 6200B *                           'C':GL posting action finished             *  
7.08 160810 6200B *                           'N':not need to post GL                    *  
7.09 160810 6200B *                 LNSTFSMS- 'P':postpone SMS alert (will be activated) *  
7.10 160810 6200B *                           'X':SMS alert at the day end               *  
7.11 160810 6200B *                           'C':SMS alert action finished              *  
7.12 160810 6200B *                           'N':not need to send SMS alert             *  
9.00 160803       ************************************************************************  
10.00 160620      F*******************************************************************       
11.00 160620      F*                       FILE DECLARATION                          *       
12.00 160620      F*******************************************************************       
13.00 160418      FLNSTLSACC UF A E           K DISK                                         
14.00 160617      FLNSTTRAN  IF   E           K DISK                                         
15.00 160418      FLNSTPF    UF A E           K DISK                                         
16.00 160620      D*******************************************************************       
17.00 160620      D*                      VARIABLE DEFINITION                        *       
18.00 160620      D*******************************************************************       
19.00 160620       *counter *                                                                
20.00 160418      DCQTY             S             10P 0 INZ(0)                               
21.00 160418      DCAMOUNT          S             13P 2 INZ(0)                               
22.00 160418       *charge flag value 'Y' if tsnqty lower than minstd                        
23.00 160418      DCHG              S              1A   INZ('N')                             
24.00 160418       *transaction quantity minimun standard*                                   
25.00 160418      DMINSTD           S             10P 0                                      
26.00 160421       *penalty amount*                                                          
27.00 160504      DPNT              S             13P 2                                      
28.00 160620      C*******************************************************************       
29.00 160620      C*                    VARIABLE INITIALIZATION                      *       
30.00 160620      C*******************************************************************       
31.00 160418       *Quantity of transaction should be made within review period              
32.00 160620      C     *DTAARA       DEFINE    LNSTTX        MINSTD                         
33.00 160506      C                   IN        MINSTD                                       
34.00 160421       *Amount of penalty fee                                                    
35.00 160620      C     *DTAARA       DEFINE    LNSTCHG       PNT                            
36.00 160506      C                   IN        PNT                                          
37.00 160620      C*******************************************************************       
38.00 160620      C*                        MAIN ROUTINE                             *       
39.00 160620      C*******************************************************************       
40.00 160620      C*                                                                         
41.00 160620      C*    Calculate LNSTLSACC transaction quantity                             
42.00 160620      C*                                                                         
43.00 160418      C                   READ      LNSTLSACC                                    
44.00 160418      C                   DOW       NOT %EOF(LNSTLSACC)                          
45.00 160620      C                                                                          
46.00 160418      C                   IF        LLSRACC<>0                                   
47.00 160418      C                   EVAL      CQTY=0                                       
48.00 160418      C                   EVAL      CAMOUNT=0                                    
49.00 160620      C                                                                          
50.00 160620      C     LLSRACC       SETLL     LNSTTRAN                                     
51.00 160620      C     LLSRACC       READE     LNSTTRAN                                     
52.00 160620      C**                                                                        
53.00 160620      C**   Loop LNSTTRAN to count transaction total                             
54.00 160620      C**                                                                        
55.00 160620      C                   DOW       NOT %EOF(LNSTTRAN)                           
56.00 160620      C                   IF        LTREFFDATE >= LLSRWSTR AND                   
57.00 160620      C                             LTREFFDATE <= LLSRWEND                       
58.00 160620      C                   EVAL      CQTY=CQTY+1                                  
59.00 160620      C                   EVAL      CAMOUNT=CAMOUNT+LTRTXNAMT                    
60.00 160620      C                   ENDIF                                                  
61.00 160620      C     LLSRACC       READE     LNSTTRAN                                     
62.00 160418      C                   ENDDO                                                  
63.00 160620      C**                                                                        
64.00 160620      C**   Get total transaction quantity and update LNSTLSACC                  
65.00 160620      C**                                                                        
66.00 160418      C                   EVAL      LLSTSNQTY=CQTY                               
67.00 160418      C                   EVAL      LLSTSNAMT=CAMOUNT                            
68.00 0      C                   UPDATE    RLNSTLSACC                                   
69.00 160620      C                                                                          
70.00 160418      C                   ENDIF                                                  
71.00 160620      C**                                                                        
72.00 160620      C**   Process next LNSTLSACC record                                        
73.00 160620      C**                                                                        
74.00 0      C                   READ      LNSTLSACC                                    
75.00 160620      C                                                                          
76.00 0      C                   ENDDO                                                  
77.00 0      C                                                                          
78.00 160620      C*                                                                         
79.00 160620      C*    Summary LNSTLSACC(LLSTSNQTY) to LNSTPF(LNSTTSNQTY)                   
80.00 160620      C*                                                                         
81.00 0      C                   READ      LNSTPF                                       
82.00 160421      C                   DOW       NOT %EOF(LNSTPF)                             
83.00 160620      C                                                                          
84.00 160421      C                   EVAL      CQTY=0                                       
85.00 160421      C                   EVAL      CAMOUNT=0                                    
86.00 160620      C                                                                          
87.00 160726      C                   IF        LNSTFAPV=' '                                 
88.00 160620      C**                                                                        
89.00 160620      C**   Search LNSTLSACC and count for transaction                           
90.00 160620      C**                                                                        
91.00 160421      C     LNSTLNNOTE    SETLL     LNSTLSACC                                    
92.00 160421      C     LNSTLNNOTE    READE     LNSTLSACC                                    
93.00 160421      C                   DOU       %EOF(LNSTLSACC)                              
94.00 160421      C                   EVAL      CQTY=CQTY+LLSTSNQTY                          
95.00 160421      C                   EVAL      CAMOUNT=CAMOUNT+LLSTSNAMT                    
96.00 160421      C     LNSTLNNOTE    READE     LNSTLSACC                                    
97.00 160421      C                   ENDDO                                                  
98.00 160620      C**                                                                        
99.00 160620      C**   Summary result and update LNSTPF                                     
100.00 160620      C**                                                                        
101.00 160617      C                   EVAL      LNSTTSNQTY=CQTY                              
102.00 160617      C                   EVAL      LNSTTSNAMT=CAMOUNT                           
103.00 160719      C                   IF        LNSTTSNQTY < MINSTD                          
103.01 160810 6200BC                   EVAL      LNSTFAPV='A'                                 
104.00 160803      C                   EVAL      LNSTFCHG='Y'                                 
104.01 160803      C*               ***a pending charge***                                    
106.00 160810 6200BC                   EVAL      LNSTPNT=PNT                                  
106.01 160810 6200BC                   EVAL      LNSTFPSTF='P'                                
106.02 160810 6200BC                   EVAL      LNSTFPSTGL='P'                               
106.03 160810 6200BC                   EVAL      LNSTFSMS='P'                                 
107.00 160803      C                   ELSE                                                   
107.01 160810 6200BC                   EVAL      LNSTFAPV='A'                                 
108.00 160803      C                   EVAL      LNSTFCHG='N'                                 
108.01 160803      C*               ***a pending charge***                                    
110.00 160810 6200BC                   EVAL      LNSTPNT=0                                    
110.01 160810 6200BC                   EVAL      LNSTFPSTF='N'                                
110.02 160810 6200BC                   EVAL      LNSTFPSTGL='N'                               
110.03 160810 6200BC                   EVAL      LNSTFSMS='N'                                 
111.00 160803      C                   ENDIF                                                  
112.00 160803      C                   UPDATE    RLNSTPF                                      
113.00 160620      C                                                                          
114.00 160617      C                   ENDIF                                                  
115.00 160620      C**                                                                        
116.00 160620      C**   Read and process next record                                         
117.00 160620      C**                                                                        
118.00 160617      C                   READ      LNSTPF                                       
119.00 160620      C                                                                          
120.00 160421      C                   ENDDO                                                  
121.00 160620      C                                                                          
122.00 160418      C                   SETON                                        LR        
123.00 160620      C*                                                                         
