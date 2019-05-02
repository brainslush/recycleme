#include "script_component.hpp"

// add respawn event
[
    QGVAR(Respawn),
    {
        if (GVAR(RespawnDelay) >= 5)  then {
            [LSTRING(NotificationRespawnPartA) + GVAR(RespawnDelay) + LSTRING(NotificationRespawnPartB)] call CBA_fnc_notify;
        };
        [
            {
                [false, false, false] call ace_spectator_fnc_setSpectator;
                setPlayerRespawnTime 0;
            },
            [],
            GVAR(RespawnDelay)
        ] call CBA_fnc_waitAndExecute;
    }
] call CBA_fnc_addEventHandler;

// add ace interaction
private _action = [
    QGVAR(return),
    LSTRING(Action),
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
