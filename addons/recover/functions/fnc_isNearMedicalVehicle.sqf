#include "script_component.hpp"
/*
 * Author: brainslush
 * Check if a unit is near a designated medical vehicle
 *
 * Arguments:
 * 0: unit <OBJECT>
 *
 * Return Value:
 * Is near medical vehicle <BOOL>
 *
 * Example:
 * [player] call recvoerme_recover_fnc_isNearMedicalVehicle
 *
 * Public: No
 */

params ["_unit"];

// load cache
(_unit getVariable [QGVAR(cacheNearVehicle), [-9, false]]) params ["_expireTime", "_lastResult"];
if (CBA_missionTime < _expireTime) exitWith {_lastResult};

// check
private _isNearVehicle = false;
{
    if ((_vehicle getVariable [GVAR(medicClass), getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "attendant")]) > 0) exitWith {
        _isNearVehicle = true;
    };
} forEach _unit nearObjects 7.5;

// save cache
_unit setVariable [QGVAR(cacheNearVehicle), [CBA_missionTime + 1, _isNearVehicle]];

_isNearVehicle;
