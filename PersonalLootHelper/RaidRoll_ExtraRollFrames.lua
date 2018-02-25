function RR_AdjustLeftXPosition(region, newX)
    local newPoints = {}

    for i = 1, region:GetNumPoints() do
        local point, relativeTo, relativePoint, xOffset, yOffset = region:GetPoint(i)
        tinsert(newPoints, {
            point = point,
            relativeTo = relativeTo,
            relativePoint = relativePoint,
            xOffset = (point == "TOPLEFT" or point == "LEFT" or point == "BOTTOMLEFT") and newX or xOffset,
            yOffset = yOffset
        })
    end

    region:ClearAllPoints();

    for _, p in ipairs(newPoints) do
        region:SetPoint(p.point, p.relativeTo, p.relativePoint, p.xOffset, p.yOffset)
    end
end

function RR_RollFrame_SortOutSize()
    local extraWidth = RaidRoll_DBPC[UnitName("player")]["RR_ExtraWidth"]
    local nextX

    -- Rank column shown when show rank option is on
    if RaidRoll_DBPC[UnitName("player")]["RR_Show_Ranks"] then
        nextX = 130 + floor(extraWidth / 3)  -- 1/3 of extra width goes to name
        RR_AdjustLeftXPosition(_G["RR_RollerRank0"], nextX)
        nextX = nextX + 60 + (extraWidth - floor(extraWidth / 3))  -- 2/3 of extra width goes to rank
        for i = 0, 5 do
            _G["RR_RollerRank" .. i]:Show()
        end
    else
        nextX = 130 + extraWidth  -- Without rank column, all extra width goes to names
        for i = 0, 5 do
            _G["RR_RollerRank" .. i]:Hide()
        end
    end

    -- PR column shown when EPGP mode on
    if RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Enabled"] then
        RR_AdjustLeftXPosition(_G["RR_RollerPR0"], nextX)
        nextX = nextX + 40
        for i = 0, 5 do
            _G["RR_RollerPR" .. i]:Show()
        end
    else
        for i = 0, 5 do
            _G["RR_RollerPR" .. i]:Hide()
        end
    end

    -- Roll column shown when EPGP off or EPGP on and also show roll on
    if not RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Enabled"] or RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_EPGP_Also_Show_Roll"] then
        RR_AdjustLeftXPosition(_G["RR_Rolled0"], nextX)
        nextX = nextX + 30
        for i = 0, 5 do
            _G["RR_Rolled" .. i]:Show()
        end
    else
        for i = 0, 5 do
            _G["RR_Rolled" .. i]:Hide()
        end
    end

    -- Group column shown when show group option is on
    if RaidRoll_DBPC[UnitName("player")]["RR_ShowGroupNumber"] then
        RR_AdjustLeftXPosition(_G["RR_Group0"], nextX)
        nextX = nextX + 30
        for i = 0, 5 do
            _G["RR_Group" .. i]:Show()
        end
    else
        for i = 0, 5 do
            _G["RR_Group" .. i]:Hide()
        end
    end

    RR_RollFrame:SetHeight(155)
    RR_RollFrame:SetWidth(nextX + 20) -- Add some extra space for the scroll bar and edge
end

