if ( !isNull player) then {
	playerGroup = createGroup west;
	[playerGroup, BLU_UNIT_SIZE, BLU_UNITS_ARRAY, WEST_SPAWN] call  jMD_fnc_spawnGroups;
	playerUnit = units playerGroup select 0;
	selectPlayer playerUnit;
};