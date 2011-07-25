MODULE_NAME='AMX_Mobile_Comm'(DEV vdvWeb,DEV dvWeb,INTEGER nWebPort,CHAR cWebURL_IP[],INTEGER nWebDeBug)
// Created by: Brian Cirrisi             
// Last Modified: 03/25/2009
// Version: 1.0
// This code is provided to the AMX Forum community and is not to be sold commercially.

(*(VAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAV)*) 
(*(VAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAV)*)
(*(             MODIFIED BY VAV JULY 23, 2009               )*)
(*(             Danile R. Vining                            )*)
(*(             30 Spring Street                            )*)
(*(             Danbury, CT 06810                           )*)
(*(VAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAV)*)
(*(VAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAV)*)
(*(  As far as I'm concerned you can use it in jobs but     )*)
(*(  don't charge for it.  If you do charge for it then     )*)
(*(  do something nice for someone else in return.          )*)
(*(VAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAV)*)  
(*(VAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAV)*)
(*(           TAB STOPS BEFORE 8 BEFORE CHARACTERS          )*)
(*(           INDENT 5 BEFORE CHARACTERS                    )*)
(*(VAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAV)*)    
(*(VAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAV)*)
(*(           TO DEBUG DO A FIND AND REPLACE                )*)
(*(    FIND: //fnWebDeBug  REPLACE W/  fnWebDeBug           )*)
(*(    since there's alot I don't like it running if        )*)
(*(    I'm not debugging.  re-compile and then re-send!!!!  )*)
(*(VAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAV)*) 
(*(VAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAVAV)*) 

DEFINE_CONSTANT //GENERAL VARS

CRLF[2] = {$0D,$0A}

DELETE_STORED_IP_20	= 200 ; //TIME TO WAIT BEFORE DELETING THE STORED IP AND REQUIRING USER TO LOGIN AGAIN.
DELETE_STORED_IP_40	= 400 ;	//THIS TIME REFRESHES WHEN USED. 
DELETE_STORED_IP_60	= 600 ;
DELETE_STORED_IP_120    = 1200 ;

WINGENERIC		= 100 ;
BLACKBERRY		= 101 ;
iPHONE			= 102 ;
iPOD			= 103 ;
WINSAFARI		= 104 ;

PAGE_CLOSE_SERVER	= 0 ;
PAGE_LOGIN		= 1 ;
PAGE_RETRY		= 2 ;
PAGE_BUTTONS		= 3 ;
PAGE_SEND_FILES		= 4 ;
PAGE_204_NOCONTENT	= 5 ;
PAGE_404_FILENOFIND	= 6 ;
PAGE_304_NOTMODIFIED	= 7 ;
PAGE_SETCOOKIE          = 8 ;
PAGE_202_ACCEPTED       = 9 ;
PAGE_QUERY_RESPONSE	= 10 ;

BUTTON_NO_SHOW		= 0 ;
BUTTON_SHOW		= 1 ;
BUTTON_MENU		= 2 ;

SERVER_STOPPED		= 0 ;
SERVER_READY		= 1 ;
SERVER_CLIENT_CONNECTED	= 2 ;
SERVER_RX_DATA		= 3 ;
SERVER_DISABLED		= 4 ;

MAX_MTU			= 1500 ;
MAX_NUM_BTNs_ROW	= 3 ;
MAX_NUM_ROWs		= 8 ;
MAX_NUM_PAGEs		= 10 ;
MAX_NUM_BTNs_PAGE	= 24 ;
MAX_NUM_BUTTONs		= MAX_NUM_PAGEs * MAX_NUM_BTNs_PAGE ;
MAX_NAME_LENGTH		= 15 ;
MAX_LEN_STR_MSG		= 20000 ;

WEB_PAGE_FB_REFRESH     = 20 ; //delay in sending web page out to provide time feedback changes to occur ;

DEFINE_CONSTANT //GENERAL VARS * FILES * REFRESH * DATE TIMES * COOKIE

//CHAR BUTTON_IMG_ARRY [3][20] = {'button_off.jpg','button_on.jpg','button_on.jpg'}

NUM_FILES_TO_Q		= 30 ;
MAXLEN_FILE_NAMES	= 30 ;
EXPIRES_IN_SECONDS      = 10 ; 	  //10 seconds
//CSS_INCLUDE_REFRESH     = 1 ;
CSS_EXCLUDE_REFRESH     = 0 ;

MAX_READ_FILE_LENGTH    = 40000 ;  	// Max buffer size for reading files.

CHAR AMX_MOBILE_COOKIE[]= 'amx00mobile00' ;

MIN_REFRESH_TIME	= 5000 ;  	//in milli-seconds minimum number of second before the web page issues another get command for refresh.
MAX_REFRESH_TIME	= 60000 ;  	//in milli-seconds maximum nuber of seconds for web page refersh

NUM_SECONDS_DAY		    = 86400 ;
CHAR WEB_MONTH[12][3] 	    = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'} ; 
LONG DAYS_MONTHs[12]        = {31   ,28   ,31   ,30   ,31   ,30   ,31   ,31   ,30   ,31   ,30   ,31} ;
LONG DAYS_LEAPMONTHs[12]    = {31   ,29   ,31   ,30   ,31   ,30   ,31   ,31   ,30   ,31   ,30   ,31} ;
CHAR WEB_DAYS[7][3]	    = {'SUN','MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'} ;

DEFINE_TYPE     //STRUCTURE

STRUCTURE _sBUTTON

     {
     CHAR Name[MAX_NAME_LENGTH] ;
     INTEGER Value ;              //TYPE_CAST ALL FLOATS TO INTERGER. DON'T CARE ABOUT VALUES BEYOND THE DECIMAL POINT
     INTEGER Show ;               //USED TO DETERMINE IF A BUTTON SHOULD SHOW OR NOT EITHER 1 OR 0 SHOW OR NO SHOW
     }

STRUCTURE _sWEB_PAGE

     {//[MAX_NUM_BTNs_PAGE]
     CHAR Pg_NAME[MAX_NAME_LENGTH] ;
     _sBUTTON BTN[MAX_NUM_BTNs_PAGE] ;
     }

DEFINE_VARIABLE //STRUCTURE VARIABLES

VOLATILE _sWEB_PAGE sWEB_PAGE[MAX_NUM_PAGEs] ;
     
DEFINE_VARIABLE //GENERAL VARS

//VOLATILE LONG     	nTestSecondsAdded ;
//VOLATILE INTEGER      nTestTime ;

VOLATILE CHAR		cWebURLPathReFresh[75] ; 
VOLATILE CHAR		cWebURLPathHome[75] ; 

VOLATILE INTEGER	nAutoRefresh ;
VOLATILE INTEGER	nAutoRefreshTime ;
VOLATILE CHAR	 	cRXCookie[48] ;
VOLATILE CHAR		nRXNewValue = 0 ;
VOLATILE INTEGER 	nCurWebPage = 1 ;
VOLATILE INTEGER	nBlockQueryResponse = 0 ;
VOLATILE CHAR		cData1[20] ;
VOLATILE CHAR		cData2[20] ;

VOLATILE INTEGER 	nTestBuff_Clear = 0 ;
VOLATILE CHAR 		cWeb_TestRXBuff[20000] ;
VOLATILE CHAR 		cWeb_TestTXBuff[20000] ;

VOLATILE CHAR 		cWeb_RXBuffer[20000] ;		// The buffer for all incoming messages from the Mobile Web
VOLATILE CHAR 		cLogin_IPAddress[20] ;		// Holds the IP address of the device communicating with the NI
VOLATILE CHAR 		cPassword[20] ;			// Holds the Password for the Site
VOLATILE CHAR 		cTitle[20] ;			// Holds the Title for the Site
VOLATILE SINTEGER	nContentLength ;		// Tracks how long the Content coming in is
VOLATILE INTEGER	nWebAgent ;			// What web user is the client using.
VOLATILE INTEGER        nWebServerState ;
VOLATILE INTEGER 	nConnectAttempts = 0 ;
VOLATILE INTEGER        nBtnCurLevel = 0 ;
VOLATILE INTEGER 	nWaitingToSend = 0 ;
NON_VOLATILE INTEGER 	nNumConfigBtns = 0 ;

VOLATILE INTEGER 	nFileInsertIndx = 1 ;
VOLATILE INTEGER 	nFileReadIndx = 1 ;

//VOLATILE SLONG 	nReadFResult ;
//VOLATILE INTEGER 	nReading = 0 ;
//VOLATILE CHAR 	cReadFileExt[3] = 'jpg' ;
//VOLATILE CHAR 	cReadFileBuf[MAX_READ_FILE_LENGTH] ;

VOLATILE CHAR 		cWebCurDateTime[29] ;
VOLATILE CHAR 		cWebExpDateTime[29] ;

DEFINE_VARIABLE //GET FILE QUEUE ARRAY

VOLATILE CHAR cFile_Q_Arry[NUM_FILES_TO_Q][MAXLEN_FILE_NAMES] ;

DEFINE_FUNCTION LONG fn24HourTimeTo_Seconds(CHAR iTime[])

     {
     RETURN ((((ATOI(REMOVE_STRING(iTime,"':'",1)) * 60) * 60) + ATOI(REMOVE_STRING(iTime,"':'",1)) * 60) + ATOI(iTime)) ;
     }
     
DEFINE_FUNCTION CHAR[8] fnSecondsTo_24HourTime(LONG iTimeInSeconds)

     {
     RETURN   "right_string("'0',ITOA(iTimeInSeconds / 3600)",2),':',
		    right_string("'0',ITOA((iTimeInSeconds % 3600) / 60)",2),':',
			 right_string("'0',ITOA((iTimeInSeconds % 3600) % 60)",2)" ;
     }
     
DEFINE_FUNCTION fnUpdateDATE_TIME()

     {
     cWebCurDateTime = "fnDo24hrTimeAddition(LDate,TIME,0),' EST'" ;
     cWebExpDateTime = "fnDo24hrTimeAddition(LDate,TIME,EXPIRES_IN_SECONDS),' EST'" ;
    
     RETURN ;
     }
 
DEFINE_FUNCTION CHAR[30] fnDo24hrTimeAddition(CHAR iLDate[],CHAR i24HourTime[],LONG iSecondsAdded)     
     
     {
     STACK_VAR INTEGER nYear ;       //change to all stack_var's
     STACK_VAR INTEGER nMonth ;
     STACK_VAR INTEGER nLeap ;
     STACK_VAR CHAR c24HrTime[8] ;
     STACK_VAR CHAR cNewDate[10] ;
     STACK_VAR LONG nDay ;
     STACK_VAR LONG nDaysOver ;
     STACK_VAR LONG nSecondsRemain ;
     STACK_VAR LONG nTotalTimeSeconds ;
     
     nTotalTimeSeconds = fn24HourTimeTo_Seconds(i24HourTime) + iSecondsAdded ;
     nMonth = atoi("REMOVE_STRING(iLDATE,"'/'",1)") ;
     nDay   = atoi("REMOVE_STRING(iLDATE,"'/'",1)") ;
     nYear  = atoi("iLDATE") ;
     
     if(nTotalTimeSeconds > NUM_SECONDS_DAY)
	  {
	  STACK_VAR INTEGER i ;
	  
	  nDaysOver = nTotalTimeSeconds / NUM_SECONDS_DAY ;
	  nSecondsRemain = nTotalTimeSeconds % NUM_SECONDS_DAY ;
	  if(!(nYear % 4))//http://en.wikipedia.org/wiki/Leap_year
	       {
	       nLeap = 1 ;
	       if(!(nYear % 100))//double check these rules?????? 
		    {
		    if(nYear % 400)
			 {
			 nLeap = 0 ;
			 }
		    }
	       }
	  if(nLeap)
	       {
	       if((nDaysOver + nDay) > DAYS_LEAPMONTHs[nMonth])
		    {
		    nDaysOver = nDaysOver - (DAYS_LEAPMONTHs[nMonth] - nDay) ;
		    nMonth++ ;
		    
		    for(nMonth = nMonth ; nDaysOver > DAYS_LEAPMONTHs[nMonth] ; nMonth++)
			 {
			 nDaysOver = (nDaysOver - DAYS_LEAPMONTHs[nMonth]) ;
			 if(nMonth == 12)
			      {
			      nMonth = 1 ;
			      nYear ++ ;
			      }
			 }
		    nDay = nDaysOver ;
		    }
	       else
		    {
		    nDay = nDaysOver + nDay ;
		    }
	       }
	  else
	       {
	       if((nDaysOver + nDay) > DAYS_MONTHs[nMonth])
		    {
		    nDaysOver = nDaysOver - (DAYS_MONTHs[nMonth] - nDay) ;
		    nMonth++ ;
		    
		   for(nMonth = nMonth ; nDaysOver > DAYS_MONTHs[nMonth] ; nMonth++)
			 {
			 nDaysOver = (nDaysOver - DAYS_MONTHs[nMonth]) ;
			 if(nMonth == 12)
			      {
			      nMonth = 1 ;
			      nYear ++ ;
			      }
			 }
		    nDay = nDaysOver ;
		    }
	       else
		    {
		    nDay = nDaysOver + nDay ;
		    }
	       }
	  c24HrTime = fnSecondsTo_24HourTime(nSecondsRemain) ; 
	  }
     else
	  {
	  c24HrTime = fnSecondsTo_24HourTime(nTotalTimeSeconds) ;
	  }
     cNewDate = "right_string("'0',ITOA(nMonth)",2),'/',right_string("'0',ITOA(nDay)",2),'/',right_string("'0',ITOA(nYear)",2)" ;
	   
     RETURN "WEB_DAYS[TYPE_CAST(DAY_OF_WEEK(cNewDate))],', ',itoa(nDay),' ',WEB_MONTH[nMonth],' ',itoa(nYear),' ',c24HrTime" ;
     }
    
DEFINE_FUNCTION fnWebDeBug(CHAR iStr[],INTEGER iPrefix)

     {
     if(nWebDebug)
	  {
	  if(iPrefix)
	       {
	       SEND_STRING 0,"'MOBILE WEB:  ',iStr,CRLF" ;
	       }
	  else
	       {
	       SEND_STRING 0,"iStr,CRLF" ;
	       }
	  }
	  
     RETURN ;
     }

DEFINE_FUNCTION fnOpenWebServer() 

     {
     STACK_VAR SLONG nErrFlag ; 
     
     if(nWebServerState == SERVER_STOPPED)
	  {
	  nWebServerState = SERVER_DISABLED ;
	  //fnWebDeBug("'Opening Server.   >-line-<',ITOA(__LINE__),'>'",1) ;
	  nErrFlag = IP_SERVER_OPEN (dvWeb.Port, nWebPort, 1) ;
	       {
	       if(nErrFlag)
		    {
		    //fnWebDeBug("'Server ERR: ',fnGET_IPServer_Error(nErrFlag),'.   >-line-<',ITOA(__LINE__),'>'",1) ;
		    WAIT 300 'ERROR_DELAY_RESTART' 
			 {
			 //fnWebDeBug("'Server Start ERR: Delayed Restart.   >-line-<',ITOA(__LINE__),'>'",1) ;
			 nWebServerState = SERVER_STOPPED ;
			 }
		    }
	       else //if no error this means the online event didn't trigger setting the connection state.
		    {
		    CANCEL_WAIT 'WEB_CONNECT_TIMEOUT' ;
		    CANCEL_WAIT 'ERROR_DELAY_RESTART' ;
		    nWebServerState = SERVER_READY ; //  WAIT FOR ONLINE EVENT ?
		    }
	       }
	  }
     
     RETURN ;
     }
     
DEFINE_FUNCTION fnCloseWebServer()

     {
     STACK_VAR SLONG nErrFlag ; 
     
     if(nWebServerState != SERVER_STOPPED && !nWaitingToSend)
	  {
	  nErrFlag = IP_SERVER_CLOSE(dvWeb.PORT) ;
	  if(nErrFlag == 0)
	       {
	       nWebServerState = SERVER_STOPPED ;
	       //fnWebDeBug("'Server Successfuly Closed.   >-line-<',ITOA(__LINE__),'>'",1);
	       }
	  else if(nErrFlag == 9)
	       {
	       //fnWebDeBug("'Server Already Closed.   >-line-<',ITOA(__LINE__),'>'",1);
	       WAIT 300 'ERROR_DELAY_RESTART' 
		    {
		    //fnWebDeBug("'Server Stop ERR: Delayed Restart.   >-line-<',ITOA(__LINE__),'>'",1) ;
		    nWebServerState = SERVER_STOPPED ;
		    }
	       }
	  else
	       {
	       //fnWebDeBug("'Server Shut Down Error. Returned Error: "',itoa(nErrFlag),'".   >-line-<',ITOA(__LINE__),'>'",1);
	       WAIT 300 'ERROR_DELAY_RESTART' 
		    {
		    //fnWebDeBug("'Server Stop ERR: Delayed Restart.   >-line-<',ITOA(__LINE__),'>'",1) ;
		    nWebServerState = SERVER_STOPPED ;
		    }
	       }
	  }
     
     RETURN ;
     }
     
DEFINE_FUNCTION CHAR[2] fn2DHEX(INTEGER iInteger) //keep in case you ever need to change shadow colors

     {
     LOCAL_VAR CHAR cHexTemp[4] ;
     LOCAL_VAR INTEGER nScaledInt ;
     
     cHexTemp = '00' ;
     nScaledInt = TYPE_CAST(iInteger * 2.55) ;
     cHexTemp = right_string("cHexTemp,ITOHEX(nScaledInt)",2) ;
     ////fnWebDeBug("'fn2DHEX value in int = ',itoa(nScaledInt),', Hex of (int x 2.55) = ',cHexTemp,'.   >-line-<',ITOA(__LINE__),'>'",1) ;
     
     RETURN cHexTemp ;
     }
     
DEFINE_FUNCTION CHAR[100] fnGET_IPServer_Error(SLONG iError)
     
     {
     STACK_VAR CHAR cErrMsg[100] ;
     
     SELECT
	  {
	  ACTIVE(iError == 0):  // this won't happen here
	       {
	       cErrMsg = "'Web Server: operation was successful'" ;
	       nWebServerState = SERVER_READY ;
	       nConnectAttempts = 0 ;
	       }
	  ACTIVE(iError ==  -1): // invalid server port
	       {
	       cErrMsg = "'Web Server: invalid server port'" ;
	       nWebServerState = SERVER_DISABLED ;
	       }
	  ACTIVE(iError ==  -2): // invalid value for Protocol
	       {
	       cErrMsg = "'Web Server: invalid protocol'" ;
	       nWebServerState = SERVER_DISABLED ;
	       }
	  ACTIVE(iError ==  -3): // unable to open communication port with server
	       {
	       cErrMsg = "'Web Server: unable to open port'" ;
	       nWebServerState = SERVER_DISABLED ;
	       }
	  /////////////////////////////////////////////////////////////////////////
	  ACTIVE(iError ==  1): // invalid server address
	       {
	       cErrMsg = "'Web Server: invalid server address'" ;
	       nWebServerState = SERVER_DISABLED ;
	       }
	  ACTIVE(iError ==  2): // invalid server port
	       {
	       cErrMsg = "'Web Server: invalid server port'" ;
	       nWebServerState = SERVER_DISABLED ;
	       }
	  ACTIVE(iError ==  3): // invalid value for Protocol
	       {
	       cErrMsg = "'Web Server: invalid protocol'" ;
	       nWebServerState = SERVER_DISABLED ;
	       }
	  ACTIVE(iError ==  4): // unable to open communication port with server
	       {
	       cErrMsg = "'Web Server: unable to open port'" ;
	       nWebServerState = SERVER_DISABLED ;
	       }
	  ACTIVE(iError ==  6): // Connection refused
	       {
	       cErrMsg = "'Web Server: connection refused'" ;  
	       nWebServerState = SERVER_DISABLED ;
	       }
	  ACTIVE(iError ==  7): // Connection timed out
	       {
	       cErrMsg = "'Web Server: connection timed out'" ;
	       nWebServerState = SERVER_DISABLED ;
	       WAIT 300 'ERROR_DELAY_RESTART' 
		    {
		    nWebServerState = SERVER_STOPPED ;
		    }
	       }
	  ACTIVE(iError ==  8) : // WINGENERIC connection error
	       {
	       cErrMsg = "'Web Server: unknown connection error'" ;
	       nWebServerState = SERVER_DISABLED ;
	       }
	  ACTIVE(iError ==  9): // Already closed
	       {
	       cErrMsg = "'Web Server: connection already closed'" ;
	       nWebServerState = SERVER_DISABLED ;
	       WAIT 300 'ERROR_DELAY_RESTART' 
		    {
		    nWebServerState = SERVER_STOPPED ;
		    }
	       }
	  ACTIVE(iError == 10): // Binding error
	       {
	       cErrMsg = "'Web Server: binding error'" ;
	       nWebServerState = SERVER_DISABLED ;
	       WAIT 300 'ERROR_DELAY_RESTART' 
		    {
		    nWebServerState = SERVER_STOPPED ;
		    }
	       }
	  ACTIVE(iError == 11): // Listening error
	       {
	       cErrMsg = "'Web Server: invalid server address'" ;
	       nWebServerState = SERVER_DISABLED ;
	       }
	  ACTIVE(iError == 14): // Local port already used
	       {
	       cErrMsg = "'Web Server: port in use'" ;
	       nWebServerState = SERVER_DISABLED ;
	       WAIT 300 'ERROR_DELAY_RESTART' 
		    {
		    nWebServerState = SERVER_STOPPED ;
		    }
	       fnCloseWebServer() ;
	       }
	  ACTIVE(iError == 15): // UDP socket already listening
	       {
	       cErrMsg = "'Web Server: UDP socket already listening'" ;
	       nWebServerState = SERVER_DISABLED ;
	       }
	  ACTIVE(iError == 16): // Too many open sockets 
	       {
	       cErrMsg = "'Web Server: Too many open sockets'" ;
	       nWebServerState = SERVER_DISABLED ;
	       WAIT 300 'ERROR_DELAY_RESTART' 
		    {
		    nWebServerState = SERVER_STOPPED ;
		    }
	       }
	  ACTIVE(iError == 17): //Local port not open'
	       {
	       cErrMsg = "'Local port not open'" ;
	       nWebServerState = SERVER_DISABLED ;
	       WAIT 300 'ERROR_DELAY_RESTART' 
		    {
		    nWebServerState = SERVER_STOPPED ;
		    }
	       }
	  ACTIVE(1): //
	       {
	       cErrMsg = "'ONERROR NO MATCH.  ERROR# ',itoa(iError)" ;
	       nWebServerState = SERVER_DISABLED ;
	       WAIT 300 'ERROR_DELAY_RESTART' 
		    {
		    nWebServerState = SERVER_STOPPED ;
		    }
	       }
	  }
     
     RETURN cErrMsg ;
     }

DEFINE_FUNCTION SLONG fnFileRead(CHAR icReadFile[],INTEGER inReadFStrLen) //body commented out
     
     {(*
     stack_var slong nReadFHandle ;
          
     nReadFHandle = file_open(icReadFile,FILE_READ_ONLY) ;
     if(nReadFHandle > 0) 
	  {
	  //fnWebDeBug("'WebDeBug fnOpenFile. File_Open successful for *',
					     icReadFile,'*! line-<',ITOA(__LINE__),'>'",1) ;
	  nReadFResult = file_read(nReadFHandle,cReadFileBuf,inReadFStrLen) ;
	  if(nReadFResult > 0) 
	       {
	       //fnWebDeBug("'WebDeBug  fnReadFile. File_Read OK. Rcvd: a ',
					itoa(nReadFResult),' CHAR String!  line-<',ITOA(__LINE__),'>'",1) ; 
	       }
	  else
	       {
	       stack_var char cErrorMsg [20] ;
	       switch (itoa(nReadFResult)) 
		    {
		    case '-9': {cErrorMsg = 'end-of-file reached'} ;
		    case '-6': {cErrorMsg = 'invalid parameter'} ;
		    case '-5': {cErrorMsg = 'disk I/O error'} ;
		    case '-1': {cErrorMsg = 'invalid file handle'} ;
		    case '-0': {cErrorMsg = 'zero bits returned?'} ;
		    }
	       //fnWebDeBug("'WebDeBug fnReadFile. Bad Read_File: ',cErrorMsg,
						  '! line-<',ITOA(__LINE__),'>'",1) ;
	       //fnWebDeBug("'WebDeBug fnReadFile. FilePath: ',icReadFile,
						  '! line-<',ITOA(__LINE__),'>'",1) ;
	       }
	  file_close(nReadFHandle) ;
	  }
     else
	  {
	  stack_var char cErrorMsg [40] ;
	  switch (itoa(nReadFHandle)) 
	       {
	       case '-2': {cErrorMsg = 'invalid file path or name'} ;
	       case '-5': {cErrorMsg = 'disk I/O error'} ;
	       case '-3': {cErrorMsg = 'invalid value supplied for IOFlag'} ;
	       }
	  //fnWebDeBug("'WebDeBug fnOpenFile. Bad Open_File: ',cErrorMsg,
						  '! line-<',ITOA(__LINE__),'>'",1) ;
	  //fnWebDeBug("'WebDeBug fnOpenFile. FilePath: ',icReadFile,
						  '! line-<',ITOA(__LINE__),'>'",1) ;
	  }
     file_close(nReadFHandle) ;
     
     RETURN nReadFResult ;
     *)
     }

DEFINE_FUNCTION fnBeginReadingFiles() //body commented out

     {
     (*
     nReading = 1 ;
     WHILE(nFileReadIndx < nFileInsertIndx)
	  {
	  if(fnFileRead(cFile_Q_Arry[nFileReadIndx],MAX_READ_FILE_LENGTH))
	       {
	       fnWebPageOut(PAGE_SEND_FILES) ;
	       cFile_Q_Arry[nFileReadIndx] = '' ; //empty after it's sent!
	       nFileReadIndx ++ ;
	       }
	  else
	       {
	       cFile_Q_Arry[nFileReadIndx] = '' ; //invalid so clear and move on!
	       nFileReadIndx ++ ;
	       }
	  }
     nReading = 0 ;
     nFileInsertIndx = 1 ;//reset values when complete
     nFileReadIndx = 1 ;
     *)
     }
     
DEFINE_FUNCTION CHAR[MAX_LEN_STR_MSG] fnHEADER_200OK(INTEGER iLengthContent)

     {
     STACK_VAR CHAR cWebHead[MAX_LEN_STR_MSG] ;
     
     cWebHead = "'HTTP/1.1 200 OK',CRLF,
     'Date: ',cWebCurDateTime,CRLF,
     'Expires: ',cWebExpDateTime,CRLF,
     'Connection: keep-alive',CRLF,
     'Content-Type: text/html',CRLF,
     'Server: AMX NetLinx',CRLF" ;
     if(length_string(cRXCookie))                           ////    Set-Cookie: DLILPC= try to force our own cookie
	  {
	  cWebHead = "cWebHead,'Cookie: JSESSIONID=',cRXCookie,CRLF" ;
	  }
     else
	  {
	  cWebHead = "cWebHead,'Cookie: JSESSIONID=""',CRLF" ;
	  }
     cWebHead = "cWebHead,
     'Content-Length: ',itoa(iLengthContent),  //no cr or lf after content length?
     CRLF,
     CRLF" ;
     
     RETURN cWebHead ;
     }
     //'Cache-Control: max-age=2592000',CRLF,
     //'Expires: Mon, 22 Nov 2010 23:18:54 EST',CRLF,
     //'Last-Modified: ',DAY,', ',cWebCurDateTime,' ',TIME,' EST',CRLF,
     //'ETag: "1234a-56bc-78d70435"',CRLF" ;

DEFINE_FUNCTION CHAR[MAX_LEN_STR_MSG] fnHEADER_200OK_SetCookie(INTEGER iLengthContent)

     {
     STACK_VAR CHAR cWebHead[MAX_LEN_STR_MSG] ;
     
     cWebHead = "'HTTP/1.1 200 OK',CRLF,
     'Date: ',cWebCurDateTime,CRLF,
     'Expires: ',cWebExpDateTime,CRLF,
     'Connection: keep-alive',CRLF,
     'Content-Type: text/html',CRLF,
     'Server: AMX NetLinx',CRLF,
     'Set-Cookie: JSESSIONID=',AMX_MOBILE_COOKIE,CRLF,
     'Content-Length: ',itoa(iLengthContent),  //no cr or lf after content length?
     CRLF,
     CRLF" ;
     
     RETURN cWebHead ;
     }
     
DEFINE_FUNCTION CHAR[MAX_LEN_STR_MSG] fnHEADER_200OK_Files(SLONG iLengthContent)

     {
     STACK_VAR CHAR cWebHead[MAX_LEN_STR_MSG] ;
     
     cWebHead = "'HTTP/1.0 200 OK',CRLF,
     'Date: ',cWebCurDateTime,CRLF,
     'Server: AMX NetLinx',CRLF,
     'Last-Modified: Wed, 11 Feb 2009 09:05:55 EST',CRLF,
     'Cookie: JSESSIONID=',cRXCookie,CRLF,
     'Connection: keep-alive',CRLF,
     'Content-Type: image/jpeg',CRLF,  //type="image/x-icon"
     'Content-Length: ',itoa(iLengthContent),  //no cr or lf after content length?
     CRLF,
     CRLF" ;
          
     RETURN cWebHead ;
     }     

DEFINE_FUNCTION CHAR[MAX_LEN_STR_MSG] fnHEADER_202()

     {
     STACK_VAR CHAR cWebHead[MAX_LEN_STR_MSG] ;
     
     cWebHead = "'HTTP/1.1 202 Accepted',CRLF,
     'Date: ',cWebCurDateTime,CRLF,
     'Server: AMX NetLinx',CRLF" ;
     if(length_string(cRXCookie))
	  {
	  cWebHead = "cWebHead,'Cookie: JSESSIONID=',cRXCookie,CRLF" ;
	  }
     else
	  {
	  cWebHead = "cWebHead,'Cookie: JSESSIONID=""',CRLF" ;
	  }
     cWebHead = "cWebHead,'Connection: keep-alive',CRLF,
     CRLF" ;
      
     RETURN cWebHead ;
     }
     
DEFINE_FUNCTION CHAR[MAX_LEN_STR_MSG] fnHEADER_204()

     {
     STACK_VAR CHAR cWebHead[MAX_LEN_STR_MSG] ;
     
     cWebHead = "'HTTP/1.1 204 No Response',CRLF,
     'Date: ',cWebCurDateTime,CRLF,
     'Server: AMX NetLinx',CRLF,
     'Cookie: JSESSIONID=',cRXCookie,CRLF,
     'Connection: keep-alive',CRLF,
     CRLF" ;
      
     RETURN cWebHead ;
     }
     
     
DEFINE_FUNCTION CHAR[MAX_LEN_STR_MSG] fnHEADER_304()

     {
     STACK_VAR CHAR cWebHead[MAX_LEN_STR_MSG] ;
     
     cWebHead = "'HTTP/1.1 304 Not Modified',CRLF,
     'Date: ',cWebCurDateTime,CRLF,
     'Server: AMX NetLinx',CRLF,
     'Cookie: JSESSIONID=',cRXCookie,CRLF,
     'Connection: keep-alive',CRLF,
     //'ETag: "681194-65b-4081e43c"',CRLF, need the tag to use
     CRLF" ;
     
     RETURN cWebHead ;
     }
     
DEFINE_FUNCTION CHAR[MAX_LEN_STR_MSG] fnHEADER_404()

     {
     STACK_VAR CHAR cWebHead[MAX_LEN_STR_MSG] ;
     
     cWebHead = "'HTTP/1.1 404 Not found',CRLF,
     'Date: ',cWebCurDateTime,CRLF,
     'Server: AMX NetLinx',CRLF,
     'Cookie: JSESSIONID=',cRXCookie,CRLF,
     'Connection: Keep-Alive',CRLF,
     CRLF" ;
     
     RETURN cWebHead ;
     }
     
DEFINE_FUNCTION CHAR[MAX_LEN_STR_MSG] fnCSS_IncludeRefresh()

//http://www.w3schools.com/HTMLDOM/met_loc_replace.asp
//http://www.jibbering.com/2002/4/httprequest.html
//http://www.jibbering.com/2002/4/httprequest.html
//http://www.w3schools.com/XML/xml_http.asp
//http://www.w3.org/TR/XMLHttpRequest/
//http://msdn.microsoft.com/en-us/library/ms535157(VS.85).aspx
//http://blogs.telerik.com/files/AjaxPart1.pdf
//http://msdn.microsoft.com/en-us/library/ms757849(VS.85).aspx

     {
     STACK_VAR CHAR cCSS[MAX_LEN_STR_MSG] ;
     
     cCSS = "cCSS,
'var obj = null;',$0A,

'function getURL(url, callBackFunc) 
     
     {
     obj = new XMLHttpRequest();
     obj.onreadystatechange = callBackFunc;
     obj.open("GET", url, true);
     obj.send(null);
     obj.onreadystatechange = callBackFunc;
	
     return obj;
     }',$0A,
     
'function getResponse(obj) 
     
     {
     var data = null;
     if ( obj != null ) 
	  {
	  if (obj.readyState == 4) 
	       {
	       if (obj.status == 200) 
		    {
		    data = obj.responseText;
		    }
	       }
	  }
     return data;
     }',$0A,
     
'var changeReq = null;',$0A,

'function checkChange() 
     
     {
     changeReq = getURL("',cWebURLPathRefresh,'", takeAction);
     }',$0A,
     
'function takeAction() 

     {
     if(changeReq) 
	  {
	  var data = getResponse(changeReq);
	  if ( data != null) 
	       {
	       reloadPage();
	       }
	  }
     
     }',$0A,// ',cData2,' = data;
     
//'var updateReq = null;',$0A,
//
//'function updateContent() 
//     
//     {
//     updateReq = getURL("',cWebURLPathReFresh,'", doUpdate);
//     }',$0A,
     
'function reloadPage()
  {
  window.location.replace("',cWebURLPathHome,'")
  }',$0A,   //window.location.reload()getURL("',cWebURLPathHome,'", DoNothing);
  
'function DoNothing()
     {
     var nothing = null;
     }',$0A" ;//give it something to do?
  
//'function doUpdate() 
//
//     {
//     if (updateReq) 
//	  {
//	  var data = getResponse(updateReq);
//	  if ( data != null )
//	       {
//	       reloadPage();
//	       }
//	  }
//     }',$0A,$0A,

 

cCSS = "cCSS,'setInterval("checkChange()", ',itoa(nAutoRefreshTime),');',$0A,$0A" ;

     RETURN cCSS ;
     }
     
DEFINE_FUNCTION CHAR[MAX_LEN_STR_MSG] fnCSS_BLACKBERRY(INTEGER iIncludeRefresh(*http://na.blackberry.com/eng/deliverables/6176/HTML_ref_meta_564143_11.jsp*))

     {
     STACK_VAR CHAR cCSS[MAX_LEN_STR_MSG] ;
   
     cCSS = fnCSS_iPHONE(nAutoRefresh) ;//temp
     
     RETURN cCSS ;
     }
     
DEFINE_FUNCTION CHAR[MAX_LEN_STR_MSG] fnCSS_iPHONE(INTEGER iIncludeRefresh)

     {
     //STACK_VAR INTEGER i ; //needed to create new shadow colors list
     STACK_VAR CHAR cCSS[MAX_LEN_STR_MSG] ;
     STACK_VAR CHAR cBG_Color[6] ;         //needed to make no show button invisible
     STACK_VAR CHAR cBtn_Width[3] ;     
     STACK_VAR CHAR cBtn_Height[2] ; 
     STACK_VAR CHAR cBtn_Border_Type[6] ; 
     STACK_VAR CHAR cBtn_Border_Size[26] ; 
     STACK_VAR CHAR cBtn_Font_Size[2] ;
     STACK_VAR CHAR cBtn_Font_Weight[6] ;     
     STACK_VAR CHAR cBtn_Border_Radius[2] ; //1234567890123456789012  n= posibble number n8 coulb be 18 for ex.
     STACK_VAR CHAR cBtn_Shadow_x[2] ;      // n8px n6px 40px #000000
     STACK_VAR CHAR cBtn_Shadow_y[2] ;      // n8px n6px 40px #000000
     STACK_VAR CHAR cBtn_Shadow_Blur[2] ;   // n8px n6px 40px #000000
          
     cBG_Color = '080808' ; 
     cBtn_Width = '100' ;
     cBtn_Height = '30' ;
     cBtn_Border_Type = 'outset' ;
     cBtn_Border_Size = '3' ;
     cBtn_Font_Size = '9' ;
     cBtn_Font_Weight = 'normal' ;
     cBtn_Border_Radius = '15' ; // 1/2 OF THE BTN HEIGHT
     cBtn_Shadow_x = '8' ;
     cBtn_Shadow_y = '6' ;
     cBtn_Shadow_Blur = '40' ;
     //cBtn_Shadow_Str = '8px 6px 40px #000000' ;  /x off , y off , shadow blur, color
     
     cCSS = "'<style type="text/css">',$0A,
'body{
     margin: 0;
     font-family: "trebuchet ms",helvetica,sans-serif;
     background: #505050  ;
     color: #FFFFFF;
     }
     
.container{
     position: absolute;
     width: 100%;
     }

body[orient="profile"] .container{
     height: 436px;
     }
    
body[orient="landscape"] .container{
     height: 258px;
     }
    
.toolbar{
     position: absolute;
     width: 100%;
     height: 60px;
     font-size: 28pt;
     }
    
body[orient="landscape"] .toolbar{
     height: 30px;
     font-size: 16pt;
     }

.anchorTop{
     top: 0;
     }

.anchorBottom{
     bottom: 0;
     }

.center{
     position: absolute;
     top: 60px;
     bottom: 60px;
    }

body[orient="landscape"] .center{
     top: 50px;
     bottom: 30px;
     }
     
body{
     margin: 0;
     padding: 0;
     width: 320px;
     height: 416px;
     font-family: "trebuchet ms",helvetica,sans-serif;
     -webkit-user-select: none;
     cursor: default;
     -webkit-text-size-adjust: none;
     }

.main{
     overflow: hidden;
     position: relative;
     }

.header{
     position: relative;
     height: 40px;
     -webkit-box-sizing: border-box;
     box-sizing: border-box;
     background-color: rgb(111, 135, 168);
     border-top: 1px solid rgb(179, 186, 201);
     border-bottom: 1px solid rgb(73, 95, 144);
     color: white;
     font-size: 20px;
     text-shadow: rgba(0, 0, 0, 0.6) 0 -1px 0;
     font-weight: bold;
     text-align: center;
     line-height: 42px;
     }'" ;

//cCSS = "cCSS,'    
//table.title{
//     width: 100%;
//     height: 50px;
//     position: absolute;
//     top: 0px;
//     left: 0px;
//     }

cCSS = "cCSS,'  	 
table.curpage{
     width: 100%;
     height: 24px;
     position: absolute;
     top: 34px;
     left: 0px;
     }
     
table.btns{
     width: 100%;
     height: 240px;
     position: absolute;
     top: 68px;
     left: 0px;
     }'" ;
     
//tr{
//     empty-cells: show;
//     width: 100%;
//     height: 40px;
//     margin-left: 0px; 
//     }
//     
//tr.title{
//     empty-cells: show;
//     width: 100%;
//     height: 50px;
//     margin-left: 0px; 
//     }

cCSS = "cCSS,'  	 
tr.curpage{
     empty-cells: show;
     width: 100%;
     height: 24px;
     margin-left: 0px; 
     }
     
tr.btns{
     empty-cells: show;
     width: 100%;
     height: 30px;
     margin-left: 0px; 
     }'" ;
     
//td.title{
//     width: 100%;
//     height: 50px;
//     align: center;
//     text-align: center; 
//     }

cCSS = "cCSS,'  	 
td.curpage{
     width: 100%;
     height: 24px;
     text-align: center; 
     }
     
td.btn{
     padding: 0px;
     width: ',cBtn_Width,'px;
     height: ',cBtn_Height,'px;
     align: center; 
     }

hr.title{
     width: 90%;
     height: 1px;
     color: #E0E0E0;
     }
     
h1.title{
     font-family: "trebuchet ms",helvetica,sans-serif;
     font-size: medium;
     text-shadow: rgba(0, 0, 0, 0.6) 0 -1px 0;
     font-weight: bold;
     color: #E0E0E0;
     text-align: center;
     }
     
h2.curpage{
     font-family: "trebuchet ms",helvetica,sans-serif;
     color: white;
     font-size: 12px;
     text-shadow: rgba(0, 0, 0, 0.6) 0 -1px 0;
     font-weight: bold;
     text-align: center;
     }
     
h3.login{
     font-family: "trebuchet ms",helvetica,sans-serif;
     font-size: medium;
     text-shadow: rgba(0, 0, 0, 0.6) 0 -1px 0;
     font-weight: bold;
     color: #F8F8F8;
     text-align: center;
     }
     
button{
     width: ',cBtn_Width,'px;
     height: ',cBtn_Height,'px;
     -webkit-border-radius: ',cBtn_Border_Radius,'px;
     font-family: "trebuchet ms",helvetica,sans-serif;
     font-size: ',cBtn_Font_Size,';
     font-weight: ',cBtn_Font_Weight,';
     text-align: center; 
     }
     
.off{ 
     -webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #000000;
     background-color: #383838;
     border: 3px outset;
     border-color: #D0D0D0 #707070 #707070 #D0D0D0;
     color: #F8F8F8;
     }
     
.on{ 
     background-color: #B8B8B8;
     border: 3px inset;
     border-color: #707070 #D0D0D0 #D0D0D0 #707070;
     color: #101010;
     }'" ;
     
(*  use to create the shadow hex value at the end.  Once made cut & paste into code so it doesn't run
    on every page load or refresh.
    
for(i = 1 ; i <= 100 ; i ++)
     {
     cCSS = "cCSS,'.on.on',itoa(i),' {-webkit-box-shadow: ',cBtn_Shadow_x,'px ',
			      cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #',fn2DHEX(i),fn2DHEX(i),'00;}',$0A"
     }
*)

cCSS = "cCSS,'
.on.on1 {-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #020200;}
.on.on2 {-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #050500;}
.on.on3 {-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #070700;}
.on.on4 {-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #0A0A00;}
.on.on5 {-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #0C0C00;}
.on.on6 {-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #0F0F00;}
.on.on7 {-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #111100;}
.on.on8 {-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #141400;}
.on.on9 {-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #161600;}
.on.on10{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #191900;}
.on.on11{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #1C1C00;}
.on.on12{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #1E1E00;}
.on.on13{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #212100;}
.on.on14{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #232300;}
.on.on15{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #262600;}
.on.on16{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #282800;}
.on.on17{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #2B2B00;}
.on.on18{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #2D2D00;}
.on.on19{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #303000;}
.on.on20{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #333300;}
.on.on21{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #353500;}
.on.on22{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #383800;}
.on.on23{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #3A3A00;}
.on.on24{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #3D3D00;}
.on.on25{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #3F3F00;}
.on.on26{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #424200;}
.on.on27{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #444400;}
.on.on28{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #474700;}
.on.on29{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #494900;}
.on.on30{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #4C4C00;}
.on.on31{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #4F4F00;}
.on.on32{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #515100;}
.on.on33{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #545400;}
.on.on34{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #565600;}
.on.on35{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #595900;}
.on.on36{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #5B5B00;}
.on.on37{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #5E5E00;}
.on.on38{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #606000;}
.on.on39{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #636300;}
.on.on40{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #666600;}
.on.on41{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #686800;}
.on.on42{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #6B6B00;}
.on.on43{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #6D6D00;}
.on.on44{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #707000;}
.on.on45{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #727200;}
.on.on46{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #757500;}
.on.on47{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #777700;}
.on.on48{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #7A7A00;}
.on.on49{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #7C7C00;}
.on.on50{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #7F7F00;}
.on.on51{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #828200;}
.on.on52{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #848400;}
.on.on53{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #878700;}
.on.on54{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #898900;}
.on.on55{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #8C8C00;}
.on.on56{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #8E8E00;}
.on.on57{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #919100;}
.on.on58{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #939300;}
.on.on59{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #969600;}
.on.on60{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #999900;}
.on.on61{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #9B9B00;}
.on.on62{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #9E9E00;}
.on.on63{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #A0A000;}
.on.on64{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #A3A300;}
.on.on65{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #A5A500;}
.on.on66{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #A8A800;}
.on.on67{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #AAAA00;}
.on.on68{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #ADAD00;}
.on.on69{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #AFAF00;}
.on.on70{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #B2B200;}
.on.on71{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #B5B500;}
.on.on72{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #B7B700;}
.on.on73{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #BABA00;}
.on.on74{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #BCBC00;}
.on.on75{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #BFBF00;}
.on.on76{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #C1C100;}
.on.on77{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #C4C400;}
.on.on78{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #C6C600;}
.on.on79{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #C9C900;}
.on.on80{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #CCCC00;}
.on.on81{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #CECE00;}
.on.on82{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #D1D100;}
.on.on83{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #D3D300;}
.on.on84{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #D6D600;}
.on.on85{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #D8D800;}
.on.on86{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #DBDB00;}
.on.on87{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #DDDD00;}
.on.on88{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #E0E000;}
.on.on89{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #E2E200;}
.on.on90{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #E5E500;}
.on.on91{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #E8E800;}
.on.on92{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #EAEA00;}
.on.on93{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #EDED00;}
.on.on94{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #EFEF00;}
.on.on95{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #F2F200;}
.on.on96{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #F4F400;}
.on.on97{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #F7F700;}
.on.on98{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #F9F900;}
.on.on99{-webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #FCFC00;}
.on.on100{-webkit-box-shadow:',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #FFFF00;}'" ;

cCSS = "cCSS,'
.click{
     -webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #000000;
     background-color: #707070;
     border: 3px inset;
     border-color: #D0D0D0 #707070 #707070 #D0D0D0;
     color: #101010;
     }
     
.noshow{ 
     width: ',cBtn_Width,'px;
     height: ',cBtn_Height,'px;
     opacity: 0;
     }
     
.menu{ 
     -webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #000000;
     background-color: #C80000;
     border: 3px outset;
     border-color: #D0D0D0 #707070 #707070 #D0D0D0;
     color: #F8F8F8;
     }
     
.mclick{
     -webkit-box-shadow: ',cBtn_Shadow_x,'px ',cBtn_Shadow_y,'px ',cBtn_Shadow_Blur,'px #000000;
     background-color: #600000;
     border: 3px inset;
     border-color: #707070 #D0D0D0 #D0D0D0 #707070;
     color: #101010;
     }

</style>',$0A,$0A" ;

cCSS = "cCSS,'<script type="text/javascript">',$0A" ;     
     
if(iIncludeRefresh)
     {
     cCSS = "cCSS,fnCSS_IncludeRefresh()" ;
     }

cCSS = "cCSS,'</script>',$0A,$0A" ;//window.resizeTo(screen.width,screen.height);

cCSS = "cCSS,'<script type="application/x-javascript">',$0A" ;
  
cCSS = "cCSS,'addEventListener("load", function()
	  {
	  setTimeout(updateLayout, 0);
	  }, false);
    
    var currentWidth = 0;
    
    function updateLayout()
    {
        if (window.innerWidth != currentWidth)
        {
            currentWidth = window.innerWidth;
	    document.getElementById(''width'').innerHTML = "[width = " + currentWidth + "px]";

            var orient = currentWidth == 320 ? "profile" : "landscape";
            document.body.setAttribute("orient", orient);
            setTimeout(function()
            {
                window.scrollTo(0, 1);
            }, 100);            
        }
    }

    setInterval(updateLayout, 400);
    
</script>',$0A,$0A" ;

     RETURN cCSS ;
     }
    
DEFINE_FUNCTION CHAR[MAX_LEN_STR_MSG] fnCSS_WINSAFARI(INTEGER iIncludeRefresh)

     {
     STACK_VAR CHAR cCSS[MAX_LEN_STR_MSG] ;
     STACK_VAR CHAR cBG_Color[6] ;     //needed to make no show button invisible
     
     cBG_Color = '080808' ; 
     
     cCSS = "'<style type="text/css">',$0A,
'body{
     margin: 0;
     font-family: "trebuchet ms",helvetica,sans-serif;
     background: #000000;
     color: #FFFFFF;
     }
    
.container{
     position: absolute;
     width: 480px;
     }

.toolbar{
     position: absolute;
     width: 480px;
     height: 60px;
     }

.anchorTop{
     top: 0;
     }

.anchorBottom{
     bottom: 0;
     }

.center{
     position: absolute;
     top: 60px;
     bottom: 60px;
     }

body{
     margin: 0;
     padding: 0;
     width: 320px;
     height: 416px;
     font-family: "trebuchet ms",helvetica,sans-serif;
     -webkit-user-select: none;
     cursor: default;
     -webkit-text-size-adjust: none;
     }

.main{
     overflow: hidden;
     position: relative;
     }

.header{
     position: relative;
     height: 44px;
     -webkit-box-sizing: border-box;
     box-sizing: border-box;
     background-color: rgb(111, 135, 168);
     border-top: 1px solid rgb(179, 186, 201);
     border-bottom: 1px solid rgb(73, 95, 144);
     color: white;
     font-size: 20px;
     text-shadow: rgba(0, 0, 0, 0.6) 0 -1px 0;
     font-weight: bold;
     text-align: center;
     line-height: 42px;
     }'" ;
     
cCSS = "cCSS,
     
'table{
     width: 480px;
     height: 600px;
     position: absolute;
     top: 0px;
     left: 0px;
     }
     
table.title{
     width: 480px;
     height: 80px;
     position: absolute;
     top: 0px;
     left: 0px;
     }
	 
table.curpage{
     width: 480px;
     height: 40px;
     position: absolute;
     top: 55px;
     left: 0px;
     }
     
table.head{
     width: 480px;
     height: 120px;
     position: absolute;
     top: 0px;
     left: 0px;
     }
     
table.btns{
     width: 480px;
     height: 400px;
     position: absolute;
     top: 80px;
     left: 0px;
     }
     
tr{
     empty-cells: show;
     width: 480px;
     height: 40px;
     margin-left: 0px; 
     }
     
tr.title{
     empty-cells: show;
     width: 480px;
     height: 80px;
     margin-left: 0px; 
     }
	 
tr.curpage{
     empty-cells: show;
     width: 480px;
     height: 40px;
     margin-left: 0px; 
     }
     
tr.btns{
     empty-cells: show;
     width: 480px;
     height: 35px;
     margin-left: 0px; 
     }
     
td{
     height: 40px;
     width: 160px;
     }
      
td.title{
     height: 80px;
     width: 480px;
     align: center;
     text-align: center; 
     }
	 
td.curpage{
     height: 40px;
     width: 480px;
     text-align: center; 
     }
     
td.btn{
     padding-right:2px;     
     padding-left:2px;
     height: 40px;
     width: 160px;
     font-size: small;
     font-weight: bold;
     align: center; 
     }

hr.title{
     height: 1px;
     width: 90%;
     color: #E0E0E0;
     align: center;
     }
     
h1.title{
     font-size: x-large;
     font-weight: bold;
     color: #E0E0E0;
     text-align: center;
     }
	 
h2.curpage{
     font-size: medium;
     font-weight: bold;
     color: #D00000;
     text-align: center;
     }
     
h3.login{
     font-family: "trebuchet ms",helvetica,sans-serif;
     font-size: medium;
     text-shadow: rgba(0, 0, 0, 0.6) 0 -1px 0;
     font-weight: bold;
     color: #F8F8F8;
     text-align: center;
     }'" ;
     
cCSS = "cCSS,
'button.off{ 
     border-color: #D0D0D0 #707070 #707070 #D0D0D0;
     background-color: #282828 ;
     width: 100px;
     height: 35px;
     border: 1px solid;
     -webkit-gradient(radial, 45 45, 10, 52 50, 30, from(#A7D30C), to(rgba(1,159,98,0)), color-stop(90%, #019F62)),
                       -webkit-gradient(radial, 105 105, 20, 112 120, 50, from(#ff5f98), to(rgba(255,1,136,0)), color-stop(75%, #ff0188)),
                       -webkit-gradient(radial, 95 15, 15, 102 20, 40, from(#00c9ff), to(rgba(0,201,255,0)), color-stop(80%, #00b5e2)),
                       -webkit-gradient(radial, 0 150, 50, 0 140, 90, from(#f4f201), to(rgba(228, 199,0,0)), color-stop(80%, #e4c700));	
     font-family: "trebuchet ms",helvetica,sans-serif;
     font-size: small;
     font-weight: bold;
     color: #F8F8F8;
     text-align: center; 
     }
     
button.on{ 
     border-color: #707070 #D0D0D0 #D0D0D0 #707070;
     background-color: #D0D0D0;
     width: 100px;
     height: 35px;
     border: 1px solid;
     -webkit-gradient(radial, 45 45, 10, 52 50, 30, from(#A7D30C), to(rgba(1,159,98,0)), color-stop(90%, #019F62)),
                       -webkit-gradient(radial, 105 105, 20, 112 120, 50, from(#ff5f98), to(rgba(255,1,136,0)), color-stop(75%, #ff0188)),
                       -webkit-gradient(radial, 95 15, 15, 102 20, 40, from(#00c9ff), to(rgba(0,201,255,0)), color-stop(80%, #00b5e2)),
                       -webkit-gradient(radial, 0 150, 50, 0 140, 90, from(#f4f201), to(rgba(228, 199,0,0)), color-stop(80%, #e4c700));	
     font-family: "trebuchet ms",helvetica,sans-serif;
     font-size: small;
     font-weight: bold;
     color: #101010;
     text-align: center; 
     }
     
button.click{
     border-color: #D0D0D0 #707070 #707070 #D0D0D0;
     background-color: #707070;
     width: 100px;
     height: 35px;
     border: 1px solid;
     -webkit-gradient(radial, 45 45, 10, 52 50, 30, from(#A7D30C), to(rgba(1,159,98,0)), color-stop(90%, #019F62)),
                       -webkit-gradient(radial, 105 105, 20, 112 120, 50, from(#ff5f98), to(rgba(255,1,136,0)), color-stop(75%, #ff0188)),
                       -webkit-gradient(radial, 95 15, 15, 102 20, 40, from(#00c9ff), to(rgba(0,201,255,0)), color-stop(80%, #00b5e2)),
                       -webkit-gradient(radial, 0 150, 50, 0 140, 90, from(#f4f201), to(rgba(228, 199,0,0)), color-stop(80%, #e4c700));	
     font-family: "trebuchet ms",helvetica,sans-serif;
     font-size: small;
     font-weight: bold;
     color: #101010;
     text-align: center; 
     }
     
button.noshow{ 
     border-color: #080808 #080808 #080808 #080808;
     background-color: #080808;
     width: 100px;
     height: 35px;
     border: 1px solid;
     font-family: "trebuchet ms",helvetica,sans-serif;
     font-size: small;
     font-weight: bold;
     color: #080808;
     text-align: center; 
     }
     
button.menu{ 
     border-color: #D0D0D0 #707070 #707070 #D0D0D0;
     background-color: #C80000;
     width: 100px;
     height: 35px;
     border: 1px solid;
     -webkit-gradient(radial, 45 45, 10, 52 50, 30, from(#A7D30C), to(rgba(1,159,98,0)), color-stop(90%, #019F62)),
                       -webkit-gradient(radial, 105 105, 20, 112 120, 50, from(#ff5f98), to(rgba(255,1,136,0)), color-stop(75%, #ff0188)),
                       -webkit-gradient(radial, 95 15, 15, 102 20, 40, from(#00c9ff), to(rgba(0,201,255,0)), color-stop(80%, #00b5e2)),
                       -webkit-gradient(radial, 0 150, 50, 0 140, 90, from(#f4f201), to(rgba(228, 199,0,0)), color-stop(80%, #e4c700));	
     font-family: "trebuchet ms",helvetica,sans-serif;
     font-size: small;
     font-weight: bold;
     color: #F8F8F8;
     text-align: center; 
     }
     
button.mclick{
     border-color: #707070 #D0D0D0 #D0D0D0 #707070;
     background-color: #600000;
     width: 100px;
     height: 35px;
     border: 1px solid;
     -webkit-gradient(radial, 45 45, 10, 52 50, 30, from(#A7D30C), to(rgba(1,159,98,0)), color-stop(90%, #019F62)),
                       -webkit-gradient(radial, 105 105, 20, 112 120, 50, from(#ff5f98), to(rgba(255,1,136,0)), color-stop(75%, #ff0188)),
                       -webkit-gradient(radial, 95 15, 15, 102 20, 40, from(#00c9ff), to(rgba(0,201,255,0)), color-stop(80%, #00b5e2)),
                       -webkit-gradient(radial, 0 150, 50, 0 140, 90, from(#f4f201), to(rgba(228, 199,0,0)), color-stop(80%, #e4c700));	 
     font-family: "trebuchet ms",helvetica,sans-serif;
     font-size: small;
     font-weight: bold;
     color: #101010;
     text-align: center;
     }
     
button.page{ 
     border-color: #080808 #080808 #080808 #080808;
     background-color: #080808;
     width: 200px;
     height: 35px;
     border: 1px solid;
     font-family: "trebuchet ms",helvetica,sans-serif;
     font-size: small;
     font-weight: bold;
     color: #F8F8F8;
     text-align: center; 
     }
 
button.hover{
     border-color: #000 #000 #ccc #ccc;
     background-color: #ddd;
     width: 100px;
     height: 35px;
     border: 1px solid;
     -webkit-gradient(radial, 45 45, 10, 52 50, 30, from(#A7D30C), to(rgba(1,159,98,0)), color-stop(90%, #019F62)),
                       -webkit-gradient(radial, 105 105, 20, 112 120, 50, from(#ff5f98), to(rgba(255,1,136,0)), color-stop(75%, #ff0188)),
                       -webkit-gradient(radial, 95 15, 15, 102 20, 40, from(#00c9ff), to(rgba(0,201,255,0)), color-stop(80%, #00b5e2)),
                       -webkit-gradient(radial, 0 150, 50, 0 140, 90, from(#f4f201), to(rgba(228, 199,0,0)), color-stop(80%, #e4c700));	
     font-family: "trebuchet ms",helvetica,sans-serif;
     font-size: small;
     font-weight: bold;
     color: #C0C0C0;
     text-align: center; 
     }
     
button.out{
     border-color: #888 #888 #fff #fff;
     background-color: #fff;
     width: 100px;
     height: 35px;
     border: 1px solid;
     -webkit-gradient(radial, 45 45, 10, 52 50, 30, from(#A7D30C), to(rgba(1,159,98,0)), color-stop(90%, #019F62)),
                       -webkit-gradient(radial, 105 105, 20, 112 120, 50, from(#ff5f98), to(rgba(255,1,136,0)), color-stop(75%, #ff0188)),
                       -webkit-gradient(radial, 95 15, 15, 102 20, 40, from(#00c9ff), to(rgba(0,201,255,0)), color-stop(80%, #00b5e2)),
                       -webkit-gradient(radial, 0 150, 50, 0 140, 90, from(#f4f201), to(rgba(228, 199,0,0)), color-stop(80%, #e4c700));	
     font-family: "trebuchet ms",helvetica,sans-serif;
     font-size: small;
     font-weight: bold;
     color: #0000FF;
     text-align: center; 
     }

</style>',$0A,$0A,//RESIZE THE WINDOW FOR THE WEB AGENT TYPE

'<script type="text/javascript">',
'function fnResizeWindow()
     {
     window.resizeTo(510,720);
     }',$0A" ;
     
if(iIncludeRefresh)
     {
     cCSS = "cCSS,fnCSS_IncludeRefresh()" ;
     }
     
 cCSS = "cCSS,'</script>',$0A,$0A" ;//window.resizeTo(screen.width,screen.height);
     
     RETURN cCSS ;
     }
     
DEFINE_FUNCTION CHAR[MAX_LEN_STR_MSG] fnCSS_WINGENERIC(INTEGER iIncludeRefresh)

     {// SHADOWS FOR WINDOWS http://msdn.microsoft.com/en-us/library/ms533086(VS.85).aspx
     STACK_VAR CHAR cCSS[MAX_LEN_STR_MSG] ;
     STACK_VAR CHAR cBG_Color[6] ;     //needed to make no show button invisible
     
     cBG_Color = '080808' ; 
     
     cCSS = "'<style type="text/css">',$0A,
'body{
     margin: 0;
     font-family: "trebuchet ms",helvetica,sans-serif;
     background: #000000;
     color: #FFFFFF;
     }
    
.container{
     position: absolute;
     width: 480px;
     }

.toolbar{
     position: absolute;
     width: 480px;
     height: 60px;
     }

.anchorTop{
     top: 0;
     }

.anchorBottom{
     bottom: 0;
     }

.center{
     position: absolute;
     top: 60px;
     bottom: 60px;
     }
     
body{
     margin: 0;
     padding: 0;
     width: 480px;
     height: 600px;
     font-family: "trebuchet ms",helvetica,sans-serif;
     cursor: default;
     }

.main{
     overflow: hidden;
     position: relative;
     }

.header{
     position: relative;
     height: 44px;
     box-sizing: border-box;
     background-color: rgb(111, 135, 168);
     border-top: 1px solid rgb(179, 186, 201);
     border-bottom: 1px solid rgb(73, 95, 144);
     color: white;
     font-size: 20px;
     text-shadow: rgba(0, 0, 0, 0.6) 0 -1px 0;
     font-weight: bold;
     text-align: center;
     line-height: 42px;
     }
     
table{
     width: 480px;
     height: 600px;
     position: absolute;
     top: 0px;
     left: 0px;
     }
     
table.title{
     width: 480px;
     height: 80px;
     position: absolute;
     top: 0px;
     left: 0px;
     }
	 
table.curpage{
     width: 480px;
     height: 40px;
     position: absolute;
     top: 55px;
     left: 0px;
     }
     
table.head{
     width: 480px;
     height: 120px;
     position: absolute;
     top: 0px;
     left: 0px;
     }
     
table.btns{
     width: 480px;
     height: 400px;
     position: absolute;
     top: 80px;
     left: 0px;
     }
     
tr{
     empty-cells: show;
     width: 480px;
     height: 40px;
     margin-left: 0px; 
     }
     
tr.title{
     empty-cells: show;
     width: 480px;
     height: 80px;
     margin-left: 0px; 
     }
	 
tr.curpage{
     empty-cells: show;
     width: 480px;
     height: 40px;
     margin-left: 0px; 
     }
     
tr.btns{
     empty-cells: show;
     width: 480px;
     height: 35px;
     margin-left: 0px; 
	 }
     
td{
     width: 160px;
     height: 40px;
     }
      
td.title{
     width: 480px;
     height: 80px;
     align: center;
     text-align: center; 
     }
	 
td.curpage{
     width: 480px;
     height: 40px;
     text-align: center; 
     }
     
td.btn{
     padding: 0px;   
     width: 160px;
     height: 40px;
     font-size: small;
     font-weight: bold;
     align: center; 
     }

hr.title{
     width: 90%;
     height: 1px;
     color: #E0E0E0;
     align: center;
     }
     
h1.title{
     font-size: x-large;
     font-weight: bold;
     color: #E0E0E0;
     text-align: center;
     }
	 
h2.curpage{
     font-size: medium;
     font-weight: bold;
     color: #D00000;
     text-align: center;
     }
     
h3.login{
     font-family: "trebuchet ms",helvetica,sans-serif;
     font-size: medium;
     text-shadow: rgba(0, 0, 0, 0.6) 0 -1px 0;
     font-weight: bold;
     color: #F8F8F8;
     text-align: center;
     }

button.off{ 
     border-color: #D0D0D0 #707070 #707070 #D0D0D0;
     background-color: #282828 ;
     width: 100px;
     height: 35px;
     border: 1px solid;
     filter: progid:DXImageTransform.Microsoft.Gradient   
     (GradientType=0,StartColorStr=#99F0F0F0 ,EndColorStr=#99101010 ); 
     font-family: "trebuchet ms",helvetica,sans-serif;
	 font-size: small;
     font-weight: bold;
     color: #F8F8F8;
     text-align: center; 
     }
     
button.on{ 
     border-color: #707070 #D0D0D0 #D0D0D0 #707070;
     background-color: #D0D0D0;
     width: 100px;
     height: 35px;
     border: 1px solid;
     filter: progid:DXImageTransform.Microsoft.Gradient   
     (GradientType=0,StartColorStr=#99101010,EndColorStr=#99F0F0F0); 
     font-family: "trebuchet ms",helvetica,sans-serif;
	 font-size: small;
     font-weight: bold;
     color: #101010;
     text-align: center; 
     }
     
button.click{
     border-color: #D0D0D0 #707070 #707070 #D0D0D0;
     background-color: #707070;
     width: 100px;
     height: 35px;
     border: 1px solid;
     filter: progid:DXImageTransform.Microsoft.Gradient   
     (GradientType=0,StartColorStr=#99F0F0F0,EndColorStr=#99101010); 
     font-family: "trebuchet ms",helvetica,sans-serif;
	 font-size: small;
     font-weight: bold;
     color: #101010;
     text-align: center; 
     }
     
button.noshow{ 
     border-color: #080808 #080808 #080808 #080808;
     background-color: #080808;
     width: 100px;
     height: 35px;
     border: 1px solid;
     font-family: "trebuchet ms",helvetica,sans-serif;
	 font-size: small;
     font-weight: bold;
     color: #080808;
     text-align: center; 
     }
     
button.menu{ 
     border-color: #D0D0D0 #707070 #707070 #D0D0D0;
     background-color: #C80000;
     width: 100px;
     height: 35px;
     border: 1px solid;
     filter: progid:DXImageTransform.Microsoft.Gradient   
     (GradientType=0,StartColorStr=#99FF0000,EndColorStr=#99300000); 
     font-family: "trebuchet ms",helvetica,sans-serif;
	 font-size: small;
     font-weight: bold;
     color: #F8F8F8;
     text-align: center; 
     }
     
button.mclick{
     border-color: #707070 #D0D0D0 #D0D0D0 #707070;
     background-color: #600000;
     width: 100px;
     height: 35px;
     border: 1px solid;
     filter: progid:DXImageTransform.Microsoft.Gradient   
     (GradientType=0,StartColorStr=#99300000,EndColorStr=#99FF0000); 
     font-family: "trebuchet ms",helvetica,sans-serif;
	 font-size: small;
     font-weight: bold;
     color: #101010;
     text-align: center; 
     }
     
button.page{ 
     border-color: #080808 #080808 #080808 #080808;
     background-color: #080808;
     width: 200px;
     height: 35px;
     border: 1px solid;
     font-family: "trebuchet ms",helvetica,sans-serif;
	 font-size: small;
     font-weight: bold;
     color: #F8F8F8;
     text-align: center; 
     }
 
button.hover{
     border-color: #000 #000 #ccc #ccc;
     background-color: #ddd;
     width: 100px;
     height: 35px;
     border: 1px solid;
     filter: progid:DXImageTransform.Microsoft.Gradient   
     (GradientType=0,StartColorStr=#bbeeddff,EndColorStr=#bbeeddcc); 
     font-family: "trebuchet ms",helvetica,sans-serif;
	 font-size: small;
     font-weight: bold;
     color: #C0C0C0;
     text-align: center; 
     }
     
button.out{
     border-color: #888 #888 #fff #fff;
     background-color: #fff;
     width: 100px;
     height: 35px;
     border: 1px solid;
     filter: progid:DXImageTransform.Microsoft.Gradient   
     (GradientType=0,StartColorStr=#bbffffff,EndColorStr=#ffeeddaa); 
     font-family: "trebuchet ms",helvetica,sans-serif;
	 font-size: small;
     font-weight: bold;
     color: #0000FF;
     text-align: center; 
     }
     
</style>',$0A,$0A,//RESIZE THE WINDOW FOR THE WEB AGENT TYPE

'<script type="text/javascript">',$0A,
'function fnResizeWindow()
     {
     window.resizeTo(510,720); 
     }',$0A" ;
     
if(iIncludeRefresh)
     {
     cCSS = "cCSS,fnCSS_IncludeRefresh()" ;
     }

cCSS = "cCSS,'</script>',$0A,$0A" ;//window.resizeTo(screen.width,screen.height);

     RETURN cCSS ;
     }
     
DEFINE_FUNCTION fnWEBPage_404(CHAR iWebStrMessage[])

     {
     STACK_VAR CHAR cLocalWebStr[MAX_LEN_STR_MSG] ;
     
     cLocalWebStr = "'<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">',$0A,
     '<HTML><HEAD>',$0A,
     '<TITLE>404 Not Found</TITLE>',$0A,
     '</HEAD><BODY>',$0A,
     '<H1>File Not Found, Sorry!</H1>THE REQUESTED FILE COULD NOT BE FOUND!<p>',$0A,
     '</BODY>',$0A,'</HTML>'" ;
     
     fnConcatString(iWebStrMessage,GET_BUFFER_STRING(cLocalWebStr,LENGTH_STRING(cLocalWebStr))) ;
     
     RETURN ;
     }

DEFINE_FUNCTION fnWEBPage_LoginRedirect(CHAR iWebStrMessage[])

     {
     STACK_VAR CHAR cLocalWebStr[MAX_LEN_STR_MSG] ;
     
     cLocalWebStr = "'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" ',
					'"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">',$0A,
     '<html dir="ltr" lang="en">',$0A,  
     '<head>',$0A,
     '<meta http-equiv="refresh" content="1;url=',cWebURLPathHome,'" />',$0A,//meta used to force a redirect after 1 second
     '<link rel="alternate" media="handheld" href="',cWebURLPathHome,'">',$0A,
     '<title>',cTitle,'</title>',$0A,
     '</head>',$0A,
     '<body></body>',$0A,'</html>'" ;
        
     fnConcatString(iWebStrMessage,GET_BUFFER_STRING(cLocalWebStr,LENGTH_STRING(cLocalWebStr))) ;
     
     RETURN ; 
     }
     
DEFINE_FUNCTION fnWEBPage_Login(CHAR iWebStrMessage[])

     {
     STACK_VAR CHAR cLocalWebStr[MAX_LEN_STR_MSG] ;
     
     cLocalWebStr = "'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">',$0A,
    
     '<html dir="ltr" lang="en">',$0A,  
     '<head>',$0A" ;
     
     if(nWebAgent != iPHONE && nWebAgent != iPOD)
	  {
	  cLocalWebStr = "cLocalWebStr,
	  '<meta http-equiv="Content-Type" content="application/vnd.wap.xhtml+xml; charset=UTF-8"/>',$0A" ;
	  }
     else
	  {
	  cLocalWebStr = "cLocalWebStr,
	  '<meta name="apple-mobile-web-app-capable" content="yes">',$0A,
	  '<meta name="apple-mobile-web-app-status-bar-style" content="black">',$0A,
	  '<meta name="viewport" content="initial-scale=2.3, user-scalable=no" />',$0A,                                 
	  '<meta name="viewport" content="width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />',$0A" ;
	  }
     cLocalWebStr = "cLocalWebStr,
	  '<link rel="alternate" media="handheld" href="http://',cWebURL_IP,'/">',$0A,
	  '<title>',cTitle,'</title>',$0A" ;
	  
     SELECT//PICK THE STYLE SHEET FOR THE WEB AGEBT TYPE!
	  {
	  ACTIVE(nWebAgent = BLACKBERRY):
	       {
	       cLocalWebStr = "cLocalWebStr,fnCSS_BLACKBERRY(CSS_EXCLUDE_REFRESH)" ; 
	       }
	  ACTIVE(nWebAgent = iPOD):
	       {
	       cLocalWebStr = "cLocalWebStr,fnCSS_iPHONE(CSS_EXCLUDE_REFRESH)" ; 
	       }
	  ACTIVE(nWebAgent = iPHONE):
	       {
	       cLocalWebStr = "cLocalWebStr,fnCSS_iPHONE(CSS_EXCLUDE_REFRESH)" ; 
	       }
	  ACTIVE(nWebAgent = WINSAFARI):
	       { 
	       cLocalWebStr = "cLocalWebStr,fnCSS_WINSAFARI(CSS_EXCLUDE_REFRESH)" ; 
	       }
	  ACTIVE(nWebAgent = WINGENERIC):
	       { 
	       cLocalWebStr = "cLocalWebStr,fnCSS_WINGENERIC(CSS_EXCLUDE_REFRESH)" ; 
	       }
	  ACTIVE(1):
	       { 
	       cLocalWebStr = "cLocalWebStr,fnCSS_WINGENERIC(CSS_EXCLUDE_REFRESH)" ; 
	       }
	  }
     
     cLocalWebStr = "cLocalWebStr,
     '</head>',$0A" ;
     if(nWebAgent != iPHONE && nWebAgent != iPOD)
	  {
	  cLocalWebStr = "cLocalWebStr,'<body onload="fnResizeWindow()">',$0A,$0A" ;
	  }
     else
	  {
	  cLocalWebStr = "cLocalWebStr,'<body>',$0A,$0A" ;
	  }
     cLocalWebStr = "cLocalWebStr,
     	  '<div class="container">',$0A,
	       '<div class="toolbar anchorTop">',$0A,
		    '<div class="main">',$0A,
			'<div class="header">',cTitle,'</div>',$0A,
		    '</div>',$0A,
	       '</div>',$0A,$0A,
	       '<br />',$0A,
	       '<br />',$0A,
	       '<br />',$0A,
	       '<br />',$0A,
	       '<form method="post">',$0A,
	       '<p align="center"><h3 class="login">Enter Password</h3></p>',$0A,
	       '<p align="center"><input type="password" name="password" /></p>',$0A,
	       '<p align="center"><input type="submit" value="Enter" href="/pass" /></p>',$0A,
	       '</form>',$0A,
	       '</div>',$0A,
     '</body>',$0A,
     '</html>'"  ;
     
     fnConcatString(iWebStrMessage,GET_BUFFER_STRING(cLocalWebStr,LENGTH_STRING(cLocalWebStr))) ;
     
     RETURN ;
     }
     
DEFINE_FUNCTION fnWEBPage_Retry(CHAR iWebStrMessage[])
     
     {
     STACK_VAR CHAR cLocalWebStr[MAX_LEN_STR_MSG] ;
     
     cLocalWebStr = "'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">',$0A,
    
     '<html dir="ltr" lang="en">',$0A,  
     '<head>',$0A" ;
     
     if(nWebAgent != iPHONE && nWebAgent != iPOD)
	  {
	  cLocalWebStr = "cLocalWebStr,
	  '<meta http-equiv="Content-Type" content="application/vnd.wap.xhtml+xml; charset=UTF-8"/>',$0A" ;
	  }
     else
	  {
	  cLocalWebStr = "cLocalWebStr,
	  '<meta name="apple-mobile-web-app-capable" content="yes">',$0A,
	  '<meta name="apple-mobile-web-app-status-bar-style" content="black">',$0A,
	  '<meta name="viewport" content="initial-scale=2.3, user-scalable=no" />',$0A,                                 
	  '<meta name="viewport" content="width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />',$0A" ;
	  }
     cLocalWebStr = "cLocalWebStr,
	  '<link rel="alternate" media="handheld" href="http://',cWebURL_IP,'/">',$0A,
	  '<title>',cTitle,'</title>',$0A" ;
	  
     SELECT//PICK THE STYLE SHEET FOR THE WEB AGEBT TYPE!
	  {
	  ACTIVE(nWebAgent = BLACKBERRY):
	       {
	       cLocalWebStr = "cLocalWebStr,fnCSS_BLACKBERRY(CSS_EXCLUDE_REFRESH)" ; 
	       }
	  ACTIVE(nWebAgent = iPOD):
	       {
	       cLocalWebStr = "cLocalWebStr,fnCSS_iPHONE(CSS_EXCLUDE_REFRESH)" ; 
	       }
	  ACTIVE(nWebAgent = iPHONE):
	       {
	       cLocalWebStr = "cLocalWebStr,fnCSS_iPHONE(CSS_EXCLUDE_REFRESH)" ; 
	       }
	  ACTIVE(nWebAgent = WINSAFARI):
	       { 
	       cLocalWebStr = "cLocalWebStr,fnCSS_WINSAFARI(CSS_EXCLUDE_REFRESH)" ; 
	       }
	  ACTIVE(nWebAgent = WINGENERIC):
	       { 
	       cLocalWebStr = "cLocalWebStr,fnCSS_WINGENERIC(CSS_EXCLUDE_REFRESH)" ; 
	       }
	  ACTIVE(1):
	       { 
	       cLocalWebStr = "cLocalWebStr,fnCSS_WINGENERIC(CSS_EXCLUDE_REFRESH)" ; 
	       }
	  }
     
     cLocalWebStr = "cLocalWebStr,
     '</head>',$0A" ;
     if(nWebAgent != iPHONE && nWebAgent != iPOD)
	  {
	  cLocalWebStr = "cLocalWebStr,'<body onload="fnResizeWindow()">',$0A,$0A" ;
	  }
     else
	  {
	  cLocalWebStr = "cLocalWebStr,'<body>',$0A,$0A" ;
	  }
     cLocalWebStr = "cLocalWebStr,
	  '<div class="container">',$0A,
	       '<div class="toolbar anchorTop">',$0A,
		    '<div class="main">',$0A,
			'<div class="header">',cTitle,'</div>',$0A,
		    '</div>',$0A,
		    '</div>',$0A,$0A,
		    '<br />',$0A,
		    '<br />',$0A,
		    '<br />',$0A,
		    '<br />',$0A,
		    '<form method="post">',$0A,
		    '<p align="center"><h2 class="curpage">Wrong, Try Again~</h2></p>',$0A,
		    '<p align="center"><input type="password" name="password" /></p>',$0A,
		    '<p align="center"><input type="submit" value="Enter" href="/pass" /></p>',$0A,
		    '</form>',$0A,
		    '</table>',$0A,
	       '</div>',$0A,
	  '</body>',$0A,
     '</html>'" ;
     
     fnConcatString(iWebStrMessage,GET_BUFFER_STRING(cLocalWebStr,LENGTH_STRING(cLocalWebStr))) ;
     
     RETURN ;
     }
     
DEFINE_FUNCTION fnWEBPage_Buttons(CHAR iWebStrMessage[])

     {
     STACK_VAR CHAR cLocalWebStr[MAX_LEN_STR_MSG] ;
     STACK_VAR INTEGER nRowBtn ;
     STACK_VAR INTEGER nRow ;
     
     cLocalWebStr = "'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" ',
					'"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">',$0A,
     '<html dir="ltr" lang="en">',$0A,  
     '<head>',$0A" ;
     
     if(nWebAgent != iPHONE && nWebAgent != iPOD)
	  {
	  cLocalWebStr = "cLocalWebStr,
	  '<meta http-equiv="Content-Type" content="application/vnd.wap.xhtml+xml; charset=UTF-8"/>',$0A" ;
	  }
     else
	  {
	  cLocalWebStr = "cLocalWebStr,
	  '<meta name="apple-mobile-web-app-capable" content="yes">',$0A,
	  '<meta name="apple-mobile-web-app-status-bar-style" content="red">',$0A,
	  //'<meta name="viewport" content="initial-scale=2.3, user-scalable=no" />',$0A,                                 
	  '<meta name="viewport" content="width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />',$0A" ;
	  }
     cLocalWebStr = "cLocalWebStr,
	  '<link rel="alternate" media="handheld" href="http://',cWebURL_IP,'/">',$0A,
	  '<title>',cTitle,'</title>',$0A" ;
	  
     fnConcatString(iWebStrMessage,GET_BUFFER_STRING(cLocalWebStr,LENGTH_STRING(cLocalWebStr))) ;
     
     SELECT//PICK THE STYLE SHEET FOR THE WEB AGENT TYPE!
	  {
	  ACTIVE(nWebAgent = BLACKBERRY):
	       {
	       fnConcatString(iWebStrMessage,fnCSS_BLACKBERRY(nAutoRefresh)) ; 
	       }
	  ACTIVE(nWebAgent = iPOD):
	       {
	       fnConcatString(iWebStrMessage,fnCSS_iPHONE(nAutoRefresh)) ; 
	       }
	  ACTIVE(nWebAgent = iPHONE):
	       {
	       fnConcatString(iWebStrMessage,fnCSS_iPHONE(nAutoRefresh)) ; 
	       }
	  ACTIVE(nWebAgent = WINSAFARI):
	       { 
	       fnConcatString(iWebStrMessage,fnCSS_WINSAFARI(nAutoRefresh)) ; 
	       }
	  ACTIVE(nWebAgent = WINGENERIC):
	       { 
	       fnConcatString(iWebStrMessage,fnCSS_WINGENERIC(nAutoRefresh)) ; 
	       }
	  ACTIVE(1):
	       { 
	       fnConcatString(iWebStrMessage,fnCSS_WINGENERIC(nAutoRefresh)) ; 
	       }
	  }
     
     cLocalWebStr = "cLocalWebStr,
     '</head>',$0A" ;
     if(nWebAgent != iPHONE && nWebAgent != iPOD)
	  {
	  cLocalWebStr = "cLocalWebStr,'<body onload="fnResizeWindow()">',$0A,$0A" ;
	  }
     else
	  {
	  cLocalWebStr = "cLocalWebStr,'<body>',$0A,$0A" ;
	  }
     cLocalWebStr = "cLocalWebStr,
	  '<div class="container">',$0A,
	       '<div class="toolbar anchorTop">',$0A,
		    '<div class="main">',$0A,
			'<div class="header">',cTitle,'</div>',$0A,
		    '</div>',$0A,
	       '</div>',$0A,$0A,
	  '<table class="curpage">',$0A,
	  '<tr class="curpage"><td class="curpage" align="center"><h2 class="curpage">',sWEB_PAGE[nCurWebPage].Pg_NAME ,'</h2></td></tr>',$0A,
	  '</table>',$0A,$0A,
	  '<table class="btns">',$0A" ;
     
     fnConcatString(iWebStrMessage,GET_BUFFER_STRING(cLocalWebStr,LENGTH_STRING(cLocalWebStr))) ;
     
     for(nRow = 1 ; nRow <= MAX_NUM_ROWs ; nRow ++)//8 rows
	  {
	  cLocalWebStr = "cLocalWebStr,'<tr class="btns">',$0A,
				   '<form method="post" enctype="text/plain">',$0A" ; 
	  for(nRowBtn = 1 ; nRowBtn <= MAX_NUM_BTNs_ROW ; nRowBtn ++ )//3 buttons per row
	       {
	       STACK_VAR INTEGER nBtnNumber ;
	       
	       cLocalWebStr = "cLocalWebStr,'<td class="btns" align="center">'" ;
	       
	       nBtnNumber = (((nRow - 1) * MAX_NUM_BTNs_ROW) + nRowBtn) ;
	       (*****************************************************************************************************************)
	       (*   	REFERENCES:	                                                                    			*)
	       (*   	http://www.degraeve.com/reference/specialcharacters.php (special characters/colors) 			*)
	       (*   	http://www.webreference.com/programming/css_stylish	                            			*)
	       (*   	http://www.w3schools.com/html                                                                           *)
	       (*	http://developer.apple.com/safari/library/documentation/AppleApplications/Reference                     *)
	       (*							   /SafariCSSRef/Introduction.html                      *)
	       (*	http://www.designdetector.com/2005/09/css-gradients-demo.php	                                        *)
	       (*	 HTML Tip: Use Lowercase Tags                                                                           *)
	       (*	 HTML tags are not case sensitive: <P> means the same as <p>.                                           *)
	       (*	Plenty of web sites use uppercase HTML tags in their pages.                                             *)
               (*                                                                                                               *)
	       (*	 W3Schools use lowercase tags because the World Wide Web Consortium (W3C)                               *)
	       (*	 recommends lowercase in HTML 4, and demands lowercase tags in future versions of (X)HTML.              *)
               (*                                                                                                               *)
	       (*****************************************************************************************************************)
	       SELECT                                                                                                
		    {
		    ACTIVE(sWEB_PAGE[nCurWebPage].BTN[nBtnNumber].Show == BUTTON_NO_SHOW):
			 {
			 cLocalWebStr = "cLocalWebStr,
				   '<button class="noshow" type="button" disabled="disabled" name="P0BTN0PUSH">',//remove > from end of this line if mouseovers used 
				   (*'onmouseover="this.className=''hover''" onmouseout="this.className=''out''" ',*)
				   (*'onclick="this.className=''click''">',sWEB_PAGE[nCurWebPage].BTN[nBtnNumber].Name,*)'</button>'" ; 
			 }
		    ACTIVE(sWEB_PAGE[nCurWebPage].BTN[nBtnNumber].Show == BUTTON_SHOW):
			 {
			 nBtnCurLevel = sWEB_PAGE[nCurWebPage].BTN[nBtnNumber].Value ;
			 if(nBtnCurLevel) //BUTTON = ON OR HAS VALUE
			      {
			      if(nWebAgent == iPHONE)
				   {
				   cLocalWebStr = "cLocalWebStr,
					'<button class="on on',itoa(nBtnCurLevel),'" type="submit" name="P',itoa(nCurWebPage),'BTN',itoa(nBtnNumber),'PUSH" ',//remove > from end of this line if mouseovers used 
					(*'onmouseover="this.className=''hover''"*)'onmouseout="this.className=''on on',itoa(nBtnCurLevel),'''" ',
					'onclick="this.className=''click''">',sWEB_PAGE[nCurWebPage].BTN[nBtnNumber].Name,'</button>'" ; 
				   }
			      else
				   {
				   cLocalWebStr = "cLocalWebStr,
					'<button class="on" type="submit" name="P',itoa(nCurWebPage),'BTN',itoa(nBtnNumber),'PUSH" ',//remove > from end of this line if mouseovers used 
					(*'onmouseover="this.className=''hover''"*)'onmouseout="this.className=''on''" ',
					'onclick="this.className=''click''">',sWEB_PAGE[nCurWebPage].BTN[nBtnNumber].Name,'</button>'" ; 
				   }
			      }
			 else //BUTTON = OFF OR HAS NO VALUE
			      {
			      cLocalWebStr = "cLocalWebStr, 
				   '<button class="off" type="submit" name="P',itoa(nCurWebPage),'BTN',itoa(nBtnNumber),'PUSH" ',//remove > from end of this line if mouseovers used 
				   (*'onmouseover="this.className=''hover''"*)'onmouseout="this.className=''off''" ',
				   'onclick="this.className=''click''">',sWEB_PAGE[nCurWebPage].BTN[nBtnNumber].Name,'</button>'" ; 
			      }
			 }
		    ACTIVE(sWEB_PAGE[nCurWebPage].BTN[nBtnNumber].Show == BUTTON_MENU):
			 {
			 cLocalWebStr = "cLocalWebStr, 
				   '<button class="menu" type="submit" name="P',itoa(nCurWebPage),'BTN',itoa(nBtnNumber),'PUSH" ',//remove > from end of this line if mouseovers used 
				   (*'onmouseover="this.className=''hover''"*)'onmouseout="this.className=''menu''" ',
				   'onclick="this.className=''mclick''">'" ;
			 if(sWEB_PAGE[nCurWebPage].Pg_NAME == sWEB_PAGE[nCurWebPage].BTN[nBtnNumber].Name)
			      {
			      cLocalWebStr = "cLocalWebStr,'Refresh</button>'" ;
			      }
			 else
			      {
			      cLocalWebStr = "cLocalWebStr,sWEB_PAGE[nCurWebPage].BTN[nBtnNumber].Name,'</button>'" ;
			      }					
			 }
		    }
	       cLocalWebStr = "cLocalWebStr,'</td>',$0A" ;
	       }
	  cLocalWebStr = "cLocalWebStr,'</form>',$0A,
			      '</tr>',$0A" ;
			      
	  fnConcatString(iWebStrMessage,GET_BUFFER_STRING(cLocalWebStr,LENGTH_STRING(cLocalWebStr))) ;
	  
     	  }
     cLocalWebStr = "cLocalWebStr,
		    '</table>',$0A,$0A,
	       '</div>',$0A,
	  '</body>',$0A,
     '</html>'" ;
     
     fnConcatString(iWebStrMessage,GET_BUFFER_STRING(cLocalWebStr,LENGTH_STRING(cLocalWebStr))) ;
     
     RETURN ;
     }

DEFINE_FUNCTION fnWebPageOut(INTEGER nFnc)
     
     {
     STACK_VAR INTEGER nLoop ;
     STACK_VAR INTEGER nLoop2 ;
     STACK_VAR CHAR cWebHead[1000] ;    
     STACK_VAR CHAR cWebMessage[MAX_LEN_STR_MSG] ;
     
     //fnWebDeBug("'Mobile Web Broswer is = Sending Webpage Out.', ITOA(nFnc),'.  line-<',ITOA(__LINE__),'>'",1) ;
     SWITCH(nFnc)
	  {
	  // First Screen Enter Password
	  CASE PAGE_LOGIN:
	       {
	       fnWEBPage_Login(cWebMessage) ;
	       }
	  // First Screen Enter Password
	  CASE PAGE_RETRY:
	       {
	       fnWEBPage_Retry(cWebMessage) ;
	       }
	  // Form Page for Control
	  CASE PAGE_BUTTONS:
	       {
	       nRXNewValue = 0 ;
	       fnWEBPage_Buttons(cWebMessage) ;
	       }
	  // Return Images for Get commands
	  CASE PAGE_SEND_FILES:
	       {
	       cWebMessage = '' ; //"cReadFileBuf" ;
	       }
	  CASE PAGE_204_NOCONTENT://No content "204" 
	       {
	       //no content
	       }
	  CASE PAGE_404_FILENOFIND://File not Found 404 
	       {
	       fnWEBPage_404(cWebMessage) ;
	       }
	  CASE PAGE_SETCOOKIE: 
	       {
	       fnWEBPage_Buttons(cWebMessage) ; //fnWEBPage_LoginRedirect
	       }
	  CASE PAGE_QUERY_RESPONSE: 
	       {
	       if(nRXNewValue)
		    {
		    cWebMessage = itoa(nRXNewValue) ;
		    }
	       else
		    {
		    cWebMessage = '' ;
		    }
	       }
	  }
     fnUpdateDATE_TIME() ;
     SELECT //GENERATE POST HEADER
	  {
	  ACTIVE(nFnc && nFnc < 4): // normal traffic
	       {
	       // Generate the Post Header
	       cWebHead = fnHEADER_200OK(length_string(cWebMessage)) ;
	       // Send web-page to browser
	       }
	  ACTIVE(nFnc == PAGE_SEND_FILES): //files  //body commented out
	       {
	       (*
	       cWebHead = fnHEADER_200OK_Files(nReadFResult) ;
	       // Send web-page to browser
	       SEND_STRING dvWeb, "cWebHead" ;
	       SEND_STRING dvWeb, "cReadFileBuf, $0D,$0A" ;
	       WAIT 200 'WAIT_FOR_TRAFFIC'
		    {
		    fnCloseWebServer() ;
		    }
	       *)
	       }
	  ACTIVE(nFnc == PAGE_202_ACCEPTED): //HTTP 204 Accepted
	       {
	       cWebHead = fnHEADER_202() ;
	       }
	  ACTIVE(nFnc == PAGE_204_NOCONTENT): //HTTP 204 No Content
	       {
	       cWebHead = fnHEADER_204() ;
	       }
	  ACTIVE(nFnc == PAGE_304_NOTMODIFIED): //HTTP 304 file not modified
	       {
	       cWebHead = fnHEADER_304() ;
	       }
	  ACTIVE(nFnc == PAGE_404_FILENOFIND): //HTTP 404 file not found
	       {
	       cWebHead = fnHEADER_404() ;
	       }
	  ACTIVE(nFnc == PAGE_SETCOOKIE): //HTTP 200OK W/ SET COOKIE
	       {
	       cWebHead = fnHEADER_200OK_SetCookie(length_string(cWebMessage)) ;
	       }
	  ACTIVE(nFnc == PAGE_QUERY_RESPONSE): //HTTP 200OK and MESSAGE BODY
	       {
	       cWebHead = fnHEADER_200OK(length_string(cWebMessage)) ;
	       }
	  }
	  
     //cWeb_TestTXBuff = cWebMessage ;//<---------------------------------------------------------TESTING----XXXXXX
     
     if(LENGTH_STRING(cWebHead))
	  {
	  WHILE(LENGTH_STRING(cWebHead) > MAX_MTU)
	       {
	       SEND_STRING dvWeb, "GET_BUFFER_STRING(cWebHead,MAX_MTU)" ; 
	       }
	  if(LENGTH_STRING(cWebHead))
	       {
	       SEND_STRING dvWeb, "cWebHead" ;
	       }
	  /////////////////////////////////////////////////
	  if(LENGTH_STRING(cWebMessage))//no body w/o head
	       {
	       WHILE(LENGTH_STRING(cWebMessage) > MAX_MTU)
		    {
		    SEND_STRING dvWeb, "GET_BUFFER_STRING(cWebMessage,MAX_MTU)" ; 
		    }
	       if(LENGTH_STRING(cWebMessage))
		    {
		    SEND_STRING dvWeb, "cWebMessage" ;
		    }
	       }
	  }
   
     fnCloseWebServer() ;
     nWaitingToSend = 0 ;
     
     RETURN ;
     }

DEFINE_FUNCTION fnConcatString(CHAR sConcatFinal[],CHAR sConcatNew[])  
     
     {
     STACK_VAR CHAR sPieces[3];
     STACK_VAR CHAR sBuffer[MAX_LEN_STR_MSG];
     STACK_VAR LONG lPos, lOldPos;
     
     lpos = 1;
     
     VARIABLE_TO_STRING(sConcatFinal,sBuffer,lPos);
     sPieces[1] = sBuffer[lPos-3];
     sPieces[2] = sBuffer[lPos-2];
     sPieces[3] = sBuffer[lPos-1];
     
     lOldPos = lpos;
     lpos = lpos - 3;
     
     VARIABLE_TO_STRING(sConcatNew,sBuffer,lPos);
     
     sBuffer[lOldPos-3] = sPieces[1];
     sBuffer[lOldPos-2] = sPieces[2];
     sBuffer[lOldPos-1] = sPieces[3];
     
     GET_BUFFER_STRING(sBuffer,3) ;

     sConcatFinal = sBuffer; 
     }

DEFINE_FUNCTION INTEGER fnFindUserAgent(CHAR iStr[]) //needs changes mades for browsers!!!!!!!
     
     {
     STACK_VAR INTEGER nUserAgent ;
     
     #WARN 'Change fnFindUserAgent() to work with correct browsers. Around line 3212 of AMX_Mobile_comm!' ;
     
     SELECT
	  { 
	  //AppleWebKit for safari     //user agent MobileSafari on get icon
	  //Windows; for windows PC most likely xp or vista  with AppleWebKit for Safari on windows
	  //User-Agent: Mozilla/5.0 (iPOD; U; CPU iPHONE OS 2_2_1 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1
	  ACTIVE(find_string(iStr,'iPod',1)): 
	       {
	       nUserAgent = iPHONE ;
	       //fnWebDeBug("'Broswer is = iPOD.   line-<',ITOA(__LINE__),'>'",1) ;
	       }
	  ACTIVE(find_string(iStr,'iPhone',1)): //just in case it changes some day
	       {
	       nUserAgent = iPHONE ;
	       //fnWebDeBug("'Broswer is = iPhone.   line-<',ITOA(__LINE__),'>'",1) ;
	       }
	  ACTIVE(find_string(iStr,'Windows',1) && find_string(iStr,'AppleWebKit',1)): //
	       {
	       nUserAgent = WINSAFARI ;
	       //fnWebDeBug("'Broswer = Safari on Windows.   line-<',ITOA(__LINE__),'>'",1) ;
	       }
	  ACTIVE(find_string(iStr,'BlackBerry',1)): 
	       {
	       nUserAgent = BLACKBERRY ;
	       //fnWebDeBug("'Broswer = Blackberry.   line-<',ITOA(__LINE__),'>'",1) ;
	       }
	  ACTIVE(1): 
	       {
	       nUserAgent = WINGENERIC ;
	       //fnWebDeBug("'Broswer = WinGeneric. str: ',iStr,'.   line-<',ITOA(__LINE__),'>'",1) ;
	       }
	  }
     
     RETURN nUserAgent ;
     }

DEFINE_FUNCTION SINTEGER fnWebPageParseHeader(CHAR iHTML_Head[],CHAR iSourceIP[])
     
     {
     STACK_VAR CHAR cStrDEBUG[5000] ; 
     STACK_VAR LONG nFBS ;
     STACK_VAR LONG nFBS_2 ;
     // CHANGE THESE TO STACK_VAR OR LEAVE AS LOCAL FOR TESTING
     // IF CHANGED TO STACK_VAR'S COMMENT OUT THE ESLE STATEMENTS BELOW WHICH CLEAR THEM
     LOCAL_VAR SINTEGER nLengthContent ;
     LOCAL_VAR CHAR cHTTPVersion[10] ;
     LOCAL_VAR CHAR cRequestType[10] ;
     LOCAL_VAR CHAR cFileName[48] ;
     LOCAL_VAR CHAR cReferer[255] ;
     LOCAL_VAR CHAR cHost[255] ;
     LOCAL_VAR CHAR cConnection[255] ;
     LOCAL_VAR CHAR cETag[255] ;
     LOCAL_VAR CHAR cCookie[255] ;
     LOCAL_VAR CHAR cCookieType[255] ;
     LOCAL_VAR CHAR cContentType[255] ;
     LOCAL_VAR CHAR cCacheControl[255] ;
    
     //fnWebDeBug("13",1) ;
     //fnWebDeBug('(***********************************************************)',1) ;
     //fnWebDeBug('Web Header; ',1) ; 	
     
     if(nWebDeBug) // Debug, send all the incoming text to telnet and 
	  {
	  cStrDEBUG = iHTML_Head ;
	  WHILE(LENGTH_STRING(cStrDEBUG))
	       {
	       if(find_string(cStrDEBUG,"CRLF",1))
		    {
		    fnWebDeBug("REMOVE_STRING(cStrDEBUG,"CRLF", 1),'.   line-<',ITOA(__LINE__),'>'",1) ;
		    }
	       else
		    {
		    fnWebDeBug("GET_BUFFER_STRING(cStrDEBUG,LENGTH_STRING(cStrDEBUG)),'.   line-<',ITOA(__LINE__),'>'",1) ;
		    }
	       }
	  }
	  
     //fnWebDeBug("'< END OF HEADER >    line-<',ITOA(__LINE__),'>'",1) ;
         
     nFBS = find_string(iHTML_Head,"' /'",1) ;
     if(nFBS)
	  {
	  cRequestType = GET_BUFFER_STRING(iHTML_Head,nFBS -1) ;
	  REMOVE_STRING(iHTML_Head,"' /'",1) ;
	  
	  nFBS = find_string(iHTML_Head,"' HTTP/'",1) ;
	  if(nFBS)
	       {
	       cFileName = GET_BUFFER_STRING(iHTML_Head,nFBS -1) ;
	       nFBS = find_string(iHTML_Head,"CRLF",1) ;
	       if(nFBS)
		    {
		    cHTTPVersion = GET_BUFFER_STRING(iHTML_Head,nFBS -1) ;
		    if(cHTTPVersion[1] == "' '")
			 {
			 GET_BUFFER_CHAR(cHTTPVersion) ;
			 }
		    ////////////////////////////////////////////////////////////////////////////////////////////////////
		    ///  FROM HERE ON WE LEAVE THE STRING INTACT AND JUST COPY WHAT WE'RE LOOKING FOR SINCE THE ORDER //
		    ///  OF THE ITEMS WE'RE LOOKING FOR MAY CHANGE DEPENDING ON BROWSER CONNECTED !!!!                //
		    ////////////////////////////////////////////////////////////////////////////////////////////////////
		    nFBS = find_string(iHTML_Head,"'User-Agent: '",1) ;
		    if(nFBS)
			 {
			 nFBS_2 = find_string(iHTML_Head,"CRLF",nFBS + 12) ;
			 nWebAgent = fnFindUserAgent(MID_STRING(iHTML_Head,nFBS + 12,nFBS_2 - (nFBS + 12))) ;//add one
			 }
		    else//leave in in case we set above variable to "LOCAL_VAR" for testing.
			 {
			 nWebAgent = WINGENERIC ;//use as default
			 }
		    nFBS = find_string(iHTML_Head,"'Referer: '",1) ;
		    if(nFBS)
			 {
			 nFBS_2 = find_string(iHTML_Head,"CRLF",nFBS + 9) ;
			 cReferer = MID_STRING(iHTML_Head,nFBS + 9,nFBS_2 - (nFBS + 9)) ;//add one
			 }
		    else//leave in in case we set above variable to "LOCAL_VAR" for testing.
			 {
			 cReferer = '' ;
			 }
		    nFBS = find_string(iHTML_Head,"'Content-Type: '",1) ;
		    if(nFBS)
			 {
			 nFBS_2 = find_string(iHTML_Head,"CRLF",nFBS + 14) ;
			 cContentType = MID_STRING(iHTML_Head,nFBS + 14,nFBS_2 - (nFBS + 14)) ;//add one
			 }
		    else//leave in in case we set above variable to "LOCAL_VAR" for testing.
			 {
			 cContentType = '' ;
			 }
		    nFBS = find_string(iHTML_Head,"'Connection: '",1) ;
		    if(nFBS)
			 {
			 nFBS_2 = find_string(iHTML_Head,"CRLF",nFBS + 12) ;
			 cConnection = MID_STRING(iHTML_Head,nFBS + 12,nFBS_2 - (nFBS + 12)) ;//add one
			 }
		    else//leave in in case we set above variable to "LOCAL_VAR" for testing.
			 {
			 cConnection = '' ;
			 }
		    nFBS = find_string(iHTML_Head,"'Cache-Control: '",1) ;
		    if(nFBS)
			 {
			 nFBS_2 = find_string(iHTML_Head,"CRLF",nFBS + 15) ;
			 cCacheControl = MID_STRING(iHTML_Head,nFBS + 15,nFBS_2 - (nFBS + 15)) ;//add one
			 }
		    else//leave in in case we set above variable to "LOCAL_VAR" for testing.
			 {
			 cCacheControl = '' ;
			 }
		    nFBS = find_string(iHTML_Head,"'Content-Length: '",1) ;
		    if(nFBS)
			 {
			 nFBS_2 = find_string(iHTML_Head,"$0D",nFBS + 16) ;
			 nLengthContent = ATOI(MID_STRING(iHTML_Head,nFBS + 16,nFBS_2 - (nFBS + 16))) ;//add one
			 }
		    else//leave in in case we set above variable to "LOCAL_VAR" for testing.
			 {
			 nLengthContent = 0 ;
			 }
		    nFBS = find_string(iHTML_Head,"'Cookie: '",1) ;
		    if(nFBS)
			 {
			 nFBS_2 = find_string(iHTML_Head,"CRLF",nFBS + 8) ;
			 cCookie = MID_STRING(iHTML_Head,nFBS + 8,nFBS_2 - (nFBS + 8)) ;//add one
			 cCookieType = REMOVE_STRING(cCookie,"'='",1) ;
			 cRXCookie = cCookie ;
			 }
		    else//leave in in case we set above variable to "LOCAL_VAR" for testing.
			 {
			 cCookie = 0 ;
			 cRXCookie = 0 ;
			 }
		    }
	       else//leave in in case we set above variable to "LOCAL_VAR" for testing.
		    {
		    cHTTPVersion = '' ;
		    }
	       }
	  else//leave in in case we set above variable to "LOCAL_VAR" for testing.
	       {
	       cFileName = '' ;
	       }
	  }
     else//leave in in case we set above variable to "LOCAL_VAR" for testing.
	  {
	  cRequestType = '' ;
	  }
	  
     iHTML_Head = '' ;
     
     //fnWebDeBug("''",0) ;
     //fnWebDeBug('(***********************************************************)',0) ;
     //fnWebDeBug("''",0) ;
     
     SELECT
	  {
	  ACTIVE(cRequestType == 'GET'):
	       {
	       SELECT
		    {
		    ACTIVE(cFileName == 'checkvalues.txt'):  
			 {
			 if(iSourceIP != cLogin_IPAddress || cCookie != AMX_MOBILE_COOKIE)
			      {
			      fnWebPageOut(PAGE_LOGIN) ;
			 
			      RETURN -1 ;
			      }
			 if(nRXNewValue && !nWaitingToSend && nAutoRefresh)
			      {
			      fnWebPageOut(PAGE_QUERY_RESPONSE) ;
				   
			      RETURN -1 ;
			      }
			 if(nWaitingToSend)
			      { 
			      
			      RETURN -1 ;
			      }
			 
			 RETURN 0 ;
			 }
		    ACTIVE(cFileName == 'buttons.html'):  
			 {
			 if(iSourceIP != cLogin_IPAddress || cCookie != AMX_MOBILE_COOKIE)
			      {
			      fnWebPageOut(PAGE_LOGIN) ;
			 
			      RETURN -1 ;
			      }
			 if(!nWaitingToSend)
			      {
			      fnWebPageOut(PAGE_BUTTONS) ;
				   
			      RETURN -1 ;
			      }
			 else
			      {
			      
			      RETURN -1 ;
			      }
			 }
		    ACTIVE(cFileName == ''):
			 {
			 if(iSourceIP != cLogin_IPAddress || cCookie != AMX_MOBILE_COOKIE)
			      {
			      fnWebPageOut(PAGE_LOGIN) ;
			      
			      RETURN -1 ;
			      }
			 fnWebPageOut(PAGE_BUTTONS) ;
			      
			 RETURN -1 ;
			 }
		    ACTIVE(length_string(cFileName)):
			 {
			 fnWebPageOut(PAGE_404_FILENOFIND) ; //PAGE_304_NOTMODIFIED //PAGE_202_ACCEPTED
			 
			 RETURN -1 ;
			 }
		    }
	       }
	  ACTIVE(cRequestType == 'POST'): 
	       {
	       SELECT
		    {//keep at the top
		    ACTIVE(find_string(cWeb_RXBuffer,"'password='",1)):
			 {
			 
			 RETURN nLengthContent ;
			 }
		    ACTIVE(cFileName == 'buttons.html'):
			 {
			 if(iSourceIP != cLogin_IPAddress || cCookie != AMX_MOBILE_COOKIE)
			      {
			      fnWebPageOut(PAGE_LOGIN) ;
			      
			      RETURN -1 ;
			      }
			 
			 RETURN nLengthContent ;
			 }
		    ACTIVE(cFileName == ''):
			 {
			 if(iSourceIP != cLogin_IPAddress || cCookie != AMX_MOBILE_COOKIE)
			      {
			      fnWebPageOut(PAGE_LOGIN) ;
			      
			      RETURN -1 ;
			      }
			 
			 RETURN nLengthContent ;
			 }
		    ACTIVE(length_string(cFileName))://something in there?
			 {
			 fnWebPageOut(PAGE_LOGIN) ;
			 
			 RETURN -1 ;
			 }
		    }
	       }
	  }
         
     RETURN 0 ;
     }
    
DEFINE_FUNCTION SINTEGER fnWebPageParseContent(CHAR iRcvdStr[],CHAR iSourceIP[])
     
     {
     //fnWebDeBug("''",0) ;
     //fnWebDeBug("'(***********************************************************)'",0) ;
     //fnWebDeBug('Parsing Content; ',0) ; 
     //fnWebDeBug("'Content = ', iRcvdStr",0) ; 
     // It is the password
     SELECT
	  {
	  // It's a Good Command, and it is logged in
	  ACTIVE((find_string(iRcvdStr,'PUSH',1)) && (iSourceIP == cLogin_IPAddress)):
	       {//P=1:BTN=1:PUSH
	       STACK_VAR INTEGER nPage ;
	       STACK_VAR INTEGER nBtn ;
	       STACK_VAR INTEGER nFBS ;
	       STACK_VAR CHAR cStrTmp[20] ;
	       
	       cStrTmp = REMOVE_STRING(iRcvdStr,'PUSH',1) ;
	       nPage = atoi(REMOVE_STRING(cStrTmp,'BTN',1)) ;
	       if(nPage)
		    {
		    nBtn = atoi(REMOVE_STRING(cStrTmp,'PUSH',1)) ;
		    if(nBtn)
			 {
			 STACK_VAR INTEGER nDo_PushBtn ;
			 
			 //fnWebDeBug("'Rcv''d Btn Press:  Page ',itoa(nPage),' * Btn ',itoa(nBtn),'.   >-Line-<',ITOA(__LINE__),'>'",1) ;
			 nDo_PushBtn = (((nPage - 1) * MAX_NUM_BTNs_PAGE) + nBtn) ;
			 DO_PUSH(vdvWeb,nDo_PushBtn) ;
			 //fnWebDeBug("'Do_Push for BUTTON ',itoa(nDo_PushBtn),'.   >-Line-<',ITOA(__LINE__),'>'",1) ;
			 nWaitingToSend = 1 ;
			 WAIT WEB_PAGE_FB_REFRESH 'WAITING_TO_SEND'
			      {
			      fnWebPageOut(PAGE_BUTTONS) ;
			      }
			      
			 RETURN -1 ;
			 }
		    else
			 {
			 //fnWebDeBug("'RCV''D BTN PUSH ERROR!  Btn = 0. Had Page# but No Show Btn?   >-Line-<',ITOA(__LINE__),'>'",1) ;
			 
			 RETURN 0 ;
			 }
		    }
	       else
		    {
		    //fnWebDeBug("'RCV''D BTN PUSH ERROR!  Page = 0. Probably a No Show Btn?   >-Line-<',ITOA(__LINE__),'>'",1) ;
		    
		    RETURN 0 ;
		    }
	       }
	  ACTIVE(find_string(iRcvdStr, 'password=', 1)):
	       {
	       REMOVE_STRING(iRcvdStr, 'password=', 1) ;
	     
	       if(iRcvdStr == cPassword)
		    {
		    //fnWebDeBug("'Password is Correct, sending Control Webpage.   >-Line-<',ITOA(__LINE__),'>'",1) ;
		    // Save the IP address, to verify incoming HTTP requests
		    cLogin_IPAddress = iSourceIP ;
		    // Send the page
		    fnWebPageOut(PAGE_SETCOOKIE) ;
		    }
	       else
		    {
		    //fnWebDeBug("'Password is Wrong!   >-Line-<',ITOA(__LINE__),'>'",1) ;
		    // Send the page
		    fnWebPageOut(PAGE_RETRY) ;
		    }
		    
	       RETURN -1 ;
	       }
	  ACTIVE(iSourceIP != cLogin_IPAddress):
	       {
	       fnWebPageOut(PAGE_LOGIN) ;
	       //fnWebDeBug("'RESENT LOGIN PAGE!   >-Line-<',ITOA(__LINE__),'>'",1) ;
	       
	       RETURN -1 ;
	       }
	  ACTIVE(1):// It is a Bad Command or unkown request like ( GET /favicon.ico  )
	       {
	       RETURN 0 ;
	       }
     	  }
     //fnWebDeBug("'(***********************************************************)'",0) ;
     //fnWebDeBug('',0) ;
     }
     
DEFINE_FUNCTION fnParseWEB_RXBuffer(CHAR iSourceIP[])

     {
     STACK_VAR CHAR cHTML_Head[30000] ;

     // Look for a complete header command
     nWebServerState = SERVER_RX_DATA ;
     //testing//cWeb_TestRXBuff = "cWeb_TestRXBuff,cWeb_RXBuffer" ;
     if(find_string(cWeb_RXBuffer, "CRLF,CRLF", 1))
	  {
	  //fnWebDeBug("'Rcv''d HEADER CRLF, CRLF!  >-Line-<',ITOA(__LINE__),'>'",1) ;
	  cHTML_Head = REMOVE_STRING(cWeb_RXBuffer, "$0D,$0A,$0D,$0A", 1) ;
	  nContentLength = fnWebPageParseHeader (cHTML_Head,iSourceIP) ;
   
	  // Wait only 2.5 seconds for the rest of the data,
	  // if it doesn't come that quickly, then it may have
	  // been compromised, so don't parse it.
	  //CANCEL_WAIT 'WAIT_FOR_TRAFFIC' ;
	  CANCEL_WAIT 'WEB_TIMEOUT' ;
	  WAIT 25 'WEB_TIMEOUT'
	       {
	       cWeb_RXBuffer = '' ;
	       nContentLength = 0 ;
	       fnCloseWebServer() ;
	       }
	  
	  if(iSourceIP == cLogin_IPAddress && cRXCookie == AMX_MOBILE_COOKIE)
	       {
	       CANCEL_WAIT 'DELETE_STORED_IP' ;
	       SELECT
		    {
		    ACTIVE(nAutoRefreshTime < 15000):
			 {
			 WAIT DELETE_STORED_IP_20 'DELETE_STORED_IP' 
			      {
			      cLogin_IPAddress = '' ;
			      }
			 }
		    ACTIVE(nAutoRefreshTime < 35000):
			 {
			 WAIT DELETE_STORED_IP_40 'DELETE_STORED_IP' 
			      {
			      cLogin_IPAddress = '' ;
			      }
			 }
		    ACTIVE(nAutoRefreshTime < 55000):
			 {
			 WAIT DELETE_STORED_IP_60 'DELETE_STORED_IP' 
			      {
			      cLogin_IPAddress = '' ;
			      }
			 }
		    ACTIVE(1):
			 {
			 WAIT DELETE_STORED_IP_120 'DELETE_STORED_IP' 
			      {
			      cLogin_IPAddress = '' ;
			      }
			 }
		    }
	       }
       
	  // If there is Content Length, check to see if it is all the content, 
	  // if not, then there could be more data coming.  Also, if it is the
	  // initial webpage request, then content will be 0, so that no parsing 
	  // is done.
	  if(nContentLength)
	       {
	       if(LENGTH_STRING(cWeb_RXBuffer) == nContentLength)
		    {
		    fnWebPageParseContent(cWeb_RXBuffer, iSourceIP) ;
		    }
	       }
	  else if(nContentLength == 0)
	       {
	       fnCloseWebServer() ;
	       //fnWebDeBug("'No Content Length.  Close Sever!  >-Line-<',ITOA(__LINE__),'>'",1) ;
	       }
	  else//-1  means a page is being sent let that code close server after sending. 
	       {
	       // do nothing      fnCloseWebServer() ;
	       //fnWebDeBug("'Do Nothing! Page Sent?  >-Line-<',ITOA(__LINE__),'>'",1) ;
	       }
	  }// In Case the Content was split up
     else if(nContentLength && nContentLength == LENGTH_STRING(cWeb_RXBuffer))
	  {
	  fnWebPageParseContent(cWeb_RXBuffer, iSourceIP) ;
	  }
    	  
     RETURN ;
     }

DEFINE_START    //SET VIRTUAL LEVEL COUNTS & LENGTH OF STRUCTURE

     {// initialize with max values and then let config modify!
     WAIT 1800 'SET_DEFAULT_VIRTUAL_LEVELS' //give the config string a chance to work.
	  {
	  if(!nNumConfigBtns)//in case this is already set via recvd command or just a reboot value is retained.
	       {
	       nNumConfigBtns = MAX_NUM_BUTTONs ; //in case a config string isn't received 
	       SET_VIRTUAL_LEVEL_COUNT(vdvWeb,nNumConfigBtns) ;
	       REBUILD_EVENT() ;
	       //fnWebDeBug("'DEFINE_START: REBUILD LEVEL_EVENT for ',itoa(nNumConfigBtns),' levels.  >-Line-<',ITOA(__LINE__),'>'",1) ;
	       }
	  }
     }
    
DEFINE_START    //CREATE BUFFER AND INITIALIZE

CREATE_BUFFER dvWeb,cWeb_RXBuffer ;
//CREATE_BUFFER vdvTX_Buff,cWebMessage ;

cWebURLPathReFresh = 'http://192.168.1.60/checkvalues.txt' ; 
cWebURLPathHome = 'http://192.168.1.60/buttons.html' ; 
nFileInsertIndx = 1 ;
nFileReadIndx = 1 ;

// Open the Server Spcket 
nConnectAttempts = 0 ;
nWebServerState = SERVER_DISABLED ; //prevent define_program from opening server right away
WAIT 1800
     {
     nWebServerState = SERVER_STOPPED ;
     fnOpenWebServer() ;
     }

DEFINE_EVENT    //VIRTUAL COMMAND EVENTS

DATA_EVENT[vdvWeb]
     
     {
     COMMAND:
	  {
	  STACK_VAR CHAR strMessage[100], strTemp[25], strTrash[3]
	  STACK_VAR INTEGER nButton ;
	  STACK_VAR INTEGER nSet ;
	  STACK_VAR INTEGER nFBS ;
	  
	  strMessage = DATA.TEXT ;
	
	  SELECT
	       {
	       ACTIVE(find_string(strMessage,'KEEPFRESH=',1)):
		    {
		    REMOVE_STRING(strMessage,'KEEPFRESH=',1) ;
		    nAutoRefresh = atoi(strMessage) ;
		    }
	       ACTIVE(find_string(strMessage,'TIMEFRESH=',1)):
		    {
		    REMOVE_STRING(strMessage,'TIMEFRESH=',1) ;
		    nAutoRefreshTime = atoi(strMessage) ;
		    if(nAutoRefreshTime < MIN_REFRESH_TIME)
			 {
			 nAutoRefreshTime = MIN_REFRESH_TIME ;
			 }
		    else if(nAutoRefreshTime > MAX_REFRESH_TIME)
			 {
			 nAutoRefreshTime = MAX_REFRESH_TIME ;
			 }
		    }
	       ACTIVE(find_string(strMessage,'NEWPAGE=',1)):
		    {//EX.   'NEWPAGE=2'
		    STACK_VAR INTEGER nNewPage ;
		    
		    REMOVE_STRING(strMessage,'NEWPAGE=',1) ;
		    nNewPage = atoi("strMessage") ;
		    if(nNewPage)
			 {
			 nCurWebPage = nNewPage ;
			 if(nWaitingToSend)
			      {
			      CANCEL_WAIT 'WAITING_TO_SEND' ;//SPEED UP SINCE WE'RE JUST CHANGING PAGES NOT WAITING FOR FEEDBACK
			      fnWebPageOut(PAGE_BUTTONS) ;
			      nWaitingToSend = 0 ;
			      }
			 }
		    }
	       ACTIVE(find_string(strMessage,'NUMPAGES=',1)):
		    {//EX.   'NUMPAGES=1'
		    STACK_VAR INTEGER nNumPages ;
		    
		    REMOVE_STRING(strMessage,'NUMPAGES=',1) ;
		    nNumPages = atoi("strMessage") ;
		    if(nNumPages)
			 {
			 CANCEL_WAIT 'SET_DEFAULT_VIRTUAL_LEVELS' ;
			 //fnWebDeBug("'CONFIG RCV''D: PAGES= ',itoa(nNumPages),'.  >-Line-<',ITOA(__LINE__),'>'",1) ;
			 nNumConfigBtns = (MAX_NUM_BTNs_PAGE * nNumPages) ;
			 if(nNumConfigBtns)// just to isolate rebuild event
			      {
			      SET_VIRTUAL_LEVEL_COUNT(vdvWeb,nNumConfigBtns) ;
			      REBUILD_EVENT() ;
			      //fnWebDeBug("'CONFIG RCV''D: REBUILD LEVEL_EVENT for ',itoa(nNumConfigBtns),' Levels.  >-Line-<',ITOA(__LINE__),'>'",1) ; 
			      }
			 SET_LENGTH_ARRAY(sWEB_PAGE,nNumPages) ;
			 //fnWebDeBug("'CONFIG RCV''D: SET STRUCTURE LENGTH for ',itoa(nNumPages),' Pages.  >-Line-<',ITOA(__LINE__),'>'",1) ;
			 }
		    else
			 {
			 //fnWebDeBug("'Rcv''d CONFIG Str ERROR! NO PAGES?  >-Line-<',ITOA(__LINE__),'>'",1) ;
			 }
		    }
	       ACTIVE(find_string(strMessage, 'PASSWORD=', 1)):
		    {//EX.   'PASSWORD=YOURPASSWORD'
		    strTrash = REMOVE_STRING(strMessage, 'PASSWORD=', 1)
		    cPassword = strMessage
		    }
	       ACTIVE(find_string(strMessage, 'TITLE=', 1)):
		    {
		    strTrash = REMOVE_STRING(strMessage, 'TITLE=', 1)
		    cTitle = strMessage
		    }
	       ACTIVE(find_string(strMessage, 'DEBUG=', 1)):
		    {
		    strTrash = REMOVE_STRING(strMessage, 'DEBUG=', 1)
		    nWebDebug = ATOI(strMessage)
		
		    if(nWebDebug)
			 {
			 SEND_STRING 0,"13"
			 SEND_STRING 0,"'(***********************************************************)'"
			 SEND_STRING 0,"'             MOBILE WEB DEBUG TURNED ON                   '" 	
			 SEND_STRING 0,"'(***********************************************************)'"
			 SEND_STRING 0,"13"
			 }
		    }
	       ACTIVE(find_string(strMessage,'PAGE=', 1)):
		    {//"'PAGE=1,',	'LABEL=LIGHTING'"
		    STACK_VAR INTEGER nPage ;
		    
		    REMOVE_STRING(strMessage,'PAGE=',1) ;
		    nPage = atoi(REMOVE_STRING(strMessage,'LABEL=',1)) ;
		    if(nPage)
			 {
			 sWEB_PAGE[nPage].Pg_NAME = strMessage ;
			 }
		    }
	       ACTIVE(find_string(strMessage,'BUTTON=', 1)):
		    {//"'BUTTON=1,',	'NAME=FRONT COACH,',	'SHOW=1'" 
		    STACK_VAR INTEGER nRcvdBtn ;
		    
		    REMOVE_STRING(strMessage,'BUTTON=',1)
		    nRcvdBtn = atoi(REMOVE_STRING(strMessage,'NAME=',1)) ;
		    if(nRcvdBtn)
			 {
			 nFBS = find_string(strMessage,"';S'",1)
			 if(nFBS)
			      {
			      STACK_VAR INTEGER nPage ;
			      STACK_VAR INTEGER nBtn ;
			      
			      nPage = ((nRcvdBtn - 1) / 24) ;
			      nBtn  = (nRcvdBtn - (nPage * 24)) ;
			      
			      sWEB_PAGE[nPage + 1].BTN[nBtn].Name = GET_BUFFER_STRING(strMessage,nFBS -1) ;
			      REMOVE_STRING(strMessage,'W=',1) ;
			      sWEB_PAGE[nPage + 1].BTN[nBtn].Show = atoi("strMessage") ;
			      
			      //fnWebDeBug("'CMD Rcv''d BUTTON=',itoa(nRcvdBtn),' for Page-',itoa(nPage  + 1),' * Btn-',itoa(nBtn),'.  >-Line-<',ITOA(__LINE__),'>'",1) ;
			      }
			 }
		    }
	       }
	  }
     }
     
DEFINE_EVENT    //WEB SERVER EVENTS

DATA_EVENT[dvWeb]
     
     {
     ONLINE:
	  {
	  if(nWebDebug)
	       {
	       SEND_STRING 0,"13"
	       SEND_STRING 0,"'(***********************************************************)'"
	       SEND_STRING 0,"'                    Mobile Web Online !!!                    '" 	
	       SEND_STRING 0,"'(***********************************************************)'"
	       SEND_STRING 0,"13"
	       }
	  CANCEL_WAIT 'WEB_CONNECT_TIMEOUT' ;
	  CANCEL_WAIT 'ERROR_DELAY_RESTART' ;
	  nWebServerState = SERVER_CLIENT_CONNECTED ;
	  nConnectAttempts = 0 ;
	  }
     OFFLINE:
	  {
	  //CANCEL_WAIT 'ERROR_DELAY_RESTART' ;
	  CANCEL_WAIT 'WAITING_TO_SEND' ;
	  nWaitingToSend = 0 ;
	  nContentLength = 0 ;
	  cWeb_RXBuffer = '' ;
	  if(nWebServerState != SERVER_DISABLED)
	       {
	       nWebServerState = SERVER_STOPPED ;
	       fnOpenWebServer() ; //possibly remove and just let define_program handle.  Might re-open faster or more time consistant here.
	       }
	  }
     ONERROR:
	  {
	  //CANCEL_WAIT 'ERROR_DELAY_RESTART' ; //wait created in fnOpenWebServer()but pass delay responsibility to fnGET_IPServer_Error() 
	  SEND_STRING 0,"'WEB MODULE: ',fnGET_IPServer_Error(TYPE_CAST(DATA.NUMBER)),' >-Line-<',ITOA(__LINE__),'>',CRLF" ;
	  }
     STRING:
	  {
	  fnParseWEB_RXBuffer(DATA.SOURCEIP) ;
	  }
     }
     
DEFINE_EVENT    //LEVEL EVENT
 
LEVEL_EVENT [vdvWeb,0]         

     {
     //fnWebDeBug("'Rcv''d LEVEL_0-',itoa(LEVEL.INPUT.LEVEL),'.  >-Line-<',ITOA(__LINE__),'>'",1) ;
     if(LEVEL.INPUT.LEVEL && LEVEL.INPUT.LEVEL <= nNumConfigBtns)
	  {
	  STACK_VAR INTEGER nPage ;
	  STACK_VAR INTEGER nBtn ;
	  
	  nRXNewValue = 1 ;
	  nPage = ((LEVEL.INPUT.LEVEL - 1) / 24) ;
	  nBtn  = (LEVEL.INPUT.LEVEL - (nPage * 24)) ;
	  
	  sWEB_PAGE[nPage + 1].BTN[nBtn].Value = LEVEL.VALUE ;
	  //fnWebDeBug("'Rcv''d LEVEL_0-',itoa(LEVEL.INPUT.LEVEL),' for Page-',itoa(nPage + 1),' * Btn-',itoa(nBtn),', value= ',itoa(LEVEL.VALUE),'.  >-Line-<',ITOA(__LINE__),'>'",1) ;
	  }
     }
     
DEFINE_PROGRAM  //AUTO SERVER START, TESTING STUFF

//if(nFileInsertIndx > 1 && !nReading)//possibly use if image transfers ever figured out
//     {
//     fnBeginReadingFiles() ;
//     }
//if(nTestBuff_Clear)//just for testing , comment out when done!
//     {
//     nTestBuff_Clear = !nTestBuff_Clear ;
//     cWeb_TestRXBuff = '' ;
//     cWeb_TestTXBuff = '' ;
//     }
//if(nTestTime)//use for testing the tima additon function
//     {
//     SEND_STRING 0, "'WEB_DEBUG: ',fnDo24hrTimeAddition(LDATE,TIME,nTestSecondsAdded)" ;
//     nTestTime = 0 ;
//    }

if(nWebServerState == SERVER_STOPPED)
     {
     nWebServerState = SERVER_DISABLED ;
     if(!nConnectAttempts)
	  {
	  nWebServerState = SERVER_STOPPED ;
	  nConnectAttempts ++ ;
	  fnOpenWebServer() ;
	  }
     else if(nConnectAttempts < 6)
	  {
	  WAIT 300 'WEB_CONNECT_TIMEOUT' ;
	       {
	       nWebServerState = SERVER_STOPPED ;
	       nConnectAttempts ++ ;
	       fnOpenWebServer() ;
	       }
	  }
     else if(nConnectAttempts < 11)
	  {
	  WAIT 3000 'WEB_CONNECT_TIMEOUT' ;
	       {
	       nWebServerState = SERVER_STOPPED ;
	       nConnectAttempts ++ ;
	       fnOpenWebServer() ;
	       }
	  }
     else 
	  {
	  WAIT 18000 'WEB_CONNECT_TIMEOUT' ;
	       {
	       nWebServerState = SERVER_STOPPED ;
	       nConnectAttempts ++ ;
	       fnOpenWebServer() ;
	       }
	  }
     }

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////

  