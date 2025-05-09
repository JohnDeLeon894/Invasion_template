 params["_position", "_triggerName", "_sectorSize", "_locationName"];

 private _trigger = createTrigger['EmptyDetector', _position, true];
 
 private _sectorTriggerActivation = format ['private _numberToSpawn = ((random 6) + 4); ON_MISSION = true;[thisTrigger, thisList, _numberToSpawn, "%1" ] execVM "triggerActivation.sqf";', _locationName];

 _trigger setTriggerStatements ['true', _sectorTriggerActivation, ''];
 _trigger setTriggerArea [_sectorSize, _sectorSize, 0, true];

_trigger setVehicleVarName _triggerName;

 GENERATED_SECTORS pushBack [_triggerName, _trigger];
 _trigger