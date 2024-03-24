// spawn reinforcements and load into chopper

private _transport = _this select 0;
private _group = group player;
private _reinforcementCount = BLU_UNIT_SIZE - ({alive _x} count units group player);
private _position = getMarkerPos 'westSpawn';

// hint 'started';
for '_i' from 1 to _reinforcementCount do {
	private _soldier = BLU_UNITS_ARRAY call BIS_fnc_selectRandom;
	_unit = _group createUnit [_soldier, _position, [],0, "NONE"];
	_unit moveInAny _transport;
};
private _allAboard = ({_x in _transport} count units group player >= _reinforcementCount);
if (!_allAboard) exitWith {
	[_transport] execVM "functions\transport\transport_reinforce_action.sqf";
};

reinforceReady = true;