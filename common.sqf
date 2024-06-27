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

	if ( isNil RED_TRIGGERS) then {
		RED_TRIGGERS = ALL_TRIGGERS;
	};

	// Should make this a function in functions library
	// for all triggers if its not in red triggers, make green.
	{
		private _trigger = _x;
		private _triggerColor = 'ColorGreen';
		private _triggerArea = [triggerArea _trigger select 0, triggerArea _trigger select 1];

		if (_trigger in ALL_TRIGGERS) then {
			_triggerColor setMarkerColor 'ColorRed';
		};
		private _triggerMark = createMarker[str _trigger, position _trigger];
		_triggerMark setMarkerBrush 'CROSS';
		_triggerMark setMarkerShape 'RECTANGLE';
		_triggerMark setMarkerSize _triggerArea;
		_triggerMark setMarkerColor _triggerColor;
		diag_log format ['Trigger %1 set to %2', _troggerName, _triggerColor];
	} forEach RED_TRIGGERS;
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

// units arrays 
Unit_Blacklist = [
	'CUP_B_BAF_Pilot_DDPM',
	'CUP_B_BAF_Soldier_RangeMaster_DDPM',
	'CUP_B_BAF_Pilot_MTP',
	'CUP_B_BAF_Soldier_Competitor_DPM',
	'CUP_B_BAF_Soldier_FighterPilot_DPM',
	'CUP_B_BAF_Soldier_Survivor_MTP',
	'CUP_B_BAF_Soldier_RiflemanUnarmed_DDPM',
	'CUP_B_BAF_Soldier_Paratrooper_MTP',
	'CUP_B_BAF_Soldier_DeckCrew_MTP',
	'AOR_2_SS_uniform',
	'AOR_2_TCasual_uniform',
	'AOR_2_uniform',
	'B_soldier_PG_F',
	'B_Soldier_support_base_F',
	'B_soldier_exp_F_OCimport_01',
	'B_soldier_exp_F_OCimport_01',
	'B_soldier_LAT_F_OCimport_01',
	'B_medic_F_OCimport_02',
	'B_sniper_F_OCimport_02',
	'B_Soldier_diver_base_F',
	'B_Soldier_GL_F_OCimport_02',
	'B_sniper_F_OCimport_01',
	'B_soldier_AR_F_OCimport_02',
	'B_Soldier_SL_F_OCimport_01',
	'B_ghillie_base_F',
	'B_recon_F_OCimport_01'
];
// enemy units 

