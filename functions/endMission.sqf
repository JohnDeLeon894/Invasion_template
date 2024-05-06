// private _trigger = _this select 0;
private _trigger = _this select 0;
currentDate = date;
ALL_TRIGGERS deleteAt (ALL_TRIGGERS find _trigger);

diag_log format['the Trigger Name: %1', _trigger];
diag_log format[" *** end mission triggered : %1 : %2 ***", currentDate, RED_TRIGGERS] ;
saveVar 'currentDate';
saveVar 'ALL_TRIGGERS';

hint format['%1', ALL_TRIGGERS];

// waitUntil{player distance WEST_SPAWN < 300};
sleep 10;

if ( CONTINUOUS && (count ALL_TRIGGERS > 0) ) then {
	// optional contineus game for stand alone mission. 
	ACTIVE_TRIGGER = []execVM 'functions\findAndActivateNearestTrigger.sqf';
} else {
	"end1" call BIS_fnc_endMission;
}
