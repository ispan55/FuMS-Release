//ControlLoop_Basic.sqf
// Horbin
// 12/31/14
// Inputs: From FuMsnInit: This loop sets up overall THEME information, then maintains constant stream of missions for that theme.
// Event/Mission Control loop:
// This code provides core mission functionality for a group of missions
PullData = compile preprocessFileLineNumbers "HC\Encounters\Functions\PullData.sqf";
//StaticMissionControlLoop = compile preprocessFileLineNumbers "HC\Encounters\LogicBomb\StaticMissionControlLoop.sqf";
StaticMissionControlLoop = compile StaticMissionControlLoopCode;

private ["_missionTheme","_respawnDelay","_encounterLocations","_msnDone","_missionList",
"_pos","_activeMission","_missionSelection","_trackList","_missionTheme","_themeIndex","_themeOptions","_themeData",
"_locationAdditions","_missionNameOverride"];
_missionTheme = _this select 0;
_themeIndex = _this select 1;
_themeData = FuMS_THEMEDATA select _themeIndex;
_themeOptions = _themeData select 0;
_missionList = _themeData select 1;
_encounterLocations = _themeData select 2;
_missionSelection = _themeOptions select 1;
_respawnDelay = _themeOptions select 2;
//diag_log format ["##ControlLoop: %1 Missions Initializing##", _missionTheme];
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
            } foreach FuMS_VillageList;
            _encounterLocations = _encounterLocations - [_x];
        };
        if (_curLoc == "Cities") then
        {
            {
                _name = (text _x);
                _loc = locationPosition _x;         
                _locationAdditions = _locationAdditions + [[_loc, _name]];
            } foreach FuMS_CityList;
            _encounterLocations = _encounterLocations - [_x];
        };
        if (_curLoc == "Capitals") then
        {
            {
                _name = (text _x);
                _loc = locationPosition _x;         
                _locationAdditions = _locationAdditions + [[_loc, _name]];
            } foreach FuMS_CapitalList;
            _encounterLocations = _encounterLocations - [_x];
        };
        if (_curLoc == "Marine") then
        {
          {
                _name = (text _x);
                _loc = locationPosition _x;         
                _locationAdditions = _locationAdditions + [[_loc, _name]];
            } foreach FuMS_MarineList;
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
        }foreach (FuMS_VillageList+FuMS_CityList+FuMS_CapitalList);     
    };
}foreach _encounterLocations;
//_encounterLocations FORMAT: [[loc], Name]], or [array]
//diag_log format ["## Control Loop : Loc Additions: %1", _locationAdditions];
//diag_log format ["##Control Loop: Encounter Locations: %1",_encounterLocations];
_encounterLocations = _encounterLocations + _locationAdditions;
//diag_log format ["## Control Loop:Them Index:%3 Full Location List: %2:%1", _encounterLocations, count _encounterLocations, _themeIndex];
_trackList = _missionList;

//Initialize Radio Chatter and other THEME related global variables!
private ["_data","_options"];
_data = (FuMS_THEMEDATA select _themeIndex)select 3;
//Theme Data elements : 0= config options, 1=AI messages, 2=base messages
//  diag_log format ["##BaseOps: Themedata select 3: _data:%1",_data];
_options = _data select 0;
FuMS_radioChannel set [ _themeIndex, _options select 0];
FuMS_silentCheckIn set [ _themeIndex, _options select 1];
FuMS_aiDeathMsg set [ _themeIndex,_options select 2];
FuMS_radioRange set [ _themeIndex,_options select 3];
FuMS_aiCallsign  set [ _themeIndex,_options select 4];
FuMS_baseCallsign set [ _themeIndex, _options select 5];
FuMS_aiMsgs  set [ _themeIndex,_data select 1];
FuMS_baseMsgs set [ _themeIndex, _data select 2]; // list of all bases messagess (array of arrays)
FuMS_AI_XMT_MsgQue set [ _themeIndex, ["From","MsgType"] ]; // just using radiochannel array to get the 'count'
FuMS_AI_RCV_MsgQue set [ _themeIndex, ["To", "MsgType"]  ];
FuMS_GroupCount set [ _themeIndex, 0 ]; // set this themes group count to zero.
FuMS_radioChatInitialized set [_themeIndex, true];

FuMS_BodyCount set [_themeIndex, 0];





