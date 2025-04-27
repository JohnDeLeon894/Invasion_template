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

SECTOR_HASH = createHashMapFromArray GENERATED_SECTORS;

if (_isNil_allTriggers) then {
	diag_log 'ALL_TRIGGERS is null, rescanning triggers';
	player createDiarySubject ['TriggersFound', 'Triggers Found'];
	player createDiaryRecord ['TriggersFound', ['Variable was not passed', 'Variable was not passed']];

	// ALL_TRIGGERS = [];
	// GREEN_TRIGGERS = [];
	// RED_TRIGGERS = [];
	{
		private _trigger = _x;
		private _triggerName = str _x;
		
		diag_log "******** trigger and trigger name ********";
		diag_log [_triggerName, _trigger];

		if ('sector' in _triggerName) then {
			private _title = _triggerName;
			private _entry = format ['Found trigger %1. Distance from player %2', _triggerName, player distance _trigger];
			player createDiaryRecord ['TriggersFound', [_title, _entry]];
			private _triggerMark = createMarker[str _triggerName, position _trigger];
			private _triggerArea = [triggerArea _trigger select 0, triggerArea _trigger select 1];
			_triggerMark setMarkerBrush 'CROSS';
			_triggerMark setMarkerShape 'RECTANGLE';
			_triggerMark setMarkerSize _triggerArea;
			_triggerMark setMarkerColor 'ColorRed';
			ALL_TRIGGERS pushBack _trigger;
			RED_TRIGGERS pushBack _trigger;
		};
		if ('region' in _triggerName) then {
			private _title = _triggerName;
			private _entry = format ['Found trigger %1. Distance from player %2', _trigger, player distance _trigger];
			player createDiaryRecord ['TriggersFound', [_title, _entry]];
			private _triggerMark = createMarker[_triggerName, position _trigger];
			private _triggerArea = [triggerArea _trigger select 0, triggerArea _trigger select 1];
			_triggerMark setMarkerBrush 'CROSS';
			_triggerMark setMarkerShape 'RECTANGLE';
			_triggerMark setMarkerSize _triggerArea;
			_triggerMark setMarkerColor 'ColorRed';
			ALL_TRIGGERS pushBack _trigger;
			RED_TRIGGERS pushBack _trigger;
		};
	} forEach allMissionObjects 'EmptyDetector';
	// } forEach GENERATED_SECTORS;
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

FIND_SECTORS_DONE = true;