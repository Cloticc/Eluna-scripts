-- local racialHandler = AIO.AddHandlers("RACIAL_CLIENT", {})
local AIO = AIO or require("AIO")
if AIO.AddAddon() then return end

-- ignore the costType for now and cost. Just set as "gold" and 100 it's not used yet.

--    "/customracial", "/cr", "/racialchange", "/racialswitch"  commands to open chat
-- Should be self explanatory what tables do   Tabinfo handle the left side of tabs and racialSpells handle the right side of tabs. U can change maxActiveSpells to change how many spells u can have active at once in each tab.


local isWorldIconOn = false -- if u want to show the world port icon on the screen
local isCOmmandsOn = true   -- if u want to show the commands in chat

local customRacial = {
    racialButtons = {},                                    -- storing the buttons
    worldPortIcon = "achievement_dungeon_ulduar77_normal", -- icon for the world port the one u see on the screen

    tableCommands = {
        -- add the commands to open window here
        "/customracial", "/rc", "/racialchange", "/racialswitch"

    },
    activeRacialSpells = {},
}

customRacial.tabInfo = {
    { id = 1, name = "Utility",    maxActiveSpells = 1, icon = "spell_shadow_charm" },
    { id = 2, name = "Passive",    maxActiveSpells = 2, icon = "spell_nature_wispsplode" },
    { id = 3, name = "Weapon",     maxActiveSpells = 1, icon = "ability_meleedamage" },
    { id = 4, name = "Profession", maxActiveSpells = 2, icon = "inv_misc_gear_01" },
    -- { id = 5, name = "Other",      maxActiveSpells = 2, icon = "inv_misc_gear_01" },  --example
    ----------------------------------------------------------
    -----------------[Shit fuck]------------------------------
    ----------------------------------------------------------


}


-- { id = 5, name = "Other",      icon = "inv_misc_book_09" }, -- -- example
customRacial.racialSpells = {
    [1] = { -- Utility
        { id = 59752, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20572, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20594, itemType = "spell", costType = "gold", cost = 100 },
        { id = 58984, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20549, itemType = "spell", costType = "gold", cost = 100 },
        { id = 7744,  itemType = "spell", costType = "gold", cost = 100 },
        { id = 20577, itemType = "spell", costType = "gold", cost = 100 },
        { id = 26297, itemType = "spell", costType = "gold", cost = 100 },
        { id = 28730, itemType = "spell", costType = "gold", cost = 100 },
        { id = 59542, itemType = "spell", costType = "gold", cost = 100 },
        { id = 2481,  itemType = "spell", costType = "gold", cost = 100 },
        { id = 20589, itemType = "spell", costType = "gold", cost = 100 }
    },
    [2] = { -- Passive
        { id = 20592, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20596, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20579, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20551, itemType = "spell", costType = "gold", cost = 100 },
        { id = 822,   itemType = "spell", costType = "gold", cost = 100 },
        { id = 20573, itemType = "spell", costType = "gold", cost = 100 },
        { id = 65222, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20555, itemType = "spell", costType = "gold", cost = 100 },
        { id = 58943, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20550, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20591, itemType = "spell", costType = "gold", cost = 100 },
        { id = 5227,  itemType = "spell", costType = "gold", cost = 100 },
        { id = 6562,  itemType = "spell", costType = "gold", cost = 100 },
        { id = 20582, itemType = "spell", costType = "gold", cost = 100 },
        { id = 21009, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20585, itemType = "spell", costType = "gold", cost = 100 },
        { id = 58985, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20599, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20598, itemType = "spell", costType = "gold", cost = 100 },

    },
    [3] = { -- Weapon
        { id = 26290, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20595, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20574, itemType = "spell", costType = "gold", cost = 100 },
        { id = 59224, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20597, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20558, itemType = "spell", costType = "gold", cost = 100 }
    },
    [4] = { -- Profession
        { id = 20593, itemType = "spell", costType = "gold", cost = 100 },
        { id = 20552, itemType = "spell", costType = "gold", cost = 100 },
        { id = 28877, itemType = "spell", costType = "gold", cost = 100 }

    },

    -- [5] = { -- Other
    --     { id = 674,   itemType = "spell", costType = "gold", cost = 100 },
    --     { id = 46917, itemType = "spell", costType = "gold", cost = 100 },
    --     { id = 2901,  itemType = "item",  costType = "gold", cost = 100 },
    --     { id = 7005,  itemType = "item",  costType = "gold", cost = 100 },
    --     { id = 39505, itemType = "item",  costType = "gold", cost = 100 },
    --     { id = 20815, itemType = "item",  costType = "gold", cost = 100 },
    --     { id = 5956,  itemType = "item",  costType = "gold", cost = 100 },


    -- } -- -- example



}

