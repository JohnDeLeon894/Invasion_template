{
	if (side _x == WEST) then {
		[_x] call jMD_fnc_setGroupCallSign;
	};
} forEach allGroups;

true;