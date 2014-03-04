EXPORT DFU_SOAP := MODULE
IMPORT STD;
IMPORT LIB_THORLIB;

/*
SOAP calls for accessing DFU services
*/
  EXPORT Bundle := MODULE(Std.BundleBase)
    EXPORT Name       	:= 'DFU_SOAP';
    EXPORT Description  := 'Abstracting DFU SOAP Calls';
    EXPORT Authors      := ['balajisampath'];
    EXPORT License      := 'http://www.apache.org/licenses/LICENSE-2.0';
    EXPORT Copyright    := 'Use, Improve, Extend, Distribute';
    EXPORT DependsOn    := [];
    EXPORT Version      := '1.0.1';
  END; 

/* Get the ESP IP */
EXPORT fn_getIP() := FUNCTION

RETURN STD.STR.SPLITWORDS(lib_ThorLib.thorlib.daliservers(),':')[1];

END;

EXPORT fn_GetCoulmnInfo(STRING FileName = '',
												STRING IP 			='',
												STRING port			= '8010', 
												STRING Cluster = '',
												STRING Include_fpos = 'N') := FUNCTION
/*

Function to return Columns with datatypes of the given INDEX/DATA (logical file name)

INPUT  	: Logical File name with IP,PORT,CLUSTER
OUTPUT 	: Index Keys and data types as comma,pipeline  seperated String
Usage 	: fn_GetCoulmnInfo('~thor::filename');

*/

// Build the soap URL

STRING URl 		:= 'http://' + IF(IP = '',fn_getIP(),IP )+ ':' + port +'/WsDfu/?ver_=1.22';
STRING fName 	:= IF(Cluster <>'',Cluster + '::' + FileName,FileName);


// SOAP request data structure
DFUSearchDataRequest := 
		RECORD
			STRING OpenLogicalName{XPATH('OpenLogicalName')} 	:= fName;
			STRING Cluster{XPATH('Cluster')} 									:= '';
		END;

// SOAP result exception data structure
 ESPExceptions_Lay :=
		RECORD
				STRING Code			{XPATH('Code'),MAXLENGTH(10)};
				STRING Audience	{XPATH('Audience'),MAXLENGTH(50)};
				STRING Source		{XPATH('Source'),MAXLENGTH(30)};
				STRING Message	{XPATH('Message'),MAXLENGTH(200)};
		END;

// SOAP result data structure		
DFUDataColumn_Lay :=  RECORD 	

	 STRING  	ColumnLabel	{XPATH('ColumnLabel'),MAXLENGTH(70)};
   STRING 	ColumnType	{XPATH('ColumnType'),MAXLENGTH(20)};
	 STRING 	ColumnValue	{XPATH('ColumnValue'),MAXLENGTH(20)};
	 INTEGER 	ColumnSize	{XPATH('ColumnSize'),MAXLENGTH(20)};
	 INTEGER	MaxSize			{XPATH('MaxSize'),MAXLENGTH(20)};
		 
END;
		
DFUDataCols :=RECORD  

	DATASET (DFUDataColumn_Lay)  DFUDataColumn {XPATH ('DFUDataColumn')};


