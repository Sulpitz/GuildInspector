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

local showOffline = false


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

function GuildInspector_UpdateGuildRoster()
  local rosterLenght = 0
  
  --GuildRoster()

  GuildInspector_BuildGuildRoster()
  GuildInspectorUiWindow:SetHeight(#guildRoster * 15 + 5 + 15)
  for index = 1, #guildRoster do
    v = guildRoster[index]
    if v.officernote ~= "" then
      GuildInspectorUiWindow:SetWidth(760)
      GuildInspectorUiWindowSortOfficerNote:Show()
      break
    end
  end

  for index, v in pairs(guildRoster) do 
    rosterLenght = rosterLenght + 1
      -- create frame if nessesarry
    if GuildRosterFontStringButton[index] == nil then
      GuildRosterFontStringButton[index] = CreateFrame('Button', "GuildRosterFontStringPlayerlevel" .. index, GuildInspectorUiWindow)
      GuildRosterFontStringButton[index]:SetPoint('TOPLEFT', GuildInspectorUiWindow, 'TOPLEFT', 3, (12 - 15 * index - 15)            )
      GuildRosterFontStringButton[index]:SetWidth(120)
      GuildRosterFontStringButton[index]:SetHeight(15)
      GuildRosterFontStringButton[index]:SetScript('OnClick', GuildInspector_OnClickGuildMemdber)
      GuildRosterFontStringButton[index]:SetText("myestttext")
      GuildRosterFontStringButton[index]:SetID(index)
      --background Frame
      if index % 2 == 0 then
        GuildRosterBackgroundFrame[index] = CreateFrame("Button", nil, GuildInspectorUiWindow, nil)
        GuildRosterBackgroundFrame[index]:SetWidth(GuildInspectorUiWindow:GetWidth() - 5)
        GuildRosterBackgroundFrame[index]:SetHeight(15)
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
      GuildRosterFontStringPlayername[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index], 'TOPLEFT', 
      25 + select(4, GuildRosterFontStringPlayerlevel[index]:GetPoint()), 
      -2)
      --rank
      GuildRosterFontStringPlayerrank[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
      GuildRosterFontStringPlayerrank[index]:SetText(v.rank)
      GuildRosterFontStringPlayerrank[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index], 'TOPLEFT',
      90 + select(4, GuildRosterFontStringPlayername[index]:GetPoint()), 
      -2)
      --zone
      GuildRosterFontStringPlayerzone[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
      GuildRosterFontStringPlayerzone[index]:SetText(v.zone)
      GuildRosterFontStringPlayerzone[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index],
      90 + select(4, GuildRosterFontStringPlayerrank[index]:GetPoint()), 
      -2)
      --note
      GuildRosterFontStringPlayernote[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
      GuildRosterFontStringPlayernote[index]:SetText(v.note)
      GuildRosterFontStringPlayernote[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index], 'TOPLEFT',
      155 + select(4, GuildRosterFontStringPlayerzone[index]:GetPoint()), 
      -2)
      --officernote
      GuildRosterFontStringPlayerofficernote[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
      GuildRosterFontStringPlayerofficernote[index]:SetText(v.officernote)
      GuildRosterFontStringPlayerofficernote[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index], 'TOPLEFT', 
      200 + select(4, GuildRosterFontStringPlayernote[index]:GetPoint()), 
      -2)
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
    ChatFrame_OpenChat(string.format("/w %s ",name .. "-" .. GetRealmName()))    
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
      
    --print("EVENT: GUILD_ROSTER_UPDATE")
    end
end

function GuildInspector_RegisterEvents()
    GuildInspector:RegisterEvent('GUILD_ROSTER_UPDATE')
end

function GuildInspector_Sort(self)
  local text = self:GetText()
  if text == "Lvl" then
    GuildFrameColumnHeader3:GetScript("OnClick")(GuildFrameColumnHeader3)
  elseif text == "Name" then
    GuildFrameColumnHeader1:GetScript("OnClick")(GuildFrameColumnHeader1)
  elseif text == "(Class)" then
    GuildFrameColumnHeader4:GetScript("OnClick")(GuildFrameColumnHeader4)
  elseif text == "Rank" then
    GuildFrameGuildStatusColumnHeader2:GetScript("OnClick")(GuildFrameGuildStatusColumnHeader2)
  elseif text == "Zone" then
    GuildFrameColumnHeader2:GetScript("OnClick")(GuildFrameColumnHeader2)
  elseif text == "Note" then
    GuildFrameGuildStatusColumnHeader3:GetScript("OnClick")(GuildFrameGuildStatusColumnHeader3)
  end
  FriendsFrameCloseButton:GetScript("OnClick")(FriendsFrameCloseButton)
end

