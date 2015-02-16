//PullData.sqf
// Horbin
// 2/8/15
// Inputs: theme name, file name
// Output: mission data provided by server for theme/mission 
private ["_missionTheme","_missionFileName","_fileName","_dataFromServer"];
_missionTheme = _this select 0;
_missionFileName = _this select 1;
_fileName = format ["%1\%2",_missionTheme,_missionFileName];
//waitUntil {OkToGetData};
//OkToGetData = false;  // semephore, locks access to 'GetMissionData' and its PVEH until this instance of the controlloop is complete with the call.
diag_log format ["##PullData: for %1\%2 is LOCKED",_missionTheme,_missionFileName];
MissionData = [];
GetMissionData = _fileName;
publicVariableServer "GetMissionData";	
waitUntil
{ 
    //diag_log format ["PullData waiting: MissionData=%1",MissionData];
    (count MissionData > 1)
};
// server gets request via 'GetMissionData'. 
// server updates "MissionData" and broadcasts it to HC
// HC waits until MissionData defined with new data.
// once missionData assigned to variable in this instance, it is relased for use by other instances by
//  setting OkToGetData to true.
_dataFromServer = MissionData;
//OkToGetData = true;
diag_log format ["##PullData: for %1\%2 is Unlocked",_missionTheme,_missionFileName];
_dataFromServer
