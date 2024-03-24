// ////////////////////////////////////////////////////////////////////////////
// Tactical Combat Link
// ////////////////////////////////////////////////////////////////////////////
// Feature Database
// Based on Operation Flashpoint Mod E.C.P. ( Enhanced Configuration Project )
// By =\SNKMAN/=
// ////////////////////////////////////////////////////////////////////////////

if (TCL_Server) then
{
	if (isNil "TCL_Feature") then
	{
		TCL_Feature = [
		
			// 0 ( Watch/scan area for targets )
			True,
			30,
			
			// 2 ( Garrison buildings )
			True,
			
			// 3 - 6 ( Smoke )
			// Unit enable,chance, Veh enable, chance 
			True,
			15,
			True,
			60,
			
			// 7 ( Flare )
			True,
			20,
			
			// 9 ( Artillery )
			False,
			99,
			
			// 11 ( House Search )
			True,
			75,
			
			// 13 ( Static Weapon )
			True,
			70,
			
			// 15 - 18 ( Take Cover )
			// Enable,chance to cover, search dist, Cov to cov chance
			True,
			95,
			70,
			90,
			
			// 19 - 21 ( Flanking )
			//Enable,Chance, single or double envelope
			True,
			60,
			50,
			
			// 22 - 26 ( Advancing )
			// Weapon fired reaction, Suppressed dist, GL dist, AT dist,general dist
			True,
			15,
			50,
			300,
			900,
			
			
			// 27 - 29 ( Suppressed )
			True,
			0.9,
			5,
			
			// 30 - 31 ( Heal )
			True,
			70,
			
			// 32 - 33 ( Rearm )
			True,
			70,
			
			// 34 - 35 ( Surrender )
			True,
			15
		];
		
		if (TCL_FilePatching) then
		{
			if ("UserConfig\TCL\TCL_Feature.sqf" call TCL_Exist_F) then
			{
				call compile preprocessFileLineNumbers "UserConfig\TCL\TCL_Feature.sqf";
			};
		};
	};
};