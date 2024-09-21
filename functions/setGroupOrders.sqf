params ['_group', '_pos', '_radius', '_orders'];

/**
Task Patrol
0: Group performing action, either unit <OBJECT> or group <GROUP>
1: Position being searched, default group position <OBJECT or ARRAY>
2: Range of tracking, default is 200 meters <NUMBER>
3: Waypoint Count, default 4 <NUMBER>
4: Area the AI Camps in, default [] <ARRAY> 5: Dynamic patrol pattern, default false <BOOL>
*/

private _setPatrol = {
	params ['_group', '_pos', '_radius'];
	if( isNil 'lambs_wp_fnc_taskGarrison') then {
		[_group, _pos, _radius] call BIS_fnc_taskPatrol;
	} else {
		[_group, _pos, _radius] call lambs_wp_fnc_taskPatrol;
	};
};
/**
Task Garrison
0: Group performing action, either unit <OBJECT> or group <GROUP>
1: Position to occupy, default group location <ARRAY or OBJECT>
2: Range of tracking, default is 50 meters <NUMBER>
3: Area the AI Camps in, default [] <ARRAY>
4: Teleport Units to Position <BOOL>
5: Sort Based on Height <BOOL>
6: Exit Conditions that breaks a Unit free (-2 Random, -1 All, 0 None, 1 Hit, 2 Fired, 3 FiredNear, 4 Suppressed), default -2 <NUMBER>
7: Sub-group patrols the area <BOOL>
 */

private _setGarrison = {
	params ['_group', '_pos', '_radius'];
	if( isNil 'lambs_wp_fnc_taskGarrison') then {
		[_group, _pos, _radius] call BIS_fnc_taskDefend;
	} else {
		[_group, _pos, _radius, [], false, true, -1, true] call lambs_wp_fnc_taskGarrison;
	};
};

/**
Task Camp
0: Group performing action, either unit <OBJECT> or group <GROUP>
1: Central position camp should be made, <ARRAY>
2: Range of patrols and turrets found, default is 50 meters <NUMBER>
3: Area the AI Camps in, default [] <ARRAY>
4: Teleport Units to Position <BOOL>
5: Partial group Patrols the Area <BOOL>

[bob, getPos bob, 50] call lambs_wp_fnc_taskCamp;
*/

private _setCamp = {
	params ['_group', '_pos', '_radius'];
	if( isNil 'lambs_wp_fnc_taskGarrison') then {
		[_group, _pos, _radius] call BIS_fnc_taskDefend;
	} else {
		[_group, _pos, _radius, [], false, true] call lambs_wp_fnc_taskCamp;
	};
};

/**

Arguments:
0: Unit fleeing <OBJECT>
1: Destination <ARRAY>
2: Forced retreat, default false <BOOL>
3: Distance threshold, default 10 <NUMBER>
4: Update cycle, default 2 <NUMBER>
5: Is Called for Waypoint, default false <BOOLEAN>

[bob, getPos angryJoe] spawn lambs_wp_fnc_taskAssault;
 */

 private _attack = {
	params ['_group', '_pos', '_radius'];
	if( isNil 'lambs_wp_fnc_taskAssault') then {
		[_group, _pos, _radius] call BIS_fnc_taskAttack;
	} else {
		[_group, _pos, false, _radius] call lambs_wp_fnc_taskAssault;
	};
 };

private _orders = toLower _orders;

switch (_orders) do {
	case 'patrol': { [_group, _pos, _radius] call _setPatrol; };
	case 'garrison': { [_group, _pos, _radius] call _setGarrison; };
	case 'camp': { [_group, _pos, _radius] call _setCamp; };
	case 'attack': { [_group, _pos, _radius] call _attack; };
	default { };
};