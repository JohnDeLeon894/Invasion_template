
private _delay = 300;

private _song = [ 
	'extremeTrapRacingMusic', 
	'dragonCastle', 
	'powerfulTrapy',
	'theArmyOfMinotaur', 
	'computerGameIdra',
	'chillHipHop',
	'enigma',
	'deflector',
	'downtownGlow',
	'urbanHipHop',
	'whiteBatBroken',
	'whiteBatCultoftheskull',
	'whiteBatDarkAngel',
	'whiteBatDrive',
	'whiteBatFightLikeHell',
	'whiteBatHardware',
	'whiteBatHauntingoftheFlesh',
	'whiteBatLicenseToKill',
	'whiteBatPlagueRat',
	'whiteBatPrisonPlanet',
	'whiteBatRedux',
	'whiteBatTornFlesh',
	'whiteBatXenomorph'
]  call BIS_fnc_selectRandom;
hint _song; 
playMusic _song;

_delay = _delay + (random 90);
sleep _delay;
[]execVM 'functions\songLoop.sqf';