// [_group, _pos, _radius, 'patrol']call jMD_fnc_setOrders;

params ['_group', '_pos', '_radius', '_marker', '_orders', '_groupLeader'];
private _basePath = 'functions\backupManagement\';
private _path = format['%1%2.sqf', _basePath, 'statusCheck'];
private _mapGrid = mapGridPosition _pos;

private _response = format['This is %1, orders received. Patrolling around %2', _groupLeader, _mapGrid];

[_group, _pos, _radius, 'patrol']call jMD_fnc_setOrders;

_group setVariable ['currentOrders', _orders];
[_group, _marker, _orders, _pos, _response] execVM _path;