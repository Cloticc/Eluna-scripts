-- AIO for TrinityCore 3.3.5 with WoW client 3.3.5
local AIO = AIO or require("AIO")

if AIO.AddAddon() then
    return
end

local BankSystemHandler = AIO.AddHandlers("BankSystem", {})

local BankAddon = CreateFrame("Frame", "BankAddonFrame", UIParent)
-- BankAddon:SetSize(300, 300 * (250 / 300))
BankAddon:SetSize(256, 512)
BankAddon:SetPoint("CENTER")
-- BankAddon:SetBackdrop({
--     bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
--     edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
--     edgeSize = 16,
--     insets = {
--         left = 8,
--         right = 6,
--         top = 8,
--         bottom = 8
--     }
-- })

-- (0.016655236, 0.9946494, 0.20685892, 0.7942723) texturecord 
-- "J:\wowStuff\Wotlk3.3.5Local\Data\patch-Z.MPQ\Interface\Upgrader\bg.blp"
local bankAddonTexture = BankAddon:CreateTexture(nil, "BACKGROUND")
bankAddonTexture:SetAllPoints(BankAddon)
bankAddonTexture:SetTexture("Interface\\BankUI\\bg.blp")

BankAddon:SetBackdropBorderColor(0, 0, 0)
BankAddon:SetBackdropColor(0, 0, 0, 0.5)
BankAddon:Hide()

BankAddon.title = BankAddon:CreateFontString(nil, "OVERLAY")
BankAddon.title:SetFontObject("GameFontHighlight")
BankAddon.title:SetPoint("TOP", BankAddon, "TOP", 0, -110)
BankAddon.title:SetText("Bank")

BankAddon.goldText = BankAddon:CreateFontString(nil, "OVERLAY")
BankAddon.goldText:SetFontObject("GameFontHighlight")
BankAddon.goldText:SetPoint("TOP", BankAddon.title, "BOTTOM", 0, -25)
BankAddon.goldText:SetText("Gold in bank: 0")
-- Close button handle reset the loading bar and enable the action button
BankAddon.closeButton = CreateFrame("Button", nil, BankAddon, "UIPanelCloseButton")
BankAddon.closeButton:SetPoint("TOPRIGHT", BankAddon, "TOPRIGHT", -5, -108)
BankAddon.closeButton:SetNormalTexture("Interface\\BankUI\\closeNormal")
BankAddon.closeButton:SetHighlightTexture("Interface\\BankUI\\closeHover")
BankAddon.closeButton:SetSize(16, 16)
BankAddon.closeButton:SetScript("OnClick", function()
    BankAddon.loadingBar:SetScript("OnUpdate", nil)
    BankAddon.loadingBar:Reset()
    BankAddon.actionButton:Enable()
    BankAddon:Hide()
end)

local function CreateInputBox(name, parent, width, height, point, relativeTo, relativePoint, xOffset, yOffset)
    local inputBox = CreateFrame("EditBox", name, parent, "InputBoxTemplate")
    inputBox:SetSize(width, height)
    inputBox:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
    inputBox:SetAutoFocus(false)
    inputBox:SetNumeric(true)
    return inputBox
end

local function CreateButton(name, parent, width, height, point, relativeTo, relativePoint, xOffset, yOffset, text,
    onClick)
    local button = CreateFrame("Button", name, parent, "GameMenuButtonTemplate")
    button:SetSize(width, height)
    button:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
    button:SetText(text)
    button:SetNormalFontObject("GameFontNormalLarge")
    button:SetHighlightFontObject("GameFontHighlightLarge")
    button:SetScript("OnClick", onClick)
    return button
end

local function CreateDropdown(name, parent, width, height, point, relativeTo, relativePoint, xOffset, yOffset, items,
    onSelect)
    local dropdown = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate")
    dropdown:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
    UIDropDownMenu_SetWidth(dropdown, width)
    UIDropDownMenu_Initialize(dropdown, function(self, level, menuList)
        for _, item in ipairs(items) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = item
            info.func = function()
                UIDropDownMenu_SetSelectedName(dropdown, item)
                onSelect(item)
                -- Clear the checked state for all items
                for _, i in ipairs(items) do
                    if i == item then
                        info.checked = true
                    else
                        info.checked = false
                    end
                end
                -- Refresh the dropdown menu to update the checked state
                UIDropDownMenu_Refresh(dropdown)
            end
            info.checked = (UIDropDownMenu_GetSelectedName(dropdown) == item)
            UIDropDownMenu_AddButton(info)
        end
    end)

    return dropdown
end

local action = "Deposit"
BankAddon.actionDropdown = CreateDropdown("DepWith", BankAddon, 140, 40, "TOP", BankAddon.goldText, "BOTTOM", 0, -10,
    {"Deposit", "Withdraw"}, function(selected)
        action = selected
    end)

-- Set the default value explicitly to "Deposit" since the dropdown menu doesn't have a default value
UIDropDownMenu_SetSelectedName(BankAddon.actionDropdown, "Deposit")
BankAddon.amountBox = CreateInputBox(nil, BankAddon, 140, 40, "TOP", BankAddon.actionDropdown, "BOTTOM", 0, -10)
-- Function to update the loading bar progress
local function updateLoadingBar(progress)
    local maxWidth = BankAddon.loadingBar:GetWidth() - 8
    local newWidth = maxWidth * progress
    BankAddon.loadingBar:SetProgress(progress)
    local percentage = math.floor(progress * 100)
    BankAddon.loadingBar.percentage:SetText(percentage .. "%")

    if progress > 0 and progress < 1 then
        BankAddon.loadingBar.spark:SetPoint("LEFT", BankAddon.loadingBar.texture, "RIGHT", -10, 0)
        BankAddon.loadingBar.spark:Show()
    else
        BankAddon.loadingBar.spark:Hide()
    end
