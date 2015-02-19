//SpawnSoldier.sqf
// Horbin
// 1/11/15
// Inputs: Group, typeSoldier, position, Theme Index
// Outputs: Unit created.
// Input Data format expected:
// 0:"Type", 1:[ 8 numbers], 2:Uniform, 3:Vest, 4:Helmet, 5:Backpack, 6;Rifle, 7:[3 numbers], 
// 8: Pistol,9: [5 numbers beltItems], 10:[3numbers visionItems], 11:[2 Flags],12:[ array of items]
AddIt = compile preprocessFileLineNumbers "HC\Encounters\Functions\AddIt.sqf";
GetChoice = compile preprocessFileLineNumbers "HC\Encounters\LogicBomb\GetChoice.sqf";
AttachMuzzle = compile preprocessFileLineNumbers "HC\Encounters\AI_Logic\AttachMuzzle.sqf";
private ["_group","_type","_pos","_themeIndex","_unit","_typeFound","_aiName","_gear","_flags","_skills","_types","_i","_priweapon","_soldierData","_secweapon",
"_radio", "_numPistolMags","_numRifleMags"];
_group = _this select 0;
_type = _this select 1;
_pos = _this select 2;
_themeIndex = _this select 3;

if (((FuMS_THEMEDATA select _themeIndex) select 0) select 4) then
{
   _soldierData = FuMS_SOLDIERDATA select FuMS_GlobalDataIndex;   
}else
{
   _soldierData = FuMS_SOLDIERDATA select _themeIndex;      
};
if (isNil "_soldierData") exitWith
{
    diag_log format ["SpawnSoldier: ERROR: no theme specific SoldierData.sqf for theme #%1",_themeIndex];
    diag_log format ["Check options in ThemeData.sqf for theme %1",((FuMS_THEMEDATA select _themeIndex) select 0) select 0];
};
_numRifleMags = FuMS_SoldierDefaults select 0;
_numPistolMags = FuMS_SoldierDefaults select 1;

