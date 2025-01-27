private _trigger = _this select 0;
private _thisList = _this select 1;
private _count = _this select 2; 
private _namedSector = _this select 3;
// diag_log _namedSector;
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

private _sectorName = format['%1', [_trigger, _namedSector] select _useSectorName];
private _isControlSector = 'control' in (toLower _sectorName); 
private _state = 'AUTOASSIGNED';
private _priority = -1;
private _showNotification = true;
private _type = "attack";
private _visibleIn3D = false;
// private _diaryTitle = format['Trigger %1 Activated', _trigger];
private _isPlayerInList = ( _thisList findIf{ _x == player}) > 0;
private _isPlayerWaypointInList = (waypoints player findIf{ [_trigger,waypointPosition _x] call BIS_fnc_inTrigger }) >= 0;
private _allLocationTypes = LOCATION_TYPES;
private _triggerAreaRadius = ( triggerArea _trigger select 0 );
private _triggerArea = [triggerArea _trigger select 0, triggerArea _trigger select 1];
private _activePositions = [];

// getting locations within trigger radious
private _nearbyLocations = nearestLocations [position _trigger, _allLocationTypes, _triggerAreaRadius];
private _isTooFewLocations = count _nearbyLocations < 10; 
// private _isTooFewLocations = true ; 
if (_isTooFewLocations) then {
	_nearbyLocations = position _trigger nearObjects ['House', _triggerAreaRadius];
};

_activePositions = [_trigger, _count, _nearbyLocations, _isTooFewLocations, _triggerAreaRadius, _parentTaskId, _useSectorName, _type] call jMD_fnc_sectorSpawn;

// deligate mission assignment 
[ _activePositions, _sectorName, _sectorName ]execVM 'functions\taskManagement\taskManager.sqf';

// don't know if this is needed
// if ((count waypoints group player) > 1) then {
// 	{
// 		deleteWaypoint [ group player, waypoints group player find _x ];
// 	} forEach waypoints group player;
// };

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