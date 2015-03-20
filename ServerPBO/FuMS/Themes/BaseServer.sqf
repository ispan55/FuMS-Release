//BaseServer.sqf
// Horbin
// 1/10/25
// Data specifc to your server's map.
// ALTIS
FuMS_ServerData =
[
    [ // Map Definition and FuMS configuration
        [15440, 15342, 0],    // Map Center
        17000,                 // Map Range in meters
		true,				//Enable AdminControls! See Docs\AdminControls.txt
         15   //minimum Server FPS. Below this FPS FuMS will not load new missions. 
    ],
    [  // Exclusion Areas
        // Areas to be excluded from Global Random generation of mission spawn points
        // Points listed are for the upper left and lower right corners of a box.
        [[13000,15000,0],[14000,14000,0]],	// Middle spawn near Stavros
        [[05900,17100,0],[06400,16600,0]], // West spawn
        [[18200,14500,0],[18800,14100,0]],   // East spawn
        [[23400,18200,0],[23900,17700,0]]   //Cloning Lab
    ],
    [ // Default Areas
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
        // -1 = all HC's.  0= Server only,  1=1st HC to connect, 2=2nd, etc.
        //  Note: Server option not currenty operational.
        // ["StressTest",-1],
        ["Test",1],
        ["HeloPatrols",1],
        ["SEM",-1],
        ["TownRaid",1],
        ["Small",-1],
        ["Aquatic",-1],
        ["MadScience",-1]
    ],
    [  // Event and AI Radio messsage behavior
        true, // EnableRadioChatterSystem: turns on the system, allowing below options to function
        false, // EnableRadioAudio: turns on 'audio' effects for radio chatter
        true, // RadioRequired: if false, messages are heard without a radio on the player's belt.
        false, // RadioFollowTheme: Conforms with Theme radio channel choices. False:any radio works for all channels.
        true, 800 // EnableAIChatter: enables random radio chatter between AI when players get within the specified range (meters) as default.
              // NOTE: Theme 'Radio Range' will override this setting.
    ],
	[ // Soldier Defaults

		3, // default number of rifle magazines for each AI
		3, // default number of pistol magazines
		true, // Turns ON VCOM_Driving V1.01 = Genesis92x for all land/boat vehicle drivers
		      //http://forums.bistudio.com/showthread.php?187450-VCOM-AI-Driving-Mod
		  //Skill Override options:
		  // Values here will override values for individual units defined in SoldierData.
		  // values ranges 1.0 -0.0      0= uses GlobalSoldierData.sqf setting for each soldier.
		  // defaults 'stock' ai based around values indicated below.
		  // if unique AI are desired, modify these numbers in GlobalSoldierData.sqf or SoldierData.sqf as applicable.
		  // values here OVERRIDE any value set in the other files! (value of zero = use other files values).
		[
		.8, // aimingAccuracy .05 : target lead, bullet drop, recoil
		.9,	// aimingShake .9 : how steady AI can hold a weapon
		.5,	// aimingSpeed .1 : how quick AI can rotate and stabilize its aim and shoot.
		.9,	// spotDistance .5 : affects ability to spot visually and audibly and the accuracy of the information
		.8,	// spotTime .5 : affects how quick AI reacts to death, damage or observing an enemy.
		.9,	// courage .1 : affects unit's subordinates morale
		.5,	// reloadSpeed .5 :affects delay between weapon switching and reloading
		.8	// commanding .5 : how quickly recognized targets are shared with the AI's group.
		]	

	],
	[ // Loot Defaults

		20, // number of minutes after mission completion before deleting a loot box.
		// NOTE: This is not based on when the box is spawned, but WHEN the mission completes!
		[  // SMOKE BOX Options
            true, // true= smoke created with box for ease of location.
            100,  // proximity character has to get to box before smokes start. 0=unlimited
            ["Red","White","Blue"],  // colors of smoke
             5     // Duration, in minutes, smoke lasts once triggered.
          ],
		true,  // vehicles occupied by players persist through server reset and are sellable!
		// List of box types used by "Random" in LootData and GlobalLootData files.
		["B_supplyCrate_F","O_supplyCrate_F","I_supplyCrate_F","CargoNet_01_box_F"],
		// List of vehicles prohibited to use by players. This list allows them to be on the map for AI use
		// but will prevent players from entering the vehicle.
		["I_UGV_01_rcws_F"],
          true  //VehicleAmmoFlag true= sets vehicle ammo to zero when an AI vehicle is 1st occupied by a player.
	]

];




