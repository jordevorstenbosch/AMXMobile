PROGRAM_NAME='amx_mobile'
// Created by: Brian Cirrisi and modified by VAV
// Last Modified: 07/15/2009
// Version: 1.0
// This code is provided to the AMX Forum community and is not to be sold
//	commercially. 

DEFINE_DEVICE

(***   DEFINED IN MAIN PROGRAM   ***)
(*
dvAMX_Mobile	        = 0:20:0 ;
vdv_amxmobile		= 33017:1:0  ;
*)

DEFINE_CONSTANT  //GENERAL CONSTANTS (THESE NEED UPDATING PER SYSTEM!)

WEB_NUMBER_PAGES	= 3 ;
CHAR WEB_PAGE1_NAME[]	= 'Lights' ;
CHAR WEB_PAGE2_NAME[]	= 'Audio' ;
CHAR WEB_PAGE3_NAME[]	= 'Shades' ;
CHAR WEB_PAGE4_NAME[]	= 'Page4 Name' ;
CHAR WEB_PAGE5_NAME[]	= 'Page5 Name' ;
CHAR WEB_PAGE6_NAME[]	= 'Page6 Name' ;
CHAR WEB_PAGE7_NAME[]	= 'Page7 Name' ;
CHAR WEB_PAGE8_NAME[]	= 'Page8 Name' ;
CHAR WEB_PAGE9_NAME[]	= 'Page9 Name' ;
CHAR WEB_PAGE10_NAME[]	= 'Page10 Name' ;

DEFINE_CONSTANT  //GENERAL CONSTANTS 

WEB_LEN_BTN_NAMEs	= 15 ;  	// MAX AMOUNT OF TEXT IN THE NAME  SET TO 15 IN MODULE TOO 
WEB_LEN_SET_NAMEs	= 40 ;  	// MAX AMOUNT OF TEXT IN THE NAME

DEFINE_VARIABLE

VOLATILE INTEGER nWebDebug = 0 ;	// Debug
VOLATILE INTEGER nWebPort ;	        // This is the port that the site will be hosted on (ie, HTTP = port 80)
VOLATILE CHAR cWebPassword[30] ;	// This holds the password for the site
VOLATILE CHAR cWebTitle [30] ;   	// This holds the title that appears when you log into the site
VOLATILE CHAR cWebURL_IP [15] ;		// The web address of the site

DEFINE_VARIABLE  //STRUCTURE VAR     DELETE ??

DEFINE_START

nWebPort	=	 80 ;		// The Website will be hosted on port 80
					// !!! Make sure that you change the NI's web port to something other then 80 (ex 83)
					// !!! if you are going to use port 80
cWebPassword 	= 	'password'	// The password to log in
cWebTitle 		= 	'AMX Mobile'	// The title that appears on the top of the Mobile Site
cWebURL_IP		=	'192.168.1.60'  // The site that the Mobile Device will point to

DEFINE_MODULE 'AMX_Mobile_Comm' AMX_Mobile (vdv_amxmobile,dv_amxmobile,nWebPort,cWebURL_IP,nWebDeBug)
					          
DEFINE_EVENT

