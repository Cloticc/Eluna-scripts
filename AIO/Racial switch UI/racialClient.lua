local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end
local AIO = AIO or require("AIO")

local MyHandlers = AIO.AddHandlers("racialSwitch", {})

local config = {}

config.utilityList = {
    59752,
    20572,
    20594,
    58984,
    20549,
    7744,
    20577,
    26297,
    28730,
    59542,
    2481,
    20589
}

config.passiveList = {
    20592,
    20596,
    20579,
    20551,
    822,
    20573,
    65222,
    20555,
    58943,
    20550,
    20591,
    5227,
    6562,
    20582,
    -- 21009,
    20585,
    58985,
    20599,
    20598
}
config.weapList = {
    20574,
    26290,
    20595,
    59224,
    20597,
    20558
}
table.sort(
    config.utilityList,
    function(a, b)
        return GetSpellInfo(a) < GetSpellInfo(b)
    end
)

local function createText(parent, text, fontSize, point, relativeFrame, relativePoint, ofsx, ofsy)
    local tex = parent:CreateFontString(nil, "OVERLAY")
    tex:SetFont("Fonts\\FRIZQT__.TTF", fontSize)
    tex:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
    tex:SetText(text)
    --set level above frame so it doesn't get hidden
    tex:SetDrawLayer("OVERLAY", 7)

    return tex
end
local function createButton(parent, text, height, point, relativeFrame, relativePoint, ofsx, ofsy)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetText(text)
    button:SetHeight(height)
    --get text size set width based on text length and font size
    local textWidth = button:GetFontString():GetStringWidth()
    button:SetWidth(textWidth + 20)
    button:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)

    return button
end

------------------------------------------------------------

-- UIPanelDialogTemplate

config.frame = CreateFrame("Frame", "MAINFRAME", UIParent, "ButtonFrameTemplate")
config.frame.width = 900
config.frame.height = 700

config.frame:SetFrameStrata("FULLSCREEN_DIALOG")
config.frame:SetSize(config.frame.width, config.frame.height)
config.frame:SetScale(0.9)
config.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
config.frame:SetBackdropColor(0, 0, 0, 1)
config.frame:EnableMouse(true)
config.frame:EnableMouseWheel(true)
config.frame:SetMovable(true)

config.frame:RegisterForDrag("LeftButton")
config.frame:SetScript("OnDragStart", config.frame.StartMoving)
config.frame:SetScript("OnDragStop", config.frame.StopMovingOrSizing)

config.frame:SetFrameLevel(0)

