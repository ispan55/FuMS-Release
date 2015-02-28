//AdminMenu.sqf
// Horbin
// 2/25/15
GetUserData = compile preprocessFileLineNumbers "HC\Menus\GetUserData.sqf";
ToggleTheme = compile preprocessFileLineNumbers "HC\Menus\ToggleTheme.sqf";
KillMission = compile preprocessFileLineNumbers "HC\Menus\KillMission.sqf";
//SetAnchor = compile preprocessFileLineNumbers "HC\Menus\SetAnchor.sqf";
//SpawnMission = compile preprocessFileLineNumbers "HC\Menus\SpawnMission.sqf";
 //if ((getPlayerUID player) in ["76561197997766935","76561198125257185"]) then { // <-- Insert your UIDs here!   
 
if (true) then
{ 
    private ["_pData","_adminLevel","_options"];
	// only show placement option if the cursor is on the ground, but not pointing at a unit or vehicle.
	//_placementCondition = "CursorOnGround * 1-CursorOnGroupMemeber * 1-CursorOnEmptyVehicle";
		FuMS_AdminToggleThemeMenu = call ToggleTheme;
		FuMS_AdminKillMissionMenu = call KillMission;
		//FuMS_AdminSetAnchorMenu = call SetAnchor;
		//FuMS_AdminSpawnMissionMenu = call SpawnMission;
		
		//FuMS_AdminAnchorLocation global set by SetAnchor!
		_pData = [] call GetUserData;
		_adminLevel = _pData select 2;
    //_adminLevel = 1;
		_options = _pData select 3;
		
    FuMS_AdminToolsMenu =[["FuMS Admin",true]];
		
		if (_adminLevel == 1 or _adminLevel == 2) then
		{		
            FuMS_AdminToolsMenu = FuMS_AdminToolsMenu + [["Toggle Theme", [2],"#USER:FuMS_AdminToggleThemeMenu", -5, [["expression", ""]], "1","1"]];
		};
		if (_adminLevel == 1 ) then
		{
            FuMS_AdminToolsMenu = FuMS_AdminToolsMenu + [["Kill Mission", [3],"#USER:FuMS_AdminKillMissionMenu", -5, [["expression", ""]], "1", "1"]];
		};
		if (_adminLevel == 1) then
		{
            FuMS_AdminToolsMenu = FuMS_AdminToolsMenu + [["Set Anchor", [4], "#USER:FuMS_AdminSetAnchorMenu", -5, [["expression", ""]], "1", "1"]];
		};
		if (_adminLevel == 1) then
		{
            FuMS_AdminToolsMenu = FuMS_AdminToolsMenu + [["Spawn Mission", [5],"#USER:FuMS_AdminSpawnMissionMenu", -5, [["expression", ""]], "1", "1"]];
		};
        FuMS_AdminToolsMenu = FuMS_AdminToolsMenu + [["", [-1], "", -5, [["expression", ""]], "1", "0"]];
        FuMS_AdminToolsMenu = FuMS_AdminToolsMenu + [["EXIT", [13], "", -3, [["expression", ""]], "1", "1"]];	
        showCommandingMenu "#USER:FuMS_AdminToolsMenu";
};



