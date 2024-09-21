// spawn reinforcements and load into chopper

private _transport = _this select 0;
private _reinforcementCount = BLU_UNIT_SIZE - ({alive _x} count units backup_bravo);
private _position = getMarkerPos 'westSpawn';

// hint 'started';
for '_i' from 1 to _reinforcementCount do {
	private _soldier = BLU_UNITS_ARRAY call BIS_fnc_selectRandom;
	_unit = backup_bravo createUnit [_soldier, _position, [],0, "NONE"];
	_unit moveInAny _transport;
	[_unit, 'lambs_danger_OnInformationShared', {
    params ['_unit', '_group', '_target', '_groups'];
		[_unit, _group, _target, _groups] execVM 'functions\enemySpottedCallOut.sqf';
	}] call BIS_fnc_addScriptedEventHandler;
};

private _allAboard = !(({_x in _transport} count units backup_bravo) == _reinforcementCount || ( count units backup_bravo >= _reinforcementCount));
if (_allAboard) exitWith {
		call compile format['[%1] execVM "functions\transport\transport_reinforceBravo.sqf"', _transport];
};

waitUntil {{_x in _transport} count units backup_bravo == _reinforcementCount};

backupReady = true;
