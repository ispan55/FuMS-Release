//HC_Player_Init.sqf
// Horbin
// 12/23/14
// Init file run by all players, HC's, and the server.
diag_log format ["Headless Client code initializing for player:%1",player];
// Start the Fulcrum Mission System
[] execVM "HC\Encounters\FuMsnInit.sqf";  
