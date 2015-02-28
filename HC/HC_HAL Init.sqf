//HC_HAL Init.sqf
// for HC_HAL
private ["_HCname"];
if (hasInterface or isServer) exitWith{};

_HCname = _this select 0;
//******************************
//***Initialization                        ***
//******************************
// Make sure mission is running
 diag_log format ["##HC:%1: Waiting on Mission to Start##",_HCname];
waitUntil {time >0};
// Notify the server that the HC needs to be initialized with global FuMS variables
HC_HAL_Initialized = false;
publicVariableServer "HC_HAL_Initialized";
// sent to server to permit specific passing of global vars to the HC.
// Note: This is not always set to 'HC_HAL'. A bug with HC's, so multiple types of checks need to be done
//   when determining if an owner is the HC.
HC_HAL_Player = player;
publicVariableServer "HC_HAL_Player";
// HC reconnect detected. Waiting on server to finish cleanup.
if (! isNil "HC_HAL_isDirty") then
{
    diag_log format ["##HC:%1: Reconnect detected. Waiting on Server cleanup.##",_HCname];    
    waitUntil { (HC_HAL_isDirty == "FALSE")};//isDirty set FALSE by server after completion of global object cleanup.
};
HC_HAL_isDirty = "TRUE";
publicVariableServer "HC_HAL_isDirty";
//Define all 'Handshake' variables here.
// If 1st time connecting define them, otherwise preserve the lists.
// Lists should have been emptyied by the Server's isAlive routine, but there may be exceptions permitted
//   such as vehicles in posesssion of players.
if (isNil "HC_HAL_Markers") then {HC_HAL_Markers=[];publicVariableServer "HC_HAL_Markers";};
if (isNil "HC_HAL_Vehicles") then {HC_HAL_Vehicles=[];publicVariableServer "HC_HAL_Vehicles";};
if (isNil "HC_HAL_AIGroups")then {HC_HAL_AIGroups = [];publicVariableServer "HC_HAL_AIGroups";};
if (isNil "HC_HAL_Buildings")then {HC_HAL_Buildings =[];publicVariableServer "HC_HAL_Buildings";};
if (isNil "HC_HAL_Triggers") then {HC_HAL_Triggers = [];publicVariableServer "HC_HAL_Triggers";};
if (isNil "HC_HAL_NumBuildings") then {HC_HAL_NumBuildings = 0; publicVariableServer "HC_HAL_NumBuildings";};
//HC to server isAlive loop.
[] spawn
{
    diag_log format ["%%%% Heart Beat Started %%%%"];
    while {true} do
    {
        // HC heartbeat sent to server every 2 seconds.
       uiSleep 1;
        HC_HAL_isAlive = "TRUE"; 
        publicVariableServer "HC_HAL_isAlive";
    };
};
// wait 15 seconds to ensure JIP/login is recognized by the server before starting to initialize encounters
sleep 15;
//HC has connected and and initialzied. So notify the server!
HC_HAL = "TRUE";
publicVariableServer "HC_HAL";       
  