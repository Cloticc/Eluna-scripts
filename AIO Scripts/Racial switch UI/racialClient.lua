local AIO = AIO or require("AIO")
if AIO.AddAddon() then return end
local AIO = AIO or require("AIO")

local MyHandlers = AIO.AddHandlers("racialSwitch", {})

local config = {}

--[[ TODO: Change spells to server side instead. more secure. if i wer to change the spell id's on client they would be able to use not intended spells.
 ]]

config.utilityActive = 1
config.pssiveActive = 2
config.weaponActive = 1
config.profActive = 1

config.isActiveProf = true

config.utilityList = {
    59752, 20572, 20594, 58984, 20549, 7744, 20577, 26297, 28730, 59542, 2481,
    20589
}

config.passiveList = {
    20592, 20596, 20579, 20551, 822, 20573, 65222, 20555, 58943, 20550, 20591,
    5227, 6562, 20582, 20585, 58985, 20599, 20598
}
config.weaponList = { 26290, 20595, 59224, 20597, 20558 }
config.profList = { 20593, 20552, 28877 }

table.sort(config.utilityList,
    function(a, b) return GetSpellInfo(a) < GetSpellInfo(b) end)

function config.createText(parent, text, fontSize, point, relativeFrame,
                           relativePoint, ofsx, ofsy)
    local tex = parent:CreateFontString(nil, "OVERLAY")
    tex:SetFont("Fonts\\FRIZQT__.TTF", fontSize)
    tex:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
    tex:SetText(text)

    if tex:GetStringWidth() > 200 then
        tex:SetWidth(200)
        tex:SetWordWrap(true)
    end

    tex:SetJustifyH("LEFT")
    tex:SetJustifyV("TOP")

    return tex
end

local function createButton(parent, text, height, point, relativeFrame,
                            relativePoint, ofsx, ofsy)

    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetText(text)
    button:SetHeight(height)
    local textWidth = button:GetFontString():GetStringWidth()
    button:SetWidth(textWidth + 20)
    button:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
    return button
end

local function getRemainingSpellCooldown(spellName)
    local cooldownSeconds = 0
    local start, duration, enabled = GetSpellCooldown(spellName)
    if enabled == 1 then
        if start ~= nil and duration ~= nil then
            cooldownSeconds = start + duration - GetTime()
        end
    end
    return cooldownSeconds
end

if not config.frame then
    config.frame = CreateFrame("Frame", "MAINFRAME", UIParent,
        "UIPanelDialogTemplate")
    print("frame created")
end

config.frame.width = 900
config.frame.height = 700

config.frame:SetSize(config.frame.width, config.frame.height)
config.frame:SetScale(0.7)
config.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

config.frame:EnableMouse(true)
config.frame:EnableMouseWheel(true)
config.frame:SetMovable(true)

config.frame:RegisterForDrag("LeftButton")
config.frame:SetScript("OnDragStart", config.frame.StartMoving)
config.frame:SetScript("OnDragStop", config.frame.StopMovingOrSizing)

config.frame:SetFrameLevel(0)

config.frame:Hide()

