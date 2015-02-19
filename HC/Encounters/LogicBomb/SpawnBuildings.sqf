//SpawnBulding.sqf
// Horbin
// 1/4/2015
//INPUTS: Building data from Mission main, eCenter, themeIndex, _curMission
//OUTPUTS: array of buildings
XPos = compile preprocessFileLineNumbers "HC\Encounters\Functions\XPos.sqf";
CheckBuildingFormat = compile preprocessFileLineNumbers "HC\Encounters\Functions\CheckBuildingFormat.sqf";

private ["_type","_offset","_newpos","_rotation","_bldg","_buildings","_buildingData","_eCenter","_themeIndex","_curMission"];
_buildingData = _this select 0;
_eCenter = _this select 1;
_themeIndex = _this select 2;
_curMission = _this select 3;

_buildings = [];
if (!isNil "_buildingData") then
{
    if (count _buildingData > 0) then
    {
        private ["_firstBuilding"];
        // check if 1st building is at [0,0,0]. If so, work offsets!
        _firstBuilding = _buildingData select 0;
        if ([_firstBuilding] call CheckBuildingFormat) then
        {
            private ["_fbLoc","_useOffset"];
            _fbLoc = _firstBuilding select 1;
            _useOffset = false;
            if (_fbLoc select 0 == 0 and _fbLoc select 1 == 0 and _fbLoc select 2 ==0) then {_useOffset = true;};    //3d locations, using offsets! 
            diag_log format ["##SpawnBuildings: Debug: 1stBuilding: %1  _useOffset:%2",_firstBuilding, _useOffset];
            //foreach _buildingData
            {
                if ([_x] call CheckBuildingFormat) then
                {
                    _type = _x select 0;
                    _offset = _x select 1;
                    _rotation = _x select 2;
                    
                    if (_useOffset) then
                    {
                        private ["_newx","_newy","_newz"];
                        if (count _eCenter == 2) then {_eCenter set [2,0];};
                        _newx = _eCenter select 0;
                        _newx = _newx + (_offset select 0);
                        
                        _newy = _eCenter select 1;
                        _newy = _newy + (_offset select 1);
                        
                        _newz = _eCenter select 2;
                        _newz = _newz + (_offset select 2);
                        _newpos = [_newx, _newy, _newz];
                    }else {_newpos = [ _eCenter, _offset] call XPos;};
                    //   _newpos = [_newpos, 0, 100, 1,0, 8,0,[],[[0,0],[0,0]]] call BIS_fnc_findSafePos; // 1m clear, terraingradient 8 pretty hilly
                    _bldg = createVehicle [ _type, _newpos,[],0,"CAN_COLLIDE"];
                    _bldg setDir _rotation;
                    // store in HC variable.
                    _buildings = _buildings+ [_bldg];
                    HC_HAL_NumBuildings = HC_HAL_NumBuildings + 1;
                    // diag_log format ["## SPAWN Buildings: _bldg:%1   _buildings:%2",_bldg, _buildings];                
                }else
                {
                    diag_log format ["##SpawnBuilding: ERROR in building data format for mission %1/%2", FuMS_ActiveThemes select _themeIndex,  _curMission];
                    diag_log format ["##SpawnBuilding: Offending building : %1", _x];
                    _buildingData=_buildingData-[_x];
                };
            } foreach _buildingData;
            //diag_log format ["## SPAWN Buildings: %1",_buildings];
            if (count _buildings > 0) then
            {
                HC_HAL_Buildings = HC_HAL_Buildings + [_buildings];
                publicVariableServer "HC_HAL_Buildings";
                publicVariableServer "HC_HAL_NumBuildings";
            };
        };
    };
};
_buildings
