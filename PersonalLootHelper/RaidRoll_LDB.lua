function RR_Raid()
    local name, ins_type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()

    RR_Test("-----------")
    RR_Test("Name: " .. name)
    RR_Test("Type: " .. ins_type)
    RR_Test("Difficult: " .. difficultyIndex)
    RR_Test("Diff Name: " .. difficultyName)
    RR_Test("Player: " .. maxPlayers)
    RR_Test("Dynamic: " .. dynamicDifficulty)
end

function RR_OptionsScreenToggle()
    if InterfaceOptionsFrame:IsShown() then
        InterfaceOptionsFrame:Hide()
    else
        RR_OpenOptionsPanel()
        RR_GuildRankUpdate()
    end
end

local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Raid Roll", {
    text = "Raid Roll",
    type = "data source",
    icon = "Interface\\Icons\\INV_Helmet_74",
    OnClick = function(clickedframe, button)
        --InterfaceOptionsFrame_OpenToCategory(myconfigframe)

        if button == "LeftButton" then
            if IsAltKeyDown() then
                RRL_Command("loot")
            else
                RRL_Command("toggle")
            end
        elseif button == "RightButton" then
            RR_OptionsScreenToggle()

        end
        RR_Debug("You clicked with " .. button)
    end,
})

if dataobj ~= nil then

    function dataobj:OnTooltipShow()
        self:AddLine(RAIDROLL_LOCALE["BARTOOLTIP"])
    end

    function dataobj:OnEnter()
        GameTooltip:SetOwner(self, "ANCHOR_NONE")
        GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
        GameTooltip:ClearLines()
        dataobj.OnTooltipShow(GameTooltip)
        GameTooltip:Show()
    end

    function dataobj:OnLeave()
        GameTooltip:Hide()
    end
end
