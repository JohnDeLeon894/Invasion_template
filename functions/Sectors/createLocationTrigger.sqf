 params["_position", "_triggerName", "_sectorSize", "_locationName"];

 private _trigger = createTrigger['EmptyDetector', _position, true];
 
 private _sectorTriggerActivation = format ['private _numberToSpawn = ((random 6) + 4); ON_MISSION = true;[thisTrigger, thisList, _numberToSpawn] execVM "triggerActivation.sqf"; "%1" ', _locationName];

 _trigger setTriggerStatements ['false', _sectorTriggerActivation, ''];
 _trigger setTriggerArea [_sectorSize, _sectorSize, 0, true];

_trigger setVehicleVarName _triggerName;

 GENERATED_SECTORS pushBack [_triggerName, _trigger];