//This is the stop escorte script
//This is a public script and any modification has to be open source
//Vist AggGaming.com
//For help on this join the teamspeak ts3.AggGaming.com

_suspect = cursorTarget;

 
If ((!isnil "_suspect" && side _suspect == civilian && player distance _suspect <= 2 && animationState _suspect == "AmovPercMstpSnonWnonDnon_Ease") && !(isNil {player getVariable "agg_is_escorting"})) exitWith {hint (localize "Escorting person")};

If (isnil "_suspect" OR side _suspect != civilian OR player distance _suspect > 2) exitWith {hint (localize "You need to be closers to the person")};

If (!isnil "_suspect" && side _suspect == civilian && player distance _suspect <= 2 && animationState _suspect != "AmovPercMstpSnonWnonDnon_Ease") exitWith {hint (localize "Person is not detained");};

If ((!isnil "_suspect" && side _suspect == civilian && player distance _suspect <= 2 && animationState _suspect == "AmovPercMstpSnonWnonDnon_Ease") && (isNil {player getVariable "agg_is_escorting"})) exitWith 
{
	_suspect attachTo [player, [0,1,0]];
	player setVariable ["agg_is_escorting", true, true];
	AGG_TEMP_ACTION_STOPESCORT = player addAction ["<t color=""#1AA31A"">" +"Stop Escorting","ArestScript\Scripts\stopeskorte.sqf"];
};
