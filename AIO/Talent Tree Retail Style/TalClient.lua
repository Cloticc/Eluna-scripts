local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local MyHandlers = AIO.AddHandlers("talentFrameRetail", {})

local talentT = {
    [1] = {
        [1] = {16542, 12678, 29838},
        [2] = {80898, 49152, 12704},
        [3] = {12666, 46917, 64976},
        [4] = {12750, 47295, 12697},
        [5] = {12751, 1908, 29787},
        [6] = {12751, 36356, 29787},
        [7] = {12752, 47296, 29790},
        [8] = {12752, 58872, 29790}
    },
    [2] = {
        [1] = {111, 26, 1345},
        [2] = {745, 26, 1678},
        [3] = {750, 26, 5531},
        [4] = {900, 26, 4111},
        [5] = {812, 26, 0463},
        [6] = {017, 26, 9972},
        [7] = {498, 26, 9586},
        [8] = {328, 26, 1633},
        [9] = {672, 26, 0036}
    },
    [3] = {
        [1] = {111, 26, 1345},
        [2] = {745, 26, 1678},
        [3] = {750, 26, 5531},
        [4] = {900, 26, 4111},
        [5] = {812, 26, 0463},
        [6] = {017, 26, 9972},
        [7] = {498, 26, 9586},
        [8] = {328, 26, 1633},
        [9] = {672, 26, 0036}
    },
    [4] = {
        [1] = {111, 26, 1345},
        [2] = {745, 26, 1678},
        [3] = {750, 26, 5531},
        [4] = {900, 26, 4111},
        [5] = {812, 26, 0463},
        [6] = {017, 26, 9972},
        [7] = {498, 26, 9586},
        [8] = {328, 26, 1633},
        [9] = {672, 26, 0036}
    },
    [5] = {
        [1] = {111, 26, 1345},
        [2] = {745, 26, 1678},
        [3] = {750, 26, 5531},
        [4] = {900, 26, 4111},
        [5] = {812, 26, 0463},
        [6] = {017, 26, 9972},
        [7] = {498, 26, 9586},
        [8] = {328, 26, 1633},
        [9] = {672, 26, 0036}
    },
    [6] = {
        [1] = {111, 26, 1345},
        [2] = {745, 26, 1678},
        [3] = {750, 26, 5531},
        [4] = {900, 26, 4111},
        [5] = {812, 26, 0463},
        [6] = {017, 26, 9972},
        [7] = {498, 26, 9586},
        [8] = {328, 26, 1633},
        [9] = {672, 26, 0036}
    },
    [7] = {
        [1] = {111, 26, 1345},
        [2] = {745, 26, 1678},
        [3] = {750, 26, 5531},
        [4] = {900, 26, 4111},
        [5] = {812, 26, 0463},
        [6] = {017, 26, 9972},
        [7] = {498, 26, 9586},
        [8] = {328, 26, 1633},
        [9] = {672, 26, 0036}
    },
    [8] = {
        [1] = {111, 26, 1345},
        [2] = {745, 26, 1678},
        [3] = {750, 26, 5531},
        [4] = {900, 26, 4111},
        [5] = {812, 26, 0463},
        [6] = {017, 26, 9972},
        [7] = {498, 26, 9586},
        [8] = {328, 26, 1633},
        [9] = {672, 26, 0036}
    },
    [9] = {
        [1] = {17834, 53759, 56302},
        [2] = {18696, 18756, 54038},
        [3] = {750, 26, 56247},
        [4] = {900, 26, 4111},
        [5] = {812, 26, 0463},
        [6] = {017, 26, 9972},
        [7] = {498, 26, 9586},
        [8] = {328, 26, 1633},
        [9] = {672, 26, 0036}
    },
    --[10] = {Don't use this tis no class for this.},
    [11] = {
        [1] = {111, 26, 1345},
        [2] = {745, 26, 1678},
        [3] = {750, 26, 5531},
        [4] = {900, 26, 4111},
        [5] = {812, 26, 0463},
        [6] = {017, 26, 9972},
        [7] = {498, 26, 9586},
        [8] = {328, 26, 1633},
        [9] = {672, 26, 0036}
    }
}

local function createText(parent, text, fontSize, point, relativeFrame, relativePoint, ofsx, ofsy)
    local tex = parent:CreateFontString(nil, "OVERLAY")
    tex:SetFont("Fonts\\FRIZQT__.TTF", fontSize)
    tex:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
    tex:SetText(text)
    return tex
end
local function createButton(parent, text, height, point, relativeFrame, relativePoint, ofsx, ofsy)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetText(text)
    button:SetHeight(height)
    --get text size set width based on text length and font size
    local textWidth = button:GetFontString():GetStringWidth()
    button:SetWidth(textWidth + 20)
    -- button:SetHeight(textWidth +20)
    button:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)

    return button
