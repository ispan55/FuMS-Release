// init.sqf
// Horbin
// 2/7/15
//
// Server side init for FuMS.pbo addon
private ["_handle"];
if (!isServer) exitWith {};

diag_log format ["##FuMS Server module initializing##"];

// initialize server side functions
_handle = [] execVM "\FuMS\Functions\ServerInit.sqf";
waitUntil {scriptDone _handle};

// all server functions and variables initialized. Notify everyone!
FuMS_Server_Operational = true;
publicVariable "FuMS_Server_Operational";


// wait for notification that the headless client is connected and requested to initialize
// send the HC all global variables it will need
// begin initialization of all themes



// Global variable so other scripts can check if VEMF is running

