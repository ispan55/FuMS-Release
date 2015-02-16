//FuMsnInit.sqf
// Horbin
// 1/8/15
// Main Initialization for Fulcrum Mission System

//Player and Headless client common initialization
if (!isServer) then
{
    // Global HC Init. Code called by all clients in support of HC
    // to enable HC to broadcast messages to other clients
    "GlobalHint" addPublicVariableEventHandler
    {
        private ["_GHint"];
        _GHint = _this select 1;
        hint parseText format["%1", _GHint];
    };
    
    "TEMPVEHICLE" addPublicVariableEventHandler
    {
        //    diag_log format ["#####%1 entered a tempary vehicle!",player];
        systemChat "Warning! This vehicle will disappear on server restart!";
    };
    
    RadioMsgQue = [];
    
    "RADIOCHATTER" addPublicVariableEventHandler
    {
        _rscLayer = "radioChatterBar" call BIS_fnc_rscLayer;
        //_rscLayer = RSCLayerRadioChat;
        _msg = format ["%1",_this select 1];
        //systemChat _msg;
        //diag_log format ["##FuMsnInit :  Radio sound should have played!"];
        if (RC_EnableRadioAudio) then { playSound ["radio1",true];}; // the class name, not the name of the file!
        RadioMsgQue = RadioMsgQue + [_msg];
        if (count RadioMsgQue == 11) then
        {
            // remove the 1st message.
            RadioMsgQue = RadioMsgQue - [RadioMsgQue select 0];
        };     
        //diag_log format ["##FuMsnInit: _msg: %1",_msg];
        //diag_log format ["##FuMsnInit: RadioChatter: RadioMsgQue:%1",RadioMsgQue];       
        //open the dialog when a new message is received (cominging from the clients PVEH
        _rscLayer cutRsc["radioChatterBar","PLAIN",1,false];
        // Name, Type, speed, showonmap
        // fill the display
        _data = "";
        for [{_i=0},{_i<count RadioMsgQue},{_i=_i+1}] do
        {
            _line = format ["%1\n",RadioMsgQue select _i];
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
   
};

// If on the headless client
if !(hasInterface or isServer) then
{    
    private ["_serverOptions","_themeNumber","_radchat","_i"];   
    if (isNil "ServerFuMsnInitData") then {ServerFuMsnInitData = false;};    
    // wait until server is operational
    waitUntil {!isNil "FuMS_Server_Operational"}; // wait for it to be defined
    waitUntil {FuMS_Server_Operational}; // wait for it to be true!  <-- initialized in /FuMS/init.sqf
    // ASSERT Server has completed loading all FuMS basic and theme data!
    // obtain all global data from the server!
    HC_HAL_Player = player;
    publicVariableServer "HC_HAL_Player";
    // THEMEDATA = []; // Array containing data from \'themename'\ThemeData.sqf
    // LOOTDATA = [];  // Array containing data from \'themename'\LootData.sqf
    // SOLDIERDATA = []; // Array containing data from \'themename'\SoldierData.sqf  
    waitUntil {ServerFuMsnInitData};
    //ASSERT BaseServer, BaseLoot, and BaseSoldier data now on HC
    //ASSERT ServerData, THEMEDATA, LOOTDATA,SOLDIERDATA fully initialized at this point!    
    diag_log format ["##FuMsnInit: ServerData:%1",ServerData];
    diag_log format ["##FuMsnInit: THEMEDATA:%1",THEMEDATA]; 
    diag_log format ["##FuMsnInit: LOOTDATA:%1", LOOTDATA];
    diag_log format ["##FuMsnInit: SOLDIERDATA:%1", SOLDIERDATA];
    diag_log format ["##FuMsnInit: %1 Themes loaded from the server",count THEMEDATA];    
    for [{_i=0},{_i < count THEMEDATA},{_i=_i+1}] do
    {      
        diag_log format ["####################################"];
        diag_log format ["#####Theme Index :%1  ##################",_i];
        diag_log format ["THEME DATA"];
        {
            diag_log format ["^^^^%1",_x];
        }foreach (THEMEDATA select _i); 
        diag_log format ["LOOT DATA"];
        {
            diag_log format ["^^^^%1",_x];
        }foreach (LOOTDATA select _i); 
        diag_log format ["SOLDIER DATA"];
        {
            diag_log format ["^^^^%1",_x];
        }foreach (SOLDIERDATA select _i);
        diag_log format ["####################################"];
    };    
    _serverOptions = ServerData select 0;
    // Change these to match your specific map!!!
    //Altis specific
    MapCenter = _serverOptions select 0;
    MapRange = _serverOptions select 1;
    // areas to not spawn encounters, if location being randomly generated.
    BlackList = ServerData select 1;
    Defaultpos = ServerData select 2;
    ActiveThemes = ServerData select 3; // array of theme names. Used to locate the theme's mission folder.
    // Configure RadioChatter module  See /Basic/ThemeData.sqf for details for more options!
    _radchat = ServerData select 4;
    RC_EnableRadioChatterSystem = _radchat select 0;
    RC_EnableRadioAudio = _radchat select 1;
    publicVariable "RC_EnableRadioAudio";
    RC_RadioRequired = _radchat select 2;
    RC_RadioFollowTheme = _radchat select 3;
    RC_EnableAIChatter = _radchat select 4;
    RC_AIRadioRange = _radchat select 5;
    RC_REINFORCEMENTS = []; // used in LogicBomb to detect when a group calls for help and BaseOps approves assistance!    
    // Identify major civilized areas on the map.
    VillageList = nearestLocations [MapCenter, ["NameVillage"], 30000];
    CityList =nearestLocations [MapCenter, ["NameCity"], 30000];
    CapitalList = nearestLocations [MapCenter, ["NameCityCapital"], 30000];
    {
        private ["_name"];
        _name = (text _x);
        //diag_log format ["## FuMsnInit: Urban area Located: %1",_name];
    }foreach (VillageList+CityList+CapitalList);    
    // Based upon the list of themes in 'ActiveThemes' the below arrays will be populated.
    // and a control loop started for each theme.     
    PhaseMsnID = 0;  // gets incremented every time a phased mission is launched.
    // Each mission launched from another mission increments PhaseMsnID and the phase mission is assigned the value as its ID.
    // This ID is then used to reference the below array from parent missions.
    PhaseMsn = []; //Array
    BodyCount = []; //Array containing number of AI killed under the current running mission. 
    //Phased missions contribute to the parent mission's total and are not calculated separately.    
    //Initialize ALL data before starting Theme Control Loops to permit global data to be fully initialized.    
	OkToGetData = true; //semephore to lock down data requests to server from multiple control loops.
    _themeNumber = 0;
    {
        [_x, _themeNumber ] execVM "HC\Encounters\ControlLoop.sqf";
        diag_log format ["*********************************************************************"];
        diag_log format ["*********************************************************************"];
        diag_log format ["##FUMSN Init: Fulcrum Mission System control loops starting for %1.", _x];    
        diag_log format ["*********************************************************************"];
        diag_log format ["*********************************************************************"];
        _themeNumber = _themeNumber + 1;
    }foreach ActiveThemes;       
    // Start AI RadioChatter Operations Center.
    [] execVM "HC\Encounters\AI_Logic\RadioChatter\BaseOps.sqf";   
};
