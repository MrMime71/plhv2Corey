function PLH_CreateOptionsPanel()

	local VERTICAL_SPACE_BETWEEN_ELEMENTS = 15

	--[[ Main Panel ]]--
	local PLHConfigFrame = CreateFrame('Frame', 'PLHConfigFrame', InterfaceOptionsFramePanelContainer)
	PLHConfigFrame:Hide()
	PLHConfigFrame.name = PLH_LONG_ADDON_NAME
	InterfaceOptions_AddCategory(PLHConfigFrame)

	--[[ Title ]]--
	local TitleLabel = PLHConfigFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	TitleLabel:SetPoint('TOPLEFT', PLHConfigFrame, 'TOPLEFT', 16, -16)
	TitleLabel:SetText(PLH_LONG_ADDON_NAME)

	-- [[ Version ]] --
	local AddonVersion = GetAddOnMetadata("PersonalLootHelper", "Version")
	local VersionLabel = PLHConfigFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
	VersionLabel:SetPoint('BOTTOMLEFT', TitleLabel, 'BOTTOMRIGHT', 8, 0)
	VersionLabel:SetText('v' .. AddonVersion)

	--[[ Author ]]--
	local AuthorLabel = PLHConfigFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
	AuthorLabel:SetPoint('TOPRIGHT', PLHConfigFrame, 'TOPRIGHT', -16, -24)
	AuthorLabel:SetText('Author: ' .. PLH_AUTHOR_NAME)
--tiny	
		--[[PLH_WHISPER_UPGRADE]]--
	PLH_WhisperUpgradeCheckbox = CreateFrame('CheckButton', 'PLHWhisperUpgrade', PLHConfigFrame, 'InterfaceOptionsCheckButtonTemplate')
	PLH_WhisperUpgradeCheckbox:SetPoint('TOPLEFT', TitleLabel, 'BOTTOMLEFT', 0, -VERTICAL_SPACE_BETWEEN_ELEMENTS)
	PLH_WhisperUpgradeCheckbox:SetChecked(PLH_WHISPER_UPGRADE)
	

	local WhisperUpgradeLabel = PLH_WhisperUpgradeCheckbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	WhisperUpgradeLabel:SetPoint('LEFT', PLH_WhisperUpgradeCheckbox, 'RIGHT', 0, 0)
	WhisperUpgradeLabel:SetText('Whisper Looter Automaticly that you need the item. Be aware: no stat evaluation!')
	
	
			--[[PLH_WHISPER_TEXT]]--
-- tiny start
		if PLH_WHISPER_TEXT == nil or PLH_WHISPER_TEXT == "" then
		   PLH_WHISPER_TEXT = "Hi. You need that? its an upgrade for me :-D"
		end   
-- tiny end		


	--[[ PLH_INCLUDE_BOE ]]--
	PLH_IncludeBOECheckbox = CreateFrame('CheckButton', 'PLHIncludeBOE', PLHConfigFrame, 'InterfaceOptionsCheckButtonTemplate')
	PLH_IncludeBOECheckbox:SetPoint('TOPLEFT', TitleLabel, 'BOTTOMLEFT', 0, -VERTICAL_SPACE_BETWEEN_ELEMENTS)
	PLH_IncludeBOECheckbox:SetChecked(PLH_INCLUDE_BOE)

	local IncludeBOELabel = PLH_IncludeBOECheckbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	IncludeBOELabel:SetPoint('LEFT', PLH_IncludeBOECheckbox, 'RIGHT', 0, 0)
	IncludeBOELabel:SetText('Include Bind on Equip items')

	--[[ PLH_CURRENT_SPEC_ONLY ]]--
	PLH_CurrentSpecOnlyCheckbox = CreateFrame('CheckButton', 'PLHCurrentSpecOnly', PLHConfigFrame, 'InterfaceOptionsCheckButtonTemplate')
	PLH_CurrentSpecOnlyCheckbox:SetPoint('TOPLEFT', PLH_IncludeBOECheckbox, 'BOTTOMLEFT', 0, -VERTICAL_SPACE_BETWEEN_ELEMENTS)
	PLH_CurrentSpecOnlyCheckbox:SetChecked(PLH_CURRENT_SPEC_ONLY)

	local CurrentSpecOnlyLabel = PLH_CurrentSpecOnlyCheckbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	CurrentSpecOnlyLabel:SetPoint('LEFT', PLH_CurrentSpecOnlyCheckbox, 'RIGHT', 0, 0)
	CurrentSpecOnlyLabel:SetText('Evaluate based on current spec only')

	--[[ PLH_NOTIFY_GROUP ]]--
	PLH_NotifyGroupCheckbox = CreateFrame('CheckButton', 'PLHNotifyGroup', PLHConfigFrame, 'InterfaceOptionsCheckButtonTemplate')
	PLH_NotifyGroupCheckbox:SetPoint('TOPLEFT', PLH_CurrentSpecOnlyCheckbox, 'BOTTOMLEFT', 0, -VERTICAL_SPACE_BETWEEN_ELEMENTS)
	PLH_NotifyGroupCheckbox:SetChecked(PLH_NOTIFY_GROUP)

	local NotifyGroupLabel = PLH_NotifyGroupCheckbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	NotifyGroupLabel:SetPoint('LEFT', PLH_NotifyGroupCheckbox, 'RIGHT', 0, 0)
	NotifyGroupLabel:SetText('Notify group (automatically disabled in LFR)')

	--[[ PLH_COORDINATE_ROLLS ]]--
	PLH_CoordinateRollsCheckbox = CreateFrame('CheckButton', 'PLHCoordinateRolls', PLHConfigFrame, 'InterfaceOptionsCheckButtonTemplate')
	PLH_CoordinateRollsCheckbox:SetPoint('TOPLEFT', PLH_NotifyGroupCheckbox, 'BOTTOMLEFT', 0, -VERTICAL_SPACE_BETWEEN_ELEMENTS)
	PLH_CoordinateRollsCheckbox:SetChecked(PLH_COORDINATE_ROLLS)

	PLH_CoordinateRollsLabel1 = PLH_CoordinateRollsCheckbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	PLH_CoordinateRollsLabel1:SetPoint('LEFT', PLH_CoordinateRollsCheckbox, 'RIGHT', 0, 0)
	PLH_CoordinateRollsLabel1:SetText('Coordinate rolls (group leaders or assistants only)')

	PLH_CoordinateRollsLabel2 = PLH_CoordinateRollsCheckbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	PLH_CoordinateRollsLabel2:SetPoint('TOPLEFT', PLH_CoordinateRollsLabel1, 'BOTTOMLEFT', 20, -10)
	PLH_CoordinateRollsLabel2:SetText('Manage loot rolls. Players can whisper the roll coordinator with "trade" or "trade [item]" to initiate rolls.')
	PLH_CoordinateRollsLabel2:SetWordWrap(true)
	PLH_CoordinateRollsLabel2:SetJustifyH('LEFT')
	PLH_CoordinateRollsLabel2:SetWidth(450)

	--[[ PLH_CHECK_CHARACTER_LEVEL ]]--
	PLH_CheckCharacterLevelCheckbox = CreateFrame('CheckButton', 'PLHCheckCharacterLevel', PLHConfigFrame, 'InterfaceOptionsCheckButtonTemplate')
	PLH_CheckCharacterLevelCheckbox:SetPoint('TOPLEFT', PLH_CoordinateRollsCheckbox, 'BOTTOMLEFT', 0, -VERTICAL_SPACE_BETWEEN_ELEMENTS*2)
	PLH_CheckCharacterLevelCheckbox:SetChecked(PLH_CHECK_CHARACTER_LEVEL)

	local CheckCharacterLevelLabel = PLH_CheckCharacterLevelCheckbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	CheckCharacterLevelLabel:SetPoint('LEFT', PLH_CheckCharacterLevelCheckbox, 'RIGHT', 0, 0)
	CheckCharacterLevelLabel:SetText('Exclude notifications if character is too low level to equip item')

	--[[ PLH_HIGHLIGHT_RAID_FRAMES ]]--
	PLH_HighlightRaidFramesCheckbox = CreateFrame('CheckButton', 'PLHHighlightRaidFrames', PLHConfigFrame, 'InterfaceOptionsCheckButtonTemplate')
	PLH_HighlightRaidFramesCheckbox:SetPoint('TOPLEFT', PLH_CheckCharacterLevelCheckbox, 'BOTTOMLEFT', 0, -VERTICAL_SPACE_BETWEEN_ELEMENTS)
	PLH_HighlightRaidFramesCheckbox:SetChecked(PLH_HIGHLIGHT_RAID_FRAMES)

	local HighlightRaidFramesLabel = PLH_HighlightRaidFramesCheckbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	HighlightRaidFramesLabel:SetPoint('LEFT', PLH_HighlightRaidFramesCheckbox, 'RIGHT', 0, 0)
	HighlightRaidFramesLabel:SetText('Show tradeable items in raid frames')

	--[[ PLH_HIGHLIGHT_SIZE ]]--
	PLH_HighlightSizeSlider = CreateFrame("Slider", "PLHHighlightSize", PLHConfigFrame, "OptionsSliderTemplate")
	PLHConfigFrame.ScalingSlider = slider
	PLH_HighlightSizeSlider:SetOrientation("HORIZONTAL")
	PLH_HighlightSizeSlider:SetMinMaxValues(10, 30)
	PLH_HighlightSizeSlider:SetValueStep(1)
	PLH_HighlightSizeSlider:SetObeyStepOnDrag(true)
	PLH_HighlightSizeSlider:SetWidth(180)
	PLH_HighlightSizeSlider:SetHeight(16)
	PLH_HighlightSizeSlider:SetPoint("LEFT", HighlightRaidFramesLabel, "RIGHT", 20, 0)
	_G[PLH_HighlightSizeSlider:GetName().."High"]:SetText("large")
	_G[PLH_HighlightSizeSlider:GetName().."Low"]:SetText("small")
	_G[PLH_HighlightSizeSlider:GetName().."Text"]:SetText("icon size")
	PLH_HighlightSizeSlider:SetValue(PLH_HIGHLIGHT_SIZE)
	
	--tiny start
	--[[PLH_WHISPER_TEXT]]--
	PLH_WhisperInput = CreateFrame('EditBox', 'PLHWhisperInput', PLHConfigFrame, 'InputBoxTemplate')
	PLH_WhisperInput:SetPoint('TOPLEFT', PLH_HighlightRaidFramesCheckbox, 'BOTTOMLEFT', 0, -VERTICAL_SPACE_BETWEEN_ELEMENTS)
	PLH_WhisperInput:SetText(PLH_WHISPER_TEXT);
	PLH_WhisperInput:SetHeight(40);
    PLH_WhisperInput:SetWidth(530);
	

	local WhisperInputLabel = PLH_WhisperInput:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	WhisperInputLabel:SetPoint('LEFT', PLH_HighlightRaidFramesCheckbox, 'LEFT', 0, -29)
	WhisperInputLabel:SetText('Enter your custom text (clear to go back to defaults)')
-- tiny
	
	--[[ Thank you message ]] --
	local ThankYouLabel = PLHConfigFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	ThankYouLabel:SetPoint('BOTTOM', PLHConfigFrame, 'BOTTOM', 0, 48)
	ThankYouLabel:SetText('Thank you to all of the players who trade loot to others who can use it! Your generosity is part of what makes the WoW community great.\nYou rock!!!')
	ThankYouLabel:SetWidth(300)
	ThankYouLabel:SetWordWrap(true)

	--[[ OnShow Event]]
	PLHConfigFrame:SetScript('OnShow', function(frame)
		PLH_IncludeBOECheckbox:SetChecked(PLH_INCLUDE_BOE)
		PLH_CurrentSpecOnlyCheckbox:SetChecked(PLH_CURRENT_SPEC_ONLY)
		PLH_CheckCharacterLevelCheckbox:SetChecked(PLH_CHECK_CHARACTER_LEVEL)
		PLH_HighlightRaidFramesCheckbox:SetChecked(PLH_HIGHLIGHT_RAID_FRAMES)
		PLH_NotifyGroupCheckbox:SetChecked(PLH_NOTIFY_GROUP)
		PLH_CoordinateRollsCheckbox:SetChecked(PLH_COORDINATE_ROLLS)
		PLH_HighlightSizeSlider:SetValue(PLH_HIGHLIGHT_SIZE)
-- tiny start
--HIDE THE AUTOWHISPER STUFF.. ITS ANNOYING
			PLH_WhisperUpgradeCheckbox:Hide()
			WhisperUpgradeLabel:Hide()
-- end hide it			
			
		PLH_WhisperUpgradeCheckbox:SetChecked(PLH_WHISPER_UPGRADE)
		PLH_WhisperInput:SetText(PLH_WHISPER_TEXT)
-- tiny end
	end)

	--[[ Okay Action ]]--
	function PLHConfigFrame.okay(arg1, arg2, arg3, ...)
	-- tiny start
		PLH_WHISPER_UPGRADE = PLH_WhisperUpgradeCheckbox:GetChecked()
		PLH_WHISPER_TEXT = PLH_WhisperInput:GetText()
	-- tiny end	
	-- tiny start
		if PLH_WHISPER_TEXT == nil or PLH_WHISPER_TEXT == "" then
		   PLH_WHISPER_TEXT = 'Sorry to bother you, but the item you just received is an upgrade for me. If you need it yourself, just ignore my message.'
		end   
	-- tiny end
		PLH_INCLUDE_BOE = PLH_IncludeBOECheckbox:GetChecked()
		PLH_CURRENT_SPEC_ONLY = PLH_CurrentSpecOnlyCheckbox:GetChecked()
		PLH_CHECK_CHARACTER_LEVEL = PLH_CheckCharacterLevelCheckbox:GetChecked()
		PLH_HIGHLIGHT_RAID_FRAMES = PLH_HighlightRaidFramesCheckbox:GetChecked()
		PLH_NOTIFY_GROUP = PLH_NotifyGroupCheckbox:GetChecked()
		PLH_COORDINATE_ROLLS = PLH_CoordinateRollsCheckbox:GetChecked()
		PLH_HIGHLIGHT_SIZE = PLH_HighlightSizeSlider:GetValue()
		PLH_ResizeHighlights()
	end

end

-- tiny start
-- tiny:arg1 is Padding space for frames, arg2 is text for frame gotten from optionmenu
--      arg3 is chat message from options, arg4 is charactername with realm
--  arg5 is targetunit 


