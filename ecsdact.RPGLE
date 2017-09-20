1.00 20307      H DATEDIT(*YMD) DATFMT(*ISO) TIMFMT(*HMS)                                                      
2.00 20319       **************************************************************************                    
3.00 170328       * REFERENCE NO. : CHG-0100-17 (D7100)                                                         
4.00 170328       * PROGRAM ID.   : ECSDACT                                                                     
5.00 161020       * DESC          : ECSD Action Module Program                                                  
6.00 160607       * AUTHOR        : Myles Ieong                                                                 
7.00 160607       * USER ID.      : BI77PGM                                                                     
8.00 170328       * DATE WRITTEN  : 28 Mar 2017                                                                 
9.00 161024       *                 PACTCODE: 'CRT '- Create operation                                          
10.00 161024       *                           'UPD '- Update operation                                          
11.00 161024       *                           'INQ '- Inquiry operation                                         
12.00 170505       *                           'DLT '- Delete operation (shdnot be invoked)                      
13.00 161024       *                 PICBSSTS: '0' - success                                                     
14.00 161024       *                           '1' - failure                                                     
15.00 161024       *                 PSTS: 'IHDSUCC'- return when success                                        
16.00 161024       *                       'IHD1082'- fail/Not authorized error & others                         
17.00 161020       **************************************************************************                    
18.00 170505       *   Reference     : CHG-100-17 (D7100)                               *                        
19.00 170505       *   Changed by    : Myles Ieong                                      *                        
20.00 170505       *   User ID       : BI77PGM                                          *                        
21.00 170505       *   Date changed  : 05 May 2017                                      *                        
22.00 170505       *   Description   : Update Log Message & Cancel Failure Log          *                        
23.00 170505       **********************************************************************                        
24.00 170913       *   Reference     : CHG-xxx-17 (D7xxx)                               *                        
25.00 170913       *   Changed by    : Myles Ieong                                      *                        
26.00 170913       *   User ID       : BI77PGM                                          *                        
27.00 170913       *   Date changed  : 13 Sep 2017                                      *                        
28.00 170913       *   Description   : Add Action Code UPDR for non-vip CIF             *                        
29.00 170913       **********************************************************************                        
30.00 161020      F**********************************************************************                        
31.00 160607      F*                         File Specification                         *                        
32.00 160607      F**********************************************************************                        
33.00 161020      FECSDPF    UF A E           K DISK                                                             
34.00 170111      FECSDLOG   UF A E           K DISK                                                             
35.00 170327      FECSDREL   IF   E           K DISK                                                             
36.00 161027       * ICBS Standard file                                                                          
37.00 161028      FTAP002    IF A E           K DISK                                                             
38.00 170123      FVIPMAST   IF A E           K DISK                                                             
39.00 170123      FCUP009L7  IF A E           K DISK                                                             
40.00 170914 D7xxxFCUP003    IF A E           K DISK                                                             
41.00 170123      F                                                                                              
42.00 170123      F**********************************************************************                        
43.00 170123      F*                         Function Description                       *                        
44.00 170123      F**********************************************************************                        
45.00 170123      F*              *IN70: General error indicator  (*ON: failed)                                  
46.00 170123      F*              *IN71: Insig. search parms/ record existence mistake                           
47.00 170123      F*              *IN72: dmpass = 'y' or dmtype > 600 or not active                              
48.00 170123      F*              *IN73: Already opt-in/opt-out                                                  
49.00 170123      F*              *IN74: Consolidation status conflict with operation                            
50.00 170328      F*              *IN75: <not occupied yet>                                                      
51.00 170328      F*              *IN76: <not occupied yet>                                                      
52.00 170123      F**                                                                                            
53.00 170123      D**********************************************************************                        
54.00 160607      D*                   Variables / constant defination                  *                        
55.00 160607      D**********************************************************************                        
56.00 20305      D DSPGID         SDS                                                                           
57.00 30113      D  WKDATE               191    198  0                                                          
58.00 20425      D  WKSTN                244    253                                                             
59.00 70118      D  WUSER                254    263                                                             
60.00 150527      DWSDTAS           DS                                                                           
61.00 150527      DCSRLOC                 370    371B 0                                                          
62.00 161024       * Variable TIME STAMP                                                                         
63.00 161024      DVDATE            S               D                                                            
64.00 161024      DVTIME            S               T                                                            
65.00 161024      DVTSTMP           S               Z                                                            
66.00 170113       * Account format                                                                              
67.00 170113      D                 DS                                                                           
68.00 170113      DVACCT                    1     12                                                             
69.00 170113      D VACCTCODE               1      2                                                             
70.00 170113      D VACCTNO                 3     12                                                             
71.00 170308      D*                                                                                             
72.00 160607      C**********************************************************************                        
73.00 160607      C*                         Key List define                            *                        
74.00 160615      C**********************************************************************                        
75.00 160818      C     KECSDPF       KLIST                                                                      
76.00 160818      C                   KFLD                    KEMAPPCODE        2                                
77.00 160818      C                   KFLD                    KEMKEY           20                                
78.00 161027      C                                                                                              
79.00 161028      C     KTAP002       KLIST                                                                      
80.00 161028      C                   KFLD                    KDMBK             3 0                              
81.00 170123      C                   KFLD                    KDMTYP            1 0                              
82.00 170123      C                   KFLD                    KDMACCT          10 0                              
83.00 170123      C                                                                                              
84.00 170123      C     KCUP009L7     KLIST                                                                      
85.00 170123      C                   KFLD                    KCUXBK            3 0                              
86.00 170123      C                   KFLD                    KCUXREC           1                                
87.00 170123      C                   KFLD                    KCUX1CS          10                                
88.00 170123      C                   KFLD                    KCUX1AC          12 0                              
89.00 170914      C                                                                                              
90.00 170914 D7xxxC     KCUP003       KLIST                                                                      
91.00 170914 D7xxxC                   KFLD                    KCUBK             3 0                              
92.00 170914 D7xxxC                   KFLD                    KCUNBR           10                                
93.00 170914      C*                                                                                             
94.00 170123      C**********************************************************************                        
95.00 170123      C*                         Parameter List                             *                        
96.00 170123      C**********************************************************************                        
97.00 161020      C     *ENTRY        PLIST                                                                      
98.00 161027      C                   PARM                    PCHANNEL          3                                
99.00 161027      C                   PARM                    PACTCODE          4                                
100.00 161027      C                   PARM                    PACTTYPE          4                                
101.00 161027      C                   PARM                    PEMAPPCODE        2                                
102.00 161027      C                   PARM                    PEMKEY           20                                
103.00 161024      C                   PARM                    PEMCLASS         10                                
104.00 161024      C                   PARM                    PEMTYPE          10                                
105.00 161024      C                   PARM                    PEMSUTYPE         2                                
106.00 161024      C                   PARM                    PEMOP1            1                                
107.00 161020      C                   PARM                    PEMOP2            1                                
108.00 161020      C                   PARM                    PEMOP3            2                                
109.00 161020      C                   PARM                    PEMDATE           8 0                              
110.00 161020      C                   PARM                    PEMTIME           6 0                              
111.00 170123      C                   PARM                    PEMSRUPD         10                                
112.00 170123      C                   PARM                    PEMREL           10                                
113.00 170123      C                   PARM                    PICBSSTS          1                                
114.00 170123      C                   PARM                    PSTS             10                                
115.00 170123      C                   PARM                    PMOMENT          26                                
116.00 170123      C**********************************************************************                        
117.00 170123      C*                          MAIN PROGRAM                              *                        
118.00 170123      C**********************************************************************                        
119.00 170123       *    Check input parameter validity                                                           
120.00 170123      C                   SETOFF                                       70                            
121.00 170123      C                   SETOFF                                       717273                        
122.00 170123      C                   SETOFF                                       747576                        
123.00 170123      C                   EVAL      PICBSSTS= '0'                                                    
124.00 170123      C                   EVAL      PSTS= ''                                                         
125.00 161027      C                                                                                              
126.00 161027       *    Check parameter significate                                                              
127.00 161027      C                   IF        PEMAPPCODE='' OR PEMKEY=''                                       
128.00 161027      C                   SETON                                        71                            
129.00 161027      C                   EVAL      PICBSSTS = '1'                                                   
130.00 161027      C                   EVAL      PSTS = 'IHD1082'                                                 
131.00 161027      C                   MOVE      WKDATE        VDATE                                              
132.00 161027      C                   TIME                    VTIME                                              
133.00 161027      C                   MOVE      VDATE         VTSTMP                                             
134.00 161027      C                   MOVE      VTIME         VTSTMP                                             
135.00 161027      C                   MOVE      VTSTMP        PMOMENT                                            
136.00 161020      C                   ENDIF                                                                      
137.00 161020      C                                                                                              
138.00 170116       *    Check when opt is create, is the record not exist yet (*IN71)                            
139.00 170116      C                   IF        PACTCODE = 'CRT '                                                
140.00 170116      C                   EVAL      KEMAPPCODE = PEMAPPCODE                                          
141.00 170116      C                   EVAL      KEMKEY = PEMKEY                                                  
142.00 170116      C     KECSDPF       CHAIN     ECSDPF                                                           
143.00 170116      C                   IF        %FOUND(ECSDPF)                                                   
144.00 170116      C                   SETON                                        71                            
145.00 170116      C                   EVAL      PICBSSTS = '1'                                                   
146.00 170116      C                   EVAL      PSTS = 'IHD1082'                                                 
147.00 170116      C                   MOVE      WKDATE        VDATE                                              
148.00 170116      C                   TIME                    VTIME                                              
149.00 170116      C                   MOVE      VDATE         VTSTMP                                             
150.00 170116      C                   MOVE      VTIME         VTSTMP                                             
151.00 170116      C                   MOVE      VTSTMP        PMOMENT                                            
152.00 170116      C                   ENDIF                                                                      
153.00 170116      C                   ENDIF                                                                      
154.00 170116      C                                                                                              
155.00 170328       *    Check account's passbook setting (VIP no need chk)                                       
156.00 170116       *    And if the product type of saving/current account valid                                  
157.00 170116      C                   IF        PACTCODE='CRT '                                                  
158.00 170116      C                             AND (PEMAPPCODE='20' OR PEMAPPCODE='26')                         
159.00 170116      C                   EVAL      KDMBK = 1                                                        
160.00 170116      C                   MOVEL     PEMKEY        KDMACCT                                            
161.00 170116      C                   IF        PEMAPPCODE = '20'                                                
162.00 170116      C                   EVAL      KDMTYP = 6                                                       
163.00 170116      C                   ENDIF                                                                      
164.00 170116      C                   IF        PEMAPPCODE = '26'                                                
165.00 170116      C                   EVAL      KDMTYP = 1                                                       
166.00 170116      C                   ENDIF                                                                      
167.00 170116      C     KTAP002       CHAIN     TAP002                                                           
168.00 170116      C                   IF        NOT %FOUND(TAP002) OR DMPASS='Y'                                 
169.00 170116      C                             OR DMTYPE > 600                                                  
170.00 170123      C                             OR (DMPRGP <> 0 AND DMPRGP <> DMTYPE)                            
171.00 170123      C                   SETON                                        72                            
172.00 170123      C                   EVAL      PICBSSTS = '1'                                                   
173.00 170116      C                   EVAL      PSTS = 'IHD1082'                                                 
174.00 170116      C                   MOVE      WKDATE        VDATE                                              
175.00 170116      C                   TIME                    VTIME                                              
176.00 170123      C                   MOVE      VDATE         VTSTMP                                             
177.00 170123      C                   MOVE      VTIME         VTSTMP                                             
178.00 170123      C                   MOVE      VTSTMP        PMOMENT                                            
179.00 170123      C                   ENDIF                                                                      
180.00 170123      C                   ENDIF                                                                      
181.00 170123      C                                                                                              
182.00 170328       *    Chk Acc Upd, if acc's cif exists in ecsdpf and if it should align                        
183.00 170328       *    the cif's setting(spec in ECSDREL), then no change allowed                               
184.00 170123      C                   IF        PACTCODE='UPD '                                                  
185.00 170123      C                             AND (PEMAPPCODE='20' OR PEMAPPCODE='26')                         
186.00 170123      C                                                                                              
187.00 170123      C                   Z-ADD     0             PACCTNO          12 0                              
188.00 170123      C                   Z-ADD     0             PAPP              2 0                              
189.00 170123      C                                                                                              
190.00 170123      C                   IF        PEMAPPCODE = '20'                                                
191.00 170123      C                   EVAL      PACCTNO = 6*10000000000 + %INT(%TRIM(PEMKEY))                    
192.00 170123      C                   ENDIF                                                                      
193.00 170123      C                   IF        PEMAPPCODE = '26'                                                
194.00 170123      C                   EVAL      PACCTNO = 1*10000000000 + %INT(%TRIM(PEMKEY))                    
195.00 170123      C                   ENDIF                                                                      
196.00 170123      C                                                                                              
197.00 170123      C                   CALL      'GACCTCIF'                                                       
198.00 170123      C                   PARM                    PACCTNO                                            
199.00 170123      C                   PARM      20            PAPP                                               
200.00 170123      C                   PARM                    PCIF             10                                
201.00 170123      C                   PARM                    PERRIND           1                                
202.00 170308      C                                                                                              
203.00 170123      C                   EVAL      KEMAPPCODE = '90'                                                
204.00 170123      C                   EVAL      KEMKEY = PCIF                                                    
205.00 170123      C     KECSDPF       CHAIN     ECSDPF                                                           
206.00 170308      C                                                                                              
207.00 170321      C                   EVAL      KCUXBK = 1                                                       
208.00 170321      C                   EVAL      KCUXREC = '1'                                                    
209.00 170321      C                   EVAL      KCUX1CS = PCIF                                                   
210.00 170321      C                   EVAL      KCUX1AC = PACCTNO                                                
211.00 170321      C     KCUP009L7     CHAIN     CUP009L7                                                         
212.00 170321      C                                                                                              
213.00 170327      C     CUXREL        CHAIN     ECSDREL                                                          
214.00 170308      C                                                                                              
215.00 170123      C                   IF        %FOUND(ECSDPF)                                                   
216.00 170328      C                             AND %FOUND(ECSDREL) AND ERFLGV = 'Y'         *rel dfn in ECSDREL 
217.00 170123      C                   SETON                                        74                            
218.00 170123      C                   EVAL      PICBSSTS = '1'                                                   
219.00 170123      C                   EVAL      PSTS = 'IHD1082'                                                 
220.00 170123      C                   MOVE      WKDATE        VDATE                                              
221.00 170123      C                   TIME                    VTIME                                              
222.00 170123      C                   MOVE      VDATE         VTSTMP                                             
223.00 170123      C                   MOVE      VTIME         VTSTMP                                             
224.00 170123      C                   MOVE      VTSTMP        PMOMENT                                            
225.00 170123      C                   ENDIF                                                                      
226.00 170123      C                                                                                              
227.00 170123      C                   ENDIF                                                                      
228.00 170123      C                                                                                              
229.00 170328       *    Check when opt is update, if cif/acc not exist or if opt-in/out                          
230.00 170328       *    already performed, then no change allowed                                                
231.00 170123      C                   IF        PACTCODE = 'UPD '                                                
232.00 161027      C                   EVAL      KEMAPPCODE = PEMAPPCODE                                          
233.00 161027      C                   EVAL      KEMKEY = PEMKEY                                                  
234.00 161027      C     KECSDPF       CHAIN     ECSDPF                                                           
235.00 161027      C                   IF        NOT %FOUND(ECSDPF)                                               
236.00 161027      C                   SETON                                        71                            
237.00 161027      C                   EVAL      PICBSSTS = '1'                                                   
238.00 161027      C                   EVAL      PSTS = 'IHD1082'                                                 
239.00 161027      C                   MOVE      WKDATE        VDATE                                              
240.00 161027      C                   TIME                    VTIME                                              
241.00 161027      C                   MOVE      VDATE         VTSTMP                                             
242.00 161027      C                   MOVE      VTIME         VTSTMP                                             
243.00 161027      C                   MOVE      VTSTMP        PMOMENT                                            
244.00 161020      C                   ELSE                                                                       
245.00 161020      C                   IF        EMOP1 = PEMOP1                                                   
246.00 161020      C                   SETON                                        73                            
247.00 161027      C                   EVAL      PICBSSTS = '1'                                                   
248.00 161027      C                   EVAL      PSTS = 'IHD1082'                                                 
249.00 161027      C                   MOVE      WKDATE        VDATE                                              
250.00 161027      C                   TIME                    VTIME                                              
251.00 161027      C                   MOVE      VDATE         VTSTMP                                             
252.00 161027      C                   MOVE      VTIME         VTSTMP                                             
253.00 161027      C                   MOVE      VTSTMP        PMOMENT                                            
254.00 161027      C                   ENDIF                                                                      
255.00 161027      C                   ENDIF                                                                      
256.00 161020      C                   ENDIF                                                                      
257.00 161024      C                                                                                              
258.00 170123       *    Check when opt is inquiry/delete, whether rec exist (*IN71)                              
259.00 170123      C                   IF        PACTCODE = 'INQ ' OR PACTCODE = 'DLT '                           
260.00 170123      C                   EVAL      KEMAPPCODE = PEMAPPCODE                                          
261.00 170123      C                   EVAL      KEMKEY = PEMKEY                                                  
262.00 170123      C     KECSDPF       CHAIN     ECSDPF                                                           
263.00 170123      C                   IF        NOT %FOUND(ECSDPF)                                               
264.00 170123      C                   SETON                                        71                            
265.00 170123      C                   EVAL      PICBSSTS = '1'                                                   
266.00 170123      C                   EVAL      PSTS = 'IHD1082'                                                 
267.00 170123      C                   MOVE      WKDATE        VDATE                                              
268.00 170123      C                   TIME                    VTIME                                              
269.00 170123      C                   MOVE      VDATE         VTSTMP                                             
270.00 170123      C                   MOVE      VTIME         VTSTMP                                             
271.00 170123      C                   MOVE      VTSTMP        PMOMENT                                            
272.00 170123      C                   ENDIF                                                                      
273.00 170123      C                   ENDIF                                                                      
274.00 170123      C                                                                                              
275.00 170913 D7xxx *    Check when opt is UPDR, the app code needs to be 90                                      
276.00 170913 D7xxxC                   IF        PACTCODE = 'UPDR'                                                
277.00 170913 D7xxxC                   IF        PEMAPPCODE <> '90'                                               
278.00 170913 D7xxxC                   SETON                                        71                            
279.00 170913 D7xxxC                   EVAL      PICBSSTS = '1'                                                   
280.00 170913 D7xxxC                   EVAL      PSTS = 'IHD1082'                                                 
281.00 170913 D7xxxC                   MOVE      WKDATE        VDATE                                              
282.00 170913 D7xxxC                   TIME                    VTIME                                              
283.00 170913 D7xxxC                   MOVE      VDATE         VTSTMP                                             
284.00 170913 D7xxxC                   MOVE      VTIME         VTSTMP                                             
285.00 170913 D7xxxC                   MOVE      VTSTMP        PMOMENT                                            
286.00 170913 D7xxxC                   ENDIF                                                                      
287.00 170913 D7xxxC                   ENDIF                                                                      
288.00 170913      C                                                                                              
289.00 170914 D7xxx *    Check when opt is UPDR, verify the CIF existence                                         
290.00 170913 D7xxxC                   IF        PACTCODE = 'UPDR'                                                
291.00 170914 D7xxxC                   Z-ADD     1             KCUBK                                              
292.00 170914 D7xxxC                   EVAL      KCUNBR = PEMKEY                                                  
293.00 170914 D7xxxC     KCUP003       CHAIN     CUP003                                                           
294.00 170914 D7xxxC                   IF        NOT %FOUND(CUP003)                                               
295.00 170914 D7xxxC                   SETON                                        71                            
296.00 170914 D7xxxC                   EVAL      PICBSSTS = '1'                                                   
297.00 170914 D7xxxC                   EVAL      PSTS = 'IHD1082'                                                 
298.00 170914 D7xxxC                   MOVE      WKDATE        VDATE                                              
299.00 170914 D7xxxC                   TIME                    VTIME                                              
300.00 170914 D7xxxC                   MOVE      VDATE         VTSTMP                                             
301.00 170914 D7xxxC                   MOVE      VTIME         VTSTMP                                             
302.00 170914 D7xxxC                   MOVE      VTSTMP        PMOMENT                                            
303.00 170914 D7xxxC                   ENDIF                                                                      
304.00 170913 D7xxxC                   ENDIF                                                                      
305.00 170914      C                                                                                              
306.00 170123       *    Operation start                                                                          
307.00 170123      C                   IF        *IN71=*ON OR *IN72=*ON OR *IN73=*ON                              
308.00 170123      C                             OR *IN74=*ON OR *IN75=*ON OR *IN76=*ON                           
309.00 170123      C                   SETON                                        70                            
310.00 170123      C                   ENDIF                                                                      
311.00 170123      C                                                                                              
312.00 170123      C                   IF        *IN70 = *OFF                                                     
313.00 170123       *    Operation: option- create                                                                
314.00 170123      C                   IF        PACTCODE = 'CRT '                                                
315.00 170328       **   chk if acc's cif is in ecsdpf, if yes, align to its cif's setting                        
316.00 170123      C                   IF        PEMAPPCODE = '20' OR PEMAPPCODE = '26'                           
317.00 170123      C                   Z-ADD     0             PACCTNO          12 0                              
318.00 170123      C                   Z-ADD     0             PAPP              2 0                              
319.00 170123      C                                                                                              
320.00 170123      C                   IF        PEMAPPCODE = '20'                                                
321.00 170123      C                   EVAL      PACCTNO = 6*10000000000 + %INT(%TRIM(PEMKEY))                    
322.00 170123      C                   ENDIF                                                                      
323.00 170123      C                   IF        PEMAPPCODE = '26'                                                
324.00 170123      C                   EVAL      PACCTNO = 1*10000000000 + %INT(%TRIM(PEMKEY))                    
325.00 170123      C                   ENDIF                                                                      
326.00 170123      C                                                                                              
327.00 170123      C                   CALL      'GACCTCIF'                                                       
328.00 170123      C                   PARM                    PACCTNO                                            
329.00 170123      C                   PARM      20            PAPP                                               
330.00 170123      C                   PARM                    PCIF             10                                
331.00 170123      C                   PARM                    PERRIND           1                                
332.00 170123      C                                                                                              
333.00 170123      C                   EVAL      KEMAPPCODE = '90'                                                
334.00 170123      C                   EVAL      KEMKEY = PCIF                                                    
335.00 170123      C     KECSDPF       CHAIN     ECSDPF                                                           
336.00 170123      C                   IF        %FOUND(ECSDPF)                                                   
337.00 170123      C                   EVAL      PEMOP1 = EMOP1                                                   
338.00 170123      C                   ENDIF                                                                      
339.00 170123      C                   EVAL      EMCLASS = PEMCLASS                                               
340.00 170123      C                   EVAL      EMTYPE = PEMTYPE                                                 
341.00 170123      C                   EVAL      EMSUTYPE = PEMSUTYPE                                             
342.00 170123      C                   EVAL      EMAPPCODE = PEMAPPCODE                                           
343.00 170123      C                   EVAL      EMKEY = PEMKEY                                                   
344.00 170113      C                   EVAL      EMOP1 = PEMOP1                                                   
345.00 161020      C                   EVAL      EMOP2 = PEMOP2                                                   
346.00 161020      C                   EVAL      EMOP3 = PEMOP3                                                   
347.00 170117      C                   EVAL      EMDATE = WKDATE                                                  
348.00 170117      C                   TIME                    EMTIME                                             
349.00 161020      C                   EVAL      EMSRUPD = PEMSRUPD                                               
350.00 170123      C                   EVAL      EMREL = PEMREL                                                   
351.00 170123      C                   WRITE     RECSDPF                                                          
352.00 170123      C                   ENDIF                                                                      
353.00 170123      C                                                                                              
354.00 170123       **   crt vip in ecsdpf, and chk if its acc in ecsdpf then align setting                       
355.00 170123      C                   IF        PEMAPPCODE = '90'                                                
356.00 170123      C                                                                                              
357.00 170123      C                   EVAL      EMCLASS = PEMCLASS                                               
358.00 170123      C                   EVAL      EMTYPE = PEMTYPE                                                 
359.00 170123      C                   EVAL      EMSUTYPE = PEMSUTYPE                                             
360.00 170123      C                   EVAL      EMAPPCODE = PEMAPPCODE                                           
361.00 170123      C                   EVAL      EMKEY = PEMKEY                                                   
362.00 170123      C                   EVAL      EMOP1 = PEMOP1                                                   
363.00 170123      C                   EVAL      EMOP2 = PEMOP2                                                   
364.00 170123      C                   EVAL      EMOP3 = PEMOP3                                                   
365.00 170123      C                   EVAL      EMDATE = WKDATE                                                  
366.00 170123      C                   TIME                    EMTIME                                             
367.00 170123      C                   EVAL      EMSRUPD = PEMSRUPD                                               
368.00 170123      C                   EVAL      EMREL = PEMREL                                                   
369.00 170123      C                   WRITE     RECSDPF                                                          
370.00 170123      C                                                                                              
371.00 170123      ***   check if vip's acc in ecdspf and update them if exist                                    
372.00 170123      C                   EVAL      KCUXBK = 1                                                       
373.00 170123      C                   EVAL      KCUXREC = '1'                                                    
374.00 170123      C                   EVAL      KCUX1CS = PEMKEY                                                 
375.00 170123      C     KCUP009L7     SETLL     CUP009L7                                                         
376.00 170123      C                   READ      CUP009L7                                                         
377.00 170123      C                   DOW       NOT %EOF(CUP009L7) AND CUX1CS = KCUX1CS                          
378.00 170123      C                                                                                              
379.00 170327      C     CUXREL        CHAIN     ECSDREL                                                          
380.00 170321      C                                                                                              
381.00 170321      C                   IF        CUX1AP = 20                                                      
382.00 170328      C                             AND %FOUND(ECSDREL) AND ERFLGV = 'Y'         *acc is SOW/OWN     
383.00 170123      C                   MOVE      CUX1AC        VACCT                                              
384.00 170123      C                   IF        VACCTCODE = '01'                                                 
385.00 170123      C                   EVAL      KEMAPPCODE = '26'                                                
386.00 170123      C                   ENDIF                                                                      
387.00 170123      C                   IF        VACCTCODE = '06'                                                 
388.00 170123      C                   EVAL      KEMAPPCODE = '20'                                                
389.00 170123      C                   ENDIF                                                                      
390.00 170123      C                   MOVEL     VACCTNO       KEMKEY                                             
391.00 170123      C     KECSDPF       CHAIN     ECSDPF                                                           
392.00 170123      C                   IF        %FOUND(ECSDPF)                                                   
393.00 170327      C                   EVAL      EMOP1 = PEMOP1                                                   
394.00 170123      C                   EVAL      EMDATE = WKDATE                                                  
395.00 170123      C                   TIME                    EMTIME                                             
396.00 170123      C                   EVAL      EMSRUPD = PEMSRUPD                                               
397.00 170123      C                   EVAL      EMREL = PEMREL                                                   
398.00 170123      C                   UPDATE    RECSDPF                                                          
399.00 170328       ***  write log for this co-change account                                                     
400.00 170328      C                   EVAL      ELUSER = WUSER                                                   
401.00 170328      C                   EVAL      ELACTDATE = WKDATE                                               
402.00 170328      C                   TIME                    ELACTTIME                                          
403.00 170505 D7100C*                  EVAL      ELACTION = 'UPD CoDone'                                          
404.00 170505 D7100C                   EVAL      ELACTION = 'UPDATE-CON'                                          
405.00 170328      C                   EVAL      ELSTATUS = '0'                                                   
406.00 170328      C                   EVAL      ELAPPCODE = EMAPPCODE                                            
407.00 170328      C                   EVAL      ELKEY = EMKEY                                                    
408.00 170328      C                   EVAL      ELCLASS = ''                                                     
409.00 170328      C                   EVAL      ELTYPE = ''                                                      
410.00 170328      C                   EVAL      ELSUTYPE = ''                                                    
411.00 170328      C                   EVAL      ELOP1 = EMOP1                                                    
412.00 170328      C                   WRITE     RECSDLOG                                                         
413.00 170328      C                                                                                              
414.00 170123      C                   ENDIF                                                                      
415.00 170123      C                   ENDIF                                                                      
416.00 170123      C                                                                                              
417.00 170123      C                   READ      CUP009L7                                                         
418.00 170123      C                   ENDDO                                                                      
419.00 170123      C                                                                                              
420.00 170123      C                   ENDIF                                                                      
421.00 170123      C                                                                                              
422.00 170123      C                   ENDIF                                                                      
423.00 170123      C                                                                                              
424.00 170111       *    Operation: option- update/modify                                                         
425.00 161027      C                   IF        PACTCODE = 'UPD '                                                
426.00 161027      C                   EVAL      KEMAPPCODE = PEMAPPCODE                                          
427.00 161027      C                   EVAL      KEMKEY = PEMKEY                                                  
428.00 161027      C     KECSDPF       CHAIN     ECSDPF                                                           
429.00 170113      C                   IF        %FOUND(ECSDPF)                                                   
430.00 161027      C                   EVAL      EMCLASS = PEMCLASS                                               
431.00 161027      C                   EVAL      EMTYPE = PEMTYPE                                                 
432.00 161020      C                   EVAL      EMSUTYPE = PEMSUTYPE                                             
433.00 161020      C                   EVAL      EMAPPCODE = PEMAPPCODE                                           
434.00 161020      C                   EVAL      EMKEY = PEMKEY                                                   
435.00 161020      C                   EVAL      EMOP1 = PEMOP1                                                   
436.00 161020      C                   EVAL      EMOP2 = PEMOP2                                                   
437.00 161020      C                   EVAL      EMOP3 = PEMOP3                                                   
438.00 170117      C                   EVAL      EMDATE = WKDATE                                                  
439.00 170117      C                   TIME                    EMTIME                                             
440.00 161020      C                   EVAL      EMSRUPD = PEMSRUPD                                               
441.00 161020      C                   EVAL      EMREL = PEMREL                                                   
442.00 161020      C                   UPDATE    RECSDPF                                                          
443.00 170113      C                   ENDIF                                                                      
444.00 170113      C                                                                                              
445.00 170328       **   if it is vip, update its follow accounts                                                 
446.00 170123      C                   IF        PEMAPPCODE = '90'                                                
447.00 170123      C                   EVAL      KCUXBK = 1                                                       
448.00 170123      C                   EVAL      KCUXREC = '1'                                                    
449.00 170123      C                   EVAL      KCUX1CS = PEMKEY                                                 
450.00 170123      C     KCUP009L7     SETLL     CUP009L7                                                         
451.00 170123      C                   READ      CUP009L7                                                         
452.00 170123      C                   DOW       NOT %EOF(CUP009L7) AND CUX1CS = KCUX1CS                          
453.00 170321      C                                                                                              
454.00 170327      C     CUXREL        CHAIN     ECSDREL                                                          
455.00 170123      C                                                                                              
456.00 170321      C                   IF        CUX1AP = 20                                                      
457.00 170328      C                             AND %FOUND(ECSDREL) AND ERFLGV = 'Y'         *acc is SOW/OWN     
458.00 170123      C                   MOVE      CUX1AC        VACCT                                              
459.00 170123      C                   IF        VACCTCODE = '01'                                                 
460.00 170123      C                   EVAL      KEMAPPCODE = '26'                                                
461.00 170123      C                   ENDIF                                                                      
462.00 170123      C                   IF        VACCTCODE = '06'                                                 
463.00 170123      C                   EVAL      KEMAPPCODE = '20'                                                
464.00 170123      C                   ENDIF                                                                      
465.00 170123      C                   MOVEL     VACCTNO       KEMKEY                                             
466.00 170123      C     KECSDPF       CHAIN     ECSDPF                                                           
467.00 170123      C                   IF        %FOUND(ECSDPF)                                                   
468.00 170123      C                   EVAL      EMOP1 = PEMOP1                                                   
469.00 170123      C                   EVAL      EMDATE = WKDATE                                                  
470.00 170123      C                   TIME                    EMTIME                                             
471.00 170123      C                   EVAL      EMSRUPD = PEMSRUPD                                               
472.00 170123      C                   EVAL      EMREL = PEMREL                                                   
473.00 170123      C                   UPDATE    RECSDPF                                                          
474.00 170328      C                                                                                              
475.00 170328       ***  write log for this co-change account                                                     
476.00 170328      C                   EVAL      ELUSER = WUSER                                                   
477.00 170328      C                   EVAL      ELACTDATE = WKDATE                                               
478.00 170328      C                   TIME                    ELACTTIME                                          
479.00 170505 D7100C*                  EVAL      ELACTION = 'UPD CoDone'                                          
480.00 170505 D7100C                   EVAL      ELACTION = 'UPDATE-CON'                                          
481.00 170328      C                   EVAL      ELSTATUS = '0'                                                   
482.00 170328      C                   EVAL      ELAPPCODE = EMAPPCODE                                            
483.00 170328      C                   EVAL      ELKEY = EMKEY                                                    
484.00 170328      C                   EVAL      ELCLASS = ''                                                     
485.00 170328      C                   EVAL      ELTYPE = ''                                                      
486.00 170328      C                   EVAL      ELSUTYPE = ''                                                    
487.00 170328      C                   EVAL      ELOP1 = EMOP1                                                    
488.00 170328      C                   WRITE     RECSDLOG                                                         
489.00 170328      C                                                                                              
490.00 170123      C                   ENDIF                                                                      
491.00 170123      C                                                                                              
492.00 170123      C                   ENDIF                                                                      
493.00 170123      C                   READ      CUP009L7                                                         
494.00 170123      C                   ENDDO                                                                      
495.00 170123      C                   ENDIF                                                                      
496.00 170123      C                                                                                              
497.00 170123      C                   ENDIF                                                                      
498.00 170123      C                                                                                              
499.00 170914 D7xxx *    Operation: option- update cif (allow both vip and non-vip)                               
500.00 170914 D7xxxC                   IF        PACTCODE = 'UPDR'                                                
501.00 170914 D7xxx **   Update all accounts under cif with selected relationship                                 
502.00 170914 D7xxxC                   EVAL      KCUXBK = 1                                                       
503.00 170914 D7xxxC                   EVAL      KCUXREC = '1'                                                    
504.00 170914 D7xxxC                   EVAL      KCUX1CS = PEMKEY                                                 
505.00 170914 D7xxxC     KCUP009L7     SETLL     CUP009L7                                                         
506.00 170914 D7xxxC                   READ      CUP009L7                                                         
507.00 170914 D7xxxC                   DOW       NOT %EOF(CUP009L7) AND CUX1CS = KCUX1CS                          
508.00 170914 D7xxxC                                                                                              
509.00 170914 D7xxxC     CUXREL        CHAIN     ECSDREL                                                          
510.00 170914 D7xxxC                                                                                              
511.00 170914 D7xxxC                   IF        CUX1AP = 20                                                      
512.00 170914 D7xxxC                             AND %FOUND(ECSDREL) AND ERUSR01 = 'Y'        *acc is set to updr 
513.00 170914 D7xxxC                   MOVE      CUX1AC        VACCT                                              
514.00 170914 D7xxxC                   IF        VACCTCODE = '01'                                                 
515.00 170914 D7xxxC                   EVAL      KEMAPPCODE = '26'                                                
516.00 170914 D7xxxC                   ENDIF                                                                      
517.00 170914 D7xxxC                   IF        VACCTCODE = '06'                                                 
518.00 170914 D7xxxC                   EVAL      KEMAPPCODE = '20'                                                
519.00 170914 D7xxxC                   ENDIF                                                                      
520.00 170914 D7xxxC                   MOVEL     VACCTNO       KEMKEY                                             
521.00 170914 D7xxxC     KECSDPF       CHAIN     ECSDPF                                                           
522.00 170914 D7xxxC                   IF        %FOUND(ECSDPF)                                                   
523.00 170914 D7xxxC                   EVAL      EMOP1 = PEMOP1                                                   
524.00 170914 D7xxxC                   EVAL      EMDATE = WKDATE                                                  
525.00 170914 D7xxxC                   TIME                    EMTIME                                             
526.00 170914 D7xxxC                   EVAL      EMSRUPD = PEMSRUPD                                               
527.00 170914 D7xxxC                   EVAL      EMREL = PEMREL                                                   
528.00 170914 D7xxxC                   UPDATE    RECSDPF                                                          
529.00 170914 D7xxxC                                                                                              
530.00 170914 D7xxx ***  write log for this co-change account                                                     
531.00 170914 D7xxxC                   EVAL      ELUSER = WUSER                                                   
532.00 170914 D7xxxC                   EVAL      ELACTDATE = WKDATE                                               
533.00 170914 D7xxxC                   TIME                    ELACTTIME                                          
534.00 170914 D7xxxC                   EVAL      ELACTION = 'UPDR-CON  '                                          
535.00 170914 D7xxxC                   EVAL      ELSTATUS = '0'                                                   
536.00 170914 D7xxxC                   EVAL      ELAPPCODE = EMAPPCODE                                            
537.00 170914 D7xxxC                   EVAL      ELKEY = EMKEY                                                    
538.00 170914 D7xxxC                   EVAL      ELCLASS = ''                                                     
539.00 170914 D7xxxC                   EVAL      ELTYPE = ''                                                      
540.00 170914 D7xxxC                   EVAL      ELSUTYPE = ''                                                    
541.00 170914 D7xxxC                   EVAL      ELOP1 = EMOP1                                                    
542.00 170914 D7xxxC                   WRITE     RECSDLOG                                                         
543.00 170914 D7xxxC                                                                                              
544.00 170914 D7xxxC                   ENDIF                                                                      
545.00 170914 D7xxxC                                                                                              
546.00 170914 D7xxxC                   ENDIF                                                                      
547.00 170914 D7xxxC                   READ      CUP009L7                                                         
548.00 170914 D7xxxC                   ENDDO                                                                      
549.00 170914 D7xxxC                                                                                              
550.00 170914 D7xxx **   Update cif's record in ECSDPF if there is one (only apply on vip)                        
551.00 170914 D7xxxC                   EVAL      KEMAPPCODE = PEMAPPCODE                                          
552.00 170914 D7xxxC                   EVAL      KEMKEY = PEMKEY                                                  
553.00 170914 D7xxxC     KECSDPF       CHAIN     ECSDPF                                                           
554.00 170914 D7xxxC                   IF        %FOUND(ECSDPF)                                                   
555.00 170914 D7xxxC                   EVAL      EMCLASS = PEMCLASS                                               
556.00 170914 D7xxxC                   EVAL      EMTYPE = PEMTYPE                                                 
557.00 170914 D7xxxC                   EVAL      EMSUTYPE = PEMSUTYPE                                             
558.00 170914 D7xxxC                   EVAL      EMAPPCODE = PEMAPPCODE                                           
559.00 170914 D7xxxC                   EVAL      EMKEY = PEMKEY                                                   
560.00 170914 D7xxxC                   EVAL      EMOP1 = PEMOP1                                                   
561.00 170914 D7xxxC                   EVAL      EMOP2 = PEMOP2                                                   
562.00 170914 D7xxxC                   EVAL      EMOP3 = PEMOP3                                                   
563.00 170914 D7xxxC                   EVAL      EMDATE = WKDATE                                                  
564.00 170914 D7xxxC                   TIME                    EMTIME                                             
565.00 170914 D7xxxC                   EVAL      EMSRUPD = PEMSRUPD                                               
566.00 170914 D7xxxC                   EVAL      EMREL = PEMREL                                                   
567.00 170914 D7xxxC                   UPDATE    RECSDPF                                                          
568.00 170914 D7xxxC                   ENDIF                                                                      
569.00 170914 D7xxxC                                                                                              
570.00 170914 D7xxxC                   ENDIF                                                                      
571.00 170914      C                                                                                              
572.00 170123       *    Operation: option- inquiry                                                               
573.00 170123      C                   IF        PACTCODE = 'INQ '                                                
574.00 170123      C                   EVAL      KEMAPPCODE = PEMAPPCODE                                          
575.00 161027      C                   EVAL      KEMKEY = PEMKEY                                                  
576.00 161027      C     KECSDPF       CHAIN     ECSDPF                                                           
577.00 170113      C                   IF        %FOUND(ECSDPF)                                                   
578.00 161027      C                   EVAL      PEMCLASS = EMCLASS                                               
579.00 161027      C                   EVAL      PEMTYPE = EMTYPE                                                 
580.00 161027      C                   EVAL      PEMSUTYPE = EMSUTYPE                                             
581.00 161027      C                   EVAL      PEMAPPCODE = EMAPPCODE                                           
582.00 161027      C                   EVAL      PEMKEY = EMKEY                                                   
583.00 161027      C                   EVAL      PEMOP1 = EMOP1                                                   
584.00 161027      C                   EVAL      PEMOP2 = EMOP2                                                   
585.00 161027      C                   EVAL      PEMOP3 = EMOP3                                                   
586.00 161027      C                   EVAL      PEMDATE = EMDATE                                                 
587.00 161027      C                   EVAL      PEMTIME = EMTIME                                                 
588.00 161027      C                   EVAL      PEMSRUPD = EMSRUPD                                               
589.00 161027      C                   EVAL      PEMREL = EMREL                                                   
590.00 170113      C                   ENDIF                                                                      
591.00 161027      C                   ENDIF                                                                      
592.00 170123      C                                                                                              
593.00 170123       *    Operation: option- inquiry                                                               
594.00 170123      C                   IF        PACTCODE = 'DLT '                                                
595.00 170123      C                   EVAL      KEMAPPCODE = PEMAPPCODE                                          
596.00 170123      C                   EVAL      KEMKEY = PEMKEY                                                  
597.00 170123      C     KECSDPF       CHAIN     ECSDPF                                                           
598.00 170123      C                   IF        %FOUND(ECSDPF)                                                   
599.00 170123      C                   DELETE    RECSDPF                                                          
600.00 170123      C                   ENDIF                                                                      
601.00 170123      C                   ENDIF                                                                      
602.00 170116      C                                                                                              
603.00 161027      C                   ENDIF                                                                      
604.00 161027      C                                                                                              
605.00 170111       *    End part - write output parms                                                            
606.00 170111      C                   IF        PICBSSTS = '0'                                                   
607.00 170111      C                   EVAL      PSTS = 'IHDSUCC'                                                 
608.00 170111      C                   MOVE      WKDATE        VDATE                                              
609.00 170111      C                   TIME                    VTIME                                              
610.00 170111      C                   MOVE      VDATE         VTSTMP                                             
611.00 170111      C                   MOVE      VTIME         VTSTMP                                             
612.00 170111      C                   MOVE      VTSTMP        PMOMENT                                            
613.00 170111      C                   ENDIF                                                                      
614.00 170111      C                                                                                              
615.00 170111       *    End part - write log                                                                     
616.00 170505 D7100C                   IF        PICBSSTS = '0'                               *log only success   
617.00 170914 D7xxxC                             AND (PACTCODE = 'CRT ' OR PACTCODE = 'UPD '  *log crt/upd/updr   
618.00 170914 D7xxxC                             OR PACTCODE = 'UPDR' )                                           
619.00 170914 D7100C*                            AND (PACTCODE = 'CRT ' OR PACTCODE = 'UPD ') *log only crt/upd   
620.00 170111      C                   EVAL      ELUSER = WUSER                               *write ELUSER       
621.00 170111      C                   EVAL      ELACTDATE = WKDATE                           *write ELACTDATE    
622.00 170111      C                   TIME                    ELACTTIME                      *write ELACTTIME    
623.00 170505 D7100C*                  IF        PICBSSTS = '0'                                                   
624.00 170505 D7100C*                  EVAL      ELACTION = PACTCODE + ' Done'                *write ELACTION     
625.00 170505 D7100C*                  EVAL      ELSTATUS = '0'                               *write ELSTATUS     
626.00 170505 D7100C*                  ELSE                                                                       
627.00 170505 D7100C*                  EVAL      ELACTION = PACTCODE + ' Fail'                                    
628.00 170505 D7100C*                  EVAL      ELSTATUS = '1'                                                   
629.00 170505 D7100C*                  ENDIF                                                                      
630.00 170505 D7100C                   IF        PACTCODE = 'CRT '                                                
631.00 170505 D7100C                   EVAL      ELACTION = 'CREATE    '                      *write ELACTION     
632.00 170505 D7100C                   ENDIF                                                                      
633.00 170505 D7100C                   IF        PACTCODE = 'UPD '                                                
634.00 170505 D7100C                   EVAL      ELACTION = 'UPDATE    '                      *write ELACTION     
635.00 170505 D7100C                   ENDIF                                                                      
636.00 170914 D7xxxC                   IF        PACTCODE = 'UPDR'                                                
637.00 170914 D7xxxC                   EVAL      ELACTION = 'UPDATE(R) '                      *write ELACTION     
638.00 170914 D7xxxC                   ENDIF                                                                      
639.00 170505 D7100C                   EVAL      ELSTATUS = '0'                               *write ELSTATUS     
640.00 170328      C                   EVAL      ELAPPCODE = PEMAPPCODE                       *write ELAPPCODE    
641.00 170328      C                   EVAL      ELKEY = PEMKEY                               *write ELKEY        
642.00 170328      C                   EVAL      ELCLASS = PEMCLASS                           *write ELCLASS      
643.00 170328      C                   EVAL      ELTYPE = PEMTYPE                             *write ELTYPE       
644.00 170328      C                   EVAL      ELSUTYPE = PEMSUTYPE                         *write ELSUTYPE     
645.00 170328      C                   EVAL      ELOP1 = PEMOP1                               *write ELOP1        
646.00 170328      C                   EVAL      ELOP2 = PEMOP2                               *write ELOP2        
647.00 170328      C                   EVAL      ELOP3 = PEMOP3                               *write ELOP3        
648.00 170328      C                   EVAL      ELDATE = WKDATE                              *write ELDATE       
649.00 170328      C                   TIME                    ELTIME                         *write ELTIME       
650.00 170328      C                   EVAL      ELSRUPD = PEMSRUPD                           *write ELSRUPD      
651.00 170328      C                   EVAL      ELREL = PEMREL                               *write ELREL        
652.00 170328      C                   WRITE     RECSDLOG                                                         
653.00 170505 D7100C                   ENDIF                                                                      
654.00 170123      C                                                                                              
655.00 170123      C                   SETON                                        LR                            
656.00 170328       **                                                                                            
