//HC_CreateVehicle.sqf
// Horbin
// 1/29/15
// INPUTS: Type, position, markers, distance, mode <-- same params as createVehicle
//   Sends call to server to fully initialize vehicle.
//OUTPUTS: vehicle created.

private  ["_type","_pos","_markers","_dist","_mode","_veh"];
_type = _this select 0;
_pos = _this select 1;
_markers = _this select 2;
_dist = _this select 3;
_mode = _this select 4;

_veh = createVehicle [_type, _pos, _markers, _dist, _mode];
 
//initialize everything that is needed on the server side!
BuildVehicle_HC = _veh;
publicVariableServer "BuildVehicle_HC";
   
  HC_HAL_Vehicles = HC_HAL_Vehicles + [_veh];
  publicVariableServer "HC_HAL_Vehicles";
    
  _veh addEventHandler ["HandleDamage",
    {
        _vehobj = _this select 0;
        _location = _this select 1;  // type string
        _damage = _this select 2;   // type number
        _sourceobj = _this select 3;
        _projectile = _this select 4; // type string
        //ASSERT this EH only active when vehicle owned by AI.
       if ( isNull _sourceobj) then
       {
            _damage = 0;
        };
        _damage       
    }];
_veh