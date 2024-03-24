/*

Once a defined area around the HQ is cleared, the transport choppers will move to the Helo zone and will be ready for orders. 

*/

zoneClear = true;
{
	call compile format['[%1] execVM "functions\transport\transport_infil_action.sqf"', _x];
}  forEach TRANSPORTS;
{
	call compile format['[%1] execVM "functions\transport\transport_infil_action.sqf"', _x];
}  forEach CAS;

