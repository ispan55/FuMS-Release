//GetBox.sqf
// Horbin
// 2/7/15
// INPUTS: None
// OUTPUTS: box object
// selects a random box for loot, based upon global options found in BaseLoot.sqf
private ["_side","_type","_box","_numboxes","_numstorage","_probOfBox","_choice"];
// _side = _this select 0;
//_type = _this select 1;
_side = "";
_type = "";
_numboxes = count BOXSIDE * count BOXTYPE;
_numstorage = count STORAGE;
_probOfBox = (_numboxes / (_numboxes + _numstorage))*100;
if ( floor(random 100) < _probOfBox) then
{   
    _box = "box_";
    _side = BOXSIDE call BIS_fnc_selectRandom;
    if (_side == "ind") then
    {
        // while loop added to prevent creation of box_ind_ammoveh_f, which conflicts with InfiStar tools.
        while {_type != "ammoveh_f"} do
        {
            _type = BOXTYPE call BIS_fnc_selectRandom;
        };
    }else
    {
        _type = BOXTYPE call BIS_fnc_selectRandom;
    };
    _box = format ["box_%1_%2",_side,_type];
}else
{   
    _choice = STORAGE call BIS_fnc_selectRandom;
    _box = format ["%1", _choice];
};
_box