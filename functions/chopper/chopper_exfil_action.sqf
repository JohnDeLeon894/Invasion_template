waitUntil {{_x in hellcat_6} count units group player == {alive _x} count units group player};

hellCat_6 move getMarkerPos 'lz1';

waitUntil {unitReady hellcat_6};

if (unitReady hellcat_6) then
 { 
	hint "landing";
	hellcat_6 land "land";
	sleep 30;
	hint 'HellCat 6 ready for nextmission';
};