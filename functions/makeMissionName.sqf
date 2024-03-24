private _taskName = _this select 0;
private _verb = VERBS call BIS_fnc_selectRandom;
private _noun = NOUNS call BIS_fnc_selectRandom;
private _adjective = ADJECTIVES call BIS_fnc_selectRandom;

private _newName = format ['%1 %2-%3', _taskName, _adjective, _noun];
diag_log ['the new name', _newName];
_newName