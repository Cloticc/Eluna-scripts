-- AIO for TrinityCore 3.3.5 with WoW client 3.3.5
local AIO = AIO or require("AIO")

if AIO.AddAddon() then
    return
end

local GameMasterSystem = AIO.AddHandlers("GameMasterSystem", {})
local npcData = {}
local gobData = {}
local spellData = {}
local currentSearchQuery = ""

local contentFrames, mainFrame, currentOffset, activeTab, refreshButton, nextButton, prevButton
-- Configuration
local config = {
    debug = false,
    tabs = {{
        name = "Creature",
        content = "Creature Content"
    }, {
        name = "Objects",
        content = "Game Objects"
    }, {
        name = "Spell",
        content = "Spell Content"
    }},
    bgWidth = 800,
    bgHeight = 600,

    pageSize = 15,
    numColumns = 5,
    numRows = 3

}

-- Define handlers table
local handlers = {
    [1] = {
        get = "getNPCData",
        search = "searchNPCData"
    },
    [2] = {
        get = "getGameObjectData",
        search = "searchGameObjectData"
    },
    [3] = {
        get = "getSpellData",
        search = "searchSpellData"
    }
}
-- Utility function to handle AIO calls
local function handleAIO(activeTab, query, offset, pageSize)
    local handler = handlers[activeTab]
    if query == "" then
        AIO.Handle("GameMasterSystem", handler.get, offset, pageSize)
    else
        AIO.Handle("GameMasterSystem", handler.search, query, offset, pageSize)
    end
end

-- Utility to display debug messages
local function debugMessage(...)
    if config.debug then
        print("DEBUG:", ...)
    end
end

-- Add tooltip to the pagination buttons
local function addSimpleTooltip(button, text)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(text, nil, nil, nil, nil, true)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
end

local function copyIcon(entity)
    local entry = tostring(entity.spellId):match("^%s*(.-)%s*$") -- Trim spaces
    local name, rank, icon = GetSpellInfo(entry)
    if icon then
        local editBox = CreateFrame("EditBox")
        editBox:SetText(tostring(icon))
        editBox:HighlightText()
        editBox:SetScript("OnEscapePressed", function(self)
            self:ClearFocus()
            self:Hide()
        end)
        editBox:SetScript("OnEnterPressed", function(self)
            self:ClearFocus()
            self:Hide()
        end)
        editBox:SetScript("OnEditFocusLost", function(self)
            self:Hide()
        end)
        editBox:Show()
        editBox:SetFocus()
        print("|cff00ff00Icon path highlighted. Press Ctrl+C to copy:|r", icon)
    else
        print("|cffff0000Icon not found for spell ID:|r", entry)
    end
end

-- creates tabs 
-- local function createTab(parent, name, index, onClick)
--     local tab = CreateFrame("Button", name, parent, "GameMenuButtonTemplate")
--     tab:SetSize(100, 30)
--     tab:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -30 * index - 10)
--     tab:SetText(name)
--     tab:SetNormalFontObject("GameFontNormal")
--     tab:SetHighlightFontObject("GameFontHighlight")
--     tab:SetScript("OnClick", onClick)
--     return tab
-- end

-- Create content frames such as NPC, GameObject, Spell, etc.
local function createContentFrames(parent, tabConfig)
    local frames = {}
    if not tabConfig then
        debugMessage("tabConfig is nil")
        return frames
    end

    for i, tab in ipairs(tabConfig) do
        if tab then
            local frame = CreateFrame("Frame", nil, parent)
            frame:SetSize(parent:GetWidth(), parent:GetHeight())
            frame:SetPoint("TOP", parent, "TOP", 0, -40)
            frame:Hide()
            frames[i] = frame
        end
    end
    return frames
end

-- Function to show the selected tab's content
local function showTab(frames, index)
    activeTab = index
    for i, frame in ipairs(frames) do
        if i == index then
            frame:Show()
            -- debugMessage("Showing frame for tab:", i)
        else
            frame:Hide()
            -- debugMessage("Hiding frame for tab:", i)
        end
    end
end

