local ADDON_NAME = ...;

local L = {
    ["enUS"] = {
        AUTO_ACCEPT = "Auto-Accept Quest",
        AUTO_TURNIN = "Auto Turn-In Quest",
        TOOLTIP_TEXT = "Click to configure auto-accept and auto turn-in settings",
        AUTO_ACCEPT_ENABLED = "Auto-Accept has been |cnGREEN_FONT_COLOR:enabled|r.",
        AUTO_ACCEPT_DISABLED = "Auto-Accept has been |cnRED_FONT_COLOR:disabled|r.",
        AUTO_TURNIN_ENABLED = "Auto Turn-In has been |cnGREEN_FONT_COLOR:enabled|r.",
        AUTO_TURNIN_DISABLED = "Auto Turn-In has been |cnRED_FONT_COLOR:disabled|r.",
    },
    ["deDE"] = {
        AUTO_ACCEPT = "Quest automatisch annehmen",
        AUTO_TURNIN = "Quest automatisch abgeben",
        TOOLTIP_TEXT = "Klicken um automatisches Annehmen und Abgeben zu konfigurieren",
        AUTO_ACCEPT_ENABLED = "Automatisches Annehmen wurde |cnGREEN_FONT_COLOR:aktiviert|r.",
        AUTO_ACCEPT_DISABLED = "Automatisches Annehmen wurde |cnRED_FONT_COLOR:deaktiviert|r.",
        AUTO_TURNIN_ENABLED = "Automatisches Abgeben wurde |cnGREEN_FONT_COLOR:aktiviert|r.",
        AUTO_TURNIN_DISABLED = "Automatisches Abgeben wurde |cnRED_FONT_COLOR:deaktiviert|r.",
    }
};
L = L[GetLocale()] or L["enUS"];

local addonTitle = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Title");
addonTitle = addonTitle:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "");

local function MenuGenerator(owner, rootDescription)
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