function config.mainFrame()

    config.frame.portrait = CreateFrame("Button", nil, config.frame)
    config.frame.portrait:SetSize(64, 64)
    config.frame.portrait:SetPoint("TOPLEFT", config.frame, "TOPLEFT", -8, 9)
    config.frame.portrait:SetNormalTexture(
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
    config.frame.portrait:GetNormalTexture():SetTexCoord(unpack(
        CLASS_ICON_TCOORDS[select(
            2, UnitClass(
                "player"))]))
    config.frame.portrait:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Racial Switch")
        GameTooltip:AddLine("You may select:", 1, 1, 1)
        GameTooltip:AddLine(config.utilityActive .. " Utility.", 1, 1, 1)
        GameTooltip:AddLine(config.pssiveActive .. " Passive.", 1, 1, 1)
        GameTooltip:AddLine(config.weaponActive .. " Specialization.", 1, 1, 1)
        if config.isActiveProf then
            GameTooltip:AddLine(config.profActive .. " Profession. ", 1, 1, 1)
        end

        GameTooltip:Show()
    end)
    config.frame.portrait:SetScript("OnLeave",
        function(self) GameTooltip:Hide() end)

    config.frame.portrait:SetHighlightTexture(
        "Interface\\Buttons\\ButtonHilight-Square")
    config.frame.portrait:GetHighlightTexture():SetBlendMode("ADD")
    config.frame.portrait:GetHighlightTexture():SetAlpha(0.5)

    config.frame.portrait:SetScript("OnUpdate", function(self, elapsed)

        if not config.frame:IsShown() then self:SetAlpha(1) end

        self.elapsed = (self.elapsed or 0) + elapsed
        if self.elapsed > 0.5 then
            if not self:IsMouseOver() then
                if self:GetAlpha() == 1 then
                    self:SetAlpha(0.5)
                else
                    self:SetAlpha(1)
                end
            end
            self.elapsed = 0
        end
    end)

    config.createText(config.frame, "Racial Switch", 15, "TOP", config.frame,
        "TOP", 0, -6)
    config.createText(config.frame, "Utility", 20, "TOPLEFT", config.frame,
        "TOPLEFT", config.frame.height / 9.5, -45)
    config.createText(config.frame, "Passive", 20, "TOPLEFT", config.frame,
        "TOPLEFT", config.frame.height / 1.8, -45)
    config.createText(config.frame, "Weapon Specialization", 20, "TOPLEFT",
        config.frame, "TOPLEFT", config.frame.width / 1.3, -35)
    if config.isActiveProf then

        config.createText(config.frame, "Profession", 20, "TOPLEFT",
            config.frame, "TOPLEFT", config.frame.width / 1.22,
            -450)
    end

    createButton(config.frame, "Reset Button", 25, "CENTER", config.frame,
        "CENTER", 0, config.frame.height / -2.2):SetScript("OnClick",
        function(
        self, ...)

            print("reset button")
            for i = 1, #config.utilityList do
                local spellID = config.utilityList[i]
                local spellName = GetSpellInfo(spellID)
                local button = _G[spellName]
                if button.active then
                    AIO.Handle("racialSwitch", "racialDeactivate", spellID)
                    button:SetAlpha(0.5)
                end
            end
            for i = 1, #config.passiveList do
                local spellID = config.passiveList[i]
                local spellName = GetSpellInfo(spellID)
                local button = _G[spellName]
                if button.active then
                    AIO.Handle("racialSwitch", "racialDeactivate", spellID)
                    button:SetAlpha(0.5)
                end
            end
            for i = 1, #config.weaponList do
                local spellID = config.weaponList[i]
                local spellName = GetSpellInfo(spellID)
                local button = _G[spellName]
                if button.active then
                    AIO.Handle("racialSwitch", "racialDeactivate", spellID)
                    button:SetAlpha(0.5)
                end
            end
            if config.isActiveProf then
                for i = 1, #config.profList do
                    local spellID = config.profList[i]
                    local spellName = GetSpellInfo(spellID)
                    local button = _G[spellName]
                    if button.active then
                        AIO.Handle("racialSwitch", "racialDeactivate", spellID)
                        button:SetAlpha(0.5)
                    end
                end
            end
        end)
end

config.mainFrame()
function config.buttonCreate(parent, spellID, point, relativeFrame,
                             relativePoint, ofsx, ofsy, tableName, maximumActive)
    local spellName = GetSpellInfo(spellID)
    local spellTexture = select(3, GetSpellInfo(spellID))
    local button = CreateFrame("Button", spellName, parent)

    button:SetSize(32, 32)

    button:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
    button:SetNormalTexture(spellTexture)
    button:SetPushedTexture(spellTexture)
    button:SetHighlightTexture(spellTexture)
    button:SetAttribute("type", "spell")
    button:SetAttribute("spell", spellName)
    button:RegisterForDrag("LeftButton")

    local tex = config.createText(button, spellName, 12, "LEFT", button,
        "RIGHT", 5, 0)
    tex:SetTextColor(1, 1, 1)
    tex:SetDrawLayer("OVERLAY", 7)
    button:SetScript("OnClick", function(self)
        local maxActive = 0
        for i = 1, #tableName do
            if IsSpellKnown(tableName[i]) then
                maxActive = maxActive + 1

            end

        end
        self.active = false
        if maxActive >= maximumActive then
            self.active = false
            AIO.Handle("racialSwitch", "racialDeactivate", spellID)
        else
            self.active = true

            AIO.Handle("racialSwitch", "racialActivate", spellID)
        end
    end)

    button:SetScript("OnDragStart", function(self) PickupSpell(spellName) end)
    button:SetScript("OnDragStop", function(self) end)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")

        GameTooltip:SetHyperlink(GetSpellLink(spellID))

        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

    button:SetScript("OnUpdate", function(self, ...)

        if IsSpellKnown(spellID) then

            self:SetAlpha(1)
            self.active = true

            if not self.overlay then
                self.overlay = self:CreateTexture(nil, "OVERLAY")
                self.overlay:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
                self.overlay:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)

                self.overlay:SetAllPoints(self)

            end

            self.overlay:Show()
        else
            self.active = false
            self:SetAlpha(0.5)
            if self.overlay then self.overlay:Hide() end
        end
    end)

    button:SetScript("OnEvent", function(self, event, ...)
        if (event == "SPELL_UPDATE_COOLDOWN") then

            if self.active then

                local spell = getRemainingSpellCooldown(spellName);

                if spell then
                    if not button.cooldown then
                        button.cooldown = CreateFrame("Cooldown", nil, button)
                        button.cooldown:SetAllPoints(button)
                        button.cooldown:SetDrawEdge(false)
                        print("cooldown created")
                    end
                    button.cooldown:SetCooldown(GetTime(), spell)
                else
                    if button.cooldown then
                        button.cooldown:Hide()
                    end
                end

            end
        end
    end)

    button:RegisterEvent("SPELL_UPDATE_COOLDOWN")

    return button
