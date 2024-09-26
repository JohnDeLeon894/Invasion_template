//This is the loop that continuously spawns soldiers until continueLoop = false

diag_log 'Spawn loop started';
if (!continueLoop) exitWith {
	hint 'loop stopped'
};
// if (ONE_LOOP == true) exitWith {
// 	hint 'instance of loop already running'
// };

// ONE_LOOP = true;
SPAWN_LOOP_COUNT = SPAWN_LOOP_COUNT + 1;
// 'westSpawn' setMarkerPos position mobileSpawn;
private _song = [ 
	'extremeTrapRacingMusic', 
	'dragonCastle', 
	'powerfulTrapy',
	'theArmyOfMinotaur', 
	'computerGameIdra',
	'chillHipHop',
	'enigma',
	'deflector',
	'downtownGlow',
	'urbanHipHop',
	'whiteBatBroken',
	'whiteBatCultoftheskull',
	'whiteBatDarkAngel',
	'whiteBatDrive',
	'whiteBatFightLikeHell',
	'whiteBatHardware',
	'whiteBatHauntingoftheFlesh',
	'whiteBatLicenseToKill',
	'whiteBatPlagueRat',
	'whiteBatPrisonPlanet',
	'whiteBatRedux',
	'whiteBatTornFlesh',
	'whiteBatXenomorph'
]  call BIS_fnc_selectRandom;
hint _song; 
playMusic _song;
//declare groups to count

{
	// Current result is saved in variable _x
	private _count = {alive _x} count units _x;
	private _spawnPoint = EAST_SPAWN;
	private _spawnNumber = (RED_UNIT_SIZE - _count);
	diag_log format ['spawining %1 east units for group %2', _spawnNumber, _x];
	private _results =  [_x, (RED_UNIT_SIZE - _count), RED_UNITS_ARRAY, _spawnPoint] call  jMD_fnc_spawnGroups;
	// private _waypoints = [_x, 200, _location, true, true] call jMD_fnc_deleteAndSetWaypoints;
		/*
	0: Group performing action, either unit <OBJECT> or group <GROUP>
	1: Range of tracking, default is 500 meters <NUMBER>
	2: Delay of cycle, default 15 seconds <NUMBER>
	3: Area the AI Camps in, default [] <ARRAY>
	4: Center Position, if no position or Empty Array is given it uses the Group as Center and updates the position every Cycle, default [] <ARRAY>
	5: Only Players, default true <BOOL>
	*/
	// [_x, 1000, 60] spawn lambs_wp_fnc_taskHunt;
	// [_x, _spawnPoint, 200, [], false, true, -1, true] call lambs_wp_fnc_taskGarrison;

	/*
	* Author: nkenny
	* Simple dynamic patrol script by nkenny
	*          Suitable for infantry units (not so much vehicles, boats or air-- that will have to wait!)
	*
	* Arguments:
	* 0: Group performing action, either unit <OBJECT> or group <GROUP>
	* 1: Position being searched, default group position <OBJECT or ARRAY>
	* 2: Range of tracking, default is 200 meters <NUMBER>
	* 3: Waypoint Count, default 4  <NUMBER>
	* 4: Area the AI Camps in, default [] <ARRAY>
	* 5: Dynamic patrol pattern, default false <BOOL>
	* 6: enable dynamic reinforcement <BOOL>
	*
	* Return Value:
	* none
	*
	* Example:
	* [bob, getPos bob, 500] call lambs_wp_fnc_taskPatrol;
	*
	* Public: Yes
	*/

	if( isNil 'lambs_wp_fnc_taskGarrison') then {
		[_x, TRIGGER_POS, 200] call BIS_fnc_taskPatrol;
	} else {
		[_x, TRIGGER_POS, 200, 5, [], true, true] call lambs_wp_fnc_taskPatrol;
		_x setVariable ["lambs_danger_enableGroupReinforce", true, true];
	};

	_x enableDynamicSimulation true;
} forEach ENEMY_GROUPS;

