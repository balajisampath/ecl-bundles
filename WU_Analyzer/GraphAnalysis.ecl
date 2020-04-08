IMPORT STD;

EXPORT GraphAnalysis     :=   MODULE
 

EXPORT fn_WorkUnitInfo_SoapCall(STRING IP='http://XX.XXX.XX.X',DECIMAL5 Port =8010 , STRING WUId) := FUNCTION 

     STRING URL := IP+':'+(STRING)Port+'/WsWorkunits/';



     WuinfoInRecord :=  RECORD, MAXLENGTH(100)
               STRING eclWorkunit{XPATH('Wuid')} := WUId;
     END;

     rESPExceptions :=   RECORD
     
          STRING Code{XPATH('Code'),MAXLENGTH(10)};
          STRING Audience{XPATH('Audience'),MAXLENGTH(50)};
          STRING Source{XPATH('Source'),MAXLENGTH(30)};
          STRING Message{XPATH('Message'),MAXLENGTH(200)};
     
     END;
     
     
     srcFile := RECORD
          
          STRING FILEName {XPATH('Name')};
          STRING CLUSTER {XPATH('Cluster')};
          STRING RecCount {XPATH('Count')};
     
     END; 


     ResultFiles_Lay := RECORD

          INTEGER Seq {XPATH('Sequence')};
          STRING Values {XPATH('Value')};
          STRING Link {XPATH('Link')};
          STRING FileName {XPATH('FileName')};
          STRING XmlSchema {XPATh('XmlSchema')};

     END;

     WuinfoResponse := RECORD

          STRING Owner{XPATH('Workunit/Owner'),MAXLENGTH(20)};
          STRING CLUSTER{XPATH('Workunit/Cluster'),MAXLENGTH(20)};
          STRING Jobname{xpath('Workunit/Jobname'),MAXLENGTH(20)};
          STRING State{XPATH('Workunit/State'),MAXLENGTH(20)};
          STRING Query{XPATH('Workunit/Query'),MAXLENGTH(100)};
          DATASET(srcFile) SrcFiles{XPATH('Workunit/SourceFiles/ECLSourceFile')};
          DATASET(rESPExceptions) Exceptions{XPATH('Exceptions/ESPException'),MAXCOUNT(110)};
          DATASET(ResultFiles_Lay) ResultFiles{XPATH('Workunit/Results/ECLResult')};
     
     END;

     WuInfoSoapCall :=   SOAPCALL(URL
                         ,'WUInfo'
                         , wuinfoInRecord
                         ,wuinfoResponse
                         ,XPATH('WUInfoResponse')
                         );


     DATASET(ResultFiles_Lay) fileResults := WuInfoSoapCall.ResultFiles;
     DATASET(srcFile) Sourcefile := WuInfoSoapCall.SrcFiles;

     ResultFiles_CustomLay := RECORD

          INTEGER Seq ;
          STRING Values ;
          STRING Link ;
          STRING FileName;
          STRING XmlSchema;

     END;

     ResultFl_CustomLay := RECORD
          
          STRING FileName;

     END;

     FileResultRecs := PROJECT(fileResults,TRANSFORM(ResultFiles_CustomLay,SELF := LEFT));

     WrittenkeyFilesDS := TABLE(FileResultRecs,{filename,STRING Values := Values, Filetype :='K'})((REGEXFIND('::key::',FileName,NOCASE)) OR (REGEXFIND('key::',FileName,NOCASE)));
     SourceFilesDS := TABLE(Sourcefile,{filename,STRING Values := '0',Filetype :='S'});

     WuinfoRec := WrittenkeyFilesDS + SourceFilesDS;

     RETURN WuinfoRec;

 END;
 
