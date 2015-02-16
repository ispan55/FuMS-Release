//FuMSInit_Server.sqf
// Horbin
// 2/7/15
// Inputs: HC PLAYER owner ID
private ["_hc","_handle","_themeNumber"];
_hc = _this select 0;

//BaseServer Init
_handle = [_hc] execVM "\FuMS\Themes\BaseServer.sqf";
waitUntil { ScriptDone _handle};

//BaseLoot Init #included into BaseSoldier.

//BaseSoldier Init
_handle = [_hc] execVM "\FuMS\Themes\BaseSoldier.sqf";
waitUntil { ScriptDone _handle};



THEMEDATA = []; // Array containing data from \'themename'\ThemeData.sqf
LOOTDATA = [];  // Array containing data from \'themename'\LootData.sqf
SOLDIERDATA = []; // Array containing data from \'themename'\SoldierData.sqf    

ActiveThemes = ServerData select 3;// array of theme names. Used to locate the theme's mission folder.
   // load the theme options, loot, and soldier configuration data for each Theme found in BaseServer.sqf
    _themeNumber = 0;
    {
        private ["_hold"];  // to ensure variables read in before continuing!
        _hold = [_themeNumber] execVM format ["\FuMS\Themes\%1\ThemeData.sqf",_x];
        waitUntil { scriptDone _hold};
        _hold = [_themeNumber] execVM format ["\FuMS\Themes\%1\LootData.sqf", _x];
        waitUntil { scriptDone _hold};
        _hold = [_themeNumber] execVM format ["\FuMS\Themes\%1\SoldierData.sqf", _x];
        waitUntil { scriptDone _hold};
        _themeNumber = _themeNumber + 1;
    }foreach ActiveThemes;

_hc publicVariableClient "THEMEDATA";
_hc publicVariableClient "LOOTDATA";
_hc publicVariableClient "SOLDIERDATA";

ServerFuMsnInitData = true;
publicVariable "ServerFuMsnInitData";	

// can probably clean up these variables since the server does not need them now!
ServerData = [];
THEMEDATA = [];
LOOTDATA = [];
SOLDIERDATA = [];
