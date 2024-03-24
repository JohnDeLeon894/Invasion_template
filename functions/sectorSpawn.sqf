// creates enemy groups and sets them to patrol or garison near their spawn marker
// [trigger, group size] call jMD_fnc_sectorspawn

private _trigger	 = _this select 0;
private _groupsize	 = _this select 1;
private _nearbyLocations = _this select 2;
private _usePosition = _this select 3;
private _arearadious = _this select 4;
private _parentTaskId = _this select 5;
private _useSectorName = _this select 6;
private _type = _this select 7;
diag_log format ['*********** the type= %1 *************', _type];
private _numberOfgroupstospawn = floor  (3 + random 3);
private _state = 'AUtoASSIGNED';
private _owner = WEST;
private _priority = -1;
private _locationcount = count _nearbyLocations;
private _resultsArray = [];
hint format ['trigger: %1', _trigger];

private _spawnedcount = 0;
private _tries = 0;

{
	private _basePos = getMarkerPos _x;
	private _baseTriggerDistance = _basePos distance _trigger;

	if (_basePos inArea _trigger) then {
		private _groupname = format ['enemygroup_%1', _x];
		private _eastgroup = creategroup [east, false];
		_eastgroup setgroupId [_groupname];
		_eastgroup = [_eastgroup, (8 + random 4), RED_units_ARRAY, _basePos] call jMD_fnc_spawngroups;
		continue;
	};

	private _inActiveTrigger = 0;

	{
		private _outsideTrigger = call compile _x;
		if (_basePos inArea _outsideTrigger) then {
			_inActiveTrigger = _inActiveTrigger + 1;
		};
	} forEach ALL_TRIGGERS;

	if ((_inActiveTrigger > 0) && (_baseTriggerDistance < 5000)) then {
		private _groupname = format ['enemygroup_%1', _x];
		private _eastgroup = creategroup [east, false];
		_eastgroup setgroupId [_groupname];
		_eastgroup = [_eastgroup, (8 + random 4), RED_units_ARRAY, _basePos] call jMD_fnc_spawngroups;
	};

} forEach ALL_BASES;

while {_spawnedcount < _numberOfgroupstospawn} do {
	private ['_position', '_groupname', '_waypointScript', '_wp', '_selectedLocation', '_eastgroup', '_westgroup', '_missionName'];
	
	_selectedLocation = _nearbyLocations call BIS_fnc_selectRandom;
	_nearbyLocations deleteAt (_nearbyLocations find _selectedLocation);
	_resultsArray pushBack _selectedLocation;
	_westgroup = FRIendlY_groupS select _spawnedcount;
	_missionName = ['Combat Patrol'] call missionNamer;
	diag_log ['the mission name', _missionName];
	group_count = group_count + 1;
	
	_groupname = format ['enemygroup_%1', group_count];
	_eastgroup = creategroup [east, false];
	_eastgroup setgroupId [_groupname];
	
	if (_usePosition) then {
			_position = position _selectedLocation;
	} else {
			_position = locationposition _selectedLocation;
	};
	
	_eastgroup = [_eastgroup, (_groupsize + random 4), RED_units_ARRAY, _position] call jMD_fnc_spawngroups;
	
	_wp = _eastgroup addWaypoint [_position, 200];
	_wp setwaypointBehaviour 'SAFE';
	/*
	0: group performing action, either unit <OBJECT> or group <group>
	1: position to occupy, default group location <ARRAY or OBJECT>
	2: Range of tracking, default is 50 meters <NUMBER>
	3: Area the AI Camps in, default [] <ARRAY>
	4: Teleport units to position <BOOL>
	5: sort Based on Height <BOOL>
	6: exit Conditions that breaks a Unit free (-2 random, -1 All, 0 None, 1 Hit, 2 fired, 3 firedNear, 4 Suppressed), default -2 <NUMBER>
	7: Sub-group patrols the area <BOOL>
	*/
	[_eastgroup, _position, 200, [], false, true, -1, true] call lambs_wp_fnc_taskGarrison;
	// creating diary record and task
	private ['_childTasIdk', '_description', '_completedChildren', '_activation', '_statement'];
	_childTasIdk = _missionName;
	_description = [format['Enemy soldiers were spotted near the marked location. Patrol the area and engage any units you come across.<br />Mission codename: %1', _missionName], _missionName, _selectedLocation];
	_activation = format['["%1", "SUCCEEDED"] call BIS_fnc_tasksetState;', _childTasIdk];
	
	/*
	0: group performing action, either unit <OBJECT> or group <group>
	1: position being searched, default group position <OBJECT or ARRAY>
	2: Range of tracking, default is 200 meters <NUMBER>
	3: Waypoint count, default 4 <NUMBER>
	4: Area the AI Camps in, default [] <ARRAY> 5: Dynamic patrol pattern, default false <BOOL>
	
	[bob, bob, 500] call lambs_wp_fnc_taskPatrol;
	*/
	if (! (isnil '_westgroup')) then {
			hint format['found group %1', _westgroup];
			[_westgroup, _position, 300] call lambs_wp_fnc_taskPatrol;
	};
	diag_log [_childTasIdk, _parentTaskId];
	[_owner, [_childTasIdk, _parentTaskId], _description, _position, _state, _priority, _shownotification, _type, _visiblein3D] call BIS_fnc_taskCreate;

	switch (_type) do {
		case "move": { 
			[_position, _childTasIdk, _numberOfgroupstospawn] execVM 'functions\patrolTracker.sqf';
		};
		default { 
			[_eastgroup, _childTasIdk, _numberOfgroupstospawn] execVM 'functions\groupTracker.sqf';
		};
	};
	
	private _diaryTitle = format['Trigger %1 created:', _trigger];
	player createDiaryRecord ['taskRecord', [_diaryTitle, format['this is the marker found: %1', _selectedLocation]]];
	player createDiaryRecord ['taskRecord', [_diaryTitle, format['This is the current group count: %1', ({
			alive _x
	} count units _eastgroup)]]];
	player createDiaryRecord ['taskRecord', [_diaryTitle, format['This is the current group name: %1', _groupname]]];
	player createDiaryRecord ['taskRecord', [_diaryTitle, format['This is the current group id: %1', groupid _eastgroup]]];
	
	_spawnedcount = _spawnedcount + 1;
};

_resultsArray