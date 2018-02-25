-- only outputs the message if debug mode is on (NEW 4.5.1)
function RR_Debug(msg)
    if RaidRoll_DB["debug"] == true then
        RR_Test(msg)
    end
end

-- only outputs the message if debug mode is on (NEW 4.5.1)
function RR_Debug2(msg)
    if RaidRoll_DB["debug2"] == true then
        RR_Test(msg)
    end
end

function RR_Test(msg)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage(tostring(msg))
    end
end

function RR_Error(msg)
    RR_Test("|cffff0000Raid Roll error:|r " .. msg)
end

-- says the message in local, party or raid chat (NEW 4.5.1)
function RR_Say(msg)
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        SendChatMessage(msg, "INSTANCE_CHAT")  -- Instance party or raid
    elseif IsInRaid() then
        SendChatMessage(msg, "RAID")           -- Raid
    elseif IsInGroup() then
        SendChatMessage(msg, "PARTY")          -- Party
    else
        RR_Test(msg)                           -- Solo
    end
end

-- says the message in local, party or raid chat, also uses raid warning if allowed (NEW 4.5.1)
function RR_Shout(msg)
    if IsInRaid() and UnitIsGroupAssistant("self") ~= nil then
        SendChatMessage(msg, "RAID_WARNING")   -- Assistant or leader in instance raid or plain raid
    elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        SendChatMessage(msg, "INSTANCE_CHAT")  -- Instance party or raid
    elseif IsInRaid() then
        SendChatMessage(msg, "RAID")           -- Raid
    elseif IsInGroup() then
        SendChatMessage(msg, "PARTY")          -- Party
    else
        RR_Test(msg)                           -- Solo
    end
end

RaidRollHasLoaded = true

RR_NumberOfIcons = 5
RR_ListOfIcons = { "", "! ", "(N)", "(G)", "(NG)" }

function RR_LootWindowEvent(self, event, ...)
    local arg1, arg2, arg3, arg4, arg5, arg6 = ...

    if event == "CHAT_MSG_ADDON" then
        if arg1 == "RRL" then
            if RaidRoll_DB["debug"] == true then
                RR_Test("---Addon messages---")
                RR_Test(event)
                RR_Test(arg1)
                RR_Test(arg2)
                RR_Test(arg3)
                RR_Test(arg4)
                RR_Test(arg5)
                RR_Test(arg6)
            end

            -- change this to send it after 5 seconds
            if arg2 == "Request" then
                -- only send info if its more than 5 seconds since the last request
                if time() >= RR_LastItemDataReSent + 5 then
                    RR_LastItemDataReSent = time()
                    RR_SendRequestFrame:SetScript("OnUpdate", function()
                        if time() >= RR_LastItemDataReSent + 5 then
                            RR_SendItemInfo()
                            RR_SendRequestFrame:SetScript("OnUpdate", function() end)
                        end
                    end)
                end
            else
                if RaidRoll_LootTrackerLoaded == true then
                    RR_AddonMessageReceived(arg2, arg3)
                end
            end
        end
    end

    if event == "LOOT_OPENED" then
        RR_Debug(event .. ": arg1 = " .. (arg1 or "nil") .. ", arg2 = " .. (arg2 or "nil"))
        RR_SendItemInfo()
    end
end

function RR_GetMobName(unit)
    local mob_name

    -- If has a GUID and is a creature, name is the name of the creature
    local mob_guid = UnitGUID("target")
    if mob_guid and mob_guid:match("^Creature-") then
        mob_name = UnitName("target")
    end

    -- If was not a creature with a name, use unknown
    return mob_name or "Unknown"
end

