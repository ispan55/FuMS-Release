//ActionKillMission.sqf
// Horbin
// 2/25/15
private ["_index","_mission","_killMsg"];
_index = _this select 0;
_mission = (FuMS_ActiveMissions select _index ) select 1;
_killMsg = [_index, "KILL"];
FuMS_ActiveMissions set [_index, _killMsg];
publicVariable "FuMS_ActiveMissions";

systemChat format["FuMS:Admin:Mission <%1> is being terminated!",_mission];