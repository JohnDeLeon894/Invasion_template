private _transport = _this select 0;

waitUntil {{_x in _transport} count units group player == {alive _x} count units group player};

_transport move getMarkerPos 'rtz';

waitUntil {unitReady _transport};

if (unitReady _transport) then
 { 
	hint "landing";
	_transport land "land";
	sleep 30;
	hint format['%1 ready for nextmission', _transport];
};