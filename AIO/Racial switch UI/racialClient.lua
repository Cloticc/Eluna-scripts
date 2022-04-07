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
    59542
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

local frame = CreateFrame("Frame", "MAINFRAME", UIParent, "UIPanelDialogTemplate")
frame.width = 600
frame.height = 700
frame:SetFrameStrata("FULLSCREEN_DIALOG")
frame:SetSize(frame.width, frame.height)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
frame:SetBackdrop(
    {
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\T    -DialogFrame-NewButton",
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
--set frame level to be above the default

--set text middle at the top of the frame
local text = frame:CreateFontString(nil, "OVERLAY")
text:SetFont("Fonts\\FRIZQT__.TTF", 15)
text:SetPoint("TOP", frame, "TOP", 0, -7)
text:SetText("Racial Switch")

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

local utilityText = frame:CreateFontString(nil, "OVERLAY")
utilityText:SetFont("Fonts\\FRIZQT__.TTF", 20)
utilityText:SetPoint("TOPLEFT", frame, "TOPLEFT", frame.height / 6.8, -40)
utilityText:SetText("Utility")
frame.utilityText = utilityText

local utilityButton = {}
for i = 1, #racialUtilityList do
    utilityButton[i] = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    utilityButton[i]:SetPoint("TOPLEFT", frame, "TOPLEFT", 25, -35 - (i * 50))
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
    utilityButton[i]:SetScript(
        "OnClick",
        function(self)

            if self.isSelected then
                self.isSelected = false
                self.text:SetTextColor(1, 1, 1) --white
                self.texture:SetAlpha(0.5) --50%
                AIO.Handle("racialSwitch", "racialDeactivate", racialUtilityList[i])
            else

                for i = 1, #utilityButton do
                    utilityButton[i].isSelected = false
                    utilityButton[i].text:SetTextColor(1, 1, 1) --white
                    utilityButton[i].texture:SetAlpha(0.5) --50%
                    AIO.Handle("racialSwitch", "racialDeactivate", racialUtilityList[i])
                end
                self.isSelected = true
                self.text:SetTextColor(1, 1, 0)
                self.texture:SetAlpha(1)
                AIO.Handle("racialSwitch", "racialActivate", racialUtilityList[i])
            end
        end
    )

    frame.utilityButton = utilityButton
end


--reload
local reloadButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
reloadButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)
reloadButton:SetHeight(25)
reloadButton:SetWidth(70)
reloadButton:SetText("RELOADUI")
reloadButton:SetScript(
    "OnClick",
    function(self)
        ReloadUI()
    end
)
frame.reloadButton = reloadButton --save the button in the frame

--set text above passiveButton saying "Passive"
local passiveText = frame:CreateFontString(nil, "OVERLAY")
passiveText:SetFont("Fonts\\FRIZQT__.TTF", 20)
passiveText:SetPoint("TOPLEFT", frame, "TOPLEFT", frame.height / 2.1, -40)
passiveText:SetText("Passive")
frame.passiveText = passiveText

local passiveButton = {}
for i = 1, #racialPassiveList do
    passiveButton[i] = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    -- passiveButton[i]:SetPoint("TOPLEFT", frame, "TOPLEFT",  200, -10 - (i * 50))

    --    passiveButton[i]:SetPoint("TOPLEFT", frame, "TOPLEFT",  200, -10 - (i * 50))
    --if button go over 10 then move it to the right
    if i > 10 then
        passiveButton[i]:SetPoint("TOPLEFT", frame, "TOPLEFT", 425, -35 - (i - 10) * 50)
    else
        passiveButton[i]:SetPoint("TOPLEFT", frame, "TOPLEFT", 225, -35 - (i * 50))
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
    passiveButton[i]:SetScript(
        "OnClick",
        function(self)

            if self.isSelected then
                self.isSelected = false
                self.text:SetTextColor(1, 1, 1) --white
                self.texture:SetAlpha(0.5) --50%
                AIO.Handle("racialSwitch", "racialDeactivate", racialPassiveList[i])
            else

                for i = 1, #racialPassiveList do
                    passiveButton[i].isSelected = false
                    passiveButton[i].text:SetTextColor(1, 1, 1) --white
                    utilityButton[i].texture:SetAlpha(0.5) --50%
                    AIO.Handle("racialSwitch", "racialDeactivate", racialPassiveList[i])
                end
                self.isSelected = true
                self.text:SetTextColor(1, 1, 0)
                self.texture:SetAlpha(1)
                AIO.Handle("racialSwitch", "racialActivate", racialPassiveList[i])
            end
        end
    )

    frame.passiveButton = passiveButton
end


local testButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
testButton:SetPoint("BOTTOMRIGHT", -10, 10)
testButton:SetHeight(25)
testButton:SetWidth(70)
testButton:SetText("Reset")
testButton:SetScript(
    "OnClick",
    function(self)
        for i = 1, #passiveButton do
            passiveButton[i].isSelected = false
            passiveButton[i].text:SetTextColor(1, 1, 1) --white
            passiveButton[i].texture:SetAlpha(0.5) --50%
            AIO.Handle("racialSwitch", "racialDeactivate", racialPassiveList[i])
        end
        for i = 1, #utilityButton do
            utilityButton[i].isSelected = false
            utilityButton[i].text:SetTextColor(1, 1, 1) --white
            utilityButton[i].texture:SetAlpha(0.5) --50%
            AIO.Handle("racialSwitch", "racialDeactivate", racialUtilityList[i])
        end
        -- for i = 1, #racialButton do
        --     racialButton[i].isSelected = false
        --     racialButton[i].text:SetTextColor(1, 1, 1) --white
        --     racialButton[i].texture:SetAlpha(0.5) --50%
        --     AIO.Handle("racialSwitch", "racialDeactivate", racialList[i])
        -- end
    end
)

frame.testButton = testButton

SLASH_AHF1 = "/tf"
SlashCmdList.AHF = function()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end

function MyHandlers.MyAddonFrame(player)
    frame:Show()
    -- frame:Hide()
end

-- -- This script shows how to

-- -- Make a global variable
-- -- Notice how the variable is only initialized if it doesnt exist yet because
-- -- the persisting variable can be loaded already
-- PLAYER_STUFF = PLAYER_STUFF or { var = 0 }

-- -- Then you add it as a saved variable for account or character
-- AIO.AddSavedVar("PLAYER_STUFF")

-- -- Then you store data to it or read data from it
-- PLAYER_STUFF.var = PLAYER_STUFF.var+1
-- print("This value should increment on reloads of UI:", PLAYER_STUFF.var)

--save selection of utilityButton and passiveButton