-- Function to handle refresh button click for model preview
local function refreshModels()
    if activeTab == 1 then
        for _, npc in ipairs(npcData) do
            if npc and npc.entry then
                AIO.Handle("GameMasterSystem", "spawnAndDeleteNpcEntity", npc.entry)
            end
        end
        C_Timer.After(0.5, function()
            config.updateNpcCards(npcData)
        end)
    elseif activeTab == 2 then
        for _, gob in ipairs(gobData) do
            if gob and gob.entry then
                AIO.Handle("GameMasterSystem", "spawnAndDeleteGameObjectEntity", gob.entry)
            end
        end
        C_Timer.After(0.5, function()
            config.updateGameObjectCards(gobData)
        end)
    elseif activeTab == 3 then
        for _, spell in ipairs(spellData) do
            if spell and spell.entry then
                AIO.Handle("GameMasterSystem", "refreshSpellEntity", spell.entry)
            end
        end
        C_Timer.After(0.5, function()
            config.updateSpellCards(spellData)
        end)
    end
end

-- Function to calculate the Levenshtein distance between two strings
local function levenshtein(str1, str2)
    local len1, len2 = #str1, #str2
    local matrix = {}

    -- Initialize the matrix
    for i = 0, len1 do
        matrix[i] = {
            [0] = i
        }
    end
    for j = 0, len2 do
        matrix[0][j] = j
    end

    -- Compute the Levenshtein distance
    for i = 1, len1 do
        for j = 1, len2 do
            local cost = (str1:sub(i, i) == str2:sub(j, j)) and 0 or 1
            matrix[i][j] = math.min(matrix[i - 1][j] + 1, -- Deletion
            matrix[i][j - 1] + 1, -- Insertion
            matrix[i - 1][j - 1] + cost -- Substitution
            )
        end
    end

    return matrix[len1][len2]
end

-- Function to perform fuzzy matching using Levenshtein distance
local function fuzzyMatch(str1, str2, threshold)
    local distance = levenshtein(str1:lower(), str2:lower())
    return distance <= threshold
end
-- function fuzzyMatch(str, pattern)
--     local pattern = pattern:lower()
--     local str = tostring(str):lower() -- Convert to string to handle numeric fields
--     local patternIndex = 1
--     local strIndex = 1

--     while patternIndex <= #pattern and strIndex <= #str do
--         if pattern:sub(patternIndex, patternIndex) == str:sub(strIndex, strIndex) then
--             patternIndex = patternIndex + 1
--         end
--         strIndex = strIndex + 1
--     end

--     return patternIndex > #pattern
-- end

function config.filterNpcCards(query)
    if not npcData then
        debugMessage("npcData is nil")
        return
    end

    local threshold = 3 -- Adjust the threshold as needed
    local filteredData = {}
    for _, npc in ipairs(npcData) do
        if fuzzyMatch(npc.entry, query, threshold) or fuzzyMatch(npc.name, query, threshold) or
            fuzzyMatch(npc.subname or "", query, threshold) or fuzzyMatch(tostring(npc.modelids[1]), query, threshold) or
            fuzzyMatch(tostring(npc.modelids[2]), query, threshold) or
            fuzzyMatch(tostring(npc.modelids[3]), query, threshold) or
            fuzzyMatch(tostring(npc.modelids[4]), query, threshold) then
            table.insert(filteredData, npc)
        end
    end
    config.updateNpcCards(filteredData)
end

function config.filterGameObjectCards(query)
    if not gobData then
        debugMessage("gobData is nil")
        return
    end

    local threshold = 3 -- Adjust the threshold as needed
    local filteredData = {}
    for _, gob in ipairs(gobData) do
        if fuzzyMatch(gob.entry, query, threshold) or fuzzyMatch(gob.name, query, threshold) or
            fuzzyMatch(tostring(gob.displayid), query, threshold) then
            table.insert(filteredData, gob)
        end
    end
    config.updateGameObjectCards(filteredData)
end

function config.updateNpcCards(filteredData)
    local tab1ContentFrame = contentFrames[1]
    if tab1ContentFrame.cards then
        for _, card in ipairs(tab1ContentFrame.cards) do
            card:Hide()
        end
    end
    tab1ContentFrame.cards = generateNpcCards(tab1ContentFrame, filteredData)
end

function config.updateGameObjectCards(filteredData)
    local tab2ContentFrame = contentFrames[2]
    if tab2ContentFrame.cards then
        for _, card in ipairs(tab2ContentFrame.cards) do
            card:Hide()
        end
    end
    tab2ContentFrame.cards = generateCardsForGameObjects(tab2ContentFrame, filteredData)
