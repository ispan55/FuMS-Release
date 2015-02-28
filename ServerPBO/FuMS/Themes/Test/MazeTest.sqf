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
    "MazeTest",  // Mission Title NOSPACES!
    200                // encounter radius
],[ 
//------------------------------------------------------------------------------------
//-----Notification Configuration-----
//--Map Marker Config.
    "Test Mission",  // Name, set to "" for nothing
     "mil_dot", // icon type:                                     https://community.bistudio.com/wiki/cfgMarkers for other options.
                     // mil_triangle, mil_objective, mil_box, group1, loc_Power, etc.
     "ELLIPSE", // "RECTANGLE". do not use "ICON", two markers are used in making each mission indicator.
     "ColorYellow",//                                                  https://community.bistudio.com/wiki/setMarkerColor
     "FDiagonal",// Cross, Vertical, Horizontal, etc      https://community.bistudio.com/wiki/setMarkerBrush 
       200           // size of the marker.    
],[[
    // NOTIFICATION Messages and Map display Control.
	true,    // Notify players via Radio Message
    "ALL",   // radio channel. "ALL" = no radio required.
    0,         //range from encounter center AI radio's can be heard (0=unlimited.)
    true,  // Notify players via global message - hint screen on right of game display -
    true,   // Show encounter area on the map
    30,      // Win delay: Time in seconds after a WIN before mission cleanup is performed
    10       // Lose delay: Time in seconds after a lose before mission cleanup is performed
//NOTE: the above delay must finish before the mission is considered 'complete' by the mission manager control loop.
// These two delays will also affect how much time will elapse from mission completion until living AI cleanup.
],[
   // Mission spawn message, DO NOT Remove these! They can be edited down to "" if desired.
     "CORE Directive",  // title line
     "Close Combat", 
     "A maze outpost has been established by bandits" //description/radio message.
],[  
    // Mission Success Message
    "Mission Success",  // title line
     "",
     "Notifying High Command that the FOB has been captured."
],[
   // Mission Failure Message
    "Mission Failure!",
    "",
    "Reconnaissance complete. All forces are to RTB."
]],[
//---------------------------------------------------------------------------------
//-----Loot Configuration-----    
// Refer to LootData.sqf for available loot types and contents.
[
 //  ["Random",[0,0]],["Random",[5,5]],["Random",[-5,5]]
   //Array of loot now supported using above syntax.
   // replace "Random" with your desired loot option from LootData.sqf, or leave random for random results!
   // AND don't forget you can use these loot options to fill vehicles with loot too!(see vehicle section below)
],[
    "Random" ,        // WIN Loot
    [0,0]                // Offset from mission center x,y, 3 coords [x,y,z] places loot at a specific map location!  
],[
    "None" ,            // Lose Loot.
     [0,0]                // Offset from mission center.
]],[
//---------------------------------------------------------------------------------
//-----Building Configuration-----       
//BUILDINGS: persist = 0: building deleted at event completion, 1= building remains until server reset.
    // building name                 | offset   |rotation|persist flag
	
   ["Land_CncShelter_F",[23587,18368.5,0],0,0],
["Land_CncShelter_F",[23587,18370.1,0],0,0],
["Land_CncShelter_F",[23587,18371.7,0],0,0],
["Land_CncShelter_F",[23587,18373.3,0],0,0],
["Land_CncShelter_F",[23587,18375,0],0,0],
["Land_CncShelter_F",[23587,18376.5,0],0,0],
["Land_CncShelter_F",[23587,18378.1,0],0,0],
["Land_CncShelter_F",[23587,18379.7,0],0,0],
["Land_CncShelter_F",[23587,18381.3,0],0,0],
["Land_CncWall4_F",[23592.1,18370,-0.64808],159.545,0],
["Land_CncWall4_F",[23588.4,18373.8,-0.912141],90,0],
["Land_CncWall4_F",[23588.6,18379.7,-0.571561],92.0454,0],
["Land_CncWall4_F",[23606.9,18369.7,-0.601235],0,0],
["Land_CncWall4_F",[23590.5,18388.8,-0.692618],132.955,0],
["Land_CncWall4_F",[23598.5,18357.7,0],91.5336,0],
["Land_CncWall4_F",[23598.7,18361.9,0],94.0909,0],
["Land_CncWall4_F",[23583.3,18363.7,0],182.557,0],
["Land_CncWall4_F",[23585.5,18366.4,-0.538321],270.511,0],
["Land_CncWall4_F",[23609.5,18371.8,-0.604523],273.579,0],
["Land_CncWall4_F",[23613.1,18365.6,0],95.625,0],
["Land_CncWall4_F",[23596,18361,0],273.068,0],
["Land_CncWall4_F",[23613.6,18370.6,0],95.1136,0],
["Land_CncWall4_F",[23597.4,18377.3,-0.72649],92.5571,0],
["Land_CncWall4_F",[23600.1,18377.1,-0.569729],181.023,0],
["Land_CncWall4_F",[23592.3,18396.6,0],95.625,0],
["Land_CncWall4_F",[23595.7,18357.9,0],272.557,0],
["Land_CncWall4_F",[23601.8,18369,-0.610225],180,0],
["Land_HBarrierWall_corridor_F",[23599.1,18382.8,0],271.534,0],
["Land_HBarrierWall_corridor_F",[23605.2,18386.7,0],180,0],
["Land_HBarrierWall_corridor_F",[23589.6,18402.1,0],70.0564,0],
["Land_HBarrierWall_corridor_F",[23597.8,18371.8,0],29.659,0],
["Land_HBarrierWall_corridor_F",[23612,18375.8,0],274.091,0],
["Land_HBarrierWall_corridor_F",[23612.5,18381.4,0],275.625,0],
["Land_HBarrierWall_corridor_F",[23612.8,18386.6,0],275.625,0],
["MetalBarrel_burning_F",[23588.6,18371.5,0],0,0],
["MetalBarrel_burning_F",[23612.9,18372.6,0],0,0],
["MetalBarrel_burning_F",[23587.6,18381.9,0],0,0],
["MetalBarrel_burning_F",[23597.7,18386.8,0],0,0],
["MetalBarrel_burning_F",[23576.4,18375.9,0],0,0],
["MetalBarrel_burning_F",[23608.3,18373.2,0],0,0],
["Land_CratesWooden_F",[23593.7,18367.7,0],272.045,0],
["Land_CratesWooden_F",[23597.1,18366.8,0],177.443,0],
["Land_CratesWooden_F",[23594.9,18366.8,0],179.489,0],
["Land_CratesWooden_F",[23608.5,18371.1,0],276.648,0],
["Land_CratesWooden_F",[23610.7,18369.2,0],94.0909,0],
["Land_CratesWooden_F",[23610.9,18394.9,0],276.648,0],
["Land_CratesWooden_F",[23581.2,18377.3,0],270,0],
["Land_Scrap_MRAP_01_F",[23598.2,18348.6,0],35.7955,0],
["Hostage_PopUp_Moving_90deg_F",[23596.7,18379.6,-0.446913],88.4659,0],
["Land_cmp_Tower_F",[23605.6,18391.9,0],3.06817,0],
["Land_Coil_F",[23600.6,18395.7,0],0,0],
["Land_ConcretePipe_F",[23597,18357,0],3.06822,0],
["Land_ConcretePipe_F",[23596.8,18354,0],3.06821,0],
["Land_ConcretePipe_F",[23579.6,18383.7,0],92.0455,0],
["Land_ConcretePipe_F",[23576.8,18383.9,0],272.045,0],
["Land_CncWall4_F",[23588.7,18396.4,0],271.023,0],
["Land_CncWall4_F",[23601.1,18364.2,-0.907769],93.5796,0],
["Land_CncWall4_F",[23592.1,18393.2,0],92.5569,0],
["Land_CncWall4_F",[23588.5,18392.6,0],273.58,0],
["Land_CncWall4_F",[23594.7,18390.1,0],26.0797,0],
["Land_CncWall4_F",[23588.2,18384.9,-0.686437],273.58,0],
["Land_CncWall1_F",[23597.1,18388,0],90.5113,0],
["Land_CncWall1_F",[23588.6,18395.8,0],273.579,0],
["Land_CncWall1_F",[23597.5,18385.9,0],38.8636,0],
["Land_CncWall1_F",[23597.1,18386.6,0],90.5113,0],
["Land_CncWall4_F",[23583.3,18385.4,0],0.000106812,0],
["Land_ConcretePipe_F",[23590.5,18398.4,0],181.534,0],
["Hostage_PopUp_Moving_90deg_F",[23595.7,18388.6,-0.322073],24.5456,0],
["Hostage_PopUp_Moving_90deg_F",[23589.2,18370.3,-0.395416],217.841,0],
["Hostage_PopUp_Moving_90deg_F",[23609.3,18380.9,-0.434929],91.534,0],
["Land_CncWall4_F",[23594.5,18399.3,0],1.53418,0],
["Land_Cargo_Tower_V1_No1_F",[23587.8,18369.4,-0.442125],90.5113,0],
["Land_i_Windmill01_F",[23578.4,18359.7,2.59111],232.67,0],

["Land_Cargo40_brick_red_F",[23603.2,18399.6,2.48493],3.06824,0],
["Land_Cargo40_brick_red_F",[23603.2,18399.6,4.96986],3.06824,0],
["Land_Cargo40_brick_red_F",[23603.2,18399.6,7.45479],3.06824,0],
["Land_Cargo20_grey_F",[23612.3,18399.1,2.47293],3.5795,0],
["Land_Cargo20_grey_F",[23612.3,18399.1,4.94586],3.5795,0],
["Land_Cargo20_grey_F",[23612.3,18399.1,7.41879],3.5795,0],
["Land_Cargo20_grey_F",[23612.3,18399.1,9.89172],3.5795,0],
["Land_Cargo20_grey_F",[23612.3,18399.1,12.3646],3.5795,0],
["Land_Cargo10_orange_F",[23616.8,18398.9,2.57534],1.53403,0],
["Land_Cargo10_orange_F",[23616.8,18398.9,5.15068],1.53403,0],
["Land_Cargo10_orange_F",[23616.8,18398.9,7.72602],1.53403,0],
["Land_Cargo10_orange_F",[23616.8,18398.9,10.3014],1.53403,0],
["Land_Cargo10_orange_F",[23616.8,18398.9,12.8767],1.53403,0],
["Land_Cargo40_brick_red_F",[23616.7,18391.5,2.48493],274.091,0],
["Land_Cargo40_brick_red_F",[23616.7,18391.5,4.96986],274.091,0],
["Land_Cargo40_brick_red_F",[23616.7,18391.5,7.45479],274.091,0],
["Land_Cargo40_brick_red_F",[23582.7,18398,2.48493],3.57959,0],
["Land_Cargo40_brick_red_F",[23582.7,18398,4.96986],3.57959,0],
["Land_Cargo40_brick_red_F",[23582.7,18398,7.45479],3.57959,0],
["Land_Cargo40_brick_red_F",[23582.7,18398,9.93972],3.57959,0],
["Land_Cargo40_brick_red_F",[23582.7,18398,12.4247],3.57959,0],
["Land_Cargo10_red_F",[23606.4,18387,2.50288],271.023,0],
["Land_Cargo40_grey_F",[23615.9,18379.4,2.48493],274.091,0],
["Land_Cargo40_grey_F",[23615.9,18379.4,4.96986],274.091,0],
["Land_Cargo40_grey_F",[23615.9,18379.4,7.45479],274.091,0],
["Land_Cargo40_grey_F",[23615.9,18379.4,9.93972],274.091,0],
["Land_Cargo40_grey_F",[23615.9,18379.4,12.4247],274.091,0],
["Land_Cargo20_brick_red_F",[23594.2,18400.2,2.47293],0.511352,0],
["Land_Cargo20_brick_red_F",[23594.2,18400.1,4.94586],0.511352,0],
["Land_Cargo40_brick_red_F",[23577.2,18391.1,2.48493],272.045,0],
["Land_Cargo40_brick_red_F",[23577.2,18391.1,4.96986],272.045,0],
["Land_Cargo40_brick_red_F",[23577.2,18391.1,7.45479],272.045,0],
["Land_Cargo20_vr_F",[23575.7,18381.6,2.47293],3.06818,0],
["Land_Cargo20_vr_F",[23575.7,18381.6,4.94586],3.06818,0],
["Land_Cargo20_vr_F",[23575.7,18381.6,7.41879],3.06818,0],
["Land_Cargo20_vr_F",[23575.7,18381.6,9.89172],3.06818,0],
["Land_Cargo20_vr_F",[23575.7,18381.6,12.3646],3.06818,0],
["Land_Cargo40_brick_red_F",[23571.1,18375,2.48493],272.045,0],
["Land_Cargo40_brick_red_F",[23571.1,18375,4.96986],272.045,0],
["Land_Cargo40_brick_red_F",[23571.1,18375,7.45479],272.045,0],
["Land_Cargo20_light_green_F",[23613.2,18353.5,2.47293],3.06818,0],
["Land_Cargo20_light_green_F",[23613.2,18353.5,4.94586],3.06818,0],
["Land_Cargo20_light_green_F",[23613.2,18353.5,7.41879],3.06818,0],
["Land_Cargo20_light_green_F",[23613.2,18353.5,9.89172],3.06818,0],
["Land_Cargo20_light_green_F",[23613.2,18353.5,12.3646],3.06818,0],
["Land_Cargo40_brick_red_F",[23604,18353.9,2.48493],3.06818,0],
["Land_Cargo40_brick_red_F",[23604,18353.9,4.96986],3.06818,0],
["Land_Cargo40_brick_red_F",[23604,18353.9,7.45479],3.06818,0],
["Land_Cargo40_military_green_F",[23589.6,18354.6,4.96986],1.53409,0],
["Land_Cargo40_military_green_F",[23589.6,18354.6,7.45479],1.53409,0],
["Land_Cargo40_military_green_F",[23589.6,18354.6,9.93972],1.53409,0],
["Land_Cargo40_military_green_F",[23589.6,18354.6,2.45209],1.53409,0],
["Land_Cargo40_brick_red_F",[23577.5,18355.2,2.48493],3.06818,0],
["Land_Cargo40_brick_red_F",[23577.5,18355.2,4.96986],3.06818,0],
["Land_Cargo40_brick_red_F",[23577.5,18355.2,7.45479],3.06818,0],
["Land_Cargo40_grey_F",[23570.8,18362.9,2.48493],90,0],
["Land_Cargo40_grey_F",[23570.8,18362.9,4.96986],90,0],
["Land_Cargo40_grey_F",[23570.8,18362.9,7.45479],90,0],
["Land_Cargo40_grey_F",[23570.8,18362.9,9.93972],90,0],
["Land_Cargo40_grey_F",[23570.8,18362.9,12.4247],90,0],
["Land_Cargo40_brick_red_F",[23615,18367.1,2.48493],274.091,0],
["Land_Cargo40_brick_red_F",[23615,18367.1,4.96986],274.091,0],
["Land_Cargo40_brick_red_F",[23615,18367.1,7.45479],274.091,0],
["Land_Cargo20_military_green_F",[23614.3,18357.9,2.47293],274.602,0],
["Land_Cargo20_military_green_F",[23614.3,18357.9,4.94586],274.602,0],
["Land_Cargo20_military_green_F",[23614.3,18357.9,7.41879],274.602,0],
["Land_Cargo20_military_green_F",[23614.3,18357.9,9.89172],274.602,0],
["Land_Cargo20_military_green_F",[23614.3,18357.9,12.3646],274.602,0],

["Land_CncWall4_F",[23586.4,18397,0],4.09091,0],
["Land_CncWall4_F",[23581.1,18397.4,0],4.09091,0],
["Land_CncWall4_F",[23578,18394.8,0],272.045,0],
["Land_CncWall4_F",[23577.6,18389.6,0],272.045,0],
["Land_CncWall4_F",[23577.8,18387.4,0],272.045,0],
["Land_CncWall4_F",[23571.9,18378,0],272.045,0],
["Land_CncWall4_F",[23574.5,18382.3,0],183.579,0],
["Land_CncWall4_F",[23571.5,18367.5,0],270.511,0],
["Land_CncWall4_F",[23590.6,18369.4,-0.545679],160.056,0],
["Land_CncWall4_F",[23571.5,18362.9,0],270,0],
["Land_CncWall4_F",[23571.5,18357.6,0],270,0],
["Land_CncWall4_F",[23574.6,18356,0],183.58,0],
["Land_CncWall4_F",[23577.3,18355.9,0],183.068,0],
["Land_CncWall4_F",[23582.6,18355.6,0],183.068,0],
["Land_CncWall4_F",[23588,18355.3,0],183.068,0],
["Land_CncWall4_F",[23599,18390.8,-0.741647],183.068,0],
["Land_CncWall4_F",[23590.4,18355.3,0],181.534,0],
["Land_CncWall4_F",[23593.2,18355.2,0],181.534,0],
["Land_CncWall4_F",[23600.6,18354.8,0],182.557,0],
["Land_CncWall4_F",[23606,18354.5,0],182.557,0],
["Land_CncWall4_F",[23611.3,18354.3,0],182.557,0],
["Land_CncWall4_F",[23613.6,18357.3,0],95.1136,0],
["Land_CncWall4_F",[23614,18362.7,0],95.1136,0],
["Land_CncWall4_F",[23614.5,18368,0],95.1136,0],
["Land_CncWall4_F",[23615.7,18387.1,0],93.0682,0],
["Land_CncWall4_F",[23616,18392.5,0],93.0682,0],
["Land_CncWall4_F",[23616.4,18397.2,0],93.0682,0],
["Land_CncWall4_F",[23613.7,18398.3,0],3.06817,0],
["Land_CncWall4_F",[23608.3,18398.6,0],3.06818,0],
["Land_CncWall4_F",[23603,18398.9,0],3.06818,0],
["Land_CncWall4_F",[23597.6,18399.2,0],3.06818,0],
["Land_Cargo10_orange_F",[23612.9,18388,2.57534],1.53403,0],
["Foundation_EPOCH",[23544.4,18367,0],0,0],
["Foundation_EPOCH",[23543.7,18387.7,0],0,0],
["Foundation_EPOCH",[23570.2,18411.6,0],0,0],
["Foundation_EPOCH",[23558.7,18403.4,0],0,0],
["Foundation_EPOCH",[23567.9,18413.7,0],0,0],
["Foundation_EPOCH",[23574.1,18419.4,0],312.955,0],
["Foundation_EPOCH",[23549.2,18384.8,0],0,0],
["Foundation_EPOCH",[23554.7,18402.2,0],0,0],
["Foundation_EPOCH",[23640.1,18414.3,0],0,0],
["Foundation_EPOCH",[23561.3,18406.9,0],0,0],
["Foundation_EPOCH",[23551.2,18392,0],0,0],
["Foundation_EPOCH",[23553.4,18394.9,0],0,0],
["Foundation_EPOCH",[23552.5,18383.2,0],349.261,0],
["Foundation_EPOCH",[23580,18418.8,0],0,0],
["Foundation_EPOCH",[23590.4,18423.7,0],0,0],
["Foundation_EPOCH",[23553.8,18357.8,0],0,0],
["Foundation_EPOCH",[23614.7,18423,0],0,0],
["Foundation_EPOCH",[23547.4,18371.6,0],0,0],
["Foundation_EPOCH",[23597.4,18424.2,0],0,0],
["Foundation_EPOCH",[23599.2,18421,0],0,0],
["Foundation_EPOCH",[23608,18424.1,0],0,0],
["Foundation_EPOCH",[23582.2,18420.5,0],0,0],
["Foundation_EPOCH",[23629.6,18423.5,0],0,0],
["Foundation_EPOCH",[23621.6,18423.5,0],0,0],
["Foundation_EPOCH",[23618.2,18426.1,0],0,0],
["Foundation_EPOCH",[23637.3,18418.2,0],0,0],
["Foundation_EPOCH",[23625.6,18426.8,0],0,0],
["Foundation_EPOCH",[23648.1,18403.1,0],0,0],
["Foundation_EPOCH",[23641.6,18384,0],0,0],
["Foundation_EPOCH",[23613.9,18334,0],0,0],
["Foundation_EPOCH",[23604.2,18332,0],0,0],
["Foundation_EPOCH",[23550,18351,0],0,0],
["Foundation_EPOCH",[23556.8,18340.1,0],0,0],
["Foundation_EPOCH",[23624.4,18340,0],0,0],
["Foundation_EPOCH",[23628.5,18342,0],0,0],
["Foundation_EPOCH",[23639.3,18353.8,0],0,0],
["Foundation_EPOCH",[23642.5,18357,0],0,0],
["Foundation_EPOCH",[23636.2,18349.1,0],0,0],
["Foundation_EPOCH",[23631,18349.9,0],0,0],
["Foundation_EPOCH",[23618.8,18337.1,0],0,0],
["Foundation_EPOCH",[23553.1,18347.2,0],0,0],
["Foundation_EPOCH",[23596.2,18333.1,0],0,0],
["Foundation_EPOCH",[23585,18332.4,0],0,0],
["Foundation_EPOCH",[23638.7,18361.3,0],0,0],
["Foundation_EPOCH",[23574.8,18334.4,0],0,0],
["Foundation_EPOCH",[23565.7,18337.9,0],0,0],
["Foundation_EPOCH",[23548,18354.4,0],0,0],
["Foundation_EPOCH",[23644,18374.3,0],0,0],
["Foundation_EPOCH",[23644.9,18390.3,0],0,0],
["Foundation_EPOCH",[23641.5,18394.2,0],0,0],
["Foundation_EPOCH",[23645.9,18406.4,0],0,0],
["Foundation_EPOCH",[23643.4,18409.1,0],0,0],
["Foundation_EPOCH",[23605.4,18419.9,0],0,0],
["Foundation_EPOCH",[23646,18398.1,0],0,0],
["Foundation_EPOCH",[23644.7,18382.4,0],0,0],
["Foundation_EPOCH",[23640.3,18370.3,0],0,0],
["Foundation_EPOCH",[23621.6,18336.1,0],0,0],
["Foundation_EPOCH",[23642.8,18364.6,0],0,0],
["Foundation_EPOCH",[23621.6,18336.1,0],0,0],
["Foundation_EPOCH",[23600.6,18330.9,0],0,0],
["Foundation_EPOCH",[23582.1,18334.9,0],0,0],
["Foundation_EPOCH",[23544.4,18357.8,0],0,0],
["Foundation_EPOCH",[23565.5,18330.4,0],0,0],
["Foundation_EPOCH",[23558.8,18336.1,0],0,0],
["Foundation_EPOCH",[23573.3,18336.6,0],0,0],
["Foundation_EPOCH",[23610.1,18329.3,0],0,0],
["Foundation_EPOCH",[23588.2,18336.9,0],0,0],
["Foundation_EPOCH",[23562.4,18405.3,0],0,0],
["Foundation_EPOCH",[23624.7,18420.7,0],0,0],
["Foundation_EPOCH",[23638.4,18406.3,0],0,0],
["Foundation_EPOCH",[23592.4,18420.7,0],0,0],
["Foundation_EPOCH",[23632.7,18416,0],0,0],
["Foundation_EPOCH",[23607.9,18422.6,0],0,0],
["Foundation_EPOCH",[23580.2,18423.6,0],0,0],
["Foundation_EPOCH",[23600.2,18427.2,0],0,0],
["Foundation_EPOCH",[23612.2,18421,0],0,0],
["Foundation_EPOCH",[23607.6,18328.1,0],0,0],
["Foundation_EPOCH",[23597.9,18330.3,0],0,0],
["Foundation_EPOCH",[23569.1,18338.9,0],0,0],
["Foundation_EPOCH",[23611.9,18329.9,0],0,0],
["Foundation_EPOCH",[23566.3,18339.4,0],0,0],
["Foundation_EPOCH",[23593.8,18331.9,0],0,0],
["Foundation_EPOCH",[23545.9,18369,0],0,0],
["Foundation_EPOCH",[23550.2,18341.5,0],0,0],
["Foundation_EPOCH",[23548.4,18365,0],0,0],
["Foundation_EPOCH",[23548.9,18375.6,0],0,0],
["Foundation_EPOCH",[23550,18378.1,0],0,0],
["Foundation_EPOCH",[23552.2,18344.1,0],0,0],
["Foundation_EPOCH",[23552.1,18370.5,0],0,0],
["Foundation_EPOCH",[23552.4,18361.8,0],0,0],
["Foundation_EPOCH",[23549.9,18392.8,0],0,0],
["Hostage_PopUp_Moving_90deg_F",[23590.6,18388.1,-0.434929],317.557,0],
["Hostage_PopUp_Moving_90deg_F",[23612.9,18360.4,-0.434929],89.9999,0],
["Hostage_PopUp_Moving_90deg_F",[23588.7,18379.3,-0.434929],272.557,0],
["Hostage_PopUp_Moving_90deg_F",[23572.4,18367.7,-0.434929],277.67,0],
["Hostage_PopUp_Moving_90deg_F",[23603.3,18369.8,-0.434929],175.909,0],
["Hostage_PopUp_Moving_90deg_F",[23603.3,18356,-0.434929],179.488,0],
["Hostage_PopUp_Moving_90deg_F",[23606.3,18369.9,-0.434929],176.932,0],
["Land_PowerLine_distributor_F",[23606.1,18361.7,0],143.182,0],
["Land_LightHouse_F",[26677.9,24625.1,10.2597],139.602,0],
["Flag_US_F",[26757.5,24640.2,9.55272],38.3523,0],
["Flag_POWMIA_F",[26770.1,24654.8,9.43789],41.9319,0],
["Land_LampAirport_F",[26827.2,24569.3,-0.210615],309.886,0],
["Land_LampHarbour_F",[26742,24665.6,0],131.421,0],
["Land_LampHarbour_F",[26748.6,24673.1,0],131.421,0],
["Land_LampHarbour_F",[26778,24646.8,0.110622],303.75,0],
["Land_LampHarbour_F",[26766.3,24632.9,0],300.682,0],
["Land_LampHarbour_F",[26735.5,24658,0],131.421,0],
["Land_LampHalogen_F",[26750.5,24676.2,-0.00894737],129.886,0],
["Land_LampHalogen_F",[26732.7,24655.8,0.119656],310.909,0],
["Land_LampHalogen_F",[26740.7,24666.9,-0.0995445],40.3977,0],
["Land_TentHangar_V1_F",[26504.7,24688.9,2.49258],266.932,0],
["CinderWallGarage_EPOCH",[26526.5,24690.1,0],266.42,0],
["CinderWall_SIM_EPOCH",[26520.4,24679.4,-0.446117],355.909,0],
["CinderWall_SIM_EPOCH",[26521.1,24700,-0.350667],358.466,0],
["CinderWall_SIM_EPOCH",[26524.6,24679.7,-0.465827],355.398,0],
["CinderWall_SIM_EPOCH",[26526.8,24684.9,-0.219742],267.443,0],
["CinderWall_SIM_EPOCH",[26526.1,24694.7,-0.164801],264.375,0],
["CinderWall_SIM_EPOCH",[26525.8,24697.8,-0.0483603],264.886,0],
["CinderWall_SIM_EPOCH",[26523,24700,0],177.955,0],
["CinderWall_SIM_EPOCH",[26527,24682.3,-0.219742],266.932,0],
["CinderWall_SIM_EPOCH",[26515.4,24679.1,-0.214639],356.421,0],
["CinderWall_SIM_EPOCH",[26516.1,24699.9,-0.765014],357.443,0],
["CinderWall_SIM_EPOCH",[26524.6,24679.7,0.151485],355.398,0],
["CinderWall_SIM_EPOCH",[26520.5,24679.4,0.554888],355.398,0],
["CinderWall_SIM_EPOCH",[26515.5,24679,1.18664],356.42,0],
["CinderWall_SIM_EPOCH",[26518.7,24699.9,0.236948],178.466,0],
["CinderWall_SIM_EPOCH",[26525.8,24697.7,0.470959],84.375,0],
["CinderWall_SIM_EPOCH",[26516.1,24699.9,0.470779],177.955,0],
["CinderWall_SIM_EPOCH",[26526.8,24685,0.0238464],86.9318,0],
["CinderWall_SIM_EPOCH",[26526.1,24695.2,0.294901],84.375,0],
["CinderWall_SIM_EPOCH",[26527,24682.3,0.0238464],86.9318,0],
["Land_Pier_small_F",[26505.7,24688,-0.109343],83.8636,0],
["Land_LampShabby_F",[26511.3,24690,0],151.364,0],
["Land_LampShabby_F",[26527,24687.8,-2.64235],92.0455,0],
["Land_LampShabby_F",[26526.6,24692.6,-2.4808],74.6591,0],
["Land_CncWall4_F",[23571.7,18372.6,0],272.045,0],
["Land_CncWall4_F",[23572,18380.4,0],268.977,0]

],[
//---------------------------------------------------------------------------------
//-----Group Configuration-----  see Convoy section for AI in vehicles! 
//--- See SoldierData.sqf for AI type options.
/*
    Defined AI logic options: See 'Documenation' for details'
["BUILDINGS", [spawnloc], [actionloc], [duration, range]]  
["EXPLORE   ",[spawnloc], [actionloc], [radius]]
["BOXPATROL", [spawnloc], [actionloc], [radius]]
["CONVOY",    [spawnloc], [actionloc], [speed, FlagRTB, FlagRoads, FlagDespawn, convoyType]]
["SENTRY",    [spawnloc], [actionloc], [radius]]
["PARADROP",  [spawnloc], [actionloc], [speed, altitude, FlagRTB, FlagSmokes]]  
["PATROLROUTE", [spawnloc], [actionloc], [behaviour, speed, [locations], FlagRTB, FlagRoads, FlagDespawn, flyHeight]    
    
*/
// **paste 'copy' below this line to add additional groups.

// **Start 'copy'****Spawn a Group of AI Config Data *********
// 3 rifleman that will spawn NW of encounter center and patrol all buildings within 70m
// Example below shows how town names can be used in place of spawn locations and offsets!
//[["RESISTANCE","COMBAT","RED","LINE"],[[3,"Rifleman"]],["Buildings",[0,0],[0,0],[0,70] ]], // 3 rifleman that will patrol all buildings within 70m for unlimited duration
// **End 'copy'******(see Patrol Options below for other AI behaviour)
// Example of a 3D map location. This loc is specific to ALTIS
//[["RESISTANCE","COMBAT","RED","LINE"],[[5,"Rifleman"]],["BoxPatrol",[0,0],[0,0],[70] ]],
    // 5 rifleman that spawn at [21520,11491.9,0] and march to encounter centr to set up a box patrol!    
// Expanded group example:
// 1 sniper, 2 rifleman, 2 hunters wil spawn east of encounter center and perform a box shaped patrol.

// 2 hunters that will spawn near encounter center and take up guard positions.
// This example the AI are spawned 6 meters NE of encoutner center, and will look for a building within 30meters of encounter senter to take up Sentry postions.
// [["RESISTANCE","COMBAT","RED","LINE"],[[2,"Hunter"]],["Sentry",[0,0],[0,0],[30]]
],
// NOTE: if no buildings are located within 'radius' both 'Buildings' and 'Lookout' will locate nearest buildings to the encounter and move there!
// NOTE: See AI_LOGIC.txt for detailed and most current descriptions of AI logic.

