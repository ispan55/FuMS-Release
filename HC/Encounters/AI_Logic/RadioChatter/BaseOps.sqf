 //BaseOps.sqf
 //Horbin
 // 1/16/15
 //Inputs: None - directly
 // Manages 'BaseOps' radio communications for all themes.
 // Radio messages are all 'Theme' based. Thus reference below will be based upon
 //  the _themeIndex used in other portions of the project.  Data for each 'Theme'
 // will be stored at its index.
 /*
    THEMEDATA [_themeIndex] select 3 is RadioChatter config data
	         0 = radio channel
			 1 = ai death message true/false
			 2 = radio range
			 3 = ai callsign
			 4 = base ops callsign
			 5 = ai message list
			 6 = baseops message list
 
 ASSERT: THEMEDATA has been fully initialized.
 */
// Build the list of BaseOps that are active
FormatAndBroadcast = compile preprocessFileLineNumbers "HC\Encounters\AI_Logic\RadioChatter\FormatAndBroadcast.sqf";
AI_XMT_MsgQue = [];
AI_RCV_MsgQue = [];
GroupCount = [];
private ["_radioChannel","_aiDeathMsg","_radioRange","_aiCallsign","_baseCallsign","_aiMsgs","_baseMsgs",
"_numThemes","_options","_silentCheckIn","_startTime","_sitrepDelta","_msg"];
_radioChannel = [];
_silentCheckIn = [];
_aiDeathMsg = [];
_radioRange = [];
_aiCallsign = [];
_baseCallsign = [];
_aiMsgs = [];
_baseMsgs = [];
{
    private ["_data"];
    _data = _x select 3;
    //Theme Data elements : 0= config options, 1=AI messages, 2=base messages
  //  diag_log format ["##BaseOps: Themedata select 3: _data:%1",_data];
    _options = _data select 0;
    _radioChannel = _radioChannel + [_options select 0];
    _silentCheckIn = _silentCheckIn + [_options select 1];
    _aiDeathMsg = _aiDeathMsg + [_options select 2];
    _radioRange = _radioRange + [_options select 3];
    _aiCallsign = _aiCallsign + [_options select 4];
    _baseCallsign = _baseCallsign + [_options select 5];
    _aiMsgs = _aiMsgs + [_data select 1];
    _baseMsgs = _baseMsgs + [_data select 2]; // list of all bases messagess (array of arrays)
    AI_XMT_MsgQue set [ (count _radioChannel -1), ["From","MsgType"] ]; // just using radiochannel array to get the 'count'
    AI_RCV_MsgQue set [ (count _radioChannel -1), ["To", "MsgType"]  ];
    GroupCount set [ (count _radioChannel -1), 0 ]; // set this themes group count to zero.
} foreach THEMEDATA;
_numThemes = count THEMEDATA;
//diag_log format ["##BaseOps: AI_XMT_MsgQue:%1",AI_XMT_MsgQue];
//diag_log format ["##BaseOps: _baeMsgs:%1",_baseMsgs];
//run loop till end of server
_startTime = time;
_sitrepDelta = _startTime;
while {true} do
{
private ["_i", "_xmtQ","_basemsgtype"];
    for [{_i=0},{_i< _numThemes},{_i = _i +1}] do
    {
        // check msqQue
        {
            _xmtQ = (AI_XMT_MsgQue select _i) select 1;
            _basemsgtype = _x select 0;
           // diag_log format ["##BaseOps: _xmtQ:%1  _basemsgtype:%2",_xmtQ, _basemsgtype];
            if ( _xmtQ == _basemsgtype) then  // if received a message from a Grp.
            {
                // process the message and transmit it
                // base callsign, aicallsign, message, radiochannel, range, position
                // range is unlimited and position not needed for BaseOps!
                [_baseCallsign select _i, (AI_XMT_MsgQue select _i) select 0, _x select 1,
                _radioChannel select _i, 0, 0] call FormatAndBroadcast;	
                // message sent so clear the que.
                AI_XMT_MsgQue set [_i, ["",""]];
                //Special Handling below!
            };
            // Perform BaseOps communication duties!
            // These are communications sent out by Base Ops or if other action is needed based upon a communication!
        }foreach (_baseMsgs select _i); 
         
        if (time > _sitrepDelta + 1800) then // ask for a SitRep every 30minutes
        {
            _sitrepDelta = time;
            AI_RCV_MsgQue set [_i, [_aiCallsign select _i, "SitRep"]];    //tell the AI
            _msg = ((_baseMsgs select _i) select 4) select 1; // get SitRep message text
            [_baseCallsign select _i, _aiCallsign select _i, _msg ,_radioChannel select _i, 0, 0] 
                            call FormatAndBroadcast;	     //tell the player.
        };      
    }; 
    sleep 2;
};

