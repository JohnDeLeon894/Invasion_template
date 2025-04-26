// check the different transports 
// chopper
// vehicle

private _defaultVehicleType = '';

private _splitString = {
	private _string = _this select 0;

	private _splitString = _string splitString '_';

	_splitString
}; 

private _deleteIfCantMove = {
	private _vehicleName = _this select 0;
	private _transportArray = _this select 1;
	private _vehicle = call compile _vehicleName;
	private _canMove = canMove _vehicle;

	private _defaultVehicleType = typeOf _vehicle;
	diag_log format['the %2"s status is %1', _canMove, _vehicle];
	_vehicle setVariable ['TCL_Disabled', true];
	_vehicle setVariable ["Vcm_Disable",true];

	if ( !(_canMove) ) then { 
		// [_vehicle, true] call _vehicleCheck;
		_vehicle setDamage 1; 
		_transportArray deleteAt (_transportArray find _vehicleName);
	}; 

	_canMove
};

private _createTransport = {

};

private _vehicleCheck = {
	private ['_vehicleName', '_vehicle', '_isLiveVehicle', '_vehicleType', '_splitName', '_vehicleNumber', '_hawkNumber', '_newName', '_vehicleSpawn', '_vehicleGroup', '_transportArray', '_newNumber'];
	_vehicle = _this select 0;
	_isLiveVehicle = _this select 1;
	_transportArray = _this select 2;
	_vehicleSpawn = _this select 3;

	if (typeName _vehicle == 'string') then {
		_vehicleType = _defaultChoppaType;
	} else {
		_vehicleType = typeOf _vehicle;
	};
	
	// private _vehicleDeleted = [_vehicle, _transportArray] call _deleteIfCantMove;

	_splitName = [_vehicleName] call _splitString;
	_vehicleName = _splitName select 0;
	_vehicleNumber = _splitName select 1;
	_newNumber = (parseNumber _vehicleNumber) + (floor (random 5));
	_newName = format ['%1_%2', _vehicleName, _newNumber];
	_newVehicle = _vehicleType createVehicle _vehicleSpawn;
	_vehicleGroup = createVehicleCrew _newVehicle;
	_vehicleGroup setVariable ['TCL_Disabled', true];
	_vehicleGroup setVariable ["Vcm_Disable",true];

	_transportArray pushBack _newName;
	missionNamespace setVariable [_newName, _newVehicle];
	_newVehicle setVehicleVarName _newName;
	[_newVehicle] execVM 'functions\transport\transport_infil_action.sqf';
};

{
	// Current result is saved in variable _x
	[_x, _deleteIfCantMove] call _deleteIfCantMove;

} forEach  GROUND_TRANSPORTS;

private _transportCount = count GROUND_TRANSPORTS;

if (_transportCount < 6) then {
	private _randomNumber = floor random 100;
	private _transportName = format ['Rhino_%1', _randomNumber];

	/**
		_vehicle = _this select 0;
		_isLiveVehicle = _this select 1;
		_transportArray = _this select 2;
		_vehicleSpawn = _this select 3;
	 */
	[_transportName, false, GROUND_TRANSPORTS, WEST_VEHICLE_SPAWN] call _vehicleCheck;
};