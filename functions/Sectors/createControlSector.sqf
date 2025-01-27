/* 
This function will find all the bases and create control sector triggers.

4 global lists:
ALL_BASES:  all the base markers.
RED_BASES: all enemy bases.
GREEN_BASES: all friendly controlled bases.
KNOWN_BASES: All bases we know about.

if we know about a base, mission selection in the task manager should be handled different.
otions are defined in task manager

*/

// list of all bases
private _isNil_allBases = isNil 'ALL_BASES';
private _isNil_redBases = isNil 'RED_BASES';
private _isNil_greenBases = isNil 'GREEN_BASES';
private _isNil_knownBases = isNil 'KNOWN_BASES';

ALL_BASES = [ALL_BASES, []] select _isNil_allBases; 
RED_BASES = [RED_BASES, []] select _isNil_redBases; 
GREEN_BASES = [GREEN_BASES, []] select _isNil_greenBases; 
KNOWN_BASES = [KNOWN_BASES, []] select _isNil_knownBases; 

private _locationTypes = [
	'Name',
	'NameCity',
	'NameCityCapital',
	'NameLocal (will return names like Airport)',
	'NameMarine',
	'NameVillage'
];

if (_isNil_allBases) then {
	{
		if ( 'base_spawn' in _x) then {
			ALL_BASES pushBack _x;
			RED_BASES pushBack _x;
		};
	} forEach allMapMarkers;

};

private _createTrigger =  {
	params ['_position', '_marker', '_area', '_active'];

	private _newTrigger = createTrigger['EmptyDetector', _position, true];
	// define trigger activation script
	private _triggerActivation = format ['
		"%1" setMarkerColor "ColorRed";
		', _marker];
	// define trigger deactivation script
	private _sectorTriggerDeactivation = format [
		'"%1" setMarkerColor "ColorGreen"; 
		deletevehicle thisTrigger;', 
		_marker
	];

	// set trigger size
	_newTrigger setTriggerArea _area;
	// set trigger  activation conditions.
	_newTrigger setTriggerActivation ['none', 'PRESENT', true];
	//set trigger statements 
	_newTrigger setTriggerStatements [_active, _triggerActivation, _sectorTriggerDeactivation];
	//return new trigger
	_newTrigger
};

private _createSectorMarker = {
	params ['_markerName', '_markerPosition', '_brush', '_shape','_area', '_color'];

	private _newMarker = createMarker [_markerName, _markerPosition];

	_newMarker setMarkerBrush _brush;
	_newMarker setMarkerShape _shape;
	_newMarker setMarkerSize _area;
	_newMarker setMarkerColor '_color';
	_newMarker setMarkerText format['ENEMY BASE %1 - Debug log.', _markerName];

	_newMarker
};

private _redBaseSpawner = {
	params ['_basePos', '_groupName'];

	private _eastGroup = createGroup [east, false];
	_eastGroup setGroupId [_groupName];
	[_eastGroup, (8 + random 4), RED_units_ARRAY, _basePos] call jMD_fnc_spawnGroups;
	_eastGroup
};

private _blueBaseSpawner = {
	params ['_basePos', '_groupName'];

	private _westGroup = createGroup [west, false];
	_westGroup setGroupId [_groupName];
	[_eastGroup, (8 + random 4), BLU_GUARD_ARRAY, _basePos] call jMD_fnc_spawnGroups;
	_westGroup
};

private _redBaseGroupCounter = 0;
private _greenBaseGroupCounter = 0;
{
	// Current result is saved in variable _x
	private _marker = _x;
	private _markerPos = getMarkerPos _marker;
	private _area = [100, 100];

	_redBaseGroupCounter = _redBaseGroupCounter + 1;

	private _redGroupName = format['redBase_%1', _redBaseGroupCounter];
	diag_log ['base group name', _redGroupName];

	private _newMarker = [_redGroupName, _markerPos, 'CROSS', 'RECTANGLE', _area, 'ColorRed'] call _createSectorMarker;

	private _newGroup = [_markerPos, _redGroupName] call _redBaseSpawner;

	[_newGroup, _markerPos, _area, 'garrison'] call jMD_fnc_setOrders;

	// params ['_position', '_marker', '_area'];

	[_markerPos, _newMarker, _area, true] call _createTrigger;
	
} forEach RED_BASES;

{
	// Current result is saved in variable _x
	
} forEach GREEN_BASES;




