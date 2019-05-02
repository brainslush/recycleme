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

params["_target, _caller"];

if (!GVAR(enabled)) exitWith {false};
// check location
private _isInFacility = (GVAR(canReturnIn) % 2 == 0) && {[_target] call ace_medical_fnc_isInMedicalFacility || [_caller] call ace_medical_fnc_isInMedicalFacility};
private _isNearVehicle = (GVAR(canReturnIn) % 3 == 0) && {[_target] call FUNC(isNearMedicalVehicle) || [_caller] call FUNC(isNearMedicalVehicle)};
private _canReturnHere = GVAR(canReturnIn) == -1 || {_isInFacility || _isNearVehicle};

// check if bodybag belongs to a spectator
private _isSpectatorBodybag = false;
if (_canReturnHere) then {
    private _bodybagName = (_target getVariable [GVARACE(dogtag,dogtagData),[]]) params [];
    {
        if ([_x] call ace_common_fnc_getName == _bodybagName) exitWith {
            _isSpectatorBodybag = true;
            _target setVariable [QGVAR(spectator), _x];
        };
    } forEach ([] call ace_spectator_fnc_players);
};

_canReturnHere && _isSpectatorBodybag