config.frame:SetScript(
    "OnEvent",
    function(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD" then
            self:Show()
        end
    end
)

--set class portrait
config.frame.portrait = config.frame:CreateTexture(nil, "ARTWORK")
config.frame.portrait:SetSize(64, 64)
config.frame.portrait:SetPoint("TOPLEFT", config.frame, "TOPLEFT", -8, 9)
config.frame.portrait:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
config.frame.portrait:SetTexCoord(unpack(CLASS_ICON_TCOORDS[select(2, UnitClass("player"))]))

--set class text next to icon
config.frame.classText =
    createText(config.frame, select(2, UnitClass("player")), 15, "TOPLEFT", config.frame.portrait, "TOPRIGHT", 10, -12)

--set name next to class text
config.frame.nameText =
    createText(config.frame, UnitName("player"), 15, "TOPLEFT", config.frame.classText, "TOPRIGHT", 10, 0)

createText(config.frame, "RACIAL CHANGE", 15, "TOP", config.frame, "TOP", 0, -4)
createText(config.frame, "Utility", 20, "TOPLEFT", config.frame, "TOPLEFT", config.frame.height / 9.5, -35)
createText(config.frame, "Passive", 20, "TOPLEFT", config.frame, "TOPLEFT", config.frame.height / 2, -35)
createText(config.frame, "Weapon Specialization", 20, "TOPRIGHT", config.frame, "TOPRIGHT", -45, -35)

createButton(config.frame, "Close", 25, "BOTTOM", config.frame, "BOTTOM", 0, 3):SetScript(
    "OnClick",
    function(self)
        HideParentPanel(self)
    end
)

for i = 1, #config.utilityList do
    local spellID = config.utilityList[i]
    local spellName = GetSpellInfo(spellID)
    local spellTexture = select(3, GetSpellInfo(spellID))

    local button = CreateFrame("Button", nil, config.frame, "SecureActionButtonTemplate")

    button:SetSize(32, 32)

    button:SetPoint("TOPLEFT", config.frame, "TOPLEFT", config.frame.height / 13, -config.frame.height / 15 * i - 50)
    button:SetNormalTexture(spellTexture)
    button:SetPushedTexture(spellTexture)
    button:SetHighlightTexture(spellTexture)
    button:SetAttribute("type", "spell")
    button:SetAttribute("spell", spellName)
    button:RegisterForDrag("LeftButton")
    button.text = createText(button, spellName, 12, "LEFT", button, "RIGHT", 5, 0)
    button.text:SetTextColor(1, 1, 1)
    button:SetFrameLevel(1)

    local isKnownUtility = IsSpellKnown(spellID)

    if isKnownUtility then
        button:SetAlpha(1)
        button.active = true
    else
        button:SetAlpha(0.5)
        button.active = false
    end

    button:SetScript(
        "OnDragStart",
        function(self)
            PickupSpell(spellName)
        end
    )

    button:SetScript(
        "OnEnter",
        function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink(GetSpellLink(spellID))

            GameTooltip:Show()
        end
    )
    button:SetScript(
        "OnLeave",
        function(self)
            GameTooltip:Hide()
        end
    )
    button:SetScript(
        "OnClick",
        function(self)
            local maxActive = 0
            for i = 1, #config.utilityList do
                if IsSpellKnown(config.utilityList[i]) then
                    maxActive = maxActive + 1
                end
            end

            if maxActive >= 1 then
                self.active = false
                AIO.Handle("racialSwitch", "racialDeactivateUtility", spellID)
            else
                self.active = true
                AIO.Handle("racialSwitch", "racialActivate", spellID)
            end
        end
    )

    button:SetScript(
        "OnEvent",
        function(self, event, ...)
            if event == "SPELL_UPDATE_COOLDOWN" then
                local start, duration, enabled = GetSpellCooldown(spellID)
                if duration > 0 then
                    button.cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
                    button.cooldown:SetAllPoints(button)
                    -- button.cooldown:SetReverse(true)
                    button.cooldown:SetCooldown(start, duration)
                else
                    button.cooldown:Hide()
                end
            end
        end
    )
    button:SetScript(
        "OnUpdate",
        function(self, elapsed)
            if IsSpellKnown(spellID) then
                self:SetAlpha(1)
            else
                self:SetAlpha(0.5)
            end
        end
    )

    button:RegisterEvent("PLAYER_ENTERING_WORLD")
    button:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    button:RegisterEvent("LEARNED_SPELL_IN_TAB")
end

for i = 1, #config.passiveList do
    local spellID = config.passiveList[i]
    local spellName = GetSpellInfo(spellID)
    local spellTexture = select(3, GetSpellInfo(spellID))

    local button = CreateFrame("Button", nil, config.frame, "SecureActionButtonTemplate")

    button:SetSize(32, 32)

    if i > 12 then
        button:SetPoint(
            "TOPLEFT",
            config.frame,
            "TOPLEFT",
            config.frame.height / 1.6,
            -config.frame.height / 15 * (i - 12) - 50
        )
    else
        button:SetPoint("TOPLEFT", config.frame, "TOPLEFT", config.frame.height / 3, -config.frame.height / 15 * i - 50)
    end
    button:SetNormalTexture(spellTexture)
    button:SetPushedTexture(spellTexture)
    button:SetHighlightTexture(spellTexture)
    button:SetAttribute("type", "spell")
    button:SetAttribute("spell", spellName)
    button:RegisterForDrag("LeftButton")
    button.text = createText(button, spellName, 12, "LEFT", button, "RIGHT", 5, 0)
    button.text:SetTextColor(1, 1, 1)
    button:SetFrameLevel(1)

    local isKnownPassive = IsSpellKnown(spellID)

    if isKnownPassive then
        button:SetAlpha(1)
        button.active = true
    else
        button:SetAlpha(0.5)
        button.active = false
    end
    button:SetScript(
        "OnDragStart",
        function(self)
            PickupSpell(spellName)
        end
    )
    button:SetScript(
        "OnEnter",
        function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink(GetSpellLink(spellID))
            GameTooltip:Show()
        end
    )
    button:SetScript(
        "OnLeave",
        function(self)
            GameTooltip:Hide()
        end
    )
    button:SetScript(
        "OnClick",
        function(self)
            local maxActive = 0
            for i = 1, #config.passiveList do
                if IsSpellKnown(config.passiveList[i]) then
                    maxActive = maxActive + 1
                end
            end
            if maxActive >= 2 then
                self.active = false
                AIO.Handle("racialSwitch", "racialDeactivatePassive", spellID)
            else
                self.active = true
                AIO.Handle("racialSwitch", "racialActivate", spellID)
            end
        end
    )

    button:SetScript(
        "OnUpdate",
        function(self, elapsed)
            if IsSpellKnown(spellID) then
                self:SetAlpha(1)
            else
                self:SetAlpha(0.5)
            end
        end
    )

    button:RegisterEvent("PLAYER_ENTERING_WORLD")
    button:RegisterEvent("SPELL_UPDATE_COOLDOWN")
end

for i = 1, #config.weapList do
    local spellID = config.weapList[i]
    local spellName = GetSpellInfo(spellID)
    local spellTexture = select(3, GetSpellInfo(spellID))
    -- local spellTexture = GetSpellTexture(spellID)
    local button = CreateFrame("Button", nil, config.frame, "SecureActionButtonTemplate")

    button:SetSize(32, 32)
    -- button:SetSize(config.frame.height / 12, config.frame.height / 12)
    button:SetPoint("TOPLEFT", config.frame, "TOPLEFT", config.frame.height / 1.1, -config.frame.height / 15 * i - 50)

    button:SetNormalTexture(spellTexture)
    button:SetPushedTexture(spellTexture)
    button:SetHighlightTexture(spellTexture)
    button:SetAttribute("type", "spell")
    button:SetAttribute("spell", spellName)
    button:RegisterForDrag("LeftButton")
    button.text = createText(button, spellName, 12, "LEFT", button, "RIGHT", 5, 0)
    button.text:SetTextColor(1, 1, 1)
    button:SetFrameLevel(1)

    local isKnownPassive = IsSpellKnown(spellID)

    if isKnownPassive then
        button:SetAlpha(1)

        button.active = true
    else
        button:SetAlpha(0.5)

        button.active = false
    end

    button:SetScript(
        "OnDragStart",
        function(self)
            PickupSpell(spellName)
        end
    )
    button:SetScript(
        "OnEnter",
        function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink(GetSpellLink(spellID))
            GameTooltip:Show()
        end
    )
    button:SetScript(
        "OnLeave",
        function(self)
            GameTooltip:Hide()
        end
    )
    button:SetScript(
        "OnClick",
        function(self)
            local maxActive = 0
            for i = 1, #config.weapList do
                if IsSpellKnown(config.weapList[i]) then
                    maxActive = maxActive + 1
                end
            end
            if maxActive >= 1 then
                self.active = false
                AIO.Handle("racialSwitch", "racialDeactivateWeaponSpecialization", spellID)
            else
                self.active = true
                AIO.Handle("racialSwitch", "racialActivate", spellID)
            end
        end
    )

    button:SetScript(
        "OnUpdate",
        function(self, elapsed)
            if IsSpellKnown(spellID) then
                self:SetAlpha(1)
            else
                self:SetAlpha(0.5)
            end
        end
    )
    button:RegisterEvent("PLAYER_ENTERING_WORLD")
    button:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    -- button:RegisterEvent("SPELL_UPDATE_USABLE")
end

createButton(config.frame, "reset button", 25, "BOTTOMRIGHT", config.frame, "BOTTOMRIGHT", -8, 2):SetScript(
    "OnClick",
    function(self)
        AIO.Handle("racialSwitch", "unLearnAllRacials")
        PlaySound("igMainMenuOptionCheckBoxOff")
    end
)

--setup button
local infoButton = CreateFrame("button", nil, config.frame, "UIPanelInfoButton")
infoButton:SetPoint("BOTTOMRIGHT", config.frame, "BOTTOMRIGHT", -10, 35)
infoButton:SetScript(
    "OnEnter",
    function(self)
        --show text when enter
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Racial Switch")
        GameTooltip:AddLine("You may select:", 1, 1, 1)
        GameTooltip:AddLine("1 Utility", 1, 1, 1)
        GameTooltip:AddLine("2 Passive", 1, 1, 1)
        GameTooltip:AddLine("1 Specialization. ", 1, 1, 1)
        GameTooltip:Show()
    end
)
infoButton:SetScript(
    "OnLeave",
    function(self)
        GameTooltip:Hide()
    end
)

config.frame.infoButton = infoButton

SLASH_RACIALSWITCH1 = "/rs"
SLASH_RACIALSWITCH2 = "/racialswitch"
SlashCmdList["RACIALSWITCH"] = function(msg)
    if config.frame:IsShown() then
        config.frame:Hide()
    else
        config.frame:Show()
    end
end

local function OnKeyDown(self, key)
    if key == "ESCAPE" then
        config.frame:Hide()
    end
end
config.frame:SetScript("OnKeyDown", OnKeyDown)

function MyHandlers.MyAddonFrame()
    if config.frame:IsShown() then
        -- config.frame:Hide()
        PlaySound("igSpellBookClose")
    else
        config.frame:Show()
        PlaySound("igSpellBookOpen")
    end
end
