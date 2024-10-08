// spawn reinforcements and load into chopper

private _transport = _this select 0;
private _reinforcementCount = BLU_UNIT_SIZE - ({alive _x} count units backup_alpha);
private _position = getMarkerPos 'westSpawn';
diag_log ['unit count to spawn = ', _reinforcementCount];
// hint 'started';
for '_i' from 1 to _reinforcementCount do {
	private _soldier = BLU_UNITS_ARRAY call BIS_fnc_selectRandom;
	_unit = backup_alpha createUnit [_soldier, _position, [],0, "NONE"];
	_unit moveInAny _transport;
	[_unit, 'lambs_danger_OnInformationShared', {
    params ['_unit', '_group', '_target', '_groups'];
		[_unit, _group, _target, _groups] execVM 'functions\enemySpottedCallOut.sqf';
	}] call BIS_fnc_addScriptedEventHandler;
};

private _allAboard = !(({_x in _transport} count units backup_alpha) == _reinforcementCount || ( count units backup_alpha >= _reinforcementCount));
if (_allAboard) exitWith {
		call compile format['[%1] execVM "functions\transport\transport_reinforceAlpha.sqf"', _transport];
};

waitUntil {{_x in _transport} count units backup_alpha == _reinforcementCount};

backupReady = true;
