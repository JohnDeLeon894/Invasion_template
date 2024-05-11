private _pos = _this select 0;
private _action = _this select 1; 

hint _action;
// [] execVM 'chopperAddAction.sqf';
if (_action == 'reinforce') then {
	reinforceReady = false; 
	call compile format['[%1] execVM "functions\chopper\chopper_%2_action.sqf"', _pos , _action];
	_action = 'infil';
	waitUntil {reinforceReady};	
};

hint format ['HellCat moving to POS %1, action %2', _pos, _action];
hellcat_6 move _pos;
hint format["moving to %1", _pos] ;

waitUntil {unitReady hellcat_6};

if (unitReady hellcat_6) then
 { 
	hint "landing";
	hellcat_6 land "GET IN";
};

// waitUntil{ready};
if (_action != 'reinforce') then {
call compile format['[%1] execVM "functions\chopper\chopper_%2_action.sqf"', _pos , _action];
};