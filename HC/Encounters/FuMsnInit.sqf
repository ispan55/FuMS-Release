//FuMsnInit.sqf
// Horbin
// 1/8/15
// Main Initialization for Fulcrum Mission System

//Player and Headless client common initialization
if (hasInterface) then
{
    diag_log format ["##FuMsnInit: Starting Player specific configuration."];
    
    // Global HC Init. Code called by all clients in support of HC
    // to enable HC to broadcast messages to other clients
    "FuMS_GlobalHint" addPublicVariableEventHandler
    {
        private ["_GHint"];
        _GHint = _this select 1;
        hint parseText format["%1", _GHint];
    };
    
    "FuMS_TEMPVEHICLE" addPublicVariableEventHandler
    {
        //    diag_log format ["#####%1 entered a tempary vehicle!",player];
        systemChat "FuMS:Warning! This vehicle will disappear on server restart!";
    };
    
    "FuMS_AIONLYVEHICLE" addPublicVariableEventHandler
    {
        systemChat "FuMS: Some odd technical incompatibility prevents you from interfacing with this vehicle!";
    };
    FuMS_RadioMsgQue = [];
    
    "FuMS_RADIOCHATTER" addPublicVariableEventHandler
    {
        _rscLayer = "radioChatterBar" call BIS_fnc_rscLayer;
        //_rscLayer = RSCLayerRadioChat;
        _msg = format ["%1",_this select 1];
        //systemChat _msg;
        //diag_log format ["##FuMsnInit :  Radio sound should have played!"];
        if (FuMS_RC_EnableRadioAudio) then { playSound ["radio1",true];}; // the class name, not the name of the file!
        FuMS_RadioMsgQue = FuMS_RadioMsgQue + [_msg];
        if (count FuMS_RadioMsgQue == 11) then
        {
            // remove the 1st message.
            FuMS_RadioMsgQue = FuMS_RadioMsgQue - [FuMS_RadioMsgQue select 0];
        };     
        //diag_log format ["##FuMsnInit: _msg: %1",_msg];
        //diag_log format ["##FuMsnInit: RadioChatter: RadioMsgQue:%1",RadioMsgQue];       
        //open the dialog when a new message is received (cominging from the clients PVEH
        _rscLayer cutRsc["radioChatterBar","PLAIN",1,false];
        // Name, Type, speed, showonmap
        // fill the display
        _data = "";
        for [{_i=0},{_i<count FuMS_RadioMsgQue},{_i=_i+1}] do
        {
            _line = format ["%1\n",FuMS_RadioMsgQue select _i];
            _data = format ["%1%2",_data,_line];
        };
        //diag_log format ["##FuMsnInit: RadioChatter:%2 lines: %1",_data, count RadioMsgQue];       
        ((uiNamespace getVariable "radioChatterBar")displayCtrl 1010) ctrlSetText _data;
        // fade out after 20 seconds
        _rscLayer cutFadeOut 20;					   
    };  
    
    //Admin Controls Menu!
   // if ((getPlayerUID player) in ["76561197997766935","76561198125257185"]) then 
    [] execVM "HC\Menus\init.sqf";
  
    
};
    

// Players and HC
if (!isServer) then
{
    //player addEventHandler ["HandleDamage", {0}];
   // player allowdamage false;
    
    
    
    
    
};