function PLH_CreateLootFrame(arg1, arg2, arg3, arg4, arg5)
local frame  = CreateFrame("Frame", "PLHLootFrame", UIParent)
frame.width  = 600
frame.height = 135
frame:SetFrameStrata("FULLSCREEN_DIALOG")
frame:SetSize(frame.width, frame.height)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, arg1)
frame:SetBackdrop({
	bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile     = true,
	tileSize = 32,
	edgeSize = 32,
	insets   = { left = 8, right = 8, top = 8, bottom = 8 }
})
frame:SetBackdropColor(0, 0, 0, 1)
frame:EnableMouse(true)
frame:EnableMouseWheel(true)

-- Make movable/resizable
frame:SetMovable(true)
frame:SetResizable(enable)
frame:SetMinResize(100, 100)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

tinsert(UISpecialFrames, "PLHLootFrame")

-- Close button
local closeButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
closeButton:SetPoint("TopRight", -10, -10)
closeButton:SetHeight(25)
closeButton:SetWidth(25)
closeButton:SetText("X")
closeButton:SetScript("OnClick", function(self)	self:GetParent():Hide() end)
frame.closeButton = closeButton

-- Whisper button
local whisperButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
whisperButton:SetPoint("BOTTOM", -60, 10)
whisperButton:SetHeight(25)
whisperButton:SetWidth(80)
whisperButton:SetText("Whisper?")
whisperButton:SetScript("OnClick", function(self) SendChatMessage(arg3, "WHISPER", nil, arg4)  end)
frame.whisperButton = whisperButton
--
-- Target button
    local HSframe = CreateFrame("BUTTON","homeButton", frame, "SecureActionButtonTemplate")
    HSframe:SetPoint("BOTTOM", 60, 15)
    HSframe:SetSize(42, 16)
    HSframe:EnableMouse(true)
    HSframe:RegisterForClicks("AnyUp")
    HSframe:SetAttribute("type", "macro")
    HSframe:SetAttribute("macrotext", "/tar " .. arg5)
     
    HSframe.icon = HSframe:CreateTexture(nil,"OVERLAY",nil,7)
    HSframe.icon:SetSize(42, 16)
    HSframe.icon:SetPoint("LEFT")
   -- HSframe.icon:SetTexture(1,1,0)
     
    HSframe.text = HSframe:CreateFontString(nil, "OVERLAY")
    HSframe.text:SetFont(STANDARD_TEXT_FONT, 16, "THINOUTLINE")
    HSframe.text:SetPoint("LEFT")
    HSframe.text:SetText("Target")

-- Trade button
    local HSframe2 = CreateFrame("BUTTON","homeButton", frame, "SecureActionButtonTemplate")
    HSframe2:SetPoint("BOTTOM", 150, 15)
    HSframe2:SetSize(42, 16)
    HSframe2:EnableMouse(true)
    HSframe2:RegisterForClicks("AnyUp")
    HSframe2:SetAttribute("type", "macro")
    HSframe2:SetAttribute("macrotext", "/trade ")
     
    HSframe2.icon = HSframe2:CreateTexture(nil,"OVERLAY",nil,7)
    HSframe2.icon:SetSize(42, 16)
    HSframe2.icon:SetPoint("LEFT")
   -- HSframe2.icon:SetTexture(1,1,0)
     
    HSframe2.text = HSframe2:CreateFontString(nil, "OVERLAY")
    HSframe2.text:SetFont(STANDARD_TEXT_FONT, 16, "THINOUTLINE")
    HSframe2.text:SetPoint("LEFT")
    HSframe2.text:SetText("Trade")

-- ScrollingMessageFrame
local messageFrame = CreateFrame("ScrollingMessageFrame", nil, frame)
messageFrame:SetPoint("CENTER", 15, 20)
messageFrame:SetSize(frame.width, frame.height - 50)
--messageFrame:SetFontObject(GameFontNormal)
messageFrame:SetTextColor(1, 1, 1, 1) -- default color
messageFrame:SetJustifyH("LEFT")
messageFrame:SetHyperlinksEnabled(true)
messageFrame:SetFading(false)
messageFrame:SetMaxLines(300)
messageFrame:SetFont("Fonts\\ARIALN.TTF", 14, nil)
frame.messageFrame = messageFrame
messageFrame:AddMessage(arg2)


-- tiny Just using 1 line so no need for scrollbars
--[[
-------------------------------------------------------------------------------
-- Scroll bar
-------------------------------------------------------------------------------
local scrollBar = CreateFrame("Slider", nil, frame, "UIPanelScrollBarTemplate")
scrollBar:SetPoint("RIGHT", frame, "RIGHT", -10, 10)
scrollBar:SetSize(30, frame.height - 90)
scrollBar:SetMinMaxValues(0, 9)
scrollBar:SetValueStep(1)
scrollBar.scrollStep = 1
frame.scrollBar = scrollBar

scrollBar:SetScript("OnValueChanged", function(self, value)
	messageFrame:SetScrollOffset(select(2, scrollBar:GetMinMaxValues()) - value)
end)

scrollBar:SetValue(select(2, scrollBar:GetMinMaxValues()))

frame:SetScript("OnMouseWheel", function(self, delta)
	print(messageFrame:GetNumMessages(), messageFrame:GetNumLinesDisplayed())

	local cur_val = scrollBar:GetValue()
	local min_val, max_val = scrollBar:GetMinMaxValues()

	if delta < 0 and cur_val < max_val then
		cur_val = math.min(max_val, cur_val + 1)
		scrollBar:SetValue(cur_val)
	elseif delta > 0 and cur_val > min_val then
		cur_val = math.max(min_val, cur_val - 1)
		scrollBar:SetValue(cur_val)
	end
end)
]]

messageFrame:SetScript("OnHyperlinkClick", function(self, link, text)
 -- thanx to https://www.reddit.com/r/wowaddons/comments/59iecy/devhelp_spell_hyperlink_in_custom_frame_text/
  SetItemRef(link, text)
	  end)

end

-- tiny end

--tiny 
-- trade frame
-- dont need arg 5 that is the playername
-- arg 4 is "announce roll is over " TRADEMETEXT = TRADEMETEXT .. item from core.lua
function PLH_CreateTradeFrame(arg1, arg2, arg3, arg4)
local _, typeOfInstancetosendchat, difficultychat, _, _, _, _, _, _ = GetInstanceInfo()
local frame  = CreateFrame("Frame", "PLHTradeFrame", UIParent)

frame.width  = 515
frame.height = 135
frame:SetFrameStrata("FULLSCREEN_DIALOG")
frame:SetSize(frame.width, frame.height)
frame:SetPoint("CENTER", UIParent, "RIGHT", -300, arg1)
frame:SetBackdrop({
	bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile     = true,
	tileSize = 32,
	edgeSize = 32,
	insets   = { left = 8, right = 8, top = 8, bottom = 8 }
})
frame:SetBackdropColor(0, 0, 0, 1)
frame:EnableMouse(true)
frame:EnableMouseWheel(true)

-- Make movable/resizable
frame:SetMovable(true)
frame:SetResizable(enable)
frame:SetMinResize(100, 100)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

tinsert(UISpecialFrames, "PLHTradeFrame")

-- Close button
local closeButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
closeButton:SetPoint("TopRight", -10, -10)
closeButton:SetHeight(25)
closeButton:SetWidth(25)
closeButton:SetText("X")
closeButton:SetScript("OnClick", function(self) self:GetParent():Hide() end)
frame.closeButton = closeButton

 


-- Trade button
    local HSframe3 = CreateFrame("BUTTON","homeButton", frame, "SecureActionButtonTemplate")
    HSframe3:SetPoint("BOTTOM", 50, 15)
    HSframe3:SetSize(42, 16)
    HSframe3:EnableMouse(true)
    HSframe3:RegisterForClicks("AnyUp")
    HSframe3:SetAttribute("type", "macro")
    HSframe3:SetAttribute("macrotext", "/trade ")
     
    HSframe3.icon = HSframe3:CreateTexture(nil,"OVERLAY",nil,7)
    HSframe3.icon:SetSize(42, 16)
    HSframe3.icon:SetPoint("LEFT")
   -- HSframe2.icon:SetTexture(1,1,0)
     
    HSframe3.text = HSframe3:CreateFontString(nil, "OVERLAY")
    HSframe3.text:SetFont(STANDARD_TEXT_FONT, 16, "THINOUTLINE")
    HSframe3.text:SetPoint("LEFT")
    HSframe3.text:SetText("Trade")

-- Announce button
local whisperButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
whisperButton:SetPoint("BOTTOM", -120, 10)
whisperButton:SetHeight(25)
whisperButton:SetWidth(75)
whisperButton:SetText("Announce")
--debug
--print(typeOfInstancetosendchat)
--print(difficultychat)
--end debug
if typeOfInstancetosendchat == "none" then
	whisperButton:SetScript("OnClick", function(self) SendChatMessage(arg3, "say", nil )  end)	
