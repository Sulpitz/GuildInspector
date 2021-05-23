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
}

GuildInspector_BLACK = CreateColor(0, 0, 0)
GuildInspector_RED = CreateColor(0.8, 0, 0)
GuildInspector_GREEN = CreateColor(0, 0.8, 0)
GuildInspector_BLUE = CreateColor(0, 0, 0.8)

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
        if online or GuildInspector_showOffline  then
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

function GuildInspectorTestNew()
    do return end
    local framesMax = 20
    local entry = 0
    for i = 1, framesMax do
        entry = entry + 1
        if not _G["GuildInspector_Entry" .. entry] then
            print("FRMAE: " .. entry)
            local frame = CreateFrame("FRAME", "GuildInspector_Entry" .. entry,  _G["GuildInspector_ScrollFrame_Container"], "GuildInspectorScrollFrameEntry")
        end
        if entry == 1 then
            _G["GuildInspector_Entry" .. entry]:SetPoint("TOPLEFT", _G["GuildInspector_ScrollFrame_Container"], "TOPLEFT")
        else
            _G["GuildInspector_Entry" .. entry]:SetPoint("TOPLEFT", _G["GuildInspector_Entry" .. entry-1], "BOTTOMLEFT")
        end
            _G["GuildInspector_Entry" .. entry .. "_NAME"]:SetText("TEST123 Frame " .. entry)
    end
end