end
local function createText(parent, text, fontSize, point, relativeFrame, relativePoint, ofsx, ofsy)
    local tex = parent:CreateFontString(nil, "OVERLAY")
    tex:SetFont("Fonts\\FRIZQT__.TTF", fontSize)
    tex:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
    tex:SetText(text)
    return tex
end
-- setup Background window
local backWindow = CreateFrame("Frame", "BackGroundFrame", UIParent, "ButtonFrameTemplate")
backWindow:SetWidth(900)
backWindow:SetHeight(800)
backWindow:SetPoint("CENTER", 0, 0)
backWindow:SetMovable(true)
backWindow:EnableMouse(true)
backWindow:RegisterForDrag("LeftButton")
backWindow:SetScript("OnDragStart", backWindow.StartMoving)
backWindow:SetScript("OnDragStop", backWindow.StopMovingOrSizing)
backWindow:SetBackdropColor(0, 0, 0, 0.8)
-- backWindow:SetFrameStrata("HIGH")
-- backWindow:SetFrameLevel(1)
backWindow:Show()
backWindow:RegisterEvent("PLAYER_LEVEL_UP")
createText(backWindow, "Talent window for added spell? or w/e wip", 20, "TOP", backWindow, "TOP", 0, -35)

local buttonFrame = CreateFrame("Frame", "ButtonFrame", backWindow)
buttonFrame:SetWidth(795)
buttonFrame:SetHeight(999)
buttonFrame:SetPoint("CENTER", 0, -20)

buttonFrame:RegisterForDrag("LeftButton")
buttonFrame:SetScript("OnDragStart", buttonFrame.StartMoving)
buttonFrame:SetScript("OnDragStop", buttonFrame.StopMovingOrSizing)
buttonFrame:SetBackdropColor(0, 0, 0, 0.8)
buttonFrame:SetFrameStrata("HIGH")
buttonFrame:SetFrameLevel(1)
buttonFrame:Show()
local scrollFrame = CreateFrame("ScrollFrame", "scrollFrame", backWindow, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", backWindow, "TOPLEFT", 10, -70)
scrollFrame:SetPoint("BOTTOMRIGHT", backWindow, "BOTTOMRIGHT", -30, 30)
scrollFrame:SetScrollChild(buttonFrame)

--connect scrollbar to scrollframe
local scrollBar = CreateFrame("Slider", "scrollBar", scrollFrame, "UIPanelScrollBarTemplate")
scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 4, -16)
scrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", 4, 16)
scrollBar:SetMinMaxValues(1, 100)
scrollBar:SetValueStep(1)
scrollBar:SetValue(0)
scrollBar:SetWidth(16)
scrollBar:SetScript(
    "OnValueChanged",
    function(self, value)
        local min, max = scrollBar:GetMinMaxValues()
        if value == min then
            self:GetParent():SetVerticalScroll(0)
        elseif value == max then
            self:GetParent():SetVerticalScroll(self:GetParent():GetVerticalScrollRange())
        else
            self:GetParent():SetVerticalScroll(value)
        end
    end
)
scrollBar:SetScript(
    "OnMouseWheel",
    function(self, delta)
        local min, max = scrollBar:GetMinMaxValues()
        local value = scrollBar:GetValue()
        if delta < 0 and value < max then
            value = math.min(value + 10, max)
        elseif delta > 0 and value > min then
            value = math.max(value - 10, min)
        end
        scrollBar:SetValue(value)
    end
)
scrollBar:SetScript(
    "OnEnter",
    function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Scroll")
        GameTooltip:AddLine("Scrolls the window up and down.")
        GameTooltip:Show()
    end
)
scrollBar:SetScript(
    "OnLeave",
    function(self)
        GameTooltip:Hide()
    end
)
scrollBar:Hide()
backWindow.scrollBar = scrollBar

local _, playerClass = UnitClass("player")
local playerRace = select(2, UnitRace("player"))

if playerClass == "WARRIOR" then
    playerClass = 1
elseif playerClass == "PALADIN" then
    playerClass = 2
elseif playerClass == "HUNTER" then
    playerClass = 3
elseif playerClass == "ROGUE" then
    playerClass = 4
elseif playerClass == "PRIEST" then
    playerClass = 5
elseif playerClass == "DEATHKNIGHT" then
    playerClass = 6
elseif playerClass == "SHAMAN" then
    playerClass = 7
