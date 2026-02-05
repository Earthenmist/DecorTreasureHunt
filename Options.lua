local ADDON_NAME, DTH = ...;

local L = DTH.L;

local addonTitle = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Title");
addonTitle = addonTitle:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "");

local function EnsureDB()
    if not DecorTreasureHuntDB then
        DecorTreasureHuntDB = {};
    end

    if DecorTreasureHuntDB.autoAccept == nil then
        DecorTreasureHuntDB.autoAccept = true;
    end

    if DecorTreasureHuntDB.autoTurnIn == nil then
        DecorTreasureHuntDB.autoTurnIn = true;
    end
end

-- ============================================================
-- Addon Compartment Menu (Blizzard)
-- ============================================================

local function MenuGenerator(owner, rootDescription)
    EnsureDB();

    rootDescription:CreateTitle(addonTitle);

    rootDescription:CreateCheckbox(
        L.AUTO_ACCEPT,
        function()
            return DecorTreasureHuntDB.autoAccept;
        end,
        function()
            DecorTreasureHuntDB.autoAccept = not DecorTreasureHuntDB.autoAccept;
            local message = DecorTreasureHuntDB.autoAccept and L.AUTO_ACCEPT_ENABLED or L.AUTO_ACCEPT_DISABLED;
            print("|cffe6c619" .. addonTitle .. ":|r " .. message);
        end
    );

    rootDescription:CreateCheckbox(
        L.AUTO_TURNIN,
        function()
            return DecorTreasureHuntDB.autoTurnIn;
        end,
        function()
            DecorTreasureHuntDB.autoTurnIn = not DecorTreasureHuntDB.autoTurnIn;
            local message = DecorTreasureHuntDB.autoTurnIn and L.AUTO_TURNIN_ENABLED or L.AUTO_TURNIN_DISABLED;
            print("|cffe6c619" .. addonTitle .. ":|r " .. message);
        end
    );
end

AddonCompartmentFrame:RegisterAddon({
    text = addonTitle,
    icon = "dashboard-panel-homestone-teleport-button",
    func = function(frame, button)
        MenuUtil.CreateContextMenu(frame, MenuGenerator);
    end,
    funcOnEnter = function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT");
        GameTooltip:SetText(addonTitle, 1, 1, 1);
        GameTooltip:AddLine(L.TOOLTIP_TEXT, nil, nil, nil, true);
        GameTooltip:Show();
    end,
    funcOnLeave = function()
        GameTooltip:Hide();
    end
});

-- ============================================================
-- Blizzard Settings (Modern)
-- ============================================================

local function RegisterSettings()
    EnsureDB();

    if not Settings or not Settings.RegisterVerticalLayoutCategory then
        return;
    end

    local category = Settings.RegisterVerticalLayoutCategory(addonTitle);

    do
        local setting = Settings.RegisterAddOnSetting(
            category,
            "DTH_AUTO_ACCEPT",
            "autoAccept",
            DecorTreasureHuntDB,
            type(DecorTreasureHuntDB.autoAccept),
            L.AUTO_ACCEPT,
            true
        );

        Settings.CreateCheckbox(category, setting, L.AUTO_ACCEPT);
    end

    do
        local setting = Settings.RegisterAddOnSetting(
            category,
            "DTH_AUTO_TURNIN",
            "autoTurnIn",
            DecorTreasureHuntDB,
            type(DecorTreasureHuntDB.autoTurnIn),
            L.AUTO_TURNIN,
            true
        );

        Settings.CreateCheckbox(category, setting, L.AUTO_TURNIN);
    end

    local initializer = Settings.CreateSettingInitializerData();
    initializer.name = addonTitle;
    initializer.tooltip = L.OPTIONS_DESCRIPTION;

    Settings.RegisterAddOnCategory(category);
end

local settingsFrame = CreateFrame("Frame");
settingsFrame:RegisterEvent("ADDON_LOADED");
settingsFrame:SetScript("OnEvent", function(self, event, name)
    if name ~= ADDON_NAME then
        return;
    end

    RegisterSettings();
end);

-- Slash command (optional quick access)
SLASH_DECORTREASUREHUNT1 = "/dth";
SLASH_DECORTREASUREHUNT2 = "/decortreasurehunt";
SlashCmdList["DECORTREASUREHUNT"] = function()
    if Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(addonTitle);
    end
end;

-- Contributor: Earthenmist (PR: Blizzard Settings panel + localization)
