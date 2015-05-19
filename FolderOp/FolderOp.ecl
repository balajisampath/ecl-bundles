EXPORT FolderOp := MODULE

IMPORT STD;
/*
Simulating OS Folder like Manipulations
*/
  EXPORT Bundle := MODULE(Std.BundleBase)
    EXPORT Name       	:= 'FolderOp';
    EXPORT Description  := 'Folder Manipulations';
    EXPORT Authors      := ['balajisampath'];
    EXPORT License      := 'http://www.apache.org/licenses/LICENSE-2.0';
    EXPORT Copyright    := 'Use, Improve, Extend, Distribute';
    EXPORT DependsOn    := [];
    EXPORT Version      := '1.0.1';
  END; 


EXPORT fn_rmdir(String dirnamewithpath) := FUNCTION

/*
This Function Removes all the files, super files, sub files of the specified path
*/

FsLogicalFileNameRecord := RECORD
	STRING name;
END;

FsLogicalFileInfoRecord := RECORD(FsLogicalFileNameRecord)
	BOOLEAN superfile;
	UNSIGNED8 size;
	UNSIGNED8 rowcount;
	STRING19 modified;
	STRING owner;
	STRING cluster;
END;

Dir := dirnamewithpath;//IF (dirnamewithpath[1..1] <> '~' , '~'+ dirnamewithpath,dirnamewithpath);

SFDS := STD.File.LogicalFileList(Dir + '*',FALSE,TRUE);
NFDS := STD.File.LogicalFileList()(REGEXFIND(Dir,name));

Cnt := COUNT(SFDS) + COUNT(NFDS) : INDEPENDENT;

SEQUENTIAL(OUTPUT('Count of files deleted := ' + (STRING) Cnt),
	STD.File.StartSuperFileTransaction(),
	NOTHOR(APPLY (SFDS(rowcount >0),STD.File.ClearSuperFile('~' + name))),
	STD.File.FinishSuperFileTransaction(),
	NOTHOR(APPLY (SFDS,STD.File.DeleteLogicalFile('~' +name))),
	NOTHOR(APPLY (NFDS,STD.File.DeleteLogicalFile('~' +name)))
);

#WORKUNIT('name','Removing files from' + dirnamewithpath);

RETURN 1;

END;
  
END;