// If on the headless client
if !(hasInterface or isServer) then
{   
    ValidateServerData = compile preprocessFileLineNumbers "HC\Encounters\Functions\DataCheck\ValidateServerData.sqf";
    ValidateThemeData = compile preprocessFileLineNumbers "HC\Encounters\Functions\DataCheck\ValidateThemeData.sqf";
    ValidateSoldierData = compile preprocessFileLineNumbers "HC\Encounters\Functions\DataCheck\ValidateSoldierData.sqf";
    ValidateLootData = compile preprocessFileLineNumbers "HC\Encounters\Functions\DataCheck\ValidateLootData.sqf";
    
    private ["_serverOptions","_themeNumber","_radchat","_i","_abort","_msg","_dat"];  
    
    if (isNil "FuMS_ServerInitData") then {FuMS_ServerInitData = false;};    
    // wait until server is operational
    waitUntil {!isNil "FuMS_Server_Operational"}; // wait for it to be defined
    waitUntil {FuMS_Server_Operational}; // wait for it to be true!  <-- initialized in /FuMS/init.sqf
    // ASSERT Server has completed loading all FuMS basic and theme data!
    // obtain all global data from the server!
    HC_HAL_Player = player;
    publicVariableServer "HC_HAL_Player"; // Tell the server the HC is here, and permit server to get owner ID.
    waitUntil {FuMS_ServerInitData}; // Server has completed loading all configuration data, and has passed it via PVClient calls.
       
    //ASSERT BaseServer, BaseLoot, and BaseSoldier data now on HC
    //ASSERT ServerData, THEMEDATA, LOOTDATA,SOLDIERDATA fully initialized at this point!   
    _abort = false;
    _msg = "";    
    while {true} do
    {
        if([] call ValidateServerData) exitWith {_abort=true;};
        _serverOptions = FuMS_ServerData select 0;
        // Change these to match your specific map!!!
        //Altis specific
        FuMS_MapCenter = _serverOptions select 0;
        FuMS_MapRange = _serverOptions select 1;
        FuMS_AdminControlsEnabled = _serverOptions select 2;
        // areas to not spawn encounters, if location being randomly generated.
        FuMS_BlackList = FuMS_ServerData select 1;
        FuMS_Defaultpos = FuMS_ServerData select 2;
        FuMS_ActiveThemes = FuMS_ServerData select 3; // array of theme names. Used to locate the theme's mission folder.
        // Configure RadioChatter module  See /Basic/ThemeData.sqf for details for more options!
        _radchat = FuMS_ServerData select 4;
        FuMS_RC_EnableRadioChatterSystem = _radchat select 0;
        FuMS_RC_EnableRadioAudio = _radchat select 1;
        publicVariable "FuMS_RC_EnableRadioAudio";
        FuMS_RC_RadioRequired = _radchat select 2;
        FuMS_RC_RadioFollowTheme = _radchat select 3;
        FuMS_RC_EnableAIChatter = _radchat select 4;
        FuMS_RC_AIRadioRange = _radchat select 5;
        FuMS_RC_REINFORCEMENTS = []; // used in LogicBomb to detect when a group calls for help and BaseOps approves assistance!    
         // Soldier Defaults
        _dat = FuMS_ServerData select 5;
        FuMS_SoldierMagCount_Rifle = _dat select 0;
        FuMS_SoldierMagCount_Pistol = _dat select 1;
        FuMS_SoldierVCOM_Driving = _dat select 2;  
        FuMS_SoldierSkillsOverride = _dat select 3;
        // Loot Defaults
        _dat = FuMS_ServerData select 6;
        FuMS_LootBoxTime = _dat select 0;
        FuMS_LootSmoke = _dat select 1;
        FuMS_LootSaveVehicle = _dat select 2;
        FuMS_STORAGE	= _dat select 3;
        FuMS_AIONLYVehicles = _dat select 4;
        
        //FuMS_GlobalDataIndex = count FuMS_ThemeData; <-- set and broadcast by server!
        if([] call ValidateThemeData) exitWith {_abort=true;};                    
        if([] call ValidateLootData) exitWith {_abort=true;};                
        if([] call ValidateSoldierData) exitWith {_abort=true;};                
        if (true) exitWith{};
    };
    if (_abort) exitWith {diag_log format ["###FuMsnInit ############FuMS OFFLINE####################"];};
    
    //FuMS_GlobalDataIndex = (count FuMS_ActiveThemes);
    if (FuMS_AdminControlsEnabled) then
    {           
        FuMS_AdminThemeOn =[];
        FuMS_AdminThemeSpawnLoc=[];     
        for [{_i=0},{_i < count FuMS_ActiveThemes},{_i=_i+1}] do
        {               
            FuMS_AdminThemeOn set [_i, (((FuMS_THEMEDATA select _i )select 0 ) select 5)];
            FuMS_AdminThemeSpawnLoc set [_i, []];          
        };                   
        publicVariable "FuMS_AdminControlsEnabled";
        publicVariable "FuMS_ActiveThemes";                                  
        publicVariable "FuMS_AdminThemeOn";
        publicVariable "FuMS_AdminThemeSpawnLoc";   
        
        diag_log format ["##FuMsnInit: Admin On: %1",FuMS_AdminControlsEnabled];        
        diag_log format ["##FuMsnInit: Theme is on: %1",FuMS_AdminThemeOn];
        diag_log format ["##FuMsnInit: Theme spawn locs: %1",FuMS_AdminThemeSpawnLoc];
    };
    
    diag_log format ["##FuMsnInit: ServerData:%1",FuMS_ServerData];
    diag_log format ["##FuMsnInit: Indx:%2:GlobalLootData %1", FuMS_LOOTDATA select FuMS_GlobalDataIndex, FuMS_GlobalDataIndex];
    diag_log format ["##FuMsnInit: Indx:%2:GlobalSoldierData %1", FuMS_SOLDIERDATA select FuMS_GlobalDataIndex,FuMS_GlobalDataIndex];
    diag_log format ["##FuMsnInit: #%2:ActiveThemes: %1",FuMS_ActiveThemes, count FuMS_ActiveThemes];          
    diag_log format ["##FuMsnInit: #%2:THEMEDATA:%1",FuMS_THEMEDATA, count FuMS_THEMEDATA]; 
    diag_log format ["##FuMsnInit: #%2:LOOTDATA:%1", FuMS_LOOTDATA, count FuMS_LOOTDATA];
    diag_log format ["##FuMsnInit: #%2:SOLDIERDATA:%1", FuMS_SOLDIERDATA, count FuMS_SOLDIERDATA];
            
    // Identify major civilized areas on the map.
    FuMS_VillageList = nearestLocations [FuMS_MapCenter, ["NameVillage"], 30000];
    FuMS_CityList =nearestLocations [FuMS_MapCenter, ["NameCity"], 30000];
    FuMS_CapitalList = nearestLocations [FuMS_MapCenter, ["NameCityCapital"], 30000];
    FuMS_MarineList = nearestLocations [FuMS_MapCenter, ["NameMarine"], 30000];
    
    
 /*   _testlocations = nearestLocations [FuMS_MapCenter, ["NameMarine"], 30000];
    {
         //plot the waypoint on the map.
        
        _mrkrname = format ["%1", _x];
        _tstmrk = createMarker [_mrkrname, [0,0]];
        _mrkrname setMarkerPos locationPosition _x;
        _mrkrname setMarkerAlpha 1;
        _mrkrname setMarkerType "mil_dot";
        _mrkrname setMarkerText _mrkrname;
        publicVariable _mrkrname;  
        
        
    }foreach _testlocations;
*/    
    
    {
        private ["_name"];
        _name = (text _x);
        //diag_log format ["## FuMsnInit: Urban area Located: %1",_name];
    }foreach (FuMS_VillageList+FuMS_CityList+FuMS_CapitalList);    
    // Based upon the list of themes in 'ActiveThemes' the below arrays will be populated.
    // and a control loop started for each theme.     
    FuMS_PhaseMsnID = 0;  // gets incremented every time a phased mission is launched.
    // Each mission launched from another mission increments PhaseMsnID and the phase mission is assigned the value as its ID.
    // This ID is then used to reference the below array from parent missions.
    FuMS_PhaseMsn = []; //Array
    FuMS_BodyCount = []; //Array containing number of AI killed under the current running mission. 
    //Phased missions contribute to the parent mission's total and are not calculated separately.    
    //Initialize ALL data before starting Theme Control Loops to permit global data to be fully initialized.    
    FuMS_OkToGetData = true; //semephore to lock down data requests to server from multiple control loops.
    
    
    
    
    // Start AI RadioChatter Operations Center. Done before control loops to permit error checking on RadioChatter data.
    [] execVM "HC\Encounters\AI_Logic\RadioChatter\BaseOps.sqf";  
    // Start any other addons here!
    if (FuMS_SoldierVCOM_Driving) then {[] execVM "HC\VCOM_Driving\init.sqf";diag_log format ["Genesis92x VCOM_Driving V1.01 Initialized."];};        
    // end custom addons
    sleep 3;        
    _themeNumber = 0;
    {
        private ["_themeData","_fault"];
        _fault = false;
        _themeData = FuMS_THEMEDATA select _themeNumber;
        if (!isNil "_themeData") then
        {
            
            [_x, _themeNumber ] execVM "HC\Encounters\ControlLoop.sqf";
        //    diag_log format ["*********************************************************************"];
         //   diag_log format ["*********************************************************************"];
            diag_log format ["##FUMSN Init: Fulcrum Mission System control loops starting for %1.", _x];    
         //   diag_log format ["*********************************************************************"];
         //   diag_log format ["*********************************************************************"];
            sleep 5; //pause for 5 secs to permit this control loop to init, and launch its 1st mission.                        
            _themeNumber = _themeNumber + 1;
        };
    }foreach FuMS_ActiveThemes;                 
};



