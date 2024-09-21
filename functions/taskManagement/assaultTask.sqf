// setup group counter 
GROUPS_KILLED = 0;
private _spawnLocations = _this select 0;
private _sectorName = _this select 1;

//Create diary record for the parent task 
private ['_owner', '_parentTaskId', '_description', '_state', '_priority', '_showNotification', '_type', '_visibleIn3D'];

_owner = WEST;
_parentTaskId = format['Clear %1', _sectorName];
_state = 'AUTOASSIGNED';
_showNotification = true;
_type = "attack";
_visibleIn3D = false;
_description = [
	format['Enemies detected in %1', _sectorName], 
	format['Assault %1', _sectorName], 
	SECTOR_POS
];
_priority = -1;

[_owner, _parentTaskId, _description, objNull, _state, _priority, _showNotification, _type, _visibleIn3D] call BIS_fnc_taskCreate;
// create child task for each group spawned 

{
	private _group = _x select 0;
	private _position = _x select 1;
	diag_log ['the group, and the position:', _group, _position];
	_missionName = ['Assault Mission'] call missionNamer;
	_childTasIdk = _missionName;
	_description = [
		format['Enemy soldiers were spotted near the marked location. Patrol the area and engage any units you come across.<br />Mission codename: %1',_missionName], 
		_missionName, 
		_position
	];
	// diag_log ['the mission name', _missionName];
	[_owner, [_childTasIdk, _parentTaskId], _description, _position, _state, _priority, _showNotification, _type, _visibleIn3D] call BIS_fnc_taskCreate;
	[_group, _childTasIdk, (count SECTOR_GROUPS)] execVM 'functions\groupTracker.sqf';
} forEach SECTOR_GROUPS;

//	[_owner, [_childTasIdk, _parentTaskId], _description, _position, _state, _priority, _shownotification, _type, _visiblein3D] call BIS_fnc_taskCreate;
// create diary record for each child