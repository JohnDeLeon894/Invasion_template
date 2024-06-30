params ['_unit', '_group', '_target', '_groups', '_timeOut'];
private ['_targetPos', '_targetGrid', '_message'];
hint 'eventhandler fired!';
_targetPos = position _target;
_targetGrid = mapGridPosition _targetPos;
_message = format ['I see the enemy at %1', _targetGrid];
systemChat _message;

private _enemyMarker = createMarker[format['%1', _unit], _targetPos]; 
_enemyMarker setMarkerBrush 'Solid'; 
_enemyMarker setMarkerShape 'ELLIPSE'; 
_enemyMarker setMarkerSize [10, 10]; 
_enemyMarker setMarkerColor 'ColorRed';
_enemyMarker setMarkerAlpha 0.4;

if (isNil '_timeOut') then {
	_timeOut = 30;
};
sleep _timeOut;
deleteMarker _enemyMarker;
