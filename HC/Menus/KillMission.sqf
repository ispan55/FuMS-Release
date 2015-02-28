//KillMission.sqf
// Horbin
// 2/25/15
private ["_killMissionMenu","_i","_txt","_action","_command","_data"];
_action = "HC\Menus\ActionKillMission.sqf";
if (isNil "FuMS_ActiveThemes") exitWith {systemChat format ["Critical Error: FuMS may be offline. Check with an Admin!"];};
_killMissionMenu =[["Kill Mission",true]];
for [{_i=0},{_i < count FuMS_ActiveMissions},{_i=_i+1}] do
{
    _data = FuMS_ActiveMissions select _i;
    if (!isNil "_data")then
    {
        if (count _data == 2) then
        {
            if (_data select 1 != "COMPLETE" and _data select 1 != "KILL") then
            {
                _txt = format ["%1",_data select 1];
                _command = format ["[%1]",_i] + ' execVM "'+_action+'"';
                _killMissionMenu = _killMissionMenu + 
                [[_txt,             [0],"",-5,[["expression",     _command]],"1","1"]];		           
            };
        };
    };
};
_killMissionMenu = _killMissionMenu + [["EXIT", [_i], "", -3, [["expression", ""]], "1", "1"]];
_killMissionMenu

