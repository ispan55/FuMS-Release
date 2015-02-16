//SpawnMissionLoot.sqf
// Horbin
//1/2/15
//INPUTS: loot data from Mission, encounter center, one of "STATIC","WIN","LOSE", Loot Data to be parsed!
//OUTPUTS: loot box filled.
XPos = compile preprocessFileLineNumbers "HC\Encounters\Functions\XPos.sqf";
FillLoot = compile preprocessFileLineNumbers "HC\Encounters\LogicBomb\FillLoot.sqf";
private ["_lootConfig","_eCenter","_option","_staticLoot","_winLoot","_pos","_themeIndex","_box","_boxes","_loseLoot","_loot"];
_lootConfig = _this select 0;
_eCenter = _this select 1;
_option = _this select 2;
_themeIndex = _this select 3;
if (!isNil "_lootConfig") then  // if no loot data then no loot for mission!
{
    _staticLoot = _lootConfig select 0;
    _winLoot = _lootConfig select 1;
    _loseLoot = _lootConfig select 2;
    _boxes = [];
    
    if (_option == "NO TRIGGERS") then {_option ="STATIC";};
    switch (_option) do
    {
        case "STATIC":
        {
           _loot = _staticLoot;
        };
        case "WIN":
        {
            _loot = _winLoot;
        };
        case "LOSE":
        {
            _loot = _loseLoot;
        };
    };
    if (typeName (_loot select 0) == "STRING") then
    {    
        _pos = [_eCenter, _loot select 1] call XPos;
        _box = [_loot select 0, _pos, _themeIndex] call FillLoot;
        _boxes = _boxes + [_box];
    }else
    {
        //ASSERT it is an array of loot options!
        {
            _pos = [_eCenter, _x select 1] call XPos;
            _box = [_x select 0, _pos, _themeIndex] call FillLoot;
            _boxes = _boxes + [_box];
        }foreach _loot;
    };
};
_boxes