//---------------------------------------------------------------------------------
//-----LAND Vehicle Configuration----- 
[
 
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
[ // NOTE: side RESISTANCE for groups == side GUER for Triggers.
    [    //WIN Triggers and Controls
      ["LowUnitCount", "GUER", 0, 0, [0,0]], // all enemies are dead:  side options "EAST","WEST","GUER","CIV","LOGIC","ANY"
       ["ProxPlayer", [0,0], 20, 1] // 1 player is within 50 meters of encounter center.
	//   ["Reinforce", 100, "Random"] // %chance when requested, Mission to run
//  ["BodyCount", 10] // when at least 10 AI are killed by players
	   // Note Reinforce trigger will not impact win/loss logic.
    ],
    [    //LOSE Triggers and Controls
//      ["HighUnitCount", "GUER",10,40,[0,0]] // 10 enemies get within 40m's of encounter center
           //["Timer",180]  // mission ends after 3 minutes if not completed
    ],   
    [    //Phase01 Triggers and Controls
//        ["Timer", 180]  // Mission launches in 180 seconds
//      ["Detected",0,0]    //Launch mission if any AI group or vehicle detects a player
       //  ["ProxPlayer", [0,0], 100, 1] // 1 player is within 100 meters of encounter center.
    ],
    [    //Phase02 Triggers and Controls
      //  ["Timer",120] // after 5 minutes Enemies to this AI arrive--town WAR!!!!!
    ],
    [    //Phase03 Triggers and Controls
    
    ],
    [    // NO TRIGGERS: Uncomment the line below to simply have this mission execute. Mission triggers from a mission that
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
   // ["NukeDevice",["Paros"]],  //Phase01 <-- as an array a 3dlocation, offset, or town name can be specified for the phase mission's center
   // "TestMission01Enemy", //Phase02 <-- just a file name, phased mission uses THIS mission's center!
   // "TestPhase3" //Phase03
],
[
    //Airborne Vehicle Configuration

]
    
];
//*******************************************************************************
//******* Do not change this!                                       **********************************
//*******************************************************************************
MissionData = _initData;
HCHAL_ID publicVariableClient "MissionData";