//Function for GraphInfo Soapcall
EXPORT fn_getGraphInfo(  STRING URL ='http://XX.XXX.XX.X:8010', 
                         STRING WUID,
                         STRING GName ='graph1',
                         STRING SGId = '')   :=   FUNCTION
                    
                    
      WuGraphInRecord :=  RECORD, MAXLENGTH(100)
           
          STRING eclWorkunit  {XPATH('Wuid')}          := WUID;
          STRING GraphName    {XPATH('GraphName')}     := GName;
          STRING SubGraphId   {XPATH('SubGraphId')}    := SGId;
          
      END;

     rESPExceptions :=   RECORD
          
          STRING Code{XPATH('Code'),MAXLENGTH(10)};
          STRING Audience{XPATH('Audience'),MAXLENGTH(50)};
          STRING Source{XPATH('Source'),MAXLENGTH(30)};
          STRING Message{XPATH('Message'),MAXLENGTH(200)};
    
     END;

     rGraphInfo     :=   RECORD
     
          STRING GraphName{XPATH('Name'),MAXLENGTH(20)};
          STRING GraphText{XPATH('Graph'),MAXLENGTH(20)};
          STRING Label{XPATH('Label'),MAXLENGTH(20)};
          
     END;

     WuGraphResponse := RECORD
     
          DATASET(rGraphInfo) GraphInfo{XPATH('Graphs/ECLGraphEx'),maxcount(110)};
         //dataset(rESPExceptions) Exceptions{XPATH('Exceptions/ESPException'),maxcount(110)};
     END;

     WuGraphSoapCall := SOAPCALL(  URL +'/WsWorkunits?ver_=1.56'
                                   ,'WUGetGraph'
                                   ,WuGraphInRecord
                                   ,WuGraphResponse
                                   ,XPATH('WUGetGraphResponse')
                                );

     linerec := { STRING line };
     
     GraphDetails   :=   DATASET([{WuGraphSoapCall.graphinfo[1].GraphText}],linerec);

     nodeRec   :=   RECORD
     
          STRING name;
          string value;
     END;
     
     
     outrec    :=   RECORD
          
          STRING nodeid;
          STRING label;
          DATASET(nodeRec) nodeinfo;
          // STRING line;
     END;

     extractedRec := RECORD
 
          STRING name;
          STRING value;
     
     END;
     
     outrec t(lineRec L) := TRANSFORM
          
          SELF.nodeid := XMLTEXT('@id');
          SELF.label := XMLTEXT('@label');
          SELF.nodeinfo := XMLPROJECT('att',
          TRANSFORM(extractedRec,
          SELF.name := XMLTEXT('@name'),
          SELF.value := XMLTEXT('@value')));
          SELF := L;
    
    END;

     extractedGraphDetails := PARSE(GraphDetails, line, t(LEFT), XML('/graph/node/att/graph/node'));
     
     RETURN extractedGraphDetails;
 
   END;
   
  //Function for WorkunitInfo Soapcall 
   
   EXPORT fn_WUInfo_SoapCall(STRING URL ='http://XX.XXX.XX.X:8010', STRING WUId ) := FUNCTION 

     WuinfoInRecord :=   RECORD, MAXLENGTH(100)
     
          STRING eclWorkunit{XPATH('Wuid')} := WUId;
 
     END;

     rESPExceptions :=   RECORD
          
          STRING Code{XPATH('Code'),MAXLENGTH(10)};
          STRING Audience{XPATH('Audience'),MAXLENGTH(50)};
          STRING Source{XPATH('Source'),MAXLENGTH(30)};
          STRING Message{XPATH('Message'),MAXLENGTH(200)};
     
     END;

     rtimer := RECORD
     
          STRING Name {XPATH('Name')};
          String GraphValue {XPATH('Value')};
          STRING GraphCount {XPATH('count')};
          STRING GraphName {XPATH('GraphName')};
          STRING GraphSubGraphId {XPATH('SubGraphId')};
     
     END; 

     rgraphtiming := RECORD
 
          STRING    GName {XPATH('Name')};
          UNSIGNED  GraphNum {XPATH('GraphNum')};
          UNSIGNED  SubGraphNum {XPATH('SubGraphNum')};
          UNSIGNED  GID {XPATH('GID')};
          UNSIGNED  Min {XPATH('Min')};
          UNSIGNED  MS {XPATH('MS')};
     
     END; 

     rgraphlist := RECORD
 
          STRING GraphName {XPATH('Name')};
          String GraphLabel {XPATH('Label')};
          STRING GraphType {XPATH('Type')};
          STRING GraphStart {XPATH('WhenStarted')};
          STRING GraphEnd {XPATH('WhenFinished')};
 
     END; 
     
     WuinfoResponse := RECORD

          STRING Jobname{XPATH('Workunit/Jobname'),MAXLENGTH(20)};
          DATASET(rgraphlist) GraphList{XPATH('Workunit/Graphs/ECLGraph')};
          DATASET(rtimer) Timer{XPATH('Workunit/Timers/ECLTimer')};
          DATASET(rgraphtiming) GraphTiming{XPATH('Workunit/TimingData/ECLTimingData')};
          // dataset(rESPExceptions) Exceptions{XPATH('Exceptions/ESPException'),maxcount(110)};

     END;

     nodeRec := RECORD
          STRING name;
          STRING value;
     END;
     
     outrec := RECORD
          
          STRING nodeid;
          STRING label;
          DATASET(nodeRec) nodeinfo;
          // STRING line;
     END;

     WuinfoResponsewithgraph := RECORD
          rgraphlist;
          dataset(outrec) GraphDetails;
     END;

     WuInfoSoapCall :=   SOAPCALL( URL +'/WsWorkunits?ver_=1.56'
                                   ,'WUInfo'
                                   , wuinfoInRecord
                                   ,wuinfoResponse
                                   ,XPATH('WUInfoResponse')
                                  );
                                  
                                  
     out            :=   PROJECT(WuInfoSoapCall.Graphlist,
                                   TRANSFORM(WuinfoResponsewithgraph,
                                   SELF.GraphDetails := fn_getgraphinfo(URL,WUId,LEFT.GraphName),
                                   SELF := left,SELF :=[]));
    RETURN out;
 
 END;

