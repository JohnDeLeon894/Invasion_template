/*
onMapSingleClick '
onMapSingleClick "";
[this, _action, _pos]execVM "functions\transport\transportAction.sqf";';
*/

private _transport = _this select 0;
private _action = _this select 1; 
private _pos = _this select 2;
private _mapGrid = mapGridPosition _pos;


choppa_group = createGroup west;

_transport setVariable ["onMission", true];
(group _transport) setVariable ["Vcm_Disable",true];

// if (_action == 'reinforce') then {
// 	reinforceReady = false; 
// 	call compile format['[%1] execVM "functions\GroundTransports\reinforce_action.sqf"', _transport];
// 	_action = 'infil';

// 	waitUntil {reinforceReady};	
// };

// // three backup squads
// if (_action == 'alpha') then {
// 	backupReady = false; 
// 	call compile format['[%1] execVM "functions\GroundTransports\reinforceAlpha.sqf"', _transport];
// 	if (isNil "alpha_lz") then {
// 		alpha_lz = 'Land_HelipadEmpty_F' createVehicle _pos;
// 	};
// 	alpha_lz setPos _pos;

// 	_action = 'alphaInfil';
// 	waitUntil {backupReady};	
// };
// if (_action == 'bravo') then {
// 	backupReady = false; 
// 	call compile format['[%1] execVM "functions\GroundTransports\reinforceBravo.sqf"', _transport];
// 	if (isNil "bravo_lz") then {
// 		bravo_lz = 'Land_HelipadEmpty_F' createVehicle _pos;
// 	};
// 	bravo_lz setPos _pos;

// 	_action = 'bravoInfil';
// 	waitUntil {backupReady};	
// };
// if (_action == 'charlie') then {
// 	backupReady = false; 
// 	call compile format['[%1] execVM "functions\GroundTransports\reinforceCharlie.sqf"', _transport];
// 	if (isNil "charlie_lz") then {
// 		charlie_lz = 'Land_HelipadEmpty_F' createVehicle _pos;
// 	};
// 	charlie_lz setPos _pos;

// 	_action = 'charlieInfil';
// 	waitUntil {backupReady};	
// };

_transport sideChat format ['%1 moving to grid %2, action %3', _transport, _mapGrid, _action];
// hint format ['%1 moving to grid %2, action %3', _transport, _mapGrid, _action];
_transport move _pos;
// _customLz setPos _pos;

waitUntil {unitReady _transport};

private _infilAction = {
	params ['_group', '_radius', '_order'];
	_transport sideChat "We're at the destination, exiting vehicle.";

	{ 
		_x action ["GetOut", _transport];
	} forEach (units _group);

	_group leaveVehicle _transport;
	[_group, _pos, _radius, _order]call jMD_fnc_setOrders;
};

if (unitReady _transport) then { 
	_transport land "GET IN"; // used only for helicopters
	// _transport animateDoor ['door_R', 1]; 
	// _transport animateDoor ['door_L', 1];
	// waitUntil { isTouchingGround _transport }; 

	switch (_action) do {
		case  'infil': { 
			private _group = group player;
			_transport sideChat "We're at the destination, exit when ready.";
			{ 
				_x action ["GetOut", _transport];
			 	_x  leaveVehicle _transport;
			} forEach (units _group);
		};
		case 'alphaInfil': {
			private _group = backup_alpha;
			private _radius = 200;

			[_group, _radius, 'patrol'] call _infilAction;
		};
		case 'bravoInfil': {
			_transport sideChat "We're at the destination, exiting vehicle.";
			private _group = backup_bravo;
			private _radius = 200;
			[_group, _radius, 'patrol'] call _infilAction;
		};
		case 'charlieInfil': {
			_transport sideChat "We're at the destination, exiting vehicle.";
			private _group = backup_charlie;
			private _radius = 200;

			[_group, _radius, 'patrol'] call _infilAction;
		};
		default {
			_transport sideChat format['%1 at LZ, lets get the hello out of here!', _transport];
			waitUntil {{_x in _transport} count units group player == {alive _x} count units group player};
		};
	};
	_action = 'infil';
};

waitUntil{unitReady _transport};
if (_action != 'reinforce') then {
	call compile format['[%2] execVM "functions\GroundTransports\%1_action.sqf"', _action, _transport];
	_transport setVariable ['onMission', false, true];
};