end

function config.updateSpellCards(filteredData)
    local tab3ContentFrame = contentFrames[3]
    if tab3ContentFrame.cards then
        for _, card in ipairs(tab3ContentFrame.cards) do
            card:Hide()
        end
    end
    tab3ContentFrame.cards = generateSpellCards(tab3ContentFrame, filteredData)
end

-- Function to enable mouse wheel scrolling with increased jump
local function enableMouseWheelScrolling(frame)
    frame:EnableMouseWheel(true)
    frame:SetScript("OnMouseWheel", function(self, delta)
        local jump = IsShiftKeyDown() and 250 or 10 -- Increase the jump to 100 rows if Shift is held, otherwise 5 rows
        if delta > 0 then
            if currentOffset > 0 then
                currentOffset = math.max(0, currentOffset - jump)
                handleAIO(activeTab, currentSearchQuery, currentOffset, config.pageSize)
            end
        else
            if (activeTab == 1 and #npcData == config.pageSize and nextButton:IsEnabled()) or
                (activeTab == 2 and #gobData == config.pageSize and nextButton:IsEnabled()) or
                (activeTab == 3 and #spellData == config.pageSize and nextButton:IsEnabled()) then
                currentOffset = currentOffset + jump
                handleAIO(activeTab, currentSearchQuery, currentOffset, config.pageSize)
            end
        end
    end)
end

-- Function to handle pagination
local function createPaginationButtons(parent)
    nextButton = CreateFrame("Button", nil, parent, "GameMenuButtonTemplate")
    nextButton:SetSize(100, 30)
    nextButton:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -10, 10)
    nextButton:SetText("Next")
    nextButton:SetNormalFontObject("GameFontNormal")
    nextButton:SetHighlightFontObject("GameFontHighlight")
    nextButton:SetScript("OnClick", function()
        if nextButton:IsEnabled() then
            currentOffset = currentOffset + 1
            handleAIO(activeTab, currentSearchQuery, currentOffset, config.pageSize)
        end
    end)

    prevButton = CreateFrame("Button", nil, parent, "GameMenuButtonTemplate")
    prevButton:SetSize(100, 30)
    prevButton:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 10, 10)
    prevButton:SetText("Previous")
    prevButton:SetNormalFontObject("GameFontNormal")
    prevButton:SetHighlightFontObject("GameFontHighlight")
    prevButton:SetScript("OnClick", function()
        if currentOffset > 0 then
            currentOffset = currentOffset - 1
            handleAIO(activeTab, currentSearchQuery, currentOffset, config.pageSize)
        end
    end)

    addSimpleTooltip(nextButton, "Click to go to the next page\nYou can also use the scroll wheel to move pages")
    addSimpleTooltip(prevButton, "Click to go to the previous page\nYou can also use the scroll wheel to move pages")
end

-- Handle received model data
function GameMasterSystem.receiveModelDataNpc(player, data)
    if not data then
        return
    end

    local model = _G["modelNpc" .. data.modelId]
    if not model then
        return
    end

    model:ClearModel()
    model:SetDisplayInfo(data.modelId)

    local textures = {data.texture1, data.texture2, data.texture3}
    for _, texture in ipairs(textures) do
        if texture then
            model:SetModel(texture)
        end
    end

    if data.portraitTexture then
        model:SetPortraitTexture(data.portraitTexture)
    end

    -- Optionally, you could add error handling or logging here
    -- For example:
    -- if not pcall(function() model:SetDisplayInfo(data.modelId) end) then
    --     print("Error setting display info for model: " .. data.modelId)
    -- end
end

-- Specific functions to generate cards for NPCs, GameObjects, and Spells
local function generateNpcCards(parent, npcData)
    return generateCards(parent, npcData, "NPC")
end

local function generateCardsForGameObjects(parent, gobData)
    return generateCards(parent, gobData, "GameObject")
end

local function generateSpellCards(parent, spellData)
    return generateCards(parent, spellData, "Spell")
end
-- Handler to receive NPC data from the server
function GameMasterSystem.receiveNPCData(player, data, offset, pageSize, hasMoreData)
    npcData = data -- Store the received data in npcData

    for _, npc in ipairs(npcData) do
        npc.creatureId = npc.entry
    end

    local tab1ContentFrame = contentFrames[1]

    if tab1ContentFrame.cards then
        for _, card in ipairs(tab1ContentFrame.cards) do
            card:Hide()
        end
    end

    tab1ContentFrame.cards = generateNpcCards(tab1ContentFrame, npcData)

    currentOffset = offset
    if hasMoreData then
        nextButton:Enable()
    else
        nextButton:Disable()
    end
end

-- Handler to receive GameObject data from the server
function GameMasterSystem.receiveGameObjectData(player, data, offset, pageSize, hasMoreData)
    gobData = data -- Store the received data in gobData

    for _, gob in ipairs(gobData) do
        gob.entry = gob.entry
    end

    local tab2ContentFrame = contentFrames[2]

    if tab2ContentFrame.cards then
        for _, card in ipairs(tab2ContentFrame.cards) do
            card:Hide()
        end
    end

    tab2ContentFrame.cards = generateCardsForGameObjects(tab2ContentFrame, gobData)

    currentOffset = offset
    if hasMoreData then
        nextButton:Enable()
    else
        nextButton:Disable()
    end
end

-- Handler to receive Spell data from the server
function GameMasterSystem.receiveSpellData(player, data, offset, pageSize, hasMoreData)
    spellData = data -- Store the received data in spellData

    for _, spell in ipairs(spellData) do
        spell.spellId = spell.spellID
    end

    local tab3ContentFrame = contentFrames[3]

    if tab3ContentFrame.cards then
        for _, card in ipairs(tab3ContentFrame.cards) do
            card:Hide()
        end
    end

    tab3ContentFrame.cards = generateSpellCards(tab3ContentFrame, spellData)

    currentOffset = offset
    if hasMoreData then
        nextButton:Enable()
    else
        nextButton:Disable()
    end
end

-- Define menu items
local menuItems = {
    {
        text = "Creature",
        func = function()
            activeTab = 1
            currentOffset = 0
            AIO.Handle("GameMasterSystem", "getNPCData", currentOffset, config.pageSize)
            showTab(contentFrames, activeTab)
        end
    },
    {
        text = "Objects",
        func = function()
            activeTab = 2
            currentOffset = 0
            AIO.Handle("GameMasterSystem", "getGameObjectData", currentOffset, config.pageSize)
            showTab(contentFrames, activeTab)
        end
    },
    {
        text = "Spell",
        func = function()
            activeTab = 3
            currentOffset = 0
            AIO.Handle("GameMasterSystem", "getSpellData", currentOffset, config.pageSize)
            showTab(contentFrames, activeTab)
        end
    },
    {
        text = "item here later",
        hasArrow = true,
        menuList = 4,
        subItems = {
            {
                text = "Item 1",
                func = function()
                    print("Item 1 clicked")
                end
            },
            {
                text = "Item 2",
                func = function()
                    print("Item 2 clicked")
                end
            },
            {
                text = "Sub Menu 3",
                hasArrow = true,
                menuList = 5,
                subItems = {
                    {
                        text = "Sub Item 1",
                        func = function()
                            print("Sub Item 1 clicked")
                        end
                    },
                    {
                        text = "Sub Item 2",
                        func = function()
                            print("Sub Item 2 clicked")
                        end
                    }
                }
            }
        }
    }
}

-- Function to initialize the dropdown menu
local function initializeDropdownMenu(frame, level, menuList)
    local info = UIDropDownMenu_CreateInfo()
    if level == 1 then
        for _, item in ipairs(menuItems) do
            info.text = item.text
            info.hasArrow = item.subItems and #item.subItems > 0
            info.menuList = item.menuList
            info.func = function()
                item.func()

                if item.text == "Creature" then
                    refreshButton:Enable()
                else
                    refreshButton:Disable()
                end
            end
            UIDropDownMenu_AddButton(info, level)
        end
    elseif level == 2 and menuList then
        for _, subItem in ipairs(menuItems[menuList].subItems) do
            info.text = subItem.text
            info.hasArrow = subItem.subItems and #subItem.subItems > 0
            info.menuList = subItem.menuList
            info.func = subItem.func
            UIDropDownMenu_AddButton(info, level)
        end
    elseif level == 3 and menuList then
        for _, subSubItem in ipairs(menuItems[4].subItems[3].subItems) do
            info.text = subSubItem.text
            info.func = subSubItem.func
            UIDropDownMenu_AddButton(info, level)
        end
    end
end


-- Function to calculate card dimensions based on mainFrame size
local function calculateCardDimensions(parent)
    local parentWidth = parent:GetWidth()
    local parentHeight = parent:GetHeight()

    -- Calculate card dimensions as a fraction of the parent frame's size
    local cardWidth = (parentWidth - 60) / config.numColumns
    local cardHeight = (parentHeight - 120) / config.numRows

    return cardWidth, cardHeight
end

--  Create the main frame
local function createMainFrame()
    local frame = CreateFrame("Frame", "MainFrame", UIParent)
    frame:SetSize(config.bgWidth, config.bgHeight)

    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    -- frame:SetClampedToScreen(true)
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

    -- Close button
    local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -10)
    closeButton:SetScript("OnClick", function()
        frame:Hide()
    end)

    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.title:SetFontObject("GameFontHighlight")
    frame.title:SetPoint("TOP", frame, "TOP", 0, -10)
    frame.title:SetText("Game Master UI")

    debugMessage("Frame created with title:", frame.title:GetText())

    -- Create the dropdown menu frame
    local dropdownMenu = CreateFrame("Frame", "DropdownMenu", frame, "UIDropDownMenuTemplate")
    dropdownMenu:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
    UIDropDownMenu_Initialize(dropdownMenu, initializeDropdownMenu)
    -- UIDropDownMenu_SetWidth(dropdownMenu, 100)
    -- UIDropDownMenuSetButtonWidth(dropdownMenu, 124)
    UIDropDownMenu_SetText(dropdownMenu, "Select Category")

    return frame
