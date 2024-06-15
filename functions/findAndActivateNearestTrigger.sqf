hint 'activated!';
private ['_player', '_closestTrigger', '_nextClosest', '_selectedTrigger'];
_player = player;
// _closestTrigger = call compile (ALL_TRIGGERS select 0);
_closestTrigger = call compile (RED_TRIGGERS select 0);
_nextClosest = call compile (RED_TRIGGERS select 0);
_lastClosest = call compile (RED_TRIGGERS select 0);

{
	private _currentTrigger = call compile _x;
	private _distanceA = player distance _currentTrigger;
	private _distanceB = player distance _closestTrigger;
	private _distanceC = player distance _nextClosest;
	private _distanceD = player distance _lastClosest;
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
	diag_log [_closestTrigger, _nextClosest, _lastClosest];
} forEach RED_TRIGGERS;
// _closestTrigger = ALL_TRIGGERS call BIS_fnc_selectRandom;
private _triggerList = [_closestTrigger, _nextClosest, _lastClosest];
// _selectedTrigger = _triggerList call BIS_fnc_selectRandom;
_selectedTrigger = _triggerList select 0;
TRIGGER_POS = position _selectedTrigger;
private _subject = player createDiarySubject ['triggerPicker', 'trigger picker'];
private _triggerListText = format['%1', _triggerList];
player createDiaryRecord ['triggerPicker', ['the trigger array', _triggerListText]];
player createDiaryRecord ['triggerPicker', ['the trigger chosen', format['%1',_selectedTrigger]]];

private _copyStatements = triggerStatements _selectedTrigger;
private _copyActivation = _copyStatements select 1;
private _copyDeactivation = _copyStatements select 2;
player createDiaryRecord ['triggerPicker', ['the trigger statements', format['%1', _copyStatements]]];

_selectedTrigger setTriggerStatements ['true', _copyActivation, _copyDeactivation];

RED_TRIGGERS deleteAt (RED_TRIGGERS find str _selectedTrigger);
sector = _selectedTrigger;
_selectedTrigger