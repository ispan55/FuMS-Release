//PullData.sqf
// Horbin
// 2/8/15
// Inputs: theme name, file name
// Output: mission data provided by server for theme/mission 
private ["_missionTheme","_missionFileName","_fileName","_dataFromServer","_timeout","_abort"];
_missionTheme = _this select 0;
_missionFileName = _this select 1;
_fileName = format ["%1\%2",_missionTheme,_missionFileName];
//waitUntil {OkToGetData};
//OkToGetData = false;  // semephore, locks access to 'GetMissionData' and its PVEH until this instance of the controlloop is complete with the call.
diag_log format ["##PullData: for %1\%2 is LOCKED",_missionTheme,_missionFileName];
MissionData = [];
_dataFromServer = [];
FuMS_GetMissionData = _fileName;
publicVariableServer "FuMS_GetMissionData";	
_timeout = time + 60; // wait 60 seconds for data from server.
_abort = true;
while {time < _timeout} do
{ 
    if (count MissionData ==10) then {_abort=false;_timeout = time;}; // contains the proper number of fields based upon the Mission file.
    if (count MissionData ==9) then {_abort=false;_timeout = time;}; // Legacy mission pre-air vehicle compatability
};
//diag_log format ["##PullData:DEBUG: _timeout:%1 time:%2 MissionData:%3 - %4",_timeout, time, count MissionData, MissionData];
if (_abort) then
{
    diag_log format ["-------------------------------------------------------------------------------------"];
    diag_log format ["----------------            Fulcrum Mission System                    -----------------"];
    diag_log format ["-------------------------------------------------------------------------------------"];
    diag_log format ["##FuMsnInit: ERROR in Fulcrum Mission Data. Mission will be aborted."];
    diag_log format ["    Recommend verifying data in file \FuMS\Themes\%1\%2 on your server!",_missionTheme,_missionFileName];        
    diag_log format ["             -ABORT- -ABORT- -FORMAT ERROR- -ABORT- -ABORT-"];   
    diag_log format ["                            Fulcrum Mission System %1 aborted!",_missionFileName];
    diag_log format ["REASON: Data Time out from server for: %1/%2",_missionTheme,_missionFileName];
    diag_log format ["Recommend checking your server's .rpt file for further information"];
    diag_log format ["-------------------------------------------------------------------------------------"];
    diag_log format ["-------------------------------------------------------------------------------------"];   
}
else
{
       // server gets request via 'GetMissionData'. 
    // server updates "MissionData" and broadcasts it to HC
    // HC waits until MissionData defined with new data.
    // once missionData assigned to variable in this instance, it is relased for use by other instances by
    //  setting OkToGetData to true.
    _dataFromServer = MissionData;
    //OkToGetData = true;
};
diag_log format ["##PullData: for %1\%2 is Unlocked",_missionTheme,_missionFileName];    
MissionData = [];
_dataFromServer
// if there was an error in the mission config file _dataFromServer will be 'nil'


