// called from radio. 
private _pos = _this select 0;
private _action = _this select 1;
// check for available transport
hint 'transport called';
{
	// Current result is saved in variable _x
	private _tooFarFromLZ = _x distance TRANSPORT_ZONE > 100;
	if(!(alive _x)) then {
		private _notAliveString = 'transport not alive';
		hint _notAliveString;
		diag_log _notAliveString;
		continue;
	};
	if (_tooFarFromLZ) then { 
		hint 'too far from lz'; 
		diag_log 'too far from lz';
		call compile format['[%1] execVM "functions\transport\transport_infil_action.sqf"', _x];
		continue; 
	};
	if(!(_x getVariable ['onMission', false]) && !(_tooFarFromLZ)) exitWith{
	// if(!(_tooFarFromLZ)) exitWith {
		_x setVariable ['onMission', true, true];
		hint format ['%1 on the move', _x];
		private _transportReport = format['%1 action sent assigned to %2', _action, _x];
		diag_log _transportReport;
		[_x, _action, _pos]execVM "functions\transport\transportAction.sqf";
	};
} forEach TRANSPORTS;