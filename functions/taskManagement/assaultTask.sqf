// setup group counter 
GROUPS_KILLED = 0;
private _spawnLocations = _this select 0;
private _sectorName = _this select 1;

//Create diary record for the parent task 

private _parentTaskId = format['Clear %1', _sectorName];
private _type = "attack";
private _description = [
	format['Enemies detected in %1', _sectorName], 
	format['Assault %1', _sectorName], 
	SECTOR_POS
];
_priority = -1;

[_parentTaskId, _type, _description] execVM "functions\taskManagement\taskCreater.sqf";
// create child task for each group spawned 

{
	private _group = _x select 0;
	private _position = _x select 1;
	private _type = "attack";
	diag_log ['the group, and the position:', _group, _position];
	_missionName = ['Assault Mission'] call missionNamer;
	_childTasIdk = _missionName;
	_description = [
		format['Enemy soldiers were spotted near the marked location. Patrol the area and engage any units you come across.<br />Mission codename: %1',_missionName], 
		_missionName, 
		_position
	];
	// diag_log ['the mission name', _missionName];
	// [_owner, [_childTasIdk, _parentTaskId], _description, _position, _state, _priority, _showNotification, _type, _visibleIn3D] call BIS_fnc_taskCreate;
	[ [_childTasIdk, _parentTaskId], _type, _description, _position] execVM "functions\taskManagement\taskCreater.sqf";
	[_group, _childTasIdk, (count SECTOR_GROUPS)] execVM 'functions\groupTracker.sqf';
} forEach SECTOR_GROUPS;

//	[_owner, [_childTasIdk, _parentTaskId], _description, _position, _state, _priority, _shownotification, _type, _visiblein3D] call BIS_fnc_taskCreate;
// create diary record for each child