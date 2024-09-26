// controller for commands to backup

// list of commands for backup group

/**
	infil - command to call new backup group and infil at marked location 
	status check - request status updated of given group
	patrol - patrol area around marker 
	move - move and hold position
	attack - engage marked position
 */
diag_log 'backup manager started';
params ['_group', '_splitMarkerText', '_marker', '_pos'];

private _basePath = 'functions\backupManagement\';
private _aliveCount = { alive _x} count (units _group);
private _groupLeader = units _group select 0;
private _groupName = _splitMarkerText select 0;
private _orders = _splitMarkerText select 1;
private _radius = _splitMarkerText select 2;

diag_log ['_group', _group, 'marker text', _splitMarkerText, 'marker', _marker];

if ((_aliveCount == 0) && (_orders != "infil")) exitWith {

	private _markerText = 'Status: Unresponsive';
	_marker setMarkerText _markerText;
};

if (isNil('_orders')) then {
	_orders = '';
};

switch (_orders) do {
	case "infil": {
		diag_log 'infil orders';
		private _path = format['%1%2.sqf', _basePath, _orders];
		// ['_position', '_groupName', '_groupLeader', '_group', '_marker', '_orders'];
		[_pos, _groupName, _group, _marker, _orders]execVM _path;
	 };
	case "status": {
		diag_log 'status orders';
		private _path = format['%1%2.sqf', _basePath, 'statusCheck'];
		[_group, _marker, _orders, _pos] execVM _path;
	 };
	case "patrol": {
		diag_log 'patrol orders';
		if (isNil('_radius')) then {
			_radius = 200;
		};

		private _path = format['%1%2.sqf', _basePath, _orders];
		[_group, _pos, _radius, _marker, _orders, _groupLeader]execVM _path;
	 };
	case "move": {
		diag_log 'move orders';
		if (isNil('_radius')) then {
			_radius = 200;
		};

		private _path = format['%1%2.sqf', _basePath, _orders];
		[_group, _pos, _radius, _marker, _orders, _groupLeader]execVM _path;

	 };
	case "attack": {

	 };
	default {
		private _path = format['%1%2.sqf', _basePath, 'statusCheck'];
		[_group, _marker, _orders, _pos] execVM _path;
	};
};