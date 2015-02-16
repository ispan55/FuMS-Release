//AttachMuzzle.sqf
// Horbin
// 1/11/2015
// Input: "weapon name"
// Output: "suppressor" appropriate for the input weapon's caliber and type.
private ["_priweapon","_suppressor","_gunList","_result"];
_priweapon = _this select 0;
//diag_log format ["##AttachMuzzle: Adding suppressor to %1",_priweapon];
_result = "None";
{ 
    _suppressor = _x select 0;
    _gunList = _x select 1;    
   // diag_log format ["##AttachMuzzle:%2:  #:%3 _gunList:%1",_gunList,_suppressor, count _gunList];
    {
       // diag_log format ["##AttachMuzzle:Comparing:  _x:%1  and %2",_x, _priweapon];
        if ( _priweapon == _x) then
      {
          //diag_log format ["##AttachMuzzle: Adding suppressor %1 to %2",_suppressor, _priweapon];
          _result = _suppressor;        
      };
  }foreach _gunList;         
}foreach Muzzles;
_result
