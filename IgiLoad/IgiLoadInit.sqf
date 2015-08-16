waituntil {!isnil "bis_fnc_init"};
//if (isDedicated) exitwith {};
//if (isServer) exitwith {};
//waitUntil { !(isNull player) };
waitUntil { time > 0 };

IL_EV_Count = 0;
IL_Veh_Array = [];

if (isServer || isDedicated) then {
    EPOCH_server_checkVehicleAccess = compileFinal preprocessFileLineNumbers "IgiLoad\EPOCH_server_checkVehicleAccess.sqf";
    "EPOCH_checkVehicleAccess_PVS" addPublicVariableEventHandler{(_this select 1 )call EPOCH_server_checkVehicleAccess};
} else {
    EPOCH_checkVehicleAccess = compileFinal preprocessFileLineNumbers "IgiLoad\EPOCH_client_checkVehicleAccess.sqf";
};

//cutText ["IgiLoad is loading. Please wait...","PLAIN",2];
//sleep (random 30);
//cutText [Format ["IgiLoad init Player: %1", Player],"PLAIN",2];

_null = [Player] execVM "IgiLoad\IgiLoad.sqf";
waitUntil {scriptDone _null};

sleep (random (IL_Check_Veh_Max - IL_Check_Veh_Min));
{
	if ((typeOf _x) in (IL_Supported_Vehicles_All)) then
	{
		IL_Veh_Array = IL_Veh_Array + [_x];
		_null = [_x] execVM "IgiLoad\IgiLoad.sqf";
		waitUntil {scriptDone _null};
	};
} forEach (vehicles);

call compileFinal preprocessFileLineNumbers "IgiLoad\IgiLoadTaru.sqf";
if (hasInterface && !isDedicated) then {
    call compileFinal preprocessFileLineNumbers "IgiLoad\IgiLoadClientFunctions.sqf";
};

//cutText ["IgiLoad loaded. Have fun :)","PLAIN",2];
if (hasInterface && !isDedicated) then {
    IL_Main_Loop = {
        if (isNil "IL_Main_Loop_Runinng") then {
            IL_Main_Loop_Runinng = true;
            while {true} do
            {
                uiSleep 2;
                [] spawn IL_Taru_Init;
                [] spawn IL_Heli_Check_Near_Transport;
                [] spawn IL_Proccess_Vehicles;
            };
        };
    };
    [] spawn IL_Main_Loop;
    IL_Main_Loop_EH_Respawn = player addEventHandler ["Respawn", "[] spawn IL_Main_Loop;"];
};
