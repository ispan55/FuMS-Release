//HC_Init.sqf
// Horbin
// 12/23/14
//  Main Init called by mission init.sqf. This init executed by all HC's that connect.
//  Call individiual HC inits from this file.
private ["_HCname","_i","_script"];
if (hasInterface or isServer) exitWith{};
_HCname = profileName;
for [{_i=0}, {_i < 25}, { _i = _i +1}] do
{
 diag_log format ["##############################################"];   
};
diag_log format ["##Headless Client %1 connected with profile %2##",player,_HCname];
for [{_i=0}, {_i < 25}, { _i = _i +1}] do
{
 diag_log format ["##############################################"];   
};
//Init for HC_HAL. Include Init for other HC's if using multiple HC's on your server.
_script = [_HCname] execVM "HC\HC_HAL Init.sqf";
waitUntil { scriptDone _script};
