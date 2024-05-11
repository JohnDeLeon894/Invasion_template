hellcat_6 addAction 
[ 
	"ready",  
	{
		ready = true; hint format ['params %1, %2, %3, %4',_this select 0, _this select 1, _this select 2, _this select 3]; 
		hellcat_6 removeAction (_this select 2);
	}, 
	nil,		// arguments
	1.5,		// priority
	true,		// showWindow
	true,		// hideOnUse
	"",			// shortcut
	"true", 	// condition
	50,			// radius
	false,		// unconscious
	"",			// selection
	""			// memoryPoint
];