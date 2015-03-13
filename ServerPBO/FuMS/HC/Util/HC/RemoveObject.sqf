//RemoveObject.sqf
//Horbin
// 3/2/15
// Inputs: General variable name, value to be removed
private ["_Type","_value","_prefix","_suffix","_varName","_var"];
_Type = _this select 0;
_value = _this select 1;
_prefix = "FuMS_HC_HAL_";
_suffix = FuMS_HC_SlotNumber;
_varName = format ["%1%2%3",_prefix,_Type,_suffix];
_var = missionNamespace getVariable _varName;
_var = _var - [_value];
missionNamespace setVariable [_varName, _var];
publicVariableServer _varName;
