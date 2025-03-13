private _transport = _this select 0;

if (isNull _transport) exitWith {
	diag_log 'exiting transport_infil script';
	hint 'There are no transports available';
};

waitUntil {{_x in _transport} count units group player == 0};
// _transport animateDoor ['door_R', 0]; 
// _transport animateDoor ['door_L', 0];
_transport move getMarkerPos 'vtz';

waitUntil {unitReady _transport};

if (unitReady _transport) then
 { 
	sleep 30;
	hint format['%1 ready for nextmission', _transport];
	[_transport]execVM "functions\GroundTransports\addAction.sqf";
	_transport setVariable["onMission", false];
};