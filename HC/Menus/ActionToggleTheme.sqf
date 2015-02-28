//ActionToggleTheme.sqf
// Horbin
// 2/25/15
private ["_index","_msg"];
_index = _this select 0;
_msg = "";
if (FuMS_AdminThemeOn select _index) then {FuMS_AdminThemeOn set [_index, false]; _msg="OFF";}
else {FuMS_AdminThemeOn set [_index, true];_msg="ON";};
publicVariable "FuMS_AdminThemeOn";

systemChat format["FuMS:Admin:Theme <%1> was turned %2",FuMS_ActiveThemes select _index, _msg];