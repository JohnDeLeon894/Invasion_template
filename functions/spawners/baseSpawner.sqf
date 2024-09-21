private _trigger = _this select 0;

{
	private _basePos = getMarkerPos _x;
	private _baseTriggerDistance = _basePos distance _trigger;

	if (_basePos inArea _trigger) then {
		private _groupName = format ['enemyGroup_%1', _x];
		private _eastGroup = createGroup [east, false];
		_eastGroup setGroupId [_groupName];
		diag_log 'calling spawn groups from sectorSpawn 1';
		_eastGroup = [_eastGroup, (8 + random 4), RED_units_ARRAY, _basePos] call jMD_fnc_spawnGroups;

		[_eastGroup, _basePos, 100, 'garrison'] call jMD_fnc_setOrders;

		continue;
	};

	private _inActiveTrigger = 0;

	{
		private _outsideTrigger = call compile _x;
		if (_basePos inArea _outsideTrigger) then {
			_inActiveTrigger = _inActiveTrigger + 1;
		};
	} forEach ALL_TRIGGERS;

	if ((_inActiveTrigger > 0) && (_baseTriggerDistance < 5000)) then {
		private _groupName = format ['enemyGroup_%1', _x];
		private _eastGroup = createGroup [east, false];
		_eastGroup setGroupId [_groupName];
		diag_log 'calling spawn groups from sectorSpawn 2';
		_eastGroup = [_eastGroup, (8 + random 4), RED_units_ARRAY, _basePos] call jMD_fnc_spawnGroups;

		[_eastGroup, _basePos, 100, 'garrison'] call jMD_fnc_setOrders;
	};

} forEach ALL_BASES;
