//GetUserData.sqf
// Horbin
// 2/26/15
// Output: data associated with 'player', 'nil' if no match for GUID found
private ["_data","_pUID","_dataUID"];
waitUntil
{
    if (isNil "FuMS_Users") then { diag_log format ["##GetUserData: FuMS_Users still 'nil"]; sleep 5;}
    else { diag_log format ["##GetUserData: FuMS_Users:%1",FuMS_Users];};    
    (!isNil "FuMS_Users")
};
_data = [];
{
	_pUID = getPlayerUID player;
	_dataUID = _x select 1;
	if (_pUID == _dataUID) exitWith {_data = _x};
}foreach FuMS_Users;
_data
