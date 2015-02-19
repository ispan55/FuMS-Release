//GetBox.sqf
// Horbin
// 2/7/15
// INPUTS: None
// OUTPUTS: box object
// selects a random box for loot, based upon global options found in BaseLoot.sqf
private ["_box"];
// _side = _this select 0;
//_type = _this select 1;
_box = [FuMS_STORAGE] call BIS_fnc_selectRandom;
_box
