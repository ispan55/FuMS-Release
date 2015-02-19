// Messages Transmitted by AI!
// Inputs: From, To, Message, RadioChannel, Range, Position
RadioChatter = compile preprocessFileLineNumbers "HC\Encounters\Functions\RadioChatter.sqf";
private ["_from","_to","_msg","_channel","_range","_position","_formattedMsg","_mA","_start","_keyword","_keywords","_newMsg",
"_actionData","_leader","_missionName","_numAlive","_maxAlive"];
_from = _this select 0;
_to = _this select 1;
_msg = _this select 2;
_channel = _this select 3;
_range = _this select 4;
_position = _this select 5; // mission center
_actionData = _this select 6;  //  [ leader, missionname, #alive, startingalive] 
_leader = _actionData select 0;
_missionName = _actionData select 1;
_numAlive = _actionData select 2;
_maxAlive = _actionData select 3;
//KRON_StrToArray (Kronzky)
private["_i","_arr","_out"];
if (isNil "_msg") then { _msg = " ";};

_arr = toArray(_msg);
_out=[];
for "_i" from 0 to (count _arr)-1 do {
    _out=_out+[toString([_arr select _i])];
};
_mA = _out;
//diag_log format ["##FABroadcastAI: _out:%1",_out];
//diag_log format ["##FABroadcastAI: _msnName:%1 #Alive:%2 #max:%3 leader:%4",_missionName,_numAlive,_maxAlive,_leader];
//Find Keywords, place them in an array along with the position they start.
// _keyword ["keyword", start,
_keywords = [];
for [{_i=0},{_i < count _mA},{_i=_i+1}] do
{
    if ( _mA select _i == "<") then
    {
        _start = _i;
        _keyword = "";
        _i=_i+1;
        while {_mA select _i != ">"} do
        {     
           _keyword = format ["%1%2",_keyword, _mA select _i];
            _i = _i + 1;
        };
        _keywords = _keywords + [[_keyword, _start]];
    };
};
//diag_log format ["##FABroadcastAI: _keywords:%1", _keywords];

if (count _keywords > 0) then
{
    // add translations to the message
    _newMsg = "";
    for [{_i=0},{_i < count _mA},{_i=_i+1}] do
    {   
        {
            if (_x select 1 == _i) then
            {
                // do all the magic here
                switch (_x select 0) do
                {
                    case "DIST":
                    {
                        private ["_distance"];
                        _distance = _position distance _leader;
                        _distance = (round(_distance/100))*100;
                        _newMsg = format ["%1%2",_newMsg,_distance];
                        _i = _i + 6;
                    };
                    case "DIR":
                    {
                        private ["_xcntr","_ycntr","_xldr","_yldr","_xdif","_ydif","_deg","_quad","_dir"];
                        _xcntr = _position select 0;
                        _ycntr = _position select 1;
                        _xldr = (getPos _leader ) select 0;
                        _yldr = (getPos _leader ) select 1;
                        _xdif = _xldr - _xcntr; // + is quad I or IV
                        _ydif = _yldr - _ycntr; // + is quad I or II
                        if (_xldr >= _xcntr and _yldr >= _ycntr) then {_quad = 1;};
                        if (_xldr >= _xcntr and _yldr < _ycntr ) then {_quad = 4;};
                        if (_xldr < _xcntr and _yldr >= _ycntr) then {_quad = 2;};
                        if (_xldr < _xcntr and _yldr < _ycntr) then {_quad = 3;};
                        // arccos between 31-60 will be subcardinal
                        _deg = acos (_ydif/_xdif);
                        switch (_quad) do
                        {
                            case 1: 
                            {
                                if (_deg < 31) then {_dir = "East";};
                                if (_deg < 61) then {_dir = "North East";}
                                else {_dir = "North";  };       
                            };
                            case 2: 
                            {
                                if (_deg < 31) then {_dir = "West";};
                                if (_deg < 61) then {_dir = "North West";}
                                else {_dir = "North";  };       
                            };
                            case 3: 
                            {
                                if (_deg < 31) then {_dir = "West";};
                                if (_deg < 61) then {_dir = "South West";}
                                else {_dir = "South";  };       
                            };
                            case 4: 
                            {
                                if (_deg < 31) then {_dir = "East";};
                                if (_deg < 61) then {_dir = "South East";}
                                else {_dir = "South";};        
                            };                      
                        };
                        _newMsg = format ["%1%2",_newMsg,_dir];
                        _i = _i + 5;     
                    };
                    case "POS":
                    {
                        private ["_unitPos","_xpos","_ypos"];
                        _unitPos = getPos _leader;
                        _xpos = _unitPos select 0;
                        _ypos = _unitPos select 1;
                        _xpos = (round (_xpos/100))*100;
                        _ypos = (round (_ypos/100))*100;
                        _newMsg = format ["%1%2-%3",_newMsg,_xpos,_ypos];
                        _i=_i+5;
                    };
                    case "MSNNAME":
                    {
                        _newMsg = format ["%1%2",_newMsg, _missionName];
                        _i=_i+9;
                    };
                    case "#ALIVE":
                    {
                        _newMsg = format ["%1%2",_newMsg, _numAlive];
                        _i=_i+8;
                    };
                    case "#DEAD":
                    {
                        _newMsg = format ["%1%2",_newMsg, _maxAlive-_numAlive];
                        _i=_i+7; 
                    };
                    case "STATUS":
                    {
                        private ["_status"];
                        _status = "OPS Normal";
                        if (!isNull (_leader findNearestEnemy _leader))then{_status="Engaged with hostiles!"};
                        _newMsg = format ["%1%2",_newMsg, _status];
                        _i=_i+8;
                    };
                };        
            };
        }foreach _keywords;
        _newMsg = format ["%1%2", _newMsg, _mA select _i];
    };
}else
{
    _newMsg = _msg;  
};
_formattedMsg = format ["%1 , %2.: %3",_to, _from, _newMsg];	
if (isNil "_formattedMsg") then
{
    diag_log format ["##FormatAndBroadcastAI: ERROR! No Message _channel:%1, _pos:%2",_channel, _position];
    diag_log format ["##FormatAndBroadcastAI: To:%1 From:%2", _to, _from];
}else
{
    [_formattedMsg, _channel, _range, _position] call RadioChatter;
};
           