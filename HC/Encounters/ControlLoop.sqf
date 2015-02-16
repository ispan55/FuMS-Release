//ControlLoop_Basic.sqf
// Horbin
// 12/31/14
// Inputs: From FuMsnInit: This loop sets up overall THEME information, then maintains constant stream of missions for that theme.
// Event/Mission Control loop:
// This code provides core mission functionality for a group of missions
PullData = compile preprocessFileLineNumbers "HC\Encounters\Functions\PullData.sqf";
private ["_missionTheme","_respawnDelay","_encounterLocations","_msnDone","_missionList",
"_pos","_activeMission","_missionSelection","_trackList","_missionTheme","_themeIndex","_themeOptions","_themeData",
"_locationAdditions","_missionNameOverride"];
_missionTheme = _this select 0;
_themeIndex = _this select 1;
_themeData = THEMEDATA select _themeIndex;
_themeOptions = _themeData select 0;
_missionList = _themeData select 1;
_encounterLocations = _themeData select 2;
_missionSelection = _themeOptions select 1;
_respawnDelay = _themeOptions select 2;
diag_log format ["##ControlLoop: %1 Missions Initializing##", _missionTheme];
// Look for keyword locations. If found, add them to the provided list of _encounterLocations
_locationAdditions = [];
{
    //Locations: [STRING] or [[array], STRING] or [array]
 //   diag_log format ["##Control Loop : Examining Location : %1",_x];
    if (TypeName (_x select 0) == "STRING") then
    {
        private ["_name","_loc","_curLoc","_curLoc","_value"];
        _value = _x;
        _curLoc = _x select 0;
        if (_curLoc == "Villages") then
        {
            {
                _name = (text _x);
                _loc = locationPosition _x;         
                _locationAdditions = _locationAdditions + [[_loc, _name]];
            } foreach VillageList;
            _encounterLocations = _encounterLocations - [_x];
        };
        if (_curLoc == "Cities") then
        {
            {
                _name = (text _x);
                _loc = locationPosition _x;         
                _locationAdditions = _locationAdditions + [[_loc, _name]];
            } foreach CityList;
            _encounterLocations = _encounterLocations - [_x];
        };
        if (_curLoc == "Capitals") then
        {
            {
                _name = (text _x);
                _loc = locationPosition _x;         
                _locationAdditions = _locationAdditions + [[_loc, _name]];
            } foreach CapitalList;
            _encounterLocations = _encounterLocations - [_x];
        };
        // add individual city names if present!
        {
            _name = (text _x);
            if (_curLoc == _name) then
            {
                _loc = locationPosition _x;
                _locationAdditions = _locationAdditions + [[_loc, _name]];
                _encounterLocations = _encounterLocations - [_value];
            };
        }foreach (VillageList+CityList+CapitalList);     
    };
}foreach _encounterLocations;
//_encounterLocations FORMAT: [[loc], Name]], or [array]
//diag_log format ["## Control Loop : Loc Additions: %1", _locationAdditions];
//diag_log format ["##Control Loop: Encounter Locations: %1",_encounterLocations];
_encounterLocations = _encounterLocations + _locationAdditions;
//diag_log format ["## Control Loop:Them Index:%3 Full Location List: %2:%1", _encounterLocations, count _encounterLocations, _themeIndex];
_trackList = _missionList;
while {true} do
{
    private ["_msnDoneList"];
    _msnDoneList = [];
    // SELECT A MISSION.
   diag_log format ["##ControlLoop: OrderOption:%2 _missionList:%1",_missionList, _missionSelection];
	//  perform call of the mission chosen
    switch (_missionSelection) do
    {
        case 1: // select a random mission from the list
        {
            _activeMission = [_trackList call BIS_fnc_selectRandom];
        };
        case 2: // run missions in order, per the list.
        {
            _activeMission = [_trackList select 0];
            //diag_log format ["##ControlLoop Premath list:%1",_trackList];
            if(TypeName _activeMission == "STRING") then
            {
                _trackList = _trackList -[_activeMission];   
            } else
            {
                _trackList = _trackList -_activeMission;
            };
            //diag_log format ["##ControlLoop Postmath list:%1",_trackList];
            if (count _trackList == 0) then { _trackList = _missionList;};
        };
        case 3: // remove mission from list once it is started
        {
            _activeMission = [_trackList call BIS_fnc_selectRandom];
              if(TypeName _activeMission == "STRING") then
            {
                _trackList = _trackList -[_activeMission];   
            } else
            {
                _trackList = _trackList -_activeMission;
            };
            if (count _trackList == 0) then { _trackList = _missionList;};   
        };
        case 4: // spawn all the missions in the missionList
        {
            //this flow controlled by 
            _activeMission = _trackList;
        };
    };
    diag_log format ["##ControlLoop: _activeMission:%1",_activeMission];   
 {   
     // Get location for the mission
     private ["_missionFileName","_dataFromServer"];
     _missionNameOverride = "";
     if (count _encounterLocations ==0 ) then // Theme location list is empty so generate a global location!
     {
         private ["_minRange","_waterMode","_terrainGradient","_shoreMode"];
         //generate random safe location
         _minRange = 0;
         _waterMode = 0;// 0=not in water, 1=either, 2=in water
         _terrainGradient = 2;  //10 is mountainous, 4 is pretty damn hilly too.
         _shoreMode = 0; // 0= either, 1=on shore	
         _pos = [MapCenter, _minRange, MapRange, _minRange, _waterMode, _terrainGradient, 
         _shoreMode, BlackList, Defaultpos] call BIS_fnc_findSafePos;		
     }else
     {
         private ["_location"];
         _location = _encounterLocations select (floor random count _encounterLocations);
         // If the location has a specific name, use it. Otherwise use mission name!
         if (TypeName (_location select 1) == "STRING") then
         {
             // found a [pos,"LocationName"] combo (a village, town, city, or custom defined item in 'Locations' list)
             _pos = _location select 0;
             _missionNameOverride = _location select 1;
         }else
         {
             _pos = _location;
         };
     };
     //diag_log format ["##ControlLoop: MsnOverride:%1 at Loc:%2",_missionNameOverride, _pos];        
     // if a position is included with the mission file name, use this FIXED position for the encounter!
     //  and remove any 'location' related name
     if (count _x > 1) then
     {
         _missionFileName = _x select 0;
         if (TypeName (_x select 1) == "ARRAY") then
         {
             _pos = _x select 1;
             _missionNameOverride = "";
         };
         if (TypeName (_x select 1) == "STRING") then
         {
             // add individual city names if present!
             private ["_curMissionLocationName"];
             _curMissionLocationName = _x select 1;
             {
                 private ["_name"];
                 _name = (text _x);
                 //diag_log format ["##ControlLoop: _name:%2 _x:%1",_x, _name];
                 if ( ( _curMissionLocationName) == _name) then
                 {
                     _pos = locationPosition _x;
                     _missionNameOverride = _name;
                 };
             }foreach (VillageList+CityList+CapitalList);  
         };
     } else { _missionFileName = _x select 0;};    
      // ****GET MISSION DATA FROM SERVER ****
     waitUntil {OkToGetData};
     OkToGetData = false;
     _dataFromServer = [_missionTheme, _missionFileName] call PullData;
     OkToGetData = true;
     //diag_log format ["##ControlLoop: Misssion Data from Server :%1",_dataFromServer];
     _msnDone = [_dataFromServer, [_pos, _missionTheme, _themeIndex, 0, _missionNameOverride]] execVM "HC\Encounters\LogicBomb\MissionInit.sqf";     
     //_activeMissionFile = format ["HC\Encounters\%1\%2.sqf",_missionTheme,_missionFileName];
     diag_log format ["##ControlLoop:  Theme: %1 : HC now starting mission %2 at %3",_missionTheme, _missionFileName, _pos];
     // setting _phaseID = 0 implies this mission is a 'root parent' (it has no parents itself!)
    // _msnDone =[[_pos, _missionTheme, _themeIndex, 0, _missionNameOverride]] execVM _activeMissionFile;
     _msnDoneList = _msnDoneList + [_msnDone];
 }foreach _activeMission; 
 // wait for ALL missions started to complete, before restarting all missions that where started, or selecting a new one.
 {
     waitUntil { scriptDone _x};  
 }foreach _msnDoneList; 
 sleep _respawnDelay;
};
