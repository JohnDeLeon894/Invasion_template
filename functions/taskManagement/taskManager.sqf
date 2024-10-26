// select mission to run from a list of missions and call that mission
private _activePositions = _this select 0;
private _sectorName = _this select 1;

private _missionList = ['patrol', 'assault', 'fetch'];
// private _chosenMission = _missionList call BIS_fnc_selectRandom;
private _chosenMission = 'assault';

switch (_chosenMission) do {
	case 'patrol': {
		[_activePositions, _sectorName] execVM 'functions\taskManagement\patrolTask.sqf';
	 };
	case 'assault': { 
		[_activePositions, _sectorName] execVM 'functions\taskManagement\assaultTask.sqf';
	};
	case 'fetch': { 
		[_activePositions, _sectorName] execVM 'functions\taskManagement\fetchTask.sqf';
	};
	default { };
};