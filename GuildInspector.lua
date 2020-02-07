local guildRoster = {}
local GuildRosterFontStringButton = {}
local GuildRosterFontStringPlayername = {}
local GuildRosterFontStringPlayerlevel = {}
local GuildRosterFontStringPlayerrank = {}
local GuildRosterFontStringPlayerzone = {}
local GuildRosterFontStringPlayernote = {}
local GuildRosterFontStringPlayerofficernote = {}
local GuildRosterFontStringPlayeronline = {}
local GuildRosterFontStringPlayerstatus = {}
local GuildRosterFontStringPlayerclassFileName = {}
local GuildRosterBackgroundFrame = {}

local showOffline = flase


SLASH_GUILDINSP1 = "/gi"
SLASH_GUILDINSP2 = "/guildinspector"
SlashCmdList["GUILDINSP"] = function(msg)
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
            guildRoster[index]["name"] = string.match(name, "[^-]+") --%w+
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

function GuildInspector_UpdateGuildRoster()  local rosterLenght = 0

  GuildInspector_BuildGuildRoster()
  GuildInspectorUiWindow:SetHeight(#guildRoster * 15 + 5)
  for index = 1, #guildRoster do
    v = guildRoster[index]
    if v.officernote ~= "" then
      GuildInspectorUiWindow:SetWidth(760)
      break
    end
  end

  for index, v in pairs(guildRoster) do 
    rosterLenght = rosterLenght + 1
      -- create frame if nessesarry
    if GuildRosterFontStringButton[index] == nil then
      GuildRosterFontStringButton[index] = CreateFrame('Button', "GuildRosterFontStringPlayerlevel" .. index, GuildInspectorUiWindow)
      GuildRosterFontStringButton[index]:SetPoint('TOPLEFT', GuildInspectorUiWindow, 'TOPLEFT', 3, (12 - 15 * index)            )
      GuildRosterFontStringButton[index]:SetWidth(120)
      GuildRosterFontStringButton[index]:SetHeight(15)
      GuildRosterFontStringButton[index]:SetScript('OnClick', GuildInspector_OnClickGuildMemdber)
      GuildRosterFontStringButton[index]:SetText("myestttext")
      GuildRosterFontStringButton[index]:SetID(index)
      --background Frame
      if index % 2 == 0 then
        GuildRosterBackgroundFrame[index] = CreateFrame("Button", nil, GuildInspectorUiWindow, nil)
        GuildRosterBackgroundFrame[index]:SetSize(GuildInspectorUiWindow:GetWidth() - 5, 15)
        GuildRosterBackgroundFrame[index]:SetPoint("LEFT", GuildRosterFontStringButton[index], "CENTER", -60, 0)
        GuildRosterBackgroundFrame[index]:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
        GuildRosterBackgroundFrame[index]:SetBackdropColor(0 ,0 ,0 ,0.4)
        GuildRosterBackgroundFrame[index]:RegisterForDrag("LeftButton")
        GuildRosterBackgroundFrame[index]:SetFrameLevel(0)
      end      
      --nr
      --GuildRosterFontStringPlayerlevel[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
      --GuildRosterFontStringPlayerlevel[index]:SetText(index)
      --GuildRosterFontStringPlayerlevel[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index], 'TOPLEFT', -50, -2)
      --Level
      GuildRosterFontStringPlayerlevel[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
      GuildRosterFontStringPlayerlevel[index]:SetText(v.level)
      GuildRosterFontStringPlayerlevel[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index], 'TOPLEFT', 5, -2)
      --name
      GuildRosterFontStringPlayername[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
      GuildRosterFontStringPlayername[index]:SetText(v.name)
      GuildRosterFontStringPlayername[index]:SetTextColor(GuildInspector_GetClassClolor(v.classFileName))
      GuildRosterFontStringPlayername[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index], 'TOPLEFT', 30, -2)
      --rank
      GuildRosterFontStringPlayerrank[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
      GuildRosterFontStringPlayerrank[index]:SetText(v.rank)
      GuildRosterFontStringPlayerrank[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index], 'TOPLEFT', 120, -2) --90
      --zone
      GuildRosterFontStringPlayerzone[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
      GuildRosterFontStringPlayerzone[index]:SetText(v.zone)
      GuildRosterFontStringPlayerzone[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index], 'TOPLEFT', 195, -2)--145
      --note
      GuildRosterFontStringPlayernote[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
      GuildRosterFontStringPlayernote[index]:SetText(v.note)
      GuildRosterFontStringPlayernote[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index], 'TOPLEFT', 350, -2)--210
      --officernote
      GuildRosterFontStringPlayerofficernote[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
      GuildRosterFontStringPlayerofficernote[index]:SetText(v.officernote)
      GuildRosterFontStringPlayerofficernote[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index], 'TOPLEFT', 550, -2) --längemax 220 
    else
      GuildRosterFontStringButton[index]:Show()
      GuildRosterFontStringPlayerlevel[index]:SetText(v.level)
      GuildRosterFontStringPlayername[index]:SetText(v.name)
      GuildRosterFontStringPlayername[index]:SetTextColor(GuildInspector_GetClassClolor(v.classFileName))
      GuildRosterFontStringPlayerzone[index]:SetText(v.zone)
      GuildRosterFontStringPlayernote[index]:SetText(v.note)
      GuildRosterFontStringPlayerofficernote[index]:SetText(v.officernote)
      GuildRosterFontStringPlayerrank[index]:SetText(v.rank)   
    end
  end 
  for index = #guildRoster + 1,  #GuildRosterFontStringButton do 
    GuildRosterFontStringButton[index]:Hide()
    if GuildRosterBackgroundFrame[index] then GuildRosterBackgroundFrame[index]:Hide() end
  end
end

function GuildInspector_OnClickGuildMemdber(self, button, down)
  local name = guildRoster[tonumber(string.match(self:GetName(), '%d+'))].name
  if not IsShiftKeyDown() then
    ChatFrame_OpenChat(string.format("/w %s ",name))    
    GuildInspectorUiWindow:Hide()
  else
    InviteUnit(name)
  end
end

function GuildInspector_OnLoad()
    GuildInspector_RegisterEvents()
    GuildInspector_FrameSetup()

    --GuildRoster_SortByColumn_old = GuildRoster_SortByColumn
end

function GuildInspector_OnEvent(self, event, ...)
    if GuildInspectorUiWindow:IsVisible() and event == "GUILD_ROSTER_UPDATE" then
      GuildInspector_UpdateGuildRoster()
    end
end

function GuildInspector_RegisterEvents()
    GuildInspector:RegisterEvent('GUILD_ROSTER_UPDATE')
end

function GuildInspector_TestButton()
  pPrint("Test")
  GuildRoster_SortByColumn("Name")
end

function GuildInspector_FrameSetup()
  --pPrint("GuildInspectorScrollFrame setup")
  --GuildInspectorScrollFrame = CreateFrame("ScrollFrame", nil, GuildInspectorUiWindow, "UiPanelScrollFrameTemplate")
  --GuildInspectorScrollFrame:SetPoint("TOPLEFT", GuildInspectorUiWindow, "TOPLEFT", 0, 0)
  --GuildInspectorScrollFrame:SetPoint("BOTTOMRIGHT", GuildInspectorUiWindow, "BOTTOMRIGHT", 0, 0)
end
-- function GuildRoster_SortByColumn(column)
--   pPrint("GuildRoster_SortByColumn(column)" .. column)
--   GuildRoster_SortByColumn_old(column)
-- end

function pPrint(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg)
end

function GuildInspector_ToggleUiWindow()
    if GuildInspectorUiWindow:IsVisible() then
        GuildInspectorUiWindow:Hide()
    else
        GuildRoster()
        GuildInspector_UpdateGuildRoster()
        GuildInspectorUiWindow:Show()
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
