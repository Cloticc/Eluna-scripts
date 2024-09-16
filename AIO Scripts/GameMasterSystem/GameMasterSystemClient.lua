-- AIO for TrinityCore 3.3.5 with WoW client 3.3.5
local AIO = AIO or require("AIO")

if AIO.AddAddon() then
    return
end

local GameMasterSystem = AIO.AddHandlers("GameMasterSystem", {})

-- Configuration
local config = {
    debug = true,
    tabs = {{
        name = "Creature",
        content = "Creature Content"
    }, {
        name = "Objects",
        content = "Game Objects"
    }, {
        name = "Tab 3",
        content = "Content for Tab 3"
    }}
}

--  to display debug messages
local function debugMessage(...)
    if config.debug then
        print("DEBUG:", ...)
    end
end


local contentFrames, mainFrame, currentOffset, activeTab

-- create a scroll frame
local function createScrollFrame(parent)
    debugMessage("Creating scroll frame for parent:", parent:GetName())
    local scrollFrame = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
    scrollFrame:SetSize(800, 600)
    scrollFrame:SetPoint("CENTER")

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(800, 600)
    scrollFrame:SetScrollChild(content)

    scrollFrame:EnableMouseWheel(true)
    scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local current = self:GetVerticalScroll()
        local maxScroll = self:GetVerticalScrollRange()
        local newScroll = math.min(maxScroll, math.max(0, current - delta * 20))
        self:SetVerticalScroll(newScroll)
    end)
 
    scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
        self:SetVerticalScroll(offset)
    end)

    -- Add a check in the OnScrollRangeChanged script
    scrollFrame:SetScript("OnScrollRangeChanged", function(self, xrange, yrange)
        if xrange and yrange then
            print("Scroll range changed:", xrange, yrange)
        else
            print("Scroll range changed but one of the values is nil")
        end
    end)

    return scrollFrame, content
end

--  create the main frame
local function createMainFrame()
    debugMessage("Creating main frame")
    local frame = CreateFrame("Frame", "MainFrame", UIParent)
    frame:SetSize(1024, 640)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetClampedToScreen(true)
    frame:Hide()

    local backdrop = {
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {
            left = 4,
            right = 4,
            top = 4,
            bottom = 4
        }
    }
    frame:SetBackdrop(backdrop)
    frame:SetBackdropColor(0, 0.5, 0.5, 1)

    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.title:SetFontObject("GameFontHighlight")
    frame.title:SetPoint("TOP", frame, "TOP", 0, -10)
    frame.title:SetText("Game master tool")

    -- Create the scroll frame
    local scrollFrame, content = createScrollFrame(frame)
    frame.scrollFrame = scrollFrame
    frame.content = content

    debugMessage("Frame created with title:", frame.title:GetText())

    return frame
end

-- creates tabs 
local function createTab(parent, name, index, onClick)
    debugMessage("Creating tab with name:", name, "at index:", index)
    local tab = CreateFrame("Button", nil, parent, "GameMenuButtonTemplate")
    tab:SetSize(100, 30)
    tab:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -30 * index - 10)
    tab:SetText(name)
    tab:SetNormalFontObject("GameFontNormal")
    tab:SetHighlightFontObject("GameFontHighlight")
    tab:SetScript("OnClick", onClick)
    return tab
end

--  create content frames
local function createContentFrames(parent, tabConfig)
    local frames = {}
    if not tabConfig then
        debugMessage("tabConfig is nil")
        return frames
    end

    for i, tab in ipairs(tabConfig) do
        if tab then
            local frame = CreateFrame("Frame", nil, parent)
            frame:SetSize(800, 600)
            frame:SetPoint("CENTER", parent, "CENTER", 0, 0)
            debugMessage("Created frame for tab:", i, "with size 800x600")

            if i == 1 then
                debugMessage("Creating scroll frame for Tab 1")
                -- Create the scroll frame for Tab 1
                local scrollFrame, content = createScrollFrame(frame)
                frame.scrollFrame = scrollFrame
                frame.content = content
                debugMessage("Scroll frame created for Tab 1")
            elseif i == 2 then
                debugMessage("Creating scroll frame for Tab 2")
                -- Create the scroll frame for Tab 2
                local scrollFrame, content = createScrollFrame(frame)
                frame.scrollFrame = scrollFrame
                frame.content = content
                debugMessage("Scroll frame created for Tab 2")
            else
                debugMessage("No scroll frame needed for Tab", i)
            end

            frames[i] = frame
        else
            debugMessage("tab is nil at index:", i)
        end
    end
    return frames
end

