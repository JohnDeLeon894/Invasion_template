
private _markerCount = 0;
private _fireMissionFailed = false;
player createDiarySubject['Arty Record', 'Artilory Record'];
// private _artyRounds = 'rhs_mag_m26a1_6';
private _artyRounds = '32Rnd_155mm_Mo_shells';
//["32Rnd_155mm_Mo_shells","4Rnd_155mm_Mo_guided","6Rnd_155mm_Mo_mine","2Rnd_155mm_Mo_Cluster","6Rnd_155mm_Mo_smoke","2Rnd_155mm_Mo_LG","6Rnd_155mm_Mo_AT_mine"]
private _nameFireMission = {
	private _verb = VERBS call BIS_fnc_selectRandom;
	private _noun = NOUNS call BIS_fnc_selectRandom;
	private _adjective = ADJECTIVES call BIS_fnc_selectRandom;
	private _newName = format ['fire mission %1-%2', _adjective, _noun];
	_newName
};

private _replaceMarker = {
	private _mark = _this select 0;
	private _missionName = _this select 1;

	m1 globalChat "replacing marker";
	// private _fireMissionName = [] call _nameFireMission;
	private _artyMarker = createMarker [_fireMissionName, _pos ];
	_artyMarker setMarkerType "mil_warning_noShadow";
	_artyMarker setMarkerText _missionName;
	_artyMarker setMarkerColor 'ColorRed';
	format['original name %1', _missionName];
	deleteMarker _mark;
};

private _parseAmmoType = {
	// private _mrkText = _this select 0;
	if ('smoke' in _mrkText) then {_artyRounds ='6Rnd_155mm_Mo_smoke' };
	if ('lg' in _mrkText) then {_artyRounds = '2Rnd_155mm_Mo_LG'};
	if ('cluster' in _mrkText) then {_artyRounds = '2Rnd_155mm_Mo_Cluster'};
	if ('guided' in _mrkText) then {_artyRounds = '4Rnd_155mm_Mo_guided'};
	// default { _artyRounds ='32Rnd_155mm_Mo_shells'};
};

{
	private _fireMissionName = [] call _nameFireMission;
	private _step = 0;
	private _mrkText = markerText _x;
	private _isArty = 'arty' in _mrkText;
	if ((_x find "_USER_DEFINED") >= 0 && _isArty) then {
		_mrkText call _parseAmmoType;
		private _roundsToFire = parseNumber _mrkText;
		private _scopedMarker = _x;
		player commandChat format['original name %1', _fireMissionName];
		private _pos = markerPos _scopedMarker;
		private _gridPos = mapGridPosition _pos;
		private _artyMessage = format ['This is %1 requesting arty mission on grid %2, how copy over.', groupId group player, _gridPos];
		private _firMissionRecord = player createDiaryRecord ['Arty Record',[_fireMissionName, _artyMessage]];
		player commandChat _artyMessage;
		private _timesFailed = 0;

		sleep 5;

		{	
			private _withinRange = _pos inRangeOfArtillery [[_x], _artyRounds];
			private _eta = _x getArtilleryETA[_pos, _artyRounds];
			private _artyResponse = format ['%1, firing %4 %5 rounds on grid %2. Rounds ETA in %3. Out.', _x, _gridPos, _eta, _roundsToFire, _artyRounds];
			private _artyNotReady = format ['%1 is not ready', _x];

			// _x setAmmo [currentWeapon _x, 12];
			_x setVehicleAmmo 1;

			if(unitReady _x && _withinRange) exitWith {
				_step = _step + 1; 
				if(_roundsToFire == 0) then{ _roundsToFire = 1};
				hint format['stopped at step %1',_step];
				[_scopedMarker, _fireMissionName] call _replaceMarker;
				_x commandChat _artyResponse;
				_firMissionRecord = player createDiaryRecord ['Arty Record',[_fireMissionName, _artyResponse]];
				_x commandArtilleryFire [_pos, _artyRounds, _roundsToFire];
			};
			_step = _step + 1; 
			_timesFailed = _timesFailed + 1;
			hint format['stopped at step %1',_step];
			_x commandChat _artyNotReady;
			if ( ! _withinRange) then {
				_artyNotReady = 'Not within range';
			};
			player createDiaryRecord ['Arty Record',[_fireMissionName, _artyNotReady]];
			if ( _timesFailed > 4) exitWith {
				_fireMissionFailed = true;
			}
		} forEach ARTY;
	};

	if (_fireMissionFailed) exitWith {

		private _noGuns = 'No guns currently available, call new mission ';
		player createDiaryRecord ['Arty Record',[_fireMissionName, _noGuns]];
		m1 sideChat 'No guns currently available, call new mission ';
	};
	
} forEach allMapMarkers;