end

function config.spawnButton()

    for i = 1, #config.utilityList do
        config.buttonCreate(config.frame, config.utilityList[i], "TOPLEFT",
            config.frame, "TOPLEFT", config.frame.height / 15,
            -50 - (i * 40), config.utilityList,
            config.utilityActive)
    end

    local row = 1
    local column = 1
    for i = 1, #config.passiveList do
        config.buttonCreate(config.frame, config.passiveList[i], "TOPLEFT",
            config.frame, "TOPLEFT",
            config.frame.height / 5 + (row * 160),

            -50 - (column * 40), config.passiveList,
            config.pssiveActive)

        if row == 1 then
            row = 2
        else
            row = 1
            column = column + 1
        end

    end

    for i = 1, #config.weaponList do
        config.buttonCreate(config.frame, config.weaponList[i], "TOPRIGHT",
            config.frame, "TOPRIGHT", -config.frame.height / 4,
            -50 - (i * 40), config.weaponList,
            config.weaponActive)
    end

    if config.isActiveProf then
        for i = 1, #config.profList do
            config.buttonCreate(config.frame, config.profList[i], "TOPRIGHT",
                config.frame, "TOPRIGHT",
                -config.frame.height / 4, -450 - (i * 40),
                config.profList, config.profActive)
        end
    end
end

if not config.button then config.spawnButton() end
tinsert(UISpecialFrames, config.frame:GetName())

local icon = CreateFrame("Button", nil, WorldFrame)
icon:SetSize(32, 32)
icon:SetPoint("TOP", WorldFrame, "TOP", 0, -50)

icon:SetNormalTexture("Interface\\Icons\\inv_misc_head_dragon_bronze")

SetPortraitToTexture(icon:GetNormalTexture(),
    "Interface\\Icons\\inv_misc_head_dragon_bronze")

local tex = icon:CreateFontString(nil, "OVERLAY")
tex:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
tex:SetPoint("CENTER", icon, "BOTTOM", 0, -5)
tex:SetText("Racial Switch")
icon:SetFrameStrata("HIGH")

icon:SetScript("OnClick",
    function(self, button, down) MyHandlers.MyAddonFrame() end)
icon:SetScript("OnEnter", function(self)
    icon:SetAlpha(1)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Click to open racial switch frame")
    GameTooltip:Show()
end)
icon:SetScript("OnLeave", function(self)
    icon:SetAlpha(0.5)
    GameTooltip:Hide()
end)

icon:SetMovable(true)
icon:EnableMouse(true)
icon:RegisterForDrag("LeftButton")
icon:SetScript("OnDragStart", function(self) self:StartMoving() end)
icon:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

if not icon:IsVisible() then
    icon:ClearAllPoints()
    icon:SetPoint("TOP", WorldFrame, "TOP", 0, -125)
end

SLASH_RACIALSWITCH1 = "/rs"
SLASH_RACIALSWITCH2 = "/racialswitch"
SlashCmdList["RACIALSWITCH"] = function(msg)
    if config.frame:IsShown() then
        config.frame:Hide()
    else
        securecall("CloseAllWindows")
        config.frame:Show()
    end
end

function MyHandlers.MyAddonFrame()
    if config.frame:IsShown() then
        config.frame:Hide()
        PlaySound("igSpellBookClose")

    else
        securecall("CloseAllWindows")
        config.frame:Show()

        PlaySound("igSpellBookOpen")
    end
end
