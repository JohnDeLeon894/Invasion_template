// ////////////////////////////////////////////////////////////////////////////
// Tactical Combat Link
// ////////////////////////////////////////////////////////////////////////////
// System Database
// Based on Operation Flashpoint Mod E.C.P. ( Enhanced Configuration Project )
// By =\SNKMAN/=
// ////////////////////////////////////////////////////////////////////////////

if (isNil "TCL_System") then
{
	TCL_System = [
	
		// 0 ( Delay )
		15,
		
		// 1 ( A.I. )
		True,
		
		// 2 ( Sides )
		[EAST,RESISTANCE,WEST],
		
		// 3 ( Combat System )
		True,
		
		// 4 ( Get In )
		True,
		
		// 5 ( Advanced Skills )
		True,
		
		// 6 ( Skill Divider )
		// 0 = high skill 7 = Arma default
		0,
		
		// 7 ( Zeus Spawn init )
		True,
		
		// 8 ( Delay to activate )
		5,
		
		// 9 ( special FX system )
		True,
		
		// 10 ( Player Respawn )
		False
	];
	
	if (TCL_Server) then
	{
		if (TCL_FilePatching) then
		{
			if ("UserConfig\TCL\TCL_System.sqf" call TCL_Exist_F) then
			{
				call compile preprocessFileLineNumbers "UserConfig\TCL\TCL_System.sqf";
			};
		};
		
		if (TCL_Multiplayer) then
		{
			publicVariable "TCL_System";
		};
	};
};