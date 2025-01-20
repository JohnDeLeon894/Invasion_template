params ['_targetVehicle', '_childTask', '_totalTaskCount'];
diag_log 'tracking target vehicle';
private _copyStatements = triggerStatements sectorTrigger;
private _copyActivation = _copyStatements select 1;
private _copyDeactivation = _copyStatements select 2;

waitUntil{! canMove _targetVehicle};
VEHICLES_DESTROYED = VEHICLES_DESTROYED + 1;
diag_log 'target vehicle destroyed';
diag_log ['vehicles destroyed: ', VEHICLES_DESTROYED];
diag_log ['vehicles to destroy', _totalTaskCount];
[_childTask, "SUCCEEDED"] call BIS_fnc_tasksetState;

if (VEHICLES_DESTROYED == _totalTaskCount) then {
	// player createDiaryRecord ['triggerPicker', ['the trigger statements', format['%1', _copyStatements]]];

	sectorTrigger setTriggerStatements ['false', _copyActivation, _copyDeactivation];
};