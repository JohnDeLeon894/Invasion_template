currentDate = date;

diag_log format[" *** end mission triggered : %1 : %2 ***", currentDate, RED_TRIGGERS] ;
saveVar 'currentDate';
saveVar 'RED_TRIGGERS';
saveVar 'ALL_TRIGGERS';

hint format['%1', RED_TRIGGERS];

waitUntil{player distance WEST_SPAWN < 300};
sleep 10;

if ( false && count RED_TRIGGERS > 0 ) then {
	// optional contineus game for stand alone mission. 
	ACTIVE_TRIGGER = []execVM 'functions\findAndActivateNearestTrigger.sqf';
} else {
	"end1" call BIS_fnc_endMission;
}