Isis_Vehicles = [
	'LOP_ISTS_OPF_Offroad_AT',
	'LOP_ISTS_OPF_Offroad_M2',
	'LOP_ISTS_OPF_Offroad',
	'LOP_ISTS_OPF_Nissan_PKM',
	'LOP_ISTS_OPF_M998_D_4DR',
	'LOP_ISTS_OPF_M1025_D',
	'LOP_ISTS_OPF_M1025_D',
	'LOP_ISTS_OPF_M1025_W_Mk19',
	'LOP_ISTS_OPF_M1025_W_M2',
	'LOP_ISTS_OPF_Landrover_SPG9',
	'LOP_ISTS_OPF_Landrover_M2',
	'LOP_ISTS_OPF_Landrover_M2',
	'LOP_ISTS_OPF_Landrover',
	'LOP_ISTS_OPF_Truck',
	'cfp_o_is_Ural',
	'cfp_o_is_UAZ_SPG9',
	'cfp_o_is_UAZ_Open',
	'cfp_o_is_UAZ_MG',
	'cfp_o_is_UAZ_METIS',
	'cfp_o_is_UAZ_AGS30',
	'cfp_o_is_UAZ_Unarmed',
	'cfp_o_is_pickup_PK_flag',
	'cfp_o_is_pickup_PK',
	'cfp_o_is_offroad_M2_flag',
	'cfp_o_is_offroad_M2',
	'cfp_o_is_offroad_AT',
	'cfp_o_is_offroad_flag',
	'cfp_o_is_offroad',
	'cfp_o_is_LR_SPG9',
	'cfp_o_is_LR_M2',
	'cfp_o_is_LR_Unarmed',
	'cfp_o_is_jeep_lmg',
	'cfp_o_is_jeep_at',
	'cfp_o_is_hmmwv_dshkm',
	'cfp_o_is_hmmwv_ags',
	'CFP_O_IS_Hilux_ZU_23_Armored_01',
	'CFP_O_IS_Hilux_UB_32_Armored_01',
	'CFP_O_IS_Hilux_SPG_Armored_01',
	'CFP_O_IS_Hilux_Podnos_Armored_01',
	'CFP_O_IS_Hilux_MLRS_Armored_01',
	'CFP_O_IS_Hilux_Metis_Armored_01',
	'CFP_O_IS_Hilux_Igla_Armored_01',
	'CFP_O_IS_Hilux_DSHKM_Armored_01',
	'CFP_O_IS_Hilux_BTR60_Armored_01',
	'CFP_O_IS_Hilux_BMP1_Armored_01',
	'CFP_O_IS_Hilux_BMP1_Armored_01',
	'CFP_O_IS_Hilux_AGS_30_Armored_01',
	'CFP_O_IS_Hilux_Armored_01',
	'CFP_O_IS_Hilux_ZU_23_01',
	'CFP_O_IS_Hilux_UB_32_01',
	'CFP_O_IS_Hilux_SPG_01',
	'CFP_O_IS_Hilux_Podnos_01',
	'CFP_O_IS_Hilux_MLRS_01',
	'CFP_O_IS_Hilux_Metis_01',
	'CFP_O_IS_Hilux_Igla_01',
	'CFP_O_IS_Hilux_DShKM_01',
	'CFP_O_IS_Hilux_AGS_30_01',
	'CFP_O_IS_Hilux_01',
	'O_IS_Technical_Armed_01',
	'O_IS_Technical_01',
	'O_IS_Captured_Humvee_01',
	'O_IS_Ural_ZSU_23_01',
	'O_IS_Ural_Troop_Truck_01'
];
Isis_Tanks = [
	'LOP_ISTS_OPF_BTR60',
	'LOP_ISTS_OPF_M113_W',
	'LOP_ISTS_OPF_T34',
	'LOP_ISTS_OPF_T55',
	'LOP_ISTS_OPF_T72BA',
	'cfp_o_is_BMP1',
	'cfp_o_is_BMP1P',
	'cfp_o_is_BMP2',
	'cfp_o_is_BMP2_PKM',
	'cfp_o_is_BMP2_ZU',
	'cfp_o_is_BTR40_MG',
	'cfp_o_is_BTR40_MG_flag',
	'cfp_o_is_BTR40_MG_flag',
	'cfp_o_is_M113',
	'cfp_o_is_M113_flag',
	'cfp_o_is_T34',
	'cfp_o_is_T55',
	'cfp_o_is_T72_flag',
	'O_IS_BTR_60_01',
	'O_IS_T72B_01'
];
Isis_units = [
	'LOP_ISTS_OPF_Infantry_SL',
	'LOP_ISTS_OPF_Infantry_AT',
	'LOP_ISTS_OPF_Infantry_Rifleman_8',
	'LOP_ISTS_OPF_Infantry_Marksman',
	'LOP_ISTS_OPF_Infantry_Rifleman_9',
	'LOP_ISTS_OPF_Infantry_AR',
	'LOP_ISTS_OPF_Infantry_AR_Asst',
	'LOP_ISTS_OPF_Infantry_AR_2',
	'LOP_ISTS_OPF_Infantry_AR_Asst_2',
	'LOP_ISTS_OPF_Infantry_Rifleman_7',
	'LOP_ISTS_OPF_Infantry_Rifleman_3',
	'LOP_ISTS_OPF_Infantry_Rifleman_4',
	'LOP_ISTS_OPF_Infantry_Rifleman',
	'LOP_ISTS_OPF_Infantry_Rifleman_6',
	'LOP_ISTS_OPF_Infantry_GL',
	'LOP_ISTS_OPF_Infantry_TL',
	'LOP_ISTS_OPF_Infantry_Corpsman',
	'LOP_ISTS_OPF_Infantry_Engineer',
	'cfp_o_is_team_leader',
	'cfp_o_is_squad_leader',
	'cfp_o_is_sniper',
	'cfp_o_is_sapper',
	'cfp_o_is_rifleman',
	'cfp_o_is_at',
	'cfp_o_is_Asst_Gunner_KORD',
	'cfp_o_is_Asst_Gunner_DSHKM',
	'cfp_o_is_Asst_Gunner_AGS30',
	'cfp_o_is_militaman',
	'cfp_o_is_medic',
	'cfp_o_is_machinegunner',
	'cfp_o_is_irregular',
	'cfp_o_is_rifleman_spg9',
	'cfp_o_is_rifleman_podnos',
	'cfp_o_is_rifleman_metis',
	'cfp_o_is_rifleman_kord',
	'cfp_o_is_rifleman_dshkm',
	'cfp_o_is_rifleman_ags30',
	'cfp_o_is_grenadier',
	'cfp_o_is_crewman',
	'cfp_o_is_autorifleman',
	'cfp_o_is_Asst_Gunner_SPG',
	'cfp_o_is_Asst_Gunner_Podnos',
	'cfp_o_is_Asst_Gunner_METIS',
	'O_IS_Veteran_Team_Leader_01',
	'O_IS_Veteran_Medic_01',
	'O_IS_Veteran_Marksman_01',
	'O_IS_Veteran_Machinegunner_01',
	'O_IS_Veteran_Grenadier_01',
	'O_IS_Veteran_Fighter_01',
	'O_IS_Veteran_AT_01',
	'O_IS_Team_Leader_01',
	'O_IS_RPG_Gunner_01',
	'O_IS_PKM_Gunner_01',
	'O_IS_Medic_01',
	'O_IS_Marksman_01',
	'O_IS_Light_Fighter_01',
	'O_IS_IED_Specialist_01',
	'O_IS_Grenadier_01',
	'O_IS_Fighter_01',
	'O_IS_Crewman_01',
	'O_IS_Cell_Leader_01',
	'O_IS_Anti_Air_Soldier_01'
];

