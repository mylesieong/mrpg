1.00 170227      H DATEDIT(*YMD) DATFMT(*ISO) TIMFMT(*HMS)                                                      
2.00 170227       **************************************************************************                    
3.00 170906       * REFERENCE NO. : CHG-0266-16 (D7266)                                                         
4.00 170227       * PROGRAM ID.   : CQRXEXT                                                                     
5.00 170227       * DESC          : Cheque QR Extraction Extract Program                                        
6.00 170227       * AUTHOR        : Myles Ieong                                                                 
7.00 170227       * USER ID.      : BI77PGM                                                                     
8.00 170227       * DATE WRITTEN  : 27/02/17                                                                    
9.00 170706       *                                                                                             
10.00 170227       **************************************************************************                    
11.00 170227      F**********************************************************************                        
12.00 170227      F*                         File Specification                         *                        
13.00 170227      F**********************************************************************                        
14.00 170301      FCQRXCHQ   IF   E           K DISK                                                             
15.00 170301      FCQRXSYS   IF   E           K DISK                                                             
16.00 170301      FCQRXPF    UF A E           K DISK                                                             
17.00 170227      F*                                                                                             
18.00 170706      D**********************************************************************                        
19.00 170706      D*                         Variable define                            *                        
20.00 170706      D**********************************************************************                        
21.00 170706       *    Index of char '-' in TLTAL1                                                              
22.00 170706      DVMK1             S              2  0                                                          
23.00 170706       *    Index of char '#Q' in TLTAL1                                                             
24.00 170706      DVMK2             S              2  0                                                          
25.00 170706       *    Key list variables of QR cheque                                                          
26.00 170706      DVOBNK            S              3  0                                                          
27.00 170706      DVOBNKC           S              3                                                             
28.00 170706      DVTYP             S              3                                                             
29.00 170706      DVCPET            S              3                                                             
30.00 170706      DVCHQ             S             20                                                             
31.00 170706      D*                                                                                             
32.00 170707      C**********************************************************************                        
33.00 170707      C*                         Parameter List                             *                        
34.00 170707      C**********************************************************************                        
35.00 170707      C     *ENTRY        PLIST                                                                      
36.00 170707      C                   PARM                    PBRN              5 0                              
37.00 170227      C**********************************************************************                        
38.00 170227      C*                         Key List define                            *                        
39.00 170227      C**********************************************************************                        
40.00 170706      C     KCQRXCHQ      KLIST                                                                      
41.00 170706      C                   KFLD                    KCXCOBNK          3 0                              
42.00 170706      C                   KFLD                    KCXCTYP           3                                
43.00 170706      C                   KFLD                    KCXCCPET          3                                
44.00 170706      C                   KFLD                    KCXCCHQ          20                                
45.00 170302      C*                                                                                             
46.00 170227      C**********************************************************************                        
47.00 170227      C*                          MAIN PROGRAM                              *                        
48.00 170706      C**********************************************************************                        
49.00 170707       *    Delete outdate record from master file                                                   
50.00 170707      C                   EXSR      DLTOUTD                                                          
51.00 170707      C                                                                                              
52.00 170707       *    Extract new record to master file                                                        
53.00 170706      C                   READ      CQRXSYS                                                          
54.00 170706      C                   DOW       NOT %EOF(CQRXSYS)                                                
55.00 170706      C                                                                                              
56.00 170707       **   Extraction Alphabetic Data to Cheque info                                                
57.00 170706      C                   Z-ADD     0             VMK1                                               
58.00 170706      C                   EVAL      VMK1 = %SCAN('-':CXSTLTAL1)                                      
59.00 170706      C                   Z-ADD     0             VMK2                                               
60.00 170706      C                   EVAL      VMK2 = %SCAN('#Q':CXSTLTAL1)                                     
61.00 170706      C                   MOVE      ''            VOBNKC                                             
62.00 170706      C                   EVAL      VOBNKC = %SUBST(CXSTLTAL1:1:VMK1-1)                              
63.00 170706      C                                                                                              
64.00 170706      C                   MOVE      VOBNKC        VOBNK                          *set VOBNK          
65.00 170706      C                                                                                              
66.00 170706      C                   IF        VMK2 = 0                                     *set VTYP           
67.00 170706      C                   EVAL      VTYP = '   '                                 *set VCHQ           
68.00 170706      C                   EVAL      VCHQ = %SUBST(CXSTLTAL1:VMK1+1)                                  
69.00 170706      C                   ELSE                                                                       
70.00 170706      C                   EVAL      VTYP = 'CHQ'                                                     
71.00 170706      C                   EVAL      VCHQ = %SUBST(CXSTLTAL1:VMK1+1:VMK2-VMK1-1)                      
72.00 170706      C                   ENDIF                                                                      
73.00 170706      C                                                                                              
74.00 170706      C                   CALL      'CCCYCHK1'                                   *set VCPET          
75.00 170706      C                   PARM                    CXSTLTCUR                                          
76.00 170706      C                   PARM                    VCPET                                              
77.00 170706      C                   PARM                    VERR              1                                
78.00 170706      C                                                                                              
79.00 170707       **   For QR cheque posting, verify existence & info from CQRXCHQ                              
80.00 170711       **   'M' - Present then matched                                                               
81.00 170711       **   'U' - Found CQRXSYS, Not found CQRXCHQ                                                   
82.00 170706      C                   IF        VTYP = 'CHQ'                                                     
83.00 170706      C                                                                                              
84.00 170706      C                   EVAL      KCXCOBNK = VOBNK                                                 
85.00 170906      C                   EVAL      KCXCTYP = 'CHQ'                                                  
86.00 170706      C                   EVAL      KCXCCPET = VCPET                                                 
87.00 170706      C                   EVAL      KCXCCHQ = VCHQ                                                   
88.00 170706      C     KCQRXCHQ      CHAIN     CQRXCHQ                                                          
89.00 170706      C                                                                                              
90.00 170706      C                   IF        NOT %FOUND(CQRXCHQ)                                              
91.00 170706      C                                                                                              
92.00 170711      C                   EVAL      CXSTS = 'U'                                  *get CXSTS          
93.00 170706      C                   EVAL      CXOBNK = VOBNK                               *get CXOBNK         
94.00 170706      C                   EVAL      CXTYP = VTYP                                 *get CXTYP          
95.00 170706      C                   EVAL      CXCPET = VCPET                               *get CXCPET         
96.00 170706      C                   EVAL      CXCHQ = VCHQ                                 *get CXCHQ          
97.00 170706      C                   EVAL      CXONAM = *BLANK                              *get CXONAM         
98.00 170706      C                   EVAL      CXOACT = *BLANK                              *get CXOACT         
99.00 170706      C                                                                                              
100.00 170706      C                   ELSE                                                                       
101.00 170706      C                                                                                              
102.00 170706      C                   EVAL      CXSTS = 'M'                                  *get CXSTS          
103.00 170706      C                   EVAL      CXOBNK = CXCOBNK                             *get CXOBNK         
104.00 170706      C                   EVAL      CXTYP = CXCTYP                               *get CXTYP          
105.00 170706      C                   EVAL      CXCPET = CXCCPET                             *get CXCPET         
106.00 170706      C                   EVAL      CXCHQ = CXCCHQ                               *get CXCHQ          
107.00 170706      C                   EVAL      CXONAM = CXCONAM                             *get CXONAM         
108.00 170706      C                   EVAL      CXOACT = CXCOACT                             *get CXOACT         
109.00 170706      C                                                                                              
110.00 170706      C                   ENDIF                                                                      
111.00 170706      C                                                                                              
112.00 170706      C                   ENDIF                                                                      
113.00 170706      C                                                                                              
114.00 170707       **   For Non-QR cheque posting, verify absence from CQRXCHQ                                   
115.00 170711       **   'M' - Absent then matched                                                                
116.00 170711       **   'U' - Found CQRXSYS, and also found CQRXCHQ                                              
117.00 170706      C                   IF        VTYP = '   '                                                     
118.00 170706      C                                                                                              
119.00 170706      C                   EVAL      KCXCOBNK = VOBNK                                                 
120.00 170906      C                   EVAL      KCXCTYP = 'CHQ'                                                  
121.00 170706      C                   EVAL      KCXCCPET = VCPET                                                 
122.00 170706      C                   EVAL      KCXCCHQ = VCHQ                                                   
123.00 170706      C     KCQRXCHQ      CHAIN     CQRXCHQ                                                          
124.00 170706      C                                                                                              
125.00 170706      C                   IF        NOT %FOUND(CQRXCHQ)                                              
126.00 170706      C                                                                                              
127.00 170711      C                   EVAL      CXSTS = 'M'                                  *get CXSTS          
128.00 170706      C                   EVAL      CXOBNK = VOBNK                               *get CXOBNK         
129.00 170706      C                   EVAL      CXTYP = VTYP                                 *get CXTYP          
130.00 170706      C                   EVAL      CXCPET = VCPET                               *get CXCPET         
131.00 170706      C                   EVAL      CXCHQ = VCHQ                                 *get CXCHQ          
132.00 170706      C                   EVAL      CXONAM = *BLANK                              *get CXONAM         
133.00 170706      C                   EVAL      CXOACT = *BLANK                              *get CXOACT         
134.00 170706      C                                                                                              
135.00 170706      C                   ELSE                                                                       
136.00 170706      C                                                                                              
137.00 170711      C                   EVAL      CXSTS = 'U'                                  *get CXSTS          
138.00 170706      C                   EVAL      CXOBNK = CXCOBNK                             *get CXOBNK         
139.00 170706      C                   EVAL      CXTYP = CXCTYP                               *get CXTYP          
140.00 170706      C                   EVAL      CXCPET = CXCCPET                             *get CXCPET         
141.00 170706      C                   EVAL      CXCHQ = CXCCHQ                               *get CXCHQ          
142.00 170706      C                   EVAL      CXONAM = CXCONAM                             *get CXONAM         
143.00 170706      C                   EVAL      CXOACT = CXCOACT                             *get CXOACT         
144.00 170706      C                                                                                              
145.00 170706      C                   ENDIF                                                                      
146.00 170706      C                                                                                              
147.00 170706      C                   ENDIF                                                                      
148.00 170706      C                                                                                              
149.00 170707       **   Consolidate record to CQRXPF                                                             
150.00 170706      C                   EVAL      CXAMT = CXSTLTTC                             *get TLTTC          
151.00 170706      C                   EVAL      CXTLTTIM = CXSTLTTIM                         *get TLTTIM         
152.00 170706      C                   EVAL      CXTLTBRN = CXSTLTBRN                         *get TLTBRN         
153.00 170706      C                   EVAL      CXTLTCUR = CXSTLTCUR                         *get TLTCUR         
154.00 170706      C                   EVAL      CXTLTTC  = CXSTLTTC                          *get TLTTC          
155.00 170706      C                   EVAL      CXTLTAL1 = CXSTLTAL1                         *get TLTAL1         
156.00 170706      C                   EVAL      CXTLTUSR = CXSTLTUSR                         *get TLTUSR         
157.00 170706      C                   EVAL      CXTLTWS  = CXSTLTWS                          *get TLTWS          
158.00 170706      C                   EVAL      CXTLTAPP = CXSTLTAPP                         *get TLTAPP         
159.00 170706      C                   EVAL      CXTLTACT = CXSTLTACT                         *get TLTACT         
160.00 170706      C                   EVAL      CXTLTTIL = CXSTLTTIL                         *get TLTTIL         
161.00 170706      C                   EVAL      CXTLTSSN = CXSTLTSSN                         *get TLTSSN         
162.00 170706      C                   EVAL      CXTLTNBR = CXSTLTNBR                         *get TLTNBR         
163.00 170706      C                   EVAL      CXTLTBSQ = CXSTLTBSQ                         *get TLTBSQ         
164.00 170706      C                   EVAL      CXTLTCOR = CXSTLTCOR                         *get TLTCOR         
165.00 170706      C                   EVAL      CXTLTCSQ = CXSTLTCSQ                         *get TLTCSQ         
166.00 170906      C                   EVAL      CXTLTCD = CXSTLTCD                           *get TLTCD          
167.00 170706      C                   WRITE     RCQRXPF                                                          
168.00 170706      C                                                                                              
169.00 170706      C                   READ      CQRXSYS                                                          
170.00 170706      C                                                                                              
171.00 170706      C                   ENDDO                                                                      
172.00 170227      C                   SETON                                        LR                            
173.00 170707       *                                                                                             
174.00 170707      C**********************************************************************                        
175.00 170707      C*       SR: DLTOUTD- Delete out of date record according to PBRN     *                        
176.00 170707      C**********************************************************************                        
177.00 170707      C     DLTOUTD       BEGSR                                                                      
178.00 170707      C/EXEC SQL                                                                                     
179.00 170707      C+ DELETE FROM CQRXPF                                                                          
180.00 170707      C+ WHERE CXTLTBRN = :PBRN                                                                      
181.00 170707      C/END-EXEC                                                                                     
182.00 170707      C                   ENDSR                                                                      
183.00 170227      C**                                                                                            
