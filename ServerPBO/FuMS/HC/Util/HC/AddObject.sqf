//AddObject
//Horbin
// 3/2/15
// Inputs: General variable name, value to be added
private ["_Type","_value","_prefix","_suffix","_varName","_var"];
_Type = _this select 0;
_value = _this select 1;
_prefix = "FuMS_HC_HAL_";
_suffix = FuMS_HC_SlotNumber;
_varName = format ["%1%2%3",_prefix,_Type,_suffix];
//diag_log format ["##AddObject: _varName:%1 _value:%2",_varName, _value];
_var = missionNamespace getVariable _varName;
_var = _var + [_value];
missionNamespace setVariable [_varName, _var];
publicVariableServer _varName;
