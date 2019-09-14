guildRoster = {}
RaidRosterFontStringButton = {}
RaidRosterFontStringPlayername = {}
RaidRosterFontStringPlayerlevel = {}
RaidRosterFontStringPlayerrank = {}
RaidRosterFontStringPlayerzone = {}
RaidRosterFontStringPlayernote = {}
RaidRosterFontStringPlayerofficernote = {}
RaidRosterFontStringPlayeronline = {}
RaidRosterFontStringPlayerstatus = {}
RaidRosterFontStringPlayerclassFileName = {}

showOffline = flase







SLASH_GUILDINSPECTOR1, SLASH_GUILDINSPECTOR2 = '/gi', '/guildinspector'; -- 3.
function SlashCmdList.GUILDINSPECTOR(msg, editbox) -- 4.
    GuildInspector_ToggleUiWindow()
end




function GuildInspector_BuildGuildRoster()
    guildRoster = {}
    numGuildMembers = GetNumGuildMembers()
    index = 1
    for i = 1, numGuildMembers do
        name, rank, _, level, _, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(i)
        if online or showOffline  then
            guildRoster[index] = {}
            guildRoster[index]["name"] = string.match(name, "%w+")
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
    for index, v in pairs(guildRoster) do
            -- create frame if nessesarry
        if RaidRosterFontStringButton[index] == nil then
            RaidRosterFontStringButton[index] = CreateFrame('Button', nil, GuildInspectorUiWindow)
            RaidRosterFontStringButton[index]:SetPoint('TOPLEFT', GuildInspectorUiWindow, 'TOPLEFT', 3, (12 - 15 * index)            )
            RaidRosterFontStringButton[index]:SetWidth(GuildInspectorUiWindow:GetWidth()- 20)
            RaidRosterFontStringButton[index]:SetHeight(15)
            --RaidRosterFontStringButton[index]:SetBackdrop({bgFile = 'Interface\\DialogFrame\\UI-DialogBox-Background'})
            RaidRosterFontStringButton[index]:SetScript('OnClick', GuildInspector_OnClickGuildMemdber)
            --RaidRosterFontStringButton[index]:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE, MONOCHROME")
            RaidRosterFontStringButton[index]:SetText("myestttext")
            RaidRosterFontStringButton[index]:SetID(index)

            --Level
            RaidRosterFontStringPlayerlevel[index] = GuildInspectorUiWindow:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
            RaidRosterFontStringPlayerlevel[index]:SetText(v.level)
            RaidRosterFontStringPlayerlevel[index]:SetPoint('TOPLEFT', RaidRosterFontStringButton[index], 'TOPLEFT', 5, -2)
            --name
            RaidRosterFontStringPlayername[index] = GuildInspectorUiWindow:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
            RaidRosterFontStringPlayername[index]:SetText(v.name)
            RaidRosterFontStringPlayername[index]:SetTextColor(GuildInspector_GetClassClolor(v.classFileName))
            RaidRosterFontStringPlayername[index]:SetPoint('TOPLEFT', RaidRosterFontStringButton[index], 'TOPLEFT', 30, -2)
            --zone
            RaidRosterFontStringPlayerzone[index] = GuildInspectorUiWindow:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
            RaidRosterFontStringPlayerzone[index]:SetText(v.zone)
            RaidRosterFontStringPlayerzone[index]:SetPoint('TOPLEFT', RaidRosterFontStringButton[index], 'TOPLEFT', 120, -2)
            --note
            RaidRosterFontStringPlayernote[index] = GuildInspectorUiWindow:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
            RaidRosterFontStringPlayernote[index]:SetText(v.note)
            RaidRosterFontStringPlayernote[index]:SetPoint('TOPLEFT', RaidRosterFontStringButton[index], 'TOPLEFT', 250, -2)
            --officernote
            RaidRosterFontStringPlayerofficernote[index] = GuildInspectorUiWindow:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
            RaidRosterFontStringPlayerofficernote[index]:SetText(v.officernote)
            RaidRosterFontStringPlayerofficernote[index]:SetPoint('TOPLEFT', RaidRosterFontStringButton[index], 'TOPLEFT', 460, -2) --längemax 220 
            --rank
            RaidRosterFontStringPlayerrank[index] = GuildInspectorUiWindow:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
            RaidRosterFontStringPlayerrank[index]:SetText(v.rank)
            RaidRosterFontStringPlayerrank[index]:SetPoint('TOPLEFT', RaidRosterFontStringButton[index], 'TOPLEFT', 680, -2)
        else
            RaidRosterFontStringPlayerlevel[index]:SetText(v.level)
            RaidRosterFontStringPlayername[index]:SetText(v.name)
            RaidRosterFontStringPlayername[index]:SetTextColor(GuildInspector_GetClassClolor(v.classFileName))
            RaidRosterFontStringPlayerzone[index]:SetText(v.zone)
            RaidRosterFontStringPlayernote[index]:SetText(v.note)
            RaidRosterFontStringPlayerofficernote[index]:SetText(v.officernote)
            RaidRosterFontStringPlayerrank[index]:SetText(v.rank)      
        end
    end
end

function GuildInspector_OnClickGuildMemdber()
    pPrint("clicked on Guild memeber")
end

function GuildInspector_OnLoad()
    GuildInspector_RegisterEvents()
end

function GuildInspector_OnEvent(self, event, ...)
    if event == "GUILD_ROSTER_UPDATE" then
        GuildInspector_UpdateGuildRoster()
    end
end

function GuildInspector_RegisterEvents()
    GuildInspector:RegisterEvent('GUILD_ROSTER_UPDATE')
end

function GuildInspector_TestButton()
    GuildInspector_UpdateGuildRoster()
end

function pPrint(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg)
end

function GuildInspector_ToggleUiWindow()
    if GuildInspectorUiWindow:IsVisible() then
        GuildInspectorUiWindow:Hide()
    else
        GuildInspectorUiWindow:Show()
        GuildInspector_UpdateGuildRoster()
    end
end

function GuildInspector_GetClassClolor(class)
    if class == "WARLOCK"  then
      return 0.58, 0.51, 0.79,1
    elseif class == "DRUID"  then
      return 1.00, 0.49, 0.04,1
    elseif class == "ROGUE"  then
      return 1.00, 0.96, 0.41,1
    elseif class == "HUNTER"  then
      return 0.67, 0.83, 0.45,1
    elseif class == "MAGE"  then
      return 0.41, 0.80, 0.94,1
    elseif class == "SHAMAN"  then
      return 0.00, 0.44, 0.87,1
    elseif class == "PRIEST"  then
      return 1.00, 1.00, 1.00,1
    elseif class == "PALADIN"  then
      return 0.96, 0.55, 0.73,1
    elseif class == "WARRIOR"  then
      return 0.78, 0.61, 0.43,1
    end
  end

-- local frameEvent = CreateFrame("Frame")
-- frameEvent:this:RegisterEvent("CHAT_MSG_CHANNEL")
-- frameEvent:this:RegisterEvent("CHAT_MSG_WHISPER")
-- frameEvent:this:RegisterEvent("CHAT_MSG_SAY")
-- frameEvent:this:RegisterEvent("CHAT_MSG_YELL")
-- frameEvent:SetScript("OnEvent", eventHandler)
