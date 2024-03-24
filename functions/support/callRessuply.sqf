
private _pos = _this select 0;
private _mapGridPos = mapGridPosition _pos;

player commandChat format ['This is %1 requesting supply drop on grid %2, how copy over.', player, _mapGridPos];
sleep 5;
ammoTruck sideChat format ['Ressuply mission on grid %1.', _mapGridPos];

ammoTruck move _pos;
waitUntil {unitReady ammoTruck};
sleep 300;

ammoTruck sideChat 'Moving back to base.';
ammoTruck move AMMO_ZONE;