end

local function createContextMenu()
    local menu = CreateFrame("Frame", "ContextMenu", UIParent, "UIDropDownMenuTemplate")
    menu:SetSize(150, 200)
    menu:SetPoint("CENTER")
    menu:Hide()

    return menu
end

local contextMenu = createContextMenu()

StaticPopupDialogs["CONFIRM_DELETE_ENTITY"] = {
    text = "Are you sure you want to delete this entity?",
    button1 = "Yes",
    button2 = "No",
    OnAccept = function(self, data)
        if data.type == "npc" then
            AIO.Handle("GameMasterSystem", "deleteNpcEntity", data.entry)
        elseif data.type == "gameobject" then
            AIO.Handle("GameMasterSystem", "deleteGameObjectEntity", data.entry)
        elseif data.type == "spell" then
            AIO.Handle("GameMasterSystem", "deleteSpellEntity", data.entry)
        end

    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}

local function showNpcContextMenu(card, entity)
    local menu = {{
        text = "Creature ID: " .. entity.entry,
        isTitle = true,
        notCheckable = true

    }, {
        text = "Spawn",
        func = function()
            local entry = tostring(entity.entry):match("^%s*(.-)%s*$") -- Trim spaces
            AIO.Handle("GameMasterSystem", "spawnNpcEntity", entry)
        end
    }, {
        text = "Delete",
        func = function()
            local entry = tostring(entity.entry):match("^%s*(.-)%s*$") -- Trim spaces
            if IsControlKeyDown() then

                AIO.Handle("GameMasterSystem", "deleteNpcEntity", entry)
            else
                StaticPopup_Show("CONFIRM_DELETE_ENTITY", nil, nil, {
                    type = "npc",
                    entry = entry
                })
            end
        end
    }, {
        text = "Morph",
        func = function()
            local modelId = tostring(entity.modelids[1]):match("^%s*(.-)%s*$") -- Trim spaces
            AIO.Handle("GameMasterSystem", "morphNpcEntity", modelId)
        end
    }, {
        text = "Cancel",
        func = function()
        end
    }}

    EasyMenu(menu, contextMenu, "cursor", 0, 0, "MENU")
