diag_log '*** exit script fired ***';

player saveStatus "playerstate";
{
	private _transport = call compile _x;
	pickWeaponPool _transport;
} foreach TRANSPORTS;