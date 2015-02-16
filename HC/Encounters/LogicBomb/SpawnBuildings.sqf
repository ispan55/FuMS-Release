//SpawnBulding.sqf
// Horbin
// 1/4/2015
//INPUTS: Building data from Mission main
//OUTPUTS: array of buildings
XPos = compile preprocessFileLineNumbers "HC\Encounters\Functions\XPos.sqf";
private ["_type","_offset","_newpos","_rotation","_bldg","_buildings","_buildingData","_eCenter"];
_buildingData = _this select 0;
_eCenter = _this select 1;
_buildings = [];
if (!isNil "_buildingData") then
{
    {
        if (count _x == 4) then
        {
        _type = _x select 0;
        _offset = _x select 1;
        _rotation = _x select 2;
        _newpos = [ _eCenter, _offset] call XPos;
        //   _newpos = [_newpos, 0, 100, 1,0, 8,0,[],[[0,0],[0,0]]] call BIS_fnc_findSafePos; // 1m clear, terraingradient 8 pretty hilly
        _bldg = createVehicle [ _type, _newpos,[],_rotation,"CAN_COLLIDE"];
        // store in HC variable.
        _buildings = _buildings+ [_bldg];
        HC_HAL_NumBuildings = HC_HAL_NumBuildings + 1;
        // diag_log format ["## SPAWN Buildings: _bldg:%1   _buildings:%2",_bldg, _buildings];
        }else {diag_log format ["##SpawnBuilding: ERROR in building data format for mission located at %1, Data:%2",_eCenter,_x];};
    } foreach _buildingData;
    //diag_log format ["## SPAWN Buildings: %1",_buildings];
    if (count _buildings > 0) then
    {
        HC_HAL_Buildings = HC_HAL_Buildings + [_buildings];
        publicVariableServer "HC_HAL_Buildings";
        publicVariableServer "HC_HAL_NumBuildings";
    };
};
_buildings
