//SpawnVehicle.sqf
// Horbin
// 1/4/15
// INPUTS groupsdata array from Mission routine, Encounter center, mission size, array of groups from MissionInit.
// OUTPUTS list of groups and vehicles crated [_groups array, vehicle array]
XPos = compile preprocessFileLineNumbers "HC\Encounters\Functions\XPos.sqf";
HC_CreateVehicle = compile preprocessfileLineNumbers "HC\Functions\HC_CreateVehicle.sqf";
SpawnGroup = compile preprocessfileLineNumbers "HC\Encounters\LogicBomb\SpawnGroup.sqf";
SpawnSoldier = compile preprocessFileLineNumbers "HC\Encounters\AI_Logic\SpawnSoldier.sqf"; 
FillLoot = compile preprocessFileLineNumbers "HC\Encounters\LogicBomb\FillLoot.sqf";
private ["_vehicleData","_eCenter","_vehicles","_encounterSize","_groups","_returnval","_themeIndex","_missionName","_totalvehicles"];
_vehicleData = _this select 0;
_eCenter = _this select 1;
_encounterSize = _this select 2;
_groups = _this select 3;
_totalvehicles = _this select 4;
_themeIndex = _this select 5;
_missionName = _this select 6;

FindNearestRoad =
{
    private ["_stepdistance","_nearRoads","_pos","_return"];
    _pos = _this select 0;
    _stepdistance = 10;
    _nearRoads = [];  
    while {count _nearRoads == 0} do // while no road segemetns found, continue searching out further!
    {
        _nearRoads = _pos nearRoads _stepdistance;
        _stepdistance = _stepdistance + _stepdistance;
    };
    _return = _nearRoads select 0;
    _pos = getPos _return;
    _pos
};

GetSafeSpawnVehPos = 
{
    private ["_driver","_driverDat","_spawnpos","_pos"];
    _pos = _this select 0; // ASSERT this, and all locations handled in this function are absolute map coords, NO OFFSETS!
    _driver = _this select 1;
    _spawnpos = [];
    if (!isNil "_driver") then
    {
        _driverDat = _driver getVariable "AILOGIC";         
        //AILOGIC: "scriptName", ecenter, spawnloc, startloc, [options]
        if (!isNil "_driverDat") then
        {
            private ["_vehAILogic","_eCenter","_spawnLoc","_startLogicLoc","_options"];
            _vehAILogic = _driverDat select 0;
            _eCenter = _driverDat select 1;
            _spawnLoc = _driverDat select 2;
            _startLogicLoc = _driverDat select 3;
            _options = _driverDat select 4;
            _vehAILogic = toUpper _vehAILogic;          
            //diag_log format ["##SpawnVehicle: GetSafeSpawnVehPos: driver=%3 data:%1  options:%2",_vehAILogic, _options,_driver];
            if (_vehAILogic == "CONVOY") then 
            {
                if (_options select 2) then // and convoy set to be on roads!
                {
                    //if 'roadsonly' then ENSURE vehicle spawns on a road! (options 2 true)
                    _spawnpos = [_pos] call FindNearestRoad;
                    //      diag_log format ["##SpawnVehicle: ^^RETURNED from ^^=%1",_spawnpos];
                    _pos = _spawnpos;
                };
            };   
        }else
        { 
            diag_log format ["##SpawnVehicle:GetSafeSpawnVehPos: ERROR attempt to initialize with a driver with no 'AILOGIC' defined!"];
        };
    }else
    {
        private ["_safepos"];
        // Normal spawn pos locating for most vehicles, with NO driver
        _safepos = [_pos] call FindNearestRoad;
        if (count _pos == 2) then // using an offset was used, so find a safe position.
        {
            _pos = [_pos, 0, 100, 5,0, 2,0,[],[_safepos]] call BIS_fnc_findSafePos; // 5m clear, terraingradient 2 (pretty flat)
        }; //else do nothing, it is 3D and assuming person making the mission knows what he is doing!
    };
    _pos
};

KK_fnc_commonTurrets = {
	private ["_arr","_trts"];
	_arr = [];
	//_trts = configFile / "CfgVehicles" / typeOf _this / "Turrets";
    _trts = configFile / "CfgVehicles" / typeOf (_this select 0)/ "Turrets";
	for "_i" from 0 to count _trts - 1 do {
		_arr set [count _arr, [_i]];
		for "_j" from 0 to count (
			_trts / configName (_trts select _i) / "Turrets"
		) - 1 do {
			_arr set [count _arr, [_i, _j]];
		};
	};
	_arr
};

private ["_convoy","_vehdat","_driverdat","_troopdat","_driverGroup","_drivers","_drivercount","_crewcount","_troops","_troopGroups","_masterIndex",
"_numberTroops","_turretsLeftinVehicle","_totalvehicles","_silentcheckin"];