else
-- Raid finder difficulty is 7 and 17
-- Timewalking is 24 and 33
-- 2 is Heroic Dungeonfinder
--0 - None; not in an Instance.
--1 - 5-player Instance.
--2 - 5-player Heroic Instance.
--3 - 10-player Raid Instance.
--4 - 25-player Raid Instance.
--5 - 10-player Heroic Raid Instance.
--6 - 25-player Heroic Raid Instance.
--7 - 25-player Raid Finder Instance.
--8 - Challenge Mode Instance.
--9 - 40-player Raid Instance.
--10 - Not used.
--11 - Heroic Scenario Instance.
--12 - Scenario Instance.
--13 - Not used.
--14 - 10-30-player Normal Raid Instance.
--15 - 10-30-player Heroic Raid Instance.
--16 - 20-player Mythic Raid Instance .
--17 - 10-30-player Raid Finder Instance.
--18 - 40-player Event raid (Used by the level 100 version of Molten Core for WoW's 10th anniversary).
--19 - 5-player Event instance (Used by the level 90 version of UBRS at WoD launch).
--20 - 25-player Event scenario (unknown usage).
--21 - Not used.
--22 - Not used.
--23 - Mythic 5-player Instance.
--24 - Timewalker 5-player Instance.
		if (difficultychat == 7) or (difficultychat == 17) or (difficultychat == 24)  or (difficultychat == 33) or (difficultychat == 2) then
	
	      whisperButton:SetScript("OnClick", function(self) SendChatMessage(arg3, "SAY" ) SendChatMessage(arg3, "INSTANCE_CHAT" ) end)
		else
		  whisperButton:SetScript("OnClick", function(self) SendChatMessage(arg3, typeOfInstancetosendchat, nil )  end) 
		end
end
	frame.whisperButton = whisperButton


-- ScrollingMessageFrame
local message1 = "|cFF00FF00If no target is made, name is not added to Endroll|r"
local messageFrame = CreateFrame("ScrollingMessageFrame", nil, frame)
messageFrame:SetPoint("CENTER", 15, 20)
messageFrame:SetSize(frame.width, frame.height - 50)
--messageFrame:SetFontObject(GameFontNormal)
messageFrame:SetTextColor(1, 1, 1, 1) -- default color
messageFrame:SetJustifyH("LEFT")
messageFrame:SetHyperlinksEnabled(true)
messageFrame:SetFading(false)
messageFrame:SetMaxLines(300)
frame.messageFrame = messageFrame
messageFrame:SetFont("Fonts\\ARIALN.TTF", 14, nil)
messageFrame:AddMessage(arg2)
messageFrame:AddMessage(message1)


messageFrame:SetScript("OnHyperlinkClick", function(self, link, text)
 -- thanx to https://www.reddit.com/r/wowaddons/comments/59iecy/devhelp_spell_hyperlink_in_custom_frame_text/
  SetItemRef(link, text)
	  end)

end

-- RaidRoll Loot Tracker

RaidRoll_LootTrackerLoaded = true

function RaidRoll_LootPanel_Setup()

    -- Options menu
    Raid_Roll_PanelName_String = RaidRoll_LootPanel:CreateFontString("Raid_Roll_PanelName_String", "ARTWORK", "GameFontNormal")
    Raid_Roll_PanelName_String:SetPoint("TopLeft", RaidRoll_LootPanel, "TopLeft", 20, -10)
    Raid_Roll_PanelName_String:SetJustifyH("LEFT")

    Raid_Roll_PanelName_String:SetText("|cFFC41F3B" .. RAIDROLL_LOCALE["OPTIONSTITLE"] .. " (Loot Window)")
    if (GetLocale() == "zhTW") then
        Raid_Roll_PanelName_String:SetFont("Fonts\\FRIZQT__.TTF", 16)
    end
    if (GetLocale() == "zhCN") then
        Raid_Roll_PanelName_String:SetFont("Fonts\\ZYKai_T.TTF", 20)
    end

    -- Set Msg1
    Raid_Roll_SetMsg1_String = RaidRoll_LootPanel:CreateFontString("Raid_Roll_SetMsg1_String", "ARTWORK", "GameFontNormal")
    Raid_Roll_SetMsg1_String:SetPoint("TopLeft", RaidRoll_LootPanel, "TOPLEFT", 10, -50)
    Raid_Roll_SetMsg1_String:SetJustifyH("LEFT")

    Raid_Roll_SetMsg1_String:SetText("|cFF69CCF0" .. RAIDROLL_LOCALE["Set_Msg1"])
    if (GetLocale() ~= "zhTW") then
        Raid_Roll_SetMsg1_String:SetFont("Fonts\\FRIZQT__.TTF", 14)
    end
    if (GetLocale() == "zhCN") then
        Raid_Roll_SetMsg1_String:SetFont("Fonts\\ZYKai_T.TTF", 15)
    end

    -- Msg1 edit box
    RR_Msg1_FRAME = CreateFrame("Frame", "RR_Msg1_FRAME", RaidRoll_LootPanel)
    rr_MsgFrame_backdrop = {
        bgFile = "",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", -- path to the border texture

        tile = false, -- true to repeat the background texture to fill the frame, false to scale it
        tileSize = 32, -- size (width or height) of the square repeating background tiles (in pixels)
        edgeSize = 20, -- thickness of edge segments and square size of edge corners (in pixels)
        insets = {
            -- distance from the edges of the frame to those of the background texture (in pixels)
            left = 2,
            right = 2,
            top = 2,
            bottom = 2
        }
    }
    RR_Msg1_FRAME:SetBackdrop(rr_MsgFrame_backdrop)
    RR_Msg1_FRAME:SetWidth(390) -- Set these to whatever height/width is needed
    RR_Msg1_FRAME:SetHeight(25) -- Set these to whatever height/width is needed
    RR_Msg1_FRAME:SetPoint("TopLeft", RaidRoll_LootPanel, "TOPLEFT", 10, -70)

    Raid_Roll_SetMsg1_EditBox = CreateFrame("EditBox", "Raid_Roll_SetMsg1_EditBox", RaidRoll_LootPanel, InputBoxTemplate)
    if (GetLocale() ~= "zhTW") then
        Raid_Roll_SetMsg1_EditBox:SetFont("Fonts\\FRIZQT__.TTF", 14)
    end
    if (GetLocale() == "zhCN") then
        Raid_Roll_SetMsg1_EditBox:SetFont("Fonts\\ZYKai_T.TTF", 15)
    end
    Raid_Roll_SetMsg1_EditBox:SetAutoFocus(false)
    Raid_Roll_SetMsg1_EditBox:SetWidth(380)
    Raid_Roll_SetMsg1_EditBox:SetHeight(20)
    Raid_Roll_SetMsg1_EditBox:SetPoint("Left", RR_Msg1_FRAME, "Left", 8, 0)
    Raid_Roll_SetMsg1_EditBox:SetScript("OnEditFocusLost", function()
        RaidRoll_DBPC[UnitName("player")]["Raid_Roll_SetMsg1_EditBox"] = Raid_Roll_SetMsg1_EditBox:GetText()
    end)
    Raid_Roll_SetMsg1_EditBox:SetScript("OnChar", function()
        RaidRoll_DBPC[UnitName("player")]["Raid_Roll_SetMsg1_EditBox"] = Raid_Roll_SetMsg1_EditBox:GetText()
    end)
    Raid_Roll_SetMsg1_EditBox:SetScript("OnEnterPressed", function() Raid_Roll_SetMsg1_EditBox:ClearFocus() end)
    Raid_Roll_SetMsg1_EditBox:SetScript("OnEscapePressed", function() Raid_Roll_SetMsg1_EditBox:ClearFocus() end)

    -- Set Msg2
    Raid_Roll_SetMsg2_String = RaidRoll_LootPanel:CreateFontString("Raid_Roll_SetMsg2_String", "ARTWORK", "GameFontNormal")
    Raid_Roll_SetMsg2_String:SetPoint("TopLeft", RaidRoll_LootPanel, "TOPLEFT", 10, -100)
    Raid_Roll_SetMsg2_String:SetJustifyH("LEFT")

    Raid_Roll_SetMsg2_String:SetText("|cFF69CCF0" .. RAIDROLL_LOCALE["Set_Msg2"])
    if (GetLocale() ~= "zhTW") then
        Raid_Roll_SetMsg2_String:SetFont("Fonts\\FRIZQT__.TTF", 14)
    end
    if (GetLocale() == "zhCN") then
        Raid_Roll_SetMsg2_String:SetFont("Fonts\\ZYKai_T.TTF", 15)
    end

    -- Msg2 edit box
    RR_Msg2_FRAME = CreateFrame("Frame", "RR_Msg2_FRAME", RaidRoll_LootPanel)
    rr_MsgFrame_backdrop = {
        bgFile = "",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", -- path to the border texture

        tile = false, -- true to repeat the background texture to fill the frame, false to scale it
        tileSize = 32, -- size (width or height) of the square repeating background tiles (in pixels)
        edgeSize = 20, -- thickness of edge segments and square size of edge corners (in pixels)
        insets = {
            -- distance from the edges of the frame to those of the background texture (in pixels)
            left = 2,
            right = 2,
            top = 2,
            bottom = 2
        }
    }
    RR_Msg2_FRAME:SetBackdrop(rr_MsgFrame_backdrop)
    RR_Msg2_FRAME:SetWidth(390) -- Set these to whatever height/width is needed
    RR_Msg2_FRAME:SetHeight(25) -- Set these to whatever height/width is needed
    RR_Msg2_FRAME:SetPoint("TopLeft", RaidRoll_LootPanel, "TOPLEFT", 10, -120)

    Raid_Roll_SetMsg2_EditBox = CreateFrame("EditBox", "Raid_Roll_SetMsg2_EditBox", RaidRoll_LootPanel, InputBoxTemplate)
    if (GetLocale() ~= "zhTW") then
        Raid_Roll_SetMsg2_EditBox:SetFont("Fonts\\FRIZQT__.TTF", 14)
    end
    if (GetLocale() == "zhCN") then
        Raid_Roll_SetMsg2_EditBox:SetFont("Fonts\\ZYKai_T.TTF", 15)
    end
    Raid_Roll_SetMsg2_EditBox:SetAutoFocus(false)
    Raid_Roll_SetMsg2_EditBox:SetWidth(380)
    Raid_Roll_SetMsg2_EditBox:SetHeight(20)
    Raid_Roll_SetMsg2_EditBox:SetPoint("Left", RR_Msg2_FRAME, "Left", 8, 0)
    Raid_Roll_SetMsg2_EditBox:SetScript("OnEditFocusLost", function()
        RaidRoll_DBPC[UnitName("player")]["Raid_Roll_SetMsg2_EditBox"] = Raid_Roll_SetMsg2_EditBox:GetText()
    end)
    Raid_Roll_SetMsg2_EditBox:SetScript("OnChar", function()
        RaidRoll_DBPC[UnitName("player")]["Raid_Roll_SetMsg2_EditBox"] = Raid_Roll_SetMsg2_EditBox:GetText()
    end)
    Raid_Roll_SetMsg2_EditBox:SetScript("OnEnterPressed", function() Raid_Roll_SetMsg2_EditBox:ClearFocus() end)
    Raid_Roll_SetMsg2_EditBox:SetScript("OnEscapePressed", function() Raid_Roll_SetMsg2_EditBox:ClearFocus() end)

    -- Set Msg3
    Raid_Roll_SetMsg3_String = RaidRoll_LootPanel:CreateFontString("Raid_Roll_SetMsg3_String", "ARTWORK", "GameFontNormal")
    Raid_Roll_SetMsg3_String:SetPoint("TopLeft", RaidRoll_LootPanel, "TOPLEFT", 10, -150)
    Raid_Roll_SetMsg3_String:SetJustifyH("LEFT")

    Raid_Roll_SetMsg3_String:SetText("|cFF69CCF0" .. RAIDROLL_LOCALE["Set_Msg3"])
    if (GetLocale() ~= "zhTW") then
        Raid_Roll_SetMsg3_String:SetFont("Fonts\\FRIZQT__.TTF", 14)
    end
    if (GetLocale() == "zhCN") then
        Raid_Roll_SetMsg3_String:SetFont("Fonts\\ZYKai_T.TTF", 15)
    end

    -- Msg3 edit box
    RR_Msg3_FRAME = CreateFrame("Frame", "RR_Msg3_FRAME", RaidRoll_LootPanel)
    rr_MsgFrame_backdrop = {
        bgFile = "",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", -- path to the border texture

        tile = false, -- true to repeat the background texture to fill the frame, false to scale it
        tileSize = 32, -- size (width or height) of the square repeating background tiles (in pixels)
        edgeSize = 20, -- thickness of edge segments and square size of edge corners (in pixels)
        insets = {
            -- distance from the edges of the frame to those of the background texture (in pixels)
            left = 2,
            right = 2,
            top = 2,
            bottom = 2
        }
    }
    RR_Msg3_FRAME:SetBackdrop(rr_MsgFrame_backdrop)
    RR_Msg3_FRAME:SetWidth(390) -- Set these to whatever height/width is needed
    RR_Msg3_FRAME:SetHeight(25) -- Set these to whatever height/width is needed
    RR_Msg3_FRAME:SetPoint("TopLeft", RaidRoll_LootPanel, "TOPLEFT", 10, -170)

    Raid_Roll_SetMsg3_EditBox = CreateFrame("EditBox", "Raid_Roll_SetMsg3_EditBox", RaidRoll_LootPanel, InputBoxTemplate)
    if (GetLocale() ~= "zhTW") then
        Raid_Roll_SetMsg3_EditBox:SetFont("Fonts\\FRIZQT__.TTF", 14)
    end
    if (GetLocale() == "zhCN") then
        Raid_Roll_SetMsg3_EditBox:SetFont("Fonts\\ZYKai_T.TTF", 15)
    end
    Raid_Roll_SetMsg3_EditBox:SetAutoFocus(false)
    Raid_Roll_SetMsg3_EditBox:SetWidth(380)
    Raid_Roll_SetMsg3_EditBox:SetHeight(20)
    Raid_Roll_SetMsg3_EditBox:SetPoint("Left", RR_Msg3_FRAME, "Left", 8, 0)
    Raid_Roll_SetMsg3_EditBox:SetScript("OnEditFocusLost", function()
        RaidRoll_DBPC[UnitName("player")]["Raid_Roll_SetMsg3_EditBox"] = Raid_Roll_SetMsg3_EditBox:GetText()
    end)
    Raid_Roll_SetMsg3_EditBox:SetScript("OnChar", function()
        RaidRoll_DBPC[UnitName("player")]["Raid_Roll_SetMsg3_EditBox"] = Raid_Roll_SetMsg3_EditBox:GetText()
    end)
    Raid_Roll_SetMsg3_EditBox:SetScript("OnEnterPressed", function() Raid_Roll_SetMsg3_EditBox:ClearFocus() end)
    Raid_Roll_SetMsg3_EditBox:SetScript("OnEscapePressed", function() Raid_Roll_SetMsg3_EditBox:ClearFocus() end)

    -- (Use [item] to announce the itemlink)
    Raid_Roll_PanelName_String = RaidRoll_LootPanel:CreateFontString("Raid_Roll_PanelName_String", "ARTWORK", "GameFontNormal")
    Raid_Roll_PanelName_String:SetPoint("TopLeft", RaidRoll_LootPanel, "TopLeft", 15, -200)
    Raid_Roll_PanelName_String:SetJustifyH("LEFT")

    Raid_Roll_PanelName_String:SetText("|cFFFFFFFF" .. RAIDROLL_LOCALE["Use_Item_Brackets"])
    if (GetLocale() ~= "zhTW") then
        Raid_Roll_PanelName_String:SetFont("Fonts\\FRIZQT__.TTF", 12)
    end
    if (GetLocale() == "zhCN") then
        Raid_Roll_PanelName_String:SetFont("Fonts\\ZYKai_T.TTF", 15)
    end

    -- General settings
    Raid_Roll_PanelName_String = RaidRoll_LootPanel:CreateFontString("Raid_Roll_PanelName_String", "ARTWORK", "GameFontNormal")
    Raid_Roll_PanelName_String:SetPoint("TopLeft", RaidRoll_LootPanel, "TopLeft", 20, -230)
    Raid_Roll_PanelName_String:SetJustifyH("LEFT")

    Raid_Roll_PanelName_String:SetText("|cFF2459FF" .. RAIDROLL_LOCALE["General_Settings"])
    if (GetLocale() ~= "zhTW") then
        Raid_Roll_PanelName_String:SetFont("Fonts\\FRIZQT__.TTF", 16)
    end
    if (GetLocale() == "zhCN") then
        Raid_Roll_PanelName_String:SetFont("Fonts\\ZYKai_T.TTF", 15)
    end

    -- [ ] Automatically open window when loot is found
    RR_AutoOpenLootWindow = CreateFrame("CheckButton", "RR_AutoOpenLootWindow", RaidRoll_LootPanel, "UICheckButtonTemplate")
    RR_AutoOpenLootWindow:SetWidth(20)
    RR_AutoOpenLootWindow:SetHeight(20)
    RR_AutoOpenLootWindow:SetPoint("TopLeft", RaidRoll_LootPanel, "TopLeft", 30, -250)
    _G["RR_AutoOpenLootWindow" .. "Text"]:SetText("|cFFFFFFFF" .. RAIDROLL_LOCALE["Automatically_open_window_when_new_loot_is_found"])
    if (GetLocale() ~= "zhTW") then
        _G["RR_AutoOpenLootWindow" .. "Text"]:SetFont("Fonts\\FRIZQT__.TTF", 12)
    end
    if (GetLocale() == "zhCN") then
        _G["RR_AutoOpenLootWindow" .. "Text"]:SetFont("Fonts\\ZYKai_T.TTF", 15)
    end
    RR_AutoOpenLootWindow:SetScript("OnClick", RaidRoll_CheckButton_Update_Panel)

    -- [ ] Receive loot messages from guild
    RR_ReceiveGuildMessages = CreateFrame("CheckButton", "RR_ReceiveGuildMessages", RaidRoll_LootPanel, "UICheckButtonTemplate")
    RR_ReceiveGuildMessages:SetWidth(20)
    RR_ReceiveGuildMessages:SetHeight(20)
    RR_ReceiveGuildMessages:SetPoint("TopLeft", RaidRoll_LootPanel, "TopLeft", 30, -270)
    _G["RR_ReceiveGuildMessages" .. "Text"]:SetText("|cFFFFFFFF" .. RAIDROLL_LOCALE["Receive_loot_messages_from_guild"])
    if (GetLocale() ~= "zhTW") then
        _G["RR_ReceiveGuildMessages" .. "Text"]:SetFont("Fonts\\FRIZQT__.TTF", 12)
    end
    if (GetLocale() == "zhCN") then
        _G["RR_ReceiveGuildMessages" .. "Text"]:SetFont("Fonts\\ZYKai_T.TTF", 15)
    end
    RR_ReceiveGuildMessages:SetScript("OnClick", RaidRoll_CheckButton_Update_Panel)

    -- [ ] Enable 3 Messages
    RR_Enable3Messages = CreateFrame("CheckButton", "RR_Enable3Messages", RaidRoll_LootPanel, "UICheckButtonTemplate")
    RR_Enable3Messages:SetWidth(20)
    RR_Enable3Messages:SetHeight(20)
    RR_Enable3Messages:SetPoint("TopLeft", RaidRoll_LootPanel, "TopLeft", 30, -290)
    _G["RR_Enable3Messages" .. "Text"]:SetText("|cFFFFFFFF" .. RAIDROLL_LOCALE["RR_Enable3Messages"])
    if (GetLocale() ~= "zhTW") then
        _G["RR_Enable3Messages" .. "Text"]:SetFont("Fonts\\FRIZQT__.TTF", 12)
    end
    if (GetLocale() == "zhCN") then
        _G["RR_Enable3Messages" .. "Text"]:SetFont("Fonts\\ZYKai_T.TTF", 15)
    end
    RR_Enable3Messages:SetScript("OnClick", RaidRoll_CheckButton_Update_Panel)

    -- [ ] WotLK Dungeons Only
    RR_Frame_WotLK_Dung_Only = CreateFrame("CheckButton", "RR_Frame_WotLK_Dung_Only", RaidRoll_LootPanel, "UICheckButtonTemplate")
    RR_Frame_WotLK_Dung_Only:SetWidth(20)
    RR_Frame_WotLK_Dung_Only:SetHeight(20)
    RR_Frame_WotLK_Dung_Only:SetPoint("TopLeft", RaidRoll_LootPanel, "TopLeft", 30, -310)
    _G["RR_Frame_WotLK_Dung_Only" .. "Text"]:SetText("|cFFFFFFFF" .. RAIDROLL_LOCALE["RR_WotLK_Dung_Only"])
    if (GetLocale() ~= "zhTW") then
        _G["RR_Frame_WotLK_Dung_Only" .. "Text"]:SetFont("Fonts\\FRIZQT__.TTF", 12)
    end
    if (GetLocale() == "zhCN") then
        _G["RR_Frame_WotLK_Dung_Only" .. "Text"]:SetFont("Fonts\\ZYKai_T.TTF", 15)
    end
    RR_Frame_WotLK_Dung_Only:SetScript("OnClick", RaidRoll_CheckButton_Update_Panel)
    RR_Frame_WotLK_Dung_Only:SetScript("OnEnter", function(self) RR_MouseOverTooltip(self:GetName()) end)
    RR_Frame_WotLK_Dung_Only:SetScript("OnLeave", function() GameTooltip:Hide() end)

    --[[
    -- Give Extra Priority to:
    Raid_Roll_PanelName_String =  RaidRoll_LootPanel:CreateFontString("Raid_Roll_PanelName_String" ,"ARTWORK","GameFontNormal")
    Raid_Roll_PanelName_String:SetPoint("TopLeft", RaidRoll_LootPanel, "TopLeft", 20, -40)
    Raid_Roll_PanelName_String:SetJustifyH("LEFT")

    Raid_Roll_PanelName_String:SetText("|cFF2459FF" .. RAIDROLL_LOCALE["General_Settings"])
    Raid_Roll_PanelName_String:SetFont("Fonts\\FRIZQT__.TTF", 16)

    -- [ ] Catch Unannounced Rolls
    RR_RollCheckBox_Unannounced_panel = CreateFrame("CheckButton", "RR_RollCheckBox_Unannounced_panel", RaidRoll_LootPanel, "UICheckButtonTemplate")
    RR_RollCheckBox_Unannounced_panel:SetWidth(20)
    RR_RollCheckBox_Unannounced_panel:SetHeight(20)
    RR_RollCheckBox_Unannounced_panel:SetPoint("TopLeft", RaidRoll_LootPanel, "TopLeft",  30, -60)
    _G["RR_RollCheckBox_Unannounced_panel".."Text"]:SetText("|cFFFFFFFF" .. RAIDROLL_LOCALE["Catch_Unannounced_Rolls"])
    _G["RR_RollCheckBox_Unannounced_panel".."Text"]:SetFont("Fonts\\FRIZQT__.TTF", 12)
    RR_RollCheckBox_Unannounced_panel:SetScript("OnClick",RaidRoll_CheckButton_Update_Panel)
    --]]
end

--[[
/run SendAddonMessage( "RRL", "Alpha\ax\aTest\aTestMob\ax\a\124cff1eff00\124Hitem:1210:0:0:0:0:0:0:0:0\124h[Shadowgem]\124h\124r\a4\aInterface\\Icons\\INV_Misc_Gem_Amethyst_01\aShadowgem\a20" ,"GUILD" )

SendAddonMessage( "RRL  Alpha\ax\aTest\aTestMob\ax\a\124cff1eff00\124Hitem:1210:0:0:0:0:0:0:0:0\124h[Shadowgem]\124h\124r\a4\aInterface\\Icons\\INV_Misc_Gem_Amethyst_01\aShadowgem\a20" ,"GUILD" )

RR_AddonMessageReceived("RRL \tAlpha\ax\aTest\aTestMob\ax\a\124cff1eff00\124Hitem:1210:0:0:0:0:0:0:0:0\124h[Shadowgem]\124h\124r\a4\aInterface\\Icons\\INV_Misc_Gem_Amethyst_01\aShadowgem\a20" ,"RAID")
--]]

function RR_DC()
    SendAddonMessage("RRL", "Alpha\ax\aTe1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890st\aTestMob\ax\a\124cff1eff00\124Hitem:1210:0:0:0:0:0:0:0:0\124h[Shadowgem]\124h\124r\a4\aInterface\\Icons\\INV_Misc_Gem_Amethyst_01\aShadowgem\a20", "GUILD")
end

function RR_AddonMessageReceived(String, Channel)
    local Version, mob_guid, player_name, mob_name, LootNumber, ItemLink, rarity, lootIcon, lootName, ItemLvl

    -- Ignore the message if it comes from guild and you have that option turned off
    if Channel == "RAID" or Channel == "PARTY" or (Channel == "GUILD" and RaidRoll_DBPC[UnitName("player")]["RR_ReceiveGuildMessages"] == true) then

        if String ~= nil then
            Seperator = "\a" -- "\226\149\145"
            Version, _ = strsplit(Seperator, String, 2)

            if Version == nil then
                if time() >= RR_LastItemDataReSent + 5 then
                    if IsInRaid() or IsInGroup() then
                        SendAddonMessage("RRL", "Request", IsInRaid() and "RAID" or "PARTY")
                    end
                end
            end

            -- Alpha Version Handler
            if Version == "Alpha" then
                Version, mob_guid, player_name, mob_name, LootNumber, ItemLink, rarity, lootIcon, lootName, ItemLvl, _ = strsplit(Seperator, String, 11)
                rarity = tonumber(rarity)

                if RaidRoll_DB["debug"] == true then
                    RR_Test("-----Item Received Breakdown-----")
                    RR_Test(String)
                    RR_Test(Version)
                    RR_Test(mob_guid)
                    RR_Test(player_name)
                    RR_Test(mob_name)
                    RR_Test(LootNumber)
                    RR_Test(ItemLink)
                    RR_Test(rarity)
                    RR_Test(lootIcon)
                    RR_Test(lootName)
                    RR_Test(strlen(String))
                    RR_Test(Channel)
                end

                RR_DuplicateItemFound = false

                TotalWindows = RaidRoll_DB["Loot"]["TOTAL WINDOWS"]
                CurrentWindow = RaidRoll_DB["Loot"]["CURRENT WINDOW"]

                if RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] ~= nil then
                    for i = 1, RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] do
                        if RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. i]["LOOTNAME"] == lootName then
                            RR_DuplicateItemFound = true
                        end
                    end
                end

                if RR_LastLootMessageTime == nil then RR_LastLootMessageTime = 0 end

                if RaidRoll_DB["debug"] == true then
                    RR_Test("---Addon Message Times---")
                    RR_Test(RR_LastLootMessageTime)
                    RR_Test(GetTime())
                    RR_Test(GetTime() - RR_LastLootMessageTime)
                end

                -- If the time record is empty or if the message is received in more than 30 seconds of the last one then create a new window
                if RR_DuplicateItemFound == false then
                    if GetTime() > (RR_LastLootMessageTime + 30) then
                        -- Auto Open the window
                        if RaidRoll_DBPC[UnitName("player")]["RR_AutoOpenLootWindow"] == true then RR_LOOT_FRAME:Show() end
                        RaidRoll_Loot_Slider:SetValue(1)
                        RR_LastLootMessageTime = GetTime()
                        RaidRoll_DB["Loot"]["TOTAL WINDOWS"] = RaidRoll_DB["Loot"]["TOTAL WINDOWS"] + 1
                        if RaidRoll_DB["Loot"]["CURRENT WINDOW"] == RaidRoll_DB["Loot"]["TOTAL WINDOWS"] - 1 then
                            RaidRoll_DB["Loot"]["CURRENT WINDOW"] = RaidRoll_DB["Loot"]["TOTAL WINDOWS"]
                        end
                    end
                end

                TotalWindows = RaidRoll_DB["Loot"]["TOTAL WINDOWS"]
                CurrentWindow = RaidRoll_DB["Loot"]["CURRENT WINDOW"]

                if RaidRoll_DB["Loot"][TotalWindows] == nil then
                    RaidRoll_DB["Loot"][TotalWindows] = {}
                end

                local _, _, _, _, ItemId = string.find(ItemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

                ItemId = tonumber(ItemId)

                if ItemLvl == nil then
                    ItemLvl = GetItemInfo(ItemId)
                else
                    if tonumber(ItemLvl) == nil then
                        ItemLvl = GetItemInfo(ItemId)
                    end
                end

                if ItemLvl == nil then
                    ItemLvl = 0
                end

                ItemLvl = tonumber(ItemLvl)

                AcceptItem = false
                -- Special rare items that should be included
                if ItemId == 46110 or -- Alchemist's Cache
                    ItemId == 47556 or -- Crusader Orb
                    ItemId == 45087 or -- Runed Orb
                    ItemId == 49908 then -- Primordial Saronite
                    AcceptItem = true
                    RR_Debug("[Rarity] This is an acceptable Item - " .. lootName)
                else
                    RR_Debug("[Rarity] This is >NOT< an acceptable Item - " .. lootName)
                end

                DontAcceptItem = false
                -- Special epic items that should not be included
                if ItemId == 34057 or -- Abyss Crystal

                    ItemId == 36931 or -- Ametrine
                    ItemId == 36919 or -- Cardinal Ruby
                    ItemId == 36928 or -- Dreadstone
                    ItemId == 36934 or -- Eye of Zul
                    ItemId == 36922 or -- King's Amber
                    ItemId == 36925 or -- Majestic Zircon

                    ItemId == 47241 or -- Emblem of Triumph
                    ItemId == 49426 then -- Emblem of Frost
                    DontAcceptItem = true
                    RR_Debug("[Epic Items] This is >NOT< an acceptable Item - " .. lootName)
                else
                    RR_Debug("[Epic Items] This is an acceptable Item - " .. lootName)
                end

                if rarity == nil then rarity = 0 end
                if AcceptItem == nil then AcceptItem = false end

                if rarity > 3 or RaidRoll_DB["debug"] == true or AcceptItem == true then
                    if DontAcceptItem == false then
                        if RR_DuplicateItemFound == false then
                            -- If the message is received in less than 60 seconds of the last one then scan the list for the item and add it to the list if its not already there
                            RaidRoll_DB["Loot"][TotalWindows]["LOOTER NAME"] = player_name
                            RaidRoll_DB["Loot"][TotalWindows]["MOB NAME"] = mob_name
                            if RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] == nil then RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] = 0 end
                            RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] = RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] + 1

                            LootNumber = RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"]

                            if RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber] == nil then
                                RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber] = {}
                            end

                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["LOOTNAME"] = lootName
                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["ITEMLINK"] = ItemLink
                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["ICON"] = lootIcon
                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["WINNER"] = "-"
                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["RECEIVED"] = "-"
                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["ITEMLEVEL"] = ItemLvl

                            RR_Loot_SortByItemLevel(TotalWindows)
                        end
                    end
                end
            end

            -- Beta Version Handler
            if Version == "Beta_2" then
                Version, player_name, mob_name, ItemId, lootName, ItemLvl, _ = strsplit(Seperator, String, 7)

                if RaidRoll_DB["debug"] == true then
                    RR_Test("-----Item Received Breakdown-----")
                    RR_Test(String)
                    RR_Test(Version)
                    RR_Test(player_name)
                    RR_Test(mob_name)
                    RR_Test(ItemId)
                    RR_Test(lootName)
                    RR_Test(strlen(String))
                    RR_Test(Channel)
                end

                RR_DuplicateItemFound = false

                TotalWindows = RaidRoll_DB["Loot"]["TOTAL WINDOWS"]
                CurrentWindow = RaidRoll_DB["Loot"]["CURRENT WINDOW"]

                if RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] ~= nil then
                    for i = 1, RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] do
                        if RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. i]["LOOTNAME"] == lootName then
                            RR_DuplicateItemFound = true
                        end
                    end
                end

                if RR_LastLootMessageTime == nil then RR_LastLootMessageTime = 0 end

                if RaidRoll_DB["debug"] == true then
                    RR_Test("---Addon Message Times---")
                    RR_Test(RR_LastLootMessageTime)
                    RR_Test(GetTime())
                    RR_Test(GetTime() - RR_LastLootMessageTime)
                end

                -- If the time record is empty or if the message is received in more than 30 seconds of the last one then create a new window
                if RR_DuplicateItemFound == false then
                    if GetTime() > (RR_LastLootMessageTime + 30) then
                        -- Auto Open the window
                        if RaidRoll_DBPC[UnitName("player")]["RR_AutoOpenLootWindow"] == true then RR_LOOT_FRAME:Show() end
                        RaidRoll_Loot_Slider:SetValue(1)
                        RR_LastLootMessageTime = GetTime()
                        RaidRoll_DB["Loot"]["TOTAL WINDOWS"] = RaidRoll_DB["Loot"]["TOTAL WINDOWS"] + 1
                        if RaidRoll_DB["Loot"]["CURRENT WINDOW"] == RaidRoll_DB["Loot"]["TOTAL WINDOWS"] - 1 then
                            RaidRoll_DB["Loot"]["CURRENT WINDOW"] = RaidRoll_DB["Loot"]["TOTAL WINDOWS"]
                        end
                    end
                end

                TotalWindows = RaidRoll_DB["Loot"]["TOTAL WINDOWS"]
                CurrentWindow = RaidRoll_DB["Loot"]["CURRENT WINDOW"]

                if RaidRoll_DB["Loot"][TotalWindows] == nil then
                    RaidRoll_DB["Loot"][TotalWindows] = {}
                end

                --local _, _, _, _, ItemId = string.find(ItemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

                if ItemId == nil then
                    ItemId = 0
                else
                    ItemId = tonumber(ItemId)
                end

                _, ItemLink, rarity, ItemLvl, _, _, _, _, _, lootIcon = GetItemInfo(ItemId)

                rarity = tonumber(rarity)

                if ItemLvl == nil then
                    ItemLvl = 0
                end

                ItemLvl = tonumber(ItemLvl)

                AcceptItem = false
                -- Special rare items that should be included
                if ItemId == 46110 or  -- Alchemist's Cache
                    ItemId == 47556 or -- Crusader Orb
                    ItemId == 45087 or -- Runed Orb
                    ItemId == 49908    -- Primordial Saronite
                then
                    AcceptItem = true
                    RR_Debug("[Rarity] This is an acceptable Item - " .. lootName)
                else
                    RR_Debug("[Rarity] This is >NOT< an acceptable Item - " .. lootName)
                end

                DontAcceptItem = false
                -- Special epic items that should not be included
                if ItemId == 34057 or -- Abyss Crystal
                    ItemId == 36931 or -- Ametrine
                    ItemId == 36919 or -- Cardinal Ruby
                    ItemId == 36928 or -- Dreadstone
                    ItemId == 36934 or -- Eye of Zul
                    ItemId == 36922 or -- King's Amber
                    ItemId == 36925 or -- Majestic Zircon
                    ItemId == 47241 or -- Emblem of Triumph
                    ItemId == 49426    -- Emblem of Frost
                then
                    DontAcceptItem = true
                    RR_Debug("[Epic Items] This is >NOT< an acceptable Item - " .. lootName)
                else
                    RR_Debug("[Epic Items] This is an acceptable Item - " .. lootName)
                end

                if rarity == nil then rarity = 0 end
                if AcceptItem == nil then AcceptItem = false end

                if rarity > 3 or RaidRoll_DB["debug"] == true or AcceptItem == true then
                    if DontAcceptItem == false then
                        if RR_DuplicateItemFound == false then
                            -- If the message is received in less than 60 seconds of the last one then scan the list for the item and add it to the list if its not already there
                            RaidRoll_DB["Loot"][TotalWindows]["LOOTER NAME"] = player_name
                            RaidRoll_DB["Loot"][TotalWindows]["MOB NAME"] = mob_name
                            if RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] == nil then RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] = 0 end
                            RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] = RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] + 1

                            LootNumber = RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"]

                            if RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber] == nil then
                                RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber] = {}
                            end

                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["LOOTNAME"] = lootName
                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["ITEMLINK"] = ItemLink
                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["ICON"] = lootIcon
                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["WINNER"] = "-"
                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["RECEIVED"] = "-"
                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["ITEMLEVEL"] = ItemLvl

                            RR_Loot_SortByItemLevel(TotalWindows)
                        end
                    end
                end
            end

			--Fixed version for WoD
            if Version == "WoDFixed" then
                Version, player_name, mob_name, ItemId, lootName, ItemLvl, ItemLink, _ = strsplit(Seperator, String, 8)
				
                if RaidRoll_DB["debug"] == true then
                    RR_Test("-----Item Received Breakdown-----")
                    RR_Test(String)
                    RR_Test(Version)
                    RR_Test(player_name)
                    RR_Test(mob_name)
                    RR_Test(ItemId)
                    RR_Test(lootName)
                    RR_Test(strlen(String))
                    RR_Test(Channel)
                end

                RR_DuplicateItemFound = false

                TotalWindows = RaidRoll_DB["Loot"]["TOTAL WINDOWS"]
                CurrentWindow = RaidRoll_DB["Loot"]["CURRENT WINDOW"]

                if RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] ~= nil then
                    for i = 1, RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] do
                        if RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. i]["LOOTNAME"] == lootName then
                            RR_DuplicateItemFound = true
                        end
                    end
                end

                if RR_LastLootMessageTime == nil then RR_LastLootMessageTime = 0 end

                if RaidRoll_DB["debug"] == true then
                    RR_Test("---Addon Message Times---")
                    RR_Test(RR_LastLootMessageTime)
                    RR_Test(GetTime())
                    RR_Test(GetTime() - RR_LastLootMessageTime)
                end

                -- If the time record is empty or if the message is received in more than 30 seconds of the last one then create a new window
                if RR_DuplicateItemFound == false then
                    if GetTime() > (RR_LastLootMessageTime + 30) then
                        -- Auto Open the window
                        if RaidRoll_DBPC[UnitName("player")]["RR_AutoOpenLootWindow"] == true then RR_LOOT_FRAME:Show() end
                        RaidRoll_Loot_Slider:SetValue(1)
                        RR_LastLootMessageTime = GetTime()
                        RaidRoll_DB["Loot"]["TOTAL WINDOWS"] = RaidRoll_DB["Loot"]["TOTAL WINDOWS"] + 1
                        if RaidRoll_DB["Loot"]["CURRENT WINDOW"] == RaidRoll_DB["Loot"]["TOTAL WINDOWS"] - 1 then
                            RaidRoll_DB["Loot"]["CURRENT WINDOW"] = RaidRoll_DB["Loot"]["TOTAL WINDOWS"]
                        end
                    end
                end

                TotalWindows = RaidRoll_DB["Loot"]["TOTAL WINDOWS"]
                CurrentWindow = RaidRoll_DB["Loot"]["CURRENT WINDOW"]

                if RaidRoll_DB["Loot"][TotalWindows] == nil then
                    RaidRoll_DB["Loot"][TotalWindows] = {}
                end

                --local _, _, _, _, ItemId = string.find(ItemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

                if ItemId == nil then
                    ItemId = 0
                else
                    ItemId = tonumber(ItemId)
                end

                _, _, rarity, ItemLvl, _, _, _, _, _, lootIcon = GetItemInfo(ItemId)

                rarity = tonumber(rarity)

                if ItemLvl == nil then
                    ItemLvl = 0
                end

                ItemLvl = tonumber(ItemLvl)

                AcceptItem = false
                -- Special rare items that should be included
                if ItemId == 46110 or  -- Alchemist's Cache
                    ItemId == 47556 or -- Crusader Orb
                    ItemId == 45087 or -- Runed Orb
                    ItemId == 49908    -- Primordial Saronite
                then
                    AcceptItem = true
                    RR_Debug("[Rarity] This is an acceptable Item - " .. lootName)
                else
                    RR_Debug("[Rarity] This is >NOT< an acceptable Item - " .. lootName)
                end

                DontAcceptItem = false
                -- Special epic items that should not be included
                if ItemId == 34057 or -- Abyss Crystal
                    ItemId == 36931 or -- Ametrine
                    ItemId == 36919 or -- Cardinal Ruby
                    ItemId == 36928 or -- Dreadstone
                    ItemId == 36934 or -- Eye of Zul
                    ItemId == 36922 or -- King's Amber
                    ItemId == 36925 or -- Majestic Zircon
                    ItemId == 47241 or -- Emblem of Triumph
                    ItemId == 49426    -- Emblem of Frost
                then
                    DontAcceptItem = true
                    RR_Debug("[Epic Items] This is >NOT< an acceptable Item - " .. lootName)
                else
                    RR_Debug("[Epic Items] This is an acceptable Item - " .. lootName)
                end

                if rarity == nil then rarity = 0 end
                if AcceptItem == nil then AcceptItem = false end

                if rarity > 3 or RaidRoll_DB["debug"] == true or AcceptItem == true then
                    if DontAcceptItem == false then
                        if RR_DuplicateItemFound == false then
                            -- If the message is received in less than 60 seconds of the last one then scan the list for the item and add it to the list if its not already there
                            RaidRoll_DB["Loot"][TotalWindows]["LOOTER NAME"] = player_name
                            RaidRoll_DB["Loot"][TotalWindows]["MOB NAME"] = mob_name
                            if RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] == nil then RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] = 0 end
                            RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] = RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"] + 1

                            LootNumber = RaidRoll_DB["Loot"][TotalWindows]["TOTAL ITEMS"]

                            if RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber] == nil then
                                RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber] = {}
                            end

                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["LOOTNAME"] = lootName
                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["ITEMLINK"] = ItemLink
                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["ICON"] = lootIcon
                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["WINNER"] = "-"
                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["RECEIVED"] = "-"
                            RaidRoll_DB["Loot"][TotalWindows]["ITEM_" .. LootNumber]["ITEMLEVEL"] = ItemLvl

                            RR_Loot_SortByItemLevel(TotalWindows)
                        end
                    end
                end
            end
        else
            if time() >= RR_LastItemDataReSent + 5 then
                if IsInRaid() or IsInGroup() then
                    SendAddonMessage("RRL", "Request", IsInRaid() and "RAID" or "PARTY")
                end
            end
        end
    end

    RR_Loot_Display_Refresh()
