//MissionInit.sqf
// Horbin
// 1/4/15
// Called by a 'missionname.sqf' configuration file located in 'mission theme' folder
// INPUTS: Init data from mission config file
// and array containing: [mission theme name, theme ID, phaseID, mission Name override]
// Theme will determine what folder mission specifics are read.
private ["_eCenter","_missionTheme","_missionArea","_markers","_curMission","_mkr1","_mkr2","_initData","_silentspawn",
"_notifications","_lootConfig","_buildingData","_groupData","_vehicleData","_phaseData","_encounterSize","_triggerData",
"_buildings","_groups","_vehicles","_msnStatus","_i","_convoys","_delay","_themeIndex","_box","_phaseID","_fragments",
"_missionNameOverride","_passthroughData","_boxes","_aircraftData"];
LogicBomb = compile preprocessFileLineNumbers "HC\Encounters\LogicBomb\LogicBomb.sqf";
SpawnBuilding = compile preprocessFileLineNumbers "HC\Encounters\LogicBomb\SpawnBuildings.sqf";
SpawnGroup = compile preprocessFileLineNumbers "HC\Encounters\LogicBomb\SpawnGroup.sqf";
SpawnVehicle = compile preprocessFileLineNumbers "HC\Encounters\LogicBomb\SpawnVehicle.sqf";
SpawnMissionLoot = compile preprocessFileLineNumbers "HC\Encounters\LogicBomb\SpawnMissionLoot.sqf";
SpawnNotifications = compile preprocessFileLineNumbers "HC\Encounters\LogicBomb\SpawnNotifications.sqf";
_initData = _this select 0;
_passthroughData = _this select 1;
_eCenter = _passthroughData select 0;
_missionTheme = _passthroughData select 1; // used in locating phased missions attached to this mission
_themeIndex = _passthroughData select 2;
_phaseID = _passthroughData select 3;
_missionNameOverride = _passthroughData select 4;
if (isNil "_missionNameOverride") then {_missionNameOverride = "";};
_msnStatus = "STATIC";
_boxes = [];
//diag_log format ["_pos:%1, Theme:%2, _initData:%3",_eCenter, _missionTheme, _initData];
_missionArea =_initData select 0;
_markers = _initData select 1;
_notifications = _initData select 2;
_lootConfig = _initData select 3;
_buildingData = _initData select 4;
_groupData = _initData select 5;
_vehicleData= _initData select 6;
_triggerData = _initData select 7;
_phaseData = _initData select 8;  
_aircraftData = _initData select 9;
//diag_log format ["##MissionInit : override=%1",_missionNameOverride];
if ( _missionNameOverride != "") then
{
    _curMission = _missionNameOverride;
}
else { _curMission = _missionArea select 0;};
_encounterSize = _missionArea select 1;
_mkr1 = format ["%1_%2_1",_missionTheme, _curMission];
_mkr2 = format ["%1_%2_2",_missionTheme, _curMission];
createMarker [_mkr1, [0,0] ];
createMarker [_mkr2, [0,0]];
_buildings = [_buildingData, _eCenter] call SpawnBuilding;
_silentspawn = (((THEMEDATA select _themeIndex) select 3) select 0) select 1;
//diag_log format ["##MissionInit: SpawnGroup at center:%1",_eCenter];
_groups = [_groupData, _eCenter, _encounterSize, _themeIndex, _silentspawn,_curMission] call SpawnGroup;
_convoys = [_vehicleData, _eCenter, _encounterSize, _groups, [], _themeIndex, _curMission] call SpawnVehicle;
_groups = _convoys select 0;
_vehicles = _convoys select 1;
if (!isNil "_aircraftData") then
{
    _convoys = [_aircraftData, _eCenter, _encounterSize, _groups, _vehicles, _themeIndex, _curMission] call SpawnVehicle;
    _groups = _convoys select 0;
    _vehicles = _convoys select 1;
};
_box= [_lootConfig, _eCenter, _msnStatus, _themeIndex] call SpawnMissionLoot;
_boxes = _boxes + _box;
[_markers, _notifications, _msnStatus, _mkr1, _mkr2, _eCenter, _missionNameOverride] call SpawnNotifications;
// Mission Completion Logic
_fragments = [_msnStatus,_buildingData, _buildings, _groups, _vehicles, _boxes];
//diag_log format ["****************************************"];
//diag_log format ["##MissionInit :%2 : Pre-LogicBomb: %1", _fragments, _curMission];
_fragments = [[_missionTheme,_eCenter, _encounterSize, _phaseData, _themeIndex, _curMission],_triggerData, 
                        [_buildingData,_buildings, _groups, _vehicles,_box]       ] call LogicBomb;
