local guildRoster = {}
local guildRosterLength = 0
GuildInspector_showOffline = false

GuildInspector_BACKDROP = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileEdge = true,
    tileSize = 32,
    edgeSize = 8,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
}

GuildInspector_BACKDROP_SIMPLE = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeSize = 1,
}

GuildInspector_COLOR_BACKGROUND = CreateColor(0.1, 0.1, 0.1)
GuildInspector_COLOR_SCROLLENTRY = CreateColor(0, 0, 0)

BINDING_HEADER_GUILDINSPECTOR = "GuildInspector"

SLASH_GUILDINSP1 = "/gi"
SLASH_GUILDINSP2 = "/guildinspector"
SlashCmdList["GUILDINSP"] = function(msg)
    GuildInspector_ToggleUiWindow()
end

function GuildInspector_BuildGuildRoster()
    guildRoster = {}
    local index = 1
    for i = 1, GetNumGuildMembers() do
        name, rank, _, level, _, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(i)
        if online or GuildInspector_showOffline then
            guildRoster[index] = {}
            guildRoster[index]["name"] = string.match(name, "[^-]+")
            guildRoster[index]["rank"] = rank
            guildRoster[index]["level"] = level
            guildRoster[index]["zone"] = zone
            guildRoster[index]["note"] = note
            guildRoster[index]["officernote"] = officernote
            guildRoster[index]["online"] = online
            guildRoster[index]["status"] = status
            guildRoster[index]["classFileName"] = classFileName
            index = index + 1
        end
    end
end

