/*
onMapSingleClick '
onMapSingleClick "";
[this]execVM "functions\rhino\transportAddAction.sqf";';
*/
private _transport = _this select 0;
hint format ["this = %1", _transport];

driver _transport setbehaviour "CARELESS";

_transport addAction [ 
	"Hey there buddy!",  
	{
		1 cutText ["Needa a ride? Get all your men in and click where you want to go on the map whem you're ready.", "PLAIN"];
		_this select 0 onMapSingleClick '
			onMapSingleClick "";
			[_this, "infil", _pos]execVM "functions\transport\transportAction.sqf";
		';

		// hint format ['params %1, %2, %3, %4',_transport select 0, _transport select 1, _transport select 2, _transport select 3]; 
		_this select 0 removeAction (_this select 2);
	}, 
	nil,		// arguments
	1.5,		// priority
	true,		// showWindow
	true,		// hideOnUse
	"",			// shortcut
	"true", 	// condition
	5,			// radius
	false,		// unconscious
	"",			// selection
	""			// memoryPoint
];