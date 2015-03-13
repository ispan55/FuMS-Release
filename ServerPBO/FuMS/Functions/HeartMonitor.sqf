// HeartMonitor.sqf
// Horbin
// 2/28/15

// Needs to occur LAST after all other server initialization!
//Launch HC cleanup process.
// This script watches for an HC disconnect
// When identified, server will cleanup objects that where controlled by the HC
// Use included HC_CreateGroup, HC_CreateVehicle, etc functions on the HC to ensure cleanup!
FuMS_HC_DataCleanup	= compile preprocessFileLineNumbers "\FuMS\Functions\HC_DataCleanup.sqf"; 

private ["_hcID","_handle","_owner"];
_owner = _this select 0;
_hcID = owner _owner;
diag_log format ["##Server-HC Heart Monitor Slot #%1 operational for %2", _hcID, _owner];

_handle = [_owner ] execVM "\FuMS\Functions\InitHeadlessClient.sqf";
waitUntil {ScriptDone _handle};
FuMS_ServerIsClean = true;
FuMS_ServerInitData = true;
_hcID publicVariableClient "FuMS_ServerInitData";    // once received by HC, it will start FuMS control loops.

[_owner] spawn
{
    private ["_prefix","_hcID","_pulse","_status","_owner","_start","_dead"];
    _prefix = "FuMS_HC_isAlive";
    _owner = _this select 0;
    _hcID = owner _owner;
   _ownerName = format ["%1",_owner]; // convert it to text, so when it goes dead, we still know its name!    
    _pulse = format ["%1%2",_prefix, _hcID];
    _isInited = format ["%1%2_init"];  
    while {alive _owner}do {sleep 3;};
    _start = time;
    diag_log format ["##HeartMonitor:%1: Disconnect detected. Cleaning up the Mess!!!!%2",_ownerName,_pulse];  
    // Cleanup AI Groups
    FuMS_ServerIsClean = false;
    [_hcID] call FuMS_HC_DataCleanup;                   
    diag_log format ["HC:%1: Complete in %3 secs!%2",_ownerName,_pulse, time-_start];  
    missionNamespace setVariable [_pulse, nil];
    FuMS_ServerIsClean = true;       
    diag_log format ["##HeartMonitor: Has ended for %1:%2",_ownerName,_pulse];
};