----------------------------------------------------------
-----------------[Testing]------------------------------
----------------------------------------------------------
-- for i = 6, 50 do
--     local name = "Category " .. i
--     local maxActiveSpells = math.random(1, 3)
--     local icon = "inv_misc_questionmark"
--     table.insert(
--         customRacial.tabInfo, { id = i, name = name, maxActiveSpells = maxActiveSpells, icon = icon })
-- end



-- { id = 20598, itemType = "spell", costType = "gold", cost = 100 },
------------------------------------------------------------
-----------------END OF CONFIG------------------------------
------------------------------------------------------------


-- Define a handler function for the "RACIAL_CLIENT" addon
local racialHandler = AIO.AddHandlers("RACIAL_CLIENT", {})



local scaleMulti = 0.85
-- Helpers --

-- This function converts pixel coordinates to texture coordinates
-- size: the size of the texture
-- xTop, yTop: the top-left pixel coordinates of the region to be converted
-- xBottom, yBottom: the bottom-right pixel coordinates of the region to be converted
local function CoordsToTexCoords(size, xTop, yTop, xBottom, yBottom)
    -- Calculate the magic number
    local magic = (1 / size) / 2
    -- Calculate the top and left texture coordinates
    local Top = (yTop / size) + magic
    local Left = (xTop / size) + magic
    -- Calculate the bottom and right texture coordinates
    local Bottom = (yBottom / size) - magic
    local Right = (xBottom / size) - magic

    -- Return the texture coordinates
    return Left, Right, Top, Bottom
end

local function Clamp(value, min, max) -- clamp a value between a min and max might use later
    if value < min then
        return min
    elseif value > max then
        return max
    else
        return value
    end
end




-------------------------------
-- [xXx]
-------------------------------

local itemTooltip = CreateFrame("GameTooltip", "CustomRacialTooltip", UIParent,
    "GameTooltipTemplate")
itemTooltip:SetScale(1)
itemTooltip:SetClampedToScreen(true)
itemTooltip:SetFrameStrata("TOOLTIP")
itemTooltip:SetOwner(UIParent, "ANCHOR_NONE")
itemTooltip:Hide()

-- local mainFrame = CreateFrame("Frame", "customRacialFrame", UIParent, "UIPanelDialogTemplate")
local mainFrame = CreateFrame("Frame", "customRacialFrame", UIParent)
mainFrame:SetSize(800, 500)
mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
mainFrame:SetBackdropColor(0, 0, 0, 1)
mainFrame:Hide()

-- Background texture
mainFrame.Background = mainFrame:CreateTexture(nil, "BACKGROUND")
mainFrame.Background:SetSize(mainFrame:GetSize())
mainFrame.Background:SetPoint("CENTER", mainFrame, "CENTER")
mainFrame.Background:SetTexture("Interface/Racial_UI/StoreFrame_Main")
mainFrame.Background:SetTexCoord(CoordsToTexCoords(1024, 0, 0, 1024, 658))

-- Title--
mainFrame.Title = mainFrame:CreateFontString()
mainFrame.Title:SetFont("Fonts\\FRIZQT__.TTF", 14)
mainFrame.Title:SetShadowOffset(1, -1)
mainFrame.Title:SetPoint("TOP", mainFrame, "TOP", 0, -3)
-- mainFrame.Title:SetText("|cffedd100Custom Racial UI|r")
--  blue text
mainFrame.Title:SetText("|cff00ccffCustom Racial UI|r")

tinsert(UISpecialFrames, mainFrame:GetName()) -- allows frame to be closed with escape key

mainFrame.CloseButton = CreateFrame("Button", nil, mainFrame)
mainFrame.CloseButton:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -5, 0)
mainFrame.CloseButton:SetScript("OnClick", function() mainFrame:Hide() end)
mainFrame.CloseButton.texture = mainFrame.CloseButton:CreateTexture(nil,
    "BACKGROUND")
-- mainFrame.CloseButton.texture:SetTexture("Interface/Racial_UI/TitanLogo")
mainFrame.CloseButton.texture:SetTexture("Interface/Racial_UI/Transmogrify")
mainFrame.CloseButton.texture:SetTexCoord(CoordsToTexCoords(512, 485, 85, 511, 115))
mainFrame.CloseButton.texture:SetAllPoints(mainFrame.CloseButton)

mainFrame.CloseButton:SetSize(20, 20)
mainFrame.CloseButton:SetNormalTexture(mainFrame.CloseButton.texture)
-- set alpha to 0.5 when mouse is over button
mainFrame.CloseButton:SetScript("OnEnter",
    function(self) self.texture:SetAlpha(0.5) end)
