/*
onMapSingleClick '
onMapSingleClick "";
[this, _action, _pos]execVM "functions\transport\transportAction.sqf";';
*/

private _transport = _this select 0;
private _action = _this select 1; 
private _pos = _this select 2;
private _mapGrid = mapGridPosition _pos;
private _customLz = USER_LZ;
private _backup = BACKUP_GROUPS call BIS_fnc_selectRandom;
choppa_group = createGroup west;

_transport setVariable ["onMission", true];
(group _transport) setVariable ["Vcm_Disable",true];
if (_action == 'reinforce') then {
	reinforceReady = false; 
	call compile format['[%1] execVM "functions\transport\transport_reinforce_action.sqf"', _transport];
	_action = 'infil';
	_customLz setPos _pos;
	waitUntil {reinforceReady};	
};

// three backup squads
if (_action == 'alpha') then {
	backupReady = false; 
	call compile format['[%1] execVM "functions\transport\transport_reinforceAlpha.sqf"', _transport];
	if (isNil "alpha_lz") then {
		alpha_lz = 'Land_HelipadEmpty_F' createVehicle _pos;
	};
	alpha_lz setPos _pos;
	_customLz = alpha_lz;
	_action = 'alphaInfil';
	waitUntil {backupReady};	
};
if (_action == 'bravo') then {
	backupReady = false; 
	call compile format['[%1] execVM "functions\transport\transport_reinforceBravo.sqf"', _transport];
	if (isNil "bravo_lz") then {
		bravo_lz = 'Land_HelipadEmpty_F' createVehicle _pos;
	};
	bravo_lz setPos _pos;
	_customLz = bravo_lz;
	_action = 'bravoInfil';
	waitUntil {backupReady};	
};
if (_action == 'charlie') then {
	backupReady = false; 
	call compile format['[%1] execVM "functions\transport\transport_reinforceCharlie.sqf"', _transport];
	if (isNil "charlie_lz") then {
		charlie_lz = 'Land_HelipadEmpty_F' createVehicle _pos;
	};
	charlie_lz setPos _pos;
	_customLz = charlie_lz;
	_action = 'charlieInfil';
	waitUntil {backupReady};	
};

_transport sideChat format ['%1 moving to grid %2, action %3', _transport, _mapGrid, _action];
// hint format ['%1 moving to grid %2, action %3', _transport, _mapGrid, _action];
_transport move _pos;
_customLz setPos _pos;

waitUntil {unitReady _transport};

if (unitReady _transport) then { 
	_transport land "GET IN"; // used only for helicopters
	_transport animateDoor ['door_R', 1]; 
	_transport animateDoor ['door_L', 1];
	waitUntil { isTouchingGround _transport }; 

	switch (_action) do {
		case  'infil': { 
				_transport sideChat "We're at the destination, exit when ready.";
				{
					if (_x in _transport) then {
						doGetOut _x;
					};
				} forEach units group player;
			};
		case 'alphaInfil': {
			_transport sideChat "We're at the destination, exiting vehicle.";
			doGetOut units backup_alpha;
			backup_alpha leaveVehicle _transport;
			if( isNil 'lambs_wp_fnc_taskGarrison') then {
				[backup_alpha, _position, 200] call BIS_fnc_taskPatrol;
			} else {
				[backup_alpha, _position, 200] call lambs_wp_fnc_taskPatrol;
			};
		};
		case 'bravoInfil': {
			_transport sideChat "We're at the destination, exiting vehicle.";
			doGetOut units backup_bravo;
			backup_bravo leaveVehicle _transport;
			if( isNil 'lambs_wp_fnc_taskGarrison') then {
				[backup_bravo, _position, 200] call BIS_fnc_taskPatrol;
			} else {
				[backup_bravo, _position, 200] call lambs_wp_fnc_taskPatrol;
			};
		};
		case 'charlieInfil': {
			_transport sideChat "We're at the destination, exiting vehicle.";
			doGetOut units backup_charlie;
			backup_charlie leaveVehicle _transport;
			if( isNil 'lambs_wp_fnc_taskGarrison') then {
				[backup_charlie, _position, 200] call BIS_fnc_taskPatrol;
			} else {
				[backup_charlie, _position, 200] call lambs_wp_fnc_taskPatrol;
			};
		};
		case 'exfil' : {
			[_transport] execVM  "functions\transport\transport_exfil_action.sqf";
		}
		default {
			_transport sideChat format['%1 at LZ, lets get the hello out of here!', _transport];
			waitUntil {{_x in _transport} count units group player == {alive _x} count units group player};
		};
	};
	_action = 'infil';
};

waitUntil{unitReady _transport};
if (_action != 'reinforce') then {
	call compile format['[%2] execVM "functions\transport\transport_%1_action.sqf"', _action, _transport];
	_transport setVariable ['onMission', false, true];
};
