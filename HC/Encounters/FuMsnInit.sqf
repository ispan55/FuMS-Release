//FuMsnInit.sqf
// Horbin
// 1/8/15
// Main Initialization for Fulcrum Mission System

//Player and Headless client common initialization
if (!isServer) then
{
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
};
// Players only
if (hasInterface) then
{
    //player addEventHandler ["HandleDamage", {0}];
   // player allowdamage false;
};

// If on the headless client
if !(hasInterface or isServer) then
{    
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
    if (isNil "FuMS_ServerData") then {_abort=true; _msg = format ["No ServerData passed to Headless Client"];};
    if (!_abort and isNil "FuMS_THEMEDATA") then {_abort = true; _msg = format ["No ThemeData passed to Headless Client"];};
    if (!_abort and isNil "FuMS_LOOTDATA") then {_abort = true;_msg = format ["No LootData passed to Headless Client"];};
    if (!_abort and isNil "FuMS_SOLDIERDATA") then {_abort = true;_msg = format ["No SoldierData passed to HeadlessClient"];};  
    // all data at least defined. Now check its format!
    if (!_abort) then
    {
        if (count FuMS_ServerData != 5) then{_abort = true;_msg = format ["Format error in ServerData.sqf"];};
        // specifically check GlobalLoot and GlobalSoldier Data
        if (!_abort) then // Check GlobalLootData
        {
            if (count FuMS_LOOTDATA == 0) then {_abort = true;_msg = format ["No LootData defined by Server"];}
            else
            {
                _dat = FuMS_LOOTDATA select FuMS_GlobalDataIndex;
                if (isNil "_dat") then 
                { 
                    _abort = true; _msg = format ["GlobalLootData not loaded by Server."];
                }
                else
                {
                    {
                        if (count _x !=  5 ) exitWith {_abort = true;_msg = format ["Error in GlobalLootData"];};  
                    }foreach _dat;
                };
            };
        };
         if (!_abort) then //Check GlobalSoldierData
        {
            if (count FuMS_SOLDIERDATA == 0) then {_abort = true;_msg = format ["No SoldierData defined by Server"];}
            else
            {
                _dat = FuMS_SOLDIERDATA select FuMS_GlobalDataIndex;
                if (isNil "_dat") then {_abort = true; _msg = format ["GlobalSoldierData not loaded by Server."];}
                else
                {
                    {
                        if (count _x !=  13 ) exitWith {_abort = true;_msg = format ["Error in GlobalSoldierData"];};  
                    }foreach _dat;
                };
            };
        }; 
        if (!_abort) then //Check ThemeData
        {
            if (count FuMS_THEMEDATA == 0) then {_abort = true;_msg = format ["No ThemeData defined by Server"];}
            else
            {
                {
                    if (isNil "_x") exitWith {_msg = format ["Syntax/Format error in ThemeData.sqf"];};//Abort later, no need to if Theme=<NULL>
                    if (count _x !=  4 ) exitWith {_msg = format ["ThemeData Error:%1",_x];};  // 4 major fields defined in each ThemeData.sqf
                }foreach FuMS_THEMEDATA;
            };
        };
        if (!_abort) then // Check LootData
        {
            {
                if (!isNil "_x") then
                {
                    { 
                        if (count _x !=  5 ) exitWith 
                        {
                            _abort = true;
                            _msg = format ["LootData Error: Expected 5: Found %2:%1",_x, count _x];
                        };  // 4 major fields defined in each ThemeData.sqf
                    }foreach _x;
                };
            }foreach FuMS_LOOTDATA;            
        };
         if (!_abort) then // Check SoldierData
        {
            {
                if (!isNil "_x") then
                {
                    {
                        if (count _x !=  13) exitWith {_abort = true;_msg = format ["SoldierData Error: Expected 13: Found %2:%1",_x, count _x];};  // 4 major fields defined in each ThemeData.sqf
                    }foreach _x;
                };
            }foreach FuMS_SOLDIERDATA;            
        };   
    };
    if (_abort) then
    { 
        diag_log format ["-------------------------------------------------------------------------------------"];
        diag_log format ["----------------            Fulcrum Mission System                    -----------------"];
        diag_log format ["-------------------------------------------------------------------------------------"];
        diag_log format ["##FuMsnInit: ERROR in Fulcrum Mission Data from Server! Aborting FuMS"];
        diag_log format ["    Recommend verifying data files in \FuMS\Themes on your server!"];        
        diag_log format ["             -ABORT- -ABORT- -FORMAT ERROR- -ABORT- -ABORT-"];   
        diag_log format ["                            Fulcrum Mission System offline....."];
        diag_log format ["REASON: %1",_msg];
        diag_log format ["  Check your server's .rpt file for further details!"];
        diag_log format ["-------------------------------------------------------------------------------------"];
        diag_log format ["-------------------------------------------------------------------------------------"];    
    }else
    {
        diag_log format ["##FuMsnInit: ServerData:%1",FuMS_ServerData];
         diag_log format ["##FuMsnInit: GlobalLootData %1", FuMS_LOOTDATA select FuMS_GlobalDataIndex];
        diag_log format ["##FuMsnInit: GlobalSoldierData %1", FuMS_SOLDIERDATA select FuMS_GlobalDataIndex];
        diag_log format ["##FuMsnInit: THEMEDATA:%1",FuMS_THEMEDATA]; 
        diag_log format ["##FuMsnInit: LOOTDATA:%1", FuMS_LOOTDATA];
        diag_log format ["##FuMsnInit: SOLDIERDATA:%1", FuMS_SOLDIERDATA];
       
        diag_log format ["##FuMsnInit: %1 Themes loaded from the server",count FuMS_THEMEDATA];    
        
        for [{_i=0},{_i < count FuMS_THEMEDATA},{_i=_i+1}] do
        {      
            diag_log format ["####################################"];
            diag_log format ["#####Theme Index :%1  ##################",_i];
            diag_log format ["FuMS_THEME DATA"];
            {
                diag_log format ["^^^^%1",_x];
            }foreach (FuMS_THEMEDATA select _i); 
            diag_log format ["FuMS_LOOT DATA"];
            {
                diag_log format ["^^^^%1",_x];
            }foreach (FuMS_LOOTDATA select _i); 
            if (count (FuMS_LOOTDATA select _i) == 0) then {diag_log format ["^^^^ Using Global Loot Data"];};
            diag_log format ["FuMS_SOLDIER DATA"];
            {
                diag_log format ["^^^^%1",_x];
            }foreach (FuMS_SOLDIERDATA select _i);
            if (count (FuMS_SOLDIERDATA select _i) == 0) then {diag_log format ["^^^^ Using Global Soldier Data"];};
            diag_log format ["####################################"];
        };    
        _serverOptions = FuMS_ServerData select 0;
        // Change these to match your specific map!!!
        //Altis specific
        FuMS_MapCenter = _serverOptions select 0;
        FuMS_MapRange = _serverOptions select 1;
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
        // Identify major civilized areas on the map.
        FuMS_VillageList = nearestLocations [FuMS_MapCenter, ["NameVillage"], 30000];
        FuMS_CityList =nearestLocations [FuMS_MapCenter, ["NameCity"], 30000];
        FuMS_CapitalList = nearestLocations [FuMS_MapCenter, ["NameCityCapital"], 30000];
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
      
        // check RadioChatter here!
        
        [] execVM "HC\Encounters\AI_Logic\RadioChatter\BaseOps.sqf";  
        sleep 3;        
        _themeNumber = 0;
        {
            private ["_themeData","_fault"];
            _fault = false;
            _themeData = FuMS_THEMEDATA select _themeNumber;
            if (!isNil "_themeData") then
            {
                if ( count _themeData != 4) then{_fault = true;}
                else
                {
                    [_x, _themeNumber ] execVM "HC\Encounters\ControlLoop.sqf";
                    diag_log format ["*********************************************************************"];
                    diag_log format ["*********************************************************************"];
                    diag_log format ["##FUMSN Init: Fulcrum Mission System control loops starting for %1.", _x];    
                    diag_log format ["*********************************************************************"];
                    diag_log format ["*********************************************************************"];
                    sleep 5; //pause for 5 secs to permit this control loop to init, and launch its 1st mission.
                };
            }else{_fault = true;};
            if (_fault) then
            {
                diag_log format ["-------------------------------------------------------------------------------------"];
                diag_log format ["----------------            Fulcrum Mission System                    -----------------"];
                diag_log format ["-------------------------------------------------------------------------------------"];
                diag_log format ["##FuMsnInit: ERROR in Fulcrum Mission Data from Server! "];
                diag_log format ["    Recommend verifying data files in \FuMS\Themes on your server!"];        
                diag_log format ["                                      -FORMAT ERROR- "];   
                diag_log format ["                                A FuMS Theme is offline...."];
                diag_log format ["REASON: Improper format of ThemeData.sqf in %1", _x ];
                diag_log format ["  Check your server's .rpt file for further details!"];
                diag_log format ["-------------------------------------------------------------------------------------"];
                diag_log format ["-------------------------------------------------------------------------------------"];      
            };
            _themeNumber = _themeNumber + 1;
        }foreach FuMS_ActiveThemes;               
    };
};