function GuildInspector_UpdateGuildRoster()

    GuildInspector_BuildGuildRoster()

    for index = 1, #guildRoster do
        if guildRoster[index].officernote ~= "" then
            _G["GuildInspectorUiWindow"]:SetWidth(760)
            _G["GuildInspectorUiWindow_OfficerNote"]:Show()
            _G["GuildInspectorUiWindow_ShowOffline"]:SetPoint("LEFT", _G["GuildInspectorUiWindow_SortNote"], 310, 0)
            break
        end
    end

    local MaxGuildInspectorUiWindowSize = 55
    if #guildRoster > MaxGuildInspectorUiWindowSize then
        _G["GuildInspectorUiWindow"]:SetHeight(MaxGuildInspectorUiWindowSize * 15 + 30)
        _G["GuildInspectorUiWindow_ScrollFrameScrollBar"]:Show()
        _G["GuildInspectorUiWindow_ScrollFrame"]:SetPoint("BOTTOMRIGHT", _G["GuildInspectorUiWindow"], "BOTTOMRIGHT", -26, 5)
    else
        _G["GuildInspectorUiWindow"]:SetHeight(#guildRoster * 15 + 30)
        _G["GuildInspectorUiWindow_ScrollFrameScrollBar"]:Hide()
        _G["GuildInspectorUiWindow_ScrollFrame"]:SetPoint("BOTTOMRIGHT", _G["GuildInspectorUiWindow"], "BOTTOMRIGHT", -3, 5)
    end

    for entry, v in pairs(guildRoster) do

        if not _G["GuildInspector_Entry" .. entry] then
            guildRosterLength = entry
            local frame = CreateFrame("FRAME", "GuildInspector_Entry" .. entry, _G["GuildInspector_ScrollFrame_Container"], "GuildInspectorScrollFrameEntry")
            if entry == 1 then
                _G["GuildInspector_Entry" .. entry]:SetPoint("TOPLEFT", _G["GuildInspector_ScrollFrame_Container"], "TOPLEFT")
            else
                _G["GuildInspector_Entry" .. entry]:SetPoint("TOPLEFT", _G["GuildInspector_Entry" .. entry-1], "BOTTOMLEFT")
            end
        end

        _G["GuildInspector_Entry" .. entry .. "_LEVEL"]:SetText(v.level)
        _G["GuildInspector_Entry" .. entry .. "_NAME"]:SetText(v.name)
        _G["GuildInspector_Entry" .. entry .. "_RANK"]:SetText(v.rank)
        _G["GuildInspector_Entry" .. entry .. "_ZONE"]:SetText(v.zone)
        _G["GuildInspector_Entry" .. entry .. "_NOTE"]:SetText(v.note)
        _G["GuildInspector_Entry" .. entry .. "_OFFICERNOTE"]:SetText(v.officernote)
        _G["GuildInspector_Entry" .. entry]:Show()

        if entry % 2 == 0 then
            _G["GuildInspector_Entry" .. entry]:SetBackdropColor(1,1,1,0)
        end

        if v.online == true then
            _G["GuildInspector_Entry" .. entry .. "_NAME"]:SetTextColor(GuildInspector_GetClassClolor(v.classFileName))
        else
            _G["GuildInspector_Entry" .. entry .. "_NAME"]:SetTextColor(0.6, 0.6, 0.6, 1)
        end
    end

    for entry = #guildRoster + 1, guildRosterLength do
        _G["GuildInspector_Entry" .. entry]:Hide()
    end
end

function GuildInspector_OnClickGuildMemdber(self, button, down)
    local name = _G[self:GetParent():GetName() .. "_NAME"]:GetText()
    if not IsShiftKeyDown() then
        ChatFrame_OpenChat(string.format("/w %s ",name .. "-" .. GetRealmName()))
        GuildInspectorUiWindow:Hide()
    else
        InviteUnit(name)
    end
end

function GuildInspector_OnLoad()
    GuildInspector_RegisterEvents()
end

function GuildInspector_OnEvent(event)
    if GuildInspectorUiWindow:IsVisible() and event == "GUILD_ROSTER_UPDATE" then
        GuildInspector_UpdateGuildRoster()
    end
end

function GuildInspector_RegisterEvents()
    GuildInspectorUiWindow:RegisterEvent('GUILD_ROSTER_UPDATE')
end

function GuildInspector_Sort(self)
    local text = self:GetText()
    if text == "Lvl" then
        SortGuildRoster("level")
    elseif text == "Name" then
        SortGuildRoster( "name" )
    elseif text == "(Class)" then
        SortGuildRoster( "class" )
    elseif text == "Rank" then
        SortGuildRoster( "rank" )
    elseif text == "Zone" then
        SortGuildRoster( "zone" )
    elseif text == "Note" then
        SortGuildRoster( "note" )
    end
    PlaySound(856)
end

function GuildInspector_ToggleUiWindow()
    if GuildInspectorUiWindow:IsVisible() then
        GuildInspectorUiWindow:Hide()
    else
        GuildInspector_UpdateGuildRoster()
        GuildRoster()
        GuildInspectorUiWindow:Show()
    end
end

function GuildInspector_GetClassClolor(class)
    if class == "WARLOCK" then
        return 0.58, 0.51, 0.79, 1
    elseif class == "DRUID" then
        return 1.00, 0.49, 0.04, 1
    elseif class == "ROGUE" then
        return 1.00, 0.96, 0.41, 1
    elseif class == "HUNTER" then
        return 0.67, 0.83, 0.45, 1
    elseif class == "MAGE" then
        return 0.41, 0.80, 0.94, 1
    elseif class == "SHAMAN" then
        return 0.00, 0.44, 0.87, 1
    elseif class == "PRIEST" then
        return 1.00, 1.00, 1.00, 1
    elseif class == "PALADIN" then
        return 0.96, 0.55, 0.73, 1
    elseif class == "WARRIOR" then
        return 0.78, 0.61, 0.43, 1
    elseif class == "DEATHKNIGHT" then
        return 0.77, 0.12, 0.23, 1
    elseif class == "DEMONHUNTER" then
        return 0.64, 0.19 ,0.79, 1
    elseif class == "EVOKER" then
        return 0.20, 0.58, 0.50, 1
    elseif class == "MONK" then
        return 0.00, 1.00, 0.60, 1
    end
end