DATA_EVENT[vdv_amxmobile] //PAGE 1 NAME & BUTTON NAMES & INITIAL CONFIG VALUES
{
	ONLINE:{
		STACK_VAR INTEGER x ;
		STACK_VAR INTEGER y ;
		STACK_VAR INTEGER z ;
		WAIT 100{
			SEND_COMMAND vdv_amxmobile,"'NUMPAGES=',ITOA(WEB_NUMBER_PAGES)" ;
			SEND_COMMAND vdv_amxmobile,"'PASSWORD=', cWebPassword" ;
			SEND_COMMAND vdv_amxmobile,"'TITLE=', cWebTitle" ;
			SEND_COMMAND vdv_amxmobile,"'DEBUG=0'" ;
			SEND_COMMAND vdv_amxmobile,"'KEEPFRESH=1'" ;   //0 = NO AND 1 = YES FORCES THE HTML TO REFRESH "THE ENTIRE PAGE" REGARDLESS OF CHANGES!!!!!
			SEND_COMMAND vdv_amxmobile,"'TIMEFRESH=10000'" ;//3000 - 60000 milli-seconds // 3 - 60 seconds!
		}
	  (******************************************************)
	  (*		PAGE 1 NAME & BUTTON NAMES		*)
	  (******************************************************)
	  WAIT 110 //BUTTON SHOW VALUES: NO SHOW = 0 ; SHOW = 1; MENU = 2
	       {  //Page names must exactly match button names set as menu buttons
	       SEND_COMMAND vdv_amxmobile, "'PAGE=1',		'LABEL=',WEB_PAGE1_NAME" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=1',		'NAME=',WEB_PAGE1_NAME,	';SHOW=2'" ;   //   	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=2',		'NAME=',WEB_PAGE2_NAME,	';SHOW=2'" ;   //   	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=3',		'NAME=',WEB_PAGE3_NAME,	';SHOW=2'" ;   //   	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=4',		'NAME=Mid Floods',	';SHOW=1'" ;   //   VKP_BTN_MFLDS	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=5',		'NAME=Rear Floods',	';SHOW=1'" ;   //   VKP_BTN_RFLDS	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=6',		'NAME=Parking Floods',	';SHOW=1'" ;   //   VKP_BTN_PFLDS	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=7',		'NAME=Kit. Island',	';SHOW=1'" ;   //   VKP_BTN_KITCHEN	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=8',		'NAME=Office',		';SHOW=1'" ;   //   VKP_BTN_OFFICE	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=9',		'NAME=Int. All Off',	';SHOW=1'" ;   //   VKP_BTN_IALLOFF	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=10',	'NAME=E. Evening',	';SHOW=1'" ;   //   VKP_BTN_EEVENING
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=11',	'NAME=E. All Off',	';SHOW=1'" ;   //   VKP_BTN_EALLOFF	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=12',	'NAME=Pathway',		';SHOW=1'" ;   //   VKP_BTN_PATHWAY	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=13',	'NAME=Front Coach',	';SHOW=1'" ;   //   VKP_BTN_FCOACH	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=14',	'NAME=Front Floods',	';SHOW=1'" ;   //   VKP_BTN_FFLDS	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=15',	'NAME=Side Floods',	';SHOW=1'" ;   //   VKP_BTN_SFLDS	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=16',	'NAME=Mid Floods',	';SHOW=1'" ;   //   VKP_BTN_MFLDS	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=17',	'NAME=Rear Floods',	';SHOW=1'" ;   //   VKP_BTN_RFLDS	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=18',	'NAME=Parking Floods',	';SHOW=1'" ;   //   VKP_BTN_PFLDS	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=19',	'NAME=Kit. Island',	';SHOW=1'" ;   //   VKP_BTN_KITCHEN	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=20',	'NAME=Office',		';SHOW=1'" ;   //   VKP_BTN_OFFICE	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=21',	'NAME=Int. All Off',	';SHOW=1'" ;   //   VKP_BTN_IALLOFF	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=22',	'NAME=E. Evening',	';SHOW=1'" ;   //   VKP_BTN_EEVENING
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=23',	'NAME=E. All Off',	';SHOW=1'" ;   //   VKP_BTN_EALLOFF	
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=24',	'NAME=Pathway',		';SHOW=1'" ;   //   VKP_BTN_PATHWAY
	       }
	  }
     }
     
DATA_EVENT[vdv_amxmobile] //PAGE 2 NAME & BUTTON NAMES

     {
     ONLINE:
	  {
	  (******************************************************)
	  (*		PAGE 2 NAME & BUTTON NAMES		*)	  
	  (******************************************************) 
	  WAIT 120
	       {
	       SEND_COMMAND vdv_amxmobile, "'PAGE=2',		'LABEL=',WEB_PAGE2_NAME" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=25',	'NAME=',WEB_PAGE1_NAME, ';SHOW=2'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=26',	'NAME=',WEB_PAGE2_NAME, ';SHOW=2'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=27',	'NAME=',WEB_PAGE3_NAME, ';SHOW=2'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=28',	'NAME=Play',		';SHOW=1'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=29',	'NAME=Stop',		';SHOW=1'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=30',	'NAME=Pause',		';SHOW=1'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=31',	'NAME=<<<',		';SHOW=1'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=32',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=33',	'NAME=>>>',		';SHOW=1'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=34',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=35',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=36',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=37',	'NAME=Vol Up',		';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=38',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=39',	'NAME=Vol Dn',		';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=40',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=41',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=42',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=43',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=44',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=45',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=46',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=47',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=48',	'NAME=NOT USED;',	';SHOW=0'" ;
	       }                                 
	  }
     }
     