CSAT_Units = [
	'O_Soldier_A_F',
	'O_Soldier_AAR_F',
	'O_support_AMG_F',
	'O_support_AMort_F',
	'O_Soldier_AAA_F',
	'O_Soldier_AAT_F',
	'O_Soldier_AR_F',
	'O_medic_F',
	'O_soldier_exp_F',
	'O_Soldier_GL_F',
	'O_support_GMG_F',
	'O_support_MG_F',
	'O_soldier_M_F',
	'O_Soldier_F',
	'O_Soldier_LAT_F',
	'O_Soldier_HAT_F',
	'O_Sharpshooter_F',
	'O_Soldier_TL_F',
	'O_soldier_UAV_F',
	'O_soldier_UAV_06_F'
];

CSAT_Vehicles = [
	'O_Truck_02_transport_F',
	'O_Truck_02_covered_F',
	'O_MRAP_02_hmg_F',
	'O_MRAP_02_gmg_F',
	'O_Truck_03_transport_F',
	'O_Truck_03_covered_F',
	'CUP_O_UAZ_Unarmed_CSAT',
	'CUP_O_UAZ_MG_CSAT'
];

CSAT_Tanks = [
	'O_MBT_04_cannon_F',
	'O_MBT_04_command_F',
	'CUP_O_T55_CSAT',
	'CUP_O_T72_CSAT',
	'O_MBT_02_cannon_F',
	'O_APC_Tracked_02_cannon_F',
	'CUP_O_BMP1_CSAT',
	'CUP_O_BMP1P_CSAT',
	'CUP_O_BMP2_CSAT',
	'CUP_O_BMP2_ZU_CSAT',
	'CUP_O_BMP_HQ_CSAT',
	'CUP_O_BRDM2_ATGM_CSAT',
	'CUP_O_BTR60_CSAT',
	'CUP_O_BTR80_CSAT',
	'CUP_O_BTR80A_CSAT',
	'O_APC_Wheeled_02_rcws_F',
	'O_APC_Wheeled_02_rcws_v2_F'
];

BocoHaran_units = [
	'CFP_O_BH_Asst_Gunner_DShKM_01',
	'CFP_O_BH_Asst_Gunner_Mortar_01',
	'CFP_O_BH_Asst_Gunner_SPG_01',
	'CFP_O_BH_Explosive_Specialist_01',
	'CFP_O_BH_Grenadier_AK74_01',
	'CFP_O_BH_Gunner_DShKM_01',
	'CFP_O_BH_Gunner_Mortar_01',
	'CFP_O_BH_Gunner_SPG_01',
	'CFP_O_BH_Machine_Gunner_PKM_01',
	'CFP_O_BH_Medic_AK47_01',
	'CFP_O_BH_Rifleman_AK47_01',
	'CFP_O_BH_Rifleman_AK74_01',
	'CFP_O_BH_Rifleman_AT_AK47_01',
	'CFP_O_BH_Sniper_Enfield_01',
	'CFP_O_BH_Sniper_SVD_01',
	'CFP_O_BH_Team_Leader_01',
	'LOP_BH_Infantry_IED',
	'LOP_BH_Infantry_Corpsman',
	'LOP_BH_Infantry_TL',
	'LOP_BH_Infantry_Driver',
	'LOP_BH_Infantry_GL',
	'LOP_BH_Infantry_AR_2',
	'LOP_BH_Infantry_AR',
	'LOP_BH_Infantry_AR_Asst_2',
	'LOP_BH_Infantry_AR_Asst',
	'LOP_BH_Infantry_Rifleman',
	'LOP_BH_Infantry_Rifleman_lite',
	'LOP_BH_Infantry_AT',
	'LOP_BH_Infantry_Marksman',
	'LOP_BH_Infantry_SL'
];

