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

local function ScrollFrame_OnMouseWheel(self, delta)
    local newValue = self:GetVerticalScroll() - (delta * 20)

    if (newValue < 0) then
        newValue = 0
    elseif (newValue > self:GetVerticalScrollRange()) then
        newValue = self:GetVerticalScrollRange()
    end

    self:SetVerticalScroll(newValue)
end
-- local function createText(parent, text, fontSize, point, relativeFrame, relativePoint, ofsx, ofsy)

--     local tex = parent:CreateFontString(nil, "OVERLAY")
--     tex:SetFont("Fonts\\FRIZQT__.TTF", fontSize)
--     tex:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
--     tex:SetText(text)
--     return tex
-- end

-- local menu = con or con:CreateMenu();
-- menu:SetShown(not menu:IsShown());
local _, playerClass = UnitClass("player")
local playerRace = select(2, UnitRace("player"))
local playerLevel = UnitLevel("player")
local player = UnitName("player")
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
local con = {}

function con.createButton(parent, text, height, point, relativeFrame, relativePoint, ofsx, ofsy)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetText(text)
    button:SetHeight(height)
    local textWidth = button:GetFontString():GetStringWidth()
    button:SetWidth(textWidth + 20)
    button:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)

    return button
end

local function createtalentT(button, i, j)--test
    local talent = CreateFrame("Button", nil, button, "UIPanelButtonTemplate")
    talent:SetHeight(64)
    talent:SetWidth(64)
talent:SetAllPoints(button[1])
    talent:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetTalent(self.talentID, self.talentGroup)
        GameTooltip:Show()
    end)
    talent:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    return talent
end

function con:CreateMenu()
    con = CreateFrame("Frame", "talentFrameRetail", UIParent, "ButtonFrameTemplate")
    con:SetSize(800, 800)
    con:SetPoint("CENTER")
    con:SetMovable(true)
    con:EnableMouse(true)
    con:RegisterForDrag("LeftButton")
    con:SetScript("OnDragStart", con.StartMoving)
    con:SetScript("OnDragStop", con.StopMovingOrSizing)

    con.TalText = con:CreateFontString(nil, "OVERLAY")
    con.TalText:SetFont("Fonts\\FRIZQT__.TTF", 20)
    con.TalText:SetPoint("TOP", con, "TOP", 0, -40)
    con.TalText:SetText("Talent Frame")

    con.buttonFrame = CreateFrame("Frame", nil, con)
    con.buttonFrame:SetWidth(765)
    con.buttonFrame:SetHeight(999)
    con.buttonFrame:SetPoint("CENTER", 0, -20)
    con.buttonFrame:SetBackdropColor(0, 0, 0, 0.8)
    -- con.buttonFrame:SetFrameStrata("HIGH")
    -- con.buttonFrame:SetFrameLevel(1)
    con.buttonFrame:Show()
    con.buttonFrame:SetBackdrop(
        {
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true,
            tileSize = 32,
            edgeSize = 32,
            insets = {left = 11, right = 12, top = 12, bottom = 11}
        }
    )

    con.scrollFrame = CreateFrame("ScrollFrame", "scrollFrame", con, "UIPanelScrollFrameTemplate")
    con.scrollFrame:SetPoint("TOPLEFT", con, "TOPLEFT", 10, -70)
    con.scrollFrame:SetPoint("BOTTOMRIGHT", con, "BOTTOMRIGHT", -30, 30)
    -- con.scrollFrame:SetClipsChildren(true)
    con.scrollFrame:SetScrollChild(con.buttonFrame)
    con.scrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel)

    -- con.scrollFrame.ScrollBar:ClearAllPoints()
    -- con.scrollFrame.ScrollBar:SetPoint("TOPLEFT", con.scrollFrame, "TOPRIGHT", 4, -16)
    -- con.scrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", con.scrollFrame, "BOTTOMRIGHT", 4, 16)
    for i = 1, #talentT[playerClass] do
        for j = 1, 3 do
            con.button = CreateFrame("Button", "button" .. i .. j, con.ButtonFrame, "SecureActionButtonTemplate")
            con.button:SetHeight(40)
            con.button:SetWidth(40)
            con.button:SetPoint("CENTER", con.buttonFrame, "CENTER", (j - 1) * 120 + 10, -(i - 1) * 50 + 100)
            --set random icon for testing
            con.button.icon = con.button:CreateTexture(nil, "OVERLAY")
            con.button.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
            con.button.icon:SetAllPoints(con.button)
            con.button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            con.button.icon:SetDesaturated(true)
            --put frame above buttonFrame
            con.button:SetFrameStrata("HIGH")
            con.button:SetFrameLevel(1)
            con.button:Show()
            con.button:SetBackdrop(
                {
                    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
                    tile = true,
                    tileSize = 32,
                    edgeSize = 32,
                    insets = {left = 11, right = 12, top = 12, bottom = 11}
                }
            )
            con.button:SetScript("OnEnter", function(self)
                print(i, j)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetTalent(self.talentID, self.talentGroup)
                GameTooltip:Show()
            end)
            con.button:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
            end)
        end
    end
    con:Show()
    return con
end
-- con:createFrameForTalentButton()
con:CreateMenu()
createtalentT(con.buttonFrame, 1, 1)
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
