private _spawnLocations = _this select 0;
private _sectorName = _this select 1;

private _chosenSpawnLocation = selectRandom _spawnLocations;
private _vehicleSpawnPoint =   [_chosenSpawnLocation, 500] call BIS_fnc_nearestRoad; // [getPosATL player, 500] call BIS_fnc_nearestRoad;
private _vehicleType = selectRandom RED_TANK_ARRAY;

//Create diary record for the parent task 

private _parentTaskId = format['Clear %1', _sectorName];
private _type = "danger";
private _description = [
	format['Disable Vehicle  %1', _sectorName], 
	format['Sabotage %1', _sectorName], 
	SECTOR_POS
];
_priority = -1;

[_parentTaskId, _type, _description, SECTOR_POS] execVM "functions\taskManagement\taskCreater.sqf";

TARGET_VEHICLE = createVehicle [_vehicleType, _vehicleSpawnPoint];

// creating the child task

private _position = _vehicleSpawnPoint;
_type = "destroy";
diag_log ['the position:', _position];
_missionName = ['Destroy Mission'] call missionNamer;
_childTasIdk = _missionName;
_description = [
	format['Enemy vehicle spotted here.<br />Mission codename: %1',_missionName], 
	_missionName, 
	_position
];
// diag_log ['the mission name', _missionName];
// [_owner, [_childTasIdk, _parentTaskId], _description, _position, _state, _priority, _showNotification, _type, _visibleIn3D] call BIS_fnc_taskCreate;
[ [_childTasIdk, _parentTaskId], _type, _description, _position] execVM "functions\taskManagement\taskCreater.sqf";
