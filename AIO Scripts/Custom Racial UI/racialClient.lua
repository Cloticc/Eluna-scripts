local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local racialHandler = AIO.AddHandlers("racialSwitch", {})
local customRacial = {}

_G.customRacial = customRacial




customRacial.racialButtons = {}





customRacial.tabInfo = {
    { id = 1, name = "Utility" },
    { id = 2, name = "Passive" },
    { id = 3, name = "Weapon" },
    { id = 4, name = "Profession" },
    --add more here like this
    -- { id = 5, name = "Other" }

}
customRacial.maxActiveSpells = {
    utility = 1,
    passive = 3,
    weapon = 1,
    profession = 1,
}


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
    }
}


------------------------------------------------------------
-----------------END OF CONFIG------------------------------
------------------------------------------------------------



local itemTooltip = CreateFrame("GameTooltip", "CustomRacialTooltip", UIParent, "GameTooltipTemplate")
itemTooltip:SetScale(1)
itemTooltip:SetClampedToScreen(true)
itemTooltip:SetFrameStrata("TOOLTIP")
itemTooltip:SetOwner(UIParent, "ANCHOR_NONE")
itemTooltip:Hide()







local mainFrame = CreateFrame("Frame", "customRacialFrame", UIParent, "UIPanelDialogTemplate")
mainFrame:SetSize(800, 500)
mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
-- mainFrame:SetBackdrop({
--     bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
--     edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
--     tile = true,
--     tileSize = 32,
--     edgeSize = 32,
--     insets = { left = 11, right = 12, top = 12, bottom = 11 }
-- })
mainFrame:SetBackdropColor(0, 0, 0, 1)
mainFrame:Hide()
tinsert(UISpecialFrames, mainFrame:GetName()) -- allows frame to be closed with escape key

local titleBar = mainFrame:CreateTexture(nil, "ARTWORK")
titleBar:SetTexture("Interface/DialogFrame/UI-DialogBox-Header")
titleBar:SetWidth(250)
titleBar:SetHeight(64)
titleBar:SetPoint("TOP", 0, 30)
-- local titleBar = mainFrame:CreateTexture(nil, "ARTWORK")
-- titleBar:SetTexture("Interface/DialogFrame/UI-DialogBox-Header")
-- titleBar:SetWidth(250)
-- titleBar:SetHeight(64)
-- titleBar:SetPoint("TOP", 0, 12)

local title = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("TOP", titleBar, "TOP", 0, -14)
title:SetText("Custom Racial UI")

-- local closeButton = CreateFrame("Button", nil, mainFrame, "UIPanelCloseButton")
-- closeButton:SetPoint("TOPRIGHT", -5, -5)
-- closeButton:SetScript(
--     "OnClick",
--     function()
--         mainFrame:Hide()
--     end
-- )

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
itemList:SetSize(600, 450)
itemList:SetPoint("TOPRIGHT", -15, -35)
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
itemList:SetBackdropColor(0, 0, 0, 0.8)



