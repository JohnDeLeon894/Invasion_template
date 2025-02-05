// create groups 
// enemy groups
// setDate [year, month, day, hour, minute]
private _currentDateNumber = (dateToNumber currentDate) + ([0, 0.1] call BIS_fnc_randomNum);
private _newDate = numberToDate [(currentDate select 0), _currentDateNumber];
if ((_newDate select 3) > 17) then {
	_newDate = [
		(_newDate select 0),
		(_newDate select 1),
		(_newDate select 2),
		17,
		0
	];
};
if ((_newDate select 3) < 6) then {
	_newDate = [
		(_newDate select 0),
		(_newDate select 1),
		(_newDate select 2),
		6,
		0
	];
};
setDate _newDate;
attackGroup_1 = createGroup [east, false];
attackGroup_2 = createGroup [east, false];
attackGroup_3 = createGroup [east, false];
attackGroup_4 = createGroup [east, false];
attackGroup_5 = createGroup [east, false];
attackGroup_6 = createGroup [east, false];
attackGroup_7 = createGroup [east, false];
attackGroup_8 = createGroup [east, false];

// friendly groups 
ally_1 = group player;
ally_2 = createGroup [west, false];
ally_3 = createGroup [west, false];
ally_4 = createGroup [west, false];
// ally_5 = createGroup [west, false];
backup_alpha = createGroup [west, false];
backup_bravo = createGroup [west, false];
backup_charlie = createGroup [west, false];
hq_guard = createGroup [west, false];

// precompile function files
missionNamer = compile preprocessFile 'functions\makeMissionName.sqf';

ENEMY_GROUPS = [
	attackGroup_1,
	attackGroup_2
];

FRIENDLY_GROUPS = [
	ally_1,
	ally_2,
	ally_3
];
BACKUP_GROUPS = [
	backup_alpha,
	backup_bravo,
	backup_charlie
];
ARTY = [
	m1,
	m2,
	m3,
	m4
];

// variable for counting stuff
GROUP_COUNT = 0;
continueLoop = true;
doOnce = 0;
SPAWN_LOOP_COUNT = 0;
ONE_LOOP = false;
BLU_UNIT_SIZE = 8;
RED_UNIT_SIZE = 6;
CHOPPA_COUNT = 0;

// find the marker 
// spawn points 

WEST_SPAWN = markerPos ["westSpawn", false];
EAST_SPAWN = markerPos ["eastSpawn", false];
AMMO_ZONE = markerPos [ 'ammoTruckZone', false];
TRANSPORT_ZONE = markerPos ['rtz', false];
WEST_VEHICLE_SPAWN = markerPos ['westVehicleSpawn', false];
EAST_VEHICLE_SPAWN = markerPos ['eastVehicleSpawn', false];
CHOPPA_SPAWN = markerPos ['CHOPPA_SPAWN', false];

if (isNil 'ALL_TRIGGERS') then {
	diag_log 'ALL_TRIGGERS is null, rescanning triggers';
	ALL_TRIGGERS = [];
	GREEN_TRIGGERS = [];
	RED_TRIGGERS = [];
	{
		private _trigger = _x;
		private _triggerName = format ['%1',_x];
		player createDiarySubject ['TriggersFound', 'Triggers Found'];
		player createDiaryRecord ['TriggersFound', ['Variable was not passed', 'Variable was not passed']];
		if ('sector' in _triggerName) then {
			private _title = _triggerName;
			private _entry = format ['Found trigger %1. Distance from player %2', _trigger, player distance _x];
			player createDiaryRecord ['TriggersFound', [_title, _entry]];
			private _triggerMark = createMarker[str _triggerName, position _trigger];
			private _triggerArea = [triggerArea _trigger select 0, triggerArea _trigger select 1];
			_triggerMark setMarkerBrush 'CROSS';
			_triggerMark setMarkerShape 'RECTANGLE';
			_triggerMark setMarkerSize _triggerArea;
			_triggerMark setMarkerColor 'ColorRed';
			ALL_TRIGGERS pushBack _triggerName;
			RED_TRIGGERS pushBack _triggerName;
		};
	} forEach allMissionObjects 'EmptyDetector';
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
			_triggerColor setMarkerColor 'ColorRed';
		};
		private _triggerMark = createMarker[str _trigger, position _trigger];
		_triggerMark setMarkerBrush 'CROSS';
		_triggerMark setMarkerShape 'RECTANGLE';
		_triggerMark setMarkerSize _triggerArea;
		_triggerMark setMarkerColor _triggerColor;
		diag_log format ['Trigger %1 set to %2', _x, _triggerColor];
	} forEach ALL_TRIGGERS;
};

ALL_BASES = [];
{
	if ( (_x find 'east_base_spawn') >= 0) then {
		ALL_BASES pushBack _x;
	};
 
} forEach allMapMarkers;

TRANSPORTS = [];

{
	private _heli = toLower str _x;
	if ( (_heli find 'hawk') >= 0) then {
		TRANSPORTS pushBack _heli;
		CHOPPA_COUNT = CHOPPA_COUNT +1;
	};
 
} forEach (entities 'Helicopter') ;


CAS = [
	Buzzard_01
];

LOCATION_TYPES = [
    'Airport',
    'Area',
    'BorderCrossing',
    'CityCenter',
    'CivilDefense',
    'CulturalProperty',
    'DangerousForces',
    'Flag',
	'FlatArea',
    'FlatAreaCity',
    'FlatAreaCitySmall',
    'HistoricalSite',
    'NameCity',
    'NameCityCapital',
    'NameMarine',
    'NameVillage',
    'SafetyZone',
    'Strategic',
    'StrongpointArea',
    'ViewPoint'
];



// global variable for units array
BLU_UNITS_ARRAY = usArmy;

BLU_GUARD_ARRAY = usArmy;

BLU_VEHICLE_ARRAY = usArmy_cars;

BLU_TANK_ARRAY = usArmy_armor;

RED_UNITS_ARRAY = BocoHaran_units + Isis_units;

RED_VEHICLE_ARRAY = Isis_Vehicles;

RED_TANK_ARRAY = Isis_Tanks;

COMMON_DONE = true;

