private ['_numberOfRounds','_ammoType', '_position', '_fireMissionName', '_artyRounds', '_repeatFireMission'];
_numberOfRounds = _this select 0;
_ammoType = _this select 1;
_position = _this select 2;
_fireMissionName = _this select 3;

player createDiarySubject['Arty Record', 'Artilory Record'];
// ["rhs_mag_155mm_m795_28","rhs_mag_155mm_m825a1_2","rhs_mag_155mm_485_2","rhs_mag_155mm_m712_2","rhs_mag_155mm_m731_1","rhs_mag_155mm_raams_1","rhs_mag_155mm_m864_3"]
private _parseAmmoType = {
	private _string = _this select 0;
	_artyRounds = "rhs_mag_155mm_m795_28";
	if ('smoke' in _string) then {_artyRounds ='rhs_mag_155mm_m825a1_2' };
	if ('flare' in _string) then {_artyRounds ='rhs_mag_155mm_485_2' };
	if ('lg' in _string) then {_artyRounds = 'rhs_mag_155mm_m712_2'};
	if ('cluster' in _string) then {_artyRounds = 'rhs_mag_155mm_m864_3'};
	if ('guided' in _string) then {_artyRounds = 'rhs_mag_155mm_m712_2'};
	_artyRounds
};

private _artilleryCall = {
	private _gridPos = mapGridPosition _position;
	private _artyMessage = format ['This is %1 requesting arty mission on grid %2, how copy over.', groupId group player, _gridPos];
	private _firMissionRecord = player createDiaryRecord ['Arty Record',[_fireMissionName, _artyMessage]];
	private _timesFailed = 0;
	private _timeoutCount = ((floor random 10) + 5);
	private _artyRounds = [_ammoType] call _parseAmmoType;
	private _fireMissionFailed = false;

	player commandChat _artyMessage;

	sleep _timeoutCount;

	{	
		private _withinRange = _position inRangeOfArtillery [[_x], _artyRounds];
		private _eta = _x getArtilleryETA[_position, _artyRounds];
		private _artyResponse = format ['%1, firing %4 %5 rounds on grid %2. Rounds ETA in %3. Out.', _x, _gridPos, _eta, _numberOfRounds, _artyRounds];
		private _artyNotReady = format ['%1 is not ready', _x];

		// _x setAmmo [currentWeapon _x, 12];
		_x setVehicleAmmo 1;

		if(unitReady _x && _withinRange) exitWith {
			if(_numberOfRounds == 0) then { _numberOfRounds = 1};
			_x commandChat _artyResponse;
			_firMissionRecord = player createDiaryRecord ['Arty Record',[_fireMissionName, _artyResponse]];
			_x commandArtilleryFire [_position, _artyRounds, _numberOfRounds];
		};
		_timesFailed = _timesFailed + 1;
		_x commandChat _artyNotReady;
		if ( ! _withinRange) then {
			_artyNotReady = 'Not within range';
		};
		player createDiaryRecord ['Arty Record',[_fireMissionName, _artyNotReady]];
		if ( _timesFailed > 4) exitWith {
			_fireMissionFailed = true;
		}
	} forEach ARTY;

	if (_fireMissionFailed) exitWith {
		private _noGuns = 'No guns currently available, call new mission ';
		player createDiaryRecord ['Arty Record',[_fireMissionName, _noGuns]];
		m1 sideChat 'No guns currently available, call new mission ';
	};
};

[] call _artilleryCall;

// create link to call again
//  player createDiaryRecord ["Diary", ["Execute","<execute expression='hint ""Some code"";'>Some text</execute>"], taskNull, "", false];
_repeatFireMission = format['<execute expression="[%1, ''%2'', %3, ''%4'']call jMD_fnc_artilleryCall;">Click here to repeat fire mission %4', _numberOfRounds, _ammoType, _position, _fireMissionName];
 
player createDiaryRecord ['Arty Record',[_fireMissionName, _repeatFireMission]];