1.00 160329       ************************************************************************  
2.00 160622       * REFERENCE NO. : CHG-0200-16 (D6200)                                  *  
3.00 160329       * AUTHOR        : Myles Ieong                                          *  
4.00 160329       * USER ID.      : BI77PGM                                              *  
5.00 160329       * DATE WRITTEN  : 29 Mar 2016                                          *  
6.00 160329       * DESCRPITION   : Build master file LNSTPF                             *  
7.00 160329       *                                                                      *  
8.00 160329       ************************************************************************  
9.00 160301      H DATEDIT(*YMD) DATFMT(*ISO) TIMFMT(*HMS)                                  
10.00 160414      FLNP00301  IF   E           K DISK                                         
11.00 160301      FLNSTPARM  IF   E           K DISK                                         
12.00 160301      FLNSTPF    UF A E           K DISK                                         
13.00 160301       *vardte & its date format equivalent*                                     
14.00 160301      DVARDTE           S              8P 0                                      
15.00 160301      DFVARDTE          S               D   DATFMT(*ISO) INZ(*SYS)               
16.00 160301       *today & its date format equivalent*                                      
17.00 160301      DTODAY            S              8P 0                                      
18.00 160301      DFTODAY           S               D   DATFMT(*ISO) INZ(*SYS)               
19.00 160301       *review teller date & its date format equivalent*                         
20.00 160301      DTLDTE            S              8P 0                                      
21.00 160301      DFTLDTE           S               D   DATFMT(*ISO) INZ(*SYS)               
22.00 160301       *review start date & its date format equivalent*                          
23.00 160301      DRSDTE            S              8P 0                                      
24.00 160301      DFRSDTE           S               D   DATFMT(*ISO) INZ(*SYS)               
25.00 160301       *review end date & its date format equivalent*                            
26.00 160301      DREDTE            S              8P 0                                      
27.00 160301      DFREDTE           S               D   DATFMT(*ISO) INZ(*SYS)               
28.00 160301       *sr:chk_type result indicator*                                            
29.00 160301      DCHK_TYP_I        S              1P 0                                      
30.00 160301       *review_interval_by_month*                                                
31.00 160301      DRWITRV           S              3P 0                                      
32.00 160301       *month distance variable*                                                 
33.00 160301      DMNDST            S              2P 0                                      
34.00 160401      DVARDTEMN         S              2P 0                                      
35.00 160401      DTLDTEMN          S              2P 0                                      
36.00 160301       *ds_4_imodule_dcalbdte: 4 months ahead wo date change*                    
37.00 160301      D                 DS                                                       
38.00 160401      D  TMPNEWP                       3P 0 INZ(4)                               
39.00 160415      D  TMPNEWSP                      2P 0 INZ(1)                               
40.00 160401      D  TMPNEWCDE                     1A   INZ('M')                             
41.00 160401      D  TMPNEWRST                     6P 0 INZ(0)                               
42.00 160301       *ds_4_imodule_dcalbdte: 3 months ahead at first day*                      
43.00 160301      D                 DS                                                       
44.00 160401      D  TMPREGP                       3P 0 INZ(3)                               
45.00 160401      D  TMPREGSP                      2P 0 INZ(1)                               
46.00 160401      D  TMPREGCDE                     1A   INZ('M')                             
47.00 160401      D  TMPREGRST                     6P 0 INZ(0)                               
48.00 160301       *ds_4_imodule_dcalbdte: 1 month ahead at last day*                        
49.00 160301      D                 DS                                                       
50.00 160401      D  TMPENDP                       3P 0 INZ(1)                               
51.00 160401      D  TMPENDSP                      2P 0 INZ(31)                              
52.00 160401      D  TMPENDCDE                     1A   INZ('M')                             
53.00 160401      D  TMPENDRST                     6P 0 INZ(0)                               
54.00 160504       *data structure for payment account and its type*                         
55.00 160803      D                 DS                                                       
56.00 160803      DSLNACAP                  1     15  0                                      
57.00 160803      D SUBS                    1      3  0                                      
58.00 160803      D ACCTYP                  4      5  0                                      
59.00 160803      D ACCNBR                  6     15  0                                      
60.00 160803       *******************initialize_variable************************************
61.00 160803      C     *DTAARA       DEFINE    LNSTRWI       RWITRV                         
62.00 160803      C                   IN        RWITRV                                       
63.00 160803       *get_today*                                                               
64.00 160301      C                   CALL      'DICBSYMD'                                   
65.00 160301      C                   PARM                    TODAY                          
67.00 160301      C                   MOVE      TODAY         FTODAY                         
68.00 160329       *get_review_date:-4mon wo date change*                                    
69.00 160301      C                   CALL      'DCALBDTE'                                   
70.00 160301      C                   PARM                    TODAY                          
71.00 160401      C                   PARM                    TMPNEWP                        
72.00 160401      C                   PARM                    TMPNEWSP                       
73.00 160401      C                   PARM                    TMPNEWCDE                      
74.00 160401      C                   PARM                    TMPNEWRST                      
75.00 160301      C                   PARM                    TLDTE                          
76.00 160301      C                   MOVE      TLDTE         FTLDTE                         
77.00 160329       *get_review_start_date:-3mon at firstday*                                 
78.00 160301      C                   CALL      'DCALBDTE'                                   
79.00 160301      C                   PARM                    TODAY                          
80.00 160401      C                   PARM                    TMPREGP                        
81.00 160401      C                   PARM                    TMPREGSP                       
82.00 160401      C                   PARM                    TMPREGCDE                      
83.00 160401      C                   PARM                    TMPREGRST                      
84.00 160301      C                   PARM                    RSDTE                          
85.00 160301      C                   MOVE      RSDTE         FRSDTE                         
86.00 160329       *get_review_end_date:-1mon at lastday*                                    
87.00 160301      C                   CALL      'DCALBDTE'                                   
88.00 160301      C                   PARM                    TODAY                          
89.00 160401      C                   PARM                    TMPENDP                        
90.00 160401      C                   PARM                    TMPENDSP                       
91.00 160401      C                   PARM                    TMPENDCDE                      
92.00 160401      C                   PARM                    TMPENDRST                      
93.00 160301      C                   PARM                    REDTE                          
94.00 160301      C                   MOVE      REDTE         FREDTE                         
95.00 160301       *******************main_routine*****************************************  
96.00 160414      C                   READ      LNP00301                                     
97.00 160803      C                   DOW       NOT %EOF(LNP00301)                           
98.00 160401      C                   EVAL      CHK_TYP_I=0                                  
99.00 160401      C     LNTYPE        CHAIN     LNSTPARM                                     
100.00 160401      C                   IF        %FOUND                                       
101.00 160401      C                   EVAL      CHK_TYP_I=1                                  
102.00 160401      C                   ENDIF                                                  
103.00 160301      C                   IF        CHK_TYP_I=1 AND LNSTAT=''                    
104.00 160301      C                   CALL      'DFDDTOYY'                                   
105.00 160301      C                   PARM                    LNNTDT                         
106.00 160301      C                   PARM                    VARDTE                         
107.00 160301      C                   MOVE      VARDTE        FVARDTE                        
108.00 160329       *Fetch loan records that should review for the first time*                
109.00 160301      C                   IF        %SUBDT(FVARDTE:*MONTHS)=                     
110.00 160301      C                                 %SUBDT(FTLDTE:*MONTHS)                   
111.00 160301      C                             AND %SUBDT(FVARDTE:*YEARS)=                  
112.00 160301      C                                 %SUBDT(FTLDTE:*YEARS)                    
113.00 160415       *              *update field for first review loan*                       
114.00 160310      C                   EVAL      LNSTLNNOTE=LNNOTE                            
115.00 160421      C                   EVAL      LNSTLNSHRT=LNSHRT                            
116.00 160421      C                   EVAL      LNSTLNNTDT=VARDTE                            
117.00 160421      C                   CALL      'DFDDTOYY'                                   
118.00 160421      C                   PARM                    LNMTDT                         
119.00 160421      C                   PARM                    LNSTLNMTDT                     
120.00 160803      C                   EVAL      LNSTLNACAP=LNACAP                            
121.00 160803      C                   MOVE      LNACAP        SLNACAP                        
122.00 160803      C                   EVAL      LNSTPACNBR=ACCNBR                            
123.00 160803      C                   EVAL      LNSTPACTYP=ACCTYP                            
124.00 160421      C                   EVAL      LNSTRWDTE=TODAY                              
125.00 160421      C                   EVAL      LNSTRWSTR=VARDTE                             
126.00 160421      C                   EVAL      LNSTRWEND=REDTE                              
127.00 160421      C                   EVAL      LNSTFFR='Y'                                  
128.00 160421      C                   EVAL      LNSTFAPV=' '                                 
129.00 160504      C                   EVAL      LNSTFCHG=' '                                 
130.00 160504      C                   EVAL      LNSTFPSTF=' '                                
131.00 160504      C                   EVAL      LNSTFPSTGL=' '                               
132.00 160504      C                   EVAL      LNSTFSMS=' '                                 
133.00 160421      C                   EVAL      LNSTLNCMCN=LNCMCN                            
134.00 160803      C*                  EVAL      LNSTLNCPET=LNCPET                            
135.00 160421      C                   WRITE     RLNSTPF                                      
136.00 160301      C                   ELSE                                                   
137.00 160415       *              *count month distances between teller dte & note dte*      
138.00 160421      C                   IF        %SUBDT(FVARDTE:*DAYS)=%SUBDT(FTLDTE:*DAYS)   
139.00 160421      C                   EVAL      MNDST=%DIFF(FTLDTE:FVARDTE:*MONTHS)-1        
140.00 160421      C                   ELSE                                                   
141.00 160421      C                   EVAL      MNDST=%DIFF(FTLDTE:FVARDTE:*MONTHS)          
142.00 160421      C                   ENDIF                                                  
143.00 160421       *Fetch loan records that should review but not their first review*        
144.00 160421      C                   IF        %REM(MNDST:RWITRV)=RWITRV-1                  
145.00 160421      C                             AND MNDST>0                                  
146.00 160421       *              *update regualer review loan*                              
147.00 160421      C                   EVAL      LNSTLNNOTE=LNNOTE                            
148.00 160421      C                   EVAL      LNSTLNNTDT=VARDTE                            
149.00 160421      C                   EVAL      LNSTLNSHRT=LNSHRT                            
150.00 160421      C                   CALL      'DFDDTOYY'                                   
151.00 160421      C                   PARM                    LNMTDT                         
152.00 160421      C                   PARM                    LNSTLNMTDT                     
153.00 160803      C                   EVAL      LNSTLNACAP=LNACAP                            
154.00 160803      C                   MOVE      LNACAP        SLNACAP                        
155.00 160803      C                   EVAL      LNSTPACNBR=ACCNBR                            
156.00 160803      C                   EVAL      LNSTPACTYP=ACCTYP                            
157.00 160421      C                   EVAL      LNSTRWDTE=TODAY                              
158.00 160421      C                   EVAL      LNSTRWSTR=RSDTE                              
159.00 160421      C                   EVAL      LNSTRWEND=REDTE                              
160.00 160421      C                   EVAL      LNSTFFR='N'                                  
161.00 160421      C                   EVAL      LNSTFAPV=' '                                 
162.00 160504      C                   EVAL      LNSTFCHG=' '                                 
163.00 160504      C                   EVAL      LNSTFPSTF=' '                                
164.00 160504      C                   EVAL      LNSTFPSTGL=' '                               
165.00 160504      C                   EVAL      LNSTFSMS=' '                                 
166.00 160421      C                   EVAL      LNSTLNCMCN=LNCMCN                            
167.00 160803      C*                  EVAL      LNSTLNCPET=LNCPET                            
168.00 160803      C                   WRITE     RLNSTPF                                      
169.00 160421      C                   ENDIF                                                  
170.00 160421      C                   ENDIF                                                  
171.00 160421      C                   ENDIF                                                  
172.00 160421      C                   READ      LNP00301                                     
173.00 160421      C                   ENDDO                                                  
174.00 160421      C                   SETON                                        LR        
175.00 160421      C                   RETURN                                                 
