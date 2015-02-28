//ServerInit.sqf
// Horbin
// 2/7/15
// Executed by server to initialize support functions for headless client

if (!isServer) exitWith {};



StaticMissionControlLoopCode = preprocessFileLineNumbers "\FuMS\HC\LogicBomb\StaticMissionControlLoop.sqf";
//Launch HC cleanup process.
// This script watches for an HC disconnect
// When identified, server will cleanup objects that where controlled by the HC
// Use included HC_CreateGroup, HC_CreateVehicle, etc functions on the HC to ensure cleanup!
[] spawn
{
    private ["_value"];
    diag_log format ["##Server-HC isAlive heart beat operational"];
    while {true} do
    {
		// Wait for signal for HC connecting.
		// initialize the HC
		// start its heartbeat monitor
		// need to get ownerid to use as an index ref to all the variables to be cleaned up.
		// these vars will need to be initialzed where HC ID is established.
		
        //****start of control code <copy&paste> start here.
        if (! isNil "HC_HAL_isDirty") then //  HC_HAL has completed initialization, at least once during server instance.
        {
            if (HC_HAL_isDirty=="TRUE") then //HC has defined global objects.
            { 
			    // HC is connected: Need to determine if it has been initialized yet!
				if (!HC_HAL_Initialized) then
                {
                    private ["_handle"];
                    HCHAL_ID = owner HC_HAL_Player;
                    _handle = [HCHAL_ID ] execVM "\FuMS\Functions\FuMsnInit_Server.sqf";
                    // loads HC server level variables.
                    waitUntil {ScriptDone _handle};
                    HC_HAL_Initialized = true;
                    FuMS_ServerInitData = true;
                    HCHAL_ID publicVariableClient "FuMS_ServerInitData";
                    HCHAL_ID publicVariableClient "StaticMissionControlLoopCode";
                };
                // HC_HAL_CLEANUP set to false by the HC when it connects and after waiting for it to be set TRUE by this routine.
                // since the HC is dirty, now need to listen for its heartbeat.
                // HC when 'reconnecting', will wait until isDirty set to false by this routine before starting its heartbeats.
                //diag_log format ["##SERVER:HC_HAL: Variable Cleanup Required!, Listening for heartbeats"]; 
                HC_HAL_isAlive = "FALSE";
                uiSleep 2;
                //Wait for 2secs, if value still FALSE, listen for a 2nd heartbeat.  
                if (HC_HAL_isAlive == "FALSE") then // listening for 2nd heart beat
                {
                    diag_log format ["##SERVER:HC_HAL: 1st Heart beat missed!!"];    
                    uiSleep 2;
                    //Wait 2secs, if value still FALSE, listen for a 3rd heart beat.
                    if (HC_HAL_isAlive == "FALSE") then //listening for the 3rd heart beat.
                    {
                        diag_log format ["##SERVER:HC_HAL: 2nd Heart beat missed!!"];       
                        uiSleep 2;                             
                        if (HC_HAL_isAlive == "FALSE" ) then // HC_HAL is confirmed disconnected.                            
                        {
                            diag_log format ["##SERVER:HC_HAL: Disconnect detected. Cleaning up the Mess!!!!"];  
                            // Cleanup AI Groups
                            {
                                diag_log format ["HC_HAL:CLEANUP Groups: %1 deleted",_x];
                                { deleteVehicle _x } forEach units _x;
                                deleteGroup _x;
                                _x = nil;
                            } forEach HC_HAL_AIGroups;
                            // Vehicles and Containers
                            diag_log format ["HC_HAL:CLEANUP: %1 vehicles to be checked!",count HC_HAL_Vehicles];
                            { 
                                if (TypeName _x == "ARRAY") then
                                {
                                    diag_log format ["##ServerInit: error in HC_HAL_Vehicles: found %1",_x];
                                }else
                                {
                                    _value = _x getVariable "HCTEMP";
                                    diag_log format ["HC_HAL:CLEANUP: %1 being checked.",_x];
                                    if (!(isNil "_value")) then  // if _value 'isNil' then somehow calling on a vehicle not created by the HC!
                                    {
                                        if (_value != "AI") then
                                        {
                                            diag_log format ["HC_HAL:CLEANUP: %1 is no longer AI controlled: %2",_x, _value];           
                                        }else
                                        {
                                            diag_log format ["HC_HAL:CLEANUP: %1 deleted",_x];
                                            deleteVehicle _x;   
                                            _x = nil;
                                        };
                                    };
                                };
                            } forEach HC_HAL_Vehicles;
                            // Markers
                            { 
                                diag_log format ["HC_HAL:CLEANUP Markers: %1 deleted",_x];
                                _x setMarkerAlpha 0; 
                                publicVariable _x; 
                                deleteMarker _x;
                                _x = nil;
                            } forEach HC_HAL_Markers;
                            
                            
                            // Buildings
                            diag_log format ["HC_HAL:CLEANUP: %1 buildings to be deleted!",HC_HAL_NumBuildings];
                            {
                                diag_log format ["HC_HAL:CLEANUP Buildings: %1 deleted", _x];
                                if ( TypeName _x == "ARRAY") then
                                {
                                    {
                                        deleteVehicle _x;
                                    }foreach _x;
                                } else
                                {
                                    deleteVehicle _x;
                                };
                            }foreach HC_HAL_Buildings;
                            HC_HAL_NumBuildings = 0;                                                     
                            // Triggers.
                            {
                                diag_log format ["HC_HAL:CLEANUP Triggers: %1 deleted", _x];  
                                if ( TypeName _x == "ARRAY") then
                                {
                                    {
                                        deleteVehicle _x;
                                    }foreach _x;
                                } else
                                {
                                    deleteVehicle _x;
                                };                      
                            } forEach HC_HAL_Triggers;
                            // cleanup done. Announce globally so when HC reconnects it knows not to wait.
                            HC_HAL_isDirty = "FALSE";
                            publicVariable "HC_HAL_isDirty";      
                            diag_log format ["HC_HAL:CLEANUP: Complete!"];           
                        };
                        // End of cleanup
                    };
                    // End of 3rd heartbeat
                };
                // End of 2nd heartbeat
            };
            //End of isDirty check and 1st heartbeat
        };
        // End of HC_HAL excists
        // <copy&paste end here. Paste below to add another HC.
    };
    // End of Listen Loop
};

