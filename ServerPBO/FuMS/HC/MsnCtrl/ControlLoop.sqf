//ControlLoop_Basic.sqf
// Horbin
// 12/31/14
// Inputs: From FuMsnInit: This loop sets up overall THEME information, then maintains constant stream of missions for that theme.
// Event/Mission Control loop:
// This code provides core mission functionality for a group of missions
//PullData = compile preprocessFileLineNumbers "HC\Encounters\Functions\PullData.sqf";
//StaticMissionControlLoop = compile preprocessFileLineNumbers "HC\Encounters\LogicBomb\StaticMissionControlLoop.sqf";
//FuMS_C1_PullData = compile FuMS_S_PullData;
private ["_missionTheme","_respawnDelay","_encounterLocations","_msnDone","_missionList","_spawnedByAdmin",
"_pos","_activeMission","_missionSelection","_trackList","_missionTheme","_themeIndex","_themeOptions","_themeData",
"_locationAdditions","_missionNameOverride"];
_missionTheme = _this select 0;
_themeIndex = _this select 1;
_spawnedByAdmin = _this select 2;
if (isNil "_spawnedByAdmin") then {_spawnedbyAdmin=false;};
_themeData = FuMS_THEMEDATA select _themeIndex;
_themeOptions = _themeData select 0;
_missionList = _themeData select 1;
_encounterLocations = _themeData select 2;
_missionSelection = _themeOptions select 1;
_respawnDelay = _themeOptions select 2;
//diag_log format ["##ControlLoop: %1 Missions Initializing##", _missionTheme];
// Look for keyword locations. If found, add them to the provided list of _encounterLocations
_activeThemeIndex = FuMS_ActiveThemes find _missionTheme;
_controlledByThisHC = FuMS_ActiveThemesHC select _activeThemeIndex;
if (  !(_controlledByThisHC == -1 or _controlledByThisHC == FuMS_HCThemeControlID)  ) exitWith
{
    // this theme not under control of the HC...so exit...
    diag_log format ["##ControlLoop: %1 not started. It is under HC#%2 control. Check BaseServer.sqf to reconfigure!",_missionTheme, _controlledByThisHC];
    
};
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
        }foreach FuMS_DefinedMapLocations;     
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
        private ["_onOff"];
		if (!_spawnedByAdmin) then  // ignore togglestate if this was spawned by an Admin
		{
			waitUntil
			{
				_onOff = missionNameSpace getVariable format["FuMS_AdminThemeOn%1",FuMS_HCThemeControlID];
			//  diag_log format ["##ControlLoop:  _themeIndex:%1  _onOff : %2",_themeIndex, _onOff];
				sleep 2; 
				(_onOff select _themeIndex)
			};
		};
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
        [_activeMission,_themeIndex,_missionTheme] call FuMS_fnc_HC_MsnCtrl_StaticMissionControlLoop;
        if (FuMS_AdminControlsEnabled) then
        {
            private ["_onOff"];
            //FuMS_AdminThemeOn set[ _themeIndex,false];
            _onOff = missionNameSpace getVariable format["FuMS_AdminThemeOn%1",FuMS_HCThemeControlID];
            _onOff set [_themeIndex, false];
            missionNameSpace setVariable [format["FuMS_AdminThemeOn%1",FuMS_HCThemeControlID],_onOff];
            FuMS_AdminUpdateData = [FuMS_HCThemeControlID, "AdminThemeOn", _onOff];
            publicVariableServer "FuMS_AdminUpdateData";
            //  staticcontrol loop will launch each mission on its own loop. So this theme loop can be shutdown.                                    
        };
    }
    else
    {
        private ["_result"];
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
            _missionFileName = _x select 0;
            _result = [_pos, _x, _missionNameOverride] call FuMS_fnc_HC_MsnCtrl_Util_SetSpecialNameandLocation;
            _pos = _result select 0;
            _missionNameOverride = _result select 1;
            if (_spawnedByAdmin) then
			{			
				if (count FuMS_AdminSPAWNLOC > 1) then {_pos = FuMS_AdminSPAWNLOC;};
			};
            _dataFromServer = [_themeIndex,_missionFileName] call FuMS_fnc_HC_MsnCtrl_Util_PullData;
            //data no longer from server, but PullData functionallity changed!
            if (count _dataFromServer > 0) then
            {
                //diag_log format ["##ControlLoop: Misssion Data from Server :%1",_dataFromServer];
               // _msnDone = [_dataFromServer, [_pos, _missionTheme, _themeIndex, 0, _missionNameOverride]] execVM "HC\Encounters\LogicBomb\MissionInit.sqf";                                     
				_msnDone = [_dataFromServer, [_pos, _missionTheme, _themeIndex, 0, _missionNameOverride]] spawn FuMS_fnc_HC_MsnCtrl_MissionInit;
                //_activeMissionFile = format ["HC\Encounters\%1\%2.sqf",_missionTheme,_missionFileName];
                diag_log format ["##ControlLoop:  Theme: %1 : HC:%4 now starting mission %2 at %3",_missionTheme, _missionFileName, _pos, FuMS_HCThemeControlID];
                // setting _phaseID = 0 implies this mission is a 'root parent' (it has no parents itself!)
                // _msnDone =[[_pos, _missionTheme, _themeIndex, 0, _missionNameOverride]] execVM _activeMissionFile;
                _msnDoneList = _msnDoneList + [_msnDone];
            }else
            {
                diag_log format ["##ControlLoop: Theme: %1 : HC:%3 skipped mission %2 check your Server .rpt file.",_missionTheme, _missionFileName, FuMS_HCThemeControlID];
            };
        }foreach _activeMission; 
        // wait for ALL missions started to complete, before restarting all missions that where started, or selecting a new one.
        {
            waitUntil { scriptDone _x};  
        }foreach _msnDoneList; 
        sleep _respawnDelay;
    };    
};
    
    
    
    