//Function for generating graphdetails 

EXPORT fn_GraphDetails(STRING URL ='http://XX.XXX.XX.X:8010', STRING WUId ) := FUNCTION

       
       
       rgraphlist := RECORD
 
          STRING GraphName;
          STRING GraphStart;
          STRING GraphEnd ;
          STRING TimeTaken :='';
 
     END; 
     
     nodeRec := RECORD
          STRING name;
          STRING value;
     END;
     
     outrec := RECORD
          
          STRING nodeid;
          STRING label;
          DATASET(nodeRec) nodeinfo;
          
     END;

     WuinfoResponsewithgraph := RECORD
          rgraphlist;
          dataset(outrec) GraphDetails;
     END;
     
     GraphDetailsDS      :=   PROJECT(fn_WUInfo_SoapCall(URL,WUId),TRANSFORM(WuinfoResponsewithgraph,SELF:=LEFT));
      
     Normalize_child_lt :=   RECORD
          
          STRING nodeid;
          STRING label;
          STRING name;
          STRING value;
     
     END;
     
     Normalize_mainlt  :=   RECORD
     
          rgraphlist;
          DATASET(Normalize_child_lt) childgraphdetails;
          
    END;
  
   //Funtion to convert HH:MM:SS to seconds
     toSecondsFn(String time)  :=   FUNCTION
                   
           split_time         :=   STD.STR.Splitwords(time,'T');
           filterout_z        :=   STD.STR.filterout(split_time[2],'Z');
           split_hh_mm_ss     :=   STD.STR.Splitwords(filterout_z,':');
           time_in_sec        :=   ((INTEGER)split_hh_mm_ss[1]*3600)  + 
                                   ((INTEGER)split_hh_mm_ss[2]*60)    +
                                   (REAL)split_hh_mm_ss[3];
           RETURN(time_in_sec);
     END;
     
     //Function to convert ns,ms,mins to seconds
     
    alltime_toseconds(STRING t)   :=   FUNCTION
          
          ns_to_s(string time)     :=  ((DECIMAL12_8)STD.STR.FILTEROUT(TRIM(t),'ns')*0.000000001);    
          ms_to_s(string time)     :=  ((DECIMAL12_8)STD.STR.FILTEROUT(TRIM(t),'ms')*0.001);
          
          min_to_s(string time)    :=   FUNCTION
                    split_time :=   STD.STR.Splitwords(TRIM(t),':');
                    return(((INTEGER)split_time[1]*60)    +
                            (REAL)split_time[2]);
          END;
          time_in_seconds     :=   MAP(STD.STR.FIND(t,'ms')>0 =>(STRING)ms_to_s(t),
                                       STD.STR.FIND(t,'ns')>0 =>(STRING)ns_to_s(t),
                                       STD.STR.FIND(t,':')>0 => (STRING)min_to_s(t),
                                       STD.STR.FILTEROUT(t,'s'));
           RETURN(time_in_seconds)  ;                         
     END;
     
     
     Normalize_grapgDetails  :=   PROJECT(GraphDetailsDS,TRANSFORM(Normalize_mainlt,
                                                       SELF.childgraphdetails   :=   NORMALIZE(LEFT.GraphDetails,
                                                                                               LEFT.nodeinfo,
                                                                                               TRANSFORM(Normalize_child_lt,
                                                                                               SELF.nodeid    :=   LEFT.nodeid,
                                                                                               SELF.label     :=   LEFT.label,
                                                                                               SELF           :=   RIGHT)),
                                                        SELF.TimeTaken          :=   (STRING)((DECIMAL10_3)toSecondsFn(LEFT.GraphEnd) - (DECIMAL10_3)toSecondsFn(LEFT.GraphStart)),                                      
                                                        SELF                    :=   LEFT));
                                                        
     
         
     
     graphDetails_lt   :=     RECORD
        
        STRING nodeid ;
        STRING label ;
        STRING Graphdetails_Kind;
        STRING Graphdetails_definition;
        STRING Graphdetails_name;
        STRING Graphdetails_ecl;
        STRING Graphdetails_recordSize;
        STRING Graphdetails_predictedCount;
        STRING Graphdetails_fileName;
        STRING Graphdetails_timeMinMs;
        STRING Graphdetails_TimeMinLocalExecute;
        STRING Graphdetails_timeMaxMs;
        STRING Graphdetails_TimeMaxLocalExecute;
        STRING Graphdetails_TimeAvgLocalExecute;
        STRING Graphdetails_SkewMinLocalExecute;
        STRING Graphdetails_SkewMaxLocalExecute;
        STRING Graphdetails_NodeMinLocalExecute;
        STRING Graphdetails_NodeMaxLocalExecute;
        STRING Graphdetails_grouped;
        STRING Graphdetails_internal;
        STRING Graphdetails_isSpill;
        STRING Graphdetails_spillReason;
        
     END;
     
     expected_graphLayout     :=   RECORD
     
          rgraphlist;
          DATASET(graphDetails_lt) Graphinfo;
      
     END;
     
     
     expected_graphLayout project_transform(Normalize_mainlt l)     :=   TRANSFORM
     
        graphlt   :=     RECORD
        
        STRING nodeid                             :=   l.childgraphdetails.nodeid;
        STRING label                              :=   l.childgraphdetails.label;
        STRING Graphdetails_Kind                  :=   '';
        STRING Graphdetails_definition            :=   '';
        STRING Graphdetails_name                  :=   '';
        STRING Graphdetails_ecl                   :=   '';
        STRING Graphdetails_recordSize            :=   '';
        STRING Graphdetails_predictedCount        :=   '';
        STRING Graphdetails_fileName              :=   '';
        STRING Graphdetails_timeMinMs             :=   '';
        STRING Graphdetails_TimeMinLocalExecute   :=   '';
        STRING Graphdetails_timeMaxMs             :=   '';
        STRING Graphdetails_TimeMaxLocalExecute   :=   '';
        STRING Graphdetails_TimeAvgLocalExecute   :=   '';
        STRING Graphdetails_SkewMinLocalExecute   :=   '';
        STRING Graphdetails_SkewMaxLocalExecute   :=   '';
        STRING Graphdetails_NodeMinLocalExecute   :=   '';
        STRING Graphdetails_NodeMaxLocalExecute   :=   '';
        STRING Graphdetails_grouped               :=   '';
        STRING Graphdetails_internal              :=   '';
        STRING Graphdetails_isSpill               :=   '';
        STRING Graphdetails_spillReason           :=   '';
        
        END;
     
          parent_lt := TABLE(l.childgraphdetails,graphlt);
     
          RECORDOF(graphlt) trans(RECORDOF(graphlt) L,Normalize_child_lt R) :=   TRANSFORM
            
          SELF.nodeid                             :=   l.nodeid;
          SELF.label                              :=   l.label;
          SELF.Graphdetails_Kind                  :=   IF(r.name ='_kind',r.value,l.Graphdetails_Kind);
          SELF.Graphdetails_definition            :=   IF(r.name ='definition',r.value,l.Graphdetails_definition);
          SELF.Graphdetails_name                  :=   IF(r.name ='name',r.value,l.Graphdetails_name);
          SELF.Graphdetails_ecl                   :=   IF(r.name ='ecl',r.value,l.Graphdetails_ecl);
          SELF.Graphdetails_recordSize            :=   IF(r.name ='recordSize',r.value,l.Graphdetails_recordSize);
          SELF.Graphdetails_predictedCount        :=   IF(r.name ='predictedCount',r.value,l.Graphdetails_predictedCount);
          SELF.Graphdetails_fileName              :=   IF(r.name ='_fileName',r.value,l.Graphdetails_fileName);
          SELF.Graphdetails_timeMinMs             :=   IF(r.name ='timeMinMs',(STRING)((DECIMAL12_8)TRIM(r.value) * 0.001),l.Graphdetails_timeMinMs);
          SELF.Graphdetails_TimeMinLocalExecute   :=   IF(r.name ='TimeMinLocalExecute',alltime_toseconds(r.value),l.Graphdetails_TimeMinLocalExecute);
          SELF.Graphdetails_timeMaxMs             :=   IF(r.name ='timeMaxMs',(STRING)((DECIMAL12_8)TRIM(r.value) * 0.001),l.Graphdetails_timeMaxMs);
          SELF.Graphdetails_TimeMaxLocalExecute   :=   IF(r.name ='TimeMaxLocalExecute',alltime_toseconds(r.value),l.Graphdetails_TimeMaxLocalExecute);
          SELF.Graphdetails_TimeAvgLocalExecute   :=   IF(r.name ='TimeAvgLocalExecute',alltime_toseconds(r.value),l.Graphdetails_TimeAvgLocalExecute);
          SELF.Graphdetails_SkewMinLocalExecute   :=   IF(r.name ='SkewMinLocalExecute',r.value,l.Graphdetails_SkewMinLocalExecute);
          SELF.Graphdetails_SkewMaxLocalExecute   :=   IF(r.name ='SkewMaxLocalExecute',r.value,l.Graphdetails_SkewMaxLocalExecute);
          SELF.Graphdetails_NodeMinLocalExecute   :=   IF(r.name ='NodeMinLocalExecute',r.value,l.Graphdetails_NodeMinLocalExecute);
          SELF.Graphdetails_NodeMaxLocalExecute   :=   IF(r.name ='NodeMaxLocalExecute',r.value,l.Graphdetails_NodeMaxLocalExecute);
          SELF.Graphdetails_grouped               :=   IF(r.name ='grouped',r.value,l.Graphdetails_grouped);
          SELF.Graphdetails_internal              :=   IF(r.name ='_internal',r.value,l.Graphdetails_internal);
          SELF.Graphdetails_isSpill               :=   IF(r.name ='_isSpill',r.value,l.Graphdetails_isSpill);
          SELF.Graphdetails_spillReason           :=   IF(r.name ='spillReason',r.value,l.Graphdetails_spillReason);
          
          END;
         
         Denorm_ds       :=    DENORMALIZE(parent_lt,l.childgraphdetails,LEFT.nodeid=RIGHT.nodeid,trans(LEFT,RIGHT));
         SELF.Graphinfo  :=    ROLLUP(SORT(Denorm_ds,(INTEGER)nodeid),LEFT.nodeid=RIGHT.nodeid,TRANSFORM(RECORDOF(graphDetails_lt),SELF:=RIGHT));
         SELF            :=  L;
         
       END;
       
       
      GraphDetailsReport :=   PROJECT(Normalize_grapgDetails,project_transform(LEFT));
         
      graphlt1   :=     RECORD
        expected_graphLayout and not Graphinfo;
        STRING nodeid;
        STRING label;
        STRING Graphdetails_Kind:= '';
        STRING Graphdetails_definition:= '';
        STRING Graphdetails_name:= '';
        STRING Graphdetails_ecl:= '';
        STRING Graphdetails_recordSize:= '';
        STRING Graphdetails_predictedCount:= '';
        STRING Graphdetails_fileName:= '';
        STRING Graphdetails_timeMinMs:= '';
        STRING Graphdetails_TimeMinLocalExecute:= '';
        STRING Graphdetails_timeMaxMs:= '';
        STRING Graphdetails_TimeMaxLocalExecute:= '';
        STRING Graphdetails_TimeAvgLocalExecute:= '';
        STRING Graphdetails_SkewMinLocalExecute:= '';
        STRING Graphdetails_SkewMaxLocalExecute:= '';
        STRING Graphdetails_NodeMinLocalExecute:= '';
        STRING Graphdetails_NodeMaxLocalExecute:= '';
        STRING Graphdetails_grouped               :=   '';
        STRING Graphdetails_internal              :=   '';
        STRING Graphdetails_isSpill               :=   '';
        STRING Graphdetails_spillReason           :=   '';
     end;
      RETURN NORMALIZE(GraphDetailsReport,LEFT.Graphinfo,TRANSFORM(graphlt1,SELF := RIGHT, SELF:=LEFT,SELF :=[]));   
     
     END;

