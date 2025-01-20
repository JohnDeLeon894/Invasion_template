private _choppaCount = count TRANSPORTS;
private _defaultChoppaType = '';

private _choppaCheck = {
	private ['_choppaName', '_choppa', '_liveChoppa', '_choppaType', '_splitChoppaName', '_choppaNumber', '_hawkNumber', '_newName', '_hawk', '_hawkGroup'];
	_choppa = _this select 0;
	_liveChoppa = _this select 1;

	if (typeName _choppa == 'string') then {
		_choppaType = _defaultChoppaType;
	} else {
		_choppaType = typeOf _choppa;
	};

	if (_liveChoppa) then {
		// HINT format['Choppa %1 cant move', _choppa]; 
		_choppaName =  vehicleVarName _choppa;
		_choppa setDamage 1; 
		TRANSPORTS deleteAt (TRANSPORTS find _choppa);
	} else {
			_choppaName = _choppa;
	};
	CHOPPA_COUNT = CHOPPA_COUNT +1; 
	_splitChoppaName = [_choppaName] call _splitOnChoppa;
	HINT format ['%1', _splitChoppaName];
	_choppaNumber = _splitChoppaName select 1;
	// _hawkNumber = (parseNumber _choppaNumber) + 3;
	_hawkNumber = CHOPPA_COUNT;
	diag_log _hawkNumber;
	_newName = format['Hawk_%1', _hawkNumber];
	diag_log _choppaName;
	_hawk = _choppaType createVehicle CHOPPA_SPAWN;
	_hawkGroup = createVehicleCrew _hawk;
	diag_log _hawk;
	_hawkGroup setVariable ['TCL_Disabled', true];
	_hawkGroup setVariable ["Vcm_Disable",true];
	_hawkGroup enableDynamicSimulation false;
	TRANSPORTS pushBack _newName; 
	
	missionNamespace setVariable [_newName, _hawk];
	_hawk setVehicleVarName _newName;
	diag_log ['is the Variable nil?', isNil _newName];
	diag_log 'setting newName on created vehicle';
	_newName = _hawk;
	diag_log ['is the Variable nil?', _newName];
	diag_log ['variable name', vehicleVarName _hawk];
	[_hawk]execVM 'functions\transport\transport_infil_action.sqf';
};

private _splitOnChoppa = {
	private _string = _this select 0;

	private _splitString = _string splitString '_';

	_splitString
};

{ 
 	private _choppa = call compile _x; 
 	// private _choppa = _x; 
 	private _canMove = canMove _choppa; 
	private _choppaName =  vehicleVarName _choppa;
	_defaultChoppaType = typeOf _choppa;
 	private _status =  ['The Choppa status',format['the Choppa"s status is %1', _canMove]]; 
 	player createDiarySubject['choppaStatus', 'Chopper Status']; 
 	player createDiaryRecord ['choppaStatus', _status]; 
	diag_log format['the Choppa"s status is %1', _canMove];
	_choppa setVariable ['TCL_Disabled', true];
	_choppa setVariable ["Vcm_Disable",true];
	if ( !(_canMove) ) then { 
		// [_choppa, true] call _choppaCheck;
		_choppa setDamage 1; 
		TRANSPORTS deleteAt (TRANSPORTS find _choppa);
	}; 
	_choppa enableDynamicSimulation false;
}  forEach TRANSPORTS;

if (_choppaCount < 4) then {
	private _randomNumber = floor random 100;
	private _newChoppa = format ['foHawk_%1', _randomNumber];
	[_newChoppa, false] call _choppaCheck;
	_choppaCount = count TRANSPORTS;
};

