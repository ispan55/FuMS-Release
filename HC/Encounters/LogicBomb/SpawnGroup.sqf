//SpawnGroup.sqf
// Horbin
// 1/4/15
// INPUTS groups array from Mission routine, mission center, encounter size, theme index, FlagSilentcheckin, missionName

//_groupData FORMAT:  [["RESISTANCE","COMBAT","RED","LINE"],   [  [2,"CivNoGun"]                                              ],   ["Guard",[6,6],[0,0],[30]       ]]
// _data FORMAT: [["RESISTANCE","COMBAT","RED","LINE"]
// _units FORMAT: [2,"CivNoGun"],[3,"Rifleman"]
//_aiLogic FORMAT: "Guard",[6,6],[0,0],30    
//     patrolpattern, spawnloc, focus loc of patrolpattern, [  pattern options]
// pattern options are parsed specific to the patrolpattern type.

// Flagsilentcheckin FALSE: 1st group of squad will checkin in with base. TRUE: no initial communicatin with base.
// this flag does NOT turn off AI radio chatter, just the intial checkin.

// OUTPUTS list of groups crated
XPos = compile preprocessFileLineNumbers "HC\Encounters\Functions\XPos.sqf";
HC_CreateGroup = compile preprocessfileLineNumbers "HC\Functions\HC_CreateGroup.sqf";
BoxPatrol = compile preprocessFileLineNumbers "HC\Encounters\AI_Logic\BoxPatrol.sqf";
PolygonPatrol = compile preprocessFileLineNumbers "HC\Encounters\AI_Logic\PolygonPatrol.sqf";
AreaPatrol = compile preprocessFileLineNumbers "HC\Encounters\AI_Logic\AreaPatrol.sqf";
Convoy = compile preprocessFileLineNumbers "HC\Encounters\AI_Logic\Convoy.sqf";
ScriptPatrol = compile preprocessFileLineNumbers "HC\Encounters\AI_Logic\ScriptPatrol.sqf";
 private ["_data","_side","_behaviour","_combat","_form","_units","_patrol","_spawnpos","_patternOptions","_silentcheckin",
"_aiLogic","_patrolSpawnLoc","_patrolPatrolLoc","_groupData","_groups","_eCenter","_group","_encounterSize","_themeIndex", "_missionName"];
_groupData = _this select 0;
_eCenter = _this select 1;
_encounterSize = _this select 2;
_themeIndex = _this select 3;
_silentcheckin = _this select 4;
_missionName = _this select 5;
if (isNil "_silentcheckin") then
{
    _silentcheckin = (((THEMEDATA select _themeIndex) select 3) select 0) select 1;
};
_groups = [];
if (!isNil "_groupData") then
{
    {
        if (count _x == 3) then
        {
            _data = _x select 0;
            _units = _x select 1;
            _aiLogic = _x select 2;
            //    diag_log format ["#Spawn Group: _data:%1, _units:%2, _aiLogic:%3",_data, _units, _aiLogic];
            _side = _data select 0;
            _behaviour = _data select 1;
            _combat = _data select 2;
            _form = _data select 3;
            //    diag_log format ["#Spawn Group: _side:%1, _behavior:%2, _combat:%3, _form:%4", _side, _behaviour, _combat, _form];
            _patrol = _aiLogic select 0;
            _patrolSpawnLoc = _aiLogic select 1;
            _patrolPatrolLoc = _aiLogic select 2;
            _patternOptions = _aiLogic select 3;   
            _spawnpos =[_eCenter, _patrolSpawnLoc] call XPos;
            switch (_side) do 
            {
                case "RESISTANCE":{ _group = createGroup RESISTANCE;};//RESISTANCE
                case "WEST": {_group = createGroup WEST;};
                case "EAST": {_group = createGroup EAST;};
                case "CIV" : {_group = createGroup CIVILIAN;};
                default { diag_log format ["#Spawn Group: ###ERROR###: Invalid _side: %1. No group created!",_side];};
            };
            //   diag_log format ["#Spawn Group: _group:%1",_group];
            _group setBehaviour _behaviour;
            _group setCombatMode _combat;
            _group setFormation _form;     
            _group = [_group,_spawnpos, _units,_themeIndex ] call HC_CreateGroup;
            //    diag_log format["#Spawn Group: _group:%1, _spawnpos:%2, _patrol:%3",_group, _spawnpos, _patrol];
            //Group Behavior
            _patrolPatrolLoc = [_eCenter, _patrolPatrolLoc] call XPos;
            _patrol = toUpper _patrol;        
            // FuMS AI global initialization.
            {
                _x setVariable ["AILOGIC", [ _patrol, _eCenter, _spawnpos, _patrolPatrolLoc, _patternOptions], false];
                _x setVariable [ "XFILL", [_themeIndex, _side, "TRUE"], false];        
                [_x] execVM "HC\Encounters\AI_Logic\AIEvac.sqf";
                
            }foreach units _group;    
            switch (_patrol) do
            {
                private ["_patrolRadius","_patrolDuration"];
                case "PERIMETER":
                { 
                    _patrolRadius = _patternOptions select 0;
                    if ( _patrolRadius == 0) then 
                    { 
                        _patrolRadius = .8* _encounterSize;
                    };
                    [_group, _patrolPatrolLoc, _patrolRadius,12,0,true] call PolygonPatrol;
                };
                case "BOXPATROL":
                { 
                    _patrolRadius = _patternOptions select 0;
                    if ( _patrolRadius == 0) then 
                    { 
                        _patrolRadius = .8* _encounterSize;
                    };  
                    [_group, _patrolPatrolLoc, _patrolRadius, 0, true] call BoxPatrol;
                };       
                case "EXPLORE":
                { 
                    _patrolRadius = _patternOptions select 0;
                    if ( _patrolRadius == 0) then 
                    { 
                        _patrolRadius = .8* _encounterSize;
                    };    
                    [_group, _patrolPatrolLoc, _patrolRadius] call AreaPatrol;
                };
                case "BUILDINGS":
                {
                    _patrolRadius = _patternOptions select 0;
                    _patrolDuration = _patternOptions select 1;     
                    [_group, _patrolPatrolLoc,"AI_PB", [_patrolPatrolLoc, _patrolRadius, _patrolDuration]  ] call ScriptPatrol;
                };
                case "SENTRY":
                {
                    _patrolRadius = _patternOptions select 0;
                    if ( _patrolRadius == 0) then 
                    { 
                        _patrolRadius = .8* _encounterSize;
                    };
                    {
                        [_x, true] execVM "HC\Encounters\AI_Logic\AI_GuardBuilding.sqf";
                    } foreach units _group;
                };
                case "Loiter":{};
                case "CONVOY":
                {
                    //"NORMAL",true,true, true
                    private ["_wp","_speed","_rtb","_roads","_despawn"];
                    //_speed = _patternOptions select 0; 
                    //_rtb = _patternOptions select 1;
                    //_roads = _patternOptions select 2;
                    //_despawn = _patternOptions select 3;
                    //_xfill = _patternOptions select 4;
                    _wp = [_group, _patrolPatrolLoc, _patternOptions] call Convoy;            
                };
                case "PARADROP":
                {
                    //pilotgroup, dropoff point, options!
                    [_group, _patrolPatrolLoc, _patternOptions] execVM "HC\Encounters\AI_Logic\Paradrop.sqf";
                };
                case "PATROLROUTE":
                {
                    [_group, _patrolPatrolLoc, _patternOptions] execVM "HC\Encounters\AI_Logic\PatrolRoute.sqf";
                };
                case "XCountry":{};
            };
            // _wp available here to permit further customization of the group's behavior at each waypoint.
            // _wp is set to the 1st waypiont the AI are to move too (ie not their spawn loc!))
            // ##For behavior that execVM's##: no wp modification is available.    
            //Spawn RadioChatter module for this Group
            // Data available _groupData, _eCenter, _encounterSize, _themeIndex
            // Know there are going to be 'count _groupData' groups made.
            //  desire to have only the 'lead' group check in.
            if (!_silentcheckin) then  // if not silent checkin, then ONLY lead group of squad checks in.
            {
                if (count _groups == 0) then {_silentcheckin = false;}else{_silentcheckin=true;}
            };    
            // initiate radio logic for the group, now that its formation is complete!
            [_group, _themeIndex, _eCenter, _silentcheckin, _missionName] execVM "HC\Encounters\AI_Logic\RadioChatter\AIRadio.sqf";   
            _groups = _groups + [_group];
        }else{diag_log format ["##SpawnGroup: Error in data formatting in Group section: %1, theme:%2, data:%3",_missionName, _themeIndex, _x];};
    } foreach _groupData;
};
_groups


