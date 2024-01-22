-- Should be self explanatory, if not, ask me on discord.
-- If you want to add more tabs, just add more to the tabsInfo table. Scrollbar will be added automatically if needed. same for item table if it reached a certain size.
-- If you want to add more items to a tab, just add more to the itemsInfo table. "the name"  can be ingored it's mostly to remind you what the item is.
-- item type can be "item" or "spell" (as it's displayed diffrantly in wow api.


local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end




local createdButtons = {} -- this is a table that will hold all the buttons that are created to update prices and such

local tabsInfo = {
    { id = 0, name = "Home" },
    { id = 1, name = "Services" },
    { id = 2, name = "Toys" },
    { id = 3, name = "Mounts" },
    { id = 4, name = "Pets" },
    -- add more tabs as needed
    { id = 5, name = "General Vendor" } -- example




}

-- loop tabs to add more with general + 1 incremnt to test tab system
-- for i = 6, 50 do  -- -- debug testing tab system
--     table.insert(tabsInfo, { id = i, name = "General " .. i })
-- end

-- the "name" can be ingored it's not being used really atm u can just use the id of the item and it will display the name of the item
local itemsInfo = {
    [0] = {
        -- Home tab
        { id = 49623, name = "This is a item", itemType = "item", costType = "Honor Points",    cost = 125 },    --shadowmoruse
        { id = 49623, name = "This is a item", itemType = "item", costType = "Arena Points",    cost = 2325 },   --shadowmoruse
        { id = 49623, name = "This is a item", itemType = "item", costType = "Donation Points", cost = 25 },     --shadowmoruse
        { id = 49623, name = "This is a item", itemType = "item", costType = "Vote Points",     cost = 5 },      --shadowmoruse
        { id = 46017, name = "This is a item", itemType = "item", costType = "gold",            cost = 3948573 } --val'anyr, hammer of ancient kings
    },
    [1] = {
        --  Services tab
        { id = 49623, name = "This is a item",  itemType = "item",  costType = "gold", cost = 34563 },
        { id = 4540,  name = "This is a item",  itemType = "item",  costType = "gold", cost = 123 },
        { id = 80871, name = "this is a spell", itemType = "spell", costType = "gold", cost = 0 },
        { id = 80871, name = "this is a spell", itemType = "spell", costType = "gold", cost = 10000 },
        { id = 159,   name = "This is a item",  itemType = "item",  costType = "gold", cost = 32434 },
        { id = 80871, name = "this is a spell", itemType = "spell", costType = "gold", cost = 23423 },
        { id = 46017, name = "This is a item",  itemType = "item",  costType = "gold", cost = 5000000 },
        { id = 80871, name = "this is a spell", itemType = "spell", costType = "gold", cost = 500 },
        { id = 46017, name = "This is a item",  itemType = "item",  costType = "gold", cost = 345345 },
        { id = 80871, name = "this is a spell", itemType = "spell", costType = "gold", cost = 500 }
    },
    [2] = {
        -- Toys tab
        { id = 49693, name = "This is a item", itemType = "item", costType = "gold", cost = 500 }
    },
    [3] = {
        -- Mounts tab
        { id = 32458, name = "This is a item", itemType = "item", costType = "gold", cost = 500 }
    },
    [4] = {
        -- Pets tab
        { id = 49693, name = "This is a item", itemType = "item", costType = "gold", cost = 500 },
        { id = 49693, name = "This is a item", itemType = "item", costType = "gold", cost = 500 }
    },
    [5] = { -- example
        -- ERP toys tab
        -- { id = 49693, name = "This is a item", itemType = "item", costType = "gold", cost = 500 },
        --  set all ID to numbers above
        { id = 858,   name = "This is a item", itemType = "item", costType = "gold", cost = 254998 },
        { id = 3371,  name = "This is a item", itemType = "item", costType = "gold", cost = 803053 },
        { id = 3372,  name = "This is a item", itemType = "item", costType = "gold", cost = 692169 },
        { id = 5565,  name = "This is a item", itemType = "item", costType = "gold", cost = 274159 },
        { id = 8925,  name = "This is a item", itemType = "item", costType = "gold", cost = 547576 },
        { id = 16583, name = "This is a item", itemType = "item", costType = "gold", cost = 683818 },
        { id = 17020, name = "This is a item", itemType = "item", costType = "gold", cost = 622137 },
        { id = 17021, name = "This is a item", itemType = "item", costType = "gold", cost = 931629 },
        { id = 17026, name = "This is a item", itemType = "item", costType = "gold", cost = 468447 },
        { id = 17028, name = "This is a item", itemType = "item", costType = "gold", cost = 618947 },
        { id = 17029, name = "This is a item", itemType = "item", costType = "gold", cost = 555586 },
        { id = 17030, name = "This is a item", itemType = "item", costType = "gold", cost = 905373 },
        { id = 17031, name = "This is a item", itemType = "item", costType = "gold", cost = 606401 },
        { id = 17032, name = "This is a item", itemType = "item", costType = "gold", cost = 334286 },
        { id = 17033, name = "This is a item", itemType = "item", costType = "gold", cost = 049105 },
        { id = 17034, name = "This is a item", itemType = "item", costType = "gold", cost = 558793 },
        { id = 17035, name = "This is a item", itemType = "item", costType = "gold", cost = 805554 },
        { id = 17036, name = "This is a item", itemType = "item", costType = "gold", cost = 149825 },
        { id = 17037, name = "This is a item", itemType = "item", costType = "gold", cost = 002593 },
        { id = 18256, name = "This is a item", itemType = "item", costType = "gold", cost = 380967 },
        { id = 21177, name = "This is a item", itemType = "item", costType = "gold", cost = 124273 },
        { id = 22147, name = "This is a item", itemType = "item", costType = "gold", cost = 280597 },
        { id = 22148, name = "This is a item", itemType = "item", costType = "gold", cost = 518288 },
        { id = 37201, name = "This is a item", itemType = "item", costType = "gold", cost = 913423 },
        { id = 40411, name = "This is a item", itemType = "item", costType = "gold", cost = 295801 },
    },

}

-----------------------------------------------------------------------------------------------

local itemTooltip = CreateFrame("GameTooltip", "CustomShopTooltip", UIParent, "GameTooltipTemplate")
itemTooltip:SetScale(1)
itemTooltip:SetClampedToScreen(true)

-----------------------------------------------------------------------------------------------

local mainFrame = CreateFrame("Frame", "CustomShopMainFrame", UIParent, "UIPanelDialogTemplate")
mainFrame:SetSize(800, 500)
mainFrame:SetPoint("CENTER")
-- mainFrame:SetBackdrop(
--     {
--         bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
--         edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
--         tile = true,
--         tileSize = 32,
--         edgeSize = 32,
--         insets = { left = 11, right = 12, top = 12, bottom = 11 }
--     }
-- )
mainFrame:SetMovable(true)
mainFrame:EnableMouse(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)
mainFrame:SetClampedToScreen(true)
-- mainFrame:Show()
mainFrame:Hide()



local quantityInput = CreateFrame("EditBox", "CustomShop_QuantityInput", mainFrame, "InputBoxTemplate")
quantityInput:SetAutoFocus(false)
quantityInput:SetWidth(50)
quantityInput:SetHeight(20)
quantityInput:SetPoint("BOTTOMRIGHT", -30, 30)
quantityInput:SetNumeric(true)
quantityInput:SetMaxLetters(3)
quantityInput:SetNumber(1) -- Set default quantity to 1
quantityInput:SetCursorPosition(0)
--set name left side saying quantity
local quantityLabel = quantityInput:CreateFontString(nil, "OVERLAY", "GameFontNormal")
quantityLabel:SetText("Quantity:")
quantityLabel:SetPoint("RIGHT", quantityInput, "LEFT", -5, 0)
-- quantityLabel:SetPoint("BOTTOMLEFT", quantityInput, "TOPLEFT", 0, 0)
-- get quantity and set a attribute
quantityInput:SetScript(
    "OnTextChanged",
    function(self)
        local quantity = tonumber(self:GetText())
        if quantity then
            self:SetAttribute("quantity", quantity)
        end
    end
)


local titleBar = mainFrame:CreateTexture(nil, "ARTWORK")
titleBar:SetTexture("Interface/DialogFrame/UI-DialogBox-Header")
titleBar:SetWidth(300)
titleBar:SetHeight(64)
titleBar:SetPoint("TOP", 0, 30)

local title = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("TOP", titleBar, "TOP", 0, -14)
title:SetText("Custom In-Game Shop")





local categoryList = CreateFrame("Frame", "categoryList", mainFrame)
categoryList:SetSize(mainFrame:GetWidth() - 650, mainFrame:GetHeight() - 150)
categoryList:SetPoint("TOPLEFT", 15, -35)
categoryList:SetBackdrop(
    {
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    }
)
categoryList:SetBackdropColor(0, 0, 0, 0.8)

local itemList = CreateFrame("Frame", nil, mainFrame)
itemList:SetSize(mainFrame:GetWidth() - 250, mainFrame:GetHeight() - 150)
itemList:SetPoint("TOPRIGHT", -15, -35)
itemList:SetBackdrop(
    {
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    }
)
itemList:SetBackdropColor(0, 0, 0, 0.8)

local scrollFrame = CreateFrame("ScrollFrame", "CustomShop_ScrollFrame", itemList, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", itemList, "TOPLEFT", 10, -10)
scrollFrame:SetPoint("BOTTOMRIGHT", itemList, "BOTTOMRIGHT", -30, 10)
itemList.scrollFrame = scrollFrame

local contentFrame = CreateFrame("Frame", nil, scrollFrame)
contentFrame:SetSize(scrollFrame:GetSize())
scrollFrame:SetScrollChild(contentFrame)
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
        local newValue = currentValue - (delta * 30) -- Change '30' to adjust the scroll speed
        tabButtonsScrollBar:SetValue(
            math.min(
                math.max(newValue, 0),
                -- TODO - Replace 10000 with the height of the content frames
                math.max(0, 10000 - tabButtonsScrollFrame:GetHeight())
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
local contentHeight = #tabsInfo * 30 -- Assuming each tab button has a height of 30 units (including spacing)
tabButtonsContentFrame:SetSize(tabButtonsScrollFrame:GetWidth(), contentHeight)
tabButtonsScrollBar:SetMinMaxValues(0, math.max(0, contentHeight - tabButtonsScrollFrame:GetHeight()))
local function UpdateTabButtonsScrollBarVisibility()
    if contentHeight > tabButtonsScrollFrame:GetHeight() then
        tabButtonsScrollBar:Show()
    else
        tabButtonsScrollBar:Hide()
    end
end

-- add text to the left side bottom saying "Be warned to buy a lot of items if u dont have enought space in your bags it will be deleted"
local warningText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
warningText:SetPoint("BOTTOMLEFT", 15, 15)
warningText:SetText("Be warned to buy a lot of items if you dont have enought space in your bags it might be deleted")







UpdateTabButtonsScrollBarVisibility()

local function CreateTabButton(id, text, onClick)
    local button = CreateFrame("Button", nil, tabButtonsContentFrame, "UIPanelButtonTemplate")
    button:SetSize(120, 25)
    button:SetText(text)
    button:SetPoint("TOPLEFT", 0, -35 - (id - 1) * 30)
    button:SetScript("OnClick", onClick)
    return button
end

local function CreateItemButton(parent, index, id, text, icon, onClick, itemType, costType, cost, quantity)
    local button = CreateFrame("Button", nil, parent)

    button:SetSize(350, 40)
    -- button:SetSize(32, 32)

    local iconTexture = button:CreateTexture(nil, "ARTWORK")
    iconTexture:SetTexture(icon)
    iconTexture:SetSize(32, 32)
    iconTexture:SetPoint("LEFT", 5, 0)

    local textLabel = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    -- "RIGHT", quantityInput, "LEFT", -5, 0
    -- textLabel:SetPoint("LEFT", iconTexture, "RIGHT", 1, -10)
    textLabel:SetPoint("LEFT", iconTexture, "RIGHT", 10, 0)
    -- set text white
    textLabel:SetTextColor(1, 1, 1, 1)
    -- if text is too long, cut it off
    textLabel:SetWidth(200)
    textLabel:SetHeight(40)
    textLabel:SetWordWrap(true)
    textLabel:SetJustifyH("LEFT")

    textLabel:SetText(text)
    -- textLabel:SetText(text)

    -- textLabel:SetJustifyV("TOP")

    -- textLabel:SetPoint("LEFT", iconTexture, "RIGHT", 10, 0)

    -- button:SetPoint("TOPLEFT", 15, -35 - (index - 1) * 45)
    button:SetPoint("TOPLEFT", 0, -((index - 1) * 45))

    -----------------------------------------------------------------------------------------------

    local costLabel = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    costLabel:SetPoint("LEFT", textLabel, "RIGHT", textLabel:GetWidth() - 85, 0)
    costLabel:SetTextColor(1, 1, 1)

    local quantityLabel1 = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    quantityLabel1:SetPoint("LEFT", textLabel, "RIGHT", 20, 0)
    quantityLabel1:SetTextColor(1, 1, 1, 1)




    button:SetScript("OnClick", onClick)
    button:SetScript(
        "OnEnter",
        function(self)
            itemTooltip:SetOwner(self, "ANCHOR_CURSOR")
            if itemType == "item" then
                itemTooltip:SetHyperlink("item:" .. id)
            elseif itemType == "spell" then
                itemTooltip:SetSpellByID(id)
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

    button:SetAttribute("itemType", itemType)
    button:SetAttribute("itemCost", cost)
    button:SetAttribute("costType ", costType)
    button:SetAttribute("cost", cost)
    table.insert(createdButtons, button)

    button.costLabel = costLabel
    button.quantityLabel1 = quantityLabel1
    return button, costLabel, quantityLabel1
end
-------------------------------
-- [refreshButton]

-- add button to refresh list of items
local refreshButton = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
refreshButton:SetSize(120, 25)
refreshButton:SetText("Refresh")
-- set right side above quantity input box
refreshButton:SetPoint("TOP", quantityInput, "TOP", -15, 30)

refreshButton:SetScript("OnClick", function()
    -- TODO - Refresh the list of items
    print("Refresh button clicked")
    -- reattach the name of items
end)
-------------------------------

-------------------------------
-- [ShowConfirmPurchasePopup]
-- sets up the popup window handle when you click on the buy button
local function ShowConfirmPurchasePopup(itemID, itemType, quantity, costType, totalCost)
    local costText
    if costType == "gold" then
        local gold = math.floor(totalCost / 10000)
        local silver = math.floor((totalCost - (gold * 10000)) / 100)
        local copper = totalCost - (gold * 10000) - (silver * 100)
        costText = gold .. "g " .. silver .. "s " .. copper .. "c"
    elseif costType == "Honor Points" then
        costText = totalCost .. " Honor Points"
    elseif costType == "Arena Points" then
        costText = totalCost .. " Arena Points"
    elseif costType == "Donation Points" then
        costText = totalCost .. " Donation Points"
    elseif costType == "Vote Points" then
        costText = totalCost .. " Vote Points"
    end

    StaticPopupDialogs["CONFIRM_PURCHASE"] = {
        text = "Are you sure you want to purchase x%d %s for " .. costText .. "?",
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            AIO.Handle("CustomShop", "addItemOrSpell", itemID, itemType, quantity, costType, totalCost)
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3
    }

    if itemType == "item" then
        local itemName = GetItemInfo(itemID)
        StaticPopup_Show("CONFIRM_PURCHASE", quantity, itemName, itemID, totalCost)
    elseif itemType == "spell" then
        local spellName = GetSpellInfo(itemID)
        StaticPopup_Show("CONFIRM_PURCHASE", quantity, spellName, itemID, totalCost)
    end
end

-------------------------------

-- [UpdateAllCostLabels]
-- This updates the cost labels for all the buttons when the quantity input box is changed
local function UpdateAllCostLabels()
    local quantity = quantityInput:GetNumber()


    for _, button in ipairs(createdButtons) do
        -- update button cost label

        local costType = button:GetAttribute("costType")
        local itemCost = button:GetAttribute("itemCost")
        local totalCost = itemCost * quantity


        -- setup quantity label
        if quantity > 1 then
            button.quantityLabel1:SetText(quantity .. " x ")
        else
            button.quantityLabel1:SetText("")
        end



        if costType == "gold" then
            local gold = math.floor(totalCost / 10000)
            local silver = math.floor((totalCost - (gold * 10000)) / 100)
            local copper = totalCost - (gold * 10000) - (silver * 100)

            button.costLabel:SetText(gold .. "g " .. silver .. "s " .. copper .. "c")
        elseif costType == "Honor Points" then
            button.costLabel:SetText(totalCost .. " " .. costType)
        elseif costType == "Arena Points" then
            button.costLabel:SetText(totalCost .. " " .. costType)
        elseif costType == "Donation Points" then
            button.costLabel:SetText(totalCost .. " " .. costType)
        elseif costType == "Vote Points" then
            button.costLabel:SetText(totalCost .. " " .. costType)
        end
    end
end

quantityInput:SetScript("OnTextChanged", UpdateAllCostLabels)  -- for live updates
quantityInput:SetScript("OnEnterPressed", UpdateAllCostLabels) -- for when user presses enter
-- quantityInput:SetScript("OnUpdate", UpdateAllCostLabels)       -- for when user clicks on the input box
-----------------------------------------------------------------------------------------------
-- local gold = math.floor(cost / 10000)
-- local silver = math.floor((cost - (gold * 10000)) / 100)
-- local copper = cost - (gold * 10000) - (silver * 100)
local function ItemButton_OnClick(self, button)
    -- Handle item click, e.g., display item details or initiate purchase
    local itemID = self:GetID()
    local itemType = self:GetAttribute("itemType")
    local itemCost = self:GetAttribute("itemCost")
    local costType = self:GetAttribute("costType")

    local quantity = tonumber(quantityInput:GetNumber()) or 1
    -- local quantity = itemList.quantityInput:GetNumber()
    local totalCost = itemCost * quantity
    ShowConfirmPurchasePopup(itemID, itemType, quantity, costType, totalCost)
end




local function PopulateItemList(tabID)
    if not itemsInfo[tabID] then
        return print("No items found for tabID: " .. tabID)
    end
    -- Reset the scrollbar position
    itemList.scrollFrame:SetVerticalScroll(0)

    -- Calculate the required height of the contentFrame based on the number of items
    local items = itemsInfo[tabID]
    local contentHeight = #items * 45 -- Assuming each item has a height of 45 units (including spacing)




    -- Update the contentFrame's height
    itemList.contentFrame:SetHeight(contentHeight)

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

    for i, item in ipairs(items) do
        local id, itemType, costType, cost = item.id, item.itemType, item.CostType, item.cost
        local icon, fakeName

        if item.itemType == "item" then
            icon = GetItemIcon(id)
            fakeName = GetItemInfo(id) or "Unknown Item"
        elseif item.itemType == "spell" then
            local spellTexture = select(3, GetSpellInfo(id))
            icon = spellTexture
            fakeName = GetSpellInfo(id) or "Unknown Spell"
        end

        -- Set name fakename for items and spells
        local button =
            CreateItemButton(
                itemList.contentFrame,
                i,
                id,
                fakeName,
                icon,
                ItemButton_OnClick,
                item.itemType,
                item.CostType,
                item.cost,
                item.quantity
            )
        button:SetID(id)

        button:SetAttribute("costType", item.costType)
        button:SetAttribute("itemCost", item.cost)

        -- local button = CreateItemButton(itemList.contentFrame, i, item.id, item.name, icon, ItemButton_OnClick,
        -- item.itemType, item.cost)
        table.insert(createdButtons, button)
    end
    -- end

    UpdateAllCostLabels()
end


local function TabButton_OnClick(self)
    local tabID = self:GetID()

    -- Handle tab click, e.g., fetch items from server or update UI
    -- print("Tab clicked:", tabID)

    PopulateItemList(tabID)
end

for i, tab in ipairs(tabsInfo) do
    local button = CreateTabButton(tab.id, tab.name, TabButton_OnClick)
    button:SetID(tab.id)
end





local f = CreateFrame("Frame")
f:SetScript("OnEvent", OnEvent)
f:RegisterEvent("CHAT_MSG_ADDON")


SLASH_CUSTOMSHOP1 = "/customshop"
SlashCmdList["CUSTOMSHOP"] = function()
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        mainFrame:Show()
        AIO.Msg():Add("CustomShop", "GetCategories"):Send()
    end
end

tinsert(UISpecialFrames, mainFrame:GetName()) -- allows frame to be closed with escape key
-- add icon on worldframe for easy access
local icon = CreateFrame("Button", nil, WorldFrame)
icon:SetSize(32, 32)
icon:SetPoint("TOP", WorldFrame, "TOP", 0, -100)

icon:SetNormalTexture("Interface\\Icons\\wowtoken")

local tex = icon:CreateFontString(nil, "OVERLAY")
tex:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
tex:SetPoint("CENTER", icon, "BOTTOM", 0, -5)
tex:SetText("Custom Shop")
icon:SetFrameStrata("HIGH")
icon:SetClampedToScreen(true)
icon:SetScript(
    "OnClick",
    function(self, button, down)
        if mainFrame:IsShown() then
            mainFrame:Hide()
        else
            mainFrame:Show()
            AIO.Msg():Add("CustomShop", "GetCategories"):Send()
        end
    end
)
icon:SetScript(
    "OnEnter",
    function(self)
        icon:SetAlpha(1)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Click to open Custom Shop")
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
