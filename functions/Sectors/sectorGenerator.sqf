
AOSize = worldSize / 2 ;
AOCenter = [AOSize, AOSize];
squareKMeters = AOSize / 1000; 
numberOfSectors = floor squareKMeters;
sectorSize = AOSize / numberOfSectors;
sectorCenter = [(sectorSize / 2), (sectorSize / 2)];
loopCounter = 0; // keeps track of every loop. Should = numberOfSectors * numberOfSectors

GENERATED_SECTORS = [];

private _yOffset = 0;
private _xOffset = 0;
private _markerColor = 'ColorRed';
private _yLoop = {
	private _ActiveSectorsPositions = [];

	for "_i" from 1 to numberOfSectors do {
		private _centerY = sectorSize + _yOffset;

		[_xOffset] call _xLoop;

		_yOffset = _i * (sectorSize * 2); 
	};

	{
		private _sectorPosition = _x;
		[_sectorPosition] call _locationWorker;
	} forEach _ActiveSectorsPositions;
};

private _xLoop = {
	params ["_xOffset"];

	for "_j" from 1 to numberOfSectors do {
		private _markerName = format["sector_%1", loopCounter];
		private _centerX = sectorSize + _xOffset;
		private _sectorCenterPos = [_centerX, _centerY];
		// diag_log "Sector Center Log";
		// diag_log _sectorCenterPos;

		_xOffset = _j * (sectorSize * 2);
		// diag_log "the offset";
		// diag_log _xOffset;

		private _validPlaces = selectBestPlaces [_sectorCenterPos, (sectorSize / 2), "(2*houses) - (10 * sea) ", 1, 50];
		private _validPlacesCount = { 
			(_x select 1) > 0.8;
		} count _validPlaces;

		diag_log "Valid Places Count";
		diag_log _validPlacesCount;
		diag_log "Valid Places";
		diag_log _validPlaces;


		if (_validPlacesCount > 25) then {
			_markerColor = 'ColorRed';

			_ActiveSectorsPositions pushBack _sectorCenterPos;

			diag_log "******** params sending to createSectorTrigger ********";
			diag_log [_sectorCenterPos, _markerName, sectorSize];

			[_sectorCenterPos, _markerName, sectorSize] execVM "functions\Sectors\createSectorTrigger.sqf";

			private _testMarkerDot = createMarker[_markerName + "dot", _sectorCenterPos];
			_testMarkerDot setMarkerBrush 'Border';  
			_testMarkerDot setMarkerType "mil_warning_noShadow";
			_testMarkerDot setMarkerColor _markerColor; 
			_testMarkerDot setMarkerText _markerName;	
		} else {
			_markerColor = 'ColorGreen';
		};


		private _testMarker = createMarker[_markerName, _sectorCenterPos];  
		_testMarker setMarkerBrush 'Border';  
		_testMarker setMarkerShape 'RECTANGLE';  
		_testMarker setMarkerSize [sectorSize, sectorSize];  
		_testMarker setMarkerColor _markerColor; 
		_testMarker setMarkerText _markerName;

		loopCounter = loopCounter + 1; 
	};
};

private _locationWorker = {
	params ["_sectorCenterPos"];

			private _nearestNamedLocations = nearestLocations [_sectorCenterPos, ["Name", "NameCity", "NameCityCapital", "NameLocal", "NameMarine", "NameVillage"], sectorSize];
			private _nearestLocationNames = [];
			private _locationSizes = [];
			private _locationPositions = [];

			{
				private _markerName = format["sector_%1", loopCounter];
				_nearestLocationNames pushBack ( text _x); 
				_locationSizes pushBack (size _x);
				_locationPositions pushBack (locationPosition _x);

				private _locationName = text _x;
				private _locationSize = ((size _x select 0)+(size _x select 1));
				private _locationPosition = locationPosition _x;

				private _locationMarker = createMarker[_markerName, _locationPosition];  
				_locationMarker setMarkerBrush 'Cross';  
				_locationMarker setMarkerShape 'RECTANGLE';  
				_locationMarker setMarkerSize [_locationSize, _locationSize];  
				_locationMarker setMarkerColor _markerColor; 
				_locationMarker setMarkerText _locationName;
				diag_log "******** params sending to createLocationTrigger ********";
				diag_log [_locationPosition, _markerName, _locationSize, _locationName];
				[_locationPosition, _markerName, _locationSize, _locationName] execVM "functions\Sectors\createLocationTrigger.sqf";

				loopCounter = loopCounter + 1; 
				// private _locationMarker = createMarker[_markerName, _sectorCenterPos];
			} forEach _nearestNamedLocations;

			diag_log "**** location data ****";
			diag_log "Named Locations";
			diag_log _nearestNamedLocations;
			diag_log "Named Locations Names";
			diag_log _nearestLocationNames;
			diag_log "Location Sizes";
			diag_log _locationSizes;
			diag_log 'location Positions';
			diag_log _locationPositions;
			diag_log "**** location data End ****";
};

[] call _yLoop;

SECTOR_GENERATOR_DONE = true;

// myPlaces = selectBestPlaces [position player, 50, "meadow + 2*hills", 1, 5];

//forest
//trees
//meadow
//hills
//houses
//sea
//coast
//night
//rain
//windy
//deadBody
//waterDepth
//camDepth

// _nearbyLocations = nearestLocations [getPosATL player, ["RockArea", "VegetationFir"], 100];

// Name
// NameCity
// NameCityCapital
// NameLocal (will return names like Airport)
// NameMarine
// NameVillage