"FuMS_RegisterVehicle" addPublicVariableEventHandler
{
// for use by non-FuMS addons to register vehicles to keep them from going poof.
	_vehObj = _this select 1;
	_vehObj call EPOCH_server_setVToken;
};

"FuMS_DataValidation" addPublicVariableEventHandler
{
	_msg = _this select 1;
    diag_log format ["-------------------------------------------------------------------------------------"];
    diag_log format ["----------------            Fulcrum Mission System                    -----------------"];
    diag_log format ["-------------------------------------------------------------------------------------"];   
    diag_log format [" Potential fatal errors in FuMS initialization or mission execution.     "];
    diag_log format ["   check your Headless Client's .rpt for specifics!"];
    diag_log format ["Offending File: %1",_msg];
    diag_log format ["-------------------------------------------------------------------------------------"];
    diag_log format ["-------------------------------------------------------------------------------------"];      
};

"BuildVehicle_HC" addPublicVariableEventHandler
{
    //        diag_log format ["##HC_HAL: BuildVehicle_HAL fired!"];   
  _vehObj = _this select 1;

    _vehObj setVariable ["HCTEMP", "AI", true]; // HCTEMP set to "PLAYER" once a player enters.

  //  _vehObj=createVehicle[_item,_position,[],0,"NONE"];
    _vehObj call EPOCH_server_setVToken;
	
    addToRemainsCollector[_vehObj];
    _vehObj disableTIEquipment true;
    clearWeaponCargoGlobal    _vehObj;
    clearMagazineCargoGlobal  _vehObj;
    clearBackpackCargoGlobal  _vehObj;
    clearItemCargoGlobal	  _vehObj;   
        
    _vehObj addEventHandler ["GetIn",
    {
        _vehobj = _this select 0;
        _vehseat = _this select 1;
        _owner = _this select 2;
        _idowner = owner _owner;
        _vehactual = vehicle _vehobj;
        // If it is ID:0, the server, or the HC controlling AI, then no changes required.
        // HC_HAL_ID is a null object after a disconnect or if it is NOT the 1st thing to connect after a reboot...        
        _hcID =HCHAL_ID;
       // diag_log format ["###EH:GetIn: HC_HAL_Player: %1, _hcID: %2, _owner: %4, _idowner: %3",HC_HAL_Player, _hcID, _idowner, _owner];
        // Any one of the below checks implies _veh owned by AI, not a player.
        if ( (!isPlayer _owner) ) then
        // if (  (_idowner == 0) or (_idowner == _hcID) or (!isPlayer _owner)  ) then
        {
           // diag_log format ["###EH:GetIn:AI DETECTED: %1 ID entered a vehicle: %2",_idowner,_vehobj];
        }else
        {
			_typeveh = typeOf _vehobj;
			_abort = false;
			{
				if (_typeveh == _x) exitWith
				{
					FuMS_AIONLYVEHICLE = true;
					_idowner publicVariableClient "FuMS_AIONLYVEHICLE";
					_owner action ["getOut", _vehobj];
					_abort = true;
				};
			}foreach FuMS_AIONLYVehicles;
			if (_abort) exitWith {};
		
            //diag_log format ["###EH:GetIn: %1 with ID:%4 entering %2 on %3",_owner, _vehseat, _vehactual, _idowner];
            FuMS_TEMPVEHICLE = true;
            _idowner publicVariableClient "FuMS_TEMPVEHICLE";
            // If a player enters the vehicle, update the HCTEMP, so server will not delete vehicle on  an HC disconnect!
            _value = _vehobj getVariable "HCTEMP";
			if (_value != "PLAYER" and (FuMS_GlobalLootOptions select 2) ) then // make vehicle purchasable, and save it to the Hive!
			{
				// Possibly needed to keep from breaking normal vehicle limits?    
				EPOCH_VehicleSlotsLimit = EPOCH_VehicleSlotsLimit + 1;
				EPOCH_VehicleSlots pushBack str(EPOCH_VehicleSlotsLimit);
				// Code below is used when a vehicle is 'purchased' off a vendor!
				_slot=EPOCH_VehicleSlots select 0;
				EPOCH_VehicleSlots=EPOCH_VehicleSlots-[_slot];
				EPOCH_VehicleSlotCount=count EPOCH_VehicleSlots;
				publicVariable "EPOCH_VehicleSlotCount";
				 _vehObj setVariable["VEHICLE_SLOT",_slot,true];
				_vehObj call EPOCH_server_save_vehicle;
				//_vehObj call EPOCH_server_vehicleInit;
			};
            //diag_log format ["###EH:GetIn: HCTEMP = %1", _value];
            _vehobj setVariable ["HCTEMP", "PLAYER", true];
        };       
    }];   
 
};

    "FuMS_RADIOCHATTER_Server" addPublicVariableEventHandler
    {
        private[];
        _data = _this select 1;
        _msg = _data select 0;
        _receivers = _data select 1;
        //diag_log format ["#FuMsnInit: RadioChatter for:%1",_receivers];
        FuMS_RADIOCHATTER = _msg;
        {
            (owner (vehicle _x)) publicVariableClient "FuMS_RADIOCHATTER";
        }foreach _receivers;
    };
	