end

local function showGameObjectContextMenu(card, entity)
    local menu = {{
        text = "GameObject ID: " .. entity.entry,
        isTitle = true,
        notCheckable = true

    }, {
        text = "Spawn",
        func = function()
            local entry = tostring(entity.entry):match("^%s*(.-)%s*$") -- Trim spaces
            AIO.Handle("GameMasterSystem", "spawnGameObject", entry)
        end
    }, {
        text = "Delete",
        func = function()
            local entry = tostring(entity.entry):match("^%s*(.-)%s*$") -- Trim spaces
            if IsControlKeyDown() then
                AIO.Handle("GameMasterSystem", "deleteGameObjectEntity", entry)
            else
                StaticPopup_Show("CONFIRM_DELETE_ENTITY", nil, nil, {
                    type = "gameobject",
                    entry = entry
                })
            end
        end
    }, {
        text = "Cancel",
        func = function()
        end
    }}

    EasyMenu(menu, contextMenu, "cursor", 0, 0, "MENU")
end

local function showSpellContextMenu(card, entity)
    local menu = {{
        text = "Spell ID: " .. entity.spellId,
        isTitle = true,
        notCheckable = true

    }, {
        text = "Learn",
        func = function()
            local entry = tostring(entity.spellId):match("^%s*(.-)%s*$") -- Trim spaces
            AIO.Handle("GameMasterSystem", "learnSpellEntity", entry)
        end
    }, {
        text = "Unlearn",
        func = function()
            local entry = tostring(entity.spellId):match("^%s*(.-)%s*$") -- Trim spaces
            if IsControlKeyDown() then
                AIO.Handle("GameMasterSystem", "deleteSpellEntity", entry)
            else
                StaticPopup_Show("CONFIRM_DELETE_ENTITY", nil, nil, {
                    type = "spell",
                    entry = entry
                })
            end
        end
    }, {
        text = "Cast Self",
        func = function()
            local entry = tostring(entity.spellId):match("^%s*(.-)%s*$") -- Trim spaces
            AIO.Handle("GameMasterSystem", "castSelfSpellEntity", entry)
        end
    }, {
        text = "Cast Player",
        func = function()
            local entry = tostring(entity.spellId):match("^%s*(.-)%s*$") -- Trim spaces
            AIO.Handle("GameMasterSystem", "castTargetSpellEntity", entry)
        end
    }, {
        text = "Copy Icon",
        func = function()
            copyIcon(entity)
        end
    }, {

        text = "Cancel",
        func = function()
        end
    }}

    EasyMenu(menu, contextMenu, "cursor", 0, 0, "MENU")
