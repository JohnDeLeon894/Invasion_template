// ////////////////////////////////////////////////////////////////////////////
// Tactical Combat Link
// ////////////////////////////////////////////////////////////////////////////
// A.I. Database
// Based on Operation Flashpoint Mod E.C.P. ( Enhanced Configuration Project )
// By =\SNKMAN/=
// ////////////////////////////////////////////////////////////////////////////
// FPR STEALTH MISSIONS
if (TCL_Server) then
{
	if (isNil "TCL_AI") then
	{
		TCL_AI = [
		
			// 0 - 2 ( Reinforcement )
			// Knowledge, Courage,Groups
			1.5,
			0.15,
			4,
			
			// 3 - 6 ( Additional )
			// Enable,Knowledge,Distance,Join
			True,
			2,
			2000,
			True,
			
			// 7 - 8 ( Disable )
			// Disable movement,Request
			False,
			False,
			
			// 9 ( Regroup )
			True,
			
			// 10 ( Timeout )
			// Searchtime
			120,
			
			// 11 ( Synchronize )
			// Syncronize caller with called
			False
		];
		
		if (TCL_FilePatching) then
		{
			if ("UserConfig\TCL\TCL_AI.sqf" call TCL_Exist_F) then
			{
				call compile preprocessFileLineNumbers "UserConfig\TCL\TCL_AI.sqf";
			};
		};
	};
};