end

function RR_Loot_SortByItemLevel(windowNumber)
    local MaxItems = RaidRoll_DB["Loot"][windowNumber]["TOTAL ITEMS"]
    RR_Debug("*****Sorting " .. tostring(MaxItems) .. " by item level*****")

    if MaxItems and MaxItems > 1 then
        for j = 1, MaxItems do
            for i = 1, MaxItems - 1 do
                local firstIlevel = RaidRoll_DB["Loot"][windowNumber]["ITEM_" .. i]["ITEMLEVEL"]
                local secondIlevel = RaidRoll_DB["Loot"][windowNumber]["ITEM_" .. i + 1]["ITEMLEVEL"]

                if firstIlevel ~= nil and secondIlevel ~= nil then
                    local firstName = RaidRoll_DB["Loot"][windowNumber]["ITEM_" .. i]["LOOTNAME"]
                    local secondName = RaidRoll_DB["Loot"][windowNumber]["ITEM_" .. i + 1]["LOOTNAME"]

                    -- Move second item before first item if:
                    --   + Second item is a higher ilevel than the first item
                    --   + Both items are the same ilevel, but second item is alphabetically before the first item
                    if firstIlevel < secondIlevel or (firstIlevel == secondIlevel and firstName > secondName) then
                        RR_Debug("Swapping " .. i .. " (" .. firstIlevel .. ": " .. firstName .. ") and " .. (i + 1) .. " (" .. secondIlevel .. ": " .. secondName .. ")")
                        local temp = {}
                        temp = RaidRoll_DB["Loot"][windowNumber]["ITEM_" .. i]
                        RaidRoll_DB["Loot"][windowNumber]["ITEM_" .. i] = RaidRoll_DB["Loot"][windowNumber]["ITEM_" .. i + 1]
                        RaidRoll_DB["Loot"][windowNumber]["ITEM_" .. i + 1] = temp
                    else
                        RR_Debug("Keeping " .. i .. " (" .. firstIlevel .. ": " .. firstName .. ") before " .. (i + 1) .. " (" .. secondIlevel .. ": " .. secondName .. ")")
                    end
                end
            end
        end
    end
