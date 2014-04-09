IMPORT STD;
EXPORT Profiler := MODULE
/*
Profiling the input dataset
*/
  EXPORT Bundle := MODULE(Std.BundleBase)
    EXPORT Name       	:= 'Profiler';
    EXPORT Description  := 'Profiling the input dataset';
    EXPORT Authors      := ['balajisampath'];
    EXPORT License      := 'http://www.apache.org/licenses/LICENSE-2.0';
    EXPORT Copyright    := 'Use, Improve, Extend, Distribute';
    EXPORT DependsOn    := [];
    EXPORT Version      := '1.0.1';
  END; 


EXPORT GetColStatistics(ds) := MACRO
 LOADXML('<xml/>');
 #DECLARE(DynamicECLCode) #SET(DynamicECLCode,#TEXT(ds)+'REC := RECORD STRING columnname;STRING columntype; STRING minval; STRING maxval;STRING minlen; STRING maxlen;STRING uniquecnt; STRING emptycnt;STRING emptypct; STRING MFOV;STRING  MFOVCnt; END;')
 #DECLARE(ColResult) #SET(ColResult,'')
 #DECLARE(rid)
 #EXPORTXML(fields,RECORDOF(ds));  
 #FOR(fields)
  #FOR(Field)
		#UNIQUENAME(columnname)
		#UNIQUENAME(columntype)
		
		#IF(%'{@type}'%[1..4] = 'data' OR %'{@type}'%[1..3] = 'set' OR %'{@type}'%[1..4] = 'enum' OR %'{@type}'%[1..4] = 'type')
				FAIL('Datatype : \''+ %'{@type}'% + '\' Not supported by this program. Please exclude the column \''+ %'{@label}'%+'\' and try again '); 
		#END;
		
		#IF(%'{@type}'%[1..4] = 'inte' OR %'{@type}'%[1..4] = 'real' OR %'{@type}'%[1..4] = 'deci' OR %'{@type}'%[1..4] = 'unsi' ) 
					#APPEND(DynamicECLCode, #TEXT(ds)+%'columnname'% + ' := \''+  %'{@label}'%+ '\'; '+ 
																	#TEXT(ds)+%'columntype'% + ' := \''+ %'{@type}'% + '\';'+
																	#TEXT(ds)+%'{@label}'%+'min := (STRING) MIN('+ #TEXT(ds)+','+ %'{@label}'%+');'+
																	#TEXT(ds)+%'{@label}'%+'max := (STRING) MAX('+ #TEXT(ds)+','+ %'{@label}'%+');'+
																	#TEXT(ds)+%'{@label}'%+'minlen := (STRING) 0;'+ 
																	#TEXT(ds)+%'{@label}'%+'maxlen := (STRING) 0;'+
																	#TEXT(ds)+%'{@label}'%+'uniquecnt := (STRING) COUNT(DEDUP(SORT('+ #TEXT(ds)+','+%'{@label}'%+'),'+ %'{@label}'%+'));'+
																	#TEXT(ds)+%'{@label}'%+'emptycnt := (STRING) COUNT('+ #TEXT(ds)+'('+%'{@label}'%+' = 0)); '+
																	#TEXT(ds)+%'{@label}'%+'emptypct := COUNT('+ #TEXT(ds)+'('+%'{@label}'%+' = 0))/COUNT('+ #TEXT(ds)+') * 100; '+
																	#TEXT(ds)+%'{@label}'%+'MFOV := SORT(TABLE('+ #TEXT(ds)+',{' +%'{@label}'%+ '; Cnt := COUNT(GROUP); },' +%'{@label}'%+ '),Cnt)[1].'+%'{@label}'%+ ';'+
																	#TEXT(ds)+%'{@label}'%+'MFOVCnt := SORT(TABLE('+ #TEXT(ds)+',{' +%'{@label}'%+ '; Cnt := COUNT(GROUP); },' +%'{@label}'%+ '),-Cnt)[1].Cnt;' +
																	#TEXT(ds)+%'columnname'% +'_resultDS := DATASET( [ {'+ #TEXT(ds)+%'columnname'%+';'+ #TEXT(ds)+%'columntype'%+';'+#TEXT(ds)+%'{@label}'% +'min;'+#TEXT(ds)+%'{@label}'%+'max;'+#TEXT(ds)+%'{@label}'% +'minlen;'+#TEXT(ds)+%'{@label}'%+'maxlen;'+#TEXT(ds)+%'{@label}'%+'uniquecnt;'+#TEXT(ds)+%'{@label}'%+'emptycnt;'+#TEXT(ds)+%'{@label}'%+'emptypct;'+#TEXT(ds)+%'{@label}'%+'MFOV;'+#TEXT(ds)+%'{@label}'%+'MFOVCnt;'+' }] , '+ #TEXT(ds)+'REC);');
					#APPEND(ColResult,  #TEXT(ds)+%'columnname'% + '_resultDS +' );

		#ELSE
			#APPEND(DynamicECLCode, #TEXT(ds)+%'columnname'% +' := \''+%'{@label}'%+'\'; '+
															#TEXT(ds)+%'columntype'%+' := \''+ %'{@type}'%+'\';'+
															#TEXT(ds)+%'{@label}'%+'min :=  MIN('+ #TEXT(ds)+','+%'{@label}'%+');'+
															#TEXT(ds)+%'{@label}'%+'max :=  MAX('+ #TEXT(ds)+','+%'{@label}'%+');'+
															#TEXT(ds)+%'{@label}'%+'minlen := MIN('+ #TEXT(ds)+',LENGTH(TRIM('+%'{@label}'%+')));'+
															#TEXT(ds)+%'{@label}'%+'maxlen := MAX('+ #TEXT(ds)+',LENGTH(TRIM('+%'{@label}'%+')));'+
															#TEXT(ds)+%'{@label}'%+'uniquecnt := COUNT(DEDUP(SORT('+ #TEXT(ds)+','+%'{@label}'%+'),'+ %'{@label}'%+'));'+
															#TEXT(ds)+%'{@label}'%+'emptycnt := COUNT('+ #TEXT(ds)+'('+%'{@label}'%+' = \'\' )); '+
															#TEXT(ds)+%'{@label}'%+'emptypct := COUNT('+ #TEXT(ds)+'('+%'{@label}'%+' = \'\'))/COUNT('+ #TEXT(ds)+') * 100; '+
															#TEXT(ds)+%'{@label}'%+'MFOV := SORT(TABLE('+ #TEXT(ds)+',{' +%'{@label}'%+ '; Cnt := COUNT(GROUP); },' +%'{@label}'%+ '),Cnt)[1].'+%'{@label}'%+ ';'+
															#TEXT(ds)+%'{@label}'%+'MFOVCnt := SORT(TABLE('+ #TEXT(ds)+',{' +%'{@label}'%+ '; Cnt := COUNT(GROUP); },' +%'{@label}'%+ '),-Cnt)[1].Cnt;      	' +
															#TEXT(ds)+%'columnname'% +'_resultDS := DATASET( [ {'+ #TEXT(ds)+%'columnname'%+';'+ #TEXT(ds)+%'columntype'%+';'+#TEXT(ds)+%'{@label}'% +'min;'+#TEXT(ds)+%'{@label}'%+'max;'+#TEXT(ds)+%'{@label}'% +'minlen;'+#TEXT(ds)+%'{@label}'%+'maxlen;'+#TEXT(ds)+%'{@label}'%+'uniquecnt;'+#TEXT(ds)+%'{@label}'%+'emptycnt;'+#TEXT(ds)+%'{@label}'%+'emptypct;'+#TEXT(ds)+%'{@label}'%+'MFOV;'+#TEXT(ds)+%'{@label}'%+'MFOVCnt;'+' }] , '+ #TEXT(ds)+'REC);');
									#APPEND(ColResult,  #TEXT(ds)+%'columnname'% + '_resultDS +' );
		#END	
  #END
 #END;
 
 #APPEND(DynamicECLCode,%'ColResult'%[1..LENGTH(%'ColResult'%)-1]);

  %DynamicECLCode%;
ENDMACRO; 

END;

