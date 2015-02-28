//FuMSInit_Server.sqf
// Horbin
// 2/7/15
// Inputs: HC PLAYER owner ID
private ["_hc","_themeNumber","_hold"];
_hc = _this select 0;

//if (isNil "FuMS_THEMEDATA") then // if already defined, then HC is reconnecting. Do not need to read in data from file!
//{ 
    diag_log format ["##FuMsnInit: Preparing data for Headless Client :%1",_hc];
	//BaseServer Init
	_hold = [_hc] execVM "\FuMS\Themes\BaseServer.sqf";
	if (isNil "_hold") exitWith { diag_log format ["###FuMsnInit: ERROR in BaseServer.sqf format."];};
	waitUntil { ScriptDone _hold};
	//BaseLoot Init #included into BaseSoldier.
	//BaseSoldier Init
	_hold = [_hc] execVM "\FuMS\Themes\BaseSoldier.sqf";
	if (isNil "_hold") exitWith { diag_log format ["###FuMsnInit: ERROR in BaseLoot.sqf and/or BaseSoldier.sqf"];};
	waitUntil { ScriptDone _hold};
    //FuMS_ServerData, and Custom global variables initialized and passed to HC at this point.
    diag_log format ["##FuMsnInit: ServerData : %1", FuMS_ServerData];
	diag_log format ["##FuMsnInit: ServerData and BaseData files parsed."];
	diag_log format ["-----------------------------------------------------------"];
	FuMS_THEMEDATA = []; // Array containing data from \'themename'\ThemeData.sqf
    FuMS_LOOTDATA = [];  // Array containing data from \'themename'\LootData.sqf
    FuMS_SOLDIERDATA = []; // Array containing data from \'themename'\SoldierData.sqf    

	FuMS_ActiveThemes = FuMS_ServerData select 3;// array of theme names. Used to locate the theme's mission folder.
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
			diag_log format ["##FuMsnInit: ThemeData: %1 : %2",_x,FuMS_THEMEDATA select _themeNumber];
            if (!(((FuMS_THEMEDATA select _themeNumber) select 0) select 3) ) then //if theme using its own LootData
			{
				_hold = [_themeNumber] execVM format ["\FuMS\Themes\%1\LootData.sqf", _x];				
				if (isNil "_hold") then { diag_log format 
				["###FuMsnInit: %1/ThemeData GlobalLootData 'true' and error in %1/LootData.sqf",_x];};
				waitUntil { scriptDone _hold};
				diag_log format ["##FuMsnInit: LootData: %1 : %2",_x,FuMS_LOOTDATA select _themeNumber];
			};
            if (!(((FuMS_THEMEDATA select _themeNumber) select 0) select 4 )) then // if theme using its own soldierData
			{
				_hold = [_themeNumber] execVM format ["\FuMS\Themes\%1\SoldierData.sqf", _x];				
				if (isNil "_hold") then { diag_log format 
				["###FuMsnInit: %1/ThemeData GlobalLootData 'true' and error in %1/SoldierData.sqf",_x];};
				waitUntil { scriptDone _hold};
				diag_log format ["##FuMsnInit: SoldierData: %1 : %2",_x,FuMS_SOLDIERDATA select _themeNumber];
			};
            diag_log format ["##FuMsnInit: Theme %1 data parse complete.",_x];
            diag_log format ["-----------------------------------------------------------"];
		};
        _themeNumber = _themeNumber + 1;
    }foreach FuMS_ActiveThemes;
	
	if (_themeNumber == 0 ) exitWith { diag_log format ["FuMsnInit:  ERROR: NO Themes Found! Exiting!"];};
	
	_hold = [_themeNumber] execVM format ["\FuMS\Themes\GlobalLootData.sqf"];
    if (isNil "_hold") exitWith { diag_log format ["##FuMsnInit: ERROR in GlobalLootData.sqf: Exiting!"];};
	waitUntil { scriptDone _hold};
	diag_log format ["##FuMsnInit: #setpos:%2 GlobalLootData: %1 ",FuMS_LOOTDATA select _themeNumber, _themeNumber];
	
    _hold = [_themeNumber] execVM format ["\FuMS\Themes\GlobalSoldierData.sqf"];
    if (isNil "_hold") exitWith { diag_log format ["##FuMsnInit: ERROR in GlobalSoldierData.sqf: Exiting!"];};
	waitUntil { scriptDone _hold};
	diag_log format ["##FuMsnInit: #setpos:%2 GlobalSoldierData: %1",FuMS_SOLDIERDATA select _themeNumber, _themeNumber];

	FuMS_GlobalDataIndex = _themeNumber;	
//};

diag_log format ["##FuMsnInit: Global variables being handed off too HC id:%1",_hc];
_hc publicVariableClient "FuMS_ActiveThemes";	
sleep 2;
_hc publicVariableClient "FuMS_THEMEDATA";
sleep 2;
_hc publicVariableClient "FuMS_LOOTDATA";
sleep 2;
_hc publicVariableClient "FuMS_SOLDIERDATA";
sleep 2;
_hc publicVariableClient "FuMS_GlobalDataIndex";

_hold = []execVM "\FuMS\Themes\AdminData.sqf";
waitUntil {ScriptDone _hold};
//diag_log format ["##FuMsnInit: AdminData:%1", FuMS_Users];
publicVariable "FuMS_Users";
publicVariable "FuMS_ActiveMissions";


FuMS_ServerInitData = true;
publicVariable "FuMS_ServerInitData";	
diag_log format ["##FuMsnInit: Global data hand off to Headless Client complete."];

