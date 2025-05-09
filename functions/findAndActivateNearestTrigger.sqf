hint 'activated!';
private ['_player', '_closestTrigger', '_nextClosest', '_selectedTrigger'];
_player = player;
// _closestTrigger = call compile (ALL_TRIGGERS select 0);
_closestTrigger = (RED_TRIGGERS select 0);
_nextClosest = (RED_TRIGGERS select 0);
_lastClosest = (RED_TRIGGERS select 0);

TRIGGER_HASHES apply {
	// _x = key 
	// _y = value 
	private _triggerName = _x;
	private _triggerData = _y;

	if (!(_triggerName in RED_TRIGGERS)) exitWith {
		diag_log '*** trigger not in red list ***';
		diag_log ['yeeting ', _triggerName, ' from red list'];
		RED_TRIGGERS deleteAt (RED_TRIGGERS find _triggerName);
	};

	private _triggerPos = _y get "Position";

	if ((WEST_SPAWN distance _triggerPos) < 300) exitWith {
		diag_log '*** trigger too close ***';
		diag_log ['yeeting ', _triggerName, ' from red list'];
		RED_TRIGGERS deleteAt (RED_TRIGGERS find _triggerName);
	};

	// get previous trigger hashes for comparison
	private _closestTriggerHash = TRIGGER_HASHES getOrDefault [_closestTrigger,"NameNotFound"]; 
	private _nextClosestHash = TRIGGER_HASHES getOrDefault [_nextClosest, "NameNotFound"];
	private _lastClosestHash = TRIGGER_HASHES getOrDefault [_lastClosest, "NameNotFound"];

	// get previous trigger positions
	
	private _closestTriggerPosition = _closestTriggerHash getOrDefault ["Position", [9999,9999]];
	private _nextClosestPosition = _nextClosestHash getOrDefault ["Position", [9999,9999]];
	private _lastClosestPosition = _lastClosestHash getOrDefault ["Position", [9999,9999]];

	// get distances 
	private _distanceA = WEST_SPAWN distance _triggerPos;
	private _distanceB = WEST_SPAWN distance _closestTriggerPosition;
	private _distanceC = WEST_SPAWN distance _nextClosestPosition;
	private _distanceD = WEST_SPAWN distance _lastClosestPosition;

	// sort distances logic 
	if (_distanceA < _distanceB) then {
		_closestTrigger = _currentTrigger;
	} else {
		if (_distanceA < _distanceC) then {
			_nextClosest = _currentTrigger;
		} else {
			if (_distanceA < _distanceD) then {
				_lastClosest = _currentTrigger;
			};
		};
	};
};

private _triggerList = [_closestTrigger, _nextClosest, _lastClosest];
private _selectedTriggerName = _triggerList call BIS_fnc_selectRandom;
private _triggerData = TRIGGER_HASHES get _selectedTriggerName;

try {
	_triggerData call ["CreateTrigger"];
}
catch {
	private _hintString = format["create trigger failed for %1", _selectedTriggerName];
	hint _hintString;
	diag_log _hintString;
	diag_log _exception;
};

RED_TRIGGERS deleteAt (RED_TRIGGERS find _selectedTriggerName);
_selectedTriggerName