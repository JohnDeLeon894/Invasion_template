//This is the Unhandcuff script script
//This is a public script and any modification has to be open source
//Vist AggGaming.com
//For help on this join the teamspeak ts3.AggGaming.com

_prisoner = _this select 0;
_guard = _this select 1;
_act = _this select 2;

removeAllActions _prisoner;
_prisoner setskill 1;
_prisoner EnableAI "MOVE";
_prisoner switchMove "";
hint "Suspect released.";

_prisoner addAction ["<t color=""#1AA31A"">" +"HandCuff him!", 'ArestScript\Scripts\HandCuff.sqf'];