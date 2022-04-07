local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local MyHandlers = AIO.AddHandlers("racialSwitch", {})

local racialUtilityList = {
    59752,
    20572,
    20594,
    58984,
    20549,
    7744,
    26297,
    28730,
    59542,
    7
}

local racialPassiveList = {
    20573,
    65222,
    20555,
    58943,
    20550,
    822,
    20591,
    20592,
    7744,
    5227,
    6562,
    20582,
    20551,
    21009,
    20585,
    20596,
    58985,
    20599,
    20598
}

local frame = CreateFrame("Frame", "MAINFRAME", UIParent)
frame.width = 600
frame.height = 600
frame:SetFrameStrata("FULLSCREEN_DIALOG")
frame:SetSize(frame.width, frame.height)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
frame:SetBackdrop(
    {
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = {left = 8, right = 8, top = 8, bottom = 8}
    }
)
frame:SetBackdropColor(0, 0, 0, 1)
frame:EnableMouse(true)
frame:EnableMouseWheel(true)

frame:SetMovable(true)
frame:SetResizable(enable)
frame:SetMinResize(100, 100)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

tinsert(UISpecialFrames, "MAINFRAME")

local closeButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
closeButton:SetPoint("BOTTOM", 0, 10)
closeButton:SetHeight(25)
closeButton:SetWidth(70)
closeButton:SetText(CLOSE)
closeButton:SetScript(
    "OnClick",
    function(self)
        HideParentPanel(self)
    end
)
frame.closeButton = closeButton

--Testing a button for handle.
local testButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
testButton:SetPoint("BOTTOMRIGHT", -10, 10)
testButton:SetHeight(25)
testButton:SetWidth(70)
testButton:SetText("Test")
testButton:SetScript(
    "OnClick",
    function()
        AIO.Handle("racialSwitch", "unLearnAllRacials")
    end
)
frame.testButton = testButton

local utilityButton = {}
for i = 1, #racialUtilityList do
    utilityButton[i] = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    utilityButton[i]:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10 - (i * 50))
    utilityButton[i]:SetHeight(32)
    utilityButton[i]:SetWidth(32)
    utilityButton[i].texture = utilityButton[i]:CreateTexture(nil, "BACKGROUND")
    utilityButton[i].texture:SetAllPoints()
    utilityButton[i].texture:SetTexture(select(3, GetSpellInfo(racialUtilityList[i])))
    utilityButton[i].texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    utilityButton[i].texture:SetAlpha(0.5)
    utilityButton[i].texture:SetBlendMode("ADD")

    local f = CreateFrame("Frame", nil, utilityButton[i])
    f:SetPoint("CENTER")
    f:SetSize(32, 32)

    f.tex = f:CreateTexture()
    f.tex:SetAllPoints(f)
    f.tex:SetTexture(select(3, GetSpellInfo(racialUtilityList[i])))

    utilityButton[i].text = utilityButton[i]:CreateFontString(nil, "OVERLAY", "GameFontNormal")

    utilityButton[i].text:SetPoint("LEFT", utilityButton[i], "RIGHT", 5, 0)
    utilityButton[i].text:SetText(GetSpellInfo(racialUtilityList[i]))
    utilityButton[i].text:SetTextColor(1, 1, 1)
    utilityButton[i].text:SetJustifyH("LEFT")
    utilityButton[i].text:SetJustifyV("CENTER")
    utilityButton[i].text:SetSize(frame.width, frame.height - 50)
    utilityButton[i].text:SetWordWrap(false)
    utilityButton[i].text:SetShadowOffset(1, -1)
    utilityButton[i].text:SetShadowColor(0, 0, 0, 1)
    --racialActivate
    --racialDeactivate
--Max 1 selected button at a time.




    -- utilityButton[i]:SetScript(
    --     "OnClick",
    --     function(self)


    --         if self.isSelected then
    --             self.isSelected = false
    --             self.text:SetTextColor(1, 1, 1) --white
    --             -- self.texture:SetAlpha(0.5) --50%
    --             AIO.Handle("racialSwitch", "racialDeactivate", racialUtilityList[i])
    --         else
    --             self.isSelected = true
    --             self.text:SetTextColor(0, 1, 0)
    --             self.texture:SetAlpha(1)
    --             AIO.Handle("racialSwitch", "racialActivate", racialUtilityList[i])
    --         end
    --     end
    -- )

    --max 1 button active with all the above code
    utilityButton[i]:SetScript(
        "OnClick",
        function(self)
            for i = 1, #utilityButton do
                utilityButton[i].isSelected = false
                utilityButton[i].text:SetTextColor(1, 1, 1) --white
                utilityButton[i].texture:SetAlpha(0.5) --50%
                AIO.Handle("racialSwitch", "racialDeactivate", racialUtilityList[i])
            end
            self.isSelected = true
            self.text:SetTextColor(0, 1, 0)
            self.texture:SetAlpha(1)
            AIO.Handle("racialSwitch", "racialActivate", racialUtilityList[i])
        end
    )

    frame.utilityButton = utilityButton
end

local passiveButton = {}
for i = 1, #racialPassiveList do
    passiveButton[i] = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    -- passiveButton[i]:SetPoint("TOPLEFT", frame, "TOPLEFT",  200, -10 - (i * 50))

    --    passiveButton[i]:SetPoint("TOPLEFT", frame, "TOPLEFT",  200, -10 - (i * 50))
    --if button go over 10 then move it to the right
    if i > 10 then
        passiveButton[i]:SetPoint("TOPLEFT", frame, "TOPLEFT", 400, -10 - (i - 10) * 50)
    else
        passiveButton[i]:SetPoint("TOPLEFT", frame, "TOPLEFT", 200, -10 - (i * 50))
    end
    passiveButton[i]:SetHeight(32)
    passiveButton[i]:SetWidth(32)

    passiveButton[i].texture = passiveButton[i]:CreateTexture(nil, "BACKGROUND")
    passiveButton[i].texture:SetAllPoints()
    passiveButton[i].texture:SetTexture(select(3, GetSpellInfo(racialPassiveList[i])))
    passiveButton[i].texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    passiveButton[i].texture:SetAlpha(0.5)
    passiveButton[i].texture:SetBlendMode("ADD")
    local f = CreateFrame("Frame", nil, passiveButton[i])
    f:SetPoint("CENTER")
    f:SetSize(32, 32)
    f.tex = f:CreateTexture()
    f.tex:SetAllPoints(f)
    f.tex:SetTexture(select(3, GetSpellInfo(racialPassiveList[i])))
    passiveButton[i].text = passiveButton[i]:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    passiveButton[i].text:SetPoint("LEFT", passiveButton[i], "RIGHT", 5, 0)
    passiveButton[i].text:SetText(GetSpellInfo(racialPassiveList[i]))
    passiveButton[i].text:SetTextColor(1, 1, 1)
    passiveButton[i].text:SetJustifyH("LEFT")
    passiveButton[i].text:SetJustifyV("CENTER")
    passiveButton[i].text:SetSize(frame.width, frame.height - 50)
    passiveButton[i].text:SetWordWrap(false)
    passiveButton[i].text:SetShadowOffset(1, -1)
    passiveButton[i].text:SetShadowColor(0, 0, 0, 1)
    passiveButton[i].highlight = passiveButton[i]:CreateTexture(nil, "OVERLAY")
    passiveButton[i].highlight:SetAllPoints()
    passiveButton[i].highlight:SetTexture(select(3, GetSpellInfo(racialPassiveList[i])))
    passiveButton[i].highlight:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    passiveButton[i].highlight:SetAlpha(0.5)
    passiveButton[i].highlight:SetBlendMode("ADD")

    passiveButton[i].highlight:Hide()

    -- passiveButton[i]:SetScript(
    --     "OnClick",
    --     function(self)
    --         for j = 1, #passiveButton do
    --             passiveButton[j]:SetBackdropColor(0, 0, 0, 0)
    --             passiveButton[j].text:SetTextColor(1, 1, 1)
    --             passiveButton[j].highlight:Hide()
    --         end
    --         self:SetBackdropColor(0, 0, 0, 0.5)
    --         self.text:SetTextColor(1, 0, 0)
    --         self.highlight:Show()
    --
    --     end
    -- )
    --GameTooltip
    passiveButton[i]:SetScript(
        "OnClick",
        function(self)
            for i = 1, #passiveButton do
                passiveButton[i].isSelected = false
                passiveButton[i].text:SetTextColor(1, 1, 1) --white
                passiveButton[i].texture:SetAlpha(0.5) --50%
                AIO.Handle("racialSwitch", "racialDeactivate", racialPassiveList[i])
            end
            self.isSelected = true
            self.text:SetTextColor(0, 1, 0)
            self.texture:SetAlpha(1)
            AIO.Handle("racialSwitch", "racialActivate", racialPassiveList[i])
        end
    )

    frame.passiveButton = passiveButton
end

SLASH_AHF1 = "/tt"
SlashCmdList.AHF = function()
    if MAINFRAME:IsShown() then
        MAINFRAME:Hide()
    else
        MAINFRAME:Show()
    end
end

function MyHandlers.MyAddonFrame(player)
    frame:Show()
end