-- set alpha to 1 when mouse leaves button
mainFrame.CloseButton:SetScript("OnLeave",
    function(self) self.texture:SetAlpha(1) end)


-------------------------------
-- [tab window for categories]
-------------------------------
local categoryList = CreateFrame("Frame", nil, mainFrame)
categoryList:SetSize(150, 300)
categoryList:SetPoint("TOPLEFT", 15, -35)
-- categoryList:SetBackdrop(
--     {
--         bgFile = "Interface/Tooltips/UI-Tooltip-Background",
--         edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
--         tile = true,
--         tileSize = 16,
--         edgeSize = 16,
--         insets = { left = 4, right = 4, top = 4, bottom = 4 }
--     }
-- )
categoryList:SetBackdropColor(0, 0, 0, 0.8)

local itemList = CreateFrame("Frame", nil, mainFrame)
itemList:SetSize(600, 435)
itemList:SetPoint("TOPRIGHT", -15, -45)

itemList:SetBackdropColor(0, 0, 0, 0.8)

-- itemList:SetBackdrop(
--     {
--         bgFile = "Interface/Tooltips/UI-Tooltip-Background",
--         edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
--         tile = true,
--         tileSize = 16,
--         edgeSize = 16,

--         insets = { left = 4, right = 4, top = 4, bottom = 4 }
--     }
-- )

