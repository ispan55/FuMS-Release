//AI_GuardBuilding.sqf
//Horbin
// 12/23/14
//
// 
// [_unit, "TRUE"] call GuardBuilding;
// Unit will travel to the nearest building within radius and do one of the following:
// "false":  Unit will perform constant patrol of all points within the building.
// "true":Unit will explore all points in building then take up station at the highest point.
// if no building is found, Bis_fnc_patrol will be called for the unit.
////[_group,_pos,50] call bis_fnc_taskPatrol; 
GetBuildingPositions =
{
    /*
    Author: 
    rübe    
    Description
    returns a list of all available building positions.    
    Parameter(s):
    _this: building (object)    
    Example:
    _positions = _building call FN_getBuildingPositions;     
    Returns:
    array of positions (guaranteed to return at least one position; position building)
    */    
    private ["_building", "_positions", "_i","_next"];
    _building = _this;
 //   diag_log format ["$$$ GetBuildingPostions:: _building=%1, TypeName=%2",_building, typeName _building];
    if (typeName _building == "ARRAY") then { _building = _building select 0;};
    _positions = [(getPos _building)];    
    // search more positions
    _i = 1;
    while {_i > 0} do
    {
        _next = _building buildingPos _i;
        if (((_next select 0) == 0) && ((_next select 1) == 0) && ((_next select 2) == 0)) then
        {
            _i = 0;
        } else {
            _positions = _positions + [_next];
            _i = _i + 1;
        };
    };  
    // return positions
    _positions
};    

private ["_unit","_curBuilding","_bPoss","_newPos","_i2","_starttime","_guard","_guarding","_highestPoss",
"_delay","_buildingPoints","_curZ","_highestZ"];
_unit = _this select 0;
_guard = _this select 1;
_guarding = false; //true = no longer exploring building, but is staying at highest point.
_curBuilding = nearestBuilding _unit;
//if ( count _curBuilding > 1) then {_curBuilding = _curBuilding select 0;};
if ( _unit distance _curBuilding > 150 ) then
{
    diag_log format ["##AI_GuardBuilding : %1 assigned to %2 which is >150m away!",_unit,_curBuilding];
};
_delay = 30;
// if not conducting constant search, then quickly work way to the top.
if (_guard) then {_delay = 1;};
_highestPoss = [0,0,0];
// get all the positions in the building and find the highest one.
_bPoss = [];
_buildingPoints = [_curBuilding] call GetBuildingPositions;
{
    _curZ = _x select 2;
    _highestZ = _highestPoss select 2;
    if (_curZ >= _highestZ) then { _highestPoss = _x;};
} foreach _buildingPoints;
_buildingPoints = _buildingPoints + [_highestPoss];
//diag_log format ["##AI_GuardBuilding _building Point list :%1",_buildingPoints];
_bPoss = _buildingPoints;
while { alive _unit }do
{
    if(isNull(_unit findNearestEnemy _unit))then
    {
        _unit forceSpeed 1;
        _unit setBehaviour "COMBAT";
        _unit action ["handGunOff", _unit];
    };
    if (!_guarding) then
    {
        // **move to the building, then move around inside.
        // diag_log format ["####AIOccupy:Exploring %1",_curBuilding];
        _i2 = 0; 
        while{_i2 < (count _bPoss)}do
        {
            _newPos = _bPoss select _i2;
            _unit doMove _newPos;
            _starttime = time; // if time > _starttime+60 may indicate AI attempting to 
            //  get to a point that is blocked or more than 1 minute walking distance, so advance to next point.
            waitUntil {sleep 1; (unitReady _unit || _unit distance _newPos < 2 || time> _starttime+60)};
            sleep random _delay;
            _i2 = _i2 +1;
        };
        //Unit has completed exploration of _curBuilding.
        // If constantSEARCH resume walking through building.
        //   otherwise move to highest point and stand guard.
        if (_guard) then{_guarding = true;};
    }else
    {
        _unit setBehaviour "COMBAT";
        sleep 30;
    };
};