end

-- /run T=time();Upd = CreateFrame("Frame");Upd:SetScript("OnUpdate",function() if time()>T+5 then T=time();DEFAULT_CHAT_FRAME:AddMessage(GetMouseFocus():GetName()); end end)

-- sets up the loot frame
function RR_SetupLootFrame()

    --Clear the database (debugging)
    --RaidRoll_DB["Loot"] = {}

    if RaidRoll_DB["Loot"] == nil then RaidRoll_DB["Loot"] = {} end
    if RaidRoll_DB["Loot"]["TOTAL WINDOWS"] == nil then RaidRoll_DB["Loot"]["TOTAL WINDOWS"] = 0 end
    if RaidRoll_DB["Loot"]["CURRENT WINDOW"] == nil then RaidRoll_DB["Loot"]["CURRENT WINDOW"] = 0 end

    -- Dim the background texture so it doesn't make the window text harder to read
    RR_LOOT_FRAME.RR_Background:SetVertexColor(0.4, 0.4, 0.4)

    RR_LOOT_FRAME:SetMovable(true)
    RR_LOOT_FRAME:EnableMouse(true)
    RR_LOOT_FRAME:SetScript("OnMouseDown", function()
        RR_LOOT_FRAME:StartMoving()
    end)
    RR_LOOT_FRAME:SetScript("OnMouseUp", function()
        RR_LOOT_FRAME:StopMovingOrSizing()
    end)

    RR_LOOT_FRAME:SetScript("OnShow", function()
        RaidRoll_Loot_Slider_Window_Scroll(0)
    end)

    -- Create 5 strings and a header for the guild ranks
    --Raid_Roll_Loot=CreateFrame("FRAME","Raid_Roll_Loot",RR_LOOT_FRAME)

    RR_Loot_String_WindowName = RR_LOOT_FRAME:CreateFontString("Window Name", "ARTWORK", "GameFontNormal")
    RR_Loot_String_WindowName:SetPoint("TOPLEFT", RR_LOOT_FRAME, "TOPLEFT", 8, -8)
    RR_Loot_String_WindowName:SetJustifyH("LEFT")
    RR_Loot_String_WindowName:SetText("Musou's Loot Tracker")

    RR_Loot_String_MobName = RR_LOOT_FRAME:CreateFontString("Mob Name", "ARTWORK", "GameFontNormal")
    RR_Loot_String_MobName:SetPoint("TOPLEFT", RR_LOOT_FRAME, "TOPLEFT", 8, -205)
    RR_Loot_String_MobName:SetJustifyH("LEFT")
    RR_Loot_String_MobName:SetText(RAIDROLL_LOCALE["Mob"])

    RR_Loot_String_LooterName = RR_LOOT_FRAME:CreateFontString("Looter Name", "ARTWORK", "GameFontNormal")
    RR_Loot_String_LooterName:SetPoint("TOPLEFT", RR_LOOT_FRAME, "TOPLEFT", 8, -218)
    RR_Loot_String_LooterName:SetJustifyH("LEFT")
    RR_Loot_String_LooterName:SetText(RAIDROLL_LOCALE["Looter_Name"])

    RR_Loot_HowManyLoots = RR_LOOT_FRAME:CreateFontString("RR_Loot_HowManyLoots", "ARTWORK", "GameFontNormal")
    RR_Loot_HowManyLoots:SetPoint("TOPLEFT", RR_LOOT_FRAME, "TOPLEFT", 8, -231)
    RR_Loot_HowManyLoots:SetJustifyH("Left")
    RR_Loot_HowManyLoots:SetText(RAIDROLL_LOCALE["Loots"])

    -------------------- THE BUTTONS   [<<] [<]   [>] [>>]--------------------

    RR_Loot_ButtonFirst = CreateFrame("Button", "RaidRoll_OptionButton", RR_LOOT_FRAME, "UIPanelButtonTemplate")
    RR_Loot_ButtonFirst:SetWidth(40)
    RR_Loot_ButtonFirst:SetHeight(20)
    RR_Loot_ButtonFirst:SetPoint("BottomLEFT", RR_LOOT_FRAME, "BottomLEFT", 5, 5)
    RR_Loot_ButtonFirst:SetText("<<")
    RR_Loot_ButtonFirst:SetScript("OnClick", function() RR_Loot_GotoWindow("First") end)

    RR_Loot_ButtonPrev = CreateFrame("Button", "RaidRoll_OptionButton", RR_LOOT_FRAME, "UIPanelButtonTemplate")
    RR_Loot_ButtonPrev:SetWidth(40)
    RR_Loot_ButtonPrev:SetHeight(20)
    RR_Loot_ButtonPrev:SetPoint("LEFT", RR_Loot_ButtonFirst, "Right", 0, 0)
    RR_Loot_ButtonPrev:SetText("<")
    RR_Loot_ButtonPrev:SetScript("OnClick", function() RR_Loot_GotoWindow("Prev") end)

    RR_Loot_ButtonNext = CreateFrame("Button", "RaidRoll_OptionButton", RR_LOOT_FRAME, "UIPanelButtonTemplate")
    RR_Loot_ButtonNext:SetWidth(40)
    RR_Loot_ButtonNext:SetHeight(20)
    RR_Loot_ButtonNext:SetPoint("LEFT", RR_Loot_ButtonPrev, "Right", 0, 0)
    RR_Loot_ButtonNext:SetText(">")
    RR_Loot_ButtonNext:SetScript("OnClick", function() RR_Loot_GotoWindow("Next") end)

    RR_Loot_ButtonLast = CreateFrame("Button", "RaidRoll_OptionButton", RR_LOOT_FRAME, "UIPanelButtonTemplate")
    RR_Loot_ButtonLast:SetWidth(40)
    RR_Loot_ButtonLast:SetHeight(20)
    RR_Loot_ButtonLast:SetPoint("LEFT", RR_Loot_ButtonNext, "Right", 0, 0)
    RR_Loot_ButtonLast:SetText(">>")
    RR_Loot_ButtonLast:SetScript("OnClick", function() RR_Loot_GotoWindow("Last") end)

    --[[
    RR_Loot_ButtonRequest = CreateFrame("Button", "RR_Loot_ButtonRequest", RR_LOOT_FRAME, "UIPanelButtonTemplate")
    RR_Loot_ButtonRequest:SetWidth(130)
    RR_Loot_ButtonRequest:SetHeight(20)
    RR_Loot_ButtonRequest:SetPoint("BottomLEFT", RR_LOOT_FRAME, "BottomLEFT", 5, 25)
    RR_Loot_ButtonRequest:SetText("Request Item Data")
    RR_Loot_ButtonRequest:SetScript("OnClick",  function()
        if IsInRaid() or IsInGroup() then
            SendAddonMessage("RRL", "Request", IsInRaid() and "RAID" or "PARTY")
        end
        if IsInGuild() then
            SendAddonMessage("RRL", "Request", "GUILD")
        end
    end)
    --]]

    RR_Loot_ButtonClear = CreateFrame("Button", "RR_Loot_ButtonClear", RR_LOOT_FRAME, "UIPanelButtonTemplate")
    RR_Loot_ButtonClear:SetWidth(80)
    RR_Loot_ButtonClear:SetHeight(20)
    RR_Loot_ButtonClear:SetPoint("BottomLEFT", RR_Loot_ButtonFirst, "TopLEFT", 0, 0)
    RR_Loot_ButtonClear:SetText(RAIDROLL_LOCALE["Clear_Data"])
    RR_Loot_ButtonClear:SetScript("OnClick", function()
        RR_ClearItems()
        RR_LastLootMessageTime = 0
    end)

    RR_Loot_LinkLootButton = CreateFrame("Button", "RR_Loot_LinkLootButton", RR_LOOT_FRAME, "UIPanelButtonTemplate")
    RR_Loot_LinkLootButton:SetWidth(70)
    RR_Loot_LinkLootButton:SetHeight(18)
    RR_Loot_LinkLootButton:SetPoint("TopRight", RR_LOOT_FRAME, "TopRight", -30, -6)
    RR_Loot_LinkLootButton:SetText(RAIDROLL_LOCALE["Link_Loot"])
    RR_Loot_LinkLootButton:SetScript("OnClick", function() RR_LinkLoot() end)
    RR_Loot_LinkLootButton:SetScript("OnEnter", function(self) RR_MouseOverTooltip(self:GetName()) end)
    RR_Loot_LinkLootButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

    --[[
    RR_Loot_ButtonMinMax = CreateFrame("Button", "RaidRoll_OptionButton", RR_LOOT_FRAME, "UIPanelButtonTemplate")
    RR_Loot_ButtonMinMax:SetWidth(30)
    RR_Loot_ButtonMinMax:SetHeight(20)
    RR_Loot_ButtonMinMax:SetPoint("BottomLEFT", RR_LOOT_FRAME, "BottomLEFT", 200, 5)
    RR_Loot_ButtonMinMax:SetText("Min")
    RR_Loot_ButtonMinMax:SetScript("OnClick",function() RR_Loot_WindowChangeSize("Min","Bottom") end)
    --]]

    -------------------- THE BUTTONS   [Announce1] [Announce2] [Raid Roll]--------------------

    for i = 1, 4 do
        RR_Loot_Announce1Button = CreateFrame("Button", "RR_Loot_Announce_1_Button_" .. i, RR_LOOT_FRAME, "UIPanelButtonTemplate")
        RR_Loot_Announce1Button:SetWidth(33)
        RR_Loot_Announce1Button:SetHeight(18)
        RR_Loot_Announce1Button:SetPoint("TopLEFT", RR_LOOT_FRAME, "TopLEFT", 55, -48 - ((i - 1) * 45))
        RR_Loot_Announce1Button:SetText("M1")
        RR_Loot_Announce1Button:SetScript("OnClick", function(self) RR_LootButton(self:GetName()) end)
        RR_Loot_Announce1Button:SetScript("OnEnter", function(self) RR_MouseOverButton(self:GetName()) end)
        RR_Loot_Announce1Button:SetScript("OnLeave", function() GameTooltip:Hide() end)

        RR_Loot_Announce2Button = CreateFrame("Button", "RR_Loot_Announce_2_Button_" .. i, RR_LOOT_FRAME, "UIPanelButtonTemplate")
        RR_Loot_Announce2Button:SetWidth(33)
        RR_Loot_Announce2Button:SetHeight(18)
        RR_Loot_Announce2Button:SetPoint("LEFT", _G["RR_Loot_Announce_1_Button_" .. i], "right", 1, 0)
        RR_Loot_Announce2Button:SetText("M2")
        RR_Loot_Announce2Button:SetScript("OnClick", function(self) RR_LootButton(self:GetName()) end)
        RR_Loot_Announce2Button:SetScript("OnEnter", function(self) RR_MouseOverButton(self:GetName()) end)
        RR_Loot_Announce2Button:SetScript("OnLeave", function() GameTooltip:Hide() end)

        RR_Loot_Announce3Button = CreateFrame("Button", "RR_Loot_Announce_3_Button_" .. i, RR_LOOT_FRAME, "UIPanelButtonTemplate")
        RR_Loot_Announce3Button:SetWidth(33)
        RR_Loot_Announce3Button:SetHeight(18)
        RR_Loot_Announce3Button:SetPoint("LEFT", _G["RR_Loot_Announce_2_Button_" .. i], "right", 1, 0)
        RR_Loot_Announce3Button:SetText("M3")
        RR_Loot_Announce3Button:SetScript("OnClick", function(self) RR_LootButton(self:GetName()) end)
        RR_Loot_Announce3Button:SetScript("OnEnter", function(self) RR_MouseOverButton(self:GetName()) end)
        RR_Loot_Announce3Button:SetScript("OnLeave", function() GameTooltip:Hide() end)

        RR_Loot_RaidRollButton = CreateFrame("Button", "RR_Loot_RaidRollButton_" .. i, RR_LOOT_FRAME, "UIPanelButtonTemplate")
        RR_Loot_RaidRollButton:SetWidth(65)
        RR_Loot_RaidRollButton:SetHeight(18)
        RR_Loot_RaidRollButton:SetPoint("TopLEFT", RR_LOOT_FRAME, "TopLEFT", 155, -48 - ((i - 1) * 45))
        RR_Loot_RaidRollButton:SetText("Raid Roll")
        RR_Loot_RaidRollButton:SetScript("OnClick", function(self) RR_LootButton(self:GetName()) end)
        RR_Loot_RaidRollButton:SetScript("OnEnter", function(self) RR_MouseOverButton(self:GetName()) end)
        RR_Loot_RaidRollButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end

    --[[
        RR_Loot_ButtonMinMaxTop = CreateFrame("Button", "RaidRoll_OptionButton", RR_LOOT_FRAME, "UIPanelButtonTemplate")
        RR_Loot_ButtonMinMaxTop:SetWidth(30)
        RR_Loot_ButtonMinMaxTop:SetHeight(20)
        RR_Loot_ButtonMinMaxTop:SetPoint("TopLEFT", RR_LOOT_FRAME, "TopLEFT", 200, -5)
        RR_Loot_ButtonMinMaxTop:SetText("Min")
        RR_Loot_ButtonMinMaxTop:SetScript("OnClick",function() RR_Loot_WindowChangeSize("Min","Top") end)
    --]]

    -------------------- THE SLIDER BAR--------------------------------

    RaidRoll_Loot_Slider = CreateFrame("Slider", "RaidRoll_Loot_Slider_ID", RR_LOOT_FRAME, "OptionsSliderTemplate")
    RaidRoll_Loot_Slider:SetWidth(10)
    RaidRoll_Loot_Slider:SetHeight(RR_LOOT_FRAME:GetHeight() - 30)
    RaidRoll_Loot_Slider:SetPoint('TOPRIGHT', -8, -25)
    RaidRoll_Loot_Slider:SetOrientation('VERTICAL')

    _G[RaidRoll_Loot_Slider:GetName() .. 'Low']:SetText('')
    _G[RaidRoll_Loot_Slider:GetName() .. 'High']:SetText('')
    _G[RaidRoll_Loot_Slider:GetName() .. 'Text']:SetText('')

    RaidRoll_Loot_Slider:SetMinMaxValues(1, 1)
    RaidRoll_Loot_Slider:SetValueStep(1)
    RaidRoll_Loot_Slider:SetValue(1)

    RaidRoll_Loot_Slider:Show()

    RaidRoll_Loot_Slider:SetScript("OnValueChanged", function()
        RaidRoll_Loot_Slider_Window_Scroll(0)
    end)

    ----------------------------------------------------

    -- This allows scrolling and passes arg1 (the direction of the scrolling [1 or -1] )
    RR_LOOT_FRAME:EnableMouseWheel(1)
    RR_LOOT_FRAME:SetScript("OnMouseWheel", function(self, delta)
        RaidRoll_Loot_Slider_Window_Scroll(delta)
    end)

    -------------------------------------------------------------

    Close_Button = CreateFrame("Button", "Close_Button", RR_LOOT_FRAME, "UIPanelCloseButton")
    Close_Button:SetWidth(30)
    Close_Button:SetHeight(30)
    Close_Button:SetPoint("TOPRIGHT", RR_LOOT_FRAME, "TOPRIGHT", 0, 0)

    --------------------------------------------------------------------------------------------------------

    -- Create frames which will be used for items
    for i = 1, 4 do
        RR_Loot_LootID_String_i = RR_LOOT_FRAME:CreateFontString("RR_Loot_LootID_String" .. i, "ARTWORK", "GameFontNormal")
        RR_Loot_LootID_String_i:SetPoint("TOPLEFT", RR_LOOT_FRAME, "TOPLEFT", 5, 20 - (i * 45))
        RR_Loot_LootID_String_i:SetJustifyH("LEFT")
        RR_Loot_LootID_String_i:SetWidth(20)
        RR_Loot_LootID_String_i:SetText(i)

        RR_Loot_Name_String_i = RR_LOOT_FRAME:CreateFontString("RR_Loot_Name_String" .. i, "ARTWORK", "GameFontNormal")
        RR_Loot_Name_String_i:SetPoint("TOPLEFT", RR_LOOT_FRAME, "TOPLEFT", 57, 21 - (i * 45))
        RR_Loot_Name_String_i:SetJustifyH("LEFT")
        RR_Loot_Name_String_i:SetWidth(170)
        RR_Loot_Name_String_i:SetText("Item " .. i)
        RR_Loot_Name_String_i:SetNonSpaceWrap(true)

        --[[
        RR_Loot_Won_String_i = RR_LOOT_FRAME:CreateFontString("RR_Loot_Won_String"..i ,"ARTWORK","GameFontNormal")
        RR_Loot_Won_String_i:SetPoint("TOPLEFT",RR_Loot_Name_String_i,"TOPLEFT", 0, -11)
        RR_Loot_Won_String_i:SetJustifyH("LEFT")
        RR_Loot_Won_String_i:SetWidth(200)
        --RR_Loot_Won_String_i:SetText("Won Item: "..i)
        --]]

        --[[
        RR_Loot_Received_String_i = RR_LOOT_FRAME:CreateFontString("RR_Loot_Received_String"..i ,"ARTWORK","GameFontNormal")
        RR_Loot_Received_String_i:SetPoint("TOPLEFT",RR_Loot_Won_String_i,"TOPLEFT", 0, -12)
        RR_Loot_Received_String_i:SetJustifyH("LEFT")
        RR_Loot_Received_String_i:SetWidth(200)
        RR_Loot_Received_String_i:SetText("Received: "..i)
        --]]

        RR_LootIcon = CreateFrame("Button", "RR_LootIcon" .. i, RR_LOOT_FRAME)
        --RR_LootIcon:SetFrameStrata("FULLSCREEN")
        RR_LootIcon:SetWidth(40) -- Set these to whatever height/width is needed
        RR_LootIcon:SetHeight(40) -- Set these to whatever height/width is needed
        --RR_LootIcon:ClearAllPoints()
        RR_LootIcon:SetPoint("TopLeft", "RR_LOOT_FRAME", "TopLeft", 15, 20 - (i * 45))
        RR_LootIcon:SetBackdrop(rr_default_backdrop)
        --RR_LootIcon:Show()

        RR_LootIcon:SetScript("OnEnter", function(self)
            RR_MouseOverName = self:GetName()
            RR_LootIcon:SetScript("OnUpdate", function()
                RR_MouseOver(RR_MouseOverName)
            end)
        end)

        RR_LootIcon:SetScript("OnLeave", function()
            GameTooltip:Hide()
            SetCursor(nil)
            RR_LootIcon:SetScript("OnUpdate", function()
            -- Dont do anything
            end)
        end)

        RR_LootIcon:SetScript("OnMouseUp", function(self, button)
            TryOnItem = false
            InsertItem = false
            if button == "LeftButton" then
                if IsControlKeyDown() then
                    TryOnItem = true
                    RR_MouseOver(RR_MouseOverName, TryOnItem)
                elseif IsShiftKeyDown() then
                    InsertItem = true
                    RR_MouseOver(RR_MouseOverName, TryOnItem, InsertItem)
                end
            end
        end)
    end

    RR_Loot_CurrentVsMaxWindow = RR_LOOT_FRAME:CreateFontString("RR_Loot_CurrentVsMaxWindow_String", "ARTWORK", "GameFontNormal")
    RR_Loot_CurrentVsMaxWindow:SetPoint("BottomRight", RR_LOOT_FRAME, "BottomRight", -20, 8)
    RR_Loot_CurrentVsMaxWindow:SetJustifyH("Right")
    RR_Loot_CurrentVsMaxWindow:SetWidth(60)
    RR_Loot_CurrentVsMaxWindow:SetFont("Fonts\\FRIZQT__.TTF", 10)
    RR_Loot_CurrentVsMaxWindow:SetText("0/0")

    if RaidRoll_DB["debug"] == true then RR_LOOT_FRAME:Show() end

    RR_Debug("Loot Frame - Loaded")

    if RR_LOOT_FRAME:IsShown() then
        RR_Debug("Loot Frame - Shown")
    end

    RR_Loot_Display_Refresh()
