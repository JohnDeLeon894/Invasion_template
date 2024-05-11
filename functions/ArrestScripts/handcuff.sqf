//This is the Handcuff script
//This is a public script and any modification has to be open source
//Vist AggGaming.com
//For help on this join the teamspeak ts3.AggGaming.com

_suspect = _this select 0;
_interigator = _this select 1;
_interigate_action = _this select 2;


	   _suspect removeAction _interigate_action;
	   _suspect disableAI "MOVE";
	   _suspect setcaptive true;
	//    playSound "HandCuff";
       _interigator switchMove "AmovPercMstpSrasWrflDnon_gear_AmovPercMstpSrasWrflDnon";
		[[_suspect, "AmovPercMstpSnonWnonDnon_Ease"],"fn_switchMoveGlobal",true,false] call BIS_fnc_MP;
	   	[[_suspect,"ANIM"],"acim_fn_ai_disable",true,false] call BIS_fnc_MP;
       sleep 5;	   
       _interigator switchMove "";
	   hint "You have the person Detained";	   
       
	   
	        // arrest him   
	        //  _suspect addAction ["<t color=""#1AA31A"">" +"Escort", 'functions\ArrestScripts\eskorte.sqf'];

			 // let him go / uncuff him
	        //  _suspect addAction ["<t color=""#1AA31A"">" +"uncuff him!", 'ArestScript\Scripts\UnHandCuff.sqf'];
			 