//diag_log format ["##SpawnSoldier: Index:%2 _soldierData:%1",_soldierData,_themeIndex];
_typeFound = false;
// locate the data for 'type' soldier.
{
    _aiName = _x select 0;  // type name
    if (_type == _aiName) then
    {
        _typeFound = true;
 //       diag_log format ["##SpawnSoldier: Found:%1",_x];
        // Basic AI creation
        _unit = _group createUnit["I_Soldier_EPOCH", _pos, [], 25, "FORM"];
        // NOTE if I_Soldier_EPOCH type is changed, AllDeadorGone.sqf will need to be modified
        removeUniform _unit;
        removeHeadgear _unit;
        removeAllWeapons _unit;
        _unit removeweapon "ItemWatch";
        _unit removeweapon "EpochRadio0";
        _unit removeweapon "ItemCompass";
        _unit removeweapon "ItemMap";  
        // Destroys gear for AI killed by AI and handle other stuff
        // ONLY NEEDS TO RUN ON HeadlessClient!
        // If a port to server only occurs, this will possibly need to be modified to MP to support server notifications.
        _unit addEventHandler ["killed",{[(_this select 0), (_this select 1)] ExecVM "HC\Encounters\AI_Logic\AI_Killed.sqf";}];
        _gear = [_x select 2] call GetChoice;if (_gear != "") then {_unit forceAddUniform _gear;};
        _gear = [_x select 3] call GetChoice;if (_gear != "") then {_unit addVest _gear;};
        _gear = [_x select 4] call GetChoice;if (_gear != "") then {_unit addHeadgear _gear;};
        _gear = [_x select 5] call GetChoice;if (_gear != "") then {_unit addBackpack _gear;};
        // Rifle
        _gear = [_x select 6] call GetChoice;
        //diag_log format ["##SpawnSoldier: Rifle-gear:%1",_gear];
        _priweapon = "";
        if (TypeName _gear =="ARRAY") then
        {
            _priweapon = _gear select 0;
            _unit addWeapon _priweapon;
            _unit addMagazine [(_gear select 1),_numRifleMags];
        }else
        {
            if (_gear != "") then
            {
                _priweapon= _gear;
                _unit addWeapon _priweapon;
            };
        };   
       // diag_log format ["##SpawnSoldier: Rifle added:%1",_priweapon];
        //Pistol
        _secweapon = "";
        _gear = [_x select 8] call GetChoice;
    //    diag_log format ["##SpawnSoldier: Pistol-gear:%1",_gear];
        if (TypeName _gear =="ARRAY") then
        {
            _secweapon = _gear select 0;
            _unit addWeapon _secweapon;
            _unit addMagazine [(_gear select 1),_numPistolMags];
        }else
        {
            if (_gear != "") then
            {
                _secweapon= _gear;
                _unit addWeapon _secweapon;
            };
        };   
        // Rifle Attachments
        _gear = _x select 7;
        if ([_gear select 0] call AddIt) then{ _unit addPrimaryWeaponItem (WeaponAttachments_Optics call BIS_fnc_selectRandom);};  //scopes
        if ([_gear select 1] call AddIt) then
        { 
            _muzzle = [_priweapon] call AttachMuzzle;
            if (_muzzle != "None") then
            {
              //  diag_log format ["##SpawnSolder: Adding %1",_muzzle];
                _unit addPrimaryWeaponItem _muzzle;
            };
        };  //muzzle
        if ([_gear select 2] call AddIt) then { _unit addPrimaryWeaponItem "acc_flashlight"};  //flashlight       
        // Belt Items
        _gear = _x select 9;
        if ([_gear select 0] call AddIt) then {_unit addweapon "ItemMap";};  //Map.
        if ([_gear select 1] call AddIt) then {_unit addweapon "ItemCompass";};  //Compass
        if ([_gear select 3] call AddIt) then {_unit addweapon "ItemGPS";};  //GPS
        if ([_gear select 4] call AddIt) then {_unit addweapon "ItemWatch";};  //Watch
        if ((_gear select 5) > 0 ) then
        {
            _radio = format ["EpochRadio%1",(_gear select 5)];
            _unit addweapon _radio;
        };  //Radio
        // Vision items
        _gear = _x select 10;
         if ([_gear select 0] call AddIt) then {_unit addweapon "Binocular";};  //Binoculars
        if ([_gear select 1] call AddIt) then {_unit addweapon "Rangefinder";};  //RangeFinders
        if ([_gear select 2] call AddIt) then {_unit addweapon "NVG_EPOCH"};  //NVGs
        // Other Equipment       
        _gear = _x select 12;
    //    diag_log format ["##SpawnSoldier: Other Equipment:%1",_gear];
        {  
            private ["_item","_variance","_min","_numitems"];
         //   diag_log format ["##SpawnSoldier: Attempting to add %1", _x];
            _item = [_x select 0] call GetChoice;
            if (_item != "") then 
            {
                _variance = _x select 1;
                _min = _variance select 0;
                _numItems = _min + floor (random ( (_variance select 1)-_min) );
             //   diag_log format ["##SpawnSoldier: Adding %1 %2",_numItems, _item];
                _unit addMagazines [ _item, _numItems];
            };
        }foreach _gear;
        // Flags
        _flags = _x select 11;
        // in water, so give them scuba gear!
        if (_flags select 0) then{if (surfaceIsWater _pos) then{_unit forceAddUniform "U_B_Wetsuit" ;_unit addVest "V_19_EPOCH";};};
        // give them unlimited ammo!
        if (_flags select 1) then{_unit addeventhandler ["fired", {(_this select 0) setvehicleammo 1;}];};
        // give them some RPG's!
        _rpg = _flags select 2;
        if (!isNil "_rpg") then
        {
            if (_rpg) then
            {
                _unit addMagazines ["RPG32_HE_F", 1];
                _unit addMagazines ["RPG32_F", 1];
                _unit addWeapon "launch_RPG32_F";
            };
        };
        
        // Set skills
        _skills = _x select 1;
        _types = ["aimingAccuracy","aimingShake","aimingSpeed","spotDistance","spotTime","courage","reloadSpeed","commanding"];
        for [ {_i=0},{_i<8},{_i=_i+1}] do { _unit setSkill [ (_types select _i), (_skills select _i)];};
    };   
}foreach _soldierData;
if (!_typeFound) then
{
    diag_log format ["*******************************************************"];
    diag_log format ["******SpawnSoldier: %1 not found in Theme index %2's SoldierData.sqf",_type, _themeIndex];
    diag_log format ["*******************************************************"];
};
_unit