while {true} do
{
    private ["_msnDoneList"];
    _msnDoneList = [];   
    if (FuMS_AdminControlsEnabled) then
    {
        waitUntil {sleep 2; (FuMS_AdminThemeOn select _themeIndex)};
    };
    
    // SELECT A MISSION.
 //  diag_log format ["##ControlLoop: OrderOption:%2 _missionList:%1",_missionList, _missionSelection];
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
            //this flow controlled by below, spawn ALL missions on the Theme's list!                     
        };
    };    
    
    if (_missionSelection == 4) then
    {
        _activeMission = _trackList;
        [_activeMission,_themeIndex,_missionTheme] call StaticMissionControlLoop;
        if (FuMS_AdminControlsEnabled) then
        {
            FuMS_AdminThemeOn set[ _themeIndex,false];
            publicVariable "FuMS_AdminThemeOn";
            // staticcontrol loop will launch each mission on its own loop. So this theme loop can be shutdown.
        };
    }
    else
    {
   //     diag_log format ["##ControlLoop: _activeMission:%1",_activeMission];   
        {   
            // Get location for the mission
            private ["_missionFileName","_dataFromServer"];
            _missionNameOverride = "";
  //          diag_log format ["##ControlLoop: _encounterLocations:%1",_encounterLocations];
            if (count _encounterLocations ==0 ) then // Theme location list is empty so generate a global location!
            {
                private ["_minRange","_waterMode","_terrainGradient","_shoreMode"];
                //generate random safe location
                _minRange = 0;
                _waterMode = 0;// 0=not in water, 1=either, 2=in water
                _terrainGradient = 2;  //10 is mountainous, 4 is pretty damn hilly too.
                _shoreMode = 0; // 0= either, 1=on shore	
                _pos = [FuMS_MapCenter, _minRange, FuMS_MapRange, _minRange, _waterMode, _terrainGradient, 
                _shoreMode, FuMS_BlackList, FuMS_Defaultpos] call BIS_fnc_findSafePos;
    //            diag_log format ["##ControlLoop: BiS_fnc_findSafePos = %1",_pos];
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
                    }foreach (FuMS_VillageList+FuMS_CityList+FuMS_CapitalList);  
                };
            } 
            else  // No specific locations specified with the mission. Ex: ["TestMision01"] so use what has already been generated, unless under Admin Control!
            { 
                _missionFileName = _x select 0;
                if (FuMS_AdminControlsEnabled) then
                {
                    
                    private ["_newpos"];
                    
                    //Admin control enabled, so look to the global variable for a custom location to spawn.
                    _newpos = FuMS_AdminThemeSpawnLoc select _themeIndex;
                    if (count _newpos > 0) then
                    {
                        diag_log format ["##ControlLoop: %1/%2 under Admin Control custom spawn of %3",_missionTheme,_missionFileName, _newpos];    
                        if(TypeName _newpos =="ARRAY") then{_pos = _newpos;}; // ONLY Handle ARRAY LOCS right now!
                        FuMS_AdminThemeSpawnLoc set [_themeIndex, []];
                        publicVariable "FuMS_AdminThemeSpawnLoc";
                        //once it is created null it out to permit normal loop operation for locations.
                    };
                    
                };
            };    
            // ****GET MISSION DATA FROM SERVER ****
            waitUntil {FuMS_OkToGetData};
            FuMS_OkToGetData = false;
            //publicVariable "FuMS_OkToGetData";
            _dataFromServer = [_missionTheme, _missionFileName] call PullData;
            FuMS_OkToGetData = true;
            if (count _dataFromServer > 0) then
            {
                //diag_log format ["##ControlLoop: Misssion Data from Server :%1",_dataFromServer];
                _msnDone = [_dataFromServer, [_pos, _missionTheme, _themeIndex, 0, _missionNameOverride]] execVM "HC\Encounters\LogicBomb\MissionInit.sqf";                                     
                //_activeMissionFile = format ["HC\Encounters\%1\%2.sqf",_missionTheme,_missionFileName];
                diag_log format ["##ControlLoop:  Theme: %1 : HC now starting mission %2 at %3",_missionTheme, _missionFileName, _pos];
                // setting _phaseID = 0 implies this mission is a 'root parent' (it has no parents itself!)
                // _msnDone =[[_pos, _missionTheme, _themeIndex, 0, _missionNameOverride]] execVM _activeMissionFile;
                _msnDoneList = _msnDoneList + [_msnDone];
            }else
            {
                diag_log format ["##ControlLoop: Theme: %1 : HC skipped mission %2",_missionTheme, _missionFileName];
            };
        }foreach _activeMission; 
        // wait for ALL missions started to complete, before restarting all missions that where started, or selecting a new one.
        {
            waitUntil { scriptDone _x};  
        }foreach _msnDoneList; 
        sleep _respawnDelay;
    };
    
    
    
};
    
    
    
    