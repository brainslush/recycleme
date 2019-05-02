#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "ace_main",
            "ace_medical"
        };
        author = ECSTRING(main,Author);
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

class CfgMods {
    class PREFIX {
        dir = "@recycleme";
        name = "Recover Me";
        picture = "";
        hidePicture = "true";
        hideName = "true";
        actionName = "Website";
        action = ECSTRING(main,URL);
        description = "Issue Tracker: https://github.com/brainslush/recycleme/issues";
    };
};

#include "CfgEventHandlers.hpp"