end

-- Function to handle the loading process
local function applyLoadingProcess(duration, callback)
    local startTime = GetTime()
    local function onUpdate()
        local currentTime = GetTime()
        local elapsed = currentTime - startTime
        local progress = elapsed / duration
        updateLoadingBar(progress)
        if progress >= 1 then
            BankAddon.loadingBar:SetScript("OnUpdate", nil)
            BankAddon.loadingBar.spark:Hide() -- Hide the spark when loading is complete
            callback()
        end
    end
    BankAddon.loadingBar:SetScript("OnUpdate", onUpdate)
end

-- Create the loading bar frame and texture
local function CreateLoadingBar(parent)
    local loadingBarFrame = CreateFrame("Frame", "LoadingBarFrame", parent)
    loadingBarFrame:SetSize(200, 20) -- Adjust size as needed
    loadingBarFrame:SetPoint("CENTER", parent, "CENTER", 0, -100)
    loadingBarFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {
            left = 4,
            right = 4,
            top = 4,
            bottom = 4
        }
    })
    loadingBarFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.9)

    local loadingBarTexture = loadingBarFrame:CreateTexture(nil, "OVERLAY")
    -- loadingBarTexture:SetTexture("Interface\\Buttons\\GREENGRAD64") -- Set the texture to a green gradient
    loadingBarTexture:SetTexture("Interface\\Buttons\\BLUEGRAD64") -- Set the texture to a blue gradient
    loadingBarTexture:SetPoint("LEFT", loadingBarFrame, "LEFT", 4, 0)
    loadingBarTexture:SetSize(0, 10) -- Initial size is 0
    -- If you don't have a blue gradient texture, you can set the color of the existing texture to blue
    -- loadingBarTexture:SetColorTexture(0, 0, 1, 1) -- Set to blue color

    local loadingBarPercentage = loadingBarFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    loadingBarPercentage:SetPoint("CENTER", loadingBarFrame, "CENTER", 0, 0)
    loadingBarPercentage:SetText("0%")

    local loadingBarSpark = loadingBarFrame:CreateTexture(nil, "OVERLAY")
    loadingBarSpark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
    loadingBarSpark:SetBlendMode("ADD")
    loadingBarSpark:SetWidth(20)
    loadingBarSpark:SetHeight(loadingBarFrame:GetHeight() * 2)
    loadingBarSpark:SetPoint("LEFT", loadingBarTexture, "RIGHT", -10, 0)

    function loadingBarFrame:SetProgress(progress)
        local width = (loadingBarFrame:GetWidth() - 8) * progress
        loadingBarTexture:SetWidth(width)
        loadingBarPercentage:SetText(math.floor(progress * 100) .. "%")
        loadingBarSpark:SetPoint("LEFT", loadingBarTexture, "RIGHT", -10, 0)
    end

    function loadingBarFrame:Reset()
        loadingBarTexture:SetWidth(-1)
        loadingBarPercentage:SetText("0%")
        loadingBarSpark:SetPoint("LEFT", loadingBarTexture, "RIGHT", -10, 0)
        loadingBarSpark:Hide() -- Hide the spark when resetting the loading bar
    end

    -- Assign the created elements to the loadingBarFrame object
    loadingBarFrame.texture = loadingBarTexture
    loadingBarFrame.percentage = loadingBarPercentage
    loadingBarFrame.spark = loadingBarSpark

    return loadingBarFrame
end

-- Create the loading bar for BankAddon
BankAddon.loadingBar = CreateLoadingBar(BankAddon)
BankAddon.loadingBar:Show()

BankAddon.actionButton = CreateButton(nil, BankAddon, 140, 40, "TOP", BankAddon.amountBox, "BOTTOM", 0, -10, "Submit",
    function()
        local amount = BankAddon.amountBox:GetNumber()
        if amount > 0 then
            BankAddon.actionButton:Disable()
            BankAddon.loadingBar:Reset()
            -- BankAddon.amountBox:SetText("") 
            BankAddon.amountBox:ClearFocus()
            applyLoadingProcess(3, function()
                BankAddon.actionButton:Enable()
                -- BankAddon.amountBox:SetText("") 
                BankAddon.amountBox:ClearFocus()
                if action == "Deposit" then
                    AIO.Handle("BankSystem", "DepositGold", amount)
                elseif action == "Withdraw" then
                    AIO.Handle("BankSystem", "WithdrawGold", amount)
                end
            end)
        else
            print("Please enter a valid amount of gold.")
        end
    end)

-- Function to update the displayed gold amount in the bank
function BankAddon:UpdateGold(amount)
    BankAddon.goldText:SetText("Gold in bank: " .. amount)
end

-- Define the slash command
SLASH_BANK1 = "/bank"

SlashCmdList["BANK"] = function()
    AIO.Handle("BankSystem", "RequestGoldAmount")
    BankAddon:Show()
    BankAddon.loadingBar:Reset()
end

-- Register a handler to update the gold amount
function BankSystemHandler.UpdateGoldAmount(player, amount)
    BankAddon:UpdateGold(amount)
end