local scrollFrame = CreateFrame("ScrollFrame", "CustomRacial_ScrollFrame",
    itemList, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", itemList, "TOPLEFT", 10, -10)
scrollFrame:SetPoint("BOTTOMRIGHT", itemList, "BOTTOMRIGHT", -30, 10)

itemList.scrollFrame = scrollFrame

local contentFrame = CreateFrame("Frame", "contentFrame", scrollFrame)
-- contentFrame:SetSize(scrollFrame:GetSize())
-- contentFrame:SetSize(600, 450)
--  half the size of the scroll frame
-- contentFrame:SetSize(300, 225)

scrollFrame:SetScrollChild(contentFrame)

scrollFrame:EnableMouse(true)

itemList.scrollFrame:SetScript("OnMouseWheel", function(self, delta)
    local currentValue =
        _G[itemList.scrollFrame:GetName() .. "ScrollBar"]:GetValue()
    local newValue = currentValue - (delta * 30)   -- Change '30' to adjust the scroll speed
    -- local contentHeight = itemList.contentFrame:GetHeight() -- Get the content height from itemList.contentFrame
    local contentHeight = contentFrame:GetHeight() -- Get the content height from itemList.contentFrame
    _G[itemList.scrollFrame:GetName() .. "ScrollBar"]:SetValue(math.min(
        math.max(
            newValue,
            0),
        math.max(0,
            contentHeight -
            itemList.scrollFrame:GetHeight())) -- Clamp(newValue, 0, math.max(0, contentHeight - itemList.scrollFrame:GetHeight()))
    )
end)

itemList.contentFrame = contentFrame

local tabButtonsScrollFrame = CreateFrame("ScrollFrame",
    "CustomShop_TabButtonsScrollFrame",
    categoryList)

tabButtonsScrollFrame:SetSize(200, 385)
tabButtonsScrollFrame:SetPoint("TOPLEFT", categoryList, "TOPRIGHT", -150, -30)

local tabButtonsContentFrame = CreateFrame("Frame", nil, tabButtonsScrollFrame)
tabButtonsScrollFrame:SetScrollChild(tabButtonsContentFrame)
-- tabButtonsContentFrame:SetSize(200, 385)


local tabInfo = customRacial.tabInfo
local contentHeightTab = #tabInfo * 35 -- assuming each tab button is 40 pixels high
tabButtonsContentFrame:SetSize(200, contentHeightTab)




local tabButtonsScrollBar = CreateFrame("Slider", nil, tabButtonsScrollFrame,
    "UIPanelScrollBarTemplate")
tabButtonsScrollBar:SetPoint("TOPLEFT", categoryList, "TOPRIGHT", 0, -40)
tabButtonsScrollBar:SetPoint("BOTTOMLEFT", categoryList, "BOTTOMRIGHT", 0, -100)
-- tabButtonsScrollBar:SetMinMaxValues(0, 0) calculate the length of the content frame and set the max value

-- local contentHeightTab = tabButtonsContentFrame:GetHeight() * 2
local contentHeightTab = tabButtonsContentFrame:GetHeight()
tabButtonsScrollBar:SetMinMaxValues(0, contentHeightTab)
tabButtonsScrollBar:SetValueStep(1)
tabButtonsScrollBar:SetValue(0)
tabButtonsScrollBar:SetWidth(16)
tabButtonsScrollFrame:EnableMouseWheel(true)

local function onScroll(self, delta)
    -- create a way to use mouse wheel to scroll the tab buttons frame
    local currentValue = tabButtonsScrollBar:GetValue()
    local newValue = currentValue - (delta * 30) -- Change '30' to adjust the scroll speed
    -- local contentHeightTab = tabButtonsContentFrame:GetHeight() -- Get the content height from itemList.contentFrame
    tabButtonsScrollBar:SetValue(math.min(math.max(newValue, 0),
        math.max(0, contentHeightTab)))
end

tabButtonsScrollBar:SetScript("OnValueChanged", function(self, value)
    tabButtonsScrollFrame:SetVerticalScroll(value)
end)

local function UpdateTabButtonsScrollBarVisibility()
    -- hide if if less then 15 tabinfo is active and show if more then 15 tabinfo is active
    if #customRacial.tabInfo > 10 then
        tabButtonsScrollBar:Show()
        tabButtonsScrollFrame:SetScript("OnMouseWheel", onScroll)
    else
        tabButtonsScrollBar:Hide()
    end
end

UpdateTabButtonsScrollBarVisibility()




-- Setups the tabs to the left side.
local function createTabButton(id, text, icon, onClick, OnEnter, OnLeave)
    -- local button = CreateFrame("Button", nil, tabButtonsContentFrame, "UIPanelButtonTemplate")
    local button = CreateFrame("Button", nil, tabButtonsContentFrame)
    -- Main button
    local size = 175
    button:SetSize(size * scaleMulti, (size / 4) * scaleMulti)
    -- button:SetText(text)
    button:SetPoint("TOPLEFT", 0, -35 - (id - 2) * 35)
    -- Set tab textures
    button:SetNormalTexture("Interface/Racial_UI/StoreFrame_Main")
    button:SetHighlightTexture("Interface/Racial_UI/StoreFrame_Main")
    button:GetNormalTexture():SetTexCoord(CoordsToTexCoords(1024, 770, 900, 1024, 960))
    button:GetHighlightTexture():SetTexCoord(CoordsToTexCoords(1024, 770, 960, 1024, 1024))

    -- Set Category name
    button.Name = button:CreateFontString()
    button.Name:SetFont("Fonts\\FRIZQT__.TTF", 14)
    button.Name:SetShadowOffset(1, -1)
    button.Name:SetPoint("CENTER", button, "CENTER", 5, 0)
    button.Name:SetText(text)

    -- Set Icon
    button.Icon = button:CreateTexture(nil, "BACKGROUND")
    button.Icon:SetSize(31, 31)
    button.Icon:SetPoint("LEFT", button, "LEFT", 2, 0)
    button.Icon:SetTexture("Interface/Icons/" .. icon)

    -- if click tab then
    button:SetScript("OnClick", onClick)

    -- if mouse over tab
    button:SetScript("OnEnter", OnEnter)

    -- if mouse leave tab
    button:SetScript("OnLeave", OnLeave)


    return button
end




-- Create a text and numers to display active racial spells
local activeRacialText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
activeRacialText:SetPoint("TOPLEFT", 20, -30)
activeRacialText:SetText("Active racial spells: ")

local activeRacialNumber = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
activeRacialNumber:SetPoint("TOPLEFT", activeRacialText, "TOPRIGHT", 0, 0)
-- activeRacialNumber:SetText(totalMaxActive .. "/" .. totalMaxActive)




function IsTotalMaxActive()
    -- Initialize a variable to keep track of the total maximum number of active spells
    local totalMaxActive = 0

    -- Loop through the values in the customRacial.tabInfo table and add the maxActiveSpells values together
    for _, tabInfo in pairs(customRacial.tabInfo) do
        totalMaxActive = totalMaxActive + tabInfo.maxActiveSpells
    end
    return totalMaxActive
end

--  show the text on how many is active.
local function activeRacialSpells()
    local count = 0
    for k, v in pairs(customRacial.racialSpells) do
        for numSpells, spell in pairs(v) do
            if IsSpellKnown(spell.id) or GetItemCount(spell.id) > 0 then
                count = count + 1
            end
        end
    end
    activeRacialNumber:SetText(count .. "/" .. IsTotalMaxActive())
end



mainFrame:SetScript("OnUpdate", function()
    activeRacialSpells()
end)




-- -- Button for the spells it create
local function createItemButton(parent, index, id, text, icon, onClick, itemType, costType, cost)
    -- isPassive = IsPassiveSpell(index, "bookType") or IsPassiveSpell("name")


    local button = CreateFrame("Button", nil, parent)
    button:SetSize(120, 25)
    button:EnableMouse(true)

    -- button:SetPoint("TOPLEFT", 0, -5 - (index - 1) * 35)
    local numColumns = 4
    local xIndex = (index - 1) % numColumns
    local yIndex = math.floor((index - 1) / numColumns)

    local xOffset = xIndex * 145
    -- local xOffset = xIndex * 130
    local yOffset = -15 - yIndex * 35

    button:SetPoint("TOPLEFT", xOffset + 10, yOffset)
    -- cet so it goes left to right and then down

    local iconTexture = button:CreateTexture(nil, "ARTWORK")
    iconTexture:SetSize(32, 32)
    iconTexture:SetTexture(icon)
    iconTexture:SetPoint("LEFT", 0, 0)



    local textLabel = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    textLabel:SetText(text)
    textLabel:SetFontObject("GameFontNormal")
    textLabel:SetPoint("LEFT", iconTexture, "RIGHT", 5, 0)
    textLabel:SetTextColor(1, 1, 1, 1)
    textLabel:SetWidth(100)
    textLabel:SetHeight(40)
    textLabel:SetWordWrap(true)
    textLabel:SetJustifyH("LEFT")

    local costLabel = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    costLabel:SetText(cost)

    button:EnableMouse(true)

    button:SetScript("OnClick", onClick)

    -- -- Comment out the second OnEnter function
    button:SetScript("OnEnter", function(self)
        local success, result = pcall(function()
            itemTooltip:SetOwner(self, "ANCHOR_CURSOR")
            if itemType == "spell" then
                local spellName, _, spellIcon = GetSpellInfo(id)
                -- if spellName then
                -- itemTooltip:SetSpellByID(id)
                itemTooltip:SetHyperlink("spell:" .. id)
                -- else
                -- itemTooltip:SetText("Unknown spell ID: " .. id, 1, 1, 1, 1, true)
                -- end
            elseif itemType == "item" then
                local itemName, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(id)
                -- if itemName then
                itemTooltip:SetHyperlink("item:" .. id)
                -- else
                -- itemTooltip:SetText("Unknown item ID: " .. id, 1, 1, 1, 1, true)
                -- end
            else
                itemTooltip:SetText("Invalid item type: " .. tostring(itemType), 1,
                    1, 1, 1, true)
            end
            if self.active then
                itemTooltip:AddLine("This spell is active", 0, 1, 0)
            else
                itemTooltip:AddLine("This spell is not active", 1, 0, 0)
            end
            itemTooltip:Show()
        end)
        if not success then
            print("Error: " .. result)
        end
    end)






    button:SetScript("OnLeave", function() itemTooltip:Hide() end)

    button:SetScript("OnClick", function(self)
        -- Determine the category of the spell
        local categoryId
        for catId, spells in ipairs(customRacial.racialSpells) do
            for _, spellInfo in ipairs(spells) do
                if spellInfo.id == id then
                    categoryId = catId
                    break
                end
            end
            if categoryId then break end
        end

        if not categoryId then
            print("Spell not found in any category")
            return
        end

        -- Initialize a variable to keep track of the maximum number of active spells
        local maxActive = 0

        -- Loop through all the spells in the category and count the number of known spells
        -- Loop through all the spells and items in the category and count the number of known spells and items
        for _, spellInfo in ipairs(customRacial.racialSpells[categoryId]) do
            if IsSpellKnown(spellInfo.id) then
                maxActive = maxActive + 1
            end
        end

        for _, itemInfo in ipairs(customRacial.racialSpells[categoryId]) do
            local itemCount = GetItemCount(itemInfo.id)
            if itemCount > 0 then
                maxActive = maxActive + 1
            end
        end

        -- Check if the number of active spells is less than the maximum number allowed
        local spellCategory = customRacial.tabInfo[categoryId].name:lower()
        local maximumActive = customRacial.tabInfo[categoryId].maxActiveSpells

        if maxActive < maximumActive then
            -- Check if the racial spell is currently active

            if not self.active then
                -- Activate the racial spell and set the active flag to true
                AIO.Handle("RACIAL_SERVER", "racialActivate", id, itemType)
                self.active = true
                -- Add the spell ID to the customRacial.activeRacialSpells table
                table.insert(customRacial.activeRacialSpells, id)
            else
                -- Deactivate the racial spell and set the active flag to false
                AIO.Handle("RACIAL_SERVER", "racialDeactivate", id, itemType)
                self.active = false
                -- Remove the spell ID from the customRacial.activeRacialSpells table
                for i, activeId in ipairs(customRacial.activeRacialSpells) do
                    if activeId == id then
                        table.remove(customRacial.activeRacialSpells, i)
                        break
                    end
                end
            end
        else
            -- If the number of active spells is already at the maximum, check if the current racial spell is active
            if self.active then
                -- Deactivate the current racial spell and set the active flag to false
                AIO.Handle("RACIAL_SERVER", "racialDeactivate", id, itemType)
                self.active = false
                -- Remove the spell ID from the customRacial.activeRacialSpells table
                for i, activeId in ipairs(customRacial.activeRacialSpells) do
                    if activeId == id then
                        table.remove(customRacial.activeRacialSpells, i)
                        break
                    end
                end
            else
                -- Print a message indicating that the maximum number of active spells has been reached
                print(string.format(
                    "You can only have %d active %s racial spells",
                    maximumActive, spellCategory))
            end
        end

        -- Update the activeRacialNumber font string to show the number of active spells



        -- Manually call the OnEnter script to update the tooltip
        self:GetScript("OnEnter")(self)
    end)

    button:SetScript("OnUpdate", function(self, elapsed, ...)
        local isActive = false

        if itemType == "spell" then
            isActive = IsSpellKnown(id)
        elseif itemType == "item" then
            isActive = GetItemCount(id) > 0
        end

        self.active = isActive
        self:SetAlpha(isActive and 1 or 0.5)

        if isActive and not self.overlay then
            self.overlay = self:CreateTexture(nil, "OVERLAY")
            self.overlay:SetTexture("Interface/Racial_UI/DressingRoom")
            self.overlay:SetTexCoord(CoordsToTexCoords(512, 358, 42, 399, 84))
            self.overlay:SetWidth(32)
            self.overlay:SetHeight(32)
            self.overlay:SetPoint("CENTER", iconTexture, "CENTER", 0, 0)
        elseif not isActive and not self.overlay then
            self.overlay = self:CreateTexture(nil, "OVERLAY")
            self.overlay:SetTexture("Interface/Racial_UI/DressingRoom")
            self.overlay:SetTexCoord(CoordsToTexCoords(512, 441, 0, 483, 42))
            self.overlay:SetWidth(32)
            self.overlay:SetHeight(32)
            self.overlay:SetPoint("CENTER", iconTexture, "CENTER", 0, 0)
        elseif isActive then
            self.overlay:SetTexture("Interface/Racial_UI/DressingRoom")
            self.overlay:SetTexCoord(CoordsToTexCoords(512, 358, 42, 399, 84))
        else
            self.overlay:SetTexture("Interface/Racial_UI/DressingRoom")
            self.overlay:SetTexCoord(CoordsToTexCoords(512, 441, 0, 483, 42))
        end
    end)

    -- button:SetScript("OnUpdate",
    --     function(self, elapsed, ...) -- Attach the update function to the model
    --         if itemType == "spell" then
    --             if IsSpellKnown(id) then
    --                 -- set button to alpha 1
    --                 self:SetAlpha(1)
    --                 self.active = true
    --                 -- check if overlay texture exists if not create it
    --                 if not self.overlay then
    --                     self.overlay = self:CreateTexture(nil, "OVERLAY")
    --                     -- fit to button size and position
    --                     self.overlay:SetAllPoints(self)
    --                     -- print("overlay created")
    --                 end
    --                 self.overlay:Show()
    --             else
    --                 self.active = false
    --                 self:SetAlpha(0.5)
    --                 if self.overlay then self.overlay:Hide() end
    --             end
    --         elseif itemType == "item" then
    --             local itemCount = GetItemCount(id)
    --             if itemCount > 0 then
    --                 -- set button to alpha 1
    --                 self:SetAlpha(1)
    --                 self.active = true
    --                 -- check if overlay texture exists if not create it
    --                 if not self.overlay then
    --                     self.overlay = self:CreateTexture(nil, "OVERLAY")

    --                     -- fit to button size and position
    --                     self.overlay:SetAllPoints(self)
    --                     -- print("overlay created")
    --                 end
    --                 self.overlay:Show()
    --             else
    --                 self.active = false
    --                 self:SetAlpha(0.5)
    --                 if self.overlay then self.overlay:Hide() end
    --             end
    --         end
    --     end)

    button:SetScript("OnMouseDown", function(self, button)
        if IsShiftKeyDown() then
            local spellName = GetSpellInfo(id)
            PickupSpell(spellName)
        end
    end)




    button:SetAttribute("itemType", itemType)
    button:SetAttribute("itemCost", cost)
    button:SetAttribute("costType ", costType)
    button:SetAttribute("cost", cost)

    table.insert(customRacial.racialButtons, button)

    button.costLabel = costLabel
    return button, costLabel
end

-- not used
local function ItemButton_OnClick(self, button)
    -- Handle item click, e.g., display item details or initiate purchase
    local itemID = self:GetID()
    local itemType = self:GetAttribute("itemType")
    local itemCost = self:GetAttribute("itemCost")
    local costType = self:GetAttribute("costType")

    -- print("itemID: " .. itemID)

    -- local quantity = tonumber(quantityInput:GetNumber()) or 1
    -- local quantity = itemList.quantityInput:GetNumber()
    -- local totalCost = itemCost * quantity
    -- ShowConfirmPurchasePopup(itemID, itemType, quantity, costType, totalCost)
end

-- adds all the racial spells to the list
local function populateList(categoryId)
    if not customRacial.tabInfo[categoryId] then
        return print("No tab info for categoryId: " .. categoryId)
    end
    local fakeName = {} -- This is a workaround for the GetItemInfo() function

    -- Reset the scrollbar position
    itemList.scrollFrame:SetVerticalScroll(0)

    -- Calculate the required height of the contentFrame based on the number of items
    local items = customRacial.racialSpells[categoryId]

    local contentHeight2 = math.ceil(#items / 2)

    itemList.contentFrame:SetSize(itemList.scrollFrame:GetWidth(),
        contentHeight2)
    -- Update the contentFrame's height

    -- Update the scrollbar's values based on the content frame's height
    local slider = _G[itemList.scrollFrame:GetName() .. "ScrollBar"]
    slider:SetMinMaxValues(0, math.max(0, contentHeight2 -
        itemList.scrollFrame:GetHeight()))
    slider:SetValue(0)

    -- mousewheel scrolling
    itemList.scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local current = slider:GetValue()
        local min, max = slider:GetMinMaxValues()
        if delta < 0 then
            if current < max then slider:SetValue(current + 35) end
        else
            if current > min then slider:SetValue(current - 35) end
        end
    end)
    -- Show the scrollbar only if the contentHeight is greater than the scrollFrame's height
    if contentHeight2 > itemList.scrollFrame:GetHeight() then
        slider:Show()
    else
        slider:Hide()
    end

    -- Remove existing item buttons
    for _, child in ipairs({ itemList.contentFrame:GetChildren() }) do
        child:Hide()
    end
    -- Create new item buttons
    if items then
        for i, item in ipairs(items) do
            local icon, fakeName
            if item.itemType == "item" then
                icon = GetItemIcon(item.id)
                fakeName = GetItemInfo(item.id) or "Unknown Item"
            elseif item.itemType == "spell" then
                icon = select(3, GetSpellInfo(item.id))
                fakeName = GetSpellInfo(item.id) or "Unknown Spell"
            end
            local button = createItemButton(itemList.contentFrame, i, item.id, fakeName, icon, ItemButton_OnClick,
                item.itemType, item.CostType, item.cost)
            button:SetAttribute("costType", item.costType)
            button:SetAttribute("itemCost", item.cost)
            button:SetID(item.id)
            table.insert(customRacial.racialButtons, button)
        end
    end
end
-- load first tab
populateList(1)

local tabButtons = {}
local function TabButton_OnClick(self)
    local tabID = self:GetID()

    --    if there is no item in tab then return
    if not customRacial.racialSpells[tabID] then
        return print("No items in tabID: " .. tabID)
    end



    -- :UnlockHighlight()
    -- :LockHighlight()

    -- Deactivate all tab buttons
    for i = 1, #tabButtons do tabButtons[i]:UnlockHighlight() end

    -- Activate the clicked tab button
    self:LockHighlight()

    -- Handle tab click, e.g., fetch items from server or update UI
    populateList(tabID)
end

local function TabButton_OnEnter(self)
    -- Handle mouse entering the tab button
    local tabID = self:GetID()


    local text = customRacial.tabInfo[tabID].name .. " tab"

    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(text, 1, 1, 1)
    GameTooltip:Show()
end

local function TabButton_OnLeave(self)
    -- Handle mouse leaving the tab button
    -- print("TabButton_OnLeave")
    GameTooltip:Hide()
end

for i, tab in ipairs(customRacial.tabInfo) do
    local button = createTabButton(tab.id, tab.name, tab.icon, TabButton_OnClick, TabButton_OnEnter, TabButton_OnLeave)
    button:SetID(tab.id)
    table.insert(tabButtons, button)
end




-- function to open the window
local function openWindow()
    if mainFrame:IsShown() then
        mainFrame:Hide()
        PlaySound("igSpellBookClose")
    else
        mainFrame:Show()
        PlaySound("igSpellBookOpen")
    end
end

function racialHandler.racialOpenUI() openWindow() end

function racialHandler.racialCloseUI()
    PlaySound("igSpellBookClose")
    mainFrame:Hide()
end

-- handle the /commands
if isCOmmandsOn then
    -- add slash commands
    for i, command in ipairs(customRacial.tableCommands) do
        _G["SLASH_CUSTOMRACIAL" .. i] = command
    end

    SlashCmdList["CUSTOMRACIAL"] = function() openWindow() end
end

-- World Port Icon
if isWorldIconOn then
    -- add icon on worldframe for easy access
    local icon = CreateFrame("Button", nil, WorldFrame)
    icon:SetSize(32, 32)
    icon:SetPoint("TOP", WorldFrame, "TOP", 100, -40)

    -- icon:SetNormalTexture("Interface\\Icons\\wowtoken")
    -- set a racial icon
    icon:SetNormalTexture("Interface/Icons/" .. customRacial.worldPortIcon)
    -- icon:SetHighlightTexture("Interface/Icons/" .. customRacial.worldPortIcon)
    -- icon:SetPushedTexture("Interface/Icons/" .. customRacial.worldPortIcon)

    SetPortraitToTexture(icon:GetNormalTexture(),
        "Interface/Icons/" .. customRacial.worldPortIcon)
    icon:SetAlpha(0.5)
    local tex = icon:CreateFontString(nil, "OVERLAY")
    tex:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    tex:SetPoint("CENTER", icon, "BOTTOM", 0, -5)
    tex:SetText("Custom Racial")
    icon:SetFrameStrata("HIGH")
    icon:SetClampedToScreen(true)
    icon:SetScript("OnClick", function(self, button, down) openWindow() end)
    icon:SetScript("OnEnter", function(self)
        icon:SetAlpha(1)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Click to open Custom Racial")
        GameTooltip:Show()
    end)
    icon:SetScript("OnLeave", function(self)
        icon:SetAlpha(0.5)
        GameTooltip:Hide()
    end)
    -- drag able
    icon:SetMovable(true)
    icon:EnableMouse(true)
    icon:RegisterForDrag("LeftButton")
    icon:SetScript("OnDragStart", function(self) self:StartMoving() end)
    icon:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    if not icon:IsVisible() then
        icon:ClearAllPoints()
        icon:SetPoint("TOP", WorldFrame, "TOP", 0, -100)
    end
end

-- Function to unlearn spells and clear the active state
local function resetSpells()
    for tabIndex, spellList in ipairs(customRacial.racialSpells) do
        for _, spellInfo in ipairs(spellList) do
            IsTotalMaxActive()
            customRacial.activeRacialSpells = {}
            -- check if "spell is known". If spell itemType "item" then check if item is in bag
            if spellInfo.itemType == "spell" then
                if IsSpellKnown(spellInfo.id) then
                    AIO.Handle("RACIAL_SERVER", "unLearnAllRacials", spellInfo.id, spellInfo.itemType)
                end
            elseif spellInfo.itemType == "item" then
                local itemCount = GetItemCount(spellInfo.id)
                if itemCount > 0 then
                    print("itemCount: " .. itemCount .. " id: " .. spellInfo.id)
                    AIO.Handle("RACIAL_SERVER", "unLearnAllRacials", spellInfo.id, spellInfo.itemType)
                end
            end

            -- if IsSpellKnown(spellInfo.id) then
            -- Unlearn the spell (assuming you have a function to unlearn spells, replace with the actual function)

            -- Clear the active state for the button associated with this spell
            local button = customRacial.racialButtons[tabIndex][spellInfo.id]
            if button then
                button.active = false
                button:SetAlpha(0.5)
                if button.overlay then
                    button.overlay:Hide()
                end
                -- end
            end
        end
    end
end
-- Create the reset button
local resetButton = CreateFrame("Button", nil, mainFrame,
    "UIPanelButtonTemplate")
resetButton:SetSize(175, 20)
resetButton:SetPoint("BOTTOMLEFT", mainFrame, "BOTTOMLEFT", 10, 26)

resetButton:SetNormalTexture("Interface/Racial_UI/StoreFrame_Main")
resetButton:SetHighlightTexture("Interface/Racial_UI/StoreFrame_Main")
resetButton:SetPushedTexture("Interface/Racial_UI/StoreFrame_Main")
resetButton:GetNormalTexture():SetTexCoord(
    CoordsToTexCoords(1024, 709, 849, 837, 873))
resetButton:GetHighlightTexture():SetTexCoord(
    CoordsToTexCoords(1024, 709, 849, 837, 873))
resetButton:GetPushedTexture():SetTexCoord(
    CoordsToTexCoords(1024, 709, 873, 837, 897))

-- Buy now button text
resetButton.ButtonText = resetButton:CreateFontString()
resetButton.ButtonText:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
resetButton.ButtonText:SetPoint("CENTER", resetButton, 0, 0)
resetButton.ButtonText:SetText("Reset All")

-- Set the OnClick script for the reset button to call the resetSpells function
resetButton:SetScript("OnClick", function(self) resetSpells() end)




----
