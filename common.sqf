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
	m_1,
	m_2,
	m_3,
	m_4
];

GROUND_TRANSPORTS = [
	'Rhino_1'
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

FIND_SECTORS_DONE = false;
[] execVM "functions\Sectors\findSectors.sqf";

waitUntil{FIND_SECTORS_DONE};

// [] execVM "functions\Sectors\createControlSector.sqf";

TRANSPORTS = [];

{
	private _heli = toLower str _x;
	if ( (_heli find 'hawk') >= 0) then {
		TRANSPORTS pushBack _heli;
		CHOPPA_COUNT = CHOPPA_COUNT +1;
	};
 
} forEach (entities 'Helicopter') ;
// } forEach (entities 'car') ;


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



// global variable for units arrayIntersect

BLU_UNITS_ARRAY = usArmy;

BLU_GUARD_ARRAY = usArmy;

BLU_VEHICLE_ARRAY = usArmy_cars;

BLU_TANK_ARRAY = usArmy_armor;

RED_UNITS_ARRAY = BocoHaran_units + Isis_units;

RED_VEHICLE_ARRAY = Isis_Vehicles;

RED_TANK_ARRAY = Isis_Tanks;


COMMON_DONE = true;

