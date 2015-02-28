//ToggleTheme.sqf
// Horbin
// 2/25/15
private ["_toggleThemeMenu","_i","_txt","_action","_command"];
_action = "HC\Menus\ActionToggleTheme.sqf";
if (isNil "FuMS_ActiveThemes") exitWith {systemChat format ["Critical Error: FuMS may be offline. Check with an Admin!"];};
_toggleThemeMenu =[["Toggle Theme",true]];
for [{_i=0},{_i < count FuMS_ActiveThemes},{_i=_i+1}] do
{
    if (FuMS_AdminThemeOn select _i) then
    {                                 
        _txt ="   ON   :";
    }else{    _txt="   OFF  :";};
    //      if ((((FuMS_THEMEDATA select _i) select 0) select 1) == 4) then {_txt="STATIC:";};
    // not worth broadcasting this to all clients to get the indications.                                                                                               
    _txt = format ["%1%2",_txt,FuMS_ActiveThemes select _i];
    _command = format ["[%1]",_i] + ' execVM "'+_action+'"';
    _toggleThemeMenu = _toggleThemeMenu + 
    [[_txt,             [0],"",-5,[["expression",     _command]],"1","1"]];		           
};
_toggleThemeMenu = _toggleThemeMenu + [["EXIT", [_i], "", -3, [["expression", ""]], "1", "1"]];
_toggleThemeMenu

