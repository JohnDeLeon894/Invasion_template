//This is the stop escorte script
//This is a public script and any modification has to be open source
//Vist AggGaming.com
//For help on this join the teamspeak ts3.AggGaming.com

_suspect = cursorTarget;

If !(_suspect in attachedObjects player)exitWith {hint "You need to be closers to the person"};

{ detach _x; } forEach attachedObjects player;
player setVariable ["agg_is_escorting", nil];
player removeAction AGG_TEMP_ACTION_STOPESCORT;