DATA_EVENT[vdv_amxmobile] //PAGE 3 NAME & BUTTON NAMES

     {
     ONLINE:
	  {
	  //(*
	  (******************************************************)
	  (*		PAGE 3 NAME & BUTTON NAMES		*)	  
	  (******************************************************) 
	  WAIT 130
	       {
	       SEND_COMMAND vdv_amxmobile, "'PAGE=3',		'LABEL=',WEB_PAGE3_NAME" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=49',	'NAME=',WEB_PAGE1_NAME,	';SHOW=2'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=50',	'NAME=',WEB_PAGE2_NAME,	';SHOW=2'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=51',	'NAME=',WEB_PAGE3_NAME,	';SHOW=2'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=52',	'NAME=NOT USED',	';SHOW=1'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=53',	'NAME=NOT USED',	';SHOW=1'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=54',	'NAME=NOT USED',	';SHOW=1'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=55',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=56',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=57',	'NAME=NOT USED',	';SHOW=1'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=58',	'NAME=NOT USED',	';SHOW=1'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=59',	'NAME=NOT USED',	';SHOW=1'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=60',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=61',	'NAME=NOT USED',	';SHOW=1'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=62',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=63',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=64',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=65',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=66',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=67',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=68',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=69',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=70',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=71',	'NAME=NOT USED',	';SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile, "'BUTTON=72',	'NAME=NOT USED;',	';SHOW=0'" ;
	       } 
	  //*)
	  }
     }
     