function GuildInspector_UpdateGuildRoster()
    local rosterLenght = 0
    
    GuildInspector_BuildGuildRoster()
    
    for index = 1, #guildRoster do
        if guildRoster[index].officernote ~= "" then
            GuildInspectorUiWindow:SetWidth(760) -- REMOVE
            _G["GuildInspectorUiWindow_ScrollFrame"]:SetWidth(760)
            _G["GuildInspectorUiWindow_OfficerNote"]:Show()
            break
        end
    end

    local MaxGuildInspectorUiWindowSize = 20 --45
    if #guildRoster > MaxGuildInspectorUiWindowSize then 
      GuildInspectorUiWindow:SetHeight(MaxGuildInspectorUiWindowSize * 15 + 10 + 15)
      GuildInspectorUiWindow.scrollbar:Show()
      GuildInspectorUiWindow.scrollupbutton:Show()
      GuildInspectorUiWindow.scrolldownbutton:Show()
    else    
      GuildInspectorUiWindow:SetHeight(#guildRoster * 15 + 10 + 20)
      GuildInspectorUiWindow.scrollbar:Hide()
      GuildInspectorUiWindow.scrollupbutton:Hide()
      GuildInspectorUiWindow.scrolldownbutton:Hide()
    end
    GuildInspectorUiWindow.scrollchild:SetHeight(#guildRoster * 15 + 5)  
    GuildInspectorUiWindow.scrollframe:SetSize(GuildInspectorUiWindow:GetWidth() -2, GuildInspectorUiWindow:GetHeight()-25)
    GuildInspectorUiWindow.scrollchild:SetWidth(GuildInspectorUiWindow:GetWidth())

    for index, v in pairs(guildRoster) do 
        rosterLenght = rosterLenght + 1
        local entry = index

    if not _G["GuildInspector_Entry" .. entry] then
        local frame = CreateFrame("FRAME", "GuildInspector_Entry" .. entry,  _G["GuildInspector_ScrollFrame_Container"], "GuildInspectorScrollFrameEntry")
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
    
    if entry % 2 == 0 then
        _G["GuildInspector_Entry" .. entry]:SetBackdropColor(1,0,0,0.5)
    end

    if GuildRosterFontStringButton[index] == nil then

        --Whisper Button
        GuildRosterFontStringButton[index] = CreateFrame('Button', "GuildRosterFontStringPlayerlevel" .. index, GuildInspectorUiWindow.scrollchild, "GuildInspectorWhisperButton")
        GuildRosterFontStringButton[index]:SetPoint('TOPLEFT', 3, (15 - 15 * index))
        
        --background Frame
        if index % 2 == 1 then        
          GuildRosterBackgroundFrame[index] = CreateFrame("Frame", nil, GuildInspectorUiWindow.scrollchild, "GuildInspectorBackgroundBar")
          GuildRosterBackgroundFrame[index]:SetPoint("LEFT", GuildRosterFontStringButton[index])
        end
        
        --Level
        GuildRosterFontStringPlayerlevel[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
        GuildRosterFontStringPlayerlevel[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index], 'TOPLEFT', 5, -2)

        --name
        GuildRosterFontStringPlayername[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
        GuildRosterFontStringPlayername[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index], 'TOPLEFT', 
        25 + select(4, GuildRosterFontStringPlayerlevel[index]:GetPoint()), 
        -2)

        --rank
        GuildRosterFontStringPlayerrank[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
        GuildRosterFontStringPlayerrank[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index], 'TOPLEFT',
        90 + select(4, GuildRosterFontStringPlayername[index]:GetPoint()), 
        -2)
      
        --zone
        GuildRosterFontStringPlayerzone[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
        GuildRosterFontStringPlayerzone[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index],
        90 + select(4, GuildRosterFontStringPlayerrank[index]:GetPoint()), 
        -2)

        --note
        GuildRosterFontStringPlayernote[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
        GuildRosterFontStringPlayernote[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index], 'TOPLEFT',
        155 + select(4, GuildRosterFontStringPlayerzone[index]:GetPoint()), 
        -2)

        --officernote
        GuildRosterFontStringPlayerofficernote[index] = GuildRosterFontStringButton[index]:CreateFontString(nil, nil, "GuildInspectorUiWindowListNameFontstring")
        GuildRosterFontStringPlayerofficernote[index]:SetPoint('TOPLEFT', GuildRosterFontStringButton[index], 'TOPLEFT', 
        200 + select(4, GuildRosterFontStringPlayernote[index]:GetPoint()), 
        -2)
    end
    
    GuildRosterFontStringButton[index]:Show()
    if GuildRosterBackgroundFrame[index] then GuildRosterBackgroundFrame[index]:Show() end
    
    GuildRosterFontStringPlayerlevel[index]:SetText(v.level)
    GuildRosterFontStringPlayername[index]:SetText(v.name)  
    GuildRosterFontStringPlayerrank[index]:SetText(v.rank)   
    GuildRosterFontStringPlayerzone[index]:SetText(v.zone)
    GuildRosterFontStringPlayernote[index]:SetText(v.note)
    GuildRosterFontStringPlayerofficernote[index]:SetText(v.officernote)

    if v.online == true then 
      GuildRosterFontStringPlayername[index]:SetTextColor(GuildInspector_GetClassClolor(v.classFileName))
        _G["GuildInspector_Entry" .. entry .. "_NAME"]:SetTextColor(GuildInspector_GetClassClolor(v.classFileName))
    else 
        GuildRosterFontStringPlayername[index]:SetTextColor(0.8, 0.8, 0.8, 1)
        _G["GuildInspector_Entry" .. entry .. "_NAME"]:SetTextColor(0.8, 0.8, 0.8, 1)
    end    
  end 

  for index = #guildRoster + 1,  #GuildRosterFontStringButton do 
    GuildRosterFontStringButton[index]:Hide()
    if GuildRosterBackgroundFrame[index] then GuildRosterBackgroundFrame[index]:Hide() end
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

function GuildInspector_OnEvent(self, event, ...)
    if GuildInspectorUiWindow:IsVisible() and event == "GUILD_ROSTER_UPDATE" then
      GuildInspector_UpdateGuildRoster()
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
  
  --GuildInspector_ScrollFrame = CreateFrame("Frame", nil, GuildInspectorUiWindow); -- re-size this to whatever size you wish your ScrollFrame to be, at this point
  --self = GuildInspector_ScrollFrame
  ----self:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 100, 500)
  --self:SetWidth(100)
  --self:SetHeight(200)
  --self:SetPoint("TOPRIGHT", GuildInspectorUiWindow, "TOPLEFT", 0, 0)
  --self:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
  --self:SetBackdropColor(0 ,0 ,1 ,0.6)
  --self:RegisterForDrag("LeftButton")
  --self:SetFrameLevel(0)

  local GIW = GuildInspectorUiWindow
  -- now create the template Scroll Frame (this frame must be given a name so that it can be looked up via the _G function (you'll see why later on in the code)
  GIW.scrollframe = CreateFrame("ScrollFrame", "GuildInspectorScrollFrame", GIW, "UIPanelScrollFrameTemplate");
  --self.scrollframe:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
  --GIW.scrollframe:SetBackdropColor(0 ,1 ,0 ,0.6)
  GIW.scrollframe:ClearAllPoints()
  -- create the standard frame which will eventually become the Scroll Frame's scrollchild
  -- importantly, each Scroll Frame can have only ONE scrollchild
  GIW.scrollchild = CreateFrame("Frame" ); -- not sure what happens if you do, but to be safe, don't parent this yet (or do anything with it)
    --GIW.scrollchild:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
  --GIW.scrollchild:SetBackdropColor(1 ,0 ,0 ,0.6)

  -- define the scrollframe's objects/elements:
  local scrollbarName = GIW.scrollframe:GetName()
  GIW.scrollbar = _G[scrollbarName.."ScrollBar"];
  GIW.scrollupbutton = _G[scrollbarName.."ScrollBarScrollUpButton"];
  GIW.scrolldownbutton = _G[scrollbarName.."ScrollBarScrollDownButton"];
   
  -- all of these objects will need to be re-anchored (if not, they appear outside the frame and about 30 pixels too high)
  GIW.scrollupbutton:ClearAllPoints();
  GIW.scrollupbutton:SetPoint("TOPRIGHT", GIW.scrollframe, "TOPRIGHT", 0, 0);
   
  GIW.scrolldownbutton:ClearAllPoints();
  GIW.scrolldownbutton:SetPoint("BOTTOMRIGHT", GIW.scrollframe, "BOTTOMRIGHT", 0, 0);
   
  GIW.scrollbar:ClearAllPoints();
  GIW.scrollbar:SetPoint("TOP", GIW.scrollupbutton, "BOTTOM", 0, 0);
  GIW.scrollbar:SetPoint("BOTTOM", GIW.scrolldownbutton, "TOP", 0, 0);
   
  -- now officially set the scrollchild as your Scroll Frame's scrollchild (this also parents self.scrollchild to self.scrollframe)
  -- IT IS IMPORTANT TO ENSURE THAT YOU SET THE SCROLLCHILD'S SIZE AFTER REGISTERING IT AS A SCROLLCHILD:
  GIW.scrollframe:SetScrollChild(GIW.scrollchild);
   
  -- set self.scrollframe points to the first frame that you created (in this case, self)
  --self.scrollframe:SetAllPoints(self);
  --GIW.scrollframe:SetSize(100, 500)
  GIW.scrollframe:SetPoint("TOPLEFT", GIW, "TOPLEFT", 0, -20);

  --self.scrollchild:SetHeight(self.scrollframe:GetHeight()+300)
end


function GuildInspector_ToggleUiWindow()
    if GuildInspectorUiWindow:IsVisible() then
        GuildInspectorUiWindow:Hide()
    else
        GuildInspector_UpdateGuildRoster()
        GuildInspectorTestNew()
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