end

-- Function to create search input field
local function createSearchInput(parent)
    local searchBox = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    searchBox:SetSize(200, 30)
    searchBox:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -50, -10)
    searchBox:SetAutoFocus(false)

    -- Set the text layer to be above the shadow text
    searchBox:SetTextInsets(8, 8, 0, 0)
    searchBox:SetFontObject("ChatFontNormal")
    addSimpleTooltip((searchBox), "Right-click to clear the search query")

    -- Placeholder text
    local placeholderText = searchBox:CreateFontString(nil, "OVERLAY", "GameFontDisable")
    placeholderText:SetPoint("LEFT", searchBox, "LEFT", 8, 0)
    placeholderText:SetText("Search...")
    searchBox:SetScript("OnEditFocusGained", function(self)
        placeholderText:Hide()
    end)
    searchBox:SetScript("OnEditFocusLost", function(self)
        if self:GetText() == "" then
            placeholderText:Show()
        end
    end)
    searchBox:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            self:SetText("")
            self:ClearFocus()
            placeholderText:Show()
            currentSearchQuery = ""
            currentOffset = 0
            if activeTab == 1 then
                AIO.Handle("GameMasterSystem", "getNPCData", currentOffset, config.pageSize)
            elseif activeTab == 2 then
                AIO.Handle("GameMasterSystem", "getGameObjectData", currentOffset, config.pageSize)
            elseif activeTab == 3 then
                AIO.Handle("GameMasterSystem", "getSpellData", currentOffset, config.pageSize)
            end
        end
    end)

    -- Search icon
    local searchIcon = searchBox:CreateTexture(nil, "ARTWORK")
    searchIcon:SetTexture("Interface\\Common\\UI-Searchbox-Icon")
    searchIcon:SetSize(16, 16)
    searchIcon:SetPoint("LEFT", searchBox, "LEFT", -20, -2)

    -- Add click functionality to search icon
    local searchIconButton = CreateFrame("Button", nil, searchBox)
    searchIconButton:SetAllPoints(searchIcon)
    searchIconButton:SetScript("OnMouseUp", function(self, button)
        if button == "RightButton" then
            print("test")
        end
    end)

    -- Clear icon
    local clearIcon = CreateFrame("Button", nil, searchBox)
    clearIcon:SetSize(16, 16)
    clearIcon:SetPoint("RIGHT", searchBox, "RIGHT", -8, 0)
    clearIcon:SetNormalTexture("Interface\\FriendsFrame\\ClearBroadcastIcon")
    clearIcon:SetScript("OnClick", function()
        searchBox:SetText("")
        searchBox:ClearFocus()
        placeholderText:Show()
        currentSearchQuery = ""
        currentOffset = 0
        handleAIO(activeTab, currentSearchQuery, currentOffset, config.pageSize)
    end)

    local function updateSearchResults()
        local query = searchBox:GetText()
        currentSearchQuery = query
        currentOffset = 0
        handleAIO(activeTab, query, currentOffset, config.pageSize)
    end

    searchBox:SetScript("OnTextChanged", function(self)
        if self:GetText() == "" then
            clearIcon:Hide()
            placeholderText:Show()
        else
            clearIcon:Show()
            placeholderText:Hide()
        end
        updateSearchResults()
    end)
    searchBox:SetScript("OnEnterPressed", updateSearchResults)

    return searchBox
