// only gets human players
private _headlessClients = entities 'HeadlessClient_F';
private _humanPlayers = allPlayers - _headlessClients;

private _moveGroupToMarkerPos = {
	private _group = _this select 0;
	private _position = _this select 1;
	private _marker = _this select 2;
	private _mapGridPos = mapGridPosition _position;

	player sideChat format ['Troops in contact, repeat; Troops in contact. Map grid %1.', _mapGridPos];

	sleep 3;

	(units _group select 0) sideChat format ['request recieved, %1 moving to %2', _group, _mapGridPos];

	
	_group setBehaviour 'aware';
	_group move _position;
};

private _taskMarkerName = {
	private _taskName = _this select 0;
	private _verb = VERBS call BIS_fnc_selectRandom;
	private _noun = NOUNS call BIS_fnc_selectRandom;
	private _adjective = ADJECTIVES call BIS_fnc_selectRandom;
	private _newName = format [' %1 %2-%3-%4', _taskName, _verb, _adjective, _noun];
	_newName
};


private _replaceMarker = {
	private _mark = _this select 0;
	private _missionName = _this select 1;
	private _pos = markerPos _mark;

	m1 globalChat 'replacing marker';
	// private _fireMissionName = [] call _nameFireMission;
	private _artyMarker = createMarker [_missionName, _pos];
	_artyMarker setMarkerType 'mil_warning_noShadow';
	_artyMarker setMarkerText _missionName;
	_artyMarker setMarkerColor 'ColorRed';
	format['original name %1', _missionName];
	deleteMarker _mark;
};

private _splitOnChoppa = {
	private _string = _this select 0;

	private _splitString = _string splitString '_- ';

	_splitString
};

private _artyProcessor = {
	private ['_artyData', '_numberOfRounds','_ammoType', '_position', '_missionName', '_hasAmmoType'];
	_artyData = _this select 0;
	_numberOfRounds = parseNumber (_artyData select 1);
	_hasAmmoType = (! isNil { _artyData select 2 });
	_ammoType =  ['default', _artyData select 2] select (! isNil { _artyData select 2 });
	hint format['has ammo type? %1, _ammoType = %2, number of rounds %3', _hasAmmoType, _ammoType, _numberOfRounds];
	_position = _this select 1;
	_missionName = _this select 2;
	[_numberOfRounds, ['default', _ammoType] select _hasAmmoType, _position, _missionName] call jMD_fnc_artilleryCall;
};