-- Setup extra frame commands
function RR_ExtraFrame_Options()

    if RaidRoll_LootTrackerLoaded ~= true then
        -- FRAME NOT LOADED MESSAGE
        local RR_LOOT_FRAME_msg = RR_LOOT_FRAME:CreateFontString("RR_LOOT_FRAME_msg", "ARTWORK", "GameFontNormal")
        --RR_LOOT_FRAME_msg:SetAllPoints()
        RR_LOOT_FRAME_msg:SetJustifyH("center")
        RR_LOOT_FRAME_msg:SetPoint("center", RR_LOOT_FRAME, "center", 0, 0)
        RR_LOOT_FRAME_msg:SetText("Loot Frame Not Loaded")
    end

    if RaidRoll_DBPC[UnitName("player")]["RR_ExtraWidth"] == nil then
        RaidRoll_DBPC[UnitName("player")]["RR_ExtraWidth"] = 0
    end

    RR_RollFrame:SetScript("OnShow", function()
        RR_GuildRankUpdate()
        RR_GetEPGPGuildData()
        RR_RollFrame_SortOutSize()
    end)

    --------------------------------------------------------------

    RR_BottomFrame = CreateFrame("Frame", "RR_Frame", RR_RollFrame)

    local backdrop = {
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", -- path to the background texture
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", -- path to the border texture
        tile = false, -- true to repeat the background texture to fill the frame, false to scale it
        tileSize = 32, -- size (width or height) of the square repeating background tiles (in pixels)
        edgeSize = 20, -- thickness of edge segments and square size of edge corners (in pixels)
        insets = {
            -- distance from the edges of the frame to those of the background texture (in pixels)
            left = 4,
            right = 4,
            top = 4,
            bottom = 4
        }
    }
    RR_BottomFrame:SetBackdrop(backdrop)

    --RR_BottomFrame:SetFrameStrata("MEDIUM")
    RR_BottomFrame:SetWidth(180) -- Set these to whatever height/width is needed
    RR_BottomFrame:SetHeight(100) -- for your Texture
    RR_BottomFrame:SetPoint("Top", RR_RollFrame, "Bottom", 0, 6)

    RR_BottomFrame:EnableMouse(true)
    RR_BottomFrame:SetScript("OnMouseDown", function()
        _G["RR_RollFrame"]:StartMoving()
    end)
    RR_BottomFrame:SetScript("OnMouseUp", function()
        _G["RR_RollFrame"]:StopMovingOrSizing()
    end)

    -- Hide the options frame
    RR_BottomFrame:Hide()
    _G["RaidRoll_Catch_All"]:Hide()
    _G["RaidRoll_Allow_All"]:Hide()

    -- Set the backdrops for the other frames
    RR_NAME_FRAME:SetBackdrop(backdrop)

    -- Change the height of the main screen
    RR_RollFrame:SetHeight(155)
    RR_RollFrame:SetWidth(215 + RaidRoll_DBPC[UnitName("player")]["RR_ExtraWidth"])
    RR_RollFrame:SetFrameStrata("MEDIUM")

    -- Dim the background texture so it doesn't make the window text harder to read
    RR_RollFrame.RR_Background:SetVertexColor(0.3, 0.3, 0.3)

    -- Create 5 buttons to mark up names
    for i = 1, 5 do
        local Raid_Roll_SetSymbol = CreateFrame("Button", "Raid_Roll_SetSymbol" .. i, RR_RollFrame)
        Raid_Roll_SetSymbol:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        Raid_Roll_SetSymbol:SetNormalTexture("")
        Raid_Roll_SetSymbol:SetPushedTexture("")
        Raid_Roll_SetSymbol:SetWidth(80)
        Raid_Roll_SetSymbol:SetHeight(12)
        Raid_Roll_SetSymbol:SetPoint("TOPLEFT", _G["RR_Roller" .. i], "TOPLEFT")
        Raid_Roll_SetSymbol:SetPoint("BOTTOMRIGHT", _G["RR_Roller" .. i], "BOTTOMRIGHT")
        Raid_Roll_SetSymbol:SetScript("OnClick", function(self, button)
            local ID = tonumber(string.sub(self:GetName(), string.len(self:GetName())))
            ID = ID + RaidRoll_Slider:GetValue() - 1
            --RR_Debug(self:GetName() .. ": ID = " .. ID .. ", button = " .. button)
            if button == "LeftButton" then
                RRL_Command("mark " .. ID)
            elseif button == "RightButton" then
                RR_Ignore(ID)
            end
        end)
        Raid_Roll_SetSymbol:SetScript("OnEnter", function(self) RR_MouseOverTooltip(self:GetName()) end)
        Raid_Roll_SetSymbol:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end

    _G["RR_Close_Button"]:ClearAllPoints()
    _G["RR_Close_Button"]:SetWidth(30)
    _G["RR_Close_Button"]:SetHeight(30)
    _G["RR_Close_Button"]:SetPoint("TopRight", _G["RR_RollFrame"], "TopRight", 0, 0)

    _G["RR_Last"]:ClearAllPoints()
    _G["RR_Last"]:SetPoint("Bottom", _G["RR_RollFrame"], "Bottom", -37, 10)
    _G["RR_Last"]:SetWidth(34)
    _G["RR_Last"]:SetText("<<<")

    _G["RR_Clear"]:ClearAllPoints()
    _G["RR_Clear"]:SetPoint("Bottom", _G["RR_RollFrame"], "Bottom", 5, 10)
    _G["RR_Clear"]:SetWidth(50)
    _G["RR_Clear"]:SetText(RAIDROLL_LOCALE["New_ID"])

    _G["RR_Next"]:ClearAllPoints()
    _G["RR_Next"]:SetPoint("Bottom", _G["RR_RollFrame"], "Bottom", 46, 10)
    _G["RR_Next"]:SetWidth(34)
    _G["RR_Next"]:SetText(">>>")

    _G["RaidRoll_Catch_All"]:ClearAllPoints()
    _G["RaidRoll_Catch_All"]:SetPoint("BottomLeft", RR_BottomFrame, "BottomLeft", 10, 75)
    _G["RaidRoll_Catch_All" .. "Text"]:SetText(RAIDROLL_LOCALE["Catch_Unannounced_Rolls"])

    _G["RaidRoll_Allow_All"]:ClearAllPoints()
    _G["RaidRoll_Allow_All"]:SetPoint("BottomLeft", RR_BottomFrame, "BottomLeft", 10, 60)
    _G["RaidRoll_Allow_All" .. "Text"]:SetText(RAIDROLL_LOCALE["Allow_all_rolls"])

    -- roll button
    RR_Roll_RollButton = CreateFrame("Button", "RR_Roll_RollButton", RR_RollFrame, "UIPanelButtonTemplate")
    RR_Roll_RollButton:SetWidth(20)
    RR_Roll_RollButton:SetHeight(20)
    RR_Roll_RollButton:SetPoint("BottomRight", RR_RollFrame, "Bottom", -60, 10)
    RR_Roll_RollButton:SetText("R")
    RR_Roll_RollButton:SetScript("OnClick", function() RandomRoll(1, 100) end)
    RR_Roll_RollButton:SetScript("OnEnter", function(self) RR_MouseOverTooltip(self:GetName()) end)
    RR_Roll_RollButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

    -- options menu button
    RR_Roll_Options = CreateFrame("Button", "RaidRoll_OptionButton", RR_RollFrame, "UIPanelButtonTemplate")
    RR_Roll_Options:SetWidth(18)
    RR_Roll_Options:SetHeight(18)
    RR_Roll_Options:SetPoint("Bottom", RR_RollFrame, "Bottom", 74, 11)
    RR_Roll_Options:SetText("v")
    RR_Roll_Options:SetScript("OnClick", RR_Roll_Options_Toggle)

    -- RaidRoll_AnnounceWinnerButton
    RaidRoll_AnnounceWinnerButton = CreateFrame("Button", "RaidRoll_AnnounceWinnerButton", RR_RollFrame, "UIPanelButtonTemplate")
    RaidRoll_AnnounceWinnerButton:SetWidth(20)
    RaidRoll_AnnounceWinnerButton:SetHeight(20)
    RaidRoll_AnnounceWinnerButton:SetPoint("BottomRight", RR_RollFrame, "Bottom", -60, 30)
    RaidRoll_AnnounceWinnerButton:SetText("A")
    RaidRoll_AnnounceWinnerButton:SetScript("OnClick", function()
        local Winner, Roll, EPGP = RR_FindWinner(rr_CurrentRollID)
        local Winner_Message

        if Winner ~= "" then
            if GetLocale() ~= "zhTW" and GetLocale() ~= "ruRU" and GetLocale() ~= "zhCN" then
                Winner = string.upper(string.sub(Winner, 1, 1)) .. string.lower(string.sub(Winner, 2))
            end

            if RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Enabled"] == true then
                if rr_Item[rr_CurrentRollID] == "ID #" .. rr_CurrentRollID then
                    Winner_Message = string.format(RAIDROLL_LOCALE["won_PR_value"], Winner, EPGP)
                else
                    Winner_Message = string.format(RAIDROLL_LOCALE["won_item_PR_value"], Winner, rr_Item[rr_CurrentRollID], EPGP)
                end
            else
                if rr_Item[rr_CurrentRollID] == "ID #" .. rr_CurrentRollID then
                    Winner_Message = string.format(RAIDROLL_LOCALE["won_with"], Winner, Roll)
                else
                    Winner_Message = string.format(RAIDROLL_LOCALE["won_item_with"], Winner, rr_Item[rr_CurrentRollID], Roll)
                end
            end
        else
            Winner_Message = string.format(RAIDROLL_LOCALE["No_winner_for"], rr_Item[rr_CurrentRollID])
        end

        RR_Say(Winner_Message)

        if RR_RollCheckBox_GuildAnnounce:GetChecked() then
            if RR_RollCheckBox_GuildAnnounce_Officer:GetChecked() then
                SendChatMessage(Winner_Message, "OFFICER")
            else
                SendChatMessage(Winner_Message, "GUILD")
            end
        end
    end)
    RaidRoll_AnnounceWinnerButton:SetScript("OnEnter", function(self) RR_MouseOverTooltip(self:GetName()) end)
    RaidRoll_AnnounceWinnerButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
    RaidRoll_AnnounceWinnerButton:Hide()

    -- finish rolling
    RR_Roll_5SecAndAnnounce = CreateFrame("Button", "RR_Roll_5SecAndAnnounce", RR_RollFrame, "UIPanelButtonTemplate")
    RR_Roll_5SecAndAnnounce:SetWidth(168)
    RR_Roll_5SecAndAnnounce:SetHeight(20)
    RR_Roll_5SecAndAnnounce:SetPoint("BottomRight", RR_RollFrame, "Bottom", 85, 30)
    RR_Roll_5SecAndAnnounce:SetText(RAIDROLL_LOCALE["Awaiting Rolls"])
    RR_Roll_5SecAndAnnounce:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    RR_Roll_5SecAndAnnounce:SetScript("OnClick", function(self, button, down)
        if RR_Timestamp ~= nil then
            if tonumber(RR_Timestamp) ~= nil then
                if rr_CurrentRollID == rr_rollID then
                    if ((60 - (time() - RR_Timestamp)) <= 11 or RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_No_countdown"] == true) and (60 - (time() - RR_Timestamp)) > 0 then
                        RR_Debug("Finishing Early")
                        RR_HasAnnounced_10_Sec = true
                        RR_HasAnnounced_5_Sec = true

                        if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_No_countdown"] == false then
                            RR_Say(RAIDROLL_LOCALE["Finishing_Rolling_Early"])
                        end

                        RR_RollCountdown = true
                        RR_AnnounceCountdowns = true

                        RR_Timestamp = time() - 60
                    else
                        RR_Debug("Normal operation")
                        RR_FinishRolling(false, nil, button)
                    end
                else
                    RR_Debug("Loot from a previous window")
                    RR_FinishRolling(false, nil, button)
                end
            else
                RR_FinishRolling(false, nil, button)
            end
        else
            RR_FinishRolling(false, nil, button)
        end
    end)

    RR_RollCheckBox_ExtraRolls = CreateFrame("CheckButton", "RaidRollCheckBox_ExtraRolls", RR_BottomFrame, "UICheckButtonTemplate")
    RR_RollCheckBox_ExtraRolls:SetWidth(20)
    RR_RollCheckBox_ExtraRolls:SetHeight(20)
    RR_RollCheckBox_ExtraRolls:SetPoint("BottomLeft", RR_BottomFrame, "BottomLeft", 10, 45)
    _G["RaidRollCheckBox_ExtraRolls" .. "Text"]:SetText(RAIDROLL_LOCALE["Allow_Extra_Rolls"])
    RR_RollCheckBox_ExtraRolls:SetScript("OnClick", RaidRoll_CheckButton_Update)

    --[[
        RR_RollCheckBox_ShowRanks = CreateFrame("CheckButton", "RaidRollCheckBox_ShowRanks", RR_BottomFrame, "UICheckButtonTemplate")
        RR_RollCheckBox_ShowRanks:SetWidth(20)
        RR_RollCheckBox_ShowRanks:SetHeight(20)
        RR_RollCheckBox_ShowRanks:SetPoint("BottomLeft", RR_BottomFrame, "BottomLeft", 10, 25)
        _G["RaidRollCheckBox_ShowRanks".."Text"]:SetText(RAIDROLL_LOCALE["Show_Rank_Beside_Name"])
        RR_RollCheckBox_ShowRanks:SetScript("OnClick",RaidRoll_CheckButton_Update)
    --]]

    --[[
        RR_RollCheckBox_RankPrio = CreateFrame("CheckButton", "RaidRollCheckBox_RankPrio", RR_BottomFrame, "UICheckButtonTemplate")
        RR_RollCheckBox_RankPrio:SetWidth(20)
        RR_RollCheckBox_RankPrio:SetHeight(20)
        RR_RollCheckBox_RankPrio:SetPoint("BottomLeft", RR_BottomFrame, "BottomLeft", 10, 10)
        _G["RaidRollCheckBox_RankPrio".."Text"]:SetText(RAIDROLL_LOCALE["Give_Higher_Ranks_Priority"])
        RR_RollCheckBox_RankPrio:SetScript("OnClick",RaidRoll_CheckButton_Update)
    --]]

    RR_Roll_ExtraOptions = CreateFrame("Button", "RaidRoll_ExtraOptionButton", RR_BottomFrame, "UIPanelButtonTemplate")
    RR_Roll_ExtraOptions:SetWidth(80)
    RR_Roll_ExtraOptions:SetHeight(15)
    RR_Roll_ExtraOptions:SetPoint("BottomLeft", RR_BottomFrame, "BottomLeft", 50, 10)
    RR_Roll_ExtraOptions:SetText(RAIDROLL_LOCALE["Options"])
    RR_Roll_ExtraOptions:SetScript("OnClick", RR_OpenOptionsPanel)

    Raid_Roll_ClearSymbols = CreateFrame("Button", "Raid_Roll_ClearSymbols", RR_BottomFrame, "UIPanelButtonTemplate")
    Raid_Roll_ClearSymbols:SetWidth(80)
    Raid_Roll_ClearSymbols:SetHeight(15)
    Raid_Roll_ClearSymbols:SetText(RAIDROLL_LOCALE["Clear_Marks"])
    Raid_Roll_ClearSymbols:SetPoint("BottomLeft", RR_BottomFrame, "BottomLeft", 10, 30)
    Raid_Roll_ClearSymbols:SetScript("OnClick", function()
        StaticPopup_Show("Clear_Marks")
    end)

    StaticPopupDialogs["Clear_Marks"] = {
        text = RAIDROLL_LOCALE["Clear_all_marks"],
        button1 = RAIDROLL_LOCALE["Yes"],
        button2 = RAIDROLL_LOCALE["No"],
        OnAccept = function()
            RaidRoll_DBPC[UnitName("player")]["RR_NameMark"] = {}
            RaidRoll_DBPC[UnitName("player")]["RR_PlayerIconID"] = {}
            RaidRoll_DBPC[UnitName("player")]["RR_PlayerIcon"] = {}
            RR_Display(rr_CurrentRollID)
            RR_Test(RAIDROLL_LOCALE["All_marks_cleared"])
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    Raid_Roll_ClearRolls = CreateFrame("Button", "Raid_Roll_ClearRolls", RR_BottomFrame, "UIPanelButtonTemplate")
    Raid_Roll_ClearRolls:SetWidth(80)
    Raid_Roll_ClearRolls:SetHeight(15)
    Raid_Roll_ClearRolls:SetText(RAIDROLL_LOCALE["Clear_Rolls"])
    Raid_Roll_ClearRolls:SetPoint("BottomLeft", RR_BottomFrame, "BottomLeft", 90, 30)
    Raid_Roll_ClearRolls:SetScript("OnClick", function()
        StaticPopup_Show("Clear_Rolls")
    end)

    StaticPopupDialogs["Clear_Rolls"] = {
        text = RAIDROLL_LOCALE["Clear_all_saved_roll_memory"],
        button1 = RAIDROLL_LOCALE["Yes"],
        button2 = RAIDROLL_LOCALE["No"],
        OnAccept = function()
            rr_rollID = 0
            rr_CurrentRollID = 0
            RR_DisplayID = 0
            RollerName = {}
            MaxPlayers = {}
            rr_Item = {}
            RR_IgnoredList = {}
            rr_Roll = {}
            rr_PlayersRolled = {}
            rr_playername = {}
            RollerRoll = {}
            RollerFirst = {}
            RollerRank = {}
            RollerRankIndex = {}
            HasRolled = {}
            Roll_Number = {}
            RaidRoll_LegitRoll = {}
            RollerColor = {}
            RR_EPGPAboveThreshold = {}
            RR_EPGP_PRValue = {}
            RR_RollData = {}
            RR_Timestamp = time()

            RollerName[rr_rollID] = {}
            RollerRoll[rr_rollID] = {}
            RollerFirst[rr_rollID] = {}

            RollerName[rr_rollID][1] = ""
            rr_Item[rr_rollID] = "ID #" .. rr_rollID

            RR_Next:Disable()
            RR_Last:Disable()

            RR_NewRoll()

            for i = 1, 5 do
                _G["RR_Roller" .. i]:SetText("")
                _G["RR_RollerRank" .. i]:SetText("")
                _G["RR_RollerPR" .. i]:SetText("")
                _G["RR_Rolled" .. i]:SetText("")
                _G["RR_Group" .. i]:SetText("")
            end

            RR_Display(rr_CurrentRollID)
            RR_Test(RAIDROLL_LOCALE["All_saved_rolls_cleared"])
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    -- RESET the position of the frame to the center of the screen
    --_G["RR_RollFrame"]:ClearAllPoints()
    --_G["RR_RollFrame"]:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

    ----------------------------------------------------

    RaidRoll_Slider = CreateFrame("Slider", "RaidRoll_Slider_ID", RR_RollFrame, "OptionsSliderTemplate")
    RaidRoll_Slider:SetWidth(10)
    RaidRoll_Slider:SetHeight(RR_RollFrame:GetHeight() - 75)
    RaidRoll_Slider:SetPoint('TOPRIGHT', -5, -25)
    RaidRoll_Slider:SetOrientation('VERTICAL')

    _G[RaidRoll_Slider:GetName() .. 'Low']:SetText('')
    _G[RaidRoll_Slider:GetName() .. 'High']:SetText('')
    _G[RaidRoll_Slider:GetName() .. 'Text']:SetText('')

    RaidRoll_MaxNumber_Slider = 1

    RaidRoll_Slider:SetMinMaxValues(1, RaidRoll_MaxNumber_Slider)
    RaidRoll_Slider:SetValueStep(1)
    RaidRoll_Slider:SetValue(1)

    --RaidRoll_Slider:Show()

    RaidRoll_Slider:SetScript("OnValueChanged", function()
        RaidRoll_Window_Scroll(0)
    end)

    ----------------------------------------------------

    -- This allows scrolling and passes arg1 (the direction of the scrolling [1 or -1] )
    RR_RollFrame:EnableMouseWheel(1)
    RR_RollFrame:SetScript("OnMouseWheel", function(self, delta)
        RaidRoll_Window_Scroll(delta)
    end)

    -- Resize script, not used anymore
    --[[
    RR_Roll_Resize_Left = CreateFrame("Button", "RR_Roll_Resize_Left", RR_RollFrame)
    RR_Roll_Resize_Left:SetWidth(18)
    RR_Roll_Resize_Left:SetHeight(18)
    RR_Roll_Resize_Left:SetPoint("Bottomleft", RR_RollFrame, "Bottomleft", 0, 0)
    RR_Roll_Resize_Left:SetText("")
    RR_Roll_Resize_Left:SetScript("OnMouseDown",function()
                                            RR_RollFrame:SetMinResize(RR_RollFrame:GetWidth(),135)
                                            RR_RollFrame:SetMaxResize(RR_RollFrame:GetWidth(),1000)
                                            RR_RollFrame:StartSizing("BottomLeft")
                                            end)
    RR_Roll_Resize_Left:SetScript("OnMouseUp",function()
                                            RR_RollFrame:StopMovingOrSizing()
                                            end)

    RR_RollFrame:SetScript("OnSizeChanged",function()
                                            RaidRoll_Slider:SetHeight(RR_RollFrame:GetHeight() - 80 )
                                            RR_RollFrameHeight = RR_RollFrame:GetHeight()
                                            RR_RollWindowSizeUpdated()
                                            end)

    RR_Roll_Resize_Left:SetBackdrop({bgFile = "Interface\\Addons\\Recount\\textures\\ResizeGripLeft"})

    RR_RollFrame:SetResizable(true)

    RR_RollFrame:SetMinResize(RR_RollFrame:GetWidth(), 135)
    RR_RollFrame:SetMaxResize(RR_RollFrame:GetWidth(), 1000)
    --]]

    --RR_RollFrame:SetScale(1)

    if RaidRoll_DB["debug"] == true then RR_RollFrame:Show() end
end

-- sets up the name frame
function RR_SetupNameFrame()

    RR_NAME_FRAME = CreateFrame("Frame", nil, RR_RollFrame)

    local backdrop = {
        --bgFile="Interface\DialogFrame\UI-DialogBox-Background",  -- path to the background texture
        --edgeFile="Interface\DialogFrame\UI-DialogBox-Border",  -- path to the border texture
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", -- path to the background texture
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", -- path to the border texture
        tile = true, -- true to repeat the background texture to fill the frame, false to scale it
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
    RR_NAME_FRAME:SetBackdrop(backdrop)

    RR_Itemname:SetParent(RR_NAME_FRAME)
    RR_NAME_FRAME:SetFrameStrata("MEDIUM")
    --RR_NAME_FRAME:SetWidth(128) -- Set these to whatever height/width is needed
    --RR_NAME_FRAME:SetWidth(128) -- Set these to whatever height/width is needed
    RR_NAME_FRAME:SetHeight(30) -- for your Texture
    RR_NAME_FRAME:SetWidth(_G["RR_Itemname"]:GetWidth() + 20)
    RR_NAME_FRAME:SetPoint("BOTTOM", "RR_RollFrame", "TOP", 0, -6)

    --RR_NAME_FRAME:Hide()

    RR_NAME_FRAME:SetMovable(true)
    RR_NAME_FRAME:EnableMouse(true)
    RR_NAME_FRAME:SetScript("OnMouseDown", function()
        RR_RollFrame:StartMoving()
    end)
    RR_NAME_FRAME:SetScript("OnMouseUp", function()
        RR_RollFrame:StopMovingOrSizing()
    end)

    RR_UpdateNAME_FRAME = CreateFrame("Frame", nil, RR_RollFrame)

    RR_NAME_FRAME:SetScript("OnEnter", function(self)
        RR_MouseOverName = self:GetName()
        RR_UpdateNAME_FRAME:SetScript("OnUpdate", function()
            RR_MouseOver_NameFrame()
        end)
    end)

    RR_NAME_FRAME:SetScript("OnLeave", function()
        GameTooltip:Hide()
        RR_UpdateNAME_FRAME:SetScript("OnUpdate", function()
        -- Dont do anything
        end)
    end)

    RR_Itemname:SetPoint("TOPLEFT", RR_NAME_FRAME, "TOPLEFT", 11, -8)
end

function RR_MouseOver_NameFrame()
    --RR_Debug("Moused over " .. rr_Item[rr_CurrentRollID])

    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    GameTooltip:ClearAllPoints()
    GameTooltip:SetPoint("bottom", RR_NAME_FRAME, "top", 0, 0)
    GameTooltip:ClearLines()

    if string.find(rr_Item[rr_CurrentRollID], "ID ") == nil then
        GameTooltip:SetHyperlink(rr_Item[rr_CurrentRollID])
    end
end

function RR_OpenOptionsPanel()
    InterfaceOptionsFrame_OpenToCategory(RaidRoll_Panel.panel)
    -- Per http://www.wowpedia.org/Patch_5.3.0/API_changes
    -- We need to call this twice if the user has never opened the addon panel before
    InterfaceOptionsFrame_OpenToCategory(RaidRoll_Panel.panel)
end

function RR_RollWindowSizeUpdated()
    local height = RR_RollFrame:GetHeight()
    local extraheight = height - 135
    RR_Debug("extraheight = " .. extraheight)
end

function RR_FinishRolling(dontannounce, settime, button)
    RR_Debug("---- RR_FinishRolling ----")

    if dontannounce == true then
        if settime ~= nil then
            if RR_Timestamp > (time() - (59 - settime)) then
                if settime == 10 then RR_HasAnnounced_10_Sec = true end
                if settime == 5 then RR_HasAnnounced_5_Sec = true end
                RR_Timestamp = time() - (59 - settime)
            end
        end
    end

    if (rr_CurrentRollID == rr_rollID) and (time() < RR_Timestamp + 48 and (RollerName[rr_rollID][1] ~= "" or rr_Item[rr_rollID] ~= "ID #" .. rr_rollID)) then
        RR_Debug("---- Setting Timestamp ----")
        if dontannounce ~= true then
            RR_Debug("---- Announcing ----")
            RR_Timestamp = time() - 49
            RR_RollCountdown = true
            RR_HasAnnounced_10_Sec = false
            RR_HasAnnounced_5_Sec = false
            RR_AnnounceCountdowns = true
        else
            RR_Debug("---- NOT Announcing ----")
        end
    end

    local SpecialAssignment = "" -- used for banker or de assignments

    -- Award xxxx button
    if dontannounce ~= true then
        local Winner = RR_FindWinner(rr_CurrentRollID)
        if Winner == "" then
            if RaidRoll_DBPC[UnitName("player")]["RR_BankerUnit"] ~= nil then
                if RaidRoll_DBPC[UnitName("player")]["RR_DisenchanterUnit"] ~= nil then
                    RR_Debug("Both DE and Banker")
                    if button == "LeftButton" then
                        Winner = RaidRoll_DBPC[UnitName("player")]["RR_DisenchanterUnit"] -- left click for disenchanter
                        SpecialAssignment = "Disenchant"
                    else
                        Winner = RaidRoll_DBPC[UnitName("player")]["RR_BankerUnit"] -- right click for banker
                        SpecialAssignment = "Bank"
                    end
                else
                    RR_Debug("Banker Only")
                    Winner = RaidRoll_DBPC[UnitName("player")]["RR_BankerUnit"] -- only banker there
                    SpecialAssignment = "Bank"
                end
            elseif RaidRoll_DBPC[UnitName("player")]["RR_DisenchanterUnit"] ~= nil then
                RR_Debug("DE Only")
                Winner = RaidRoll_DBPC[UnitName("player")]["RR_DisenchanterUnit"] -- only de there
                SpecialAssignment = "Disenchant"
            end
        end

        if RaidRoll_DB["debug2"] == true then
            RR_Test(">>>><<>><><><><")
            RR_Test(Winner)
            RR_Test(rr_Item[rr_CurrentRollID])
            RR_Test(rr_CurrentRollID)
            RR_Test(rr_rollID)
            RR_Test(RR_Timestamp + 60)
            RR_Test(time())
            RR_Test("XX>><<>><><><><")
        end

        if Winner ~= "" and rr_Item[rr_CurrentRollID] ~= "ID #" .. rr_CurrentRollID and (time() > RR_Timestamp + 60 or rr_CurrentRollID ~= rr_rollID) then
            RR_Debug2("---- Awarding Loot ----")
            -- Get the number of items on the body
            local numLootItems = GetNumLootItems()
            local WeHaveFoundTheItem = false

            RR_Debug2(numLootItems .. " items found.")
            for i = 1, numLootItems do
                -- If its an item
                local lootIcon, lootName, lootQuantity, rarity = GetLootSlotInfo(i)

                --[[
                texture - Path to an icon texture for the item or amount of money (string)
                item - Name of the item, or description of the amount of money (string)
                quantity - Number of stacked items, or 0 for money (number)
                quality - Quality (rarity) of the item (number, itemQuality)
                locked - 1 if the item is locked (preventing the player from looting it); otherwise nil (1nil)
                --]]

                if lootQuantity ~= 0 then
                    if WeHaveFoundTheItem == false then
                        local ItemLink1 = GetLootSlotLink(i)
                        local ItemLink2 = rr_Item[rr_CurrentRollID]

                        if ItemLink1 ~= nil then
                            local _, itemId1, _ = strsplit(":", ItemLink1, 3)
                            local _, itemId2, _ = strsplit(":", ItemLink2, 3)

                            if RaidRoll_DB["debug2"] == true then
                                RR_Test("--------Item " .. i .. "-------")
                                RR_Test(ItemLink1)
                                RR_Test(itemId1)
                                RR_Test(ItemLink2)
                                RR_Test(itemId2)
                                RR_Test("--------------------")
                            end

                            if itemId1 == itemId2 then
                                RR_Debug2("Item Found, it was item #" .. i)
                                WeHaveFoundTheItem = true

                                if not RR_RollCheckBox_SilenceLootReason:GetChecked() then
                                    if SpecialAssignment == "" then
                                        RR_Say("Assigning " .. ItemLink1 .. " to " .. Winner .. ". Reason: Winner")
                                    else
                                        RR_Say("Assigning " .. ItemLink1 .. " to " .. Winner .. ". Reason: " .. SpecialAssignment)
                                    end
                                end

                                RR_GiveLoot(Winner, i)
                            end
                        end
                    end
                end
            end

            if WeHaveFoundTheItem == false then
                RR_Error(rr_Item[rr_CurrentRollID] .. " " .. RAIDROLL_LOCALE["item_not_found"])
            end
        end
    end
end

function RR_GiveLoot(player, slot)
    if RaidRoll_DB["debug2"] == true then
        RR_Test("---- RR_GiveLoot ----")
        RR_Test("Player: " .. player)
        RR_Test("Slot: " .. slot)
        RR_Test("Item: " .. GetLootSlotLink(slot))
    end

    StaticPopupDialogs["RaidRollGiveLoot"] = {
        text = string.format(RAIDROLL_LOCALE["Are_You_Sure"], GetLootSlotLink(slot), player),
        button1 = RAIDROLL_LOCALE["Give_to"] .. " " .. player,
        button2 = RAIDROLL_LOCALE["Cancel"],
        OnAccept = function()
            RR_ReallyGiveLoot(player, slot)
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    StaticPopup_Show("RaidRollGiveLoot")
end

function RR_ReallyGiveLoot(player, slot)
    RR_Debug2("Giving " .. player .. " the loot in slot " .. slot)

    -- Check all possible candidates
    for i = 1, 40 do
        local candidateName = GetMasterLootCandidate(slot, i)
        if candidateName ~= nil then
            RR_Debug2(i .. ": " .. candidateName)

            if RR_IsCharacterNameMatch(candidateName, player) then
                RR_Debug2("Giving loot in slot " .. i .. " to " .. player)
                GiveMasterLoot(slot, i)

                if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Auto_Close"] == true then
                    RR_RollFrame:Hide()
                end

                return  -- Loot given, so done
            end
        end
    end

    RR_Error(player .. " could not be found or is not eligable for the loot.")
end

function RR_DoYouWantToMarkThem(player)
    player = string.lower(player)

    StaticPopupDialogs["WannaMarkThem"] = {
        text = string.format(RAIDROLL_LOCALE["Mark_Them"], player),
        button1 = RAIDROLL_LOCALE["Mark"] .. " " .. player,
        button2 = RAIDROLL_LOCALE["Cancel"],
        button3 = RAIDROLL_LOCALE["Not_Sure"],
        button4 = RAIDROLL_LOCALE["Possibly"],
        OnAccept = function()
            RaidRoll_DBPC[UnitName("player")]["RR_NameMark"][player] = true
            if RR_RollFrame:IsShown() then
                RR_Display(rr_CurrentRollID)
            end
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    StaticPopup_Show("WannaMarkThem")
end