END;

graphresds := GraphAnalysis.fn_GraphDetails(, 'WUID') ;
avg:= AVE(graphresds,(DECIMAL8)Timetaken);
dupsetminor 		:= set(table(graphresds,{Graphdetails_ecl,cnt := count(group)},Graphdetails_ecl)(cnt >1),Graphdetails_ecl);
dupsetminorname := set(table(graphresds(Graphdetails_name <> ''),{Graphdetails_name,cnt := count(group)},Graphdetails_name)(cnt >1),Graphdetails_name);
dupsetminorDefn := set(table(graphresds(Graphdetails_definition <> ''),{Graphdetails_definition,cnt := count(group)},Graphdetails_definition)(cnt >1),Graphdetails_definition);
dupsetmajor 		:= set(table(graphresds((DECIMAL8) Timetaken > avg),{Graphdetails_ecl,cnt := count(group)},Graphdetails_ecl)(cnt >1),Graphdetails_ecl);
topbykind				:= sort(table(graphresds,{Task:= label[1..if (std.str.find(label,'\'')<=0,length(label),std.str.find(label,'\'')-1)],tm := (REAL4) (SUM(GROUP,(REAL4)Graphdetails_TimeAvgLocalExecute)[1..5])},label[1..if (std.str.find(label,'\'')<=0,length(label),std.str.find(label,'\'')-1)]),-tm);

Output(topbykind,named('EffortByTask'),all) ;
Output(graphresds,named('GraphDetails'),all) ;
Output(graphresds(Graphdetails_ecl in dupsetminor), named('PossibleMinorDuplicateTasks'));
Output(graphresds(Graphdetails_name in dupsetminorname), named('PossibleMinorDuplicateTasksByVariableName'));
Output(graphresds(Graphdetails_definition in dupsetminorDefn), named('PossibleMinorDuplicateTasksByDefinition'));
Output(graphresds(Graphdetails_ecl in dupsetmajor), named('PossibleMajorDuplicateTasks'));
Output(graphresds((INTEGER)Graphdetails_SkewMinLocalExecute not between -100 and 100 or 
									(INTEGER)Graphdetails_SkewMaxLocalExecute not between -100 and 100
									), named('PossibleSkewedDistributions'));
