private _spawnLocations = _this select 0;
private _sectorName = _this select 1;
private _locationCount = count _spawnLocations;
PATROL_COMPLETE = 0;

//Create diary record for the parent task 
private ['_owner', '_parentTaskId', '_description', '_state', '_priority', '_showNotification', '_type', '_visibleIn3D'];

_owner = WEST;
_parentTaskId = format['Combat Patrol %1', _sectorName];
_state = 'AUTOASSIGNED';
_showNotification = true;
_type = "move";
_visibleIn3D = false;
_description = [
	format['Its been quiet around %1. Patrol the area and see if you run into any enemy.', [sectorTrigger, _sectorName] select _useSectorName], 
	format['Patrol %1', _sectorName], 
	position sectorTrigger
];
_priority = -1;

[_owner, _parentTaskId, _description, objNull, _state, _priority, _showNotification, _type, _visibleIn3D] call BIS_fnc_taskCreate;

{
	// current iterable is _x 
	private _position = _x;
	private _missionName = TEXAS_CITIES call BIS_fnc_selectRandom;
	_missionName = _missionName;
	_description = [format['Enemy soldiers were spotted near the marked location. Patrol the area and engage any units you come across.<br />Mission codename: %1', _missionName], _missionName, _selectedLocation];

	[_owner, [_missionName, _parentTaskId], _description, _position, _state, _priority, _shownotification, _type, _visiblein3D] call BIS_fnc_taskCreate;
	[_position, _missionName, _locationCount] execVM 'functions\patrolTracker.sqf';

} forEach _spawnLocations;