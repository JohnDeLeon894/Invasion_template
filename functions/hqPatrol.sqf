// BLU_LOCAL_GUARD

// find hq
private _hqPOS = WEST_SPAWN;
private _groupSize = 6;
private _group = hq_guard;
private _radius = 300;

diag_log 'calling spawn groups from HQ Patrol';
[_group, (_groupSize + (floor (random 4))), BLU_GUARD_ARRAY, _hqPOS] call  jMD_fnc_spawnGroups;
[_group, _hqPOS, _radius, 'camp']call jMD_fnc_setOrders;
[_group] call jMD_fnc_setGroupCallSign;
hQGuard_TL = (units _group) select 0;