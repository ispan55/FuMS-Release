//StaticMissionControlLoop.sqf
// Horbin
// 2/18/15
// Inputs: list of missions, themeindex to spawn them under.
private ["_listOfMissions","_themeIndex","_themeName"];
_listOfMissions = _this select 0;
_themeIndex = _this select 1;
_themeName = _this select 2;

// allocate and initialize data for each mission.
// create an index for each theme/mission:
// 4194304 probably high limit for index arrays....no problem!
{
    private ["_nextIndex","_themeData","_options"];
_nextIndex = count FuMS_LOOTDATA;//using LOOT array because master data stored at end of initialized themes, so next open slot is after it!
FuMS_THEMEDATA set [_nextIndex, FUMS_THEMEDATA select _themeIndex];
FuMS_LOOTDATA set [_nextIndex, FUMS_LOOTDATA select _themeIndex];
FuMS_SOLDIERDATA set [_nextIndex, FUMS_SOLDIERDATA select _themeIndex];
// modify this themes' options to '1'
_themeData = FuMS_THEMEDATA select _nextIndex;
_options = _themeData select 0;
_options set [1,1];
_themeData set [0, _options];
// modify this theme's mission list to be ONLY the single mission!
    _themeData set [1, [_x]];
FuMS_THEMEDATA set [_nextIndex, _themeData];
// step through process in FuMsnInit for each mission.
[_themeName, _nextIndex] execVM "HC\Encounters\ControlLoop.sqf";
					diag_log format ["****** STATIC ** STATIC ** STATIC ** STATIC ** STATIC  **************"];
					diag_log format ["*********************************************************************"];
                    diag_log format ["##StaticMissionControlLoop: FuMS control loops starting for %2/%1.", _x,_themeName];    
                    diag_log format ["********Static Mission Control Loop Initialized Index:%1 !           *********",_nextIndex];
                    diag_log format ["*********************************************************************"];
sleep 5;
}foreach _listOfMissions;

