function RR_GetEPGPGuildData()

    -- Setting up default Values
    if RaidRoll_DB["EPGP"]     == nil then RaidRoll_DB["EPGP"]     = {}   end
    if RaidRoll_DB["DECAY_P"]  == nil then RaidRoll_DB["DECAY_P"]  = 0    end  -- The decay (in %)
    if RaidRoll_DB["EXTRAS_P"] == nil then RaidRoll_DB["EXTRAS_P"] = 0    end  -- Standby EPGP
    if RaidRoll_DB["MIN_EP"]   == nil then RaidRoll_DB["MIN_EP"]   = 2500 end  -- Min ep req to be eligable for loot
    if RaidRoll_DB["BASE_GP"]  == nil then RaidRoll_DB["BASE_GP"]  = 1    end  -- GP value you start with

    if RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Enabled"] == true then
        RR_ReallyGetEPGPGuildData()
    end
end

function RR_GetEPGPCharacterData(playerName)
    local PR, AboveThreshold, EP, GP = 0, false, 0, 0
    if RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Enabled"] == true then
        PR, AboveThreshold, EP, GP = RR_ReallyGetEPGPCharacterData(playerName)
    end
    return PR, AboveThreshold, EP, GP
end

function RR_EPGP_Setup()
    if RaidRoll_DBPC[UnitName("player")]["RR_EPGP_Enabled"] == true then
        local EPGP_Event = CreateFrame("Frame")
        EPGP_Event:RegisterEvent("CHAT_MSG_RAID")
        EPGP_Event:RegisterEvent("CHAT_MSG_OFFICER")
        EPGP_Event:RegisterEvent("CHAT_MSG_GUILD")
        EPGP_Event:RegisterEvent("CHAT_MSG_ADDON")
        EPGP_Event:SetScript("OnEvent", EPGP_Event_Function)
    end
end

function EPGP_Event_Function(self, event, ...)
    local arg1, arg2, arg3, arg4, arg5, arg6 = ...

    if arg1 ~= nil then
        local GuildString = string.lower(arg1)
        if string.find(GuildString, "epgp") then
            RR_Debug("EPGP String Found, updating guild info")
            if IsInGuild() then
                RR_GetEPGPGuildData()
                GuildRoster()
            end
        end
    end
end

function RR_ReallyGetEPGPGuildData()
    if IsInGuild() then
        local GuildInfoText = GetGuildInfoText()
        local debugInfo = ""

        --[[
        -EPGP-
        @DECAY_P:10
        @EXTRAS_P:50
        @MIN_EP:2500
        @BASE_GP:100
        -EPGP-
        --]]

        local string_start, string_end = string.find(GuildInfoText, "%-EPGP%-")
        if string_start ~= nil and string_end ~= nil then
            GuildInfoText = string.sub(GuildInfoText, string_end + 2)

            --[[
            @DECAY_P:10
            @EXTRAS_P:50
            @MIN_EP:2500
            @BASE_GP:100
            -EPGP-
            --]]

            local string_start, string_end = string.find(GuildInfoText, "%-EPGP%-")
            if string_start ~= nil then
                GuildInfoText = string.sub(GuildInfoText, 1, string_start - 2)

                --[[
                @DECAY_P:10
                @EXTRAS_P:50
                @MIN_EP:2500
                @BASE_GP:100
                --]]

                for i = 1, 10 do
                    if GuildInfoText ~= nil then
                        string_start, string_end = string.find(GuildInfoText, "%@+%a+%_%a+%:%d+")
                        if string_start ~= nil then
                            local Substring = string.sub(GuildInfoText, string_start, string_end)
                            GuildInfoText = string.sub(GuildInfoText, string_end + 2)
                            --RR_Debug("Leftover String: " .. GuildInfoText)

                            --[[
                            Substring
                            @DECAY_P:10
                            --]]

                            --[[
                            RR_GuildInfo
                            @EXTRAS_P:50
                            @MIN_EP:2500
                            @BASE_GP:100
                            --]]

                            string_start, string_end = string.find(Substring, "%@+%a+%_%a+%:")
                            local Type = string.upper(string.sub(Substring, string_start + 1, string_end - 1))

                            -- DECAY_P

                            string_start, string_end = string.find(Substring, "%:%d+")
                            local Value = tonumber(string.sub(Substring, string_start + 1, string_end))

                            -- 10

                            debugInfo = debugInfo .. " " .. Type .. "=" .. Value
                            RaidRoll_DB[Type] = Value
                        end
                    end
                end
            end
        end
        RR_Debug("EPGP Guild Info:" .. debugInfo)
    end
end

function RR_GetGuildOfficerNote(name)
    if IsInGuild() then
        for i = 1, GetNumGuildMembers() do
            local fullName, _, _, _, _, _, _, officerNote = GetGuildRosterInfo(i)  -- Additional retvals ignored
            if RR_IsCharacterNameMatch(name, fullName) then
                return strtrim(officerNote or "")  -- cut out [space][tab][return][newline]
            end
        end
    end

    return ""
end

function RR_ReallyGetEPGPCharacterData(playerName)
    local PR, AboveThreshold, EP, GP = 0, false, 0, 0

    if playerName ~= nil and IsInGuild() then

        RR_GetEPGPGuildData()

        local officerNote = RR_GetGuildOfficerNote(playerName)
        if officerNote ~= "" then

            -- Got a non-empty officer note, so check for EP,GP v main name
            local maybeEP, maybeGP = strsplit(",", officerNote)
            maybeEP = tonumber(maybeEP)
            maybeGP = tonumber(maybeGP)
            if maybeEP ~= nil and maybeGP ~= nil then
                -- Is EP,GP
                EP = maybeEP
                GP = maybeGP
            else

                -- Not EP,GP so check for main name if enabled
                if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Enable_Alt_Mode"] == true then
                    officerNote = RR_GetGuildOfficerNote(officerNote)
                    if officerNote ~= "" then

                        -- Found main's officer note, so parse out what may be EP,GP
                        maybeEP, maybeGP = strsplit(",", officerNote)
                        maybeEP = tonumber(maybeEP)
                        maybeGP = tonumber(maybeGP)
                        if maybeEP ~= nil and maybeGP ~= nil then
                            -- Is EP,GP
                            EP = maybeEP
                            GP = maybeGP
                        end
                    end
                end
            end

            -- Calculate values for player found in guild
            GP = GP + RaidRoll_DB["BASE_GP"]
            PR = (ceil(EP / GP * 100) / 100)
            if EP >= RaidRoll_DB["MIN_EP"] then AboveThreshold = true end
            RR_Debug(playerName .. ": EP=" .. EP .. " GP=" .. GP .. " PR=" .. PR)
        end
    end

    return PR, AboveThreshold, EP, GP
end
