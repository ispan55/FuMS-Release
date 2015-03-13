//LoadCommonData.sqf
// Horbin
// 2/28/15
// Inputs : None
// Loads FuMS core data
FuMS_BuildThemeMissionList = compile preprocessFileLineNumbers "\FuMS\Functions\BuildThemeMissionList.sqf"; 
private ["_themeNumber","_hold"];

diag_log format ["##FuMsnInit: Preparing FuMS common data."];
//BaseServer Init
_hold = [] execVM "\FuMS\Themes\BaseServer.sqf";
if (isNil "_hold") exitWith { diag_log format ["###FuMsnInit: ERROR in BaseServer.sqf format."];};
waitUntil { ScriptDone _hold};
_hold = [] execVM "\FuMS\Themes\BaseSoldier.sqf";
if (isNil "_hold") exitWith { diag_log format ["###FuMsnInit: ERROR in BaseLoot.sqf and/or BaseSoldier.sqf"];};
waitUntil { ScriptDone _hold};

FuMS_THEMEDATA = []; // Array containing data from \'themename'\ThemeData.sqf
FuMS_LOOTDATA = [];  // Array containing data from \'themename'\LootData.sqf
FuMS_SOLDIERDATA = []; // Array containing data from \'themename'\SoldierData.sqf    
FuMS_ListofMissions = []; // Array of ["Name", "string of preprocessed code"];
FuMS_ActiveThemesHC = []; // scalar value of what HC the theme should run on...
FuMS_ActiveThemes = [];

_themeListData = FuMS_ServerData select 3;
{
    FuMS_ActiveThemes pushback (_x select 0);// array of theme names. Used to locate the theme's mission folder.
    FuMS_ActiveThemesHC pushback (_x select 1);       
}foreach _themeListData;
diag_log format ["##LoadCommonData: ActiveThemes: %1",FuMS_ActiveThemes];
diag_log format ["##LoadCommonData: ActiveThemesHC: %1",FuMS_ActiveThemesHC];

FuMS_AIONLYVehicles = (FuMS_ServerData select 6) select 4;
FuMS_ActiveMissions = []; // [index, "mission:Theme"] combo. to track running missions.
// load the theme options, loot, and soldier configuration data for each Theme found in BaseServer.sqf
_themeNumber = 0;
{
    _hold = [_themeNumber] execVM format ["\FuMS\Themes\%1\ThemeData.sqf",_x];
    if (isNil "_hold") then { diag_log format ["###FuMsnInit: ERROR in %1\ThemeData.sqf format in theme #%1",_x];}
    else
    {
        waitUntil { scriptDone _hold}; 
        //diag_log format ["##FuMsnInit: ThemeData: %1 : %2",_x,FuMS_THEMEDATA select _themeNumber];
        if (!(((FuMS_THEMEDATA select _themeNumber) select 0) select 3) ) then //if theme using its own LootData
        {
            _hold = [_themeNumber] execVM format ["\FuMS\Themes\%1\LootData.sqf", _x];				
            if (isNil "_hold") then { diag_log format 
            ["###FuMsnInit: %1/ThemeData GlobalLootData 'true' and error in %1/LootData.sqf",_x];};
            waitUntil { scriptDone _hold};
           // diag_log format ["##FuMsnInit: LootData: %1 : %2",_x,FuMS_LOOTDATA select _themeNumber];
        };
        if (!(((FuMS_THEMEDATA select _themeNumber) select 0) select 4 )) then // if theme using its own soldierData
        {
            _hold = [_themeNumber] execVM format ["\FuMS\Themes\%1\SoldierData.sqf", _x];				
            if (isNil "_hold") then { diag_log format 
            ["###FuMsnInit: %1/ThemeData GlobalLootData 'true' and error in %1/SoldierData.sqf",_x];};
            waitUntil { scriptDone _hold};
         //   diag_log format ["##FuMsnInit: SoldierData: %1 : %2",_x,FuMS_SOLDIERDATA select _themeNumber];
        };
        
        [_themeNumber] call FuMS_BuildThemeMissionList; 
        {
            diag_log format ["##LoadCommonData: %1:%2",_themeNumber,_x];
        }foreach (FuMS_ListofMissions select _themeNumber);
        
      //  diag_log format ["##FuMsnInit: Theme %1 data parse complete.",_x];
      //  diag_log format ["-----------------------------------------------------------"];
    };
    _themeNumber = _themeNumber + 1;
}foreach FuMS_ActiveThemes;

if (_themeNumber == 0 ) exitWith { diag_log format ["FuMsnInit:  ERROR: NO Themes Found! Exiting!"];};

_hold = [_themeNumber] execVM format ["\FuMS\Themes\GlobalLootData.sqf"];
if (isNil "_hold") exitWith { diag_log format ["##FuMsnInit: ERROR in GlobalLootData.sqf: Exiting!"];};
waitUntil { scriptDone _hold};
//diag_log format ["##FuMsnInit: #setpos:%2 GlobalLootData: %1 ",FuMS_LOOTDATA select _themeNumber, _themeNumber];

_hold = [_themeNumber] execVM format ["\FuMS\Themes\GlobalSoldierData.sqf"];
if (isNil "_hold") exitWith { diag_log format ["##FuMsnInit: ERROR in GlobalSoldierData.sqf: Exiting!"];};
waitUntil { scriptDone _hold};
//diag_log format ["##FuMsnInit: #setpos:%2 GlobalSoldierData: %1",FuMS_SOLDIERDATA select _themeNumber, _themeNumber];

FuMS_GlobalDataIndex = _themeNumber;	
FuMS_FPSMinimum = (FuMS_ServerData select 0 ) select 3;
FuMS_FPSVariance = .3; // max 30% fps drop acceptable



_hold = []execVM "\FuMS\Themes\AdminData.sqf";
waitUntil {ScriptDone _hold};
//diag_log format ["##FuMsnInit: AdminData:%1", FuMS_Users];
//publicVariable "FuMS_Users";
//publicVariable "FuMS_ActiveMissions";

