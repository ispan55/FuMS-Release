//LootData.sqf    - For Simple Epoch Missions =DrSudo=
// Horbin
// 1/8/15
//INPUTS: lootConfig, mission center, mission status.
// Intended as a #include to the Fulcrum Mission System init file.
// This function pulls the applicable data from here, and call the function to create the loot box.
// Note: "RANDOM" in any field will select a random type (BoxType, weapon, magazine, item, backpack, etc)
// Note: Placing a 'variable name' from BaseLoot into an option will direct FillLoot.sqf to select a random item from
//    the list of obtions in the 'variable name'
// Example: [Backpacks_All, 4] will select a random backpack, and place 4 of them in the container
// Example: ["FAK",[1,0,5] ] will add '1' FAK, and an additional '0' to '5' First Aid Kits to the container.
//    see BaseLoot.sqf for more specific 'random' lists you can choose from.
//*********************************************************************************************************
// LOOTDATA is GLOBAL to all mission sets to permit easier management of quantity/richness/type of loot
//   accross all missions and mission themes on the server.
//**********************************************************************************************************
_lootData =
[
    // To add more loot options, copy and paste all lines (including comments) from the 'CloneHunter' code below.
    // Paste the code above the '**** CloneHunter Loot**** line.
  //***********************************
 [
// Loot Option title, and box to be used.  Use of array names is permitted. 
  ["BuildingBox", "Random"],
  [// All weapons and quantity 
      ["srifle_GM6_F", 1]
  ],
  [// All magazines and quantity
    ["5Rnd_127x108_Mag", 4]
  ],
  [// All items and quantity
      ["ItemCompass", 1],["FAK", 1],["CinderBlocks", 16],["ChainSaw", 1],
	["ItemMixOil", 2],["jerrycan_epoch", 2],["EnergyPack", 4],
	["MortarBucket", 6],["ItemCorrugated", 6]
  ],
  [// All backpacks and quantity
    [Backpacks_ALL, 1]
  ]
 ],//**********End of loot**********************
 //***********************************
 [
// Loot Option title, and box to be used.  Use of array names is permitted. 
  ["MultiGunBox", "Random"],
  [// All weapons and quantity 
       ["srifle_GM6_F", 1],
		  ["MultiGun", 1]
  ],
  [// All magazines and quantity
     ["5Rnd_127x108_Mag", 4],
		  ["EnergyPack", 4]
  ],
  [// All items and quantity
     ["ItemCompass", 1],["FAK", 1],["Repair_EPOCH", 1],
	["Defib_EPOCH", 1],["Heal_EPOCH", 2],["jerrycan_epoch", 2]
  ],
  [// All backpacks and quantity
    [Backpacks_ALL, 1]
  ]
 ],//**********End of loot**********************
  //***********************************
 [
// Loot Option title, and box to be used.  Use of array names is permitted. 
  ["LMGBox", "Random"],
  [// All weapons and quantity 
      ["LMG_Zafir_F", 1]
  ],
  [// All magazines and quantity
    ["150Rnd_762x51_Box", 4]
  ],
  [// All items and quantity
      ["ItemCompass", 1],["VehicleRepair", 1],["FAK", 1],
	["sweetcorn_epoch", 2],["ItemSodaRbull", 1],["Pelt_EPOCH", 2],
	["ItemKiloHemp", 5],["Towelette", 4]
  ],
  [// All backpacks and quantity
    [Backpacks_ALL, 1]
  ]
 ],//**********End of loot**********************   
 //***********************************
 [
// Loot Option title, and box to be used.  Use of array names is permitted. 
  ["SmallGunBox", "Random"],
  [// All weapons and quantity 
       ["hgun_P07_F", 1],
		  ["Rollins_F", 1]
  ],
  [// All magazines and quantity
     ["16Rnd_9x21_Mag", 4],
		  ["5Rnd_rollins_mag", 4]
  ],
  [// All items and quantity
     ["ItemCompass", 1],["Rangefinder", 2],["FAK", 1],
	["muzzle_snds_B", 1],["Pelt_EPOCH", 2],["ChainSaw", 1],
	["ItemMixOil", 2],["jerrycan_epoch", 2]
  ],
  [// All backpacks and quantity
    [Backpacks_ALL, 1]
  ]
 ],//**********End of loot**********************
//**************************************************************   
//***********************************
 [
// Loot Option title, and box to be used.  Use of array names is permitted. 
  ["RiflesBox", "Random"],
  [// All weapons and quantity 
      ["hgun_P07_F", 2],
	  ["arifle_MXC_Black_F", 1],
	  ["arifle_Katiba_F", 2]
  ],
  [// All magazines and quantity
     ["16Rnd_9x21_Mag", 7],
	 ["30Rnd_65x39_caseless_green_mag_Tracer", 6]
  ],
  [// All items and quantity
      	["ItemGPS", 2],["Binocular", 2],["FAK", 4],
		["WhiskeyNoodle", 3],["muzzle_snds_H", 1],["ItemKiloHemp", 2],
	 ["scam_epoch", 2],["ColdPack", 1],["muzzle_snds_L", 1],
	 ["VehicleRepair", 1],["U_O_CombatUniform_ocamo", 1]
  ],
  [// All backpacks and quantity
    [Backpacks_ALL, 1]
  ]
 ],//**********End of loot**********************
//******************************************************************************
 [
// Loot Option title, and box to be used.  If box = 'VEHICLE' then loot is intended to be placed in a vehicle.
  ["SniperBox","Random"],
  [// All weapons and quantity  
   ["srifle_GM6_F", 1],["srifle_DMR_01_F", 1],["srifle_EBR_F", 1]
  ],
  [// All magazines and quantity
    ["5Rnd_127x108_Mag", 4],["10Rnd_762x51_Mag", 4],["20Rnd_762x51_Mag", 5]
  ],
  [// All items and quantity
      ["ItemCompass", 1],["Rangefinder", 2],["FAK", 1],["muzzle_snds_B", 1],
	  ["ItemGoldBar", 1],["Pelt_EPOCH", 2],["ChainSaw", 1],["ItemMixOil", 1],
	["muzzle_snds_B", 1],["optic_Nightstalker", 1],["ItemGPS", 1]
  ],// All backpacks and quantity
  [
    [Backpacks_ALL, 1]
  ]
 ],  //***********End of Loot************************ 
  [
// Loot Option title, and box to be used.  If box = 'VEHICLE' then loot is intended to be placed in a vehicle.
  ["Truck01","Random"],
  [// All weapons and quantity  
   //["srifle_GM6_F", 1],["srifle_DMR_01_F", 1],["srifle_EBR_F", 1]
  ],
  [// All magazines and quantity
    //["5Rnd_127x108_Mag", 4],["10Rnd_762x51_Mag", 4],["20Rnd_762x51_Mag", 5]
  ],
  [// All items and quantity
     // ["ItemCompass", 1],["Rangefinder", 2],["FAK", 1],["muzzle_snds_B", 1],
	  ["ItemGoldBar", 1],["Pelt_EPOCH", 2],["ChainSaw", 1],["ItemMixOil", 1]
	//["muzzle_snds_B", 1],["optic_Nightstalker", 1],["ItemGPS", 1]
  ],// All backpacks and quantity
  [
    //[Backpacks_ALL, 1]
  ]
 ]  //***********End of Loot************************ 
//**********************************************************************************************************
];

LOOTDATA set [_this select 0, _lootData];

