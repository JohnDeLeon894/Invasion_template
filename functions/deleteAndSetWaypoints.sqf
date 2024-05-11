// get group waypoints and delete them
// [_group, _radious, _position, _delete, _setScript] call jMD_fnc_deleteAndSetWaypoints
private _group = _this select 0;
private _radious = _this select 1;
private _position = _this select 2;
private _delete = _this select 3;
private _setScript = _this select 4;
if(_delete) then{
	while {(count (waypoints _group)) > 0} do
	{
	deleteWaypoint ((waypoints _group) select 0);
	};
};

//create new Waypoints 
private _wp = _group addWaypoint[_position, _radious];

if(_setScript) then {
	[_group, (count waypoints _group) - 1 ]setWaypointScript "\z\lambs\addons\wp\scripts\fnc_wpGarrison.sqf";
	_wp setWaypointBehaviour 'SAFE';
	// _wp setWaypointType 'DISMISS';
};