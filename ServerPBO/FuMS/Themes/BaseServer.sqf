//BaseServer.sqf
// Horbin
// 1/10/25
// Inputs: None
// Outputs: Fulcrum Mission data specific for the map being used
// Data specifc to your server's map.
// ALTIS
private ["_hc"];
_hc = _this select 0;
FuMS_ServerData =
[
    [
        [15440, 15342, 0],    // Map Center
        17000                 // Map Range in meters
    ],
    [  
        // Areas to be excluded from Global Random generation of mission spawn points
        // Points listed are for the upper left and lower right corners of a box.
        [[13000,15000,0],[14000,14000,0]],	// Middle spawn near Stavros
        [[05900,17100,0],[06400,16600,0]], // West spawn
        [[18200,14500,0],[18800,14100,0]],   // East spawn
        [[23400,18200,0],[23900,17700,0]]   //Cloning Lab
    ],
    [
        // default positions to use if locations being randomly generated
        // These positions will be used if a random safe location is not found.
        // Note: The below locations are for use by BIS_fnc_findSafePos !!!
        //  If you have specific locations you want to use for your mission set, place those
        //  locations in the specific themedata.sqf.
        
        
    ],
    [
        // ActiveThemes
        // A folder matching the names below needs to exist in the ..\Encounters folder.
        // use this block to easily turn off/on your various mission sets.
       // "StressTest",
		"Test",
		"HeloPatrols",
	    "SEM",
        "TownRaid",
		"Small"
        //"CloneHunters"
    ],
    [  // Event and AI Radio messsage behavior
        true, // EnableRadioChatterSystem: turns on the system, allowing below options to function
        true, // EnableRadioAudio: turns on 'audio' effects for radio chatter
        true, // RadioRequired: if false, messages are heard without a radio on the player's belt.
        false, // RadioFollowTheme: Conforms with Theme radio channel choices. False:any radio works for all channels.
        true, 800 // EnableAIChatter: enables random radio chatter between AI when players get within the specified range (meters) as default.
              // NOTE: Theme 'Radio Range' will override this setting.
    ]
];

_hc publicVariableClient "FuMS_ServerData";