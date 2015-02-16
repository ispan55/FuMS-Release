//HC_CreateGroup.sqf
// Horbin
// 12/26/2014
//INPUTS::Group, Position,  array of #units and type (see SpawnSoldier for format), Theme Index
// [group, pos, partycomp, themeindex]
//RETURNS:: group created
// Note:   group must remain in scope to maintain proper interaction with players.
SpawnSoldier = compile preprocessFileLineNumbers "HC\Encounters\AI_Logic\SpawnSoldier.sqf"; 

private ["_partycomp","_group","_unit","_i","_pos","_partysize","_typesoldier","_numunits","_themeIndex"];
_group = _this select 0;
_pos = _this select 1;
_partycomp = _this select 2;
_themeIndex = _this select 3;
//diag_log format ["HC_Create Group: _group:%1  _pos:%2  _partycomp:%3",_group, _pos, _partycomp];
{
    _partySize = _x select 0;
    _typesoldier = _x select 1;
    for [{_i=0},{ _i<_partySize}, {_i=_i+1}] do
    {
        _unit = [_group, _typesoldier, _pos, _themeIndex] call SpawnSoldier;
        [_unit] join _group;
    };
} foreach _partycomp;

//Notify server of new group so it will perform clean up on an HC disconnect.
if (!isServer) then
{
    // clean up any stale groups.
    {
        _numunits = count units _x;
        if (_numunits == 0 ) then
        {
            deleteGroup _x;
            _x = nil;
        };
    } foreach HC_HAL_AIGroups;
    HC_HAL_AIGroups = HC_HAL_AIGroups + [_group];
    // Pass new group list to the server so it can delete them if the HC disconnects.
    publicVariableServer "HC_HAL_AIGroups";
};
// Return the Group of soldiers!
_group