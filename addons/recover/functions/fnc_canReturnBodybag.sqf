#include "script_component.hpp"
/*
 * Author: brainslush
 * Check if bodybag can be returned
 *
 * Arguments:
 * 0: unit <OBJECT>
 *
 * Return Value:
 * Can return the bodybag <BOOL> 
 *
 * Example:
 * [player] call recvoerme_recover_fnc_canReturnBodybag
 *
 * Public: No
 */

//params["_target, _caller"];

if (!GVAR(Enabled)) exitWith {false};
// check location
private _isInFacility = (GVAR(CanReturnIn) % 2 == 0) && {[_player] call ace_medical_fnc_isInMedicalFacility};
private _isNearVehicle = (GVAR(CanReturnIn) % 3 == 0) && {[_target] call FUNC(isNearMedicalVehicle) || {[_caller] call FUNC(isNearMedicalVehicle)}};
private _canReturnHere = GVAR(CanReturnIn) == -1 || {_isInFacility || {_isNearVehicle}};

// check if bodybag belongs to a spectator
private _isSpectatorBodybag = false;
if (_canReturnHere) then {
    ([_target] call ace_dogtags_fnc_getDogtagData) params ["_bodybagName"];
    {
        private _name = [_x] call ace_common_fnc_getName;
        if (_name == _bodybagName) exitWith {
            _isSpectatorBodybag = true;
            _target setVariable [QGVAR(Spectator), _x, true];
        };
    } forEach ([] call ace_spectator_fnc_players);
};

_canReturnHere && _isSpectatorBodybag