function RR_SendItemInfo()
    local player_name, mob_name, numLootItems, LootNumber, WeHaveFoundAnItem, ItemLink, AcceptItem,
        DontAcceptItem, AcceptableZone, ZoneName, Seperator, Version, String, ItemId

    player_name = UnitName("player")
    mob_name = RR_GetMobName("target")

    -- Get the number of items on the body
    numLootItems = GetNumLootItems()

    LootNumber = 0

    -- Check if the mob has loots
    if numLootItems ~= nil then
        RR_Debug("Mob " .. mob_name .. " has " .. numLootItems .. " items")

        -- Used later to see if an item was found yet
        WeHaveFoundAnItem = false

        -- Start scanning for items
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

            if not lootQuantity or lootQuantity == 0 then
                RR_Debug("Skipping " .. tostring(lootName))
            else
                if WeHaveFoundAnItem == false then
                    -- If we are currently looking at the last window
                    --     if RaidRoll_DB["Loot"]["TOTAL WINDOWS"] == RaidRoll_DB["Loot"]["CURRENT WINDOW"] then
                    -- then increment the current window ID
                    --         RaidRoll_DB["Loot"]["CURRENT WINDOW"] = RaidRoll_DB["Loot"]["CURRENT WINDOW"] + 1
                    --     end
                    --
                    -- Add a window to the list of windows
                    --     RaidRoll_DB["Loot"]["TOTAL WINDOWS"] = RaidRoll_DB["Loot"]["TOTAL WINDOWS"] + 1
                    --     Max_LootID = RaidRoll_DB["Loot"]["TOTAL WINDOWS"]
                    --
                    -- Set the Identifier to the mob guid
                    --     if RaidRoll_DB["Loot"][Max_LootID] == nil then RaidRoll_DB["Loot"][Max_LootID] = mob_guid end

                    WeHaveFoundAnItem = true
                end

                -- Increase the count by 1 (because an item was found)
                LootNumber = LootNumber + 1

                -- Get the ICON and ITEMLINK
                ItemLink = GetLootSlotLink(i)
                if ItemLink ~= nil then

                    RR_Debug("Loot: slot=" .. i .. ", link=" .. ItemLink .. ", icon=" .. lootIcon .. ", name=" .. lootName
                        .. ", quantity=" .. lootQuantity .. ", rarity=" .. rarity)

                    -- Create an array
                    if RR_Check_lootName == nil then RR_Check_lootName = {} end

                    AcceptItem = false

                    local _, _, _, _, ItemId = string.find(ItemLink,
                        "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
                    ItemId = tonumber(ItemId)

                    local _, _, _, ItemLvl = GetItemInfo(ItemId)
                    ItemLvl = tonumber(ItemLvl)

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
                    if ItemId == 34057 or  -- Abyss Crystal
                        ItemId == 36931 or -- Ametrine
                        ItemId == 36919 or -- Cardinal Ruby
                        ItemId == 36928 or -- Dreadstone
                        ItemId == 36934 or -- Eye of Zul
                        ItemId == 36922 or -- King's Amber
                        ItemId == 36925 or -- Majestic Zircon
                        ItemId == 87208 or -- Sigil of Power
                        ItemId == 87209 or -- Sigil of Wisdom
                        ItemId == 47241 or -- Emblem of Triumph
                        ItemId == 49426 or -- Emblem of Frost
                        ItemId == 74248    -- Sha Crystal
                    then
                        DontAcceptItem = true
                        RR_Debug("[Epic Items] This is >NOT< an acceptable Item - " .. lootName)
                    else
                        RR_Debug("[Epic Items] This is an acceptable Item - " .. lootName)
                    end

                    AcceptableZone = false

                    -- Non-Localized zone info
                    ZoneName = GetRealZoneText()

                    if ZoneName == "Trial of the Crusader" or
                        ZoneName == "Icecrown Citadel" or
                        ZoneName == "Naxxramas" or
                        ZoneName == "Onyxia's Lair" or
                        ZoneName == "The Eye of Eternity" or
                        ZoneName == "The Obsidian Sanctum" or
                        ZoneName == "Ulduar" or
                        ZoneName == "Vault of Archavon"
                    then
                        AcceptableZone = true
                        RR_Debug("This is an acceptable Zone - " .. ZoneName)
                    else
                        RR_Debug("This is >NOT< an acceptable zone - " .. ZoneName)
                    end

                    if RaidRoll_DBPC[UnitName("player")]["RR_Frame_WotLK_Dung_Only"] == false then
                        local name, ins_type, _, _, maxPlayers = GetInstanceInfo()
                        RR_Debug("ins_type - " .. ins_type)
                        if ins_type == "raid" or RaidRoll_DB["debug"] == true then
                            AcceptableZone = true
                            RR_Debug("This is a Raid - " .. ZoneName)
                        end
                    end

                    --[[
                        Trial of the Crusader
                        Icecrown Citadel
                        Naxxramas
                        Onyxia's Lair
                        The Eye of Eternity
                        The Obsidian Sanctum
                        Ulduar
                        Vault of Archavon
                    --]]

                    RR_Check_lootName[LootNumber] = lootName
                    local tempLootName = lootName

                    if LootNumber > 1 then
                        local LootCount = 0
                        for i = 1, LootNumber - 1 do
                            -- Check if the lootName is the same as one in the list
                            if lootName == RR_Check_lootName[i] then
                                LootCount = LootCount + 1
                                lootName = tempLootName .. LootCount
                                RR_Check_lootName[LootNumber] = lootName
                            end
                        end
                    end

                    --local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name =
                    --      string.find(ItemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
                    --RR_Debug("Item ID = " .. Id)

                    Seperator = "\a" -- "\226\149\145"
                    Version = "WoDFixed"
                    String = ""

                    --[[ beta string format
                        String = (
                            Version .. Seperator ..
                            player_name .. Seperator ..
                            mob_name .. Seperator ..
                            ItemId .. Seperator ..
                            lootName.. Seperator ..
                            ItemLvl
                        )
                    --]]

                    if ItemLvl ~= nil then
                        -- String = (Version .. Seperator ..
                            -- player_name .. Seperator ..
                            -- mob_name .. Seperator ..
                            -- ItemId .. Seperator ..
                            -- lootName .. Seperator ..
                            -- ItemLvl)
						String = (Version .. Seperator ..
                            player_name .. Seperator ..
                            mob_name .. Seperator ..
                            ItemId .. Seperator ..
                            lootName .. Seperator ..
                            ItemLvl .. Seperator ..
							ItemLink)

                        if time() >= RR_LastItemDataReSent + 60 then
                            RR_LastItemDataReSent = time() - 10
                            if IsInRaid() or IsInGroup() then
                                SendAddonMessage("RRL", "Request", IsInRaid() and "RAID" or "PARTY")
                            end
                        end

                        --[[
                            0 for grey,
                            1 for white items and quest items,
                            2 for green,
                            3 for blue,
                            4 for epic,
                            5 for legendary,
                        --]]

                        -- Send items with epic or higher quality, also send items on the acceptable items list.
                        -- Also, only send items from an acceptable zone (raid)
                        if rarity > 3 or RaidRoll_DB["debug"] == true or AcceptItem == true then
                            if AcceptableZone == true or RaidRoll_DB["debug"] == true then
                                if DontAcceptItem == false or RaidRoll_DB["debug"] == true then
                                    if IsInRaid() or IsInGroup() then
                                        SendAddonMessage("RRL", String, IsInRaid() and "RAID" or "PARTY")
                                    end
                                    if IsInGuild() then
                                        SendAddonMessage("RRL", String, "GUILD")
                                    end
                                end
                            end
                        end

                        --RaidRoll_DB["Loot"][mob_guid]["LOOTER NAME"]    = player_name
                        --RaidRoll_DB["Loot"][mob_guid]["MOB NAME"]       = mob_name
                        --RaidRoll_DB["Loot"][mob_guid]["TOTAL ITEMS"]    = LootNumber
                        --
                        --if RaidRoll_DB["Loot"][mob_guid]["ITEM_" .. LootNumber] == nil then
                        --    RaidRoll_DB["Loot"][mob_guid]["ITEM_" .. LootNumber] = {}
                        --end
                        --
                        --RaidRoll_DB["Loot"][mob_guid]["ITEM_" .. LootNumber]["ITEMLINK"]    = ItemLink
                        --RaidRoll_DB["Loot"][mob_guid]["ITEM_" .. LootNumber]["ICON"]        = lootIcon
                        --RaidRoll_DB["Loot"][mob_guid]["ITEM_" .. LootNumber]["WINNER"]      = "-"
                        --RaidRoll_DB["Loot"][mob_guid]["ITEM_" .. LootNumber]["RECEIVED"]    = "-"
                    end

                    if RaidRoll_LootTrackerLoaded == true then
                        RR_Loot_Display_Refresh()
                    end
                end
            end
        end
    end
end

--  --  --  --  --  --  --  --  --  --  --  --
--  USED TO DISPLAY TOOLTIPS THEN MOUSING   --
--  OVER A BUTTON. THE FRAME NAME IS        --
--  PASSED AS "ID" AND THE TOOLTIPS ARE     --
--  STORED IN THE "RR_Tooltips" ARRAY.      --
--  --  --  --  --  --  --  --  --  --  --  --
function RR_MouseOverTooltip(ID)
    if RR_Tooltips == nil then
        RR_Tooltips = {}
    end

    RR_Tooltips[ID] = RAIDROLL_LOCALE[ID]

    -- Displays tooltip for rollers
    if ID ~= nil then
        if string.find(ID, "Raid_Roll_SetSymbol") then

            local CharID = tonumber(string.sub(ID, 20))
            --RR_Debug("MouseOverTooltip: " .. ID .. " = " .. CharID)

            if RR_RollData ~= nil and RR_RollData[rr_CurrentRollID] ~= nil and RR_RollData[rr_CurrentRollID][CharID] ~= nil then
                RR_Tooltips[ID] = RollerName[rr_CurrentRollID][CharID] .. " " .. RollerRoll[rr_CurrentRollID][CharID] .. " "
                    .. RR_RollData[rr_CurrentRollID][CharID]["LowHigh"]
                if RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Enabled"] == true then
                    RR_Tooltips[ID] = RollerName[rr_CurrentRollID][CharID] .. " "
                        .. RR_RollData[rr_CurrentRollID][CharID]["EPGPValues"] .. " PR: " .. RR_EPGP_PRValue[rr_CurrentRollID][CharID]
                end
            else
                RR_Tooltips[ID] = ""
            end

        --[[
        RollerName[rr_rollID][j]
        RollerRoll[rr_rollID][j]
        RR_EPGP_PRValue[rr_rollID][j]

        RR_EPGP_EPGPValues[rr_rollID][j]
        RaidRoll_LowHigh[rr_rollID][j]
        --]]
        end
    end

    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    GameTooltip:ClearAllPoints()
    GameTooltip:SetPoint("bottomleft", _G[ID], "top", 0, 0)
    GameTooltip:ClearLines()
    GameTooltip:SetText(RR_Tooltips[ID])
end

------------------------------------------------------------------------------------------------------------

function RR_SetupSlashCommands()
    SLASH_RRL1 = "/rr"
    SLASH_RRL2 = "/raidroll"
    SLASH_RRL3 = "/rrl"

    SlashCmdList["RRL"] = RRL_Command
end

function RaidRoll_OnLoad(self)
    RR_Test("Kilerpet's Raid Roll Addon - Loaded")

    -- local f = CreateFrame("Frame")
	
 
	self:RegisterEvent("UPDATE_LFG_TYPES")
    self:RegisterEvent("CHAT_MSG_INSTANCE_CHAT")
    self:RegisterEvent("CHAT_MSG_SYSTEM")
    self:RegisterEvent("CHAT_MSG_PARTY")
    self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
    self:RegisterEvent("CHAT_MSG_RAID")
    self:RegisterEvent("CHAT_MSG_RAID_LEADER")
    self:RegisterEvent("CHAT_MSG_RAID_WARNING")
    self:RegisterEvent("CHAT_MSG_SAY")
    self:RegisterEvent("CHAT_MSG_YELL")
    self:RegisterEvent("CHAT_MSG_WHISPER")
     self:RegisterEvent("CHAT_MSG_ADDON")
    self:RegisterEvent("GUILD_ROSTER_UPDATE")
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("VARIABLES_LOADED")   -- Fired when saved variables are loaded

    RR_ClearAllData_Startup()

    --  f:SetScript("OnEvent", RaidRoll_Event)

    -- Hook Looting events
    local RR_LootEventHook = CreateFrame("Frame")
    RR_LootEventHook:RegisterEvent("LOOT_OPENED")
    RR_LootEventHook:RegisterEvent("CHAT_MSG_ADDON")
    RR_LootEventHook:SetScript("OnEvent", RR_LootWindowEvent)
end

function RR_ClearAllData_Startup()
    RR_Has_Rolled = false
    RR_Rolling_on_item = true

    rr_rollID = 0
    rr_CurrentRollID = 0

    RR_ScrollOffset = 0

    -- Define the various arrays
    rr_Roll = {}
    rr_PlayersRolled = {}
    rr_Item = {}
    rr_playername = {}
    RollerRoll = {}
    RollerName = {}
    RollerGroup = {}
    MaxPlayers = {}
    RollerFirst = {}
    RollerRank = {}
    RollerRankIndex = {}
    HasRolled = {}
    Roll_Number = {}
    RaidRoll_LegitRoll = {}
    if RaidRoll_DBPC == nil then RaidRoll_DBPC = {} end
    if RaidRoll_DBPC[UnitName("player")] == nil then RaidRoll_DBPC[UnitName("player")] = {} end
    if RaidRoll_DBPC[UnitName("player")]["RR_NameMark"] == nil then RaidRoll_DBPC[UnitName("player")]["RR_NameMark"] = {} end
    if RaidRoll_DBPC[UnitName("player")]["RR_PlayerIconID"] == nil then RaidRoll_DBPC[UnitName("player")]["RR_PlayerIconID"] = {} end
    if RaidRoll_DBPC[UnitName("player")]["RR_PlayerIcon"] == nil then RaidRoll_DBPC[UnitName("player")]["RR_PlayerIcon"] = {} end
    RollerColor = {}
    RR_EPGPAboveThreshold = {}
    RR_EPGP_PRValue = {}
    RR_RollData = {}

    rr_Item[0] = "ID #0"

    RollerName[0] = {}

    RollerName[0][1] = ""

    RR_Timestamp = 0

    RR_Doing_a_New_Roll = false

    if RR_LastItemDataReSent == nil then RR_LastItemDataReSent = time() - 60 end
    RR_SendRequestFrame = CreateFrame("Frame")

    RR_HomeRealmNameLower = strlower(GetRealmName())
end

function RaidRoll_Window_Scroll(direction)
    RR_Debug("WindowScroll: " .. direction .. ", " .. RaidRoll_Slider:GetValue())

    -- Dont scroll unless a maxplayers value exists
    if MaxPlayers[rr_CurrentRollID] ~= nil then
        if MaxPlayers[rr_CurrentRollID] >= 5 then
            RaidRoll_MaxNumber = MaxPlayers[rr_CurrentRollID] - 4
            --else
            --RaidRoll_MaxNumber = 1
            --end

            RaidRoll_MaxNumber_Slider = RaidRoll_MaxNumber

            if rr_CurrentRollID > 0 and RaidRoll_MaxNumber > 1 then RaidRoll_MaxNumber_Slider = RaidRoll_MaxNumber - 1 end

            RaidRoll_Slider:SetMinMaxValues(1, RaidRoll_MaxNumber_Slider)


            RaidRoll_Slider:SetValue(RaidRoll_Slider:GetValue() - (direction * 3))

            if RaidRoll_Slider:GetValue() > RaidRoll_MaxNumber then
                RaidRoll_Slider:SetValue(RaidRoll_MaxNumber)
            end

            RR_ScrollOffset = RaidRoll_Slider:GetValue() - 1

            --for i=1, 5 do
            --if InviteHelper_Position[i+RaidRoll_Slider:GetValue()] ~= nil then
            --  _G["InviteHelper_GMButton_name" .. i]:SetText(i+RaidRoll_Slider:GetValue() - 1 .. ": " .. RaidRoll_Position[i+RaidRoll_Slider:GetValue()])
            --else
            --  _G["InviteHelper_GMButton_name" .. i]:SetText("")
            --end
            --end

            --RaidRoll_Slider.tooltipText = RaidRoll_Slider:GetValue() .. " - " .. RaidRoll_Slider:GetValue() + 4

            RR_Display(rr_CurrentRollID)
        end
    end
end

-- TOGGLE THE OPTIONS MENU
function RR_Roll_Options_Toggle()

    if RR_BottomFrame:IsShown() then
        _G["RaidRoll_Catch_All"]:Hide()
        _G["RaidRoll_Allow_All"]:Hide()
        RR_BottomFrame:Hide()
    else
        _G["RaidRoll_Catch_All"]:Show()
        _G["RaidRoll_Allow_All"]:Show()
        RR_BottomFrame:Show()
    end
end

----------------------------------------------------------------------------------------------

function RaidRoll_Event(self, event, ...)
    local arg1, arg2, arg3, arg4, arg5, arg6 = ...

    if event == "CHAT_MSG_ADDON" and arg1 == "RAIDROLL" then
        RR_Test("|cFF11aacc" .. arg2 .. " found.")
        if RaidRoll_DB == nil then RaidRoll_DB = {} end
        if RaidRoll_DB["Amount"] == nil then RaidRoll_DB["Amount"] = 1 end
        if RaidRoll_DB["Names"] == nil then RaidRoll_DB["Names"] = {} end

        local CharacterWasFound = false

        for i = 1, RaidRoll_DB["Amount"] do
            if RaidRoll_DB["Names"][i] == arg2 then CharacterWasFound = true end
        end

        if CharacterWasFound == false then
            RaidRoll_DB["Names"][RaidRoll_DB["Amount"]] = arg2
            RaidRoll_DB["Amount"] = RaidRoll_DB["Amount"] + 1
        end
    end

    -- Set up the variables with default values and set up the check boxes
    if event == "VARIABLES_LOADED" then
        RR_SetupVariables()
        RR_SetupSlashCommands()
        RR_EPGP_Setup()
    end

    if event == "GUILD_ROSTER_UPDATE" then
        RR_GuildRankUpdate()
    end

    -- Debugging, show the events that occured and the arguments
    if RaidRoll_DB ~= nil then
        if RaidRoll_DB["debug"] == true then
            if arg1 == nil or (arg1 ~= nil and (arg1 ~= "Crb" and arg1 ~= "LGP")) then
                RR_Test("Event " .. event)
                if arg1 ~= nil then RR_Test("1 .. " .. arg1) end
                if arg2 ~= nil then RR_Test("2 .. " .. arg2) end
                if arg3 ~= nil then RR_Test("3 .. " .. arg3) end
                if arg4 ~= nil then RR_Test("4 .. " .. arg4) end
                if arg5 ~= nil then RR_Test("5 .. " .. arg5) end
                if arg6 ~= nil then RR_Test("6 .. " .. arg6) end
            end
        end
    end

    if event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" or event == "CHAT_MSG_RAID"
        or event == "CHAT_MSG_RAID_LEADER" or event == "CHAT_MSG_RAID_WARNING" or event == "CHAT_MSG_SAY"
    then
        local arg1_s = string.lower(arg1)  -- message
        local arg2_s = string.lower(arg2)  -- sender

        if string.find(arg1, RAIDROLL_LOCALE["Rolling_Ends_in_10_Sec"]) then
            RR_FinishRolling(true, 10)
        end

        if string.find(arg1, RAIDROLL_LOCALE["Rolling_Ends_in_5_Sec"]) then
            RR_HasAnnounced_10_Sec = true
            RR_FinishRolling(true, 5)
        end

        if string.find(arg1_s, "item:") then
            if RR_IsCharacterNameMatch(UnitName("player"), arg2_s) then

                -- We sent the message, so honor it

                --Find the start and end location of the item link
                local xRR_Start_Loc, _ = string.find(arg1_s, "item:")
                local _, xRR_End_Loc = string.find(arg1_s, "|h|r")

                if xRR_Start_Loc == nil then xRR_Start_Loc = 0 end
                if xRR_End_Loc == nil then xRR_End_Loc = 0 end

                --Get the words before and after the item link
                local RR_String_minus_ILink1 = strsub(arg1, 0, xRR_Start_Loc - 12)
                local RR_String_minus_ILink2 = strsub(arg1, xRR_End_Loc, strlen(arg1))

                --If they are nil set them to blank values
                if RR_String_minus_ILink1 == nil then RR_String_minus_ILink1 = "" end
                if RR_String_minus_ILink2 == nil then RR_String_minus_ILink2 = "" end

                --Put them together
                local RR_String_minus_ILink = RR_String_minus_ILink1 .. RR_String_minus_ILink2

                -- use lower case characters
                RR_String_minus_ILink = string.lower(RR_String_minus_ILink)

                RR_Debug(RR_String_minus_ILink)

                local RR_ChatRollFound = string.find(RR_String_minus_ILink, "roll")
                --[[
                if RR_ChatRollFound == nil then
                    RR_ChatRollFound = string.find(RR_String_minus_ILink, RAIDROLL_LOCALE["Roll"])
                end
                --]]

                -- Includes german searching for roll announcement
                if string.find(arg1_s, "|h|r") ~= nil and string.find(RR_String_minus_ILink, "raid roll") == nil
                    and (RR_ChatRollFound ~= nil or event == "CHAT_MSG_RAID_WARNING")
                then
                    RR_Debug("Rolling on an item detected")

                    if IsInGuild() then GuildRoster() end
                    if IsInGuild() then RR_GetEPGPGuildData() end

                    --Timestamp of when the rolling was announced
                    RR_Timestamp = time() + RaidRoll_DBPC[UnitName("player")]["Time_Offset"]
                    RR_Debug("Timestamp set to " .. RR_Timestamp)

                    -- This being false tells us that we should begin decrementing the counter
                    RR_Doing_a_New_Roll = false

                    --Cut the itemlink out of the string
                    local xRR_ItemLink
                    if xRR_Start_Loc ~= nil and xRR_End_Loc ~= nil then
                        xRR_ItemLink = strsub(arg1, xRR_Start_Loc - 12, xRR_End_Loc)
                    end
                    RR_Debug(xRR_ItemLink)

                    if rr_Item[rr_rollID] ~= "ID #" .. rr_rollID or RollerName[rr_rollID][1] ~= "" then
                        rr_rollID = rr_rollID + 1
                        if rr_CurrentRollID + 1 == rr_rollID then
                            rr_CurrentRollID = rr_rollID
                        end
                    end

                    rr_Item[rr_rollID] = xRR_ItemLink
                    rr_RollSort(rr_rollID, 0, "", true)

                    RR_Debug("New item roll found, ID#" .. rr_rollID)
                end

                RR_Rolling_on_item = true
            else
                -- Not sent by us, so ignore it
                RR_Debug("Not from you, so ignoring it")
            end
        end
    end

    if RaidRoll_DBPC[UnitName("player")] ~= nil then
        if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Track_EPGPSays"] == true then
            if event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" or event == "CHAT_MSG_RAID"
                or event == "CHAT_MSG_RAID_LEADER" or event == "CHAT_MSG_RAID_WARNING" or event == "CHAT_MSG_SAY"
            then
                if arg1 ~= nil and arg2 ~= nil then
                    local arg1_s = string.lower(arg1)

                    if string.find(arg1_s, "%!epgp") then
                        RR_ARollHasOccured(arg2, "1", "1", "100")
                    end
                end
            end
        end
    end

    if RaidRoll_DBPC[UnitName("player")] ~= nil then
        if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Track_Bids"] == true then
            if event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" or event == "CHAT_MSG_RAID"
                or event == "CHAT_MSG_RAID_LEADER" or event == "CHAT_MSG_RAID_WARNING" or event == "CHAT_MSG_SAY"
            then
                local arg1_s = string.lower(arg1)

                if string.find(arg1_s, "%!bid") then

                    local _, bid = strsplit(" ", arg1_s)

                    RR_Test(bid)
                    RR_Test(tonumber(bid))

                    if tonumber(bid) ~= nil then
                        RR_ARollHasOccured(arg2, bid, "1", "100")
                    else
                        if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Num_Not_Req"] == true then
                            RR_ARollHasOccured(arg2, 0, "1", "100")
                        end
                    end
                end
            end
        end
    end

    -- Roll handler
    if event == "CHAT_MSG_SYSTEM" then
        local Name, Roll, Low, High = RR_RollHandler(arg1)
        if Name ~= nil then
            RR_ARollHasOccured(Name, Roll, Low, High)
        end
    end
end

function RR_ARollHasOccured(Name, Roll, Low, High)

    if IsInGuild() then
        GuildRoster()
        RR_GetEPGPGuildData()
    end

    local Roll = tonumber(Roll)
    local Low = tonumber(Low)
    local High = tonumber(High)

    -- Standard Roll Catcher
    if RR_Rolling_on_item == true then
        -- Debugging, tells us how long after the announcement the roll was detected
        RR_Debug("Roll detected " .. time() - RR_Timestamp .. " seconds after announcement")

        -- If its less than 60 seconds after then accept the roll
        if time() < RR_Timestamp + 60 or RaidRoll_DBPC[UnitName("player")]["RR_Track_Unannounced_Rolls"] == true then
            --This creates a new window for rolls made more than 60 seconds after the last roll if the option to track unannounced rolls is turned on
            if RaidRoll_DBPC[UnitName("player")]["RR_Track_Unannounced_Rolls"] == true then
                if time() > RR_Timestamp + 60 then
                    RR_NewRoll()
                end
            end

            -- This controls the showing of the window (true = show window, false = dont show window)
            if RaidRoll_DBPC[UnitName("player")]["RR_Roll_Tracking_Enabled"] == true then
                RR_RollFrame:Show()
                RR_NAME_FRAME:Show()
            end

            -- Find out if the roll is a standard (1-100) roll or not
            local LegitRoll
            if High == 100 and Low == 1 then
                LegitRoll = true
                RR_Debug("Standard roll detected")
            else
                LegitRoll = false
            end

            local LowHigh = "(" .. Low .. "-" .. High .. ")"

            -- This being false tells us that we should begin decrementing the counter
            RR_Doing_a_New_Roll = false

            -- Create a new array for rolls if needed
            if rr_Roll[rr_rollID] == nil then rr_Roll[rr_rollID] = {} end

            -- If the person has not rolled yet
            if rr_Roll[rr_rollID][Name] == nil then
                -- Record their roll
                rr_Roll[rr_rollID][Name] = tonumber(Roll)

                -- If the list of players that rolled is empty then set it to 1, otherwise add 1 to it
                if rr_PlayersRolled[rr_rollID] == nil then
                    rr_PlayersRolled[rr_rollID] = 1
                else
                    rr_PlayersRolled[rr_rollID] = rr_PlayersRolled[rr_rollID] + 1
                end

                RR_Debug("Total players rolled: " .. rr_PlayersRolled[rr_rollID])
                if rr_playername[rr_rollID] == nil then rr_playername[rr_rollID] = {} end
                rr_playername[rr_rollID][rr_PlayersRolled[rr_rollID]] = Name

                rr_RollSort(rr_rollID, Roll, Name, true, true, LegitRoll, LowHigh)
            else
                rr_RollSort(rr_rollID, Roll, Name, true, false, LegitRoll, LowHigh)

                if RR_RollCheckBox_Multi_Rollers:GetChecked() then
                    RR_Say(RAIDROLL_LOCALE["Multiroll_by"] .. Name) -- announce that there was a multiroll
                end
            end
        end
    end

    -- Raid Roll Catcher
    if RR_Has_Rolled == true then
        --Check if the player rolling is the user
        if Name == UnitName("player") then
            RR_Debug("You have rolled on a raid roll")

            if RR_Name_Array[Roll] ~= nil and RR_ItemLink == nil then
                RR_Say(">>> " .. RR_Name_Array[Roll] .. " " .. RAIDROLL_LOCALE["Wins"] .. " <<<")
            end

            if RR_Name_Array[Roll] ~= nil and RR_ItemLink ~= nil then
                RR_Say(">>> " .. RR_Name_Array[Roll] .. " " .. RAIDROLL_LOCALE["Wins"] .. " <<<")
            end

            RR_Has_Rolled = false
        end
    end

    -- update scrollbar
    if MaxPlayers[rr_CurrentRollID] and MaxPlayers[rr_CurrentRollID] >= 5 then
        RaidRoll_MaxNumber = MaxPlayers[rr_CurrentRollID] - 4
        RaidRoll_MaxNumber_Slider = RaidRoll_MaxNumber
        if rr_CurrentRollID > 0 and RaidRoll_MaxNumber > 1 then RaidRoll_MaxNumber_Slider = RaidRoll_MaxNumber - 1 end
        RaidRoll_Slider:SetMinMaxValues(1, RaidRoll_MaxNumber_Slider)
    end
end

-- Convert Blizzard locale specific print string for roll chat messages to a regex to parse them.
-- Since the first term is the character name and character names with realms can contain spaces,
-- we'll look for a message that ends with this regex.
-- I'm assuming this is correct because the previous code pulled the character name from
-- the first word of the message, but for cross-realm characters with multi-word realm names,
-- we need a stronger solution.
local _rollMessageTailRegex =
    RANDOM_ROLL_RESULT               -- The enUS value is "%s rolls %d (%d-%d)"
                                     -- The German value is "%1$s würfelt. Ergebnis: %2$d (%3$d-%4$d)"
        :gsub("%(", "%%(")           -- Open paren escaped for regex
        :gsub("%)", "%%)")           -- Close paren escaped for regex
        :gsub("%%d", "(%%d+)")       -- Convert %d for printing integer to sequence of digits
        :gsub("%%%d+%$d", "(%%d+)")  -- Convert positional %#$d for printing integer to sequence of digits
        :gsub("%%s", "")             -- Delete %s for character name
        :gsub("%%%d+%$s", "")        -- Delete positional %#$s for character name
        .. "$"                       -- End of line anchor for regex

function RR_RollHandler(msg)

    if msg == nil then
        return nil
    end

    local roll, min, max = msg:match(_rollMessageTailRegex)
    roll = tonumber(roll)
    min = tonumber(min)
    max = tonumber(max)
    if roll == nil or roll == 0 or min == nil or min == 0 or max == nil or max == 0 then
        RR_Debug("No roll in message: " .. msg)
        return nil
    end

    local name = msg:gsub("%s*" .. _rollMessageTailRegex, "")
    if name == nil or strlen(name) == 0 then
        RR_Debug("No name in roll message: " .. msg)
        return nil
    end

    -- As of 5.4.8, the name in a roll message is the character name without a realm.
    -- GetUnitName may not be intended for this, but when given a character name in your
    -- raid group, it returns the character's name AND realm.
    -- We need both name and realm for assigning loot.
    -- At this time, you cannot have cross-realm guild members, so guild roster lookup for EP/GP
    -- will match because GetUnitName does NOT return the realm name of characters on your realm.
    local nameInGroup = GetUnitName(name, true)
    if nameInGroup == nil then
        RR_Debug("Roll message name " .. name .. " not in group")
    else
        name = nameInGroup
    end

    RR_Debug("Roll message: name=" .. name .. ", roll=" .. roll .. ", min=" .. min .. ", max=" .. max .. ", msg=" .. msg)
    return name, roll, min, max
end

-- PlayerRoll = the roll performed
-- PlayerName = the name of the player who rolled
-- rr_rollID = the id of the list
-- rr_FirstRoll = was it this persons first roll? (true / false)
-- rr_AddedPlayer = if we added a player this is true, otherwise it is false (for re-sorting)
function rr_RollSort(rr_rollID, PlayerRoll, PlayerName, rr_AddedPlayer, rr_FirstRoll, RR_LegitRoll, LowHigh)
    --RR_Test("www"..LowHigh)
    local temp

    --if rr_rollID == nil then rr_rollID = rr_CurrentRollID end

    if rr_AddedPlayer == true then

        -- Checks for the variables that are passed to make sure no nil values are passed
        if rr_FirstRoll == nil then rr_FirstRoll = false end -- Was this their first roll?
        if rr_AddedPlayer == nil then rr_AddedPlayer = false end -- Are you adding more players to the list or just re-sorting? (SET THIS TO DEFAULT FALSE)
        if RR_LegitRoll == nil then RR_LegitRoll = false end -- Is it a 1-100 roll?
        if LowHigh == nil then LowHigh = "(1-100)" end -- Is it a 1-100 roll?

        -- If this is the first time that it is called then set the max rollers value to zero
        if MaxPlayers[rr_rollID] == nil then MaxPlayers[rr_rollID] = 0 end

        -- If you are to add a player then increment the value
        if rr_AddedPlayer == true then MaxPlayers[rr_rollID] = MaxPlayers[rr_rollID] + 1 end

        -- If there are less than 5 rollers then set the value to 5 (to avoid bugs)
        if MaxPlayers[rr_rollID] < 5 then
            MaxPlayersValue = 5
        else
            MaxPlayersValue = MaxPlayers[rr_rollID]
        end

        if RR_RollData[rr_rollID] == nil then
            RR_RollData[rr_rollID] = {}
        end

        if RR_RollData[rr_rollID][MaxPlayersValue] == nil then
            RR_RollData[rr_rollID][MaxPlayersValue] = {}
            RR_RollData[rr_rollID][MaxPlayersValue]["LowHigh"] = ""
            RR_RollData[rr_rollID][MaxPlayersValue]["EPGPValues"] = ""
        end

        -- Making the variable to an array
        if RollerName[rr_rollID] == nil then RollerName[rr_rollID] = {} end
        if RollerRoll[rr_rollID] == nil then RollerRoll[rr_rollID] = {} end
        if RollerFirst[rr_rollID] == nil then RollerFirst[rr_rollID] = {} end
        if RollerRank[rr_rollID] == nil then RollerRank[rr_rollID] = {} end
        if RollerRankIndex[rr_rollID] == nil then RollerRankIndex[rr_rollID] = {} end
        if HasRolled[rr_rollID] == nil then HasRolled[rr_rollID] = {} end
        if Roll_Number[rr_rollID] == nil then Roll_Number[rr_rollID] = {} end
        if RaidRoll_LegitRoll[rr_rollID] == nil then RaidRoll_LegitRoll[rr_rollID] = {} end
        if RollerColor[rr_rollID] == nil then RollerColor[rr_rollID] = {} end
        if RR_EPGPAboveThreshold[rr_rollID] == nil then RR_EPGPAboveThreshold[rr_rollID] = {} end
        if RR_EPGP_PRValue[rr_rollID] == nil then RR_EPGP_PRValue[rr_rollID] = {} end

        if HasRolled[rr_rollID][PlayerName] == nil then
            HasRolled[rr_rollID][PlayerName] = 1
        else
            HasRolled[rr_rollID][PlayerName] = HasRolled[rr_rollID][PlayerName] + 1
        end

        Roll_Number[rr_rollID][MaxPlayersValue] = HasRolled[rr_rollID][PlayerName]

        -- Filling in the blank values with dummies
        for i = 1, MaxPlayersValue - 1 do
            if RollerName[rr_rollID][i] == nil then RollerName[rr_rollID][i] = "" end
            if RollerRoll[rr_rollID][i] == nil then RollerRoll[rr_rollID][i] = 0 end
            if RollerFirst[rr_rollID][i] == nil then RollerFirst[rr_rollID][i] = false end
            if RollerRank[rr_rollID][i] == nil then RollerRank[rr_rollID][i] = "" end
            if RollerRankIndex[rr_rollID][i] == nil then RollerRankIndex[rr_rollID][i] = 11 end
            if RaidRoll_LegitRoll[rr_rollID][i] == nil then RaidRoll_LegitRoll[rr_rollID][i] = false end
            if RollerColor[rr_rollID][i] == nil then RollerColor[rr_rollID][i] = "" end
            if RR_EPGPAboveThreshold[rr_rollID][i] == nil then RR_EPGPAboveThreshold[rr_rollID][i] = false end
            if RR_EPGP_PRValue[rr_rollID][i] == nil then RR_EPGP_PRValue[rr_rollID][i] = 0 end
        end

        -- Getting and filling in the name colors
        if RaidRoll_DBPC[UnitName("player")]["RR_ShowClassColors"] == true then
            if IsInRaid() then
                -- we are in a raid
                for i = 1, 40 do
                    local name, rank, subgroup, level, class, fileName = GetRaidRosterInfo(i)
                    -- fileName
                    --  String - The system representation of the character's class; always in english, always fully capitalized.
                    if PlayerName ~= nil and name ~= nil then
                        if strupper(PlayerName) == strupper(name) then
                            RollerColor[rr_rollID][MaxPlayersValue] = RR_GetClassColor(fileName)
                            RR_Debug("Color " .. RollerColor[rr_rollID][MaxPlayersValue] .. fileName)
                        end
                    end
                end
            else
                for i = 1, 5 do
                    --[[
                    if i==1 then
                        name = UnitName("player")
                        guid = UnitGUID("player")
                        DEFAULT_CHAT_FRAME:AddMessage(guid)
                        locClass, engClass, locRace, engRace, gender = GetPlayerInfoByGUID(guid)
                        -- engClass
                        --  String - Class of the character in question (in English)
                        if RaidRoll_DB["debug"] == true then if engClass ~= nil then RR_Test(name .. engClass) end end
                    else
                        name = UnitName("party" .. i-1)
                        guid = UnitGUID("party" .. i-1)
                        if guid ~= nil then
                            locClass, engClass, locRace, engRace, gender = GetPlayerInfoByGUID(guid)
                        else
                            engClass = ""
                        end
                        if RaidRoll_DB["debug"] == true then if name ~= nil then RR_Test(name .. engClass) end end
                    end
                    --]]

                    --zhCN code
                    local name, guid, locClass, locRace, engClass, engRace, gender
                    if (GetLocale() == "zhCN") then
                        name = UnitName("party" .. i)
                        _, engClass = UnitClass("party" .. i)
                    else
                        if i == 1 then
                            name = UnitName("player")
                            guid = UnitGUID("player")
                            --DEFAULT_CHAT_FRAME:AddMessage(guid)
                            locClass, engClass, locRace, engRace, gender = GetPlayerInfoByGUID(guid)
                            -- engClass
                            --  String - Class of the character in question (in English)
                            --if engClass ~= nil then RR_Test(name .. " is a " .. engClass) end
                        else
                            name = UnitName("party" .. i - 1)
                            guid = UnitGUID("party" .. i - 1)
                            if guid ~= nil then
                                locClass, engClass, locRace, engRace, gender = GetPlayerInfoByGUID(guid)
                            else
                                engClass = ""
                            end
                            --if name ~= nil then RR_Debug(name .. " is a " .. engClass) end
                        end
                    end

                    if PlayerName ~= nil and name ~= nil then
                        -- RR_Debug("RROL539 pn=" .. (PlayerName or "nil") .. ", n=" .. (name or "nil"))
                        if RR_IsCharacterNameMatch(PlayerName, name) then
                            if engClass ~= nil then
                                RollerColor[rr_rollID][MaxPlayersValue] = RR_GetClassColor(engClass)
                                --RR_Debug("Color " .. RollerColor[rr_rollID][MaxPlayersValue] .. engClass)
                            end
                        end
                    end
                end
            end
        end

        -- Setting the players name, roll, guild rank and roll status to the current max players value
        if rr_AddedPlayer == true then
            RollerName[rr_rollID][MaxPlayersValue] = PlayerName
            RollerRoll[rr_rollID][MaxPlayersValue] = tonumber(PlayerRoll)
            RollerFirst[rr_rollID][MaxPlayersValue] = rr_FirstRoll

            local PR, AboveThreshold, EP, GP = RR_GetEPGPCharacterData(PlayerName)

            RR_EPGPAboveThreshold[rr_rollID][MaxPlayersValue] = AboveThreshold
            RR_EPGP_PRValue[rr_rollID][MaxPlayersValue] = PR

            RR_RollData[rr_rollID][MaxPlayersValue]["LowHigh"] = LowHigh
            RR_RollData[rr_rollID][MaxPlayersValue]["EPGPValues"] = "EP: " .. EP .. " GP: " .. GP

            --CODE CHANGED DRKNEZSZ
            if RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Enabled"] == true then
                if PlayerName ~= "" then
                    RR_Say(PlayerName .. " has Prio: " .. PR)
                end
            end
            --END OF CODE CHANGED

            -- Default rank and rank id values (will be overwritten if the person is in the guild
            RollerRank[rr_rollID][MaxPlayersValue] = ""
            RollerRankIndex[rr_rollID][MaxPlayersValue] = 10
            RaidRoll_LegitRoll[rr_rollID][MaxPlayersValue] = RR_LegitRoll

            -- scan the guild info for the person
            for i = 1, GetNumGuildMembers() do
                local fullName, rank, rankIndex = GetGuildRosterInfo(i)  -- Additional retvals ignored

                -- If a match is found set the rank and rankindex
                if RR_IsCharacterNameMatch(PlayerName, fullName) then
                    RollerRank[rr_rollID][MaxPlayersValue] = rank
                    RollerRankIndex[rr_rollID][MaxPlayersValue] = rankIndex
                end
            end

            -- Debugging, lists the name, guild rank, and guild rank id of the player (Rank ID starts at 0)
            RR_Debug(RollerName[rr_rollID][MaxPlayersValue] .. " " .. RollerRank[rr_rollID][MaxPlayersValue] .. " " .. RollerRankIndex[rr_rollID][MaxPlayersValue])
        end

        --Debugging values
        --[[
        RollerRoll[rr_rollID][1] = 2
        RollerRoll[rr_rollID][2] = 4
        RollerRoll[rr_rollID][3] = 5
        RollerRoll[rr_rollID][4] = 1
        RollerRoll[rr_rollID][5] = 9
        --]]
    end

    if MaxPlayersValue ~= nil then
        for i = 1, MaxPlayersValue do
            --RR_Test(i)    -- Debugging, shows the ''i'' value
            for j = 1, MaxPlayersValue - 1 do
                --RR_Test(j)    -- Debugging, shows the ''j'' value
                if RollerRoll[rr_rollID] ~= nil then
                    if RollerRoll[rr_rollID][j + 1] ~= nil then
                        if RollerRoll[rr_rollID][j + 1] > RollerRoll[rr_rollID][j] then
                            RaidRoll_Flip(rr_rollID, j)
                        end
                    end
                end
            end
        end

        if RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Enabled"] == true then
            for i = 1, MaxPlayersValue do
                --RR_Test(i)    -- Debugging, shows the ''i'' value
                for j = 1, MaxPlayersValue - 1 do
                    if RR_EPGP_PRValue[rr_rollID] ~= nil then
                        if RR_EPGP_PRValue[rr_rollID][j + 1] ~= nil then
                            if RR_EPGP_PRValue[rr_rollID][j + 1] > RR_EPGP_PRValue[rr_rollID][j] then
                                RaidRoll_Flip(rr_rollID, j)
                            end
                        end
                    end
                end
            end
        end

        if RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Enabled"] == true then
            if RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Priority"] == true then
                for i = 1, MaxPlayersValue do
                    --RR_Test(i)    -- Debugging, shows the ''i'' value
                    for j = 1, MaxPlayersValue - 1 do
                        if RR_EPGPAboveThreshold[rr_rollID] ~= nil then
                            if RR_EPGPAboveThreshold[rr_rollID][j + 1] ~= nil then
                                if RR_EPGPAboveThreshold[rr_rollID][j + 1] == true and RR_EPGPAboveThreshold[rr_rollID][j] == false then
                                    RaidRoll_Flip(rr_rollID, j)
                                end
                            end
                        end
                    end
                end
            end
        end

        if RaidRoll_DBPC[UnitName("player")]["RR_RankPriority"] == true then
            for i = 1, MaxPlayersValue do
                --RR_Test(i)    -- Debugging, shows the ''i'' value
                for j = 1, MaxPlayersValue - 1 do
                    --RR_Test(j)    -- Debugging, shows the ''j'' value
                    --RR_Test("i=" .. i .. " j=" .. " " .. j .. RollerRankIndex[rr_rollID][j+1] .. "/" .. RollerRankIndex[rr_rollID][j])
                    if RollerRankIndex[rr_rollID] ~= nil then
                        if RollerRankIndex[rr_rollID][j + 1] ~= nil then
                            if RaidRoll_DB["Rank Priority"][RollerRankIndex[rr_rollID][j + 1] + 1] > RaidRoll_DB["Rank Priority"][RollerRankIndex[rr_rollID][j] + 1] then
                                RaidRoll_Flip(rr_rollID, j)
                            end
                        end
                    end
                end
            end
        end

        if RaidRoll_DBPC[UnitName("player")]["RR_AllowExtraRolls"] == false then
            for i = 1, MaxPlayersValue do
                --RR_Test(i)    -- Debugging, shows the ''i'' value
                for j = 1, MaxPlayersValue - 1 do
                    --RR_Test(j)    -- Debugging, shows the ''j'' value
                    --RR_Test("i=" .. i .. " j=" .. j .. " " .. RollerRankIndex[rr_rollID][j+1] .. "/" .. RollerRankIndex[rr_rollID][j])
                    if RollerFirst[rr_rollID][j + 1] ~= nil then
                        if RollerFirst[rr_rollID][j + 1] == true and RollerFirst[rr_rollID][j] == false then
                            RaidRoll_Flip(rr_rollID, j)
                        end
                    end
                end
            end
        end

        if RaidRoll_DBPC[UnitName("player")]["RR_Accept_All_Rolls"] == false then
            for i = 1, MaxPlayersValue do
                --RR_Test(i)    -- Debugging, shows the ''i'' value
                for j = 1, MaxPlayersValue - 1 do
                    --RR_Test(j)    -- Debugging, shows the ''j'' value
                    --RR_Test("i=" .. i .. " j=" .. j .. " " .. RollerRankIndex[rr_rollID][j+1] .. "/" .. RollerRankIndex[rr_rollID][j])
                    if RaidRoll_LegitRoll[rr_rollID] ~= nil then
                        if RaidRoll_LegitRoll[rr_rollID][j + 1] ~= nil then
                            if RaidRoll_LegitRoll[rr_rollID][j + 1] == true and RaidRoll_LegitRoll[rr_rollID][j] == false then
                                RaidRoll_Flip(rr_rollID, j)
                            end
                        end
                    end
                end
            end
        end

        --Debugging, lists all the raid rolls
        --[[
        RR_Test("Listing Results")
        for i=1,41 do
            RR_Test(RollerName[rr_rollID][i])
            RR_Test(RollerRoll[rr_rollID][i])
        end
        --]]

        if rr_CurrentRollID == rr_rollID then
            RR_Display(rr_rollID)
        end
    end
end

function RaidRoll_Flip(rr_rollID, j)
    local temp_arr = { { {} } }

    temp_arr = RR_RollData[rr_rollID][j + 1]
    RR_RollData[rr_rollID][j + 1] = RR_RollData[rr_rollID][j]
    RR_RollData[rr_rollID][j] = temp_arr

    local temp = RollerRoll[rr_rollID][j + 1]
    RollerRoll[rr_rollID][j + 1] = RollerRoll[rr_rollID][j]
    RollerRoll[rr_rollID][j] = temp

    temp = RollerName[rr_rollID][j + 1]
    RollerName[rr_rollID][j + 1] = RollerName[rr_rollID][j]
    RollerName[rr_rollID][j] = temp

    temp = RollerRank[rr_rollID][j + 1]
    RollerRank[rr_rollID][j + 1] = RollerRank[rr_rollID][j]
    RollerRank[rr_rollID][j] = temp

    temp = RollerRankIndex[rr_rollID][j + 1]
    RollerRankIndex[rr_rollID][j + 1] = RollerRankIndex[rr_rollID][j]
    RollerRankIndex[rr_rollID][j] = temp

    temp = RollerFirst[rr_rollID][j + 1]
    RollerFirst[rr_rollID][j + 1] = RollerFirst[rr_rollID][j]
    RollerFirst[rr_rollID][j] = temp

    temp = Roll_Number[rr_rollID][j + 1]
    Roll_Number[rr_rollID][j + 1] = Roll_Number[rr_rollID][j]
    Roll_Number[rr_rollID][j] = temp

    temp = RaidRoll_LegitRoll[rr_rollID][j + 1]
    RaidRoll_LegitRoll[rr_rollID][j + 1] = RaidRoll_LegitRoll[rr_rollID][j]
    RaidRoll_LegitRoll[rr_rollID][j] = temp

    temp = RollerColor[rr_rollID][j + 1]
    RollerColor[rr_rollID][j + 1] = RollerColor[rr_rollID][j]
    RollerColor[rr_rollID][j] = temp

    temp = RR_EPGPAboveThreshold[rr_rollID][j + 1]
    RR_EPGPAboveThreshold[rr_rollID][j + 1] = RR_EPGPAboveThreshold[rr_rollID][j]
    RR_EPGPAboveThreshold[rr_rollID][j] = temp

    temp = RR_EPGP_PRValue[rr_rollID][j + 1]
    RR_EPGP_PRValue[rr_rollID][j + 1] = RR_EPGP_PRValue[rr_rollID][j]
    RR_EPGP_PRValue[rr_rollID][j] = temp
end

function RR_Update_Name_Frame(RR_DisplayID)

    -- This allows auto-reporting of 10 and 5 seconds left
    if time() < RR_Timestamp + 48 then
        if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Auto_Announce"] == true then
            if RR_RollCountdown ~= true then
                RR_RollCountdown = true
                RR_HasAnnounced_10_Sec = false
                RR_HasAnnounced_5_Sec = false
            end
        end
    end

    if rr_Item[rr_CurrentRollID] ~= "ID #" .. rr_CurrentRollID and (time() > RR_Timestamp + 59 or rr_CurrentRollID ~= rr_rollID) then
        RaidRoll_AnnounceWinnerButton:Show()
        RR_Roll_5SecAndAnnounce:SetWidth(145)
    else
        RaidRoll_AnnounceWinnerButton:Hide()
        RR_Roll_5SecAndAnnounce:SetWidth(168)
    end

    if rr_Item[rr_CurrentRollID] ~= "ID #" .. rr_CurrentRollID and (time() > RR_Timestamp + 59 or rr_CurrentRollID ~= rr_rollID) then
        local Winner = RR_FindWinner(rr_CurrentRollID)

        if Winner ~= "" then
            RR_Roll_5SecAndAnnounce:SetText(string.format(RAIDROLL_LOCALE["Award"], Winner))
        else
            if RaidRoll_DBPC[UnitName("player")]["RR_DisenchanterUnit"] ~= nil then
                if RaidRoll_DBPC[UnitName("player")]["RR_BankerUnit"] ~= nil then
                    local bank = string.sub(RaidRoll_DBPC[UnitName("player")]["RR_BankerUnit"], 1, 3)
                    local disen = string.sub(RaidRoll_DBPC[UnitName("player")]["RR_DisenchanterUnit"], 1, 3)
                    RR_Roll_5SecAndAnnounce:SetText("DE (" .. disen .. ") | Bank (" .. bank .. ")") -- bank and de assigned
                else
                    RR_Roll_5SecAndAnnounce:SetText("DE (" .. RaidRoll_DBPC[UnitName("player")]["RR_DisenchanterUnit"] .. ")") -- only de assigned
                end
            elseif RaidRoll_DBPC[UnitName("player")]["RR_BankerUnit"] ~= nil then
                RR_Roll_5SecAndAnnounce:SetText("Bank (" .. RaidRoll_DBPC[UnitName("player")]["RR_BankerUnit"] .. ")") -- only bank assigned
            else
                RR_Roll_5SecAndAnnounce:SetText(RAIDROLL_LOCALE["No_Winner"])
            end
        end
    elseif (time() > RR_Timestamp + 59 or rr_CurrentRollID ~= rr_rollID) then
        RR_Roll_5SecAndAnnounce:SetText(RAIDROLL_LOCALE["No_Item"])
    else
        if RR_Doing_a_New_Roll == true then
            RR_Roll_5SecAndAnnounce:SetText(RAIDROLL_LOCALE["Awaiting Rolls"])
        else
            if (60 - (time() - RR_Timestamp)) <= 11 or RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_No_countdown"] == true then
                RR_Roll_5SecAndAnnounce:SetText(RAIDROLL_LOCALE["Finish_Early"])
            else
                RR_Roll_5SecAndAnnounce:SetText(RAIDROLL_LOCALE["10_Sec_Announce_Winner"])
            end
        end
    end

    l_RR_DisplayID = RR_DisplayID

    -- If you clicked "new roll" then dont  decrement the timer (unless there was a roll performed)
    if RR_Doing_a_New_Roll == true then RR_Timestamp = time() + RaidRoll_DBPC[UnitName("player")]["Time_Offset"] end

    if time() < RR_Timestamp + 60 and rr_rollID == rr_CurrentRollID then
        _G["RR_Itemname"]:SetText("(" .. 60 - time() + RR_Timestamp .. ") " .. rr_Item[l_RR_DisplayID])
    else
        _G["RR_Itemname"]:SetText(rr_Item[l_RR_DisplayID])
    end

    if RR_RollCountdown == true then

        if RR_HasAnnounced_10_Sec == false and time() > RR_Timestamp + 49 then
            RR_HasAnnounced_10_Sec = true
            if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Auto_Announce"] == true or RR_AnnounceCountdowns == true then
                RR_Say(RAIDROLL_LOCALE["Rolling_Ends_in_10_Sec"])
            end
        end

        if RR_HasAnnounced_5_Sec == false and time() > RR_Timestamp + 54 then
            RR_HasAnnounced_5_Sec = true
            if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Auto_Announce"] == true or RR_AnnounceCountdowns == true then
                RR_Say(RAIDROLL_LOCALE["Rolling_Ends_in_5_Sec"])
            end
        end

        -- Announce the winner when the time runs out
        if time() > RR_Timestamp + 60 then

            if RR_RollCountdown == true then
                if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Auto_Announce"] == true or RR_AnnounceCountdowns == true then

                    local Winner, Roll, EPGP = RR_FindWinner(rr_rollID)
                    local Winner_Message

                    if Winner ~= "" then
                        if GetLocale() ~= "zhTW" and GetLocale() ~= "ruRU" and GetLocale() ~= "zhCN" then
                            Winner = string.upper(string.sub(Winner, 1, 1)) .. string.lower(string.sub(Winner, 2))
                        end

                        if RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Enabled"] == true then
                            if rr_Item[rr_rollID] == "ID #" .. rr_rollID then
                                Winner_Message = string.format(RAIDROLL_LOCALE["won_PR_value"], Winner, EPGP)
                            else
                                Winner_Message = string.format(RAIDROLL_LOCALE["won_item_PR_value"], Winner, rr_Item[rr_rollID], EPGP)
                            end
                        else
                            if rr_Item[rr_rollID] == "ID #" .. rr_rollID then
                                Winner_Message = string.format(RAIDROLL_LOCALE["won_with"], Winner, Roll)
                            else
                                Winner_Message = string.format(RAIDROLL_LOCALE["won_item_with"], Winner, rr_Item[rr_rollID], Roll)
                            end
                        end
                    else
                        Winner_Message = string.format(RAIDROLL_LOCALE["No_winner_for"], rr_Item[rr_rollID])
                    end

                    RR_Say(Winner_Message)

                    if RR_RollCheckBox_GuildAnnounce:GetChecked() then
                        if RR_RollCheckBox_GuildAnnounce_Officer:GetChecked() then
                            SendChatMessage(Winner_Message, "OFFICER")
                        else
                            SendChatMessage(Winner_Message, "GUILD")
                        end
                    end
                end

                RR_AnnounceCountdowns = false
                RR_RollCountdown = false
            end
        end
    end

    --[[
    for i=1,MaxPlayersValue-1 do
        if RollerName[rr_rollID][i]  == nil then RollerName[rr_rollID][i]  = "" end
        if RollerRoll[rr_rollID][i]  == nil then RollerRoll[rr_rollID][i]  = 0  end
        if RollerFirst[rr_rollID][i] == nil then RollerFirst[rr_rollID][i] = false end
        if RollerRank[rr_rollID][i]  == nil then RollerRank[rr_rollID][i]  = "" end
        if RollerRankIndex[rr_rollID][i]  == nil then RollerRankIndex[rr_rollID][i]  = 11 end
        if RaidRoll_LegitRoll[rr_rollID][i]  == nil then RaidRoll_LegitRoll[rr_rollID][i]  = false end
        if RollerColor[rr_rollID][i]  == nil then RollerColor[rr_rollID][i]  = ""  end
        if RR_EPGPAboveThreshold[rr_rollID][i] == nil then RR_EPGPAboveThreshold[rr_rollID][i] = false end
        if RR_EPGP_PRValue[rr_rollID][i] == nil then RR_EPGP_PRValue[rr_rollID][i] = 0 end
    end
    --]]

    --RR_width = _G["RR_Itemname"]:GetWidth()

    RR_NAME_FRAME:SetWidth(_G["RR_Itemname"]:GetWidth() + 20)

    --if RR_width + 45 > 185 then
    --  RR_RollFrame:SetWidth(RR_width+45)
    --else
    --  RR_RollFrame:SetWidth(185)
    --end

    if not _RR then
        RR_NAME_FRAME:SetScript("OnUpdate", function()
            if _RR > 0 and GetTime() >= _RR then _RR = 0 RR_Update_Name_Frame(l_RR_DisplayID) end
        end)
    end

    _RR = GetTime()
end

function RR_FindWinner(rollID)
    -- Find the highest roller/PR non-ignored person
    local Winner = ""
    local Roll = 0
    local EPGP = 0

    if MaxPlayers ~= nil then
        if MaxPlayers[rollID] ~= nil then
            for i = 1, MaxPlayers[rollID] do
                local j = MaxPlayers[rollID] - i + 1
                local Name_low = string.lower(RollerName[rollID][j])
                --RR_Debug(j .. ": " .. Name_low)

                if (RaidRoll_LegitRoll[rollID][j] == false and RaidRoll_DBPC[UnitName("player")]["RR_Accept_All_Rolls"] == false)
                    or (RaidRoll_DBPC[UnitName("player")]["RR_AllowExtraRolls"] == false and RollerFirst[rollID][j] == false)
                    or RR_IgnoredList[rollID][Name_low] == true
                then
                    --RR_Debug(Name_low .. " ignored. Moving on")
                else
                    Winner = Name_low
                    EPGP = RR_EPGP_PRValue[rollID][j]
                    Roll = RollerRoll[rollID][j]

                    --if RaidRoll_DB["debug"] == true then
                    --  RR_Test("Setting winner to: "..Name_low)
                    --  RR_Test("EPGP Value: " .. EPGP)
                    --  RR_Test("Roll Value: " .. Roll)
                    --end
                end
            end
        end
    end

    if RaidRoll_DB["debug3"] == true then
        RR_Test("--- RR_FindWinner Debug Messages: ---")
        RR_Test("1.." .. RollerName[rollID][1])
        RR_Test("2.." .. string.lower(RollerName[rollID][1]))
        RR_Test("3.." .. string.upper(RollerName[rollID][1]))
        RR_Test("4.." .. Winner)
        RR_Test("5.." .. " " .. Winner)
        RR_Test("--- --- ---")
    end

    --if GetLocale() == "ruRU" then
    --  return " " .. Winner,Roll,EPGP  -- #2
    --else
    return Winner, Roll, EPGP -- #4
    --end
end

function RR_Display(RR_DisplayID)

    RR_HasDisplayedAlready = true

    l_RR_DisplayID = RR_DisplayID

    if RollerGroup[l_RR_DisplayID] == nil then RollerGroup[l_RR_DisplayID] = {} end

    --- If the current roll is the latest rol it shows a 60 second countdown
    if time() < RR_Timestamp + 60 and rr_rollID == rr_CurrentRollID then
        _G["RR_Itemname"]:SetText("(" .. 60 - time() + RR_Timestamp .. ") " .. rr_Item[l_RR_DisplayID])
        RR_Update_Name_Frame(l_RR_DisplayID)
    else
        _G["RR_Itemname"]:SetText(rr_Item[l_RR_DisplayID])
    end

    if RollerFirst[RR_DisplayID] ~= nil and RollerFirst[RR_DisplayID][1] ~= nil then
        for i = 1, 5 do

            --To make sure these are not nil values
            local mark = ""
            local color = ""

            _G["RR_RollerPos" .. i]:SetText(i + RR_ScrollOffset .. ":")

            if RollerFirst[RR_DisplayID][i + RR_ScrollOffset] == false then
                color = "|cFF11aacc"
            else
                color = "|cFFFF0000|r"
            end

            if RaidRoll_DBPC[UnitName("player")] == nil then RaidRoll_DBPC[UnitName("player")] = {} end
            if RaidRoll_DBPC[UnitName("player")]["RR_NameMark"] == nil then RaidRoll_DBPC[UnitName("player")]["RR_NameMark"] = {} end
            if RaidRoll_DBPC[UnitName("player")]["RR_NameMark"][strlower(RollerName[RR_DisplayID][i + RR_ScrollOffset])] == nil then
                RaidRoll_DBPC[UnitName("player")]["RR_NameMark"][strlower(RollerName[RR_DisplayID][i + RR_ScrollOffset])] = {}
            end

            -- Checks to see if the roll should be shown
            -- RaidRoll_DBPC[UnitName("player")]["RR_Accept_All_Rolls"]
            -- RaidRoll_LegitRoll

            if (RaidRoll_LegitRoll[RR_DisplayID][i + RR_ScrollOffset] == false and RaidRoll_DBPC[UnitName("player")]["RR_Accept_All_Rolls"] == false)
                or (RaidRoll_DBPC[UnitName("player")]["RR_AllowExtraRolls"] == false and RollerFirst[RR_DisplayID][i + RR_ScrollOffset] == false)
            then
                _G["RR_Roller" .. i]:SetText("")
                _G["RR_RollerRank" .. i]:SetText("")
                _G["RR_RollerPR" .. i]:SetText("")
                _G["RR_Rolled" .. i]:SetText("")
                _G["RR_Group" .. i]:SetText("")
            else
                local Name_low = string.lower(RollerName[RR_DisplayID][i + RR_ScrollOffset])

                if RR_IgnoredList == nil then RR_IgnoredList = {} end
                if RR_IgnoredList[RR_DisplayID] == nil then RR_IgnoredList[RR_DisplayID] = {} end


                if RR_IgnoredList[RR_DisplayID][Name_low] == true then
                    if (GetLocale() ~= "zhTW" and GetLocale() ~= "ruRU") then
                        _G["RR_Roller" .. i]:SetFont("Fonts\\FRIZQT__.TTF", 12, "THICKOUTLINE")
                    end
                    if (GetLocale() == "zhCN") then
                        _G["RR_Roller" .. i]:SetFont("Fonts\\ZYKai_T.TTF", 12, "THICKOUTLINE")
                    end
                else
                    if (GetLocale() ~= "zhTW" and GetLocale() ~= "ruRU") then
                        _G["RR_Roller" .. i]:SetFont("Fonts\\FRIZQT__.TTF", 12)
                    end
                    if (GetLocale() == "zhCN") then
                        _G["RR_Roller" .. i]:SetFont("Fonts\\ZYKai_T.TTF", 12)
                    end
                end

                if RollerName[RR_DisplayID][i + RR_ScrollOffset] then
                    local rollerName = strlower(RollerName[RR_DisplayID][i + RR_ScrollOffset])
                    if RaidRoll_DBPC[UnitName("player")]["RR_NameMark"][rollerName] == nil then
                        RaidRoll_DBPC[UnitName("player")]["RR_NameMark"][rollerName] = false
                    end

                    if RaidRoll_DBPC[UnitName("player")]["RR_NameMark"][rollerName] == true then
                        if RaidRoll_DBPC[UnitName("player")]["RR_PlayerIcon"] ~= nil then
                            if RaidRoll_DBPC[UnitName("player")]["RR_PlayerIcon"][rollerName] ~= nil then
                                mark = RaidRoll_DBPC[UnitName("player")]["RR_PlayerIcon"][rollerName]
                            end
                        end
                    else
                        mark = ""
                    end
                end

                if RollerColor[RR_DisplayID][i + RR_ScrollOffset] ~= nil and RollerColor[RR_DisplayID][i + RR_ScrollOffset] ~= "" then
                    _G["RR_Roller" .. i]:SetText(color .. mark .. RollerColor[RR_DisplayID][i + RR_ScrollOffset] .. RollerName[RR_DisplayID][i + RR_ScrollOffset] .. "|r")
                else
                    _G["RR_Roller" .. i]:SetText(color .. mark .. RollerName[RR_DisplayID][i + RR_ScrollOffset])
                end

                if RollerRoll[RR_DisplayID][i + RR_ScrollOffset] == 0 then
                    _G["RR_RollerPR" .. i]:SetText("")
                    _G["RR_Rolled" .. i]:SetText("")
                else
                    -- If EPGP enabled, show roller's PR
                    if RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Enabled"] == true then
                        if RR_EPGPAboveThreshold[RR_DisplayID][i + RR_ScrollOffset] ~= true then
                            _G["RR_RollerPR" .. i]:SetText("|cFFC41F3B" .. RR_EPGP_PRValue[RR_DisplayID][i + RR_ScrollOffset]) -- not above threshold (red)
                        else
                            _G["RR_RollerPR" .. i]:SetText("|cFFABD473" .. RR_EPGP_PRValue[RR_DisplayID][i + RR_ScrollOffset]) -- above threshold (green)
                        end
                    end

                    -- Show roller's roll
                    local ExtraChar
                    if RaidRoll_LegitRoll[RR_DisplayID][i + RR_ScrollOffset] == true then
                        ExtraChar = ""
                    else
                        ExtraChar = "*"
                    end

                    if RollerFirst[RR_DisplayID][i + RR_ScrollOffset] == true then
                        _G["RR_Rolled" .. i]:SetText(color .. RollerRoll[RR_DisplayID][i + RR_ScrollOffset] .. ExtraChar)
                    else
                        _G["RR_Rolled" .. i]:SetText(color .. "(" .. Roll_Number[RR_DisplayID][i + RR_ScrollOffset] .. ") "
                            .. RollerRoll[RR_DisplayID][i + RR_ScrollOffset] .. ExtraChar)
                    end
                end

                -- Show roller's guild rank
                if RollerRankIndex[RR_DisplayID][i + RR_ScrollOffset] == 99 then
                    _G["RR_RollerRank" .. i]:SetText("")
                else
                    _G["RR_RollerRank" .. i]:SetText(color .. "(" .. RollerRankIndex[RR_DisplayID][i + RR_ScrollOffset] .. ") "
                        .. RollerRank[RR_DisplayID][i + RR_ScrollOffset])
                end

                -- Show roller's group (if any)
                if IsInRaid() then
                    for j = 1, 40 do
                        local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(j)
                        if RR_IsCharacterNameMatch(name, RollerName[RR_DisplayID][i + RR_ScrollOffset]) then
                            --RR_Test(i .. " " .. RollerName[RR_DisplayID][i+RR_ScrollOffset] .. " - " .. name)
                            RollerGroup[RR_DisplayID][i + RR_ScrollOffset] = subgroup
                        end
                    end
                elseif IsInGroup() then
                    RollerGroup[RR_DisplayID][i + RR_ScrollOffset] = 1
                else
                    RollerGroup[RR_DisplayID][i + RR_ScrollOffset] = "-"
                end

                if RollerGroup[RR_DisplayID][i + RR_ScrollOffset] == nil then RollerGroup[RR_DisplayID][i + RR_ScrollOffset] = "" end
                _G["RR_Group" .. i]:SetText(color .. RollerGroup[RR_DisplayID][i + RR_ScrollOffset])
            end
        end
    end

    -- This controls the showing of the window (true = show window, false = dont show window)
    if RaidRoll_DBPC[UnitName("player")]["RR_Roll_Tracking_Enabled"] == true then
        RR_RollFrame:Show()
        RR_NAME_FRAME:Show()
    end

    if rr_rollID ~= 0 then
        if rr_CurrentRollID < rr_rollID then
            RR_Next:Enable()
        else
            RR_Next:Disable()
        end

        if rr_CurrentRollID > 0 then
            RR_Last:Enable()
        else
            RR_Last:Disable()
        end
    else
        RR_Last:Disable()
        RR_Next:Disable()
    end
end

function RRL_Command(cmd)
    --Stuff that happens when you press /mm <command>

    RR_ItemLink = nil --clearing the variable

    local cmd_s = string.lower(cmd)

    if cmd_s == "options" or cmd_s == "option" or cmd_s == "config" then
        RR_OptionsScreenToggle()
        return
    end

    if cmd_s == "zone" then
        local RR_ZoneInfo = {}
        local RR_NamesList = {}
        local RR_NameAmount = 0

        for i = 1, 40 do
            local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
            if name ~= nil then
                --RR_Test("Name: " .. name .. " - Location: " .. zone)
                RR_NameAmount = RR_NameAmount + 1
                RR_NamesList[RR_NameAmount] = name
                RR_ZoneInfo[name] = {}
                RR_ZoneInfo[name]["Zone"] = zone
            end
        end

        for i = 1, 40 do
            local name, realm = UnitName("raid" .. i)
            local inRange = CheckInteractDistance("raid" .. i, 1)
            if name ~= nil then
                if inRange == nil then inRange = 0 end
                --RR_Test("Name: " .. name .. " - InRange: " .. inRange)
                RR_ZoneInfo[name]["InRange"] = inRange
            end
        end

        if RR_NameAmount > 0 then
            local RR_DifferentZone = ""
            local RR_OutOfRange = ""

            for i = 1, RR_NameAmount do
                local name = RR_NamesList[i]

                if RR_ZoneInfo[name]["InRange"] ~= RR_ZoneInfo[UnitName("player")]["InRange"] then
                    if RR_ZoneInfo[name]["Zone"] ~= RR_ZoneInfo[UnitName("player")]["Zone"] then
                        -- Different Zone
                        if RR_DifferentZone == "" then
                            RR_DifferentZone = name
                        else
                            RR_DifferentZone = RR_DifferentZone .. ", " .. name
                        end
                    else
                        -- Same Zone > 28yd away
                        if RR_OutOfRange == "" then
                            RR_OutOfRange = name
                        else
                            RR_OutOfRange = RR_OutOfRange .. ", " .. name
                        end
                    end
                end
            end

            if RR_DifferentZone ~= "" then
                RR_Say(RAIDROLL_LOCALE["Players_in_another_zone"] .. RR_DifferentZone)
            end

            if RR_OutOfRange ~= "" then
                RR_Say(RAIDROLL_LOCALE["Players_28_yd_from_me"] .. RR_OutOfRange)
            end

            if RR_DifferentZone == "" and RR_OutOfRange == "" then
                RR_Say(RAIDROLL_LOCALE["Everyone_is_here"] .. " /cheer")
            end
        end
        return
    end

    if cmd_s == "loot" then
        if RR_LOOT_FRAME:IsShown() then
            RR_LOOT_FRAME:Hide()
        else
            RR_LOOT_FRAME:Show()
        end
        return
    end

    if cmd_s == "debug" then
        if RaidRoll_DB["debug"] == nil then
            RaidRoll_DB["debug"] = true
        elseif RaidRoll_DB["debug"] == false then
            RaidRoll_DB["debug"] = true
        elseif RaidRoll_DB["debug"] == true then
            RaidRoll_DB["debug"] = false
        end

        if RaidRoll_DB["debug"] == true then
            RR_Test("Raid Roll - Debug Mode Enabled")
        end

        if RaidRoll_DB["debug"] == false then
            RR_Test("Raid Roll - Debug Mode Disabled")
        end
        return
    end

    if cmd_s == "debug2" then
        if RaidRoll_DB["debug2"] == nil then
            RaidRoll_DB["debug2"] = true
        elseif RaidRoll_DB["debug2"] == false then
            RaidRoll_DB["debug2"] = true
        elseif RaidRoll_DB["debug2"] == true then
            RaidRoll_DB["debug2"] = false
        end

        if RaidRoll_DB["debug2"] == true then
            RR_Test("Raid Roll - Debug2 Mode Enabled")
        end

        if RaidRoll_DB["debug2"] == false then
            RR_Test("Raid Roll - Debug2 Mode Disabled")
        end
        return
    end

    if cmd_s == "help" then
        for i = 1, 20 do
            if RAIDROLL_LOCALE["HELP" .. i] then
                RR_Test(RAIDROLL_LOCALE["HELP" .. i])
            end
        end
        return
    end

    if cmd_s == "epgp" then
        if RR_RollCheckBox_EPGPMode_panel:GetChecked() then
            RR_RollCheckBox_EPGPMode_panel:SetChecked(false)
            RR_Test("EPGP Mode - |cFFC41F3BDISABLED")
        else
            RR_RollCheckBox_EPGPMode_panel:SetChecked(true)
            RR_Test("EPGP Mode - |cFFABD473ENABLED")
        end
        RaidRoll_CheckButton_Update_Panel()
        RR_Display(rr_CurrentRollID)
        return
    end

    -- reset the position of the rolling frame
    if cmd_s == "reset" or cmd_s == "resetpos" then
        _G["RR_RollFrame"]:ClearAllPoints()
        _G["RR_RollFrame"]:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        RR_Display(rr_CurrentRollID)
        return
    end

    if cmd_s == "show" then
        RR_RollFrame:Show()
        RR_NAME_FRAME:Show()
        return
    end

    if cmd_s == "toggle" then
        if RR_RollFrame:IsShown() then
            RR_RollFrame:Hide()
            RR_NAME_FRAME:Hide()
        else
            RR_RollFrame:Show()
            RR_NAME_FRAME:Show()
        end
        return
    end

    if cmd_s == "unan" or cmd_s == "unannounced" then
        if RaidRoll_DBPC[UnitName("player")]["RR_Track_Unannounced_Rolls"] == true then
            RaidRoll_DBPC[UnitName("player")]["RR_Track_Unannounced_Rolls"] = false
            RR_Test("Raid Roll: Auto-Tracking Rolls Disabled")
            RaidRoll_Catch_All:SetChecked(false)
        else
            RaidRoll_DBPC[UnitName("player")]["RR_Track_Unannounced_Rolls"] = true
            RR_Test("Raid Roll: Auto-Tracking Rolls Enabled")
            RaidRoll_Catch_All:SetChecked(true)
        end
        return
    end

    -- This controls the showing of the window (true = show window, false = dont show window)
    if cmd_s == "enable" then
        RaidRoll_DBPC[UnitName("player")]["RR_Roll_Tracking_Enabled"] = true
        RR_Test("Raid Roll: Raid Roll Tracking enabled. Type ''/rr disable'' to disable tracking")
        return
    end

    if cmd_s == "disable" then
        RaidRoll_DBPC[UnitName("player")]["RR_Roll_Tracking_Enabled"] = false
        RR_Test("Raid Roll: Raid Roll Tracking disabled. Type ''/rr enable'' to enable tracking")
        return
    end

    if cmd_s == "all" then
        if RaidRoll_DBPC[UnitName("player")]["RR_Accept_All_Rolls"] == true then
            RaidRoll_DBPC[UnitName("player")]["RR_Accept_All_Rolls"] = false
            RR_Test("Raid Roll: Only 1-100 rolls accepted")
            RaidRoll_Allow_All:SetChecked(false)
        else
            RaidRoll_DBPC[UnitName("player")]["RR_Accept_All_Rolls"] = true
            RR_Test("Raid Roll: All rolls accepted")
            RaidRoll_Allow_All:SetChecked(true)
        end
        return
    end

    local cmd1, cmd2, cmd3 = strsplit(" ", cmd_s, 3)

    if cmd1 == "assign" then
        RR_Debug("Assigning")
        if cmd2 == "bank" then
            local Banker = ""
            RR_Debug("Bank")
            if cmd3 == nil then
                Banker = GetUnitName("target")
                if Banker == nil then
                    RR_Debug("Banker Value = Nil")
                else
                    RR_Debug("To Target (" .. Banker .. ")")
                end
            else
                Banker = cmd3
                RR_Debug("To " .. cmd3)
            end
            if Banker ~= nil then
                RR_Say("Banker Assigned to: " .. Banker)
            else
                RR_Say("Banker Unassigned")
            end

            RaidRoll_DBPC[UnitName("player")]["RR_BankerUnit"] = Banker
        elseif cmd2 == "de" then
            local Disenchanter = ""
            RR_Debug("Disenchanter")
            if cmd3 == nil then
                Disenchanter = GetUnitName("target")
                if Disenchanter == nil then
                    RR_Debug("Disenchanter Value = Nil")
                else
                    RR_Debug("To Target (" .. Disenchanter .. ")")
                end
            else
                Disenchanter = cmd3
                RR_Debug("To " .. cmd3)
            end
            if Disenchanter ~= nil then
                RR_Say("Disenchanter Assigned to: " .. Disenchanter)
            else
                RR_Say("Disenchanter Unassigned")
            end

            RaidRoll_DBPC[UnitName("player")]["RR_DisenchanterUnit"] = Disenchanter
        end
        return
    end

    if cmd1 == "mark" then
        --RR_Debug("mark " .. tostring(cmd2))
        if cmd2 ~= nil and cmd2 ~= "!reset" then

            if RaidRoll_DBPC[UnitName("player")]["RR_NameMark"] == nil then
                RaidRoll_DBPC[UnitName("player")]["RR_NameMark"] = {}
            end

            local name
            if tonumber(cmd2) == nil then
                -- Mark by name
                name = cmd2
                if RaidRoll_DBPC[UnitName("player")]["RR_NameMark"][name] == true then
                    RaidRoll_DBPC[UnitName("player")]["RR_NameMark"][name] = false
                    RR_Test(name .. " " .. RAIDROLL_LOCALE["removed_from_marking_list"])
                else
                    RaidRoll_DBPC[UnitName("player")]["RR_NameMark"][name] = true
                    RR_Test(name .. " " .. RAIDROLL_LOCALE["added_to_marking_list"])
                end
            elseif RollerName[rr_CurrentRollID][tonumber(cmd2)] ~= nil then
                -- Mark by roller number
                name = strlower(RollerName[rr_CurrentRollID][tonumber(cmd2)])
                if name ~= nil and name ~= "" then
                    RaidRoll_DBPC[UnitName("player")]["RR_NameMark"][name] = true

                    if RaidRoll_DBPC[UnitName("player")]["RR_PlayerIconID"] == nil then
                        RaidRoll_DBPC[UnitName("player")]["RR_PlayerIconID"] = {}
                    end
                    if RaidRoll_DBPC[UnitName("player")]["RR_PlayerIcon"] == nil then
                        RaidRoll_DBPC[UnitName("player")]["RR_PlayerIcon"] = {}
                    end

                    local currentIconId = RaidRoll_DBPC[UnitName("player")]["RR_PlayerIconID"][name]
                    if currentIconId == nil or currentIconId >= RR_NumberOfIcons then
                        RaidRoll_DBPC[UnitName("player")]["RR_PlayerIconID"][name] = 1
                    else
                        RaidRoll_DBPC[UnitName("player")]["RR_PlayerIconID"][name] = currentIconId + 1
                    end

                    RaidRoll_DBPC[UnitName("player")]["RR_PlayerIcon"][name] = RR_ListOfIcons[RaidRoll_DBPC[UnitName("player")]["RR_PlayerIconID"][name]]

                    RR_Test(name .. " " .. RAIDROLL_LOCALE["added_to_marking_list"])
                end
            else
                RR_Test("Nobody was " .. RAIDROLL_LOCALE["added_to_marking_list"])
            end
        elseif cmd2 == "!reset" then
            RaidRoll_DBPC[UnitName("player")]["RR_NameMark"] = {}
            RaidRoll_DBPC[UnitName("player")]["RR_PlayerIconID"] = {}
            RaidRoll_DBPC[UnitName("player")]["RR_PlayerIcon"] = {}
            RR_Test(RAIDROLL_LOCALE["Marking_list_cleared"])
        end

        -- If shown, update roll tracking frame to reflect the new marks
        if RR_RollFrame:IsShown() then
            RR_Display(rr_CurrentRollID)
        end

        return
    end

    if cmd1 == "unmark" then
        if cmd2 ~= nil and cmd2 ~= "!reset" then
            local name
            if tonumber(cmd2) == nil then
                name = cmd2
            else
                name = strlower(RollerName[rr_CurrentRollID][tonumber(cmd2)])
            end
            RaidRoll_DBPC[UnitName("player")]["RR_NameMark"][name] = false
            RR_Test(name .. " " .. RAIDROLL_LOCALE["removed_from_marking_list"])
        end

        -- If shown, update roll tracking frame to reflect the new marks
        if RR_RollFrame:IsShown() then
            RR_Display(rr_CurrentRollID)
        end

        return
    end

    if RR_RollFrame:IsShown() then
        RR_Display(rr_CurrentRollID)
    end

    -- Get any item link from the command
    local firstItemLink = string.match(cmd, "([|]%S%S-item:..-[|]h[|]r)")
    if firstItemLink ~= nil then
        RR_ItemLink = firstItemLink
    end

    --Do a repeat Raid roll
    if cmd1 == "re" or cmd1 == "reroll" then
        if RR_ItemLink ~= nil then
            if IsInRaid() then
                RR_Debug("Doing a raid reroll for " .. RR_ItemLink)
                RR_DoARaidRoll(RR_ItemLink, "ReRoll")
            else
                RR_Debug("Doing a party reroll for " .. RR_ItemLink)
                RR_DoAPartyRoll(RR_ItemLink, "ReRoll")
            end
        else
            if IsInRaid() then
                RR_Debug("Doing a raid reroll without an item")
                RR_DoARaidRoll(nil, "ReRoll")
            else
                RR_Debug("Doing a party reroll without an item")
                RR_DoAPartyRoll(nil, "ReRoll")
            end
        end
        return
    end

    --Do a Raid roll if empty command or first argument is an item link
    if cmd == "" or (firstItemLink ~= nil and string.find(cmd, firstItemLink, 1, true) == 1) then
        --Do a Raid roll and show the item being rolled for
        if RR_ItemLink ~= nil then
            if IsInRaid() then
                RR_Debug("Doing a raid roll for " .. RR_ItemLink)
                RR_DoARaidRoll(RR_ItemLink)
            else
                RR_Debug("Doing a party roll for " .. RR_ItemLink)
                RR_DoAPartyRoll(RR_ItemLink)
            end
        else
            if IsInRaid() then
                RR_Debug("Doing a raid roll without an item")
                RR_DoARaidRoll(nil)
            else
                RR_Debug("Doing a party roll without an item")
                RR_DoAPartyRoll(nil)
            end
        end
        return
    end

    -- Unknown command
    RR_Error("Unknown command. Use /rr help for help.")
end

function RR_Ignore(ID)
    local Name = string.lower(RollerName[rr_CurrentRollID][tonumber(ID)])

    RR_Debug("ID # " .. ID)

    if Name ~= nil and Name ~= "" then
        if RR_IgnoredList == nil then RR_IgnoredList = {} end
        if RR_IgnoredList[rr_CurrentRollID] == nil then RR_IgnoredList[rr_CurrentRollID] = {} end

        if RR_IgnoredList[rr_CurrentRollID][Name] == true then
            RR_IgnoredList[rr_CurrentRollID][Name] = false
            RR_Test(">> " .. Name .. " NOT ignored for " .. rr_Item[rr_CurrentRollID])
        else
            RR_IgnoredList[rr_CurrentRollID][Name] = true
            RR_Test(">> " .. Name .. " ignored for " .. rr_Item[rr_CurrentRollID])
        end
    end

    RR_Display(rr_CurrentRollID)
end

function RR_DoARaidRoll(ItemLink, Type)

    -- Set the number to the amout of people in the raid
    RR_num = GetNumGroupMembers()
    local num = RR_num

    -- Clear the list of people in the raid
    if RR_Name_Array == nil then
        RR_Name_Array = {}
    end

    -- If the array is empty then we are not doing a reroll
    if RR_Name_Array[1] == nil then
        RR_Debug("Name array empty, we are not rerolling")
        Type = nil
    end

    -- Output the list of people to raid chat if its not a reroll
    if Type ~= "ReRoll" then

        -- Check if there is an item being rolled on
        if ItemLink == nil then
            RR_Shout(RAIDROLL_LOCALE["Raid_Rolling"] .. " " .. RAIDROLL_LOCALE["ID_Name"])
        else
            RR_Shout("<<" .. RAIDROLL_LOCALE["Raid_Rolling_for"] .. ItemLink .. " >> " .. RAIDROLL_LOCALE["ID_Name"])
        end

        -- Add the members of the raid to the name array
        for i = 1, GetNumGroupMembers() do
            RR_Name_Array[i] = GetRaidRosterInfo(i)
        end

        local i_mod
        if num < 21 then
            num = num + 1
            for i = 1, num / 2 do
                i_mod = 2 * i
                --RR_Test(i_mod .. num)
                if GetRaidRosterInfo(i_mod) ~= nil and i_mod <= num - 1 then
                    RR_Say("#" .. i_mod - 1 .. " - " .. GetRaidRosterInfo(i_mod - 1) .. "" .. "    #" .. i_mod .. " - " .. GetRaidRosterInfo(i_mod))
                else
                    RR_Say("#" .. i_mod - 1 .. " - " .. GetRaidRosterInfo(i_mod - 1))
                end
                --RR_Test("#".. i .." - " .. GetRaidRosterInfo(i))
                --RR_Test(num)
            end
        else
            num = num + 2
            for i = 1, num / 3 do
                i_mod = 3 * i
                --RR_Test(i_mod .. num)
                if GetRaidRosterInfo(i_mod) ~= nil and i_mod <= num - 2 then
                    RR_Say("#" .. i_mod - 2 .. " - " .. GetRaidRosterInfo(i_mod - 2) .. "    #" .. i_mod - 1 .. " - " .. GetRaidRosterInfo(i_mod - 1)
                        .. "    #" .. i_mod .. " - " .. GetRaidRosterInfo(i_mod))
                elseif GetRaidRosterInfo(i_mod - 1) ~= nil and i_mod <= num - 1 then
                    RR_Say("#" .. i_mod - 2 .. " - " .. GetRaidRosterInfo(i_mod - 2) .. "" .. "    #" .. i_mod - 1 .. " - " .. GetRaidRosterInfo(i_mod - 1))
                else
                    RR_Say("#" .. i_mod - 2 .. " - " .. GetRaidRosterInfo(i_mod - 2))
                end
                --RR_Test("#".. i .." - " .. GetRaidRosterInfo(i))
                --RR_Test(num)
            end
        end
    else
        -- Check if there is an item being rolled on
        if ItemLink == nil then
            RR_Shout(RAIDROLL_LOCALE["Re_Rolling"])
        else
            RR_Shout("<<" .. RAIDROLL_LOCALE["Re_Rolling_for"] .. ItemLink .. " >>")
        end
    end

    -- After 2 seconds do a roll
    Raid_Roll_AutoUpdate_Time = GetTime() + 2
    Raid_Roll_AutoUpdate:SetScript("OnUpdate", function()
        if GetTime() >= Raid_Roll_AutoUpdate_Time then
            Raid_Roll_AutoUpdate_Time = 0
            Raid_Roll_AutoUpdate:SetScript("OnUpdate", function() end)
            RR_Roll()
        end
    end)
end

function RR_DoAPartyRoll(ItemLink, Type)

    -- Set the number to the amout of people in the party (it ranges from 2-5)
    RR_num = GetNumGroupMembers()
    if RR_num == nil or RR_num == 0 then
        RR_num = 1  -- If you are not in a group, set the limit to 1 for testing alone
    end
    local num = RR_num

    -- Clear the list of people in the raid
    if RR_Name_Array == nil then
        RR_Name_Array = {}
    end

    -- If the array is empty then we are not doing a reroll
    if RR_Name_Array[1] == nil then
        RR_Debug("Name array empty, we are not rerolling")
        Type = nil
    end

    -- Output the list of people to raid chat if its not a reroll
    if Type ~= "ReRoll" then

        -- Check if there is an item being rolled on
        if ItemLink == nil then
            RR_Shout(RAIDROLL_LOCALE["Raid_Rolling"] .. " " .. RAIDROLL_LOCALE["ID_Name"])
        else
            RR_Shout("<<" .. RAIDROLL_LOCALE["Raid_Rolling_for"] .. ItemLink .. " >> " .. RAIDROLL_LOCALE["ID_Name"])
        end

        -- Add the members of the raid to the name array
        for i = 1, RR_num do
            if i == 1 then
                RR_Name_Array[i] = UnitName("player")
            else
                RR_Name_Array[i] = UnitName("party" .. i - 1)
            end
        end

        num = num + 1
        for i = 1, num / 2 do
            local i_mod = 2 * i
            --RR_Test(i_mod .. ", " .. num)
            if RR_Name_Array[i_mod] ~= nil and i_mod <= num - 1 then
                RR_Say("#" .. i_mod - 1 .. " - " .. RR_Name_Array[i_mod - 1] .. "    #" .. i_mod .. " - " .. RR_Name_Array[i_mod])
            elseif RR_Name_Array[i_mod - 1] ~= nil then
                RR_Say("#" .. i_mod - 1 .. " - " .. RR_Name_Array[i_mod - 1])
            end
        end
    else
        -- Check if there is an item being rolled on
        if ItemLink == nil then
            RR_Shout(RAIDROLL_LOCALE["Re_Rolling"])
        else
            RR_Shout("<<" .. RAIDROLL_LOCALE["Re_Rolling_for"] .. ItemLink .. " >>")
        end
    end

    -- After 2 seconds do a roll
    Raid_Roll_AutoUpdate_Time = GetTime() + 2
    Raid_Roll_AutoUpdate:SetScript("OnUpdate", function()
        if GetTime() >= Raid_Roll_AutoUpdate_Time then
            Raid_Roll_AutoUpdate_Time = 0
            Raid_Roll_AutoUpdate:SetScript("OnUpdate", function() end)
            RR_Roll()
        end
    end)
end

function RR_Roll()
    RandomRoll(1, RR_num)
    RR_Has_Rolled = true
end

function RR_CloseWindow()
    RR_RollFrame:Hide()
    RR_NAME_FRAME:Hide()
end

function RR_PrevRoll()

    RR_ScrollOffset = 0

    if rr_CurrentRollID > 0 then
        rr_CurrentRollID = rr_CurrentRollID - 1
        RR_Display(rr_CurrentRollID)
    end

    if rr_CurrentRollID == 0 then
        RR_Last:Disable()
        RR_Next:Enable()
    else
        RR_Last:Enable()
        RR_Next:Enable()
    end

    rr_RollSort(rr_CurrentRollID)
    RR_Display(rr_CurrentRollID)
end

function RR_NewRoll()

    RR_RollFrame:SetHeight(155)
    RR_ScrollOffset = 0

    RR_Timestamp = time() + RaidRoll_DBPC[UnitName("player")]["Time_Offset"]
    --RR_Test("Timestamp set to :" .. RR_Timestamp) --Debugging, displays the timestamp

    RR_Doing_a_New_Roll = true

    if RollerName[rr_rollID][1] ~= "" or rr_Item[rr_rollID] ~= "ID #" .. rr_rollID then
        rr_rollID = rr_rollID + 1

        rr_Item[rr_rollID] = "ID #" .. rr_rollID


        if rr_CurrentRollID + 1 == rr_rollID then
            rr_CurrentRollID = rr_rollID
            RR_Last:Enable()
        end

        rr_RollSort(rr_rollID, 0, "", true)
    end

    rr_RollSort(rr_CurrentRollID)
    RR_Display(rr_CurrentRollID)
end

function RR_NextRoll()

    RR_ScrollOffset = 0

    if rr_CurrentRollID < rr_rollID then
        rr_CurrentRollID = rr_CurrentRollID + 1
        RR_Display(rr_CurrentRollID)
    end

    if rr_CurrentRollID == rr_rollID then
        RR_Next:Disable()
        RR_Last:Enable()
    else
        RR_Next:Enable()
        RR_Last:Enable()
    end

    rr_RollSort(rr_CurrentRollID)
    RR_Display(rr_CurrentRollID)
end

function RaidRoll_CheckButton_Update()

    --RaidRoll_Allow_All:SetChecked(true)
    if RaidRoll_Catch_All:GetChecked() then
        RaidRoll_DBPC[UnitName("player")]["RR_Track_Unannounced_Rolls"] = true
        RaidRoll_Catch_All:SetChecked(true)
        RR_RollCheckBox_Unannounced_panel:SetChecked(true)
        --RR_Test("Raid Roll: Auto-Tracking Rolls Enabled")
    else
        RaidRoll_DBPC[UnitName("player")]["RR_Track_Unannounced_Rolls"] = false
        RaidRoll_Catch_All:SetChecked(false)
        RR_RollCheckBox_Unannounced_panel:SetChecked(false)
        --RR_Test("Raid Roll: Auto-Tracking Rolls Disabled")
    end

    if RaidRoll_Allow_All:GetChecked() then
        RaidRoll_DBPC[UnitName("player")]["RR_Accept_All_Rolls"] = true
        RaidRoll_Allow_All:SetChecked(true)
        RR_RollCheckBox_AllRolls_panel:SetChecked(true)
        --RR_Test("Raid Roll: All rolls accepted")
    else
        RaidRoll_DBPC[UnitName("player")]["RR_Accept_All_Rolls"] = false
        RaidRoll_Allow_All:SetChecked(false)
        RR_RollCheckBox_AllRolls_panel:SetChecked(false)
        --RR_Test("Raid Roll: Only 1-100 rolls accepted")
    end

    if RR_RollCheckBox_ExtraRolls:GetChecked() then
        RaidRoll_DBPC[UnitName("player")]["RR_AllowExtraRolls"] = true
        RR_RollCheckBox_ExtraRolls:SetChecked(true)
        RR_RollCheckBox_ExtraRolls_panel:SetChecked(true)
        --RR_Test("Raid Roll: All rolls accepted")
    else
        RaidRoll_DBPC[UnitName("player")]["RR_AllowExtraRolls"] = false
        RR_RollCheckBox_ExtraRolls:SetChecked(false)
        RR_RollCheckBox_ExtraRolls_panel:SetChecked(false)
        --RR_Test("Raid Roll: Only 1-100 rolls accepted")
    end

    if RR_RollCheckBox_RankPrio_panel:GetChecked() then
        RaidRoll_DBPC[UnitName("player")]["RR_RankPriority"] = true
        --RR_RollCheckBox_RankPrio:SetChecked(true)
        RR_RollCheckBox_RankPrio_panel:SetChecked(true)
        --RR_Test("Raid Roll: All rolls accepted")
    else
        RaidRoll_DBPC[UnitName("player")]["RR_RankPriority"] = false
        --RR_RollCheckBox_RankPrio:SetChecked(false)
        RR_RollCheckBox_RankPrio_panel:SetChecked(false)
        --RR_Test("Raid Roll: Only 1-100 rolls accepted")
    end

    rr_RollSort(rr_CurrentRollID)

    if RR_HasDisplayedAlready ~= nil then
        RR_Display(rr_CurrentRollID)
    end

    RaidRoll_CheckButton_Update_Panel()
end

function Set_RaidRoll_ExtraWidth(width)
    RaidRoll_DBPC[UnitName("player")]["RR_ExtraWidth"] = width
    RaidRoll_CheckButton_Update()
end

function RR_SetupVariables()

    Raid_Roll_AutoUpdate = CreateFrame("FRAME", "Raid_Roll_AutoUpdate")

    --[[
    if IsInGuild() then
        RR_Debug("--In Guild, Auto refreshing guild info--")
        RR_AutoUpdate_GUILDROSTERTIME = GetTime() + 6
        UIParent:HookScript("OnUpdate", function()
                                            if GetTime() > RR_AutoUpdate_GUILDROSTERTIME then
                                                if IsInGuild() then GuildRoster() end
                                                RR_Debug("--Auto refreshing guild info again--")
                                                RR_AutoUpdate_GUILDROSTERTIME = GetTime() + 6
                                            end
                                        end)
    end
    --]]

    if RaidRoll_DB == nil then RaidRoll_DB = {} end
    if RaidRoll_DBPC == nil then RaidRoll_DBPC = {} end
    if RaidRoll_DBPC[UnitName("player")] == nil then RaidRoll_DBPC[UnitName("player")] = {} end

    --[[
    if RaidRoll_DBPC[UnitName("player")]["RR_Accept_All_Rolls"] == nil then RaidRoll_DBPC[UnitName("player")][""] = RR_Accept_All_Rolls end
    if RaidRoll_DBPC[UnitName("player")]["RR_Track_Unannounced_Rolls"] == nil then RaidRoll_DBPC[UnitName("player")]["RR_Track_Unannounced_Rolls"] = RR_Track_Unannounced_Rolls end
    if RaidRoll_DBPC[UnitName("player")]["RR_Roll_Tracking_Enabled"] == nil then RaidRoll_DBPC[UnitName("player")]["RR_Roll_Tracking_Enabled"] = RR_Roll_Tracking_Enabled end
    if RaidRoll_DBPC[UnitName("player")]["RR_AllowExtraRolls"] == nil then RaidRoll_DBPC[UnitName("player")]["RR_AllowExtraRolls"] = RR_AllowExtraRolls end
    if RaidRoll_DBPC[UnitName("player")]["RR_Show_Ranks"] == nil then RaidRoll_DBPC[UnitName("player")]["RR_Show_Ranks"] = RR_Show_Ranks end
    if RaidRoll_DBPC[UnitName("player")]["RR_RankPriority"] == nil then RaidRoll_DBPC[UnitName("player")]["RR_RankPriority"] = RR_RankPriority end
    if RaidRoll_DBPC[UnitName("player")]["RR_ExtraWidth"] == nil then RaidRoll_DBPC[UnitName("player")]["RR_ExtraWidth"] = RR_ExtraWidth end
    if RaidRoll_DBPC[UnitName("player")]["RR_ShowGroupNumber"] == nil then RaidRoll_DBPC[UnitName("player")]["RR_ShowGroupNumber"] = RR_ShowGroupNumber end
    if RaidRoll_DBPC[UnitName("player")]["RR_RollFrameHeight"] == nil then RaidRoll_DBPC[UnitName("player")]["RR_RollFrameHeight"] = RR_RollFrameHeight end
    --]]

    RR_SetupNameFrame()
    RR_ExtraFrame_Options()
    Setup_RR_Panel()

    if RaidRoll_LootTrackerLoaded == true then
        RR_SetupLootFrame()

        -- edit box 1
        if RaidRoll_DBPC[UnitName("player")]["Raid_Roll_SetMsg1_EditBox"] == nil then
            RaidRoll_DBPC[UnitName("player")]["Raid_Roll_SetMsg1_EditBox"] = "Roll [Item] Main Spec"
        end

        -- edit box 2
        if RaidRoll_DBPC[UnitName("player")]["Raid_Roll_SetMsg2_EditBox"] == nil then
            RaidRoll_DBPC[UnitName("player")]["Raid_Roll_SetMsg2_EditBox"] = "Roll [Item] Off Spec"
        end

        -- edit box 3
        if RaidRoll_DBPC[UnitName("player")]["Raid_Roll_SetMsg3_EditBox"] == nil then
            RaidRoll_DBPC[UnitName("player")]["Raid_Roll_SetMsg3_EditBox"] = "Roll [Item] Off Spec"
        end

        Raid_Roll_SetMsg1_EditBox:Insert(RaidRoll_DBPC[UnitName("player")]["Raid_Roll_SetMsg1_EditBox"])
        Raid_Roll_SetMsg2_EditBox:Insert(RaidRoll_DBPC[UnitName("player")]["Raid_Roll_SetMsg2_EditBox"])
        Raid_Roll_SetMsg3_EditBox:Insert(RaidRoll_DBPC[UnitName("player")]["Raid_Roll_SetMsg3_EditBox"])

        -- RR_ReceiveGuildMessages
        if RaidRoll_DBPC[UnitName("player")]["RR_ReceiveGuildMessages"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_ReceiveGuildMessages"] == false then
            RaidRoll_DBPC[UnitName("player")]["RR_ReceiveGuildMessages"] = false
            RR_ReceiveGuildMessages:SetChecked(false)
        else
            RR_ReceiveGuildMessages:SetChecked(true)
        end

        -- RR_Enable3Messages
        if RaidRoll_DBPC[UnitName("player")]["RR_Enable3Messages"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_Enable3Messages"] == false then
            RaidRoll_DBPC[UnitName("player")]["RR_Enable3Messages"] = false
            RR_Enable3Messages:SetChecked(false)
        else
            RR_Enable3Messages:SetChecked(true)
        end

        -- RR_Frame_WotLK_Dung_Only
        if RaidRoll_DBPC[UnitName("player")]["RR_Frame_WotLK_Dung_Only"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_Frame_WotLK_Dung_Only"] == false then
            RaidRoll_DBPC[UnitName("player")]["RR_Frame_WotLK_Dung_Only"] = false
            RR_Frame_WotLK_Dung_Only:SetChecked(false)
        else
            RR_Frame_WotLK_Dung_Only:SetChecked(true)
        end

        -- RR_AutoOpenLootWindow
        if RaidRoll_DBPC[UnitName("player")]["RR_AutoOpenLootWindow"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_AutoOpenLootWindow"] == true then
            RaidRoll_DBPC[UnitName("player")]["RR_AutoOpenLootWindow"] = true
            RR_AutoOpenLootWindow:SetChecked(true)
        else
            RR_AutoOpenLootWindow:SetChecked(false)
        end
    end

    -- Show Class Colors
    if RaidRoll_DBPC[UnitName("player")]["Time_Offset"] == nil then
        RaidRoll_DBPC[UnitName("player")]["Time_Offset"] = 0
    end

    -- RR_RollCheckBox_Auto_Close
    if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Auto_Close"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Auto_Close"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Auto_Close"] = false
        RR_RollCheckBox_Auto_Close:SetChecked(false)
    else
        RR_RollCheckBox_Auto_Close:SetChecked(true)
    end

    -- RR_RollCheckBox_No_countdown
    if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_No_countdown"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_No_countdown"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_No_countdown"] = false
        RR_RollCheckBox_No_countdown:SetChecked(false)
    else
        RR_RollCheckBox_No_countdown:SetChecked(true)
    end

    -- RR_RollCheckBox_GuildAnnounce
    if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_GuildAnnounce"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_GuildAnnounce"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_GuildAnnounce"] = false
        RR_RollCheckBox_GuildAnnounce:SetChecked(false)
    else
        RR_RollCheckBox_GuildAnnounce:SetChecked(true)
    end

    -- RR_RollCheckBox_GuildAnnounce_Officer
    if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_GuildAnnounce_Officer"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_GuildAnnounce_Officer"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_GuildAnnounce_Officer"] = false
        RR_RollCheckBox_GuildAnnounce_Officer:SetChecked(false)
    else
        RR_RollCheckBox_GuildAnnounce_Officer:SetChecked(true)
    end

    -- RR_RollCheckBox_Auto_Announce
    if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Auto_Announce"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Auto_Announce"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Auto_Announce"] = false
        RR_RollCheckBox_Auto_Announce:SetChecked(false)
    else
        RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Auto_Announce"] = true
        RR_RollCheckBox_Auto_Announce:SetChecked(true)
    end

    -- Show Class Colors
    if RaidRoll_DBPC[UnitName("player")]["RR_ShowClassColors"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_ShowClassColors"] == true then
        RaidRoll_DBPC[UnitName("player")]["RR_ShowClassColors"] = true
        RR_RollCheckBox_ShowClassColors_panel:SetChecked(true)
    else
        RR_RollCheckBox_ShowClassColors_panel:SetChecked(false)
    end

    -- Catch unannounced rolls
    if RaidRoll_DBPC[UnitName("player")]["RR_Track_Unannounced_Rolls"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_Track_Unannounced_Rolls"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_Track_Unannounced_Rolls"] = false --Set true if unannounced rolls are tracked
        RaidRoll_Catch_All:SetChecked(false)
        RR_RollCheckBox_Unannounced_panel:SetChecked(false)
    else
        RaidRoll_Catch_All:SetChecked(true)
        RR_RollCheckBox_Unannounced_panel:SetChecked(true)
    end

    -- Allow all rolls (e.g. 1-50)
    if RaidRoll_DBPC[UnitName("player")]["RR_Accept_All_Rolls"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_Accept_All_Rolls"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_Accept_All_Rolls"] = false --Set true if all rolls are counted (False = only 1-100 rolls are counted)
        RaidRoll_Allow_All:SetChecked(false)
        RR_RollCheckBox_AllRolls_panel:SetChecked(false)
    else
        RaidRoll_Allow_All:SetChecked(true)
        RR_RollCheckBox_AllRolls_panel:SetChecked(true)
    end

    -- Allow Extra Rolls
    if RaidRoll_DBPC[UnitName("player")]["RR_AllowExtraRolls"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_AllowExtraRolls"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_AllowExtraRolls"] = false
        RR_RollCheckBox_ExtraRolls:SetChecked(false)
        RR_RollCheckBox_ExtraRolls_panel:SetChecked(false)
    else
        RR_RollCheckBox_ExtraRolls:SetChecked(true)
        RR_RollCheckBox_ExtraRolls_panel:SetChecked(true)
    end

    -- Show Rank beside names
    if RaidRoll_DBPC[UnitName("player")]["RR_Show_Ranks"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_Show_Ranks"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_Show_Ranks"] = false
        --RR_RollCheckBox_ShowRanks:SetChecked(false)
        RR_RollCheckBox_ShowRanks_panel:SetChecked(false)
    else
        --RR_RollCheckBox_ShowRanks:SetChecked(true)
        RR_RollCheckBox_ShowRanks_panel:SetChecked(true)
    end

    if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Multi_Rollers"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Multi_Rollers"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Multi_Rollers"] = false
        RR_RollCheckBox_Multi_Rollers:SetChecked(false)
    else
        RR_RollCheckBox_Multi_Rollers:SetChecked(true)
    end

    -- !bid
    if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Track_EPGPSays"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Track_EPGPSays"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Track_EPGPSays"] = false
        RR_RollCheckBox_Track_EPGPSays:SetChecked(false)
    else
        RR_RollCheckBox_Track_EPGPSays:SetChecked(true)
    end

    if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Num_Not_Req"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Num_Not_Req"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Num_Not_Req"] = false
        RR_RollCheckBox_Num_Not_Req:SetChecked(false)
    else
        RR_RollCheckBox_Num_Not_Req:SetChecked(true)
    end

    -- !epgp
    if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Track_Bids"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Track_Bids"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Track_Bids"] = false
        RR_RollCheckBox_Track_Bids:SetChecked(false)
    else
        RR_RollCheckBox_Track_Bids:SetChecked(true)
    end

    -- Give higher ranks higher priority
    if RaidRoll_DBPC[UnitName("player")]["RR_RankPriority"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_RankPriority"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_RankPriority"] = false
        --RR_RollCheckBox_RankPrio:SetChecked(false)
        RR_RollCheckBox_RankPrio_panel:SetChecked(false)
    else
        --RR_RollCheckBox_RankPrio:SetChecked(true)
        RR_RollCheckBox_RankPrio_panel:SetChecked(true)
    end

    if RaidRoll_DBPC[UnitName("player")]["RR_ShowGroupNumber"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_ShowGroupNumber"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_ShowGroupNumber"] = false
        RR_RollCheckBox_ShowGroupNumber_panel:SetChecked(false)
    else
        RaidRoll_DBPC[UnitName("player")]["RR_ShowGroupNumber"] = true
        RR_RollCheckBox_ShowGroupNumber_panel:SetChecked(true)
    end

    if RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Enabled"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Enabled"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Enabled"] = false
        RR_RollCheckBox_EPGPMode_panel:SetChecked(false)
    else
        RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Enabled"] = true
        RR_RollCheckBox_EPGPMode_panel:SetChecked(true)
    end

    if RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Priority"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Priority"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Priority"] = false
        RR_RollCheckBox_EPGPThreshold_panel:SetChecked(false)
    else
        RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Priority"] = true
        RR_RollCheckBox_EPGPThreshold_panel:SetChecked(true)
    end

    if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Enable_Alt_Mode"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Enable_Alt_Mode"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Enable_Alt_Mode"] = false
        RR_RollCheckBox_Enable_Alt_Mode:SetChecked(false)
    else
        RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Enable_Alt_Mode"] = true
        RR_RollCheckBox_Enable_Alt_Mode:SetChecked(true)
    end

    if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_EPGP_Also_Show_Roll"] == nil or RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_EPGP_Also_Show_Roll"] == false then
        RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_EPGP_Also_Show_Roll"] = false
        RR_RollCheckBox_EPGP_Also_Show_Roll:SetChecked(false)
    else
        RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_EPGP_Also_Show_Roll"] = true
        RR_RollCheckBox_EPGP_Also_Show_Roll:SetChecked(true)
    end

    RR_Next:Disable()
    RR_Last:Disable()

    -- This controls the showing of the window (true = show window, false = dont show window)
    if RaidRoll_DBPC[UnitName("player")]["RR_Roll_Tracking_Enabled"] == nil then
        RaidRoll_DBPC[UnitName("player")]["RR_Roll_Tracking_Enabled"] = true
    end

    if RaidRoll_DBPC[UnitName("player")]["RR_Roll_Tracking_Enabled"] == false then
        RR_Test("Raid Roll: Raid Roll Tracking disabled. Type ''/rr enable'' to enable tracking")
    end

    -- sets up the name frame
    --RR_SetupNameFrame()

    RR_RollFrame:SetHeight(155)
    RR_RollWindowSizeUpdated()
    RaidRoll_CheckButton_Update()
    RaidRoll_CheckButton_Update_Panel()
end

-- /run RaidRoll_DBPC[UnitName("player")]["RR_ExtraWidth"]=300
-- /run RaidRoll_CheckButton_Update()

function RR_GetClassColor(Class)

    local ClassColor = ""
    local Red, Green, Blue

    Class = strupper(Class)

    if RAID_CLASS_COLORS[Class] ~= nil then
        Red = RAID_CLASS_COLORS[Class].r
        Green = RAID_CLASS_COLORS[Class].g
        Blue = RAID_CLASS_COLORS[Class].b

        ClassColor = "|c" .. string.format("%2x%2x%2x%2x", 255, Red * 255, Green * 255, Blue * 255)
    end

    return ClassColor
end

-- Matches character names with and without a realm suffix
-- Proposed by Jfalcon - 2014/06/03
function RR_IsCharacterNameMatch(name1, name2)
    name1 = strlower(name1 or "")
    name2 = strlower(name2 or "")
    local homeRealmNoSpaces = RR_HomeRealmNameLower:gsub("%s", "")

    return (name1 == name2)                                    -- Names match without any realm suffixes
        or ((name1 .. "-" .. RR_HomeRealmNameLower) == name2)  -- Names match when name1 has home realm suffix
        or (name1 == (name2 .. "-" .. RR_HomeRealmNameLower))  -- Names match when name2 has home realm suffix
		or ((name1 .. "-" .. homeRealmNoSpaces) == name2)      -- Names match when name1 has home realm suffix where home realm contains a space
		or (name1 == (name2 .. "-" .. homeRealmNoSpaces))      -- Names match when name2 has home realm suffix where home realm contains a space
end
