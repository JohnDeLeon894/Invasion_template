// spawn reinforcements and load into chopper

private _group = group player;
private _troopLimit = 6;
private _reinforcementCount = _troopLimit - ({alive _x} count units group player);
private _position = getMarkerPos 'w_spawn';

hint 'started';
// private _unitsList = "getText (_x >> 'faction') == 'LOP_PMC' && getText (_x >> 'simulation') == 'soldier'" configClasses (configFile >> "CfgVehicles");
private _unitsList = BLU_UNITS_ARRAY;
private _unitsArray = _unitsList apply {configName _x};

for [{ private _i =_reinforcementCount}, {_i > 0}, {_i = _i - 1}] do {
	private _soldier = _unitsArray call BIS_fnc_selectRandom;
	_unit = _group createUnit [_soldier, _position, [],0, "NONE"];
	_unit moveInAny hellcat_6;
};

waitUntil {{_x in hellcat_6} count units group player == _reinforcementCount};

reinforceReady = true;