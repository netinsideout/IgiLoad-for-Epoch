private ["_vehicle","_allow","_caller","_player","_lockedOwner","_plyrGroup","_plyrUID","_lockOwner","_vehSlot","_isLocked","_vehLockHiveKey","_response"];
_vehicle =  _this select 0;
_player =  _this select 1;
_caller =  _this select 2;
if (isNull _vehicle) exitWith {};

if !([_caller,_this select 3] call EPOCH_server_getPToken) exitWith {};

_plyrUID = getPlayerUID _player;
_plyrGroup = _player getVariable["GROUP", ""];

_lockOwner = _plyrUID;
if (_plyrGroup != "") then {
    _lockOwner = _plyrGroup;
};

_lockedOwner = "-1";
_vehSlot = _vehicle getVariable["VEHICLE_SLOT", "ABORT"];
_vehLockHiveKey = format["%1:%2", (call EPOCH_fn_InstanceID), _vehSlot];
if (_vehSlot != "ABORT") then {
    _response = ["VehicleLock", _vehLockHiveKey] call EPOCH_server_hiveGETRANGE;
    if ((_response select 0) == 1 && typeName(_response select 1) == "ARRAY" && !((_response select 1) isEqualTo[])) then {
        _lockedOwner = _response select 1 select 0;
    };
};

_isLocked = locked _vehicle in [2, 3];
_allow = false;
//diag_log format["_isLocked is %1, _lockedOwner is %2, _lockOwner is %3",_isLocked,_lockedOwner,_lockOwner];
if (!_isLocked || _lockedOwner == _lockOwner || _lockedOwner == "-1") then {
     _allow = true;
};
//[["isVehicleOwner", _vehicle, _allow], (owner _player)] call EPOCH_sendPublicVariableClient;
EPOCH_allowVehicleAccess = [_vehicle, _player, _allow];
(owner _caller) publicVariableClient "EPOCH_allowVehicleAccess";
