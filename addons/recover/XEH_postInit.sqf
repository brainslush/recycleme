#include "script_component.hpp"

// save global respawn time
GVAR(RespawnTime) = if (isNumber(missionConfigFile >> "RespawnDelay")) then {
    getNumber(missionConfigFile >> "RespawnDelay");
} else {0}; 

// add respawn event
[
    QGVAR(Respawn),{
        if (GVAR(RespawnDelay) >= 5) then {
            private _minutes = floor(GVAR(RespawnDelay) / 60);
            private _seconds = GVAR(RespawnDelay) % 60;
            private _timeStr = str()
            [[LLSTRING(NotificationRespawnPartA), GVAR(RespawnDelay), LLSTRING(NotificationRespawnPartBS)] joinString " "] call CBA_fnc_notify;

            [

            ] call CBA_fnc_addPerFrameHandler;
            [
                {
                    [[LLSTRING(NotificationRespawnPartA), GVAR(RespawnDelay), LLSTRING(NotificationRespawnPartBM)] joinString " "] call CBA_fnc_notify;
                }
            ] call CBA_fnc_waitAndExecute;
        };
        [
            {
                [false, false, false] call ace_spectator_fnc_setSpectator;
                setPlayerRespawnTime 0;
                [{setPlayerRespawnTime GVAR(RespawnTime)}] call CBA_fnc_execNextFrame;
            }, [], GVAR(RespawnDelay)
        ] call CBA_fnc_waitAndExecute;
    }
] call CBA_fnc_addEventHandler;

// add ace interaction
private _action = [
    QGVAR(Return),
    LLSTRING(Action),
    QPATHTOF(ui\logo.paa),
    FUNC(returnBodybag),
    FUNC(canReturnBodybag)
] call ace_interact_menu_fnc_createAction;

[
    "ACE_bodyBagObject",
    0,
    ["ACE_MainActions"],
    _action
] call ace_interact_menu_fnc_addActionToClass;