DATA_EVENT[vdv_amxmobile] //PAGE 4 NAME & BUTTON NAMES !!! FIX ; & , & '  !!!

     {
     ONLINE:
	  {
	  (*
	  #WARN '!!! FIX ; & , & '  !!! in DATA_EVENT for PAGE 4 NAME & BUTTON NAMES' ;
	  (******************************************************)
	  (*		PAGE 4 NAME & BUTTON NAMES		*)	  
	  (******************************************************) 
	  WAIT 140
	       {
	       SEND_COMMAND vdv_amxmobile; "'PAGE=4;';		'LABEL=SOME NAME'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=73;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=74;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=75;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=76;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=77;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=78;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=79;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=80;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=81;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=82;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=83;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=84;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=85;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=86;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=87;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=88;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=89;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=90;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=91;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=92;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=93;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=94;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=95;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=96;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       }                                   
	  *)
	  }
     }
     
DATA_EVENT[vdv_amxmobile] //PAGE 5 NAME & BUTTON NAMES !!! FIX ; & , & '  !!!(CAN CONTINUE UP TO TEN PAGES)

     {
     ONLINE:
	  {
	  (*
	  #WARN '!!! FIX ; & , & '  !!! in DATA_EVENT for PAGE 5 NAME & BUTTON NAMES' ;
	  (******************************************************)
	  (*		PAGE 5 NAME & BUTTON NAMES		*)	  
	  (******************************************************) 
	  WAIT 150
	       {
	       SEND_COMMAND vdv_amxmobile; "'PAGE=5;';		'LABEL=SOME NAME'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=97;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=98;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=99;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=100;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=101;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=102;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=103;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=104;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=105;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=106;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=107;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=108;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=109;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=110;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=111;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=112;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=113;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=114;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=115;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=116;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=117;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=118;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=119;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       SEND_COMMAND vdv_amxmobile; "'BUTTON=120;';	'NAME=NOT USED;';	'SHOW=0'" ;
	       } 
	  *)
	  }
	  (******************************************************)
	  (*		CONTINUE UP TO TEN PAGES		*)	  
	  (******************************************************) 
     }


BUTTON_EVENT[vdv_amxmobile,0]
     
     {
     PUSH:
	  {
	  STACK_VAR INTEGER nBtn ;
	  
	  if(BUTTON.INPUT.CHANNEL)
	       {
	       nBtn = BUTTON.INPUT.CHANNEL ;
	       if(nWebDeBug)
		    {
		    SEND_STRING 0, "'WEB PRESS: ', ITOA(nBtn)"
		    }
	       SWITCH(nBtn)//NEWPAGE=2:NEWPAGE
		    /////////////   PAGE ONE BEGINS   /////////////////////////////////////////////
		    {
		    CASE 1:  {SEND_COMMAND vdv_amxmobile,"'NEWPAGE=1'" ;} ;   		//      1 ; 
		    CASE 2:  {SEND_COMMAND vdv_amxmobile,"'NEWPAGE=2'" ;} ;   		//      2 ;
		    CASE 3:  {SEND_COMMAND vdv_amxmobile,"'NEWPAGE=3'" ;} ;   		//      3 ;
		    CASE 4:  {do_push(tp_hwi_1,707)} ; //   VKP_BTN_MFLDS		=	4 ;
		    CASE 5:  {do_push(tp_hwi_1,697)} ; //   VKP_BTN_RFLDS		=	5 ;
		    CASE 6:  {do_push(tp_hwi_1,698)} ; //   VKP_BTN_PFLDS		=	6 ;
		    CASE 7:  {do_push(tp_hwi_1,695)} ; //   VKP_BTN_KITCHEN		=	7 ;
		    CASE 8:  {do_push(tp_hwi_1,699)} ; //   VKP_BTN_OFFICE		=	8 ;
		    CASE 9:  {do_push(tp_hwi_1,31)}  ; //   VKP_BTN_IALLOFF		=	9 ;
		    CASE 10: {do_push(tp_hwi_1,32)}  ; //   VKP_BTN_EEVENING		=	10 ;
		    CASE 11: {do_push(tp_hwi_1,33)}  ; //   VKP_BTN_EALLOFF		=	11 ;
		    CASE 12: {do_push(tp_hwi_1,35)}  ; //   VKP_BTN_PATHWAY		=	12 ;
		    CASE 13: {do_push(tp_hwi_1,704)} ; //   VKP_BTN_FCOACH		=	13 ;
		    CASE 14: {do_push(tp_hwi_1,709)} ; //   VKP_BTN_FFLDS		=	14 ;
		    CASE 15: {do_push(tp_hwi_1,710)} ; //   VKP_BTN_SFLDS		=	15 ;
		    CASE 16: {do_push(tp_hwi_1,707)} ; //   VKP_BTN_MFLDS		=	16 ;
		    CASE 17: {do_push(tp_hwi_1,697)} ; //   VKP_BTN_RFLDS		=	17 ;
		    CASE 18: {do_push(tp_hwi_1,698)} ; //   VKP_BTN_PFLDS		=	18 ;
		    CASE 19: {do_push(tp_hwi_1,695)} ; //   VKP_BTN_KITCHEN		=	19 ;
		    CASE 20: {do_push(tp_hwi_1,699)} ; //   VKP_BTN_OFFICE		=	20 ;
		    CASE 21: {do_push(tp_hwi_1,31)}  ; //   VKP_BTN_IALLOFF		=	21 ;
		    CASE 22: {do_push(tp_hwi_1,32)}  ; //   VKP_BTN_EEVENING		=	22 ;
		    CASE 23: {do_push(tp_hwi_1,33)}  ; //   VKP_BTN_EALLOFF		=	23 ;
		    CASE 24: {do_push(tp_hwi_1,35)}  ; //   VKP_BTN_PATHWAY		=	24 ;
		    /////////////   PAGE TWO BEGINS   /////////////////////////////////////////////
		    CASE 25: {SEND_COMMAND vdv_amxmobile,"'NEWPAGE=1'" ;} ;   		//      1 ;
		    CASE 26: {SEND_COMMAND vdv_amxmobile,"'NEWPAGE=2'" ;} ;   		//      2 ;
		    CASE 27: {SEND_COMMAND vdv_amxmobile,"'NEWPAGE=3'" ;} ;   		//      3 ;
		    CASE 28: {do_push(tp_hwi_1,707)} ; //   VKP_BTN_MFLDS		=	4 ;
		    CASE 29: {do_push(tp_hwi_1,697)} ; //   VKP_BTN_RFLDS		=	5 ;
		    CASE 30: {do_push(tp_hwi_1,698)} ; //   VKP_BTN_PFLDS		=	6 ;
		    CASE 31: {do_push(tp_hwi_1,695)} ; //   VKP_BTN_KITCHEN		=	7 ;
		    CASE 32: {do_push(tp_hwi_1,699)} ; //   VKP_BTN_OFFICE		=	8 ;
		    CASE 33: {do_push(tp_hwi_1,31)}  ; //   VKP_BTN_IALLOFF		=	9 ;
		    CASE 34: {do_push(tp_hwi_1,32)}  ; //   VKP_BTN_EEVENING		=	10 ;
		    CASE 35: {do_push(tp_hwi_1,33)}  ; //   VKP_BTN_EALLOFF		=	11 ;
		    CASE 36: {do_push(tp_hwi_1,35)}  ; //   VKP_BTN_PATHWAY		=	12 ;
		    CASE 37: {do_push(tp_hwi_1,704)} ; //   VKP_BTN_FCOACH		=	13 ;
		    CASE 38: {do_push(tp_hwi_1,709)} ; //   VKP_BTN_FFLDS		=	14 ;
		    CASE 39: {do_push(tp_hwi_1,710)} ; //   VKP_BTN_SFLDS		=	15 ;
		    CASE 40: {do_push(tp_hwi_1,707)} ; //   VKP_BTN_MFLDS		=	16 ;
		    CASE 41: {do_push(tp_hwi_1,697)} ; //   VKP_BTN_RFLDS		=	17 ;
		    CASE 42: {do_push(tp_hwi_1,698)} ; //   VKP_BTN_PFLDS		=	18 ;
		    CASE 43: {do_push(tp_hwi_1,695)} ; //   VKP_BTN_KITCHEN		=	19 ;
		    CASE 44: {do_push(tp_hwi_1,699)} ; //   VKP_BTN_OFFICE		=	20 ;
		    CASE 45: {do_push(tp_hwi_1,31)}  ; //   VKP_BTN_IALLOFF		=	21 ;
		    CASE 46: {do_push(tp_hwi_1,32)}  ; //   VKP_BTN_EEVENING		=	22 ;
		    CASE 47: {do_push(tp_hwi_1,33)}  ; //   VKP_BTN_EALLOFF		=	23 ;
		    CASE 48: {do_push(tp_hwi_1,35)}  ; //   VKP_BTN_PATHWAY		=	24 ;
		    /////////////   PAGE THREE BEGINS   ////////////////////////////////////////////
		    CASE 49: {SEND_COMMAND vdv_amxmobile,"'NEWPAGE=1'" ;} ;  		//      1 ;
		    CASE 50: {SEND_COMMAND vdv_amxmobile,"'NEWPAGE=2'" ;} ;   		//      2 ;
		    CASE 51: {SEND_COMMAND vdv_amxmobile,"'NEWPAGE=3'" ;} ;   		//      3 ;
		    CASE 52: {do_push(tp_hwi_1,707)} ; //   VKP_BTN_MFLDS		=	4 ;
		    CASE 53: {do_push(tp_hwi_1,697)} ; //   VKP_BTN_RFLDS		=	5 ;
		    CASE 54: {do_push(tp_hwi_1,698)} ; //   VKP_BTN_PFLDS		=	6 ;
		    CASE 55: {do_push(tp_hwi_1,695)} ; //   VKP_BTN_KITCHEN		=	7 ;
		    CASE 56: {do_push(tp_hwi_1,699)} ; //   VKP_BTN_OFFICE		=	8 ;
		    CASE 57: {do_push(tp_hwi_1,31)}  ; //   VKP_BTN_IALLOFF		=	9 ;
		    CASE 58: {do_push(tp_hwi_1,32)}  ; //   VKP_BTN_EEVENING		=	10 ;
		    CASE 59: {do_push(tp_hwi_1,33)}  ; //   VKP_BTN_EALLOFF		=	11 ;
		    CASE 60: {do_push(tp_hwi_1,35)}  ; //   VKP_BTN_PATHWAY		=	12 ;
		    CASE 61: {do_push(tp_hwi_1,704)} ; //   VKP_BTN_FCOACH		=	13 ;
		    CASE 62: {do_push(tp_hwi_1,709)} ; //   VKP_BTN_FFLDS		=	14 ;
		    CASE 63: {do_push(tp_hwi_1,710)} ; //   VKP_BTN_SFLDS		=	15 ;
		    CASE 64: {do_push(tp_hwi_1,707)} ; //   VKP_BTN_MFLDS		=	16 ;
		    CASE 65: {do_push(tp_hwi_1,697)} ; //   VKP_BTN_RFLDS		=	17 ;
		    CASE 66: {do_push(tp_hwi_1,698)} ; //   VKP_BTN_PFLDS		=	18 ;
		    CASE 67: {do_push(tp_hwi_1,695)} ; //   VKP_BTN_KITCHEN		=	19 ;
		    CASE 68: {do_push(tp_hwi_1,699)} ; //   VKP_BTN_OFFICE		=	20 ;
		    CASE 69: {do_push(tp_hwi_1,31)}  ; //   VKP_BTN_IALLOFF		=	21 ;
		    CASE 70: {do_push(tp_hwi_1,32)}  ; //   VKP_BTN_EEVENING		=	22 ;
		    CASE 71: {do_push(tp_hwi_1,33)}  ; //   VKP_BTN_EALLOFF		=	23 ;
		    CASE 72: {do_push(tp_hwi_1,35)}  ; //   VKP_BTN_PATHWAY		=	24 ;
		    }                                                                        
	       }
	  }
     }

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)

DEFINE_PROGRAM



  