// merge objects from child with this parent.
//diag_log format ["##MissionInit :%2 Post-LogicBomb: %1", _fragments, _curMission];
//diag_log format ["****************************************"];
_msnStatus = _fragments select 0;
_buildingdata = _fragments select 1;
_buildings = _fragments select 2;
_groups = _fragments select 3;
_vehicles = _fragments select 4;
_box = _fragments select 5;
// Mission complete: Take action based upon Trigger/Mission Logic above
diag_log format ["## MissionInit: Mission %2 finished with status of :%1",_msnStatus, _curMission];
_box = [_lootConfig, _eCenter, _msnStatus,_themeIndex] call SpawnMissionLoot;
_boxes = _boxes + _box;
_delay = [_markers, _notifications, _msnStatus, _mkr1, _mkr2,_eCenter, _missionNameOverride] call SpawnNotifications;
//sleep _delay;
// **********************************************************************
// Common Mission clean up
// For boxes: look to have a seperate timer, spawn a process to wait that timer period then delete them!
diag_log format ["##MissionInit: Preparing to delete loot: %1",_boxes];
{
    if (typeName _x != "ARRAY") then
    {
        [_x] spawn
        {
            private ["_box","_timer"];
            _box = _this select 0;
            _timer = time + (GlobalLootOptions select 0)*60;
            diag_log format ["##MissionInit: _box:%1 set to expire at %2",_box, _timer];
            while {time < _timer} do
            {
                sleep 30;
            };
            deleteVehicle _box;
        };
    };
}foreach _boxes;
// Remove all of the triggers. - completed in 'LogicBomb'
//Remove Structures
//if (_msnStatus != "NO TRIGGERS") then
//{
    if (_phaseID !=0 ) then
    {
        // this is not a root parent, so ensure evertyhing is preserved, as control is transfered to the parent mission.   
        _fragments = [_msnStatus, _buildingData, _buildings, _groups, _vehicles, _boxes];
       // diag_log format ["##MissionInit:%4: _phaseID:%1  _curMission:%2  _fragments:%3",_phaseID, _curMission, _fragments, _curMission];
       PhaseMsn set [ _phaseID, _fragments];
    }else
    {
        private ["_keep","_found"];
        _i = 0;
       // diag_log format ["## MissionInit : %2: Removing Buildings: %1",_buildings, _curMission];
        {
            private ["_keep"];
            _keep = _x select 3;
            if (_keep == 0) then
            {
              //  diag_log format ["## MissionInit: %2: deleting building :%1", _buildings select _i, _curMission];
                deleteVehicle (_buildings select _i);
                // store in HC variable.
                HC_HAL_Buildings = HC_HAL_Buildings - [(_buildings select _i)];
                HC_HAL_NumBuildings = HC_HAL_NumBuildings - 1;
            };
            _i = _i +1;
        } foreach _buildingData;        
        //Remove vehicles before Groups. Any vehicle occupied by AI will be removed!
       // diag_log format ["##MissionInit: Removing vehicles:%1",_vehicles];      
        //Flatten array...somehow getting arrays of arrays of objects, vs just a simple array of objects.
        //   need to flatten to permit clean deletion.
        {
            if (TypeName _x == "ARRAY") then
            {
                // do nothing for now. Not sure why vehicle array is becoming an array of arrays.
            }else
            {
                _keep = driver _x;
                if (! (isNull _keep) and !(isPlayer _keep) )then
                { 
                    HC_HAL_Vehicles = HC_HAL_Vehicles - [_x];
                    deleteVehicle _x;
                };
            };
        }foreach _vehicles;
        publicVariableServer "HC_HAL_Vehicles";        
        // Remove Groups
        {
            {
                deleteVehicle _x;
            } foreach units _x;
            deletegroup _x;
            HC_HAL_AIGroups = HC_HAL_AIGroups - [_x];
        }foreach _groups;
        publicVariableServer "HC_HAL_AIGroups";
    };
//};
_msnStatus
