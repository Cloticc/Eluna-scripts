local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local MyHandlers = AIO.AddHandlers("racialSwitch", {})

local config = {}

--[[
did some refactor to make it easier to read 2022-12-22

TODO: Change spells to server side instead. more secure. if i wer to change the spell id's on client they would be able to use not intended spells.

 ]]
local enableItem = false -- if true, players will need an item to remove their racial.
local itemRequired, maxStack = 5140, 20 -- item id, max stack stack is for GM only. GM's can click it to add 20 to their bag else it cost 1 for each click/usage.

config.isActiveProf = true -- if true, player can see the racial prof spells

config.utilityActive = 1
config.pssiveActive = 2
config.weaponActive = 1
config.profActive = 1

config.utilityList = { 59752, 20572, 20594, 58984, 20549, 7744, 20577, 26297, 28730, 59542, 2481, 20589 }

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
    20585,
    58985,
    20599,
    20598
}
config.weaponList = { 26290, 20595, 59224, 20597, 20558 }
config.profList = { 20593, 20552, 28877 }

------------------------------------------------------------
-----------------END OF CONFIG------------------------------
------------------------------------------------------------

-- local timePassed = SecondsToTime(seconds[, noSeconds]);

-- sort table utilityList by name
table.sort(
    config.utilityList,
    function(a, b)
        return GetSpellInfo(a) < GetSpellInfo(b)
    end
)

function config.createText(parent, text, fontSize, point, relativeFrame, relativePoint, ofsx, ofsy)
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

local function createButton(parent, text, height, point, relativeFrame, relativePoint, ofsx, ofsy)
    -- local button = CreateFrame("Button", nil, parent)
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
    return 0 < cooldownSeconds and cooldownSeconds or 0
end

-- if frame don't exist create it

if not config.frame then
    config.frame = CreateFrame("Frame", "MAINFRAME", UIParent, "UIPanelDialogTemplate")
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
    -- set class portrait
    -- config.frame.portrait = config.frame:CreateTexture(nil, "OVERLAY")
    -- config.frame.portrait:SetSize(64, 64)
    -- config.frame.portrait:SetPoint("TOPLEFT", config.frame, "TOPLEFT", -8, 9)
    -- config.frame.portrait:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
    -- config.frame.portrait:SetTexCoord(unpack(CLASS_ICON_TCOORDS[select(2, UnitClass("player"))]))

    -- set class portrait with mouseover to display class name
    config.frame.portrait = CreateFrame("Button", nil, config.frame)
    config.frame.portrait:SetSize(64, 64)
    config.frame.portrait:SetPoint("TOPLEFT", config.frame, "TOPLEFT", -8, 9)
    config.frame.portrait:SetNormalTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
    config.frame.portrait:GetNormalTexture():SetTexCoord(unpack(CLASS_ICON_TCOORDS[select(2, UnitClass("player"))]))
    config.frame.portrait:SetScript(
        "OnEnter",
        function(self)
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
        end
    )
    config.frame.portrait:SetScript(
        "OnLeave",
        function(self)
            GameTooltip:Hide()
        end
    )
    -- make indecation that the button is clickable
    config.frame.portrait:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
    config.frame.portrait:GetHighlightTexture():SetBlendMode("ADD")
    config.frame.portrait:GetHighlightTexture():SetAlpha(0.5)
    -- updates every 5 sec blink the button
    config.frame.portrait:SetScript(
        "OnUpdate",
        function(self, elapsed)
            -- if frame is not shown stop blinking
            if not config.frame:IsShown() then
                self:SetAlpha(1)
            end
            -- check if mouse is over the button stop blinking
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
        end
    )

    config.createText(config.frame, "Racial Switch", 15, "TOP", config.frame, "TOP", 0, -6)
    config.createText(config.frame, "Utility", 20, "TOPLEFT", config.frame, "TOPLEFT", config.frame.height / 9.5, -45)
    config.createText(config.frame, "Passive", 20, "TOPLEFT", config.frame, "TOPLEFT", config.frame.height / 1.8, -45)
    config.createText(
        config.frame,
        "Weapon Specialization",
        20,
        "TOPLEFT",
        config.frame,
        "TOPLEFT",
        config.frame.width / 1.3,
        -35
    )
    if config.isActiveProf then
        config.createText(
            config.frame,
            "Profession",
            20,
            "TOPLEFT",
            config.frame,
            "TOPLEFT",
            config.frame.width / 1.22,
            -450
        )
    end

    createButton(config.frame, "Reset Button", 25, "CENTER", config.frame, "CENTER", 0, config.frame.height / -2.2):
        SetScript(
            "OnClick",
            function(self, ...)
                -- gets active spells and deactivate them send spellID

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
            end
        )
end

config.mainFrame()