function GuildInspector_ScrollFrane()

  --GuildInspector_ScrollFrame = CreateFrame("ScrollFrame", "GuildInspector_ScrollFrame", GuildInspectorUiWindow, "UIPanelScrollFrameTemplate")
  --GuildInspector_ScrollFrame:ClearAllPoints()
  --GuildInspector_ScrollFrame:SetSize(800, 400)
  --GuildInspector_ScrollFrame:SetPoint("TOPLEFT", "GuildInspectorUiWindow", "TOPRIGHT", 0, 0)
  --GuildInspector_ScrollFrame:SetFrameStrata("BACKGROUND")
	--GuildInspector_ScrollFrame.ScrollBar:ClearAllPoints()
	--GuildInspector_ScrollFrame.ScrollBar:SetPoint("TOPLEFT", GuildInspector_ScrollFrame, "TOPRIGHT", 0, -16)
	--GuildInspector_ScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", GuildInspector_ScrollFrame, "BOTTOMRIGHT", 0, 16)


  --GuildInspector_ScrollFrame:Show()
  
  -- create the frame that will hold all other frames/objects:
  GuildInspector_ScrollFrame = CreateFrame("Frame", nil, GuildInspectorUiWindow); -- re-size this to whatever size you wish your ScrollFrame to be, at this point
  local self = GuildInspector_ScrollFrame
  --self:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 100, 500)
  self:SetWidth(100)
  self:SetHeight(200)
  self:SetPoint("TOPRIGHT", GuildInspectorUiWindow, "TOPLEFT", 0, 0)
  self:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
  self:SetBackdropColor(0 ,0 ,0 ,0.4)
  self:RegisterForDrag("LeftButton")
  self:SetFrameLevel(0)
  self:Show()

  -- now create the template Scroll Frame (this frame must be given a name so that it can be looked up via the _G function (you'll see why later on in the code)
  self.scrollframe = self.scrollframe or CreateFrame("ScrollFrame", "ANewScrollFrame", self, "UIPanelScrollFrameTemplate");
  self.scrollframe:ClearAllPoints()
  self.scrollframe:SetSize(100, 500)
  -- create the standard frame which will eventually become the Scroll Frame's scrollchild
  -- importantly, each Scroll Frame can have only ONE scrollchild
  self.scrollchild = self.scrollchild or CreateFrame("Frame"); -- not sure what happens if you do, but to be safe, don't parent this yet (or do anything with it)
   
  -- define the scrollframe's objects/elements:
  local scrollbarName = self.scrollframe:GetName()
  self.scrollbar = _G[scrollbarName.."ScrollBar"];
  self.scrollupbutton = _G[scrollbarName.."ScrollBarScrollUpButton"];
  self.scrolldownbutton = _G[scrollbarName.."ScrollBarScrollDownButton"];
   
  -- all of these objects will need to be re-anchored (if not, they appear outside the frame and about 30 pixels too high)
  self.scrollupbutton:ClearAllPoints();
  self.scrollupbutton:SetPoint("TOPRIGHT", self.scrollframe, "TOPRIGHT", -2, -2);
   
  self.scrolldownbutton:ClearAllPoints();
  self.scrolldownbutton:SetPoint("BOTTOMRIGHT", self.scrollframe, "BOTTOMRIGHT", -2, 2);
   
  self.scrollbar:ClearAllPoints();
  self.scrollbar:SetPoint("TOP", self.scrollupbutton, "BOTTOM", 0, -2);
  self.scrollbar:SetPoint("BOTTOM", self.scrolldownbutton, "TOP", 0, 2);
   
  -- now officially set the scrollchild as your Scroll Frame's scrollchild (this also parents self.scrollchild to self.scrollframe)
  -- IT IS IMPORTANT TO ENSURE THAT YOU SET THE SCROLLCHILD'S SIZE AFTER REGISTERING IT AS A SCROLLCHILD:
  self.scrollframe:SetScrollChild(self.scrollchild);
   
  -- set self.scrollframe points to the first frame that you created (in this case, self)
  self.scrollframe:SetAllPoints(self);
   
  -- now that SetScrollChild has been defined, you are safe to define your scrollchild's size. Would make sense to make it's height > scrollframe's height,
  -- otherwise there's no point having a scrollframe!
  -- note: you may need to define your scrollchild's height later on by calculating the combined height of the content that the scrollchild's child holds.
  -- (see the bit below about showing content).
  --self.scrollchild:SetSize(self.scrollframe:GetWidth(), ( self.scrollframe:GetHeight() * 2 ));
  self.scrollchild:SetWidth(self.scrollframe:GetWidth())
  self.scrollchild:SetHeight(self.scrollframe:GetHeight()+300)
   
   
  -- THE SCROLLFRAME IS COMPLETE AT THIS POINT.  THE CODE BELOW DEMONSTRATES HOW TO SHOW DATA ON IT.
   
   
  -- you need yet another frame which will be used to parent your widgets etc to.  This is the frame which will actually be seen within the Scroll Frame
  -- It is parented to the scrollchild.  I like to think of scrollchild as a sort of 'pin-board' that you can 'pin' a piece of paper to (or take it back off)
  self.moduleoptions = self.moduleoptions or CreateFrame("Frame", nil, self.scrollchild);
  self.moduleoptions:SetAllPoints(self.scrollchild);
   
  -- a good way to immediately demonstrate the new scrollframe in action is to do the following...
   
  -- create a fontstring or a texture or something like that, then place it at the bottom of the frame that holds your info (in this case self.moduleoptions)
  self.moduleoptions.fontstring = self.moduleoptions:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
  self.moduleoptions.fontstring:SetText("This is a test.");
  self.moduleoptions.fontstring:SetPoint("BOTTOMLEFT", self.moduleoptions, "BOTTOMLEFT", 20, 60);
   
  -- you should now need to scroll down to see the text "This is a test."
end

function GuildInspector_TestButton()
  pPrint("Test")
  ScrollFrane()
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