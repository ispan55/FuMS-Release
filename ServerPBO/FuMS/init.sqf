// init.sqf
// Horbin
// 2/7/15
//
// Server side init for FuMS.pbo addon
if (!isServer) exitWith {};
private ["_handle"];
FuMS_HCIDs = [];
FuMS_HCNames = [];
FuMS_HCIDs set [0,0]; // set the 1st slot to be the actual server's ID.
FuMS_HCNames set [0, "SERVER"];
FuMS_AdminListofMissions = []; //Full list of all missions on the server. [themeIndex, themeName, missionName] format.

_handle = [] execVM "\FuMS\Menus\init.sqf";
waitUntil {ScriptDone _handle};

// Preprocess all HC files and prepare variables for transfer of HC files to HC's as they connect
_handle = [] execVM "\FuMS\HC\LoadScriptsForHCv2.sqf";
waitUntil {ScriptDone _handle};

_handle = [] execVM "\FuMS\Functions\PVEH.sqf";
waitUntil {ScriptDone _handle};

_handle = [] execVM "\FuMS\Functions\LoadCommonData.sqf";
waitUntil {ScriptDone _handle};

diag_log format ["##\FuMS\Init.sqf:  Server side FuMS initialized and operational."];
FuMS_Server_Operational = true;
publicVariable "FuMS_Server_Operational";
FuMS_ServerIsClean = true;
