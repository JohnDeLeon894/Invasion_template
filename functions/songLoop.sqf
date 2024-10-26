

private _playMusic = {

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
};

private _songLoop = {
	call _playMusic;
	sleep 300;
	call _songLoop;
};

call _songLoop;

