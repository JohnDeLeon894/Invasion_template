// params ['_spawnLocations', '_sectorName'];

private _spawnLocations = _this select 0;
private _sectorName = _this select 1;

diag_log ['****** the spawn locations **********', _spawnLocations];

private _testSpawnLocationSelection = selectRandom _spawnLocations;

diag_log ['****** the test spawn location **********', _testSpawnLocationSelection];

private _parentTaskId = format['Clear %1', _sectorName];
private _type = "danger";
private _description = [
	format['Disable Vehicle  %1', _sectorName], 
	format['Sabotage %1', _sectorName], 
	SECTOR_POS
];
_priority = -1;

[_parentTaskId, _type, _description, SECTOR_POS] execVM "functions\taskManagement\taskCreater.sqf";

private _totalTaskCount = 1 + (floor (random 3));

VEHICLES_DESTROYED = 0;

// TARGET_VEHICLE = createVehicle [_vehicleType, _vehicleSpawnPoint];

// creating the child task

for [{private _i = 0}, {_i < _totalTaskCount}, {_i = _i + 1 }] do {
	// [(selectRandom _spawnLocations)]call _createDestroyVehicleMission;
	private _chosenSpawnLocation = selectRandom _spawnLocations;
	diag_log ['******* chosen spawn location. ********', _chosenSpawnLocation];
	private _vehicleSpawnPoint =   [_chosenSpawnLocation, 500] call BIS_fnc_nearestRoad; // [getPosATL player, 500] call BIS_fnc_nearestRoad;
	private _vehicleType = selectRandom RED_TANK_ARRAY;
	private _childType = "destroy";
	private _missionName = ['Mission Codename: Destroy-'] call missionNamer;
	private _childTasIdk = _missionName;

	private _targetVehicle = createVehicle [_vehicleType, _vehicleSpawnPoint];
	diag_log ['the position:', _vehicleSpawnPoint];

	_description = [
		format['Enemy vehicle spotted here.<br />Mission codename: %1',_missionName], 
		_missionName, 
		_chosenSpawnLocation
	];

	diag_log 'creating the task';
	[ [_childTasIdk, _parentTaskId], _type, _description, _chosenSpawnLocation] execVM "functions\taskManagement\taskCreater.sqf";
	diag_log 'starting the tracker';
	[_targetVehicle, _childTasIdk, _totalTaskCount ] execVM 'functions\taskManagement\targetVehicleTracker.sqf';
};