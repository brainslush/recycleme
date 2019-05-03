[
    QGVAR(Enabled), "CHECKBOX",
    [LSTRING(SettingEnabledName), LSTRING(SettingEnabledDesc)],
    LSTRING(Category),
    false, // default value
    true // isGlobal
] call CBA_settings_fnc_init;
[
    QGVAR(CanReturnIn), "LIST",
    [LSTRING(SettingCanReturnInName), LSTRING(SettingCanReturnInDesc)],
    LSTRING(Category),
    [
        [2,3,6,-1],
        [
            LSTRING(SettingAceFactility),
            LSTRING(SettingAceVehicle),
            LSTRING(SettingAceFacilityVehicle),
            LSTRING(SettingEverywhere)
        ],
        0
    ],
    true // isGlobal
] call CBA_settings_fnc_init;
[
    QGVAR(Delay), "EDITBOX",
    [LSTRING(SettingDelayName), LSTRING(SettingDelayDesc)],
    LSTRING(Category),
    "0", // default value
    true, // isGlobal
    {GVAR(RespawnDelay) = parseNumber GVAR(Delay);}
] call CBA_settings_fnc_init;
GVAR(RespawnDelay) = parseNumber GVAR(Delay);
