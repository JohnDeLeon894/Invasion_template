private _position = _this select 0;
private _composition = _this select 1;

private _azimuth = random 360;

TARGET_OBJECTS = [_position, _azimuth, call (compile (preprocessFileLineNumbers _composition))] call BIS_fnc_ObjectsMapper;

diag_log ['compositionSpawner finish', TARGET_OBJECTS];

spawnerDone = true;