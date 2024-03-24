// ////////////////////////////////////////////////////////////////////////////
// Tactical Combat Link
// ////////////////////////////////////////////////////////////////////////////
// Radio Database
// Based on Operation Flashpoint Mod E.C.P. ( Enhanced Configuration Project )
// By =\SNKMAN/=
// ////////////////////////////////////////////////////////////////////////////

if (TCL_Server) then
{
	if (isNil "TCL_Radio") then
	{
		TCL_Radio = [
		
			// 0 - 2 ( Radio request )
			// Enable, time to call, Distance to called
			// Inf,veh,Armour,CAS,Ships
			True,
			10,
			[1000, 3000, 4800, 10000, 13000]
		];
		
		if (TCL_FilePatching) then
		{
			if ("UserConfig\TCL\TCL_Radio.sqf" call TCL_Exist_F) then
			{
				call compile preprocessFileLineNumbers "UserConfig\TCL\TCL_Radio.sqf";
			};
		};
	};
};