-- createButton with itemRequired
local function createButtonWithItemRequired(
    parent,
    name,
    width,
    height,
    point,
    relativeTo,
    relativePoint,
    xOfs,
    yOfs,
    itemID)
    local button = CreateFrame("Button", name, parent, "SecureActionButtonTemplate")
    button:SetWidth(width)
    button:SetHeight(height)
    button:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    button:SetNormalTexture(GetItemIcon(itemID))
    button:SetPushedTexture(GetItemIcon(itemID))

    -- button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
    -- button:GetHighlightTexture():SetBlendMode("ADD")
    -- button:GetHighlightTexture():SetAlpha(0.5)
    button:SetScript(
        "OnEnter",
        function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
            GameTooltip:SetHyperlink("item:" .. itemID)
            GameTooltip:Show()
        end
    )

    button:SetScript(
        "OnLeave",
        function(self)
            GameTooltip:Hide()
        end
    )
    button:SetAttribute("type", "item")
    button:SetAttribute("item", "item:" .. itemID)

    return button
end

if enableItem then
    createButtonWithItemRequired(
        config.frame,
        "itemRequiredFrame",
        30,
        30,
        "BOTTOM",
        config.frame,
        "BOTTOM",
        config.frame.width / 10,
        20,
        itemRequired
    ):SetScript(
        "OnClick",
        function(self)
            AIO.Handle("racialSwitch", "AddItemIfGm", itemRequired, maxStack)
        end
    )
    config.createText(
        config.frame,
        "<-- Required",
        15,
        "CENTER",
        itemRequiredFrame,
        "CENTER",
        config.frame.width / 12,
        0
    )
end

function config.buttonSetSpell(
    parent,
    spellID,
    point,
    relativeFrame,
    relativePoint,
    ofsx,
    ofsy,
    tableName,
    maximumActive)
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

    local tex = config.createText(button, spellName, 12, "LEFT", button, "RIGHT", 5, 0)
    tex:SetTextColor(1, 1, 1)
    tex:SetDrawLayer("OVERLAY", 7)
    -- Set the OnClick script for the button
    button:SetScript(
        "OnClick",
        function(self)
            -- Initialize a variable to keep track of the maximum number of active spells
            local maxActive = 0

            -- Loop through all the spells in the table and count the number of known spells
            for i = 1, #tableName do
                if IsSpellKnown(tableName[i]) then
                    maxActive = maxActive + 1
                end
            end

            -- Check if the number of active spells is less than the maximum number allowed
            if maxActive < maximumActive then
                -- Check if the racial spell is currently active
                if not self.active then
                    -- Activate the racial spell and set the active flag to true
                    AIO.Handle("racialSwitch", "racialActivate", spellID)
                    self.active = true
                else
                    -- Deactivate the racial spell and set the active flag to false
                    AIO.Handle("racialSwitch", "racialDeactivate", spellID)
                    self.active = false
                end
            else
                -- If the number of active spells is already at the maximum, check if the current racial spell is active
                if self.active then
                    -- Deactivate the current racial spell and set the active flag to false
                    AIO.Handle("racialSwitch", "racialDeactivate", spellID)
                    self.active = false
                else
                    -- Print a message indicating that the maximum number of active spells has been reached
                    print(string.format("You can only have %d active racial spells", maximumActive))
                end
            end

            -- Manually call the OnEnter script to update the tooltip
            self:GetScript("OnEnter")(self)
        end
    )

    -- Set the OnDragStart script for the button
    button:SetScript(
        "OnDragStart",
        function(self)
            PickupSpell(spellName)
        end
    )

    -- Set the OnDragStop script for the button
    button:SetScript(
        "OnDragStop",
        function(self)
            -- ClearCursor()
        end
    )

    button:SetScript(
        "OnEnter",
        function(self, event, ...)
            local success, error =
            pcall(
                function()
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:SetHyperlink(GetSpellLink(spellID))
                    if self.active then
                        GameTooltip:AddLine("This spell is active", 0, 1, 0)
                    else
                        GameTooltip:AddLine("This spell is not active", 1, 0, 0)
                    end
                    GameTooltip:Show()
                end
            )
            if not success then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(string.format("This spell is broken: %s", error), 1, 0, 0)
                GameTooltip:AddLine(string.format("spellName: %s", spellName))
                GameTooltip:AddLine(string.format("spellID: %d", spellID))
                GameTooltip:Show()
            end
        end
    )

    button:SetScript(
        "OnShow",
        function(self, event, ...)

        end
    )
    button:SetScript(
        "OnHide",
        function(self, event, ...)

        end
    )

    button:SetScript(
        "OnLeave",
        function(self)
            GameTooltip:Hide()
        end
    )

    button:SetScript(
        "OnUpdate",
        function(self, elapsed, ...) -- Attach the update function to the model

            if IsSpellKnown(spellID) then

                -- set button to alpha 1
                self:SetAlpha(1)
                self.active = true
                -- check if overlay texture exists if not create it
                if not self.overlay then
                    self.overlay = self:CreateTexture(nil, "OVERLAY")
                    self.overlay:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
                    self.overlay:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
                    -- fit to button size and position
                    self.overlay:SetAllPoints(self)
                    -- print("overlay created")
                end
                self.overlay:Show()
            else
                self.active = false
                self:SetAlpha(0.5)
                if self.overlay then
                    self.overlay:Hide()
                end
            end
        end
    )




    button:SetScript(
        "OnEvent",
        function(self, event, ...)
            if (event == "SPELL_UPDATE_COOLDOWN") then
                if self.active then
                    local spell = getRemainingSpellCooldown(spellName)
                    if spell then
                        if not button.cooldown then
                            button.cooldown = CreateFrame("Cooldown", nil, button)
                            button.cooldown:SetAllPoints(button)
                            button.cooldown:SetDrawEdge(false)
                        end
                        button.cooldown:SetCooldown(GetTime(), spell)
                    else
                        if button.cooldown then
                            button.cooldown:Hide()
                        end
                    end
                end
            end
        end
    )

    button:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    button:RegisterEvent("LEARNED_SPELL_IN_TAB")
    button:RegisterEvent("PLAYER_ENTERING_WORLD")

    return button
