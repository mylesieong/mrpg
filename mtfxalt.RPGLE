1.00 160822      H DATEDIT(*YMD) DATFMT(*ISO) TIMFMT(*HMS)                                  
2.00 160511       ************************************************************************  
3.00 160822       * REFERENCE NO. : CHG-0250-16 (D6250)                                  *  
4.00 160511       * AUTHOR        : Myles Ieong                                          *  
5.00 160511       * USER ID.      : BI77PGM                                              *  
6.00 160822       * DATE WRITTEN  : 22 Aug 2016                                          *  
7.00 160822       * DESCRPITION   : Monitor Fx Alert Program                             *  
8.00 160511       *                                                                      *  
9.00 160511       ************************************************************************  
10.00 170802       * REFERENCE NO. : CHG-0255-17                                        *    
11.00 170731       * USER ID.      : BI77PGM Myles Ieong                                *    
12.00 170731       * DATE WRITTEN  : 31/07/2017                                         *    
13.00 170802       * DESCRPITION   : Fix Same Currency Tx False Alarm                   *    
14.00 170731       **********************************************************************    
15.00 160912      FMTFXTXPFL1UF A E           K DISK                                         
16.00 160822      FMTFXALTPF UF A E           K DISK                                         
17.00 160823      D*****************************************************************         
18.00 160823      D*               VARIABLES / CONSTANT DEFINITION                 *         
19.00 160823      D*****************************************************************         
20.00 160823       * time stamp format variable                                              
21.00 160906      DVDATE            S               D                                        
22.00 160906      DVTIME            S               T                                        
23.00 160906      DVTSTMP           S               Z                                        
24.00 160913       * alert data area                                                         
25.00 160913      D                 DS                                                       
26.00 160913      D ALTARA                  1     17                                         
27.00 160913      D ALTLMT                  1     15  2                                      
28.00 160913      D ALTMTH                 17     17                                         
29.00 160913      C*****************************************************************         
30.00 160913      C*                        MAIN ROUTINE                           *         
31.00 160913      C*****************************************************************         
32.00 160913       *    Read in alert criteria and method                                    
33.00 160913      C     *DTAARA       DEFINE    MTFXALTARA    ALTARA                         
34.00 160913      C                   IN        ALTARA                                       
35.00 160913      C                                                                          
36.00 160912      C                   READ      MTFXTXPFL1                                   
37.00 160906      C                                                                          
38.00 160912      C                   DOW       NOT %EOF(MTFXTXPFL1)                         
39.00 160823       **   Alert condition                                                      
40.00 160905      C                   SETOFF                                       70        
41.00 160912      C                   SETOFF                                       717273    
42.00 170802 D7255C                   SETOFF                                       74        
43.00 160823      C                                                                          
44.00 160913      C                   IF        MFTXLCE> ALTLMT                              
45.00 160823      C                   SETON                                        71        
46.00 160823      C                   ENDIF                                                  
47.00 160823      C                                                                          
48.00 160913      C                   IF        MFTXTLCE> ALTLMT                             
49.00 160823      C                   SETON                                        72        
50.00 160823      C                   ENDIF                                                  
51.00 160912      C                                                                          
52.00 160913      C                   IF        MFTXFALT = 'P'                               
53.00 160913      C                   SETON                                        73        
54.00 160913      C                   ENDIF                                                  
55.00 170731      C                                                                          
56.00 170802 D7255 *    Check: Turn on checker only when different ccy                       
57.00 170802 D7255C                   IF        MFTXCUR <> MFTXTCUR                          
58.00 170802 D7255C                   SETON                                        74        
59.00 170802 D7255C                   ENDIF                                                  
60.00 160823      C                                                                          
61.00 170731      C                   IF        (*IN71=*ON OR *IN72=*ON) AND *IN73=*ON       
62.00 170802 D7255C                             AND *IN74=*ON                                
63.00 160905      C                   SETON                                        70        
64.00 160905      C                   ENDIF                                                  
65.00 160905      C                                                                          
66.00 160912       *    Write alert file                                                     
67.00 160912      C                   IF        *IN70 = *ON                                  
68.00 160907      C                   EVAL      MFATDT = MFTXDT                              
69.00 160907      C                   EVAL      MFATTM = MFTXTM                              
70.00 160907      C                   EVAL      MFATTIM = MFTXTIM                            
71.00 160912      C                   EVAL      MFATCHN = MFTXCHN                            
72.00 160912      C                   EVAL      MFATCD = MFTXCD                              
73.00 160912      C                   EVAL      MFATTLDS = MFTXTLDS                          
74.00 160907      C                   EVAL      MFATACT = MFTXACT                            
75.00 160912      C                   EVAL      MFATCUR = MFTXCUR                            
76.00 160912      C                   EVAL      MFATPET = MFTXPET                            
77.00 160912      C                   EVAL      MFATTC = MFTXTC                              
78.00 160912      C                   EVAL      MFATLCE = MFTXLCE                            
79.00 160912      C                   EVAL      MFATCIF = MFTXCIF                            
80.00 160912      C                   EVAL      MFATAPP = MFTXAPP                            
81.00 160912      C                   EVAL      MFATTACT = MFTXTACT                          
82.00 170731      C                   EVAL      MFATTCUR = MFTXTCUR                          
83.00 170731      C                   EVAL      MFATTPET = MFTXTPET                          
84.00 160907      C                   EVAL      MFATTTC = MFTXTTC                            
85.00 160907      C                   EVAL      MFATTLCE = MFTXTLCE                          
86.00 160912      C                   EVAL      MFATTCIF = MFTXTCIF                          
87.00 160912      C                   EVAL      MFATTAPP = MFTXTAPP                          
88.00 160906      C                   EVAL      MFATMTH = ALTMTH                             
89.00 160905      C                   EVAL      MFATFLG = 'P'                                
90.00 160823      C                   WRITE     RMTFXALTPF                                   
91.00 160912      C                   ENDIF                                                  
92.00 160907      C                                                                          
93.00 160912       *    Update master file process flag                                      
94.00 160912      C                   SELECT                                                 
95.00 160912      C                   WHEN      *IN73=*ON AND (*IN71=*ON OR *IN72=*ON)       
96.00 160912      C                   EVAL      MFTXFALT = 'C'                               
97.00 160912      C                   UPDATE    RMTFXTXPF                                    
98.00 160912      C                   WHEN      *IN73=*ON AND NOT (*IN71=*ON OR *IN72=*ON)   
99.00 160912      C                   EVAL      MFTXFALT = 'N'                               
100.00 160912      C                   UPDATE    RMTFXTXPF                                    
101.00 160912      C                   ENDSL                                                  
102.00 160912      C                                                                          
103.00 160912      C                   READ      MTFXTXPFL1                                   
104.00 160823      C                                                                          
105.00 160511      C                   ENDDO                                                  
106.00 160823      C                                                                          
107.00 160511      C                   SETON                                        LR        
