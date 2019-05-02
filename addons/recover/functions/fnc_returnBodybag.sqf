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

private _spectator = _bodybag getVariable [QGVAR(spectator), nullObj];
if (_spectator == objNull) exitWith {};

[QGVAR(respawn),[],_spectator] call CBA_fnc_targetEvent;
deleteVehicle _bodybag;