end

function config.spawnButton()
    --[[ utilityList ]]
    for i = 1, #config.utilityList do
        config.buttonSetSpell(
            config.frame,
            config.utilityList[i],
            "TOPLEFT",
            config.frame,
            "TOPLEFT",
            config.frame.height / 15,
            -50 - (i * 40),
            config.utilityList,
            config.utilityActive
        )
    end
    --
    --[[passiveList]]
    local row = 1
    local column = 1
    for i = 1, #config.passiveList do
        config.buttonSetSpell(
            config.frame,
            config.passiveList[i],
            "TOPLEFT",
            config.frame,
            "TOPLEFT",
            config.frame.height / 5 + (row * 160),
            -- spread out buttons
            -50 - (column * 40),
            config.passiveList,
            config.pssiveActive
        )

        if row == 1 then
            row = 2
        else
            row = 1
            column = column + 1
        end
        -- -- other way to sort passive
        -- if column == 14 then
        --     row = row + 1
        --     column = 1
        -- else
        --     column = column + 1
        -- end
    end

    --[[ Weapon Specialization ]]
    for i = 1, #config.weaponList do
        config.buttonSetSpell(
            config.frame,
            config.weaponList[i],
            "TOPRIGHT",
            config.frame,
            "TOPRIGHT",
            -config.frame.height / 4,
            -50 - (i * 40),
            config.weaponList,
            config.weaponActive
        )
    end
    --[[ profList ]]
    if config.isActiveProf then
        for i = 1, #config.profList do
            config.buttonSetSpell(
                config.frame,
                config.profList[i],
                "TOPRIGHT",
                config.frame,
                "TOPRIGHT",
                -config.frame.height / 4,
                -450 - (i * 40),
                config.profList,
                config.profActive
            )
        end
    end
end

if not config.button then
    config.spawnButton()
end
tinsert(UISpecialFrames, config.frame:GetName()) -- allows frame to be closed with escape key

-- add icon on worldframe for easy access
local icon = CreateFrame("Button", nil, WorldFrame)
icon:SetSize(32, 32)
icon:SetPoint("TOP", WorldFrame, "TOP", 0, -50)

icon:SetNormalTexture("Interface\\Icons\\inv_misc_head_dragon_bronze")

-- SetPortraitToTexture(textureObject, texturePath)
-- icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
SetPortraitToTexture(icon:GetNormalTexture(), "Interface\\Icons\\inv_misc_head_dragon_bronze")

local tex = icon:CreateFontString(nil, "OVERLAY")
tex:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
tex:SetPoint("CENTER", icon, "BOTTOM", 0, -5)
tex:SetText("Racial Switch")
icon:SetFrameStrata("HIGH")

icon:SetScript(
    "OnClick",
    function(self, button, down)
        MyHandlers.MyAddonFrame()
    end
)
icon:SetScript(
    "OnEnter",
    function(self)
        icon:SetAlpha(1)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Click to open racial switch frame")
        GameTooltip:Show()
    end
)
icon:SetScript(
    "OnLeave",
    function(self)
        icon:SetAlpha(0.5)
        GameTooltip:Hide()
    end
)
-- drag able
icon:SetMovable(true)
icon:EnableMouse(true)
icon:RegisterForDrag("LeftButton")
icon:SetScript(
    "OnDragStart",
    function(self)
        self:StartMoving()
    end
)
icon:SetScript(
    "OnDragStop",
    function(self)
        self:StopMovingOrSizing()
    end
)

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