{
	// Current result is saved in variable _x
	scopeName 'unitSpawn';
	private _groupSize = BLU_UNIT_SIZE; // desired size of each group
	private _count = {alive _x}count units _x;
	private _group = _x;
	private _results =  [_group, (_groupSize - _count), BLU_UNITS_ARRAY, WEST_SPAWN] call  jMD_fnc_spawnGroups;
	private _timer = 0;

	while { (({alive _x}count units _group) < _groupSize) && (_group != group player) } do {
		_timer = _timer + 1;
		private _count = {alive _x}count units _group;
		private _results =  [_group, (_groupSize - _count), BLU_UNITS_ARRAY, WEST_SPAWN] call  jMD_fnc_spawnGroups;
		if (_timer > 255) then { breakTo 'unitSpawn'};
	};
	if (doOnce < count FRIENDLY_GROUPS) then {
		_x setBehaviour 'SAFE';
		FRIENDLY_GROUPS deleteAt(FRIENDLY_GROUPS find group player);
		doOnce = doOnce +1;
	};

	[_x, 'lambs_danger_OnInformationShared', {
    	params ['_unit', '_group', '_target', '_groups'];
		[_unit, _group, _target, _groups] execVM 'functions\enemySpottedCallOut.sqf';
	}] call BIS_fnc_addScriptedEventHandler;
} forEach FRIENDLY_GROUPS;

_vehicleType = RED_VEHICLE_ARRAY call BIS_fnc_selectRandom;
_veh = [ EAST_VEHICLE_SPAWN, 330, _vehicleType, east] call BIS_fnc_spawnVehicle;

_bluVehicleType = BLU_VEHICLE_ARRAY call BIS_fnc_selectRandom;
_bluVeh = [ WEST_VEHICLE_SPAWN, 330, _bluVehicleType, WEST] call BIS_fnc_spawnVehicle;
_bluVehGroup = _bluVeh select 2;

_bluVehGroup setVariable ["lambs_danger_enableGroupReinforce", true, true];

if( isNil 'lambs_wp_fnc_taskGarrison') then {
	[_bluVehGroup, TRIGGER_POS, 500] call BIS_fnc_taskPatrol;
} else {
	[_bluVehGroup, TRIGGER_POS, 500] call lambs_wp_fnc_taskPatrol;
};

_bluVehGroup setVariable ["lambs_danger_enableGroupReinforce", true, true];

// hint format['Created vehicle %1', _veh select 0];
_veh params ["_vehicle", "_crew", "_vehGroup"];
_vehGroup setBehaviour 'SAFE';
_seatsAvailable = [_vehicleType, true] call BIS_fnc_crewCount;
diag_log [_seatsAvailable, 'seats available'];
diag_log [count units _vehGroup, 'in', _vehGroup];
diag_log [_seatsAvailable - (count units _vehGroup), 'this should be the number to spawn'];
[_vehGroup, (_seatsAvailable - (count units _vehGroup)), RED_UNITS_ARRAY, EAST_VEHICLE_SPAWN, 'CARGO'] call  jMD_fnc_spawnGroups;

if( isNil 'lambs_wp_fnc_taskGarrison') then {
	[_vehGroup, TRIGGER_POS, 500] call BIS_fnc_taskPatrol;
} else {
	[_vehGroup, TRIGGER_POS, 500] call lambs_wp_fnc_taskPatrol;
};

