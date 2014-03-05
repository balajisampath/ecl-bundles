DFU_SOAP
===========

This bundle is built with the aim of abstracting SOAP calls into simple function calls 

The following are the functions that are provided

1. fn_GetCoulmnInfo - Retrieves the column information of given  logical name  (index/data file) as dataset with Key and NonKey columns indicator
E.g. Usage 	: fn_GetCoulmnInfo('~thor::filename','10.XXX.XXX.1','8010');

2. fn_GetFileLayout(Dataset, FileName) - Retrieves the column information of given  logical name (index/data file) in string format

E.g. Usage : fn_GetFileLayout('~thor::filename','10.XXX.XXX.1','8010');

*** By default the function use ESP IP of the connected server. Please pass IP and cluster info for getting info from remote servers
 
