diag_log '*** exit script fired ***';

player saveStatus "playerstate";
{
	pickWeaponPool _x;
} foreach TRANSPORTS;