// desert camo friendly soldiers

bluforDesertUnits = [
	'rhsusf_usmc_marpat_d_squadleader',
	'rhsusf_usmc_marpat_d_spotter',
	'rhsusf_usmc_marpat_d_sniper',
	'rhsusf_usmc_marpat_d_sniper_m110',
	'rhsusf_usmc_marpat_d_rifleman_law',
	'rhsusf_usmc_marpat_d_rifleman_m4',
	'rhsusf_usmc_marpat_d_rifleman',
	'rhsusf_usmc_marpat_d_riflemanat',
	'rhsusf_usmc_marpat_d_rifleman_light',
	'rhsusf_usmc_marpat_d_machinegunner_ass',
	'rhsusf_usmc_marpat_d_machinegunner',
	'rhsusf_usmc_marpat_d_grenadier',
	'rhsusf_usmc_marpat_d_jfo',
	'rhsusf_usmc_marpat_d_fso',
	'rhsusf_usmc_marpat_d_explosives',
	'rhsusf_usmc_marpat_d_marksman',
	'rhsusf_usmc_marpat_d_engineer',
	'rhsusf_usmc_marpat_d_rifleman_m590',
	'rhsusf_usmc_marpat_d_autorifleman_m249_ass',
	'rhsusf_usmc_marpat_d_autorifleman',
	'rhsusf_usmc_marpat_d_autorifleman_m249',
	'rhsusf_usmc_marpat_d_javelin',
	'rhsusf_usmc_marpat_d_javelin_assistant',
	'rhsusf_usmc_marpat_d_smaw'
];

natoUnits = [
	'B_Soldier_A_F',
	'B_support_AMG_F',
	'B_soldier_AAA_F',
	'B_soldier_AAT_F',
	'B_soldier_AR_F',
	'B_medic_F',
	'B_engineer_F',
	'B_soldier_exp_F',
	'B_support_GMG_F',
	'B_support_MG_F',
	'B_support_Mort_F',
	'B_HeavyGunner_F',
	'B_soldier_M_F',
	'B_soldier_mine_F',
	'B_soldier_AA_F',
	'B_soldier_AT_F',
	'B_soldier_repair_F',
	'B_soldier_LAT_F',
	'B_Sharpshooter_F'
];
// precompile function files
missionNamer = compile preprocessFile 'functions\makeMissionName.sqf';

usArmy = [
	'rhsusf_army_ucp_teamleader',
	'rhsusf_army_ucp_squadleader',
	'rhsusf_army_ucp_rifleman_m4',
	'rhsusf_army_ucp_rifleman_m16',
	'rhsusf_army_ucp_riflemanat',
	'rhsusf_army_ucp_riflemanl',
	'rhsusf_army_ucp_rifleman',
	'rhsusf_army_ucp_marksman',
	'rhsusf_army_ucp_machinegunner',
	'rhsusf_army_ucp_grenadier'
];

usArmy_cars = [
	'rhsusf_m1240a1_mk19crows_usarmy_wd',
	'rhsusf_m1240a1_mk19_uik_usarmy_wd',
	'rhsusf_m1240a1_m240_uik_usarmy_wd',
	'rhsusf_m1240a1_m2_uik_usarmy_wd',
	'rhsusf_m1240a1_m240_usarmy_wd',
	'rhsusf_M1117_W',
	'rhsusf_m1151_m240_v2_usarmy_wd',
	'rhsusf_m1151_m2_v2_usarmy_wd',
	'rhsusf_m1151_mk19_v2_usarmy_wd'
];

usArmy_armor = [
	'rhsusf_stryker_m1126_m2_wd',
	'rhsusf_stryker_m1126_mk19_wd',
	'rhsusf_stryker_m1132_m2_np_wd',
	'rhsusf_m113_usarmy_M240',
	'rhsusf_m1a1aimwd_usarmy'
];

// global variable for units array
BLU_UNITS_ARRAY = usArmy;

BLU_VEHICLE_ARRAY = usArmy_cars;

BLU_TANK_ARRAY = usArmy_armor;

RED_UNITS_ARRAY = BocoHaran_units + Isis_units;

RED_VEHICLE_ARRAY = Isis_Vehicles;

RED_TANK_ARRAY = Isis_Tanks;

COMMON_DONE = true;

