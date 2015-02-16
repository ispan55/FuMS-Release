//TestMission01.sqf
// Horbin
// 12/31/14
// Be cautious when editing data.

// NOTE: For all Offset values, if three dimensions are used, the point will be treated as an absolute point on the game map.
// Ex: [15,20] is an offset 15m east, 20m north of the encounter center
// Ex: [12100,11000,0] is a specific point on the map.
// absolute 3d locations can be subsituted for any offset within this file!

_initData =
[[
//------------------------------------------------------------------------------------
//-----Mission Area Setup-----
    "cloneArmy",  // Mission Title NOSPACES!
    500                // encounter radius
],[ 
//------------------------------------------------------------------------------------
//-----Notification Configuration-----
//--Map Marker Config.
    "Clone Army",  // Name, set to "" for nothing
     "mil_dot", // icon type:                                     https://community.bistudio.com/wiki/cfgMarkers for other options.
                     // mil_triangle, mil_objective, mil_box, group1, loc_Power, etc.
     "ELLIPSE", // "RECTANGLE". do not use "ICON", two markers are used in making each mission indicator.
     "ColorRed",//                                                  https://community.bistudio.com/wiki/setMarkerColor
     "FDiagonal",// Cross, Vertical, Horizontal, etc      https://community.bistudio.com/wiki/setMarkerBrush 
       900           // size of the marker.    
],[[
    // NOTIFICATION Messages and Map display Control.
	true,    // Notify players via Radio Message
    "ALL",   // radio channel. "ALL" = no radio required.
    0,         //range from encounter center AI radio's can be heard (0=unlimited.)
    false,  // Notify players via global message - hint screen on right of game display -
    true,   // Show encounter area on the map
    30,      // Win delay: Time in seconds after a WIN before mission cleanup is performed
    10       // Lose delay: Time in seconds after a lose before mission cleanup is performed
//NOTE: the above delay must finish before the mission is considered 'complete' by the mission manager control loop.
// These two delays will also affect how much time will elapse from mission completion until living AI cleanup.
],[
			"Clone Army",  																		// Spawn Mission Message
			"Enemy forces are regrouping on the northern Island.",								// title line
			"They already occupy an abandonend military base and wait for their reinforcements"	// description/radio message.
],[  
			"Army defeated",																	// Mission Success Message
			"",																					// title line
			"Congratulations! search the area for any left overs"								// description/radio message.
],[
			"Mission failed!",																	// Mission Failure Message
			"You Failed",																		// title line
			""    
]],[
//---------------------------------------------------------------------------------
//-----Loot Configuration-----    
// Refer to LootData.sqf for available loot types and contents.
[
   ["random",[8375.1,24994.3,0]],["random",[8305.64,25243.7,0]],["random",[8691.44,25361.8,0]],["random",[8794.44,25198.1,0]],["random",[8656.88,25001.4,0]]
   //Array of loot now supported using above syntax.
   // replace "Random" with your desired loot option from LootData.sqf, or leave random for random results!
   // AND don't forget you can use these loot options to fill vehicles with loot too!(see vehicle section below)
],[
    ["BuildingBox_north",[8516.87,25096.7,0]],["BuildingBox_north",[8513.75,25095.9,0]],["BuildingBox_north",[8458.96,25071.9,0]]        // WIN Loot
],[
    "Random" ,            // Lose Loot.
     [0,0]                // Offset from mission center.
]],[
//---------------------------------------------------------------------------------
//-----Building Configuration-----       
//BUILDINGS: persist = 0: building deleted at event completion, 1= building remains until server reset.
    // building name                 | offset   |rotation|persist flag
    []
],[
[[
	"RESISTANCE",
	"COMBAT",
	"RED",
	"LINE"
],[
	[15,"Sniper"]
],[
	"Sentry",
	[8314.73,25193,0],
	[0,0],
	[0,70]
]],
[[
	"RESISTANCE",
	"COMBAT",
	"RED",
	"LINE"
],[
	[50,"Rifleman"],[20,"LMG"]
],[
	"Explore",
	[8466.07,25124.9,0],
	[0,0],
	[70]
]],
[[
	"RESISTANCE", // side: RESISTANCE, WEST, EAST
	"COMBAT",      // behaviour: SAFE, AWARE, COMBAT, STEALTH
	"RED",          //combatmode: BLUE, WHITE, GREEN, YELLOW, RED
	"COLUMN"    //formation: STAG COLUMN, WEDGE, ECH LEFT, ECH RIGHT, VEE, LINE, COLUMN
],[      // number and type of AI to be in the group (see SoldierData.sqf)
    [3,"Sniper"],[45,"Rifleman"],[20,"Hunter"]          
],[  
    "BoxPatrol",  
    [0,75],   // spawn location offset.
    [0,0],    // origion of patrol routine.
    [0]       // options to be passed to the routine.
]],
// 2 hunters that will spawn near encounter center and take up guard positions.
// This example the AI are spawned 6 meters NE of encoutner center, and will look for a building within 30meters of encounter senter to take up Sentry postions.
 [[
	"RESISTANCE",
	"COMBAT",
	"RED",
	"LINE"
],[
	[15,"Sniper"]
],[
	"Sentry",
	[8314.73,25193,0],
	[0,0],
	[0,70]
]
]],
// NOTE: if no buildings are located within 'radius' both 'Buildings' and 'Lookout' will locate nearest buildings to the encounter and move there!
// NOTE: See AI_LOGIC.txt for detailed and most current descriptions of AI logic.

//---------------------------------------------------------------------------------
//-----LAND Vehicle Configuration----- 
[
	[]
],
// Triggers and Event control.
//  There are 3 general states for a mission. Win, Lose, or Phase Change.
// In order to establish a WIN or LOSE, all Trigger specified below must be met within their specified state.
// Same evaluation is done with checking for Phase changes. 
// Phase Change Detail:
//	When a 'phase change occurs the appropriate additional mission will be launched.
//  Win/Lose logic for this encounter will suspend when phase change is launched. 
//  If triggers in this mission are still desired, uncomment the "NO TRIGGERS" comment IN THE MISSION being launched by this mission"
// See the Triggers.txt file under Docs!
[			// NOTE: side RESISTANCE for groups == side GUER for Triggers.
    [		//WIN Triggers and Controls
		["BodyCount", 110],
		["Reinforce",50,"phase_1"]
    ],
    [    //LOSE Triggers and Controls
        ["TIMER", 4500]  // mission ends after 3 minutes if not completed
    ],   
    [    //Phase01 Triggers and Controls
    ],
    [    //Phase02 Triggers and Controls
    ],
    [    //Phase03 Triggers and Controls  
    ],
    [   // NO TRIGGERS: Uncomment the line below to simply have this mission execute. Mission triggers from a mission that
        // launched this mission will continue to be observed.
		// Uncommenting this line will ignore all triggers defined above, and mission will pass neither a WIN or LOSE result.
    //   ["NO TRIGGERS"]
    ]
],

// Phased Missions.
// Chaininig of missions is unlimited.
// Above triggers will 'suspend' when below phase starts. Phase launched will use its own triggers as specified in its mission script.
// If it is desired to continue to use the above Triggers instead of the 'launched mission's' triggers do the following:
//   uncomment the "NO TRIGGERS' line from the mission being launched.
// The file needs to be located in the same folder as this mission launching them.
[
    //"NukeDevice",  //Phase01
    //"TestMission01Enemy", //Phase02
    //"TestPhase3" //Phase03
],
[
[]   
]


];
//*******************************************************************************
//******* Do not change this!                                       **********************************
//*******************************************************************************
MissionData = _initData;
HCHAL_ID publicVariableClient "MissionData";