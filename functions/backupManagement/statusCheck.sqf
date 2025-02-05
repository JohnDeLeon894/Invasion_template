params ['_group', '_marker',  '_orders', '_position', '_response'];

private _aliveCount = {alive _x} count (units _group);

private _unResponsiveString = format['%1 is not responding', _group];

private _currentOrders = _group getVariable 'currentOrders';
private _reportStatus = {
	if (isNil('_currentOrders')) then {
		_currentOrders = _orders;
	};

	// private _markerText = formatText['Status:', lineBreak, 'Squad Strength: ', _aliveCount, lineBreak, 'Current Orders:', _orders];

	private _markerText =  format['Unit Strength: %1 / Current Orders %2', _aliveCount, _currentOrders];
	private _groupLeader = (units _group) select 0;
	private _groupPos = position _groupLeader;
	private _mapPos = mapGridPosition _groupPos;
	private _statusString = format['This is %1, we have %2 units. We are at coordinates %3 We are executing a %4 order.', _groupLeader, _aliveCount, _mapPos, _currentOrders];

	diag_log format ['status call with params %1, %2, %3', _aliveCount,  _mapPos, _statusString];

	if(isNil('_response')) then {
		_response = _statusString
	};

	_marker setMarkerText (str _markerText);
	if (_orders == 'status') then {
		_marker setMarkerPos _groupPos;
	};
	_groupLeader sideChat _response;

	sleep 60;
	deleteMarker _marker;
};

private _noResponse = {
	private _markerText = format['Status: Unresponsive'];
	_marker setMarkerText _markerText;
};

[] call ([_noResponse, _reportStatus] select (_aliveCount > 0))