if ((SPAWN_LOOP_COUNT mod 3) == 0) then {
	_vehicleType = RED_VEHICLE_ARRAY call BIS_fnc_selectRandom;
	private _veh2SpawnPos = [EAST_VEHICLE_SPAWN select 0, (EAST_VEHICLE_SPAWN select 1) + 10];
	private _veh2 = [_veh2SpawnPos, 330, _vehicleType, east] call BIS_fnc_spawnVehicle;
	_veh2 params ["_vehicle", "_crew", "_vehGroup2"];

	_vehGroup2 setBehaviour 'SAFE';

	if( isNil 'lambs_wp_fnc_taskGarrison') then {
		[_vehGroup2, TRIGGER_POS, 500] call BIS_fnc_taskPatrol;
	} else {
		[_vehGroup2, TRIGGER_POS, 500] call lambs_wp_fnc_taskPatrol;
	};

	_seatsAvailable = [_vehicleType, true] call BIS_fnc_crewCount;
	[_vehGroup2, (_seatsAvailable - (count units _vehGroup2)), RED_UNITS_ARRAY, EAST_VEHICLE_SPAWN, 'CARGO'] call  jMD_fnc_spawnGroups;

	_vehicleType = RED_VEHICLE_ARRAY call BIS_fnc_selectRandom;

	private _veh3SpawnPos =  [EAST_VEHICLE_SPAWN select 0, (EAST_VEHICLE_SPAWN select 1) - 10];
	private _veh3 = [  _veh3SpawnPos, 330, _vehicleType, east] call BIS_fnc_spawnVehicle;
	_veh3 params ["_vehicle", "_crew", "_vehGroup3"];
	// hint format['Created vehicle %1', _veh3 select 0];
	_vehGroup3 setBehaviour 'SAFE';

	if( isNil 'lambs_wp_fnc_taskGarrison') then {
		[_vehGroup3, TRIGGER_POS, 500] call BIS_fnc_taskPatrol;
	} else {
		[_vehGroup3, TRIGGER_POS, 500] call lambs_wp_fnc_taskPatrol;
	};
	
	_seatsAvailable = [_vehicleType, true] call BIS_fnc_crewCount;
	[_vehGroup3, (_seatsAvailable - (count units _vehGroup3)), RED_UNITS_ARRAY, EAST_VEHICLE_SPAWN, 'CARGO'] call  jMD_fnc_spawnGroups;
};
if ((SPAWN_LOOP_COUNT mod 5) == 0) then {
	_TankType = RED_TANK_ARRAY call BIS_fnc_selectRandom;
	private _tankSpawnPos = [(EAST_VEHICLE_SPAWN select 0)  + 10, EAST_VEHICLE_SPAWN select 1];
	private _tank = [  _tankSpawnPos, 330, _vehicleType, east] call BIS_fnc_spawnVehicle;
	// hint format['Created vehicle %1', _veh select 0];
	__tankGroup2 = _tank select 2;
	__tankGroup2 setBehaviour 'SAFE';
	
	if( isNil 'lambs_wp_fnc_taskGarrison') then {
		[__tankGroup2, TRIGGER_POS, 500] call BIS_fnc_taskPatrol;
	} else {
		[__tankGroup2, TRIGGER_POS, 500] call lambs_wp_fnc_taskPatrol;
	};

	_bluVehicleType = BLU_TANK_ARRAY call BIS_fnc_selectRandom;
	private _bluTankSpawn = [(WEST_VEHICLE_SPAWN select 0)  + 10, WEST_VEHICLE_SPAWN select 1];
	_bluVeh = [ _bluTankSpawn, 330, _bluVehicleType, WEST] call BIS_fnc_spawnVehicle;
	_bluVehGroup = _bluVeh select 2;
	
	if( isNil 'lambs_wp_fnc_taskGarrison') then {
		[_bluVehGroup, TRIGGER_POS, 500] call BIS_fnc_taskPatrol;
	} else {
		[_bluVehGroup, TRIGGER_POS, 500] call lambs_wp_fnc_taskPatrol;
	};
};

diag_log 'deleting the dead';
{ if (_x distance player > 300) then { deleteVehicle _x}} forEach allDeadMen;

// check to see if all support assets are still alive

[] call jMD_fnc_choppaCheck;

// if asset is damaged and away from base...
	// if crew is alive, repair asset and order to return to base waypoint
	// if crew is dead, spawn new crew and order them to asset and to bring it back to base. 

diag_log 'Spawn loop end';
sleep 900; //1200 = 20 min
diag_log 'Spawn Timer End';
// saveGame;
// ONE_LOOP = false;
diag_log 'starting spawn loop again';
[] spawn jMD_fnc_spawnLoop;