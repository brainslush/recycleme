#include "script_component.hpp"

// save global respawn time
GVAR(RespawnTime) = if (isNumber(missionConfigFile >> "RespawnDelay")) then {
    getNumber(missionConfigFile >> "RespawnDelay");
} else {0}; 

// add respawn event
[
    QGVAR(Respawn),{
        // handle notifications
        private _notifyPrior = {
            params["_notifyTime"];

            private _seconds = _notifyTime * 60;
            if (GVAR(RespawnDelay) > _seconds) then {
                [
                    {   
                        if (GVAR(Notify)) then {
                            [[
                                LLSTRING(NotificationRespawnPartA),
                                _this,
                                LLSTRING(NotificationRespawnPartBM)
                            ] joinString " "] call CBA_fnc_notify;
                        };
                    }, _notifyTime, GVAR(RespawnDelay) - _seconds
                ] call CBA_fnc_waitAndExecute;
            };
        };

        private _minutes = floor(GVAR(RespawnDelay) / 60);
        private _seconds = GVAR(RespawnDelay) % 60;
        private _notifyTimes = [60, 45, 30, 15, 10, 5, 1];

        if (GVAR(RespawnDelay) >= 5) then {
            if (GVAR(Notify) && {!(_minutes in _notifyTimes) || {_seconds > 5}}) then {
                [[
                    LLSTRING(NotificationRespawnPartA),
                    str(_minutes) + ":" + str(_seconds),
                    LLSTRING(NotificationRespawnPartB)
                ] joinString " "] call CBA_fnc_notify;
            };
            {
                [_x] call _notifyPrior;
            } forEach _notifyTimes;
        };
        // handle respawn
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
