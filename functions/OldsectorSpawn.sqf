                            // creates enemy groups and sets them to patrol or garison near their spawn marker
// [trigger, group size] call jMD_fnc_sectorspawn

private _trigger	 = _this select 0;
private _groupsize	 = _this select 1;
private _nearbyLocations = _this select 2;
private _usePosition = _this select 3;
private _arearadious = _this select 4;
private _locationcount = count _nearbyLocations;
private _resultsArray = [];
hint format ['trigger: %1', _trigger];

// private _markers = EAST_POSITIONS select {(getmarkerPos _x) inArea _trigger};
// hint format _markers;
private _spawnedCount = 0;
private _tries = 0;

{
    private ['_destination', '_d20', '_position'];
    _tries = _tries +1;
    _d20 = ceil(random 100);
    _dinominator = _locationcount + _arearadious;
    private _challenge = 3.4 * (ceil ((_locationcount /_dinominator) * 100)); // formula for balance spawn locations chance to spawn. This is an effort to spread out the spawn locations when the location array has many objects close to each other. 
    /*
    var percentageCalculator = (a, b) => {
    const denominator = a + b 
    return {
        'percentage of a': ((a/denominator) * 20).toFixed(0),
        'percentage of b': ((b/denominator) * 20).toFixed(0)
    } 
    (parseInt(percentageCalculator( 600, 600 )['percentage of a']))*3 results in 30
    (parseInt(percentageCalculator( 263, 600 )['percentage of a']))*3 results in 18
}
    */

    _challenge = [_challenge, 99] select (_challenge > 99);
    if ((_d20 > _challenge) && (_spawnedCount < 6)) then {
        _resultsArray pushBack _x;
        groupcount = groupcount + 1;
        _spawnedCount = _spawnedCount + 1;
        
        private _groupname = format ['enemygroup_%1', groupcount];
        _groupname = creategroup [east, false];
        private _waypointScript = [
            "\z\lambs\addons\wp\scripts\fnc_wpPatrol.sqf",
            "\z\lambs\addons\wp\scripts\fnc_wpGarrison.sqf"
        ] call BIS_fnc_selectRandom;

        if ( _usePosition ) then {
            _position = position _x; 
        } else {
            _position = locationposition _x
        };
        [_groupname, _groupsize, RED_units_ARRAY, _position] call jMD_fnc_spawngroups;
        
        private _wp = _groupname addWaypoint [_position, 200];
        // [_groupname, (count waypoints _groupname) - 1 ] setwaypointScript _waypointScript;
        _wp setWaypointType 'DISMISS';
				_wp setWaypointBehaviour 'SAFE';
    };
    
// move trigger here to detect death of group
} forEach _nearbyLocations;

_resultsArray 