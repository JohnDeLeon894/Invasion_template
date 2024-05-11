
private _group = _this select 0;
private _verb = VERBS call BIS_fnc_selectRandom;
private _noun = NOUNS call BIS_fnc_selectRandom;
private _adjective = ADJECTIVES call BIS_fnc_selectRandom;
private _name = TEXAS_CITIES call BIS_fnc_selectRandom;
private _leader =  units _group select 0;
hint format [
	'random callSign: %1  %2 %3', _adjective, _noun,  _name
]; 

private _newCallsign = format ['%1 %2', _verb, _noun];

_group setGroupIdGlobal [_newCallsign];

player sideChat format [' groupId %1', groupId _group];