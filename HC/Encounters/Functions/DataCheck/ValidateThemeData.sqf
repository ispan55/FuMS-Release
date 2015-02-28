//ValidateTheme.sqf
// Horbin
// 2/22/15
// Inputs ThemeData array
// OUTPUTS true or false
VerifyTheme = compile preprocessFileLineNumbers "HC\Encounters\Functions\DataCheck\VerifyTheme.sqf";

private ["_abort","_msg","_critical","_file","_i","_theme","_start","_themeList"];
_abort = false;
_critical = false;
_msg = "";
_file = "";
_start = time;
// FuMS_ActiveThemes contains list of activated themes as defined in BaseDataServer.sqf.
while {true} do
{
	_file = "\FuMS\Themes\BaseServerData.sqf";
	if (isNil "FuMS_THEMEDATA") exitWith {_abort = true;_critical=true; _msg = format ["No ThemeData passed to Headless Client"];}; 
    if (TypeName FuMS_THEMEDATA != "ARRAY") exitWith {_abort = true;_critical=true; _msg = format ["No ThemeData defined by Server"];};
	if (count FuMS_THEMEDATA == 0) exitWith {_abort = true;_critical=true; _msg = format ["No ThemeData defined by Server"];};
    
    _themeList = FuMS_ServerData select 3;
    if (isNil "_themeList")exitWith {_abort = true;_critical=true; _msg = format ["No Themes defined in BaseServerData.sqf"];};
    if (TypeName _themeList != "ARRAY") exitWith {_abort = true;_critical=true; _msg = format ["No ThemeData defined by Server"];};
    
    for [{_i=0},{_i < count _themeList},{_i=_i+1}] do
	{	
        private ["_status"];
		_theme = _themeList select _i;
		_file = format ["\FuMS\Themes\%1\ThemeData.sqf",_theme];
		_status = [_i] call VerifyTheme;
        _abort = _status select 0;
        _msg = _status select 1;
        if (_abort) then
        {
            diag_log format ["-------------------------------------------------------------------------------------"];
            diag_log format ["----------------            Fulcrum Mission System                    -----------------"];
            diag_log format ["-------------------------------------------------------------------------------------"];
            diag_log format ["##ValidateThemeData: ERROR in FuMS_THEMEDATA"];
            diag_log format ["Recommend verifying data in file %1 on your server!",_file];                
            diag_log format ["                          Theme %1 offline!", _theme];
            diag_log format ["REASON: %1",_msg];
            diag_log format ["-------------------------------------------------------------------------------------"];
            diag_log format ["-------------------------------------------------------------------------------------"];      
           // FuMS_THEMEDATA = FuMS_THEMEDATA - [FuMS_THEMEDATA select _i];
            //FuMS_LOOTDATA = FuMS_LOOTDATA - [FuMS_LOOTDATA select _i];
          //  FuMS_SOLDIERDATA = FuMS_SOLDIERDATA - [FuMS_SOLDIERDATA select _i];
            FuMS_ActiveThemes = FuMS_ActiveThemes - [_theme];    
            
            FuMS_DataValidation = format[ "%1",_file];
            publicVariableServer "FuMS_DataValidation";                                              
        };        
    };      
    if (true) exitWith{};
};
if (_critical) then
{
    diag_log format ["-------------------------------------------------------------------------------------"];
    diag_log format ["----------------            Fulcrum Mission System                    -----------------"];
    diag_log format ["-------------------------------------------------------------------------------------"];
    diag_log format ["##ValidateThemeData: ERROR in FuMS_THEMEDATA"];
    diag_log format ["Recommend verifying data in file %1 on your server!",_file];  
    diag_log format ["             	    CRITICAL ERROR: FuMS OFFLINE! "];
    diag_log format ["REASON: %1",_msg];
    diag_log format ["-------------------------------------------------------------------------------------"];
    diag_log format ["-------------------------------------------------------------------------------------"];      
    FuMS_DataValidation = format ["%1",_file];
    publicVariableServer "FuMS_DataValidation";
}else { diag_log format ["------ Theme Data validation complete. %1secs----",time -_start];_abort=false;};
_abort
