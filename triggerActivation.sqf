private _trigger = _this select 0;
private _thisList = _this select 1;
private _count = _this select 2; 
private _namedSector = _this select 3;
diag_log _namedSector;
private _triggerName = str _trigger;
diag_log format ['*** the trigger name from trigger activation %1 ***',_triggerName];
private _useSectorName = !isNil '_namedSector';
diag_log _useSectorName;
private _owner = WEST;
private _parentTaskId = format['Clear %1', _namedSector]; 
private _description = [
	format['Enemies detected in %1', [_trigger, _namedSector] select _useSectorName], 
	[format['Clear %1', _trigger], format['Assault %1', _namedSector]] select _useSectorName, 
	position _trigger
];
private _state = 'AUTOASSIGNED';
private _priority = -1;
private _showNotification = true;
private _type = "attack";
private _visibleIn3D = false;
private _diaryTitle = format['Trigger %1 Activated', _trigger];
private _isPlayerInList = ( _thisList findIf{ _x == player}) > 0;
private _isPlayerWaypointInList = (waypoints player findIf{ [_trigger,waypointPosition _x] call BIS_fnc_inTrigger }) >= 0;
private _allLocationTypes = LOCATION_TYPES;
private _triggerAreaRadius = ( triggerArea _trigger select 0 );
private _triggerArea = [triggerArea _trigger select 0, triggerArea _trigger select 1];
private _activePositions = [];
// "_allLocationTypes pushBack configName _x" configClasses (configFile >> "CfgLocationTypes");
private _nearbyLocations = nearestLocations [position _trigger, _allLocationTypes, _triggerAreaRadius];
private _isTooFewLocations = count _nearbyLocations < 10; 
// private _isTooFewLocations = true ; 
if (_isTooFewLocations) then {
	_nearbyLocations = position _trigger nearObjects ['House', _triggerAreaRadius];
};
if (!_useSectorName) then {
	_type = 'move';
	PATROL_COMPLETE = 0;
	diag_log format ['*********** the type in triggerActivation = %1 *************', _type];
} else {
	GROUPS_KILLED = 0;
	diag_log format ['*********** the type in triggerActivation = %1 *************', _type];
};
player createDiarySubject['taskRecord', 'Task Record'];
[_owner, _parentTaskId, _description, objNull, _state, _priority, _showNotification, _type, _visibleIn3D] call BIS_fnc_taskCreate;

_activePositions = [_trigger, _count, _nearbyLocations, _isTooFewLocations, _triggerAreaRadius, _parentTaskId, _useSectorName, _type] call jMD_fnc_sectorSpawn;

// hint format['this is the trigger %1',_trigger];

// player createDiaryRecord ['taskRecord',[_diaryTitle, format['this is the trigger activated: %1', _trigger]]];
// player createDiaryRecord ['taskRecord',[_diaryTitle, format['this is the trigger List: %1', _thisList]]];
// player createDiaryRecord ['taskRecord',[_diaryTitle, format['Does the player have a waypoint in triggert: %1', _isPlayerWaypointInList]]];
// player createDiaryRecord ['taskRecord',[_diaryTitle, format['Is the player in the trigger List: %1', _isPlayerInList]]];
// player createDiaryRecord ['taskRecord',[_diaryTitle, format['Is too few locations: %1', _isTooFewLocations]]];
// player createDiaryRecord ['taskRecord',[_diaryTitle, format['Trigger area radius: %1', _triggerAreaRadius]]];
player createDiaryRecord ['taskRecord',[_diaryTitle, format['Nearest Locations List: %1/nLocations returned: %2; /nlist / returned location counts %3 / %4', _nearbyLocations, _activePositions, count _nearbyLocations, count _activePositions]]];

player createDiaryRecord ['taskRecord',[_diaryTitle, format['This will only show up if %1 evaluates to true.',_isPlayerWaypointInList]]];

if ((count waypoints group player) > 1) then {
	{
		deleteWaypoint [ group player, waypoints group player find _x ];
	} forEach waypoints group player;
};

// {
// 	private [ '_destination'];
// 	if (_isTooFewLocations) then {
// 		_destination = position _x;
// 	} else {
// 		_destination = (locationPosition _x);
// 	};

// 	{
// 		private _group = _x;
// 		[_x, 50, _destination, false, false] call jMD_fnc_deleteAndSetWaypoints;
// 	} forEach FRIENDLY_GROUPS; 

// 	[group player, 50, _destination, false, false] call jMD_fnc_deleteAndSetWaypoints;

// // } forEach EAST_POSITIONS;
// } forEach _activePositions;


// private _aoMarker = createMarker[format['%1', _trigger], position _trigger];
// _aoMarker setMarkerBrush 'CROSS';
// _aoMarker setMarkerShape 'RECTANGLE';
// _aoMarker setMarkerSize _triggerArea;
// _aoMarker setMarkerColor 'ColorOrange';
_aoMarker = str _trigger;

sectorTrigger = createTrigger['EmptyDetector', position _trigger];
private _sectorTriggerActivation = format['"%1" setMarkerColor "ColorRed"; ON_MISSION = TRUE;', _aoMarker];
private _sectorTriggerDeactivation = format [
	'"%1" setMarkerColor "ColorGreen"; 
	["%2",  "SUCCEEDED"] call BIS_fnc_taskSetState; 
	ON_MISSION = FALSE; 
	["%3"] execvm "functions\endMission.sqf"; 
	deletevehicle thisTrigger;
	', _aoMarker, _parentTaskId, _triggerName];
sectorTrigger setTriggerArea [_triggerArea select 0, _triggerArea select 1, 0,true];
switch (_type) do {
	case "move": { 
		sectorTrigger setTriggerActivation ['none', 'PRESENT', true];
		sectorTrigger setTriggerStatements ['true', _sectorTriggerActivation, _sectorTriggerDeactivation];	
	};
	default {
		sectorTrigger setTriggerActivation ['none', 'PRESENT', true];
		sectorTrigger setTriggerStatements ['true', _sectorTriggerActivation, _sectorTriggerDeactivation];	
	 };
};

diag_log format ["the trigger activation string: %1 /br the sector trigger deactivation %2 ", _sectorTriggerActivation, _sectorTriggerDeactivation];

// ALL_TRIGGERS deleteAt (ALL_TRIGGERS find (str _trigger));

deleteVehicle _trigger;

diag_log 'sector activation end';
/*
Strategic
StrongpointArea
FlatArea
FlatAreaCity
FlatAreaCitySmall
CityCenter
Airport
NameMarine
NameCityCapital
NameCity
NameVillage
NameLocal
Hill
ViewPoint
*/