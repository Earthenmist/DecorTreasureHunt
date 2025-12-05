local ADDON_NAME, DTH = ...;

local addonTitle = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Title");
local tomtomWaypointUid;

local function SetWaypoint(x, y)
    local mapId = C_Map.GetBestMapForUnit("player");
    if (not mapId) then
        return;
    end

    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(mapId, x, y));
    C_SuperTrack.SetSuperTrackedUserWaypoint(true);

    if (TomTom and TomTom.AddWaypoint) then
        tomtomWaypointUid = TomTom:AddWaypoint(mapId, x, y, { title = addonTitle });
    end
end

local function ClearWaypoint()
    C_Map.ClearUserWaypoint();

    if (TomTom and TomTom.RemoveWaypoint) then
        TomTom:RemoveWaypoint(tomtomWaypointUid);
    end
end

local function OnEvent(self, event, questId)
    local data = DTH.QuestData[questId];

    if (event == "PLAYER_ENTERING_WORLD") then
        for i = 1, C_QuestLog.GetNumQuestLogEntries() do
            local info = C_QuestLog.GetInfo(i);
            if (info and not info.isHeader) then
                data = DTH.QuestData[info.questID];

                if (data) then
                    questId = info.questID;
                    event = "QUEST_ACCEPTED";
                    break;
                end
            end
        end
    end

    if (not data) then
        return;
    end

    if (event == "QUEST_ACCEPTED") then
        SetWaypoint(data[1], data[2]);
    elseif (event == "QUEST_REMOVED") then
        ClearWaypoint();
    end
end

local Handler = CreateFrame("Frame");
Handler:RegisterEvent("QUEST_ACCEPTED");
Handler:RegisterEvent("QUEST_REMOVED");
Handler:RegisterEvent("PLAYER_ENTERING_WORLD");
Handler:SetScript("OnEvent", OnEvent);
