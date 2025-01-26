// get location from locations
private _positions = _this select 0;
private _sectorName = _this select 1;
private _selectThisOne = floor(random count _positions -1);
private _position = _positions select _selectThisOne;
private _parentTaskId = format['RevoverIntel %1', _sectorName];;
private _childTask_1 =  'Secure Intel';
private _childTask_2 =  'Return Intel';
gotIntel = false;
private _compositionArray = 'compositions\supplyDump.sqf';

diag_log ['Positions passed to fetch task', _positions];
TASK_POS = _position;
// get composition 
spawnerDone = false;
// find best pos looking for buildings 
// myPlaces = selectBestPlaces [position player, 50, "meadow + 2*hills", 1, 5];
// nearestObjects [player, ["house"], 200];
private _buildingFound = false;
private _nearestBuildings = [];
private _radius = 50;

while {! _buildingFound} do {
	_nearestBuildings = nearestObjects [_position, ["house"], _radius];
	if ((count _nearestBuildings) > 1) then {
		_buildingFound = true;
	} else {
		_radius = _radius + 50
	};
};

private _selectedBuilding = selectRandom _nearestBuildings;
private _buildingPositions = [_selectedBuilding] call BIS_fnc_buildingPositions;
private _spawnDocsPosition = selectRandom _buildingPositions;

// spawn composition 
// [[ 0, 0, 0 ], _compositionArray] execVM 'functions\spawners\compositionSpawner.sqf';
[_spawnDocsPosition, _compositionArray] execVM 'functions\spawners\compositionSpawner.sqf';

// create retrieval item
private _addItem = { 
	hint 'Action triggered!';
	params ["_target", "_caller", "_actionId", "_arguments"];
	_caller addItem 'acex_intelitems_document';
	hint 'Intel retrieved';
	
	[ 'Secure Intel', "SUCCEEDED" ] call BIS_fnc_taskSetState;
	gotIntel = true;
	deleteVehicle _target; 
};

private _compileTask = {
	private ['_owner', '_description', '_state', '_priority', '_showNotification', '_type', '_visibleIn3D'];

	_owner = WEST;
	_state = 'AUTOASSIGNED';
	_showNotification = true;
	_type = "intel";
	_visibleIn3D = false;
	_description = [
		format['Theres no telling who took it, but we know where it is. Leaked documents have been located in %1',_sectorName], 
		format['Retrieve leaked documents %1', _sectorName], 
		TASK_POS
	];
	_priority = -1;
	[_owner, _parentTaskId, _description, _position, _state, _priority, _shownotification, _type, _visiblein3D] call BIS_fnc_taskCreate;
};

private _compileChildTask_1 = {
	private ['_owner',  '_description', '_state', '_priority', '_showNotification', '_type', '_visibleIn3D'];

	_owner = WEST;
	_state = 'AUTOASSIGNED';
	_showNotification = true;
	_type = "intel";
	_visibleIn3D = false;
	_description = [
		format['The intel was seen around %1',_sectorName], 
		_childTask_1, 
		TASK_POS
	];
	_priority = -1;
	[_owner, [_childTask_1, _parentTaskId], _description, TASK_POS, _state, _priority, _showNotification, _type, _visibleIn3D] call BIS_fnc_taskCreate;
};

private _compileChildTask_2 = {
	private ['_owner', '_description', '_state', '_priority', '_showNotification', '_type', '_visibleIn3D'];

	_owner = WEST;
	_state = 'AUTOASSIGNED';
	_showNotification = true;
	_type = "intel";
	_visibleIn3D = false;
	_description = [
		format['Bring intel back to base'], 
		_childTask_2, 
		TASK_POS
	];
	_priority = -1;
	[_owner, [_childTask_2, _parentTaskId], _description, TASK_POS, _state, _priority, _showNotification, _type, _visibleIn3D] call BIS_fnc_taskCreate;
};

waitUntil {spawnerDone};

// object addAction [title, script, arguments, priority, showWindow, hideOnUse, shortcut, condition, radius, unconscious, selection, memoryPoint]
targetDocs addAction ['Take Docs', _addItem,[], 1.5, true, true,'', 'true', 5 ];

[] call _compileTask;
[] call _compileChildTask_1;
[] call _compileChildTask_2;

waitUntil{player distance WEST_SPAWN < 300 && gotIntel };

[_childTask_2,"SUCCEEDED"] call BIS_fnc_taskSetState;
[_parentTaskId,"SUCCEEDED"] call BIS_fnc_taskSetState;
[]execVM 'functions\taskManagement\deactivateTrigger.sqf';

