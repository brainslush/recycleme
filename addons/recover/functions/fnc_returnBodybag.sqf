#include "script_component.hpp"
/*
 * Author: brainslush
 * Handle bodybag and trigger player respawn
 *
 * Arguments:
 * 0: bodybag <OBJECT>
 *
 * Return Value:
 * Is near medical vehicle <BOOL>
 *
 * Example:
 * [bag] call recvoerme_recover_fnc_returnBodybag
 *
 * Public: No
 */

params ["_bodybag"];

private _spectator = _bodybag getVariable [QGVAR(Spectator), objNull];
[
    5, [_bodybag, _spectator], {
        params ["_data"];
        _data params ["_bodybag", "_spectator"];
        if (_spectator == objNull) exitWith {};
        [QGVAR(Respawn), [], _spectator] call CBA_fnc_targetEvent;
        deleteVehicle _bodybag;
    }, {}, LLSTRING(ProgressText)
] call ace_common_fnc_progressBar;
