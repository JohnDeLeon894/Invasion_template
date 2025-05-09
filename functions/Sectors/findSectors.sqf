// define global trigger lists. 
private _isNil_allTriggers = isNil 'ALL_TRIGGERS';
private _isNil_greenTriggers = isNil 'GREEN_TRIGGERS';
private _isNil_redTriggers = isNil 'RED_TRIGGERS';
private _isNil_controlTriggers = isNil 'CONTROL_TRIGGERS';
private _isNil_regionTriggers = isNil 'REGION_TRIGGERS';

ALL_TRIGGERS = [ALL_TRIGGERS, []] select _isNil_allTriggers;
GREEN_TRIGGERS = [GREEN_TRIGGERS, []] select _isNil_greenTriggers;
RED_TRIGGERS = [RED_TRIGGERS, []] select _isNil_redTriggers;
CONTROL_TRIGGERS = [CONTROL_TRIGGERS, []] select _isNil_controlTriggers;
REGION_TRIGGERS = [REGION_TRIGGERS, []] select _isNil_regionTriggers;

// SECTOR_HASH = createHashMapFromArray GENERATED_SECTORS;

if (_isNil_allTriggers) then {
	SECTOR_GENERATOR_DONE  = false;

	[]call jMD_fnc_sectorGenerator;

	waitUntil {SECTOR_GENERATOR_DONE};

	diag_log 'ALL_TRIGGERS is null, re-scanning triggers';
	TRIGGER_HASHES apply {
		private _triggerName = _x;
		private _triggerHash = _y;
		private _triggerPos = _triggerHash get "Position";
		private _triggerSize = _triggerHash get "Size";
		private _triggerArea = [_triggerSize, _triggerSize];
		private _title = _triggerName;
		private _entry = format ['Found trigger %1. Distance from player %2', _triggerName, player distance _triggerPos];
		private _triggerMark = createMarker[str _triggerName, _triggerPos];

		player createDiaryRecord ['TriggersFound', [_title, _entry]];

		_triggerMark setMarkerBrush 'CROSS';
		_triggerMark setMarkerShape 'RECTANGLE';
		_triggerMark setMarkerSize _triggerArea;
		_triggerMark setMarkerColor 'ColorRed';
		ALL_TRIGGERS pushBack _triggerName;
		RED_TRIGGERS pushBack _triggerName;
	};

} else {
	hint "derp";
	diag_log 'Saved triggers list detected';
	private _entry = format ['The list of triggers from previous mission: %1', ALL_TRIGGERS];
	player createDiaryRecord ['TriggersFound', ['found existing triggers!', _entry]];

	TRIGGER_HASHES apply {
		// key _x 
		// value _y 
		private _triggerName = _x;
		private _triggerHash = _y;
		private _triggerPos = _triggerHash get "Position";
		private _triggerSize = _triggerHash get "Size";
		private _triggerArea = [_triggerSize, _triggerSize];
		private _title = _triggerName;
		private _entry = format ['Found trigger %1. Distance from player %2', _triggerName, player distance _triggerPos];
		private _triggerMark = createMarker[str _triggerName, _triggerPos];

		player createDiaryRecord ['TriggersFound', [_title, _entry]];

		private _isRedTrigger = _triggerName in RED_TRIGGERS;
		private _markerColor = ['ColorGreen', 'ColorRed'] select _isRedTrigger;
		private _state = ["green", "red"] select isRedTrigger;

		private _triggerMark = createMarker[_triggerName, _triggerPos];
		_triggerMark setMarkerBrush 'CROSS';
		_triggerMark setMarkerShape 'RECTANGLE';
		_triggerMark setMarkerSize _triggerArea;
		_triggerMark setMarkerColor _markerColor;
		diag_log format ['Trigger %1 set to %2', _x, _markerColor];
		_triggerHash set ["State", _state];
	};
};

/*
} else {
	diag_log 'Saved triggers list detected';
	player createDiarySubject ['TriggersFound', 'Triggers Found'];
	private _entry = format ['The list of triggers from previous mission: %1', ALL_TRIGGERS];
	player createDiaryRecord ['TriggersFound', ['found existing triggers!', _entry]];

	if ( isNil 'RED_TRIGGERS') then {
		RED_TRIGGERS = ALL_TRIGGERS;
	};

	// Should make this a function in functions library
	// for all triggers if its not in red triggers, make green.
	{
		private _trigger = call compile _x;
		private _triggerColor = 'ColorGreen';
		private _triggerArea = [triggerArea _trigger select 0, triggerArea _trigger select 1];

		if (_trigger in RED_TRIGGERS) then {
			_triggerColor = 'ColorRed';
		};
		private _triggerMark = createMarker[str _trigger, position _trigger];
		_triggerMark setMarkerBrush 'CROSS';
		_triggerMark setMarkerShape 'RECTANGLE';
		_triggerMark setMarkerSize _triggerArea;
		_triggerMark setMarkerColor _triggerColor;
		diag_log format ['Trigger %1 set to %2', _x, _triggerColor];
	} forEach ALL_TRIGGERS;
};
*/
FIND_SECTORS_DONE = true;