local scrollFrame = CreateFrame("ScrollFrame", "CustomRacial_ScrollFrame", itemList, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", itemList, "TOPLEFT", 10, -10)
scrollFrame:SetPoint("BOTTOMRIGHT", itemList, "BOTTOMRIGHT", -30, 10)

itemList.scrollFrame = scrollFrame


local contentFrame = CreateFrame("Frame", "contentFrame", scrollFrame)
contentFrame:SetSize(scrollFrame:GetSize())
scrollFrame:SetScrollChild(contentFrame)

scrollFrame:EnableMouse(true)

itemList.scrollFrame:SetScript(
    "OnMouseWheel",
    function(self, delta)
        local currentValue = _G[itemList.scrollFrame:GetName() .. "ScrollBar"]:GetValue()
        local newValue = currentValue - (delta * 30)            -- Change '30' to adjust the scroll speed
        local contentHeight = itemList.contentFrame:GetHeight() -- Get the content height from itemList.contentFrame
        _G[itemList.scrollFrame:GetName() .. "ScrollBar"]:SetValue(
            math.min(
                math.max(newValue, 0),
                math.max(0, contentHeight - itemList.scrollFrame:GetHeight())
            )
        )
    end
)




itemList.contentFrame = contentFrame

local tabButtonsScrollFrame = CreateFrame("ScrollFrame", "CustomShop_TabButtonsScrollFrame", categoryList)
tabButtonsScrollFrame:SetSize(150, categoryList:GetHeight() - 10)
tabButtonsScrollFrame:SetPoint("TOPLEFT", categoryList, "TOPLEFT", 5, -5)

local tabButtonsContentFrame = CreateFrame("Frame", nil, tabButtonsScrollFrame)
tabButtonsScrollFrame:SetScrollChild(tabButtonsContentFrame)

local tabButtonsScrollBar =
    CreateFrame("Slider", "CustomShop_TabButtonsScrollBar", tabButtonsScrollFrame, "UIPanelScrollBarTemplate")
tabButtonsScrollBar:SetPoint("TOPLEFT", categoryList, "TOPRIGHT", -20, -20)
tabButtonsScrollBar:SetPoint("BOTTOMLEFT", categoryList, "BOTTOMRIGHT", -20, 20)
tabButtonsScrollBar:SetMinMaxValues(0, 1)
tabButtonsScrollBar:SetValueStep(1)
tabButtonsScrollBar.scrollStep = 1
tabButtonsScrollBar:SetValue(0)
tabButtonsScrollBar:SetWidth(16)
-- tabButtonsScrollBar:SetAlpha(1)
tabButtonsScrollFrame:EnableMouseWheel(true)
tabButtonsScrollFrame:SetScript(
    "OnMouseWheel",
    function(self, delta)
        local currentValue = tabButtonsScrollBar:GetValue()
        local newValue = currentValue - (delta * 30)            -- Change '30' to adjust the scroll speed
        local contentHeight = itemList.contentFrame:GetHeight() -- Get the content height from itemList.contentFrame
        tabButtonsScrollBar:SetValue(
            math.min(
                math.max(newValue, 0),
                -- TODO - Replace 10000 with the height of the content frames
                -- math.max(0, 10000 - tabButtonsScrollFrame:GetHeight())
                math.max(0, contentHeight - tabButtonsScrollFrame:GetHeight())
            )
        )
    end
)

tabButtonsScrollBar:SetScript(
    "OnValueChanged",
    function(self, value)
        tabButtonsScrollFrame:SetVerticalScroll(value)
    end
)
local contentHeight = #customRacial.tabInfo *
    30 -- Assuming each tab button has a height of 30 units (including spacing)
tabButtonsContentFrame:SetSize(tabButtonsScrollFrame:GetWidth(), contentHeight)
tabButtonsScrollBar:SetMinMaxValues(0, math.max(0, contentHeight - tabButtonsScrollFrame:GetHeight()))

local function UpdateTabButtonsScrollBarVisibility()
    if contentHeight > tabButtonsScrollFrame:GetHeight() then
        tabButtonsScrollBar:Show()
    else
        tabButtonsScrollBar:Hide()
    end
end
UpdateTabButtonsScrollBarVisibility()





local function CreateTabButton(id, text, onClick)
    local button = CreateFrame("Button", nil, tabButtonsContentFrame, "UIPanelButtonTemplate")
    button:SetSize(120, 25)
    button:SetText(text)
    button:SetPoint("TOPLEFT", 0, -35 - (id - 1) * 30)
    button:SetScript("OnClick", onClick)
    return button
end


local function createItemButton(parent, index, id, text, icon, onClick, itemType, costType, cost)
    local button = CreateFrame("Button", nil, parent)
    button:SetSize(120, 25)
    button:EnableMouse(true)

    -- button:SetPoint("TOPLEFT", 0, -5 - (index - 1) * 35)
    local numColumns = 4
    local xIndex = (index - 1) % numColumns
    local yIndex = math.floor((index - 1) / numColumns)

    local xOffset = xIndex * 145
    -- local xOffset = xIndex * 130
    local yOffset = -5 - yIndex * 35

    button:SetPoint("TOPLEFT", xOffset, yOffset)
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



    button:SetScript("OnClick", onClick)
    button:SetScript(
        "OnEnter",
        function(self)
            itemTooltip:SetOwner(self, "ANCHOR_CURSOR")
            if itemType == "spell" then
                local spellName, _, spellIcon = GetSpellInfo(id)
                if spellName then
                    -- itemTooltip:SetSpellByID(id)
                    itemTooltip:SetHyperlink("spell:" .. id)
                else
                    itemTooltip:SetText("Unknown spell ID: " .. id, 1, 1, 1, 1, true)
                end
            elseif itemType == "item" then
                itemTooltip:SetHyperlink("item:" .. id)
            else
                itemTooltip:SetText("Invalid item type: " .. tostring(itemType), 1, 1, 1, 1, true)
            end
            if self.active then
                itemTooltip:AddLine("This spell is active", 0, 1, 0)
            else
                itemTooltip:AddLine("This spell is not active", 1, 0, 0)
            end
            itemTooltip:Show()
        end
    )





    button:SetScript(
        "OnLeave",
        function()
            itemTooltip:Hide()
        end
    )
    button:SetScript(
        "OnClick",
        function(self)
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
            for _, spellInfo in ipairs(customRacial.racialSpells[categoryId]) do
                if IsSpellKnown(spellInfo.id) then
                    maxActive = maxActive + 1
                end
            end

            -- Check if the number of active spells is less than the maximum number allowed
            local spellCategory = customRacial.tabInfo[categoryId].name:lower()
            local maximumActive = customRacial.maxActiveSpells[spellCategory]
            if maxActive < maximumActive then
                -- Check if the racial spell is currently active
                if not self.active then
                    -- Activate the racial spell and set the active flag to true
                    AIO.Handle("racialSwitch", "racialActivate", id)
                    self.active = true
                else
                    -- Deactivate the racial spell and set the active flag to false
                    AIO.Handle("racialSwitch", "racialDeactivate", id)
                    self.active = false
                end
            else
                -- If the number of active spells is already at the maximum, check if the current racial spell is active
                if self.active then
                    -- Deactivate the current racial spell and set the active flag to false
                    AIO.Handle("racialSwitch", "racialDeactivate", id)
                    self.active = false
                else
                    -- Print a message indicating that the maximum number of active spells has been reached
                    print(string.format("You can only have %d active %s racial spells", maximumActive, spellCategory))
                end
            end

            -- Manually call the OnEnter script to update the tooltip
            self:GetScript("OnEnter")(self)
        end
    )

    button:SetScript(
        "OnUpdate",
        function(self, elapsed, ...) -- Attach the update function to the model
            if IsSpellKnown(id) then
                -- set button to alpha 1
                self:SetAlpha(1)
                self.active = true
                -- check if overlay texture exists if not create it
                if not self.overlay then
                    self.overlay = self:CreateTexture(nil, "OVERLAY")
                    -- self.overlay:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")

                    -- Adjust the texture coordinates to fit the button size and position
                    -- self.overlay:SetTexCoord(14 / 64, 50 / 64, 14 / 64, 50 / 64)

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




    -- Set the OnDragStart script for the button
    button:SetScript(
        "OnDragStart",
        function(self)
            PickupSpell(id)
        end
    )

    -- Set the OnDragStop script for the button
    button:SetScript(
        "OnDragStop",
        function(self)
            -- ClearCursor()
        end
    )



    button:SetAttribute("itemType", itemType)
    button:SetAttribute("itemCost", cost)
    button:SetAttribute("costType ", costType)
    button:SetAttribute("cost", cost)

    table.insert(customRacial.racialButtons, button)

    button.costLabel = costLabel
    return button, costLabel
end




local function ItemButton_OnClick(self, button)
    -- Handle item click, e.g., display item details or initiate purchase
    local itemID = self:GetID()
    local itemType = self:GetAttribute("itemType")
    local itemCost = self:GetAttribute("itemCost")
    local costType = self:GetAttribute("costType")

    print("itemID: " .. itemID)

    -- local quantity = tonumber(quantityInput:GetNumber()) or 1
    -- local quantity = itemList.quantityInput:GetNumber()
    -- local totalCost = itemCost * quantity
    -- ShowConfirmPurchasePopup(itemID, itemType, quantity, costType, totalCost)
end



local function PopulateList(tabID)
    if not customRacial.tabInfo[tabID] then
        return print("No tab info for tabID: " .. tabID)
    end
    local fakeName = "" -- This is a workaround for the GetItemInfo() function

    -- Reset the scrollbar position
    itemList.scrollFrame:SetVerticalScroll(0)

    -- Calculate the required height of the contentFrame based on the number of items
    local items = customRacial.racialSpells[tabID]

    local contentHeight = #items * 35 -- Assuming each item has a height of 35 units (including spacing)
    itemList.contentFrame:SetSize(itemList.scrollFrame:GetWidth(), contentHeight)
    -- Update the contentFrame's height
    itemList.contentFrame:SetSize(itemList.scrollFrame:GetWidth(), contentHeight)

    -- Update the scrollbar's values based on the content frame's height
    local slider = _G[itemList.scrollFrame:GetName() .. "ScrollBar"]
    slider:SetMinMaxValues(0, math.max(0, contentHeight - itemList.scrollFrame:GetHeight()))
    slider:SetValue(0)

    -- Show the scrollbar only if the contentHeight is greater than the scrollFrame's height
    if contentHeight > itemList.scrollFrame:GetHeight() then
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
        -- print("Populating list with items")
        for i, item in ipairs(items) do
            -- print(i, item.id, item.name, item.icon, item.itemType, item.costType, item.cost)
            local icon
            if item.itemType == "item" then
                icon = GetItemIcon(item.id)
                fakeName = GetItemInfo(item.id)
            elseif item.itemType == "spell" then
                local spellTexture = select(3, GetSpellInfo(item.id))
                icon = spellTexture
                fakeName = GetSpellInfo(item.id)
            end
            -- Set name fakename for items and spells
            local button =
                createItemButton(
                    itemList.contentFrame,
                    i,
                    item.id,
                    fakeName,
                    icon,
                    ItemButton_OnClick,
                    item.itemType,
                    item.CostType,
                    item.cost
                )

            button:SetAttribute("costType", item.costType)
            button:SetAttribute("itemCost", item.cost)



            button:SetID(item.id)
            table.insert(customRacial.racialButtons, button)
        end
    end
end
-- load first tab
PopulateList(1)

local function TabButton_OnClick(self)
    local tabID = self:GetID()

    --    if there is no item in tab then return
    if not customRacial.racialSpells[tabID] then
        return print("No items in tabID: " .. tabID)
    end

    -- Handle tab click, e.g., fetch items from server or update UI
    -- print("Tab clicked:", tabID)
    PopulateList(tabID)
end

for i, tab in ipairs(customRacial.tabInfo) do
    local button = CreateTabButton(tab.id, tab.name, TabButton_OnClick)
    button:SetID(tab.id)
end



local f = CreateFrame("Frame")
f:SetScript("OnEvent", OnEvent)
f:RegisterEvent("CHAT_MSG_ADDON")


SLASH_CUSTOMRACIAL1 = "/customracial"
SlashCmdList["CUSTOMRACIAL"] = function()
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        mainFrame:Show()
    end
end


-- add icon on worldframe for easy access
local icon = CreateFrame("Button", nil, WorldFrame)
icon:SetSize(32, 32)
icon:SetPoint("TOP", WorldFrame, "TOP", 100, -40)

-- icon:SetNormalTexture("Interface\\Icons\\wowtoken")
-- set a racial icon
icon:SetNormalTexture("Interface\\Icons\\spell_nature_undyingstrength")


local tex = icon:CreateFontString(nil, "OVERLAY")
tex:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
tex:SetPoint("CENTER", icon, "BOTTOM", 0, -5)
tex:SetText("Custom Racial")
icon:SetFrameStrata("HIGH")
icon:SetClampedToScreen(true)
icon:SetScript(
    "OnClick",
    function(self, button, down)
        if mainFrame:IsShown() then
            mainFrame:Hide()
        else
            mainFrame:Show()
            -- AIO.Msg():Add("CustomShop", "GetCategories"):Send()
        end
    end
)
icon:SetScript(
    "OnEnter",
    function(self)
        icon:SetAlpha(1)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Click to open Custom Racial")
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
    icon:SetPoint("TOP", WorldFrame, "TOP", 0, -100)
end

-- Function to unlearn spells and clear the active state
local function resetSpells()
    for tabIndex, spellList in ipairs(customRacial.racialSpells) do
        for _, spellInfo in ipairs(spellList) do
            if IsSpellKnown(spellInfo.id) then
                -- Unlearn the spell (assuming you have a function to unlearn spells, replace with the actual function)
                AIO.Handle("racialSwitch", "unLearnAllRacials", spellInfo.id)

                -- Clear the active state for the button associated with this spell
                local button = customRacial.racialButtons[tabIndex][spellInfo.id]
                if button then
                    button.active = false
                    button:SetAlpha(0.5)
                    if button.overlay then
                        button.overlay:Hide()
                    end
                end
            end
        end
    end
end

-- Create the reset button
local resetButton = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
resetButton:SetSize(100, 30)
resetButton:SetPoint("BOTTOMLEFT", mainFrame, "BOTTOMLEFT", 10, 10)
resetButton:SetText("Reset")

-- Set the OnClick script for the reset button to call the resetSpells function
resetButton:SetScript("OnClick", function(self)
    resetSpells()
end)
