//HC_Init.sqf
// Horbin
// 12/23/14 - mod 3/2/15
private ["_HCname","_i"];
if (hasInterface or isServer) exitWith{};

waitUntil{!isNull (uiNameSpace getVariable ["EPOCH_loadingScreen", displayNull])};
waitUntil{isNull (uiNameSpace getVariable "EPOCH_loadingScreen")};

_HCname = profileName;
for [{_i=0}, {_i < 50}, { _i = _i +1}] do
{
    diag_log format ["##############################################"];   
    if (_i == 26) then {diag_log format ["##Headless Client %1 connected with profile %2##",player,_HCname];};
};
waitUntil {time >0};
waitUntil {!isNil "FuMS_Server_Operational"};
waitUntil {FuMS_Server_Operational};

FuMS_GetHCIndex = player;
FuMS_HC_SlotNumber = -1;
waitUntil
{
    publicVariableServer "FuMS_GetHCIndex";
    sleep 3; // give the server time to respond and init, so we dont spam it!!!!
    //diag_log format ["##HC_Init:   GetHCIndex:%1  FuMS_HC_SlotNumber:%2",FuMS_GetHCIndex, FuMS_HC_SlotNumber];
    (FuMS_HC_SlotNumber >= 0) 
};

waitUntil 
{
    sleep 5;
    diag_log format ["##HC_INIT: Waiting on Server to initialize."]; 
    (!isNil "FuMS_ServerInitData" or !isNil "FuMS_HC_ScriptList")
};
//waitUntil {FuMS_ServerInitData}; // Server has completed loading all configuration data, and has passed it via PVClient calls.
sleep 5;
diag_log format ["##HC_INIT: Script List size = %1",count FuMS_HC_ScriptList];
{ 
    private ["_code"];
	diag_log format ["##HC_Init: Compiling %1 ",_x];
    _code = compile (missionNamespace getVariable _x);
	missionNamespace setVariable [_x, _code];
}foreach FuMS_HC_ScriptList;

diag_log format ["##HC_Init: Starting FuMS!"];
[] spawn FuMS_fnc_HC_FuMsnInit;

