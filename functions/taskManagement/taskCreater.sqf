//Create diary record for the parent task 
private ['_owner', '_parentTaskId', '_description', '_state', '_priority', '_showNotification', '_type', '_visibleIn3D'];

_parentTaskId = _this select 0;
_type = _this select 1;
_description = _this select 2;
_position = _this select 3;
_owner = WEST;
// _parentTaskId = format['Clear %1', _sectorName];
_state = 'AUTOASSIGNED';
_showNotification = true;
// _type = "attack";
_visibleIn3D = false;
// _description = [
// 	format['Enemies detected in %1', _sectorName], 
// 	format['Assault %1', _sectorName], 
// 	SECTOR_POS
// ];
_priority = -1;

[_owner, _parentTaskId, _description, _position, _state, _priority, _showNotification, _type, _visibleIn3D] call BIS_fnc_taskCreate;