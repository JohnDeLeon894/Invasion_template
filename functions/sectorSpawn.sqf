// creates enemy groups and sets them to patrol or garison near their spawn marker
// [trigger, group size] call jMD_fnc_sectorspawn

private _trigger	 = _this select 0;
private _groupSize	 = _this select 1;
private _nearbyLocations = _this select 2;
private _usePosition = _this select 3;
private _areaRadius = _this select 4;
private _parentTaskId = _this select 5;
private _useSectorName = _this select 6;
private _type = _this select 7;
diag_log format ['*********** the type= %1 *************', _type];
private _numberOfgroupstospawn = floor  (2 + random 3);
private _state = 'AUtoASSIGNED';
private _owner = WEST;
private _priority = -1;
private _locationCount = count _nearbyLocations;
private _resultsArray = [];
hint format ['trigger: %1', _trigger];

private _spawnedCount = 0;
private _tries = 0;

// This should be moved to external file for higher level scope
private _setPatrol = {
	params ['_group', '_pos', '_radius'];
	if( isNil 'lambs_wp_fnc_taskGarrison') then {
		[_group, _pos, _radius] call BIS_fnc_taskPatrol;
	} else {
		[_group, _pos, _radius] call lambs_wp_fnc_taskPatrol;
	};
};

private _setGarrison = {
	params ['_group', '_pos', '_radius'];
	if( isNil 'lambs_wp_fnc_taskGarrison') then {
		[_group, _pos, _radius] call BIS_fnc_taskDefend;
	} else {
		[_group, _pos, _radius, [], false, true, -1, true] call lambs_wp_fnc_taskGarrison;
	};
};

{
	private _basePos = getMarkerPos _x;
	private _baseTriggerDistance = _basePos distance _trigger;

	if (_basePos inArea _trigger) then {
		private _groupName = format ['enemyGroup_%1', _x];
		private _eastGroup = createGroup [east, false];
		_eastGroup setGroupId [_groupName];
		_eastGroup = [_eastGroup, (8 + random 4), RED_units_ARRAY, _basePos] call jMD_fnc_spawnGroups;

		[_eastGroup, _basePos, 100] call _setGarrison;

		continue;
	};

	private _inActiveTrigger = 0;

	{
		private _outsideTrigger = call compile _x;
		if (_basePos inArea _outsideTrigger) then {
			_inActiveTrigger = _inActiveTrigger + 1;
		};
	} forEach RED_TRIGGERS;

	if ((_inActiveTrigger > 0) && (_baseTriggerDistance < 5000)) then {
		private _groupName = format ['enemyGroup_%1', _x];
		private _eastGroup = createGroup [east, false];
		_eastGroup setGroupId [_groupName];
		_eastGroup = [_eastGroup, (8 + random 4), RED_units_ARRAY, _basePos] call jMD_fnc_spawnGroups;

		[_eastGroup, _basePos, 100] call _setGarrison;
		_eastGroup  enableDynamicSimulation true;
	};

} forEach ALL_BASES;

while {_spawnedCount < _numberOfGroupsToSpawn} do {
	private ['_position', '_groupName', '_waypointScript', '_wp', '_selectedLocation', '_eastGroup', '_westGroup', '_missionName'];
	
	_selectedLocation = _nearbyLocations call BIS_fnc_selectRandom;
	_nearbyLocations deleteAt (_nearbyLocations find _selectedLocation);
	_resultsArray pushBack _selectedLocation;
	_westGroup = FRIendlY_groupS select _spawnedCount;
	_missionName = ['Combat Patrol'] call missionNamer;
	diag_log ['the mission name', _missionName];
	group_count = group_count + 1;
	
	_groupName = format ['enemyGroup_%1', group_count];
	_eastGroup = createGroup [east, false];
	_eastGroup setGroupId [_groupName];
	
	if (_usePosition) then {
			_position = position _selectedLocation;
	} else {
			_position = locationPosition _selectedLocation;
	};
	
	_eastGroup = [_eastGroup, (_groupSize + random 4), RED_units_ARRAY, _position] call jMD_fnc_spawnGroups;
	
	_wp = _eastGroup addWaypoint [_position, 200];
	_wp setWaypointBehaviour 'SAFE';
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

	[_eastGroup, _position, _areaRadius] call _setGarrison;
	// if( isNil 'lambs_wp_fnc_taskGarrison') then {
	// 	[_eastGroup, _position, 200] call BIS_fnc_taskDefend;
	// } else {
	// 	[_eastGroup, _position, 200, [], false, true, -1, true] call lambs_wp_fnc_taskGarrison;
	// };
	// creating diary record and task
	private ['_childTasIdk', '_description', '_completedChildren', '_activation', '_statement'];
	_childTasIdk = _missionName;
	_description = [format['An enemy group was spotted here. Seek them out and eliminate them.<br />Mission codename: %1', _missionName], _missionName, _selectedLocation];
	_activation = format['["%1", "SUCCEEDED"] call BIS_fnc_tasksetState;', _childTasIdk];
	
	/*
	0: group performing action, either unit <OBJECT> or group <group>
	1: position being searched, default group position <OBJECT or ARRAY>
	2: Range of tracking, default is 200 meters <NUMBER>
	3: Waypoint count, default 4 <NUMBER>
	4: Area the AI Camps in, default [] <ARRAY> 5: Dynamic patrol pattern, default false <BOOL>
	
	[bob, bob, 500] call lambs_wp_fnc_taskPatrol;
	*/
	if (! (isnil '_westGroup')) then {
		// hint format['found group %1', _westGroup];
		[_westGroup, _position, _areaRadius] call _setPatrol;
	};
	diag_log [_childTasIdk, _parentTaskId];
	[_owner, [_childTasIdk, _parentTaskId], _description, _position, _state, _priority, _shownotification, _type, _visiblein3D] call BIS_fnc_taskCreate;

	switch (_type) do {
		case "move": { 
			[_position, _childTasIdk, _numberOfGroupsToSpawn] execVM 'functions\patrolTracker.sqf';
		};
		default { 
			[_eastGroup, _childTasIdk, _numberOfGroupsToSpawn] execVM 'functions\groupTracker.sqf';
		};
	};

	_eastGroup  enableDynamicSimulation true;
	
	private _diaryTitle = format['Trigger %1 created:', _trigger];
	player createDiaryRecord ['taskRecord', [_diaryTitle, format['this is the marker found: %1', _selectedLocation]]];
	player createDiaryRecord ['taskRecord', [_diaryTitle, format['This is the current group count: %1', ({
			alive _x
	} count units _eastGroup)]]];
	player createDiaryRecord ['taskRecord', [_diaryTitle, format['This is the current group name: %1', _groupName]]];
	player createDiaryRecord ['taskRecord', [_diaryTitle, format['This is the current group id: %1', groupId _eastGroup]]];
	
	_spawnedCount = _spawnedCount + 1;
};

_resultsArray