END;
DFUSearchDataResponse      := RECORD
	
		STRING  	LogicalName	{XPATH('LogicalName'),MAXLENGTH(70)};
		INTEGER 	Total				{XPATH('Total'),MAXLENGTH(15)};
		STRING 		Cluster			{XPATH('Cluster'),MAXLENGTH(25)};
		STRING 		ParentName	{XPATH('ParentName'),MAXLENGTH(20)};
		INTEGER 	StartIndex	{XPATH('StartIndex'),MAXLENGTH(7)};
		INTEGER 	EndIndex		{XPATH('EndIndex'),MAXLENGTH(12)};
    DATASET(ESPExceptions_Lay)    Exceptions{XPATH('Exceptions/ESPException'),maxcount(110)};
		
		DATASET(DFUDataCols)  DFUDataKeyedColumns1 {XPATH('DFUDataKeyedColumns1')};
		DATASET(DFUDataCols)  DFUDataKeyedColumns2 {XPATH('DFUDataKeyedColumns2')};	
		DATASET(DFUDataCols)  DFUDataKeyedColumns3 {XPATH('DFUDataKeyedColumns3')};	
		DATASET(DFUDataCols)  DFUDataKeyedColumns4 {XPATH('DFUDataKeyedColumns4')};	
		DATASET(DFUDataCols)  DFUDataKeyedColumns5 {XPATH('DFUDataKeyedColumns5')};
		DATASET(DFUDataCols)  DFUDataKeyedColumns6 {XPATH('DFUDataKeyedColumns6')};
		DATASET(DFUDataCols)  DFUDataKeyedColumns7 {XPATH('DFUDataKeyedColumns7')};	
		DATASET(DFUDataCols)  DFUDataKeyedColumns8 {XPATH('DFUDataKeyedColumns8')};	
		DATASET(DFUDataCols)  DFUDataKeyedColumns9 {XPATH('DFUDataKeyedColumns9')};	
		DATASET(DFUDataCols)  DFUDataKeyedColumns10 {XPATH('DFUDataKeyedColumns10')};		
		DATASET(DFUDataCols)  DFUDataKeyedColumns11 {XPATH('DFUDataKeyedColumns11')};
		DATASET(DFUDataCols)  DFUDataKeyedColumns12 {XPATH('DFUDataKeyedColumns12')};	
		DATASET(DFUDataCols)  DFUDataKeyedColumns13 {XPATH('DFUDataKeyedColumns13')};	
		DATASET(DFUDataCols)  DFUDataKeyedColumns14 {XPATH('DFUDataKeyedColumns14')};	
		DATASET(DFUDataCols)  DFUDataKeyedColumns15 {XPATH('DFUDataKeyedColumns15')};
		DATASET(DFUDataCols)  DFUDataKeyedColumns16 {XPATH('DFUDataKeyedColumns16')};
		DATASET(DFUDataCols)  DFUDataKeyedColumns17 {XPATH('DFUDataKeyedColumns17')};	
		DATASET(DFUDataCols)  DFUDataKeyedColumns18 {XPATH('DFUDataKeyedColumns18')};	
		DATASET(DFUDataCols)  DFUDataKeyedColumns19 {XPATH('DFUDataKeyedColumns19')};	
		DATASET(DFUDataCols)  DFUDataKeyedColumns20 {XPATH('DFUDataKeyedColumns20')};		
		
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns1{XPATH('DFUDataNonKeyedColumns1')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns2{XPATH('DFUDataNonKeyedColumns2')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns3{XPATH('DFUDataNonKeyedColumns3')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns4{XPATH('DFUDataNonKeyedColumns4')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns5{XPATH('DFUDataNonKeyedColumns5')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns6{XPATH('DFUDataNonKeyedColumns6')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns7{XPATH('DFUDataNonKeyedColumns7')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns8{XPATH('DFUDataNonKeyedColumns8')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns9{XPATH('DFUDataNonKeyedColumns9')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns10{XPATH('DFUDataNonKeyedColumns10')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns11{XPATH('DFUDataNonKeyedColumns11')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns12{XPATH('DFUDataNonKeyedColumns12')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns13{XPATH('DFUDataNonKeyedColumns13')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns14{XPATH('DFUDataNonKeyedColumns14')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns15{XPATH('DFUDataNonKeyedColumns15')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns16{XPATH('DFUDataNonKeyedColumns16')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns17{XPATH('DFUDataNonKeyedColumns17')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns18{XPATH('DFUDataNonKeyedColumns18')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns19{XPATH('DFUDataNonKeyedColumns19')};
		DATASET(DFUDataCols)  DFUDataNonKeyedColumns20{XPATH('DFUDataNonKeyedColumns20')};
END;

DFUSearchDataSoapCall   :=   SOAPCALL(URl
																			,'DFUSearchData'
																			,DFUSearchDataRequest
																			,DFUSearchDataResponse
																			,XPATH('DFUSearchDataResponse')
																			);


KeyColumnsTmp := DFUSearchDataSoapCall.DFUDataKeyedColumns1.DFUDataColumn & DFUSearchDataSoapCall.DFUDataKeyedColumns2.DFUDataColumn & 
							DFUSearchDataSoapCall.DFUDataKeyedColumns3.DFUDataColumn & DFUSearchDataSoapCall.DFUDataKeyedColumns4.DFUDataColumn & 
							DFUSearchDataSoapCall.DFUDataKeyedColumns5.DFUDataColumn & DFUSearchDataSoapCall.DFUDataKeyedColumns6.DFUDataColumn & 
							DFUSearchDataSoapCall.DFUDataKeyedColumns7.DFUDataColumn & DFUSearchDataSoapCall.DFUDataKeyedColumns8.DFUDataColumn & 
							DFUSearchDataSoapCall.DFUDataKeyedColumns9.DFUDataColumn & DFUSearchDataSoapCall.DFUDataKeyedColumns10.DFUDataColumn &
							DFUSearchDataSoapCall.DFUDataKeyedColumns11.DFUDataColumn & DFUSearchDataSoapCall.DFUDataKeyedColumns12.DFUDataColumn & 
							DFUSearchDataSoapCall.DFUDataKeyedColumns13.DFUDataColumn & DFUSearchDataSoapCall.DFUDataKeyedColumns14.DFUDataColumn & 
							DFUSearchDataSoapCall.DFUDataKeyedColumns15.DFUDataColumn & DFUSearchDataSoapCall.DFUDataKeyedColumns16.DFUDataColumn & 
							DFUSearchDataSoapCall.DFUDataKeyedColumns17.DFUDataColumn & DFUSearchDataSoapCall.DFUDataKeyedColumns18.DFUDataColumn & 
							DFUSearchDataSoapCall.DFUDataKeyedColumns19.DFUDataColumn & DFUSearchDataSoapCall.DFUDataKeyedColumns20.DFUDataColumn;

				
KeyColumns := TABLE(KeyColumnsTmp,{ColumnLabel,ColumnType,ColumnValue,ColumnSize,MaxSize,KeyCol :='Y'});
NonKeyColumnsTmp := DFUSearchDataSoapCall.DFUDataNonKeyedColumns1.DFUDataColumn & DFUSearchDataSoapCall.DFUDataNonKeyedColumns2.DFUDataColumn & 
								 DFUSearchDataSoapCall.DFUDataNonKeyedColumns3.DFUDataColumn & DFUSearchDataSoapCall.DFUDataNonKeyedColumns4.DFUDataColumn & 
								 DFUSearchDataSoapCall.DFUDataNonKeyedColumns5.DFUDataColumn & DFUSearchDataSoapCall.DFUDataNonKeyedColumns6.DFUDataColumn & 
								 DFUSearchDataSoapCall.DFUDataNonKeyedColumns7.DFUDataColumn & DFUSearchDataSoapCall.DFUDataNonKeyedColumns8.DFUDataColumn & 
								 DFUSearchDataSoapCall.DFUDataNonKeyedColumns9.DFUDataColumn & DFUSearchDataSoapCall.DFUDataNonKeyedColumns10.DFUDataColumn &
								 DFUSearchDataSoapCall.DFUDataNonKeyedColumns11.DFUDataColumn & DFUSearchDataSoapCall.DFUDataNonKeyedColumns12.DFUDataColumn & 
								 DFUSearchDataSoapCall.DFUDataNonKeyedColumns13.DFUDataColumn & DFUSearchDataSoapCall.DFUDataNonKeyedColumns14.DFUDataColumn & 
								 DFUSearchDataSoapCall.DFUDataNonKeyedColumns15.DFUDataColumn & DFUSearchDataSoapCall.DFUDataNonKeyedColumns16.DFUDataColumn & 
								 DFUSearchDataSoapCall.DFUDataNonKeyedColumns17.DFUDataColumn & DFUSearchDataSoapCall.DFUDataNonKeyedColumns18.DFUDataColumn & 
								 DFUSearchDataSoapCall.DFUDataNonKeyedColumns19.DFUDataColumn & DFUSearchDataSoapCall.DFUDataNonKeyedColumns20.DFUDataColumn ;

NonKeyColumns := TABLE(NonKeyColumnsTmp,{ColumnLabel,ColumnType,ColumnValue,ColumnSize,MaxSize,KeyCol :='N'});
Result 				:= IF(include_fpos = 'N', KeyColumns & NonKeyColumns (ColumnLabel <> '_fpos' AND ColumnLabel <> '__fileposition__'  AND ColumnLabel <> '__internal_fpos__'),
									KeyColumns & NonKeyColumns );
RETURN Result;

END;

EXPORT fn_GetFileLayout(STRING FileName , STRING IP='',STRING port='8010',STRING  Cluster = '') := FUNCTION
/*
To get the file layout as string
Usage : fn_DFUInfo_SOAP('~thor::filename');
*/
STRING URl 		:= 'http://' + IF(IP = '',fn_getIP(),IP )+ ':' + port +'/WsDfu/?ver_=1.22';
STRING fName 	:= IF(Cluster<>'',Cluster+'::'+FileName,FileName);

DFUInfoRequest := RECORD, MAXLENGTH(100)
			STRING OpenLogicalName{XPATH('Name')} := fName;
END;

ESPExceptions_Lay := RECORD
		STRING Code			{XPATH('Code'),MAXLENGTH(10)};
		STRING Audience	{XPATH('Audience'),MAXLENGTH(50)};
		STRING Source		{XPATH('Source'),MAXLENGTH(30)};
		STRING Message	{XPATH('Message'),MAXLENGTH(200)};
		END;
		
DFUFileDetail :=  RECORD ,  MAXLENGTH(300)	

			STRING  	Name{XPATH('Name'),MAXLENGTH(70)};
			STRING 		Filename{XPATH('Filename'),MAXLENGTH(20)};
			STRING 		Owner{XPATH('Owner'),MAXLENGTH(20)};
			STRING 		Filesize {XPATH('Filesize'),MAXLENGTH(20)};
			STRING 		RecordSize {XPATH('RecordSize'),MAXLENGTH(20)};
			STRING 		RecordCount{XPATH('RecordCount'),MAXLENGTH(20)};
			STRING		Wuid{XPATH('Wuid'),MAXLENGTH(20)};
			STRING 		Cluster{XPATH('Cluster'),MAXLENGTH(20)};
			STRING 		JobName{XPATH('JobName'),MAXLENGTH(20)};
			STRING		ECL{XPATH('Ecl'),MAXLENGTH(20)};
		 
END;
		

DFUInfoResponse      := RECORD
	
		DATASET(ESPExceptions_Lay)    Exceptions{XPATH('Exceptions/ESPException'),maxcount(110)};
		DATASET(DFUFileDetail)  FileDetail{XPATH('FileDetail'),maxcount(20)};
	
END;
DATASET DFUInfoSoapCall   :=   SOAPCALL(URl
				,'DFUInfo'
				,DFUInfoRequest
				,DFUInfoResponse
				,XPATH('DFUInfoResponse')
				);
	
	
RETURN DFUInfoSoapCall.FileDetail[1].ecl;

END;

END;