{
	if ((_x find '_USER_DEFINED') >= 0) then {
		private _mrkText = toLower(markerText _x);
		private _position = markerPos _x;
		private _marker = _x;
		private _splitMarkerText = [_mrkText] call _splitOnChoppa;
		hint format ['%1', _splitMarkerText];

		private _theCaller = _marker;
		_theCaller = (_theCaller splitString '#/,_USER_DEFINED ') select 0;
		private _stringToPrint = format['*** *** *** support caller is %1 *** *** ***', _theCaller];
		diag_log _stringToPrint;
		private _userId = getPlayerUID player;
		private _stringToPrint = format['*** *** *** support caller is %1 *** *** ***', _userId];
		diag_log _userId;

		if ('arty' in _mrkText) then {
			private _splitMarkerText = [_mrkText] call _splitOnChoppa;
			private _missionName = [_splitMarkerText select 0] call _taskMarkerName;
			[_marker, _missionName] call _replaceMarker;
			[_splitMarkerText, _position, _missionName] call _artyProcessor;
			continue
		};
		if (_mrkText == 'reinforce') then {
			[_position, 'reinforce'] execVM 'functions\transport\callTransport.sqf';
			private _missionName = [_mrkText] call _taskMarkerName;
			[_marker, _missionName] call _replaceMarker;
			sleep 5;		 
			continue
		}; 
		if (_mrkText == 'alpha') then {
			if ({alive _x}count(units backup_alpha) > 4) then {
				private _missionName = [_mrkText] call _taskMarkerName;
				
				if( isNil 'lambs_wp_fnc_taskGarrison') then {
					[backup_alpha, _position, 200] call BIS_fnc_taskPatrol;
				} else {
					[backup_alpha, _position, 200] call lambs_wp_fnc_taskPatrol;
				};
				[_marker, _missionName] call _replaceMarker;
			} else {
				[_position, 'alpha'] execVM 'functions\transport\callTransport.sqf';
				private _missionName = [_mrkText] call _taskMarkerName;
				[_marker, _missionName] call _replaceMarker;
			}; 
			sleep 5;
			continue
		}; 
		if (_mrkText == 'bravo') then {
			if ({alive _x}count(units backup_bravo) > 4) then {
				private _missionName = [_mrkText] call _taskMarkerName;
				if( isNil 'lambs_wp_fnc_taskGarrison') then {
					[backup_bravo, _position, 200] call BIS_fnc_taskPatrol;
				} else {
					[backup_bravo, _position, 200] call lambs_wp_fnc_taskPatrol;
				};
				[_marker, _missionName] call _replaceMarker;
			} else {
				[_position, 'bravo'] execVM 'functions\transport\callTransport.sqf';
				private _missionName = [_mrkText] call _taskMarkerName;
				[_marker, _missionName] call _replaceMarker;
			}; 
			sleep 5;
			continue
		}; 
		if (_mrkText == 'charlie') then {
			if ({alive _x}count(units backup_charlie) > 4) then {
				private _missionName = [_mrkText] call _taskMarkerName;
				if( isNil 'lambs_wp_fnc_taskGarrison') then {
					[backup_charlie, _position, 200] call BIS_fnc_taskPatrol;
				} else {
					[backup_charlie, _position, 200] call lambs_wp_fnc_taskPatrol;
				};
				[_marker, _missionName] call _replaceMarker;
			} else {
				[_position, 'charlie'] execVM 'functions\transport\callTransport.sqf';
				private _missionName = [_mrkText] call _taskMarkerName;
				[_marker, _missionName] call _replaceMarker;
			}; 
			sleep 5;
			continue
		}; 
		if (_mrkText == 'tic') then {
			{
				// [_x, _position, _marker] call _moveGroupToMarkerPos;
				/*
				0: Unit fleeing <OBJECT>
				1: Destination <ARRAY>
				2: Forced retreat, default false <BOOL>
				3: Distance threshold, default 10 <NUMBER>
				4: Update cycle, default 2 <NUMBER>
				5: Is Called for Waypoint, default false <BOOLEAN>

				[bob, getPos angryJoe] spawn lambs_wp_fnc_taskAssault;
				*/
				[_x, _position, false, 100, 4, false] spawn lambs_wp_fnc_taskAssault;
			} forEach FRIENDLY_GROUPS;
			private _missionName = [_mrkText] call _taskMarkerName;
			[_marker, _missionName] call _replaceMarker;
			continue
		}; 
		if ((_mrkText == 'pickup') || (_mrkText == 'exfil')) then {
			[_position, 'exfil'] execVM 'functions\transport\callTransport.sqf';
			private _missionName = [_mrkText] call _taskMarkerName;
			[_marker, _missionName] call _replaceMarker;
			continue
		}; 
		if (_mrkText == 'infil') then {
			[_position, 'infil'] execVM 'functions\transport\callTransport.sqf';
			private _missionName = [_mrkText] call _taskMarkerName;
			[_marker, _missionName] call _replaceMarker;
			continue
		}; 
// []execVM 'functions\CAS\callCAS.sqf';
		if (_mrkText == 'cas') then {
			[_position, 'infil'] execVM 'functions\transport\callTransport.sqf';
			private _missionName = [_mrkText] call _taskMarkerName;
			[_marker, _missionName] call _replaceMarker;
			continue
		}; 
	};
} forEach allMapMarkers;