end

-- Generic function to generate cards
function generateCards(parent, data, type)
    local cards = {}

    local cardWidth, cardHeight = calculateCardDimensions(parent)

    local maxVisibleCards = config.numColumns * config.numRows
    -- local contentHeight = numRows * (cardHeight + spacingY)

    -- parent:SetHeight(contentHeight)

    for i = 1, math.min(#data, maxVisibleCards) do
        local entity = data[i]
        local card = CreateFrame("Frame", "card" .. i, parent)
        card:SetSize(cardWidth, cardHeight)
        card:EnableMouse(true)

        card:SetPoint("TOPLEFT", parent, "TOPLEFT", 10 + ((i - 1) % config.numColumns) * (cardWidth + 10),
            -10 - math.floor((i - 1) / config.numColumns) * (cardHeight + 10))

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

        local nameText = card:CreateFontString(nil, "OVERLAY")
        nameText:SetFontObject("GameFontNormal")
        nameText:SetPoint("TOP", card, "TOP", 0, -10)
        nameText:SetWidth(cardWidth - 10)
        nameText:SetWordWrap(true)

        local displayIdText = card:CreateFontString(nil, "OVERLAY")
        displayIdText:SetFontObject("GameFontNormal")
        displayIdText:SetPoint("BOTTOM", card, "BOTTOM", 0, 10)
        displayIdText:SetWidth(cardWidth - 10)
        displayIdText:SetWordWrap(true)

        local idText = card:CreateFontString(nil, "OVERLAY")
        idText:SetFontObject("GameFontHighlight")
        idText:SetPoint("BOTTOM", displayIdText, "TOP", 0, 5)
        idText:SetWidth(cardWidth - 10)
        idText:SetWordWrap(true)

        if type == "NPC" then
            local model = CreateFrame("DressUpModel", "modelNpc" .. i, card)
            model:SetSize(cardWidth - 30, cardHeight - 40)
            model:SetPoint("CENTER", card, "CENTER", 0, 15)
            model:SetFrameStrata("DIALOG")
            model:ClearModel()
            model:SetCreature(entity.creatureId)
            model:SetRotation(math.rad(30))

            nameText:SetText(entity.name .. "\n" .. (entity.subname or ""))
            displayIdText:SetText("Model ID: " .. entity.modelids[1])
            idText:SetText("Creature ID: " .. entity.creatureId)

            card:SetScript("OnMouseUp", function(self, button)
                if button == "RightButton" then
                    showNpcContextMenu(card, entity)
                end
            end)
        elseif type == "GameObject" then
            local model = CreateFrame("DressUpModel", "modelGob" .. i, card)
            model:SetSize(cardWidth - 30, cardHeight - 40)
            model:SetPoint("CENTER", card, "CENTER", 0, 25)
            model:SetFrameStrata("DIALOG")
            model:ClearModel()

            if entity.modelName then
                model:SetModel(entity.modelName)
            end
            model:SetRotation(math.rad(30))

            local initialX, initialY = 0, 25
            model:EnableMouseWheel(true)
            model:SetScript("OnMouseWheel", function(self, delta)
                local zoomLevel = self:GetModelScale()
                if delta > 0 then
                    self:SetModelScale(zoomLevel + 0.1)
                else
                    if zoomLevel > 0.2 then
                        self:SetModelScale(zoomLevel - 0.1)
                    end
                end
                local newY = initialY + (1 - self:GetModelScale()) * 20
                self:SetPoint("CENTER", card, "CENTER", initialX, newY)
            end)

            displayIdText:SetText("Display ID: " .. entity.displayid)
            nameText:SetText(entity.name)
            idText:SetText("GameObject ID: " .. entity.entry)

            card:SetScript("OnMouseUp", function(self, button)
                if button == "RightButton" then
                    showGameObjectContextMenu(card, entity)
                end
            end)
        elseif type == "Spell" then
            local name, rank, icon = GetSpellInfo(entity.spellId)

            local iconTexture = card:CreateTexture(nil, "ARTWORK")
            iconTexture:SetSize(64, 64)
            iconTexture:SetPoint("CENTER", card, "CENTER", 0, 0)
            iconTexture:SetTexture(icon or "Interface\\Icons\\INV_Misc_QuestionMark")

            nameText:SetText(name .. "\n" .. (rank or ""))
            displayIdText:SetText("Icon: " .. (icon or "N/A"))
            idText:SetText("Spell ID: " .. entity.spellId)
            local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(entity.spellId)

            card:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetSpellByID(entity.spellId)

                -- Check if the tooltip has any lines, if not, set the text manually
                if GameTooltip:NumLines() == 0 then
                    GameTooltip:SetText("|cffffff00Description:|r " .. (entity.spellDescription or "N/A") ..
                                            "\n\n|cffffff00Tooltip:|r " .. (entity.spellToolTip or "N/A"), nil, nil,
                        nil, nil, true)
                end

                GameTooltip:Show()
            end)

            card:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
            end)

            card:SetScript("OnMouseUp", function(self, button)
                if button == "RightButton" then
                    showSpellContextMenu(card, entity)
                end
            end)
        end

        cards[i] = card
    end

    return cards
end

-- Function to create the refresh button
local function createRefreshButton(parent)
    local button = CreateFrame("Button", nil, parent, "GameMenuButtonTemplate")
    button:SetSize(100, 30)
    button:SetPoint("BOTTOM", parent, "BOTTOM", 0, 10)
    button:SetText("Refresh")
    button:SetNormalFontObject("GameFontNormal")
    button:SetHighlightFontObject("GameFontHighlight")
    button:SetScript("OnClick", function()
        refreshModels()
    end)

    -- Add tooltip to the refresh button
    button:SetScript("OnEnter", function(self)
        addSimpleTooltip(self,
            "Click to refresh the model preview if you don't see the models\nThis will try to spawn and delete the entities")
    end)
    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    return button
end

-- Initialize the UI
local function initializeUI()
    mainFrame = createMainFrame()
    contentFrames = createContentFrames(mainFrame, menuItems)
    -- for i, tabConfig in ipairs(config.tabs) do
    --     local tab = createTab(mainFrame, tabConfig.name, i - 1, function()
    --         showTab(contentFrames, i)
    --         currentOffset = 0
    --         handleAIO(i, "", currentOffset, config.pageSize)
    --         if i == 1 then
    --             refreshButton:Enable()
    --         else
    --             refreshButton:Disable()
    --         end
    --     end)
    --     config.tabs[i].tab = tab
    -- end

    showTab(contentFrames, 1)
    currentOffset = 0
    AIO.Handle("GameMasterSystem", "getNPCData", currentOffset, config.pageSize)

    createPaginationButtons(mainFrame)
    enableMouseWheelScrolling(mainFrame)
    createSearchInput(mainFrame) -- Add search input field

    -- Add Refresh Button
    refreshButton = createRefreshButton(mainFrame)

    tinsert(UISpecialFrames, "MainFrame")
end

-- Open the UI with a slash command
SLASH_GAMEMASTERUI1 = "/gmui"
SlashCmdList["GAMEMASTERUI"] = function(msg)
    if mainFrame then
        if mainFrame:IsShown() then
            mainFrame:Hide()
        else
            mainFrame:ClearAllPoints()
            mainFrame:SetPoint("CENTER")
            mainFrame:Show()

        end
    else
        print("Game Master UI is not initialized.")
    end
end

print("|cff00ff00Game Master UI can be toggled with /gmui|r")

initializeUI()
