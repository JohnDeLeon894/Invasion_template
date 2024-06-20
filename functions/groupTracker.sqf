// creates a loop that waits until the given group is no longer alive
//create variable for group that is passed in
private _group = _this select 0;
private _childTaske = _this select 1;
private _groupsToKill = _this select 2;
private _diaryTitle = format['group tracking: %1', _group];
private _troops = units _group;

player createDiaryRecord ['taskRecord', [_diaryTitle, format['group %1 is is being tracked', _group]]];
// waitUntil given group no longer has any living members
waitUntil {({alive _x}count _troops) < 2 };
// {
// 	_x setCaptive true;
// 	_x action['Surrender'];
// }forEach units _group;
player sideChat 'Remaining units have scattering';
// {
// 	_x addAction ['Restrain', 'functions\ArrestScripts\handcuff.sqf']
// } forEach units _group;

GROUPS_KILLED = GROUPS_KILLED + 1;
// create a diary record stating this group has been killed
player createDiaryRecord ['taskRecord', [_diaryTitle, format['group %1 is dead', _group]]];
[_childTaske, "SUCCEEDED"] call BIS_fnc_tasksetState;

if (GROUPS_KILLED == _groupsToKill) then {
	// should turn this into a function on its own to be called form anywhere. 
	private _copyStatements = triggerStatements sectorTrigger;
	private _copyActivation = _copyStatements select 1;
	private _copyDeactivation = _copyStatements select 2;
	// player createDiaryRecord ['triggerPicker', ['the trigger statements', format['%1', _copyStatements]]];

	sectorTrigger setTriggerStatements ['false', _copyActivation, _copyDeactivation];
};