-- function to show the selected tab's content
local function showTab(frames, index)
    activeTab = index 
    for i, frame in ipairs(frames) do
        if i == index then
            frame:Show()
            debugMessage("Showing frame for tab:", i)
        else
            frame:Hide()
            debugMessage("Hiding frame for tab:", i)
        end
    end
end

-- Function to generate cards for NPCs
local function generateNpcCards(parent, npcData)
    local cards = {}
    local numColumns = 5
    local cardWidth, cardHeight = 150, 200
    local spacingX, spacingY = 10, 10

    local contentHeight = math.ceil(#npcData / numColumns) * (cardHeight + spacingY)
    parent:SetHeight(contentHeight)

    for i, npc in ipairs(npcData) do
        local card = CreateFrame("Frame", "card" .. i, parent)
        card:SetSize(cardWidth, cardHeight)

        local row = math.floor((i - 1) / numColumns)
        local col = (i - 1) % numColumns
        card:SetPoint("TOPLEFT", parent, "TOPLEFT", 10 + (cardWidth + spacingX) * col,
            -10 - (cardHeight + spacingY) * row)

        card:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
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
        card:SetBackdropColor(0, 0, 0, 0.5)

        -- model placement and size
        local model = CreateFrame("PlayerModel", "modelNpc" .. i, card)
        -- model:SetSize(cardWidth - 20, cardHeight - 70)  
        -- model:SetPoint("TOP", card, "TOP", 0, -10) 
        model:SetSize(cardWidth - 30, cardHeight - 80) 
        model:SetPoint("CENTER", card, "CENTER", 0, -10)
        model:SetFrameStrata("DIALOG")
        model:Show()
        model:ClearModel()
        if model.SetCreature then
            model:SetCreature(npc.creatureId)
            model:SetRotation(0)
            model:SetCamera(0)
            model:SetModelScale(0.8)  
        end

        model:SetBackdrop({
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
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
        model:SetBackdropBorderColor(1, 0, 0, 1) -- Set the border color to red

    
        local nameText = card:CreateFontString(nil, "OVERLAY")
        nameText:SetFontObject("GameFontNormal")
        nameText:SetPoint("TOP", card, "BOTTOM", 0, 50)
        nameText:SetText(npc.name .. "\n" .. (npc.subname or ""))

        local idText = card:CreateFontString(nil, "OVERLAY")
        idText:SetFontObject("GameFontHighlight")
        idText:SetPoint("TOP", nameText, "BOTTOM", 0, -5)
        idText:SetText("Creature ID: " .. npc.creatureId)

        cards[i] = card
    end
    return cards
end

-- function to generate cards for GameObjects
    local function generateCardsForGameObjects(parent, gobData)
        local cards = {}
        local numColumns = 5
        local cardWidth, cardHeight = 150, 200
        local spacingX, spacingY = 10, 10
    
        local contentHeight = math.ceil(#gobData / numColumns) * (cardHeight + spacingY)
        parent:SetHeight(contentHeight)
    
        for i, gob in ipairs(gobData) do
            local card = CreateFrame("Frame", "card" .. i, parent)
            card:SetSize(cardWidth, cardHeight)
    
            local row = math.floor((i - 1) / numColumns)
            local col = (i - 1) % numColumns
            card:SetPoint("TOPLEFT", parent, "TOPLEFT", 10 + (cardWidth + spacingX) * col,
                -10 - (cardHeight + spacingY) * row)
    
            card:SetBackdrop({
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
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
            card:SetBackdropColor(0, 0, 0, 0.5)
    
            -- model placement and size
            local model = CreateFrame("Model", "modelGob" .. i, card)
            model:SetSize(cardWidth - 20, cardHeight - 70)  
            model:SetPoint("TOP", card, "TOP", 0, -10) 
            model:SetFrameStrata("DIALOG")
            model:Show()
            model:ClearModel() 
    
            if model.SetDisplayInfo then
                local displayId = gob.displayid
                if displayId then
                    model:SetDisplayInfo(displayId)
                    model:SetRotation(0)
                    model:SetCamera(0)
                    model:SetModelScale(0.8)  
                end
            end
    
            local displayIdText = card:CreateFontString(nil, "OVERLAY")
            displayIdText:SetFontObject("GameFontNormal")
            displayIdText:SetPoint("TOP", card, "TOP", 0, -10)
            displayIdText:SetText("Display ID: " .. gob.displayid)
    
            local nameText = card:CreateFontString(nil, "OVERLAY")
            nameText:SetFontObject("GameFontNormal")
            nameText:SetPoint("TOP", displayIdText, "BOTTOM", 0, -5)
            nameText:SetText(gob.name)
    
            local idText = card:CreateFontString(nil, "OVERLAY")
            idText:SetFontObject("GameFontHighlight")
            idText:SetPoint("TOP", nameText, "BOTTOM", 0, -5)
            idText:SetText("GameObject ID: " .. gob.entry)
    
            cards[i] = card
        end
        return cards
    end

-- Handler to receive NPC data from the server
function GameMasterSystem.receiveNPCData(player, npcData, offset, pageSize)

    for _, npc in ipairs(npcData) do
        npc.creatureId = npc.entry
    end

    local tab1ContentFrame = contentFrames[1].content
    
    if tab1ContentFrame.cards then
        for _, card in ipairs(tab1ContentFrame.cards) do
            card:Hide()
        end
    end


    tab1ContentFrame.cards = generateNpcCards(tab1ContentFrame, npcData)

    currentOffset = offset

    contentFrames[1].scrollFrame:SetVerticalScroll(0)
end

-- Handler to receive GameObject data from the server
function GameMasterSystem.receiveGameObjectData(player, gobData, offset, pageSize)
    -- debugMessage("Received GameObject Data:", gobData)

    for _, gob in ipairs(gobData) do
        gob.entry = gob.entry
    end

    local tab2ContentFrame = contentFrames[2].content
   
    if tab2ContentFrame.cards then
        for _, card in ipairs(tab2ContentFrame.cards) do
            card:Hide()
        end
    end

    tab2ContentFrame.cards = generateCardsForGameObjects(tab2ContentFrame, gobData)
   
    currentOffset = offset
   
    contentFrames[2].scrollFrame:SetVerticalScroll(0)
end

-- Function to handle pagination
local function createPaginationButtons(parent)
    local nextButton = CreateFrame("Button", nil, parent, "GameMenuButtonTemplate")
    nextButton:SetSize(100, 30)
    nextButton:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -10, 10)
    nextButton:SetText("Next")
    nextButton:SetNormalFontObject("GameFontNormal")
    nextButton:SetHighlightFontObject("GameFontHighlight")
    nextButton:SetScript("OnClick", function()
        currentOffset = currentOffset + 100
        if activeTab == 1 then
            AIO.Handle("GameMasterSystem", "getNPCData", currentOffset, 100)
        elseif activeTab == 2 then
            AIO.Handle("GameMasterSystem", "getGameObjectData", currentOffset, 100)
        end
    end)

    local prevButton = CreateFrame("Button", nil, parent, "GameMenuButtonTemplate")
    prevButton:SetSize(100, 30)
    prevButton:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 10, 10)
    prevButton:SetText("Previous")
    prevButton:SetNormalFontObject("GameFontNormal")
    prevButton:SetHighlightFontObject("GameFontHighlight")
    prevButton:SetScript("OnClick", function()
        currentOffset = math.max(0, currentOffset - 100)
        if activeTab == 1 then
            AIO.Handle("GameMasterSystem", "getNPCData", currentOffset, 100)
        elseif activeTab == 2 then
            AIO.Handle("GameMasterSystem", "getGameObjectData", currentOffset, 100)
        end
    end)
end

-- initialize the UI
local function initializeUI()
    mainFrame = createMainFrame()
    local tabs = {}

    debugMessage("Type of config.tabs:", type(config.tabs))
    debugMessage("Content of config.tabs:", config.tabs)

    contentFrames = createContentFrames(mainFrame, config.tabs)

    for i, tabConfig in ipairs(config.tabs) do
        local tab = createTab(mainFrame, tabConfig.name, i - 1, function()
            showTab(contentFrames, i)
            currentOffset = 0
            if i == 1 then
                AIO.Handle("GameMasterSystem", "getNPCData", currentOffset, 100)
            elseif i == 2 then
                AIO.Handle("GameMasterSystem", "getGameObjectData", currentOffset, 100)
            end
        end)
        tabs[i] = tab
    end

    showTab(contentFrames, 1)
    currentOffset = 0 
    AIO.Handle("GameMasterSystem", "getNPCData", currentOffset, 100) 

    -- Create pagination buttons
    createPaginationButtons(mainFrame)
end

-- open the UI with a slash command
SLASH_GAMEMASTERUI1 = "/gmui"
SlashCmdList["GAMEMASTERUI"] = function(msg)
    if mainFrame then
        if mainFrame:IsShown() then
            mainFrame:Hide()
        else
            mainFrame:Show()
        end
    else
        debugMessage("Game Master UI is not initialized.")
    end
end

debugMessage("Game Master UI can be toggled with /gmui")


initializeUI()
