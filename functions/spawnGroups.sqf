// spawns units when called
// [_group, _count, _unitsArray, _position] call spawnGroups;

private _group 			= _this select 0;
private _count 			= _this select 1;
private _unitsArray		= _this select 2;
private _position 		= _this select 3;
private _special 		= _this select 4;

if(_count < 1 ) exitWith {hint "exiting spawn loop"};
if(isNil "_special") then { _special = 'NONE'};
// spawns unit and adds to group
for [{private _i=0}, {_i<_count}, {_i=_i+1}] do {
	private _soldierRole =  _unitsArray call BIS_fnc_selectRandom; 
	private _newRecruit = _group createUnit [_soldierRole, [_position select 0, _position select 1], [], 50, _special];
	// _newRecruit setVariable ["lambs_danger_disableAI",true]; 
	if ( _group == group player ) then {
		player createDiarySubject['spawnRecord', 'Spawn Record'];
		player createDiaryRecord ['spawnRecord',[format ['%1', _newRecruit], format['this is the unit spawned: %1', configOf _newRecruit]]];
	};

};

// return value
_group