end

function RR_ClearItems()
    RaidRoll_DB["Loot"] = {}
    RaidRoll_DB["Loot"]["CURRENT WINDOW"] = 0
    RaidRoll_DB["Loot"]["TOTAL WINDOWS"] = 0
    RR_Loot_Display_Refresh()
end

function RR_Loot_GotoWindow(WhichWindow)

    if RaidRoll_DB["Loot"]["TOTAL WINDOWS"] ~= 0 then
        if WhichWindow == "First" then
            RaidRoll_DB["Loot"]["CURRENT WINDOW"] = 1
        elseif WhichWindow == "Prev" then
            if RaidRoll_DB["Loot"]["CURRENT WINDOW"] > 1 then
                RaidRoll_DB["Loot"]["CURRENT WINDOW"] = RaidRoll_DB["Loot"]["CURRENT WINDOW"] - 1
            end
        elseif WhichWindow == "Next" then
            if RaidRoll_DB["Loot"]["CURRENT WINDOW"] < RaidRoll_DB["Loot"]["TOTAL WINDOWS"] then
                RaidRoll_DB["Loot"]["CURRENT WINDOW"] = RaidRoll_DB["Loot"]["CURRENT WINDOW"] + 1
            end
        elseif WhichWindow == "Last" then
            RaidRoll_DB["Loot"]["CURRENT WINDOW"] = RaidRoll_DB["Loot"]["TOTAL WINDOWS"]
        end
    end
    RaidRoll_Loot_Slider:SetValue(1)

    RR_Loot_Display_Refresh()

    if RaidRoll_DB["debug"] == true then
        if RaidRoll_DB["Loot"]["CURRENT WINDOW"] ~= nil then RR_Test("Current: " .. RaidRoll_DB["Loot"]["CURRENT WINDOW"]) end
        if RaidRoll_DB["Loot"]["TOTAL WINDOWS"] ~= nil then RR_Test("Total:   " .. RaidRoll_DB["Loot"]["TOTAL WINDOWS"]) end
    end

    RaidRoll_Loot_Slider_Window_Scroll(0)
end

-- Come back to this
function RaidRoll_Loot_Slider_Window_Scroll(direction)

    if RaidRoll_DB["Loot"]["TOTAL WINDOWS"] ~= 0 then
        RR_Debug("LootSliderScroll: " .. direction .. ", " .. RaidRoll_Loot_Slider:GetValue())

        --MOB_ID = RaidRoll_DB["Loot"][Current_Window]
        local Current_Window = RaidRoll_DB["Loot"]["CURRENT WINDOW"]

        if RaidRoll_DB["Loot"][Current_Window]["TOTAL ITEMS"] >= 4 then
            Loot_MaxNumber = RaidRoll_DB["Loot"][Current_Window]["TOTAL ITEMS"] - 3
        else
            Loot_MaxNumber = 1
        end

        RaidRoll_Loot_Slider:SetMinMaxValues(1, Loot_MaxNumber)

        RaidRoll_Loot_Slider:SetValue(RaidRoll_Loot_Slider:GetValue() - (direction * 1))

        if RaidRoll_Loot_Slider:GetValue() > Loot_MaxNumber then
            RaidRoll_Loot_Slider:SetValue(Loot_MaxNumber)
        end

        --RR_ScrollOffset = RaidRoll_Loot_Slider:GetValue() - 1

        RR_Loot_Display_Refresh()
    end

    if GetMouseFocus() ~= nil then
        if GetMouseFocus():GetName() == "RR_LootIcon1" or GetMouseFocus():GetName() == "RR_LootIcon2" or GetMouseFocus():GetName() == "RR_LootIcon3" or GetMouseFocus():GetName() == "RR_LootIcon4" then
            RR_MouseOver(GetMouseFocus():GetName())
        end
    end
end

--  --  --  --  --  --  --  --  --  --  --  --
--  USED TO REFRESH THE LOOT WINDOW DISPLAY
--  FILLING IN ITEM NAMES, ITEM ICONS AND
--  MOB NAME.
--  --  --  --  --  --  --  --  --  --  --  --
function RR_Loot_Display_Refresh()

    local Current_Window = RaidRoll_DB["Loot"]["CURRENT WINDOW"]
    local Total_Windows = RaidRoll_DB["Loot"]["TOTAL WINDOWS"]

    if Total_Windows == 0 then
        for i = 1, 4 do
            _G["RR_Loot_LootID_String" .. i]:SetText("")

            _G["RR_Loot_Name_String" .. i]:SetText("")
            _G["RR_LootIcon" .. i]:SetBackdrop(rr_default_backdrop)

            _G["RR_Loot_Announce_1_Button_" .. i]:Hide()
            _G["RR_Loot_Announce_2_Button_" .. i]:Hide()
            _G["RR_Loot_Announce_3_Button_" .. i]:Hide()
            _G["RR_Loot_RaidRollButton_" .. i]:Hide()
        end
        RR_Loot_String_MobName:SetText(RAIDROLL_LOCALE["Mob"])
        RR_Loot_String_LooterName:SetText(RAIDROLL_LOCALE["Looter_Name"])

        RR_Loot_CurrentVsMaxWindow:SetText("-/-")
        RR_Loot_HowManyLoots:SetText(RAIDROLL_LOCALE["Loots"])
    end

    if Current_Window <= 1 then
        RR_Loot_ButtonFirst:Disable()
        RR_Loot_ButtonPrev:Disable()
    else
        RR_Loot_ButtonFirst:Enable()
        RR_Loot_ButtonPrev:Enable()
    end

    if Current_Window == Total_Windows then
        RR_Loot_ButtonNext:Disable()
        RR_Loot_ButtonLast:Disable()
    else
        RR_Loot_ButtonNext:Enable()
        RR_Loot_ButtonLast:Enable()
    end

    if RaidRoll_DB == nil then RaidRoll_DB = {} end
    if RaidRoll_DB["Loot"] == nil then RaidRoll_DB["Loot"] = {} end
    if RaidRoll_DB["Loot"][Current_Window] == nil then RaidRoll_DB["Loot"][Current_Window] = {} end
    if RaidRoll_DB["Loot"][Current_Window]["TOTAL ITEMS"] == nil then RaidRoll_DB["Loot"][Current_Window]["TOTAL ITEMS"] = 0 end

    if RaidRoll_DB["debug"] == true then
        RR_Test("----RR_Loot_Display_Refresh 1----")
        RR_Test("Current_Window " .. Current_Window)
        RR_Test("TOTAL ITEMS " .. RaidRoll_DB["Loot"][Current_Window]["TOTAL ITEMS"])
    end

    if Current_Window ~= 0 then
        --Get the mob id for the current window
        --MOB_ID = RaidRoll_DB["Loot"][Current_Window]

        for i = 1, 4 do
            if i <= tonumber(RaidRoll_DB["Loot"][Current_Window]["TOTAL ITEMS"]) then
                --Get the slider offset
                local j = i + RaidRoll_Loot_Slider:GetValue() - 1

                local MobName = RaidRoll_DB["Loot"][Current_Window]["MOB NAME"]
                local LooterName = RaidRoll_DB["Loot"][Current_Window]["LOOTER NAME"]

                if RaidRoll_DB["Loot"][Current_Window]["ITEM_" .. j] == nil then RaidRoll_DB["Loot"][Current_Window]["ITEM_" .. j] = {} end
                local ItemLink = RaidRoll_DB["Loot"][Current_Window]["ITEM_" .. j]["ITEMLINK"]
                local ItemIcon = RaidRoll_DB["Loot"][Current_Window]["ITEM_" .. j]["ICON"]
                local Winner = RaidRoll_DB["Loot"][Current_Window]["ITEM_" .. j]["WINNER"]
                local Received = RaidRoll_DB["Loot"][Current_Window]["ITEM_" .. j]["RECEIVED"]

                if RaidRoll_DB["debug"] == true then
                    RR_Test("----RR_Loot_Display_Refresh----")
                    RR_Test(MobName)
                    RR_Test(LooterName)
                    RR_Test(ItemLink)
                    RR_Test(ItemIcon)
                    RR_Test(Winner)
                    RR_Test(Received)
                end

                _G["RR_Loot_LootID_String" .. i]:SetText(j)

                _G["RR_Loot_Name_String" .. i]:SetText(ItemLink)
                _G["RR_LootIcon" .. i]:SetBackdrop({ bgFile = ItemIcon })
                --_G["RR_Loot_Won_String"..i]:SetText("Won Item: " .. Winner)
                --_G["RR_Loot_Received_String"..i]:SetText("Received: " .. Received)

                if IsInRaid() then -- we are in a raid
                    --if UnitIsRaidOfficer("self") == nil then
                    --  _G["RR_Loot_Announce_1_Button_"..i]:Hide()
                    --  _G["RR_Loot_Announce_2_Button_"..i]:Hide()
                    --  _G["RR_Loot_Announce_3_Button_"..i]:Hide()
                    --  _G["RR_Loot_RaidRollButton_"..i]:Hide()
                    --else
                    _G["RR_Loot_Announce_1_Button_" .. i]:Show()
                    _G["RR_Loot_Announce_2_Button_" .. i]:Show()
                    if RaidRoll_DBPC[UnitName("player")]["RR_Enable3Messages"] == true then _G["RR_Loot_Announce_3_Button_" .. i]:Show() end
                    _G["RR_Loot_RaidRollButton_" .. i]:Show()
                    --end
                else
                    _G["RR_Loot_Announce_1_Button_" .. i]:Show()
                    _G["RR_Loot_Announce_2_Button_" .. i]:Show()
                    if RaidRoll_DBPC[UnitName("player")]["RR_Enable3Messages"] == true then _G["RR_Loot_Announce_3_Button_" .. i]:Show() end
                    _G["RR_Loot_RaidRollButton_" .. i]:Show()
                end

                RR_Loot_String_MobName:SetText(RAIDROLL_LOCALE["Mob"] .. " " .. MobName)
                RR_Loot_String_LooterName:SetText(RAIDROLL_LOCALE["Looter_Name"] .. " " .. LooterName)

                RR_Loot_CurrentVsMaxWindow:SetText(RaidRoll_DB["Loot"]["CURRENT WINDOW"] .. "/" .. RaidRoll_DB["Loot"]["TOTAL WINDOWS"])
                RR_Loot_HowManyLoots:SetText(RAIDROLL_LOCALE["Loots"] .. " " .. RaidRoll_DB["Loot"][Current_Window]["TOTAL ITEMS"])
            else
                _G["RR_Loot_LootID_String" .. i]:SetText("")

                _G["RR_Loot_Name_String" .. i]:SetText("")
                _G["RR_LootIcon" .. i]:SetBackdrop(rr_default_backdrop)
                --_G["RR_Loot_Won_String"..i]:SetText("")   --Won Item: ")

                _G["RR_Loot_Announce_1_Button_" .. i]:Hide()
                _G["RR_Loot_Announce_2_Button_" .. i]:Hide()
                _G["RR_Loot_Announce_3_Button_" .. i]:Hide()
                _G["RR_Loot_RaidRollButton_" .. i]:Hide()

                --_G["RR_Loot_Received_String"..i]:SetText("Received: ")
            end
        end
    end
end

--  --  --  --  --  --  --  --  --  --  --  --
--  LINKS ALL THE LOOTS FOR THE CURRENT     --
--  WINDOW IN THE FORMAT:                   --
--  [ID] [ITEMLINK]                         --
--  e.g. 1: [Sword of Awesomeness]          --
--  --  --  --  --  --  --  --  --  --  --  --
function RR_LinkLoot()
    if RaidRoll_DB["Loot"]["CURRENT WINDOW"] ~= nil then
        local Window = RaidRoll_DB["Loot"]["CURRENT WINDOW"]
        local Max = RaidRoll_DB["Loot"][Window]["TOTAL ITEMS"]
        local Name = RaidRoll_DB["Loot"][Window]["MOB NAME"]

        if Name ~= nil then
            RR_Say(RAIDROLL_LOCALE["Displaying_Loots_for"] .. " " .. Name)
            for i = 1, Max do
                local Item = RaidRoll_DB["Loot"][Window]["ITEM_" .. i]["ITEMLINK"]
                RR_Say(i .. ": " .. Item)
            end
        end
    end
end

--  --  --  --  --  --  --  --  --  --  --  --
--  USED TO DISPLAY THE TOOLTIPS OF THE     --
--  ITEMS IN THE LOOT WINDOW WHEN YOU       --
--  MOUSEOVER THEM. ALLOWS YOU TO LINK      --
--  THE ITEMS IN CHAT AND TRY ON THE ITEMS  --
--  TOO.                                    --
--  --  --  --  --  --  --  --  --  --  --  --
function RR_MouseOver(ID, TryOnItem, InsertItem)

    local LootItemlink = nil

    --RR_Test(ID)

    if ID == "RR_LootIcon1" then i = 1 end
    if ID == "RR_LootIcon2" then i = 2 end
    if ID == "RR_LootIcon3" then i = 3 end
    if ID == "RR_LootIcon4" then i = 4 end

    local j = i + RaidRoll_Loot_Slider:GetValue() - 1

    local Current_Window = RaidRoll_DB["Loot"]["CURRENT WINDOW"]
    --MOB_ID = RaidRoll_DB["Loot"][Current_Window]

    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    GameTooltip:ClearAllPoints()
    GameTooltip:SetPoint("bottomleft", _G[ID], "topright", 0, 0)
    GameTooltip:ClearLines()

    if RaidRoll_DB["Loot"][Current_Window] ~= nil then
        if RaidRoll_DB["Loot"][Current_Window]["ITEM_" .. j] ~= nil then
            GameTooltip:SetHyperlink(RaidRoll_DB["Loot"][Current_Window]["ITEM_" .. j]["ITEMLINK"])

            LootItemlink = RaidRoll_DB["Loot"][Current_Window]["ITEM_" .. j]["ITEMLINK"]

            if InsertItem == true then
                ChatEdit_InsertLink(LootItemlink)
            end

            if TryOnItem == true then
                DressUpItemLink(LootItemlink)
            end

            if IsControlKeyDown() then
                ShowInspectCursor()
            else
                SetCursor(nil)
            end
        else
            SetCursor(nil)
        end
    else
        SetCursor(nil)
    end


    --[[
        RR_GearItemlink1 = nil
        RR_GearItemlink2 = nil


        if Button ~= nil then
            if LootItemlink ~= nil then
                if IsEquippableItem(LootItemlink) then
                    _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(LootItemlink)
                    RR_Test(itemEquipLoc)
                    Slot1, Slot2 = RR_GetpossibleSlots(itemEquipLoc)

                    if Slot1 ~= nil then
                        RR_GearItemlink1 = GetInventoryItemLink("player", Slot1)
                    end
                    if Slot2 ~= nil then
                        RR_GearItemlink2 = GetInventoryItemLink("player", Slot2)
                    end
                end
            end
        end

        --  ********************* SETUP COMPARE TOOLTIP 1 *********************
        GameTooltip_SetDefaultAnchor( RR_Compare_Tooltip1, UIParent )
        RR_Compare_Tooltip1:ClearAllPoints()

        -- place the window on the left side if the gametooltip is on the right side of the screen, left it otherwise
        if GameTooltip:GetCenter() > UIParent:GetCenter() then
            RR_Compare_Tooltip1:SetPoint("right", GameTooltip, "left")
        else
            RR_Compare_Tooltip1:SetPoint("left", GameTooltip, "right")
        end

        RR_Compare_Tooltip1:ClearLines()

        if RaidRoll_DB["Loot"][Current_Window] ~= nil then
            if RaidRoll_DB["Loot"][Current_Window]["ITEM_"..j] ~= nil then
                if RR_GearItemlink1 ~= nil then
                    RR_Compare_Tooltip1:SetHyperlink(RR_GearItemlink1)
                end
            end
        end

        --  ********************* SETUP COMPARE TOOLTIP 2 *********************
        GameTooltip_SetDefaultAnchor( RR_Compare_Tooltip2, UIParent )
        RR_Compare_Tooltip2:ClearAllPoints()

        -- place the window on the left side if the gametooltip is on the right side of the screen, left it otherwise
        if GameTooltip:GetCenter() > UIParent:GetCenter() then
            RR_Compare_Tooltip2:SetPoint("right", RR_Compare_Tooltip1, "left")
        else
            RR_Compare_Tooltip2:SetPoint("left", RR_Compare_Tooltip1, "right")
        end

        RR_Compare_Tooltip2:ClearLines()

        if RaidRoll_DB["Loot"][Current_Window] ~= nil then
            if RaidRoll_DB["Loot"][Current_Window]["ITEM_"..j] ~= nil then
                if RR_GearItemlink2 ~= nil then
                    RR_Compare_Tooltip2:SetHyperlink(RR_GearItemlink2)
                end
            end
        end
    --]]
end

--  --  --  --  --  --  --  --  --  --  --  --
--  THIS FUNCTION IS CALLED THEN YOU PRESS  --
--  ONE OF THE "MSG" OR "RAID ROLL" BUTTONS --
--  ON THE LOOT WINDOW. IT CALLS            --
--  RR_AnnounceMsg TO FIND OUT WHAT MESSAGE --
--  SHOULD BE DISPLAYED.                    --
--  --  --  --  --  --  --  --  --  --  --  --
function RR_LootButton(Whatbutton)

    _, _, AnnounceType, ID, Button, ItemID = strsplit("_", Whatbutton)
    --RR_Debug("LootButton: " .. (Whatbutton or "nil") .. ", " .. (AnnounceType or "nil") .. ", "
    --    .. (ID or "nil") .. ", " .. (Button or "nil") .. ", " .. (ItemID or "nil"))

    if ItemID ~= nil then
        ItemID_2 = tonumber(ItemID)
        ItemID_2 = ItemID_2 + RaidRoll_Loot_Slider:GetValue() - 1
    end

    if ID ~= nil then
        ID_2 = tonumber(ID)
        ID_2 = ID_2 + RaidRoll_Loot_Slider:GetValue() - 1
    end

    if AnnounceType == "Announce" then
        ItemLink = RaidRoll_DB["Loot"][Current_Window]["ITEM_" .. ItemID_2]["ITEMLINK"]
        local AnnounceMessage = RR_AnnounceMsg(ID, ItemLink)
        RR_Shout(AnnounceMessage)
    else
        RRL_Command(RaidRoll_DB["Loot"][Current_Window]["ITEM_" .. ID_2]["ITEMLINK"])
    end
end

--  --  --  --  --  --  --  --  --  --  --  --
--  DISPLAYS A TOOLTIP WHEN YOU MOUSE OVER  --
--  ONE OF THE MSG BUTTONS THAT TELLS YOU   --
--  THE MESSAGE THAT THEY WOULD DISPLAY     --
--  --  --  --  --  --  --  --  --  --  --  --
function RR_MouseOverButton(Whatbutton)

    Current_Window = RaidRoll_DB["Loot"]["CURRENT WINDOW"]

    _, _, AnnounceType, ID, Button, ItemID = strsplit("_", Whatbutton)
    --RR_Debug("MouseOverButton: " .. (Whatbutton or "nil") .. ", " .. (AnnounceType or "nil") .. ", "
    --    .. (ID or "nil") .. ", " .. (Button or "nil") .. ", " .. (ItemID or "nil"))

    if ItemID ~= nil then
        ItemID_2 = tonumber(ItemID)
        ItemID_2 = ItemID_2 + RaidRoll_Loot_Slider:GetValue() - 1
    end

    if ID ~= nil then
        ID_2 = tonumber(ID)
        ID_2 = ID_2 + RaidRoll_Loot_Slider:GetValue() - 1
    end

    if AnnounceType == "Announce" then
        ItemLink = RaidRoll_DB["Loot"][Current_Window]["ITEM_" .. ItemID_2]["ITEMLINK"]

        local AnnounceMessage = RR_AnnounceMsg(ID, ItemLink)

        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
        GameTooltip:ClearAllPoints()
        GameTooltip:SetPoint("bottomLEFT", _G["RR_Loot_Announce_" .. ID .. "_Button_" .. ItemID], "top", 0, 0)
        GameTooltip:ClearLines()

        GameTooltip:AddLine(AnnounceMessage, 1, 1, 1)
        GameTooltip:Show()
    else
        ItemLink = RaidRoll_DB["Loot"][Current_Window]["ITEM_" .. ID_2]["ITEMLINK"]

        local AnnounceMessage = "<<Raid Rolling for: " .. ItemLink .. " >> (ID - Name)"

        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
        GameTooltip:ClearAllPoints()
        GameTooltip:SetPoint("bottomLEFT", _G["RR_Loot_RaidRollButton_" .. ID], "top", 0, 0)
        GameTooltip:ClearLines()

        GameTooltip:AddLine(AnnounceMessage, 1, 1, 1)
        GameTooltip:Show()
    end
end

--  --  --  --  --  --  --  --  --  --  --  --
--  FINDS OUT WHAT CHANNEL THE MESSAGE      --
--  SHOULD BE ANNOUNCED IN AND REPLACES     --
--  THE FIRST INSTANCE OF [ITEM] WITH THE   --
--  ITEMLINK OF THE ITEM BEING ROLLED ON.   --
--  --  --  --  --  --  --  --  --  --  --  --
function RR_AnnounceMsg(ID, ItemLink)
    local AnnounceMessage = _G["Raid_Roll_SetMsg" .. ID .. "_EditBox"]:GetText()
    local startpos, endpos = strfind(strlower(AnnounceMessage), "%[item%]")

    if startpos ~= nil and endpos ~= nil then
        AnnounceMessage = string.sub(AnnounceMessage, 0, startpos - 1) .. ItemLink .. string.sub(AnnounceMessage, endpos + 1)
    end

    return AnnounceMessage
end

--  --  --  --  --  --  --  --  --  --  --  --
--  OLD FUNCTIONS THAT ARE NOT BEING USED   --
--  BUT MAY HAVE SOME USE IN THE FUTURE     --
--  --  --  --  --  --  --  --  --  --  --  --
--[[
function RR_Loot_WindowChangeSize(MinMax,TopBottom)

    BottomLoc = RR_LOOT_FRAME:GetBottom()
    xoff = RR_LOOT_FRAME:GetLeft()

    if RaidRoll_DB["debug"] == true then
        RR_Test("-----")
        RR_Test(xoff)
        RR_Test(BottomLoc)

        RR_Test("-------")
        point, relativeTo, relativePoint, xOfs, yOfs = RR_LOOT_FRAME:GetPoint()
        RR_Test(point)
        RR_Test(relativeTo)
        RR_Test(relativePoint)
        RR_Test(xOfs)
        RR_Test(yOfs)
        RR_Test("---------")
    end

    if MinMax == "Min" then
        RR_Loot_ButtonMinMax:SetText("Max")
        RR_Loot_ButtonMinMax:SetScript("OnClick",function() RR_Loot_WindowChangeSize("Max") end)
        RR_LOOT_FRAME:SetHeight(30)

        --RR_Loot_ButtonMinMaxTop:Hide()

        for i=1,4 do
            _G["RR_Loot_Name_String" .. i]:Hide()
            --_G["RR_Loot_Won_String" .. i]:Hide()
            --_G["RR_Loot_Received_String" .. i]:Hide()
            _G["RR_LootIcon"..i]:Hide()

            RR_Loot_String_MobName:Hide()
            RR_Loot_String_LooterName:Hide()

            RR_Loot_ButtonFirst:Hide()
            RR_Loot_ButtonPrev:Hide()
            RR_Loot_ButtonNext:Hide()
            RR_Loot_ButtonLast:Hide()

            RaidRoll_Loot_Slider:Hide()
        end

    end

    if MinMax == "Max" then
        RR_Loot_ButtonMinMax:SetText("Min")
        RR_Loot_ButtonMinMax:SetScript("OnClick",function() RR_Loot_WindowChangeSize("Min") end)
        RR_LOOT_FRAME:SetHeight(270)

        --RR_Loot_ButtonMinMaxTop:Show()

        for i=1,4 do
            _G["RR_Loot_Name_String" .. i]:Show()
            --_G["RR_Loot_Won_String" .. i]:Show()
            --_G["RR_Loot_Received_String" .. i]:Show()
            _G["RR_LootIcon"..i]:Show()

            RR_Loot_String_MobName:Show()
            RR_Loot_String_LooterName:Show()

            RR_Loot_ButtonFirst:Show()
            RR_Loot_ButtonPrev:Show()
            RR_Loot_ButtonNext:Show()
            RR_Loot_ButtonLast:Show()

            RaidRoll_Loot_Slider:Show()
        end
    end

    if TopBottom == "Top" then
        RR_LOOT_FRAME:ClearAllPoints()
        RR_LOOT_FRAME:SetPoint("CENTER", nil, "topleft", xoff + (RR_LOOT_FRAME:GetWidth()/2),BottomLoc + (RR_LOOT_FRAME:GetHeight()/2))
    else
        RR_LOOT_FRAME:ClearAllPoints()
        RR_LOOT_FRAME:SetPoint("CENTER", nil, "bottomleft", xoff + (RR_LOOT_FRAME:GetWidth()/2),BottomLoc + (RR_LOOT_FRAME:GetHeight()/2))
    end

    RR_LOOT_FRAME:ClearAllPoints()
    RR_LOOT_FRAME:SetPoint("CENTER", nil, "bottomleft", xoff + (RR_LOOT_FRAME:GetWidth()/2),BottomLoc + (RR_LOOT_FRAME:GetHeight()/2))
end

function RR_GetpossibleSlots(itemEquipLoc)

    local ItemEquipLocations1 = {
        ["INVTYPE_AMMO"] = 0,
        ["INVTYPE_HEAD"] = 1,
        ["INVTYPE_NECK"] = 2,
        ["INVTYPE_SHOULDER"] = 3,
        ["INVTYPE_BODY"] = 4,
        ["INVTYPE_CHEST"] = 5,
        ["INVTYPE_ROBE"] = 5,
        ["INVTYPE_WAIST"] = 6,
        ["INVTYPE_LEGS"] = 7,
        ["INVTYPE_FEET"] = 8,
        ["INVTYPE_WRIST"] = 9,
        ["INVTYPE_HAND"] = 10,
        ["INVTYPE_FINGER"] = 11,
        ["INVTYPE_TRINKET"] = 13,
        ["INVTYPE_CLOAK"] = 15,
        ["INVTYPE_WEAPON"] = 16,
        ["INVTYPE_SHIELD"] = 17,
        ["INVTYPE_2HWEAPON"] = 16,
        ["INVTYPE_WEAPONMAINHAND"] = 16,
        ["INVTYPE_WEAPONOFFHAND"] = 17,
        ["INVTYPE_HOLDABLE"] = 17,
        ["INVTYPE_RANGED"] = 18,
        ["INVTYPE_THROWN"] = 18,
        ["INVTYPE_RANGEDRIGHT"] = 18,
        ["INVTYPE_RELIC"] = 18,
        ["INVTYPE_TABARD"] = 19,
        ["INVTYPE_BAG"] = 20,
        ["INVTYPE_QUIVER"] = nil
    }

    local ItemEquipLocations2 = {
        ["INVTYPE_AMMO"] = nil,
        ["INVTYPE_HEAD"] = nil,
        ["INVTYPE_NECK"] = nil,
        ["INVTYPE_SHOULDER"] = nil,
        ["INVTYPE_BODY"] = nil,
        ["INVTYPE_CHEST"] = nil,
        ["INVTYPE_ROBE"] = nil,
        ["INVTYPE_WAIST"] = nil,
        ["INVTYPE_LEGS"] = nil,
        ["INVTYPE_FEET"] = nil,
        ["INVTYPE_WRIST"] = nil,
        ["INVTYPE_HAND"] = nil,
        ["INVTYPE_FINGER"] = 12,
        ["INVTYPE_TRINKET"] = 14,
        ["INVTYPE_CLOAK"] = nil,
        ["INVTYPE_WEAPON"] = 17,
        ["INVTYPE_SHIELD"] = nil,
        ["INVTYPE_2HWEAPON"] = nil,
        ["INVTYPE_WEAPONMAINHAND"] = nil,
        ["INVTYPE_WEAPONOFFHAND"] = nil,
        ["INVTYPE_HOLDABLE"] = nil,
        ["INVTYPE_RANGED"] = nil,
        ["INVTYPE_THROWN"] = nil,
        ["INVTYPE_RANGEDRIGHT"] = nil,
        ["INVTYPE_RELIC"] = nil,
        ["INVTYPE_TABARD"] = nil,
        ["INVTYPE_BAG"] = nil,
        ["INVTYPE_QUIVER"] = nil
    }

    return ItemEquipLocations1[itemEquipLoc],ItemEquipLocations2[itemEquipLoc]
end
--]]
