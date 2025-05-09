// creates enemy groups and sets them to patrol or garison near their spawn marker
// [trigger, group size] call jMD_fnc_sectorspawn

private _trigger	 = _this select 0;
private _groupSize	 = _this select 1;
private _nearbyLocations = _this select 2;
private _usePosition = _this select 3;
private _areaRadius = _this select 4;
private _numberOfGroupsToSpawn = floor  (3 + random 3);
private _locationCount = count _nearbyLocations;
private _resultsArray = [];
private _locationsArray = [];
hint format ['trigger: %1', _trigger];

private _spawnedCount = 0;
private _groups = [];

private _validPlaces = selectBestPlaces [(position _trigger), (sectorSize / 2), "(2*houses) - (10 * sea) ", 1, 50];
private _validPlacesCount = { 
	if ((_x select 1) > 0.8) then {
		_locationsArray pushBack (_x select 0);
	};
} forEach _validPlaces;


// populate bases  
[_trigger] execVM 'functions\spawners\baseSpawner.sqf';

// selecting a location to spawn {_numberOfGroupsToSpawn} groups 
while {_spawnedCount < _numberOfGroupsToSpawn} do {
	private ['_position', '_groupName', '_waypointScript', '_wp', '_selectedLocation', '_eastGroup', '_westGroup', '_missionName'];

	// define west group
	_westGroup = FRIendlY_groupS select _spawnedCount;
	if (isnil '_westGroup') then {
		_westGroup = FRIendlY_groupS select 0;
	};

	// select a single location from {_nearbyLocations}
	_selectedLocation = _locationsArray call BIS_fnc_selectRandom;
	_locationsArray deleteAt (_locationsArray find _selectedLocation);
	
	// name the mission 
	_missionName = ['Combat Patrol'] call missionNamer;
	diag_log ['the mission name', _missionName];


	group_count = group_count + 1;
	_groupName = format ['enemyGroup_%1', group_count];
	_eastGroup = createGroup [east, false];
	_eastGroup setGroupId [_groupName];

	_position = _selectedLocation;

	diag_log 'calling spawn groups from sectorSpawn 3';

	if (WEST_SPAWN distance _position < 200) exitWith {
		diag_log "position too close, skipping";
		diag_log (WEST_SPAWN distance _position) ;
		continue;
	};

	diag_log "Found a position far enough away!";

	_resultsArray pushBack _position;

	_eastGroup = [_eastGroup, (_groupSize + random 4), RED_units_ARRAY, _position] call jMD_fnc_spawnGroups;
	_groups pushBack [_eastGroup, _position];
	
	_wp = _eastGroup addWaypoint [_position, 200];
	_wp setWaypointBehaviour 'SAFE';

	[_eastGroup, _position, _areaRadius, 'garrison'] call jMD_fnc_setOrders;
	
	// creating diary record and task
	private ['_childTasIdk', '_description', '_completedChildren', '_activation', '_statement'];
	_childTasIdk = _missionName;
	_description = [format['Enemy soldiers were spotted near the marked location. Patrol the area and engage any units you come across.<br />Mission codename: %1', _missionName], _missionName, _selectedLocation];
	_activation = format['["%1", "SUCCEEDED"] call BIS_fnc_tasksetState;', _childTasIdk];
	
	if (! (isnil '_westGroup')) then {
		[_westGroup, _position, _areaRadius, 'patrol'] call jMD_fnc_setOrders;
	};
	
	_spawnedCount = _spawnedCount + 1;
};

SECTOR_GROUPS = _groups;

_resultsArray