//Client Functions
if (isnil "IL_Functions") then
{
    IL_Functions = true;

    IL_Check_Transport_Fix = {
        _veh = _this select 0;
        _cargo = _this select 1;
        _cargo_pos = getPosATL _cargo;
        _cargo_dir = getDir _cargo;
        _cargo allowDamage false;
        _veh setSlingLoad _cargo;
        waitUntil{!isNull (getSlingLoad _veh)};
        sleep 2;
        _veh setSlingLoad objNull;
        _cargo setPosATL _cargo_pos;
        _cargo setDir _cargo_dir;
        _cargo enableRopeAttach false;
        _cargo allowDamage true;
    };

    IL_Heli_Check_Near_Transport = {
        private ["_veh", "_transports","_is_owner"];
        if (isNil "IL_Heli_Check_Near_Transport_Runner") then {
            IL_Heli_Check_Near_Transport_Runner = true;
            uiSleep 8;
            _veh = vehicle player;
            if (!(_veh isKindOf "Heli_Transport_04_base_F") && !(_veh isKindOf "Heli_Transport_01_base_F") && !(_veh isKindOf "Heli_Transport_02_base_F") && !(_veh isKindOf "Heli_Transport_03_unarmed_base_F")) exitWith {IL_Heli_Check_Near_Transport_Runner = nil};
            if (!(isNull (getSlingLoad _veh))) exitWith {IL_Heli_Check_Near_Transport_Runner = nil};
            _transports = (getPosATL _veh) nearEntities [["LandVehicle","Ship"], 20];
            {
                if (_veh canSlingLoad _x) then {
                    _x enableSimulation true;
                    _is_owner = [_x, player] call EPOCH_checkVehicleAccess;
                    if (_is_owner) then {
                        _x enableRopeAttach true;
                        //hint "Rope Attach Enabled";
                    } else {
                        _x enableRopeAttach false;
                        if(ropeAttachEnabled _x) then {
                            [_veh,_x] spawn IL_Check_Transport_Fix;
                        };
                        hint "Rope attach is disabled";
                    };
                };
            } forEach _transports;
            IL_Heli_Check_Near_Transport_Runner = nil;
        };
    };

    IL_Proccess_Vehicles = {
        if (isNil "IL_Proccess_Vehicles_Runner") then {
            IL_Proccess_Vehicles_Runner = true;
            uiSleep (IL_Check_Veh_Min + (random (IL_Check_Veh_Max - IL_Check_Veh_Min)));
            {
                if !(_x in vehicles) then
                {
                    IL_Veh_Array = IL_Veh_Array - [_x];
                };
            } forEach (IL_Veh_Array);
            {
                if (((typeOf _x) in (IL_Supported_Vehicles_All)) && !(_x in IL_Veh_Array)) then
                {
                    IL_Veh_Array = IL_Veh_Array + [_x];
                    _null = [_x] execVM "IgiLoad\IgiLoad.sqf";
                    waitUntil {scriptDone _null};
                };
            } forEach (vehicles);
            IL_Proccess_Vehicles_Runner = nil;
        };
    };
};