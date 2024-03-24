// creates a loop that waits until the given group is no longer alive
//create variable for group that is passed in
private _position = _this select 0;
private _childTask = _this select 1;
private _patrolTasks = _this select 2;
private _diaryTitle = format['Tracking patrol mission: %1', _childTask];

private _patrolPosition = [_position select 0, _position select 1];

player createDiaryRecord ['taskRecord', [_diaryTitle, format['Patrol mission %1 is being tracked', _childTask]]];
// waitUntil given group no longer has any living members
waitUntil { (player distance _patrolPosition) < 75 };
PATROL_COMPLETE = PATROL_COMPLETE + 1;
// create a diary record stating this group has been killed
player createDiaryRecord ['taskRecord', [_diaryTitle, format['Reached position %1', _childTask]]];
[_childTask, "SUCCEEDED"] call BIS_fnc_tasksetState;

if (PATROL_COMPLETE == _patrolTasks) then {
	private _copyStatements = triggerStatements sectorTrigger;
	private _copyActivation = _copyStatements select 1;
	private _copyDeactivation = _copyStatements select 2;
	// player createDiaryRecord ['triggerPicker', ['the trigger statements', format['%1', _copyStatements]]];

	sectorTrigger setTriggerStatements ['false', _copyActivation, _copyDeactivation];
};