elseif playerClass == "MAGE" then
    playerClass = 8
elseif playerClass == "WARLOCK" then
    playerClass = 9
elseif playerClass == "DRUID" then
    playerClass = 11
end

local buttonGrid = {}

-- local resting = IsResting()
-- local inLockdown = InCombatLockdown()

local playerLevel = UnitLevel("player")
local player = UnitName("player")
for i = 1, #talentT[playerClass] do
    buttonGrid[i] = {}
    for j = 1, 3 do
        local spellId = talentT[playerClass][i][j]
        local spellName = GetSpellInfo(spellId)
        buttonGrid[i][j] = CreateFrame("Button", "Button" .. i .. j, buttonFrame)
        buttonGrid[i][j]:SetWidth(50)
        buttonGrid[i][j]:SetHeight(50)
        buttonGrid[i][j]:SetPoint("TOPLEFT", (j - 1) * 300 + 80, -(i - 1) * 80 - 20)
        -- buttonGrid[i][j]:SetPoint("TOPLEFT", (j - 1) * 250, -(i - 1) * 80)

        buttonGrid[i][j].texture = buttonGrid[i][j]:CreateTexture(nil, "BACKGROUND")
        buttonGrid[i][j].texture:SetAllPoints()
        buttonGrid[i][j].texture:SetTexture(select(3, GetSpellInfo(talentT[playerClass][i][j])))
        buttonGrid[i][j].texture:SetTexCoord(0, 1, 0, 1)
        -- buttonGrid[i][j].texture:SetVertexColor(0.5, 0.5, 0.5, 0.5)
        buttonGrid[i][j].text = buttonGrid[i][j]:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        buttonGrid[i][j].text:SetPoint("LEFT", buttonGrid[i][j], "RIGHT", 5, 0)
        buttonGrid[i][j].text:SetText(GetSpellInfo(talentT[playerClass][i][j]))
        buttonGrid[i][j].text:SetTextColor(1, 1, 1)
        buttonGrid[i][j].text:SetJustifyH("LEFT")
        buttonGrid[i][j].text:SetJustifyV("CENTER")
        buttonGrid[i][j].text:SetSize(buttonGrid[i][j]:GetWidth() * 2, buttonGrid[i][j]:GetHeight() * 1)
        buttonGrid[i][j].text:SetWordWrap(false)
        buttonGrid[i][j].text:SetShadowOffset(1, -1)
        buttonGrid[i][j].text:SetShadowColor(0, 0, 0, 1)

        local isKnownT = IsSpellKnown(spellId) --check if spell is known
        if isKnownT == true then
            --   buttonGrid[i][j].text:SetText((GetSpellInfo(talentT[playerClass][i][j])) .. " (active)")
            buttonGrid[i][j].active = true
            buttonGrid[i][j].texture:SetDesaturated(false)
            buttonGrid[i][j].texture:SetVertexColor(1, 1, 1)
            buttonGrid[i][j].text:SetTextColor(1, 1, 0)
            buttonGrid[i][j]:SetBackdrop(
                {
                    edgeFile = "Interface\\Buttons\\WHITE8x8",
                    edgeSize = 1
                }
            )
        elseif isKnownT == false then
            buttonGrid[i][j].active = false
            buttonGrid[i][j].texture:SetDesaturated(true)
            buttonGrid[i][j].texture:SetVertexColor(0.5, 0.5, 0.5)
            buttonGrid[i][j].text:SetTextColor(1, 1, 1)
        -- buttonGrid[i][j].text:SetText((GetSpellInfo(talentT[playerClass][i][j])) .. " (deactive)")
        end


        buttonGrid[i][j]:SetScript(
            "OnEvent",
            function(self, event)
                if event == "PLAYER_LEVEL_UP" then
                    if playerLevel < i * 10 then
                        self:Disable()
                    end
                    print("event: " .. event)

                end
            end
        )

        buttonGrid[i][j]:SetScript(
            "OnClick",
            function(self)
                if self.active == true then --if the talent is active
                    return
                end

                for k = 1, 3 do
                    if buttonGrid[i][k].active == true then
                        buttonGrid[i][k].active = false
                        buttonGrid[i][k].texture:SetDesaturated(true)
                        buttonGrid[i][k].texture:SetVertexColor(0.5, 0.5, 0.5)
                        buttonGrid[i][k].text:SetTextColor(1, 1, 1)
                        AIO.Handle("talentFrameRetail", "DeactivateTalent", talentT[playerClass][i][k])
                    end
                end
                self.active = true
                self.texture:SetDesaturated(false)
                self.texture:SetVertexColor(1, 1, 1)
                self.text:SetTextColor(1, 1, 0)
                self:SetBackdrop(
                    {
                        edgeFile = "Interface\\Buttons\\WHITE8x8",
                        edgeSize = 1
                    }
                )

                AIO.Handle("talentFrameRetail", "ActivateTalent", talentT[playerClass][i][j])
                PlaySound("igMainMenuOptionCheckBoxOn")
            end
        )

        -- buttonGrid[i][j]:SetScript(
        --     "OnMouseUp",
        --     function(self, button, down)
        --         if button == "LeftButton" then
        --             print("LeftButton")
        --         elseif button == "RightButton" then
        --             print("RightButton")
        --         end
        --     end
        -- )

        buttonGrid[i][j]:SetScript(
            "OnEnter",
            function(self)
                print(i .. " " .. j)

                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetHyperlink("spell:" .. spellId)
                GameTooltip:AddLine("Rank: " .. select(2, GetSpellInfo(spellId)))

                -- if buttonGrid[i][j].active == true then ----testing
                --     GameTooltip:AddLine("|CFF0042FF Require Xitem |r")
                --     GameTooltip:AddLine("|cffff0000 Right-click to unlearn spell |r")
                -- else
                --     GameTooltip:AddLine("|cff00ff00 Left-click to learn spell |r")
                -- end

                GameTooltip:Show()
            end
        )

        buttonGrid[i][j]:SetScript(
            "OnLeave",
            function(self)
                GameTooltip:Hide()
            end
        )
        -- buttonGrid[i][j]:Hide()
        buttonGrid[i][j].spellId = talentT[playerClass][i][j]
    end
end

-- createText(parent, text, fontSize, point, relativeFrame, relativePoint, ofsx, ofsy)
--text for level
createText(buttonFrame, "10", 50, "RIGHT", buttonGrid[1][1], "LEFT", -20, 0)
createText(buttonFrame, "20", 50, "RIGHT", buttonGrid[2][1], "LEFT", -20, 0)
createText(buttonFrame, "30", 50, "RIGHT", buttonGrid[3][1], "LEFT", -20, 0)
createText(buttonFrame, "40", 50, "RIGHT", buttonGrid[4][1], "LEFT", -20, 0)
createText(buttonFrame, "50", 50, "RIGHT", buttonGrid[5][1], "LEFT", -20, 0)
createText(buttonFrame, "60", 50, "RIGHT", buttonGrid[6][1], "LEFT", -20, 0)
createText(buttonFrame, "70", 50, "RIGHT", buttonGrid[7][1], "LEFT", -20, 0)
createText(buttonFrame, "80", 50, "RIGHT", buttonGrid[8][1], "LEFT", -20, 0)
-- createText(buttonFrame, "90", 50, "RIGHT",buttonGrid[9][1], "LEFT", -15 , 0)
-- createText(buttonFrame, "100", 50, "RIGHT",buttonGrid[10][1], "LEFT", -15 , 0)

createButton(backWindow, "Reset all", 25, "BOTTOMRIGHT", backWindow, "BOTTOMRIGHT", -5, 2.5):SetScript(
    "OnClick",
    function(self)
        for i = 1, #talentT[playerClass] do
            for k = 1, 3 do
                if buttonGrid[i][k].active == true then
                    buttonGrid[i][k].active = false
                    buttonGrid[i][k].texture:SetDesaturated(true)
                    buttonGrid[i][k].texture:SetVertexColor(0.5, 0.5, 0.5)
                    buttonGrid[i][k].text:SetTextColor(1, 1, 1)
                    AIO.Handle("talentFrameRetail", "DeactivateTalent", talentT[playerClass][i][k])
                end
            end
        end
    end
)

createButton(backWindow, "Close", 25, "BOTTOM", backWindow, "BOTTOM", -35, 2.5):SetScript(
    "OnClick",
    function(self)
        backWindow:Hide()
    end
)

SLASH_talentFrameRetail1 = "/tf"
SLASH_talentFrameRetail2 = "/talentframe"
local function slashcmd(msg)
    if (InCombatLockdown()) then
        return
    end
    if (msg ~= "") then
        LeftInset.SearchBox:SetText(msg)
    end
    backWindow:Show()
    PlaySound("igSpellBookOpen")
end
SlashCmdList["talentFrameRetail"] = slashcmd

function MyHandlers.talentFrameRetail(player)
    if talentFrameRetail:IsShown() then
        talentFrameRetail:Hide()
        PlaySound("igSpellBookClose")
    else
        talentFrameRetail:Show()
        PlaySound("igSpellBookOpen")
    end
end