if (!isNil "_vehicleData") then
{
    {
        if (count _x == 3) then // valid number of elements in the data field.
        {
            _convoy = _x;
            _vehdat = _convoy select 0; // vehicle definitions block
            _driverdat = _convoy select 1;  // driver def block
            _troopdat = _convoy select 2; // troop def block
            _vehicles = [];   
            //only 1st group of the convoy should radio in!
            if (count _totalvehicles == 0 ) then {_silentcheckin = false;}else{_silentcheckin = true;};    
            _driverGroup = [_driverdat, _eCenter, _encounterSize, _themeIndex, _silentcheckin, _missionName] call SpawnGroup;    
            // Spawn group returns an array of groups. Need to add each individual element to preserve format of _groups as a list of groups and not a mix of groups and array of groups!
            // also generate list of drivers to be moved into each vehicle.
            _drivers=[];
            {
                _drivers = _drivers + units _x;
                _groups = _groups + [_x];
            }foreach _driverGroup;
            // get offset from drivers to use for the crew and vehicles
            // ASSERT count _drivers <= num vehicles in the convoy.
            // create, man up and load each vehicle
            if (count _drivers < 1) then
            { 
                diag_log format ["##SpawnVehicle :ERROR no drivers found! Not creating crew! ThemIndex:%1",_themeIndex];
            }else
            {
                _drivercount = 0;
                _turretsLeftinVehicle = [];
                {
                    // _x is a single line from vehicle block
                    // 0:type 1:spawn offset 2:crew 3:loot
                    private ["_veh","_pos","_i","_crew","_spawndata","_type","_numAI","_loot","_turretsArray","_nearRoads","_safepos","_var"];
                    
                    _pos = [_eCenter, _x select 1] call XPos;             
                    // only add drivers based upon the number of drivers we produced. Leave other vehicles w/o a driver!
                    if (_drivercount < count _drivers) then
                    {
                        private ["_driverLogic","_mode","_base","_air","_flyHeight","_options"];
                        //grab details from driver in case it impacts vehicle spawn paramaters (ie water only, airborne, roads only!
                        _var = (_drivers select _drivercount) getVariable "AILOGIC";
                        _driverLogic = toupper (_var select 0);
                        _mode = "CAN_COLLIDE";
                        //_air = inheritsFrom (configFile >> "CfgVehicles" >> "Air");
                        // _base = inheritsFrom (configFile >>"CfgVehicles">>(_x select 0));
                        //diag_log format ["##SpawnVehicle ::  _air:%1   _base:%2",_air, _base];
                        if (_driverLogic == "PARADROP") then
                        {
                            _options = _var select 3;
                            _mode = "FLY";
                            _flyHeight = _options select 1;
                        };
                        if (_driverLogic == "PATROLROUTE") then
                        {
                            _options = _var select 4;
                            if (count _options == 7) then
                            { 
                                _mode = "FLY";
                                _flyHeight = _options select 6;                    
                            }; // fly height defined, so vehicle is of type air.
                        };
                        if (_mode != "FLY") then
                        {
                            //        diag_log format ["##SpawnVehicle: Calling GetSafeSpawnVehPos with %1 and %2",_pos, _drivers select _drivercount];
                            _pos = [_pos, (_drivers select _drivercount)] call GetSafeSpawnVehPos;
                        };
                        //         diag_log format ["##SpawnVehicle: Creating %1 at %2", _x select 0, _pos];
                        _veh = [ (_x select 0), _pos, [], 0 , _mode] call HC_CreateVehicle;
                        if (_mode == "FLY") then
                        {
                            // put it atleast 500' in the air, set its flyin height to driver's logic..rest controlled by ai logic selected.
                            _veh setPosATL [getPosATL _veh select 0, getPosATL _veh select 1, ((getPosATL _veh select 2) + 500+_flyHeight)];
                            _veh flyinheight _flyHeight;   
                        };
                        (_drivers select _drivercount) moveinDriver _veh;
                        // need to update driver's spawn loc with the spawn loc of this vehicle!
                        _var = (_drivers select _drivercount) getVariable "AILOGIC";
                        _var set [2,_pos];
                        (_drivers select _drivercount) setVariable ["AILOGIC",_var,false];
                        
                        [(_drivers select _drivercount)] execVM "HC\Encounters\AI_Logic\VehStuck.sqf";;
                        _drivercount = _drivercount +1;                
                    } else
                    {   
                        //no driver, so just put it someplace that is not stupid.
                        _pos = [_pos] call GetSafeSpawnVehPos;
                        _veh = [ (_x select 0), _pos, [], 0 , "CAN_COLLIDE"] call HC_CreateVehicle;
                    };
                    _vehicles = _vehicles + [_veh];
                    // Add Crew
                    _turretsArray =[_veh] call KK_fnc_commonTurrets;
                    //diag_log format ["##SPAWN Vehicles : %1 has %2 turrets", _x select 0, count _turretsArray];
                    _spawndata = _x select 2;  
                    // if crew data is defined, create and add them!
                    if (!isNil "_spawndata") then
                    {
                        _type = _spawndata select 1;
                        _crewcount = _spawndata select 0;
                         //diag_log format ["##SPAWN Vehicles: _numAI:%1   _type:%2 _driverGroup%3",_crewcount, _type, _driverGroup];
                        for [{_i =0}, {_i < _crewcount}, {_i = _i+1}] do
                        {
                            if ( count _turretsArray > 0 ) then  // a turret is avail!
                            {
                                private ["_leader"];
                                _spawndata = _x select 2;
                                _type = _spawndata select 1;
                                _crew = [_driverGroup select 0,_type, getPos _veh, _themeIndex] call SpawnSoldier;
                                //sloppy coding. Need to initialize advanced FuMS functionality here!
                                _leader = leader (_driverGroup select 0); // ASSERT this guy is fully initialized!                                
                                _crew setVariable ["AILOGIC", _leader getVariable "AILOGIC", false];
                                _crew setVariable [ "XFILL", _leader getVariable "XFILL", false];        
                                [_crew] execVM "HC\Encounters\AI_Logic\AIEvac.sqf";
                                //radio chatter only required for group leaders, so only requires init inside SpawnGroup                                                                
                                //so copy the driver's variables, and exec necessary scripting!
                                //_crew assignAsGunner _veh;
                                //_crew moveInTurret [_veh, (_turretsArray select 0)];
                                _crew moveInAny _veh;
                                _turretsArray = _turretsArray - (_turretsArray select 0);
                            }else
                            {
                                //no turrents left, so move the AI into cargo:
                                // Current functinality is to leave cargo, for 'cargo' ai, just delete extra 'crewmembers' for now.
                                // so for now do nothing!
                            };
                            
                        };
                        _turretsLeftinVehicle = _turretsLeftinVehicle + [_turretsArray];
                    };
                    // Add Loot
                    _loot = _x select 3;
                    if (!isNil "_loot") then
                    {
                        [_loot, _veh, _themeIndex] call FillLoot;
                    };
                    
                }foreach _vehdat;
            };
            // Add Troops
            //   diag_log format ["##Spawn Vehicle : _troopdat:%1",_troopdat];  
            //Obtain the list of troops to be added to the list of vehicles
            _troops = [];
            _troopGroups =  [_troopdat, _eCenter, _encounterSize, _themeIndex, true, _missionName] call SpawnGroup;  // all troops are silent checkin
            {
                _groups = _groups + [_x];
                {
                    _troops = _troops + [_x];
                }foreach units _x;       
            }foreach _troopGroups;    
            private ["_done","_activeVehicle"];
            _done = false;
            _activeVehicle = 0;
            _masterIndex = 0;
            _numberTroops = count _troops;
            //    diag_log format ["Spawn Vehicle: _numberTroops:%1  for _troops:%2",_numberTroops, _troops]; 
            //    diag_log format ["Spawn Vehicle: adding troops to %1 vehicles",count _vehicles];
            {
                private ["_i","_numCargo","_numCommander","_numDriver","_numGunner","_turretsArray"];
                _numCargo = _x emptyPositions "Cargo";
                _numCommander = _x emptyPositions "Commander";
                _numDriver = _x emptyPositions "Driver";
                _numGunner = _x emptyPositions "Gunner";
                //   diag_log format ["Spawn Vehicle: Cargo:%1 CMD:%2 Driver:%3 Gunner:%4:%5",_numCargo, _numCommander, _numDriver, _numGunner, _x];     
                
                // Fill vehicle's cargo
                for [{_i = 0}, {_i < _numCargo},{ _i=_i+1}] do
                {
                    if (_masterIndex == _numberTroops) then {_done=true;_i=_numCargo;};
                    if (!_done) then
                    {
                        //diag_log format ["Spawn Vehicle: Adding %1 to %2",_troops select _masterIndex, _x];
                        //(_troops select _masterIndex) assignAsCargo _x;
                        (_troops select _masterIndex) moveInCargo _x;                    
                        _masterIndex = _masterIndex + 1;
                    };
                };
                _activeVehicle = _activeVehicle +1;
                _totalvehicles = _totalvehicles + [_x];
            } foreach _vehicles;   
        }else
        {
            if (count _x != 0 ) then
            {
                diag_log format ["SpawnVehicle: Error in Vehicle format for Msn:%1 Index:%2 of value:%3",_missionName, _themeIndex, _x];
            };
        };
        //    _totalvehicles = _totalvehicles + [_vehicles]; // This was creating arrays of arrays of vehicles!   
    }foreach _vehicleData;
};
_returnval = [_groups, _totalvehicles];
_returnval