"FuMS_GetMissionData" addPublicVariableEventHandler
{
    _filename = _this select 1;
    if (isNil "_filename") exitWith { diag_log format ["##ServerInit: FuMS_GetMissionData PVEH called with NO DATA!"];};
    [_filename] spawn 
    {
        private ["_missionFile","_hold"];
        _missionFile = format ["\FuMS\Themes\%1.sqf",_this select 0];  
        MissionData = [];
        _hold = [] execVM _missionFile;
        waitUntil {scriptDone _hold};
        if (isNil "_hold" or ( count MissionData <9 or count MissionData > 10) ) exitWith
        {
            diag_log format ["-------------------------------------------------------------------------------------"];
            diag_log format ["----------------            Fulcrum Mission System                    -----------------"];
            diag_log format ["-------------------------------------------------------------------------------------"];
            diag_log format ["##FuMsnInit: ERROR in Fulcrum Mission Data. Mission will be aborted."];
            diag_log format ["    Recommend verifying data in file %1 on your server!",_missionFile];        
            diag_log format ["             -ABORT- -ABORT- -FORMAT ERROR- -ABORT- -ABORT-"];   
            diag_log format ["                            Fulcrum Mission System %1 aborted!",_missionFile];
            diag_log format ["REASON: Format error in %1",_missionFile];
            diag_log format ["-------------------------------------------------------------------------------------"];
            diag_log format ["-------------------------------------------------------------------------------------"];    	
        };
        diag_log format ["##ServerInit : Pushing information on mission %1 to %2",_missionFile,HCHAL_ID];
    };
};
/*
//PVEH WATCHDOG
[] spawn
{
    while {true} do
    {
        waitUntil { MissionData select 0 == "PULL"};
        
        
        
    };
};
*/

