params ['_position', '_groupName', '_group', '_marker', '_orders'];
diag_log 'infil orders recieved';

backupReady = false;
private _basePath = 'functions\backupManagement\';
[_position, _groupName] execVM 'functions\transport\callTransport.sqf';

waitUntil{ backupReady == true };

_groupLeader = (units _group) select 0;

private _path = format['%1%2.sqf', _basePath, 'statusCheck'];
private _response = format['This is %1 from %2. Orders received.', _groupLeader, _groupName];

_group setVariable ['currentOrders', _orders];
[_group, _marker, _orders, _position, _response] execVM _path;