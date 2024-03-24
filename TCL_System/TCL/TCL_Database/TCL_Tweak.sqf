// ////////////////////////////////////////////////////////////////////////////
// Tactical Combat Link
// ////////////////////////////////////////////////////////////////////////////
// Tweak Database
// Based on Operation Flashpoint Mod E.C.P. ( Enhanced Configuration Project )
// By =\SNKMAN/=
// ////////////////////////////////////////////////////////////////////////////

if (TCL_Server) then
{
	if (isNil "TCL_Tweak") then
	{
		TCL_Tweak = [
			
			// 0 ( Behaviour combat or aware)
			70,
			
			// 1 ( Push and Stop Distance )
			200,
			
			// 2 ( Push Chance )
			20,
			
			// 3 ( Push Factor )
			0.15
		];
		
		if (TCL_FilePatching) then
		{
			if ("UserConfig\TCL\TCL_Tweak.sqf" call TCL_Exist_F) then
			{
				call compile preprocessFileLineNumbers "UserConfig\TCL\TCL_Tweak.sqf";
			};
		};
	};
};