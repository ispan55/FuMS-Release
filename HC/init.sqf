//init.sqf
// Horbin
// 12/31/14
// run this script from the server's mpmissions init.sqf
// This script will conduct proper initialization all necessary HC data
if (isServer) then
{
	private ["_path"];
	_path = "\FuMS\init.sqf";
	diag_log format ["Starting FuMS via %1",_path];
	[] ExecVM _path;
};
//***************************
//** Start Player and Headless Client Init  
// !hasInterface => HC
//***************************
if (!isServer) then 
{
	waitUntil {!isNull player};
	waitUntil {player == player};
};
//*************************
//** Start HC Init 
// ASSERT: Player Init above already completed by Headless Client
//*************************
if !(hasInterface or isServer) then
{
    private ["_script"];
    _script = [] execVM "HC\HC_Init.sqf";
    waitUntil {scriptDone _script};
};
//***************************
//** Execute on all players, HC's, and server
//***************************
[] execVM "HC\HC_Player_Init.sqf";