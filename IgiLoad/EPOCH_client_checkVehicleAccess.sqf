private ["_player","_isLocked","_player2","_veh","_is_owner","_args","_veh2","_allow","_i","_received"];
EPOCH_allowVehicleAccess = [];
_veh = _this select 0;
_player = _this select 1;
_is_owner = false;
_isLocked = locked _veh in[2, 3];
if (!_isLocked) exitWith {_is_owner = true; _is_owner};
EPOCH_checkVehicleAccess_PVS = [_veh, _player, player, Epoch_personalToken];
publicVariableServer "EPOCH_checkVehicleAccess_PVS";
_i = 0;
_received = false;
while {true} do
{
    uiSleep 0.5;
    _i = _i + 1;
    if (count EPOCH_allowVehicleAccess == 3) exitWith {_received = true;};
    //if not received then exiting
    if (_i == 30) exitWith {_received = false;};
};
//diag_log format["_received == %1",_received];
if (!_received) exitWith {_is_owner};
//diag_log format["EPOCH_allowVehicleAccess == %1",EPOCH_allowVehicleAccess];
_veh2 = EPOCH_allowVehicleAccess select 0;
_player2 = EPOCH_allowVehicleAccess select 1;
_allow = EPOCH_allowVehicleAccess select 2;
EPOCH_allowVehicleAccess = [];
//diag_log format["_veh is %1, _veh2 is %2, _player is %3, _player2 is %4, _allow is %5",_veh,_veh2,_player,_player2,_allow];
if ((_veh2 == _veh) && (_player == _player2)) then {
     _is_owner = _allow;
};
_is_owner