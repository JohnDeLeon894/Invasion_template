{
	{
		[_x, (group _x), _x, nil, 300] execVM 'functions\enemySpottedCallOut.sqf'
	} forEach (units (_x select 0)) ;
} forEach SECTOR_GROUPS;