//Init.sqf
// Horbin
// 2/26/15
// For FuMS Admin Controls menu system
GetUserData = compile preprocessFileLineNumbers "HC\Menus\GetUserData.sqf";

HasAdminAccess =
{
	private ["_enable","_pUID","_pData","_dataUID"];
	_enable = false;
	_pUID = getPlayerUID player;
	_pData = [] call GetUserData;
	if (!isNil "_pData") then
	{
		_dataUID = _pData select 1;
		if (_pUID == _dataUID) then {_enable=true;};
	};
    _enable
}; 


waituntil {!alive player ; !isnull (finddisplay 46)};
if ([] call HasAdminAccess) then
//if (true) then
{
    sleep 10;
	player addaction [("<t color=""#1376e5"">" + ("FuMS Admin") +"</t>"),"HC\Menus\AdminMenu.sqf","",5,false,true,"",""];    
    
    while {true} do 
    {
        waitUntil {!alive player};
        // uh oh...
        waitUntil {alive player};
        player addaction [("<t color=""#1376e5"">" + ("FuMS Admin") +"</t>"),"HC\Menus\AdminMenu.sqf","",5,false,true,"",""];    
    };        
};