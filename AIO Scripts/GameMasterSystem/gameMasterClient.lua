-- AIO for TrinityCore 3.3.5 with WoW client 3.3.5
local AIO = AIO or require("AIO")

if AIO.AddAddon() then
	return
end

local GameMasterSystem = AIO.AddHandlers("GameMasterSystem", {})
local npcData = {}
local gobData = {}
local spellData = {}
local spellVisualData = {}
local coreName = ""
local currentSearchQuery = ""
local gmLevel = 0

-- State flags to track data fetching
local isGmLevelFetched = false
local isCoreNameFetched = false

-- Function to receive the core name from the server
function GameMasterSystem.receiveCoreName(player, name)
	coreName = name
	isCoreNameFetched = true
end

-- Function to receive GM Level from the server
function GameMasterSystem.receiveGmLevel(player, data)
	gmLevel = data
	isGmLevelFetched = true
end

local contentFrames, mainFrame, currentOffset, activeTab, refreshButton, nextButton, prevButton, sortOrder, MenuFactory
-- Configuration
local config = {
	debug = false,
	REQUIRED_GM_LEVEL = 2,

	BG_WIDTH = 800,
	BG_HEIGHT = 600,

	PAGE_SIZE = 15,
	NUM_COLUMNS = 5,
	NUM_ROWS = 3,
}

local sortOptions = {
	{
		text = "Ascending",
		value = "ASC",
	},
	{
		text = "Descending",
		value = "DESC",
	}, -- Add more options here in the future
}
-- Constants for tab types
local TAB_TYPES = {
	CREATURE = 1,
	OBJECT = 2,
	SPELL = 3,
	SPELL_VISUAL = 4,
	ITEM = 5,
}
-- Constants for menu configuration
local MENU_CONFIG = {
	SIZE = {
		WIDTH = 150,
		HEIGHT = 200,
	},
	CONFIRM_DIALOG = {
		TIMEOUT = 0,
		PREFERRED_INDEX = 3,
	},
	TYPES = {
		NPC = "npc",
		GAMEOBJECT = "gameobject",
		SPELL = "spell",
		SPELLVISUAL = "spellvisual",
	},
	DROPDOWN = {
		MAX_DEPTH = 10,
		DEFAULT_LEVEL = 1,
		ITEM = {
			WIDTH = 180,
			MIN_WIDTH = 120,
			PADDING = 20,
			TEXT_OFFSET = 5,
		},
	},
}
-- Helper function for tab switching
local function switchTab(tabId)
	return function()
		activeTab = tabId
		currentOffset = 0
		config.handleAIO(activeTab, currentSearchQuery, currentOffset, config.PAGE_SIZE, sortOrder)
		config.showTab(contentFrames, activeTab)
	end
end

-- Define menu items with consistent structure
local menuItems = {
	{
		text = "Creature",
		func = switchTab(TAB_TYPES.CREATURE),
		notCheckable = true,
	},
	{
		text = "Objects",
		func = switchTab(TAB_TYPES.OBJECT),
		notCheckable = true,
	},
	{
		text = "Spell",
		notCheckable = true,
		subItems = {
			{
				text = "Spell",
				func = switchTab(TAB_TYPES.SPELL),
				notCheckable = true,
			},
			{
				text = "Spell Visual",
				func = switchTab(TAB_TYPES.SPELL_VISUAL),
				notCheckable = true,
			},
		},
	},
	{
		text = "Items",
		notCheckable = true,
		subItems = {
			{
				text = "Search Items",
				func = switchTab(TAB_TYPES.ITEM),
				notCheckable = true,
			},
			{
				text = "Item Categories",
				notCheckable = true,
				subItems = {
					{
						text = "Weapons",
						notCheckable = true,
						subItems = {
							{
								text = "One-Handed",
								func = function()
									print("One-Handed Weapons")
								end,
								notCheckable = true,
							},
							{
								text = "Two-Handed",
								func = function()
									print("Two-Handed Weapons")
								end,
								notCheckable = true,
							},
						},
					},
					{
						text = "Armor",
						notCheckable = true,
						subItems = {
							{
								text = "Plate",
								func = function()
									print("Plate Armor")
								end,
								notCheckable = true,
							},
							{
								text = "Mail",
								func = function()
									print("Mail Armor")
								end,
								notCheckable = true,
							},
						},
					},
				},
			},
		},
	},
}
-- Define handlers table
local handlers = {
	[1] = {
		get = "getNPCData",
		search = "searchNPCData",
	},
	[2] = {
		get = "getGameObjectData",
		search = "searchGameObjectData",
	},
	[3] = {
		get = "getSpellData",
		search = "searchSpellData",
	},
	[4] = {
		get = "getSpellVisualData",
		search = "searchSpellVisualData",
	},
}
-- Utility function to handle AIO calls
function config.handleAIO(activeTab, query, offset, pageSize, sortOrder)
	local handler = handlers[activeTab]
	if query == "" then
		AIO.Handle("GameMasterSystem", handler.get, offset, pageSize, sortOrder)
	else
		AIO.Handle("GameMasterSystem", handler.search, query, offset, pageSize, sortOrder)
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
	local entry = tostring(entity.spellID):match("^%s*(.-)%s*$") -- Trim spaces
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
		print("Ctrl+C to copy the path")
	else
		print("|cffff0000Icon not found for spell ID:|r", entry)
	end
end

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
function config.showTab(frames, index)
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

-- Custom timer function
local function customTimer(delay, func)
	local frame = CreateFrame("Frame")
	local elapsed = 0
	frame:SetScript("OnUpdate", function(self, delta)
		elapsed = elapsed + delta
		if elapsed >= delay then
			func()
			self:SetScript("OnUpdate", nil)
		end
	end)
end

-- Function to calculate the Levenshtein distance between two strings
local function levenshtein(str1, str2)
	local len1, len2 = #str1, #str2
	local matrix = {}

	-- Initialize the matrix
	for i = 0, len1 do
		matrix[i] = {
			[0] = i,
		}
	end
	for j = 0, len2 do
		matrix[0][j] = j
	end

	-- Compute the Levenshtein distance
	for i = 1, len1 do
		for j = 1, len2 do
			local cost = (str1:sub(i, i) == str2:sub(j, j)) and 0 or 1
			matrix[i][j] = math.min(
				matrix[i - 1][j] + 1, -- Deletion
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

function config.filterNpcCards(query)
	if not npcData then
		debugMessage("npcData is nil")
		return
	end

	local threshold = 3 -- Adjust the threshold as needed
	local filteredData = {}
	for _, npc in ipairs(npcData) do
		if
			fuzzyMatch(npc.entry, query, threshold)
			or fuzzyMatch(npc.name, query, threshold)
			or fuzzyMatch(npc.subname or "", query, threshold)
			or (type(npc.modelid) == "table" and (fuzzyMatch(tostring(npc.modelid[1]), query, threshold) or fuzzyMatch(
				tostring(npc.modelid[2]),
				query,
				threshold
			) or fuzzyMatch(tostring(npc.modelid[3]), query, threshold) or fuzzyMatch(
				tostring(npc.modelid[4]),
				query,
				threshold
			)))
			or (type(npc.modelid) == "number" and fuzzyMatch(tostring(npc.modelid), query, threshold))
		then
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
		if
			fuzzyMatch(gob.entry, query, threshold)
			or fuzzyMatch(gob.name, query, threshold)
			or fuzzyMatch(tostring(gob.displayid), query, threshold)
		then
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

function config.updateSpellVisualCards(filteredData)
	debugMessage("Updating SpellVisual cards")
	local tab4ContentFrame = contentFrames[4]
	if tab4ContentFrame.cards then
		for _, card in ipairs(tab4ContentFrame.cards) do
			card:Hide()
		end
	end
	tab4ContentFrame.cards = generateSpellVisualCards(tab4ContentFrame, filteredData)
end
-- Global variable to keep track of whether there are more pages available
local hasMoreData = false

-- Function to update pagination buttons based on data availability
local function updatePaginationButtons(hasMoreDataFlag)
	hasMoreData = hasMoreDataFlag -- Update the global variable

	if hasMoreData then
		nextButton:Enable()
	else
		nextButton:Disable()
	end

	if currentOffset > 0 then
		prevButton:Enable()
	else
		prevButton:Disable()
	end
end

-- Constants for scroll configuration
local SCROLL_CONFIG = {
	NORMAL_JUMP = 1,
	FAST_JUMP = 100,
	MIN_OFFSET = 0,
}

-- Function to calculate new scroll offset
local function calculateNewOffset(currentOffset, delta, jumpSize, hasMore)
	if delta > 0 then
		-- Scroll up
		return math.max(SCROLL_CONFIG.MIN_OFFSET, currentOffset - jumpSize)
	else
		-- Scroll down
		return hasMore and (currentOffset + jumpSize) or currentOffset
	end
end

-- Function to enable mouse wheel scrolling with increased jump
local function enableMouseWheelScrolling(frame)
	if not frame then
		error("Frame is required for mouse wheel scrolling")
	end

	frame:EnableMouseWheel(true)
	frame:SetScript("OnMouseWheel", function(self, delta)
		-- Determine jump size based on Shift key state
		local jumpSize = IsShiftKeyDown() and SCROLL_CONFIG.FAST_JUMP or SCROLL_CONFIG.NORMAL_JUMP

		-- Calculate and validate new offset
		local newOffset = calculateNewOffset(currentOffset, delta, jumpSize, hasMoreData)
		currentOffset = math.max(SCROLL_CONFIG.MIN_OFFSET, newOffset)

		-- Update display with new offset
		config.handleAIO(activeTab, currentSearchQuery, currentOffset, config.PAGE_SIZE, sortOrder)
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
			config.handleAIO(activeTab, currentSearchQuery, currentOffset, config.PAGE_SIZE, sortOrder)
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
			config.handleAIO(activeTab, currentSearchQuery, currentOffset, config.PAGE_SIZE, sortOrder)
		end
	end)

	addSimpleTooltip(nextButton, "Click to go to the next page\nYou can also use the scroll wheel to move pages")
	addSimpleTooltip(prevButton, "Click to go to the previous page\nYou can also use the scroll wheel to move pages")
end

-- Specific functions to generate cards for NPCs, GameObjects, and Spells
local function createCardGenerator(cardType)
	return function(parent, data)
		return config.generateCards(parent, data, cardType)
	end
end

local generateNpcCards = createCardGenerator("NPC")
local generateGameObjectCards = createCardGenerator("GameObject")
local generateSpellCards = createCardGenerator("Spell")
local generateSpellVisualCards = createCardGenerator("SpellVisual")

-- Handler to receive NPC data from the server
function GameMasterSystem.receiveNPCData(player, data, offset, pageSize, hasMoreData)
	npcData = data -- Store the received data in npcData
	local tab1ContentFrame = contentFrames[1]

	if tab1ContentFrame.cards then
		for _, card in ipairs(tab1ContentFrame.cards) do
			card:Hide()
		end
	end

	tab1ContentFrame.cards = generateNpcCards(tab1ContentFrame, npcData)

	currentOffset = offset
	updatePaginationButtons(hasMoreData)
end

-- Handler to receive GameObject data from the server
function GameMasterSystem.receiveGameObjectData(player, data, offset, pageSize, hasMoreData)
	gobData = data -- Store the received data in gobData
	local tab2ContentFrame = contentFrames[2]

	if tab2ContentFrame.cards then
		for _, card in ipairs(tab2ContentFrame.cards) do
			card:Hide()
		end
	end
	tab2ContentFrame.cards = generateGameObjectCards(tab2ContentFrame, gobData)

	currentOffset = offset

	updatePaginationButtons(hasMoreData)
end

-- Handler to receive Spell data from the server
function GameMasterSystem.receiveSpellData(player, data, offset, pageSize, hasMoreData)
	spellData = data -- Store the received data in spellData
	local tab3ContentFrame = contentFrames[3]

	if tab3ContentFrame.cards then
		for _, card in ipairs(tab3ContentFrame.cards) do
			card:Hide()
		end
	end

	tab3ContentFrame.cards = generateSpellCards(tab3ContentFrame, spellData)

	currentOffset = offset

	updatePaginationButtons(hasMoreData)
end

-- Handle to recive spellVisualData from the server
function GameMasterSystem.receiveSpellVisualData(player, data, offset, pageSize, hasMoreData)
	spellVisualData = data
	local tab4ContentFrame = contentFrames[4]

	if tab4ContentFrame.cards then
		for _, card in ipairs(tab4ContentFrame.cards) do
			card:Hide()
		end
	end

	tab4ContentFrame.cards = generateSpellVisualCards(tab4ContentFrame, spellVisualData)
	currentOffset = offset

	updatePaginationButtons(hasMoreData)
end

-- Function to create the dropdown menu for sorting order
local function createSortOrderDropdown(parent)
	local dropdown = CreateFrame("Frame", "SortOrderDropdown", parent, "UIDropDownMenuTemplate")
	dropdown:SetPoint("TOPLEFT", parent, "TOPLEFT", 165, -10)
	local maxTextLength = 0
	for _, option in ipairs(sortOptions) do
		local textLength = string.len(option.text)
		if textLength > maxTextLength then
			maxTextLength = textLength
		end
	end

	local width = maxTextLength * 8
	UIDropDownMenu_SetWidth(dropdown, width)
	UIDropDownMenu_SetText(dropdown, "Sort Order")

	local function OnClick(self)
		sortOrder = self.value
		UIDropDownMenu_SetSelectedValue(dropdown, self.value)
		currentOffset = 0 -- Reset offset when sort order changes
		config.handleAIO(activeTab, currentSearchQuery, currentOffset, config.PAGE_SIZE, sortOrder)
	end

	local function initialize(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for _, option in ipairs(sortOptions) do
			info.text = option.text
			info.value = option.value
			info.func = OnClick
			info.checked = (sortOrder == option.value)
			UIDropDownMenu_AddButton(info, level)
		end
	end

	UIDropDownMenu_Initialize(dropdown, initialize)
end

-- Helper function to split string
local function splitString(str, sep)
	if type(str) ~= "string" then
		return {}
	end
	local t = {}
	for s in string.gmatch(str, "([^" .. sep .. "]+)") do
		table.insert(t, s)
	end
	return t
end

-- Improved menu item validation
local function isValidMenuItem(item)
	return item and type(item.text) == "string" and (item.func == nil or type(item.func) == "function")
end

-- Get submenu items based on path
local function getSubmenuItems(path)
	if not path then
		return menuItems
	end

	local indices = splitString(path, ",")
	local currentItems = menuItems

	for _, indexStr in ipairs(indices) do
		local menuIndex = tonumber(indexStr)
		if not menuIndex or not currentItems or not currentItems[menuIndex] or not currentItems[menuIndex].subItems then
			return nil
		end
		currentItems = currentItems[menuIndex].subItems
	end

	return currentItems
end

-- Update handleMenuLevel to use new config name
local function handleMenuLevel(info, items, level, menuPath)
	if not items or type(items) ~= "table" or level > MENU_CONFIG.DROPDOWN.MAX_DEPTH then
		return
	end

	for index, item in ipairs(items) do
		if isValidMenuItem(item) then
			wipe(info)
			info.text = item.text
			info.func = item.func
			info.notCheckable = item.notCheckable
			info.padding = MENU_CONFIG.DROPDOWN.ITEM.PADDING
			info.leftPadding = MENU_CONFIG.DROPDOWN.ITEM.TEXT_OFFSET
			info.minWidth = MENU_CONFIG.DROPDOWN.ITEM.MIN_WIDTH
			info.tooltipOnButton = true

			if item.subItems and type(item.subItems) == "table" and #item.subItems > 0 then
				info.hasArrow = true
				local newPath = menuPath and (menuPath .. "," .. index) or tostring(index)
				info.menuList = newPath
			end

			UIDropDownMenu_AddButton(info, level)
		end
	end
end

-- Main initialization function
local function initializeDropdownMenu(frame, level, menuList)
	if not frame or not level then
		return
	end

	local info = UIDropDownMenu_CreateInfo()
	level = level or MENU_CONFIG.DEFAULT_LEVEL

	local currentItems = getSubmenuItems(menuList)
	if currentItems and type(currentItems) == "table" then
		handleMenuLevel(info, currentItems, level, menuList)
	end
end

-- Function to calculate card dimensions based on mainFrame size
local function calculateCardDimensions(parent)
	local parentWidth = parent:GetWidth()
	local parentHeight = parent:GetHeight()

	-- Calculate card dimensions as a fraction of the parent frame's size
	local cardWidth = (parentWidth - 60) / config.NUM_COLUMNS
	local cardHeight = (parentHeight - 120) / config.NUM_ROWS

	return cardWidth, cardHeight
end

--  Create the main frame
local function createMainFrame()
	local frame = CreateFrame("Frame", "MainFrame", UIParent)
	frame:SetSize(config.BG_WIDTH, config.BG_HEIGHT)

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
			bottom = 4,
		},
	}
	frame:SetBackdrop(backdrop)
	frame:SetBackdropColor(0, 0.5, 0.5, 1)

	-- Close button
	local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, -3)
	closeButton:SetScript("OnClick", function()
		frame:Hide()
	end)

	frame.title = frame:CreateFontString(nil, "OVERLAY")
	frame.title:SetFontObject("GameFontHighlight")
	frame.title:SetPoint("TOP", frame, "TOP", 0, -10)
	frame.title:SetText("Game Master UI")

	-- Create the dropdown menu frame
	local dropdownMenu = CreateFrame("Frame", "DropdownMenu", frame, "UIDropDownMenuTemplate")
	dropdownMenu:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
	UIDropDownMenu_Initialize(dropdownMenu, initializeDropdownMenu)
	UIDropDownMenu_SetText(dropdownMenu, "Select Category")

	return frame
end

-- Define the function to create the Kofi frame
local function createKofiFrame()
	-- Define Kofi variables
	local kofiName = "https://ko-fi.com/clotic"
	local kofiQR = "Interface\\GameMasterUI\\qrcode_cropped.blp"

	-- Create the Kofi Frame (initially hidden)
	local kofiFrame = CreateFrame("Frame", "KofiFrame", UIParent)
	kofiFrame:SetSize(300, 400)
	kofiFrame:SetPoint("RIGHT", mainFrame, "RIGHT", mainFrame:GetWidth() / 2.6, 0)
	kofiFrame:SetFrameStrata("DIALOG")
	kofiFrame:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left = 8, right = 8, top = 8, bottom = 8 },
	})
	kofiFrame:Hide()

	-- Create the Close Button
	local kofiCloseButton = CreateFrame("Button", nil, kofiFrame, "UIPanelCloseButton")
	kofiCloseButton:SetPoint("TOPRIGHT", kofiFrame, "TOPRIGHT", -5, -5)
	kofiCloseButton:SetScript("OnClick", function()
		kofiFrame:Hide()
	end)

	-- Add the QR code texture
	local qrTexture = kofiFrame:CreateTexture(nil, "BACKGROUND")
	qrTexture:SetTexture(kofiQR)
	qrTexture:SetSize(200, 200)
	qrTexture:SetPoint("TOP", 0, -50)
	-- qrTexture:SetFrameLevel(kofiFrame:GetFrameLevel() + 1)
	qrTexture:SetDrawLayer("ARTWORK", 1)

	-- Add the Kofi link text
	local kofiText = kofiFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	kofiText:SetPoint("TOP", qrTexture, "BOTTOM", 0, -20)
	kofiText:SetText("Support me on Ko-fi!")

	-- Add the Kofi link edit box
	local kofiEditBox = CreateFrame("EditBox", nil, kofiFrame, "InputBoxTemplate")
	kofiEditBox:SetSize(250, 30)
	kofiEditBox:SetPoint("TOP", kofiText, "BOTTOM", 0, -10)
	kofiEditBox:SetAutoFocus(false)
	kofiEditBox:SetText(kofiName)
	kofiEditBox:HighlightText()
	kofiEditBox:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	kofiEditBox:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
	end)
	kofiEditBox:SetScript("OnEditFocusGained", function(self)
		self:HighlightText()
	end)

	return kofiFrame
end

local function trimSpaces(value)
	return tostring(value):match("^%s*(.-)%s*$")
end

<<<<<<< HEAD
-- Common menu item templates
local MenuItems = {
	CANCEL = {
		text = "Cancel",
		func = function() end,
		notCheckable = true,
	},
	createTitle = function(text)
		return {
			text = text,
			isTitle = true,
			notCheckable = true,
		}
	end,
	createDelete = function(type, entry, handler)
		return {
			text = "Delete",
			func = function()
				if IsControlKeyDown() then
					handler(entry)
				else
					StaticPopup_Show("CONFIRM_DELETE_ENTITY", nil, nil, {
						type = type,
						entry = entry,
					})
				end
			end,
			notCheckable = true,
		}
	end,
}

MenuFactory = {
	createContextMenu = function()
		local menu = CreateFrame("Frame", "ContextMenu", UIParent, "UIDropDownMenuTemplate")
		menu:SetSize(MENU_CONFIG.SIZE.WIDTH, MENU_CONFIG.SIZE.HEIGHT)
		menu:SetPoint("CENTER")
		menu:Hide()
		return menu
	end,

	createNpcMenu = function(entity)
		local trimmedEntry = trimSpaces(entity.entry)
		return {
			MenuItems.createTitle("Creature ID: " .. trimmedEntry),
			{
				text = "Spawn",
				func = function()
					if coreName == "TrinityCore" then
						AIO.Handle("GameMasterSystem", "spawnNpcEntity", trimmedEntry)
					elseif coreName == "AzerothCore" then
						SendChatMessage(".npc add " .. trimmedEntry, "SAY")
					end
				end,
				notCheckable = true,
			},
			MenuItems.createDelete(MENU_CONFIG.TYPES.NPC, trimmedEntry, function(entry)
				AIO.Handle("GameMasterSystem", "deleteNpcEntity", entry)
			end),
			{
				text = "Morphing",
				hasArrow = true,
				menuList = MenuFactory.createMorphingSubmenu(entity),
				notCheckable = true,
			},
			MenuItems.CANCEL,
		}
	end,

	createMorphingSubmenu = function(entity)
		local submenu = {
			{
				text = "Demorph",
				func = function()
					AIO.Handle("GameMasterSystem", "demorphNpcEntity")
				end,
				notCheckable = true,
			},
		}

		-- Add model IDs
		for i, modelId in ipairs(entity.modelid) do
			table.insert(submenu, 1, {
				text = "Model ID " .. i .. ": " .. modelId,
				func = function()
					AIO.Handle("GameMasterSystem", "morphNpcEntity", trimSpaces(modelId))
				end,
				notCheckable = true,
			})
		end

		return submenu
	end,

	createGameObjectMenu = function(entity)
		local trimmedEntry = trimSpaces(entity.entry)
		return {
			MenuItems.createTitle("GameObject ID: " .. trimmedEntry),
			{
				text = "Spawn",
				func = function()
					if coreName == "TrinityCore" then
						AIO.Handle("GameMasterSystem", "spawnGameObject", trimmedEntry)
					elseif coreName == "AzerothCore" then
						SendChatMessage(".gobject add " .. trimmedEntry, "SAY")
					end
				end,
				notCheckable = true,
			},
			MenuItems.createDelete(MENU_CONFIG.TYPES.GAMEOBJECT, trimmedEntry, function(entry)
				AIO.Handle("GameMasterSystem", "deleteGameObjectEntity", entry)
			end),
			MenuItems.CANCEL,
		}
	end,

	createSpellMenu = function(entity)
		local trimmedEntry = trimSpaces(entity.spellID)
		return {
			MenuItems.createTitle("Spell ID: " .. trimmedEntry),
			{
				text = "Learn",
				func = function()
					AIO.Handle("GameMasterSystem", "learnSpellEntity", trimmedEntry)
				end,
				notCheckable = true,
			},
			MenuItems.createDelete(MENU_CONFIG.TYPES.SPELL, trimmedEntry, function(entry)
				AIO.Handle("GameMasterSystem", "deleteSpellEntity", entry)
			end),
			{
				text = "Cast on Self",
				func = function()
					AIO.Handle("GameMasterSystem", "castSelfSpellEntity", trimmedEntry)
				end,
				notCheckable = true,
			},
			{
				text = "Cast from Target",
				func = function()
					AIO.Handle("GameMasterSystem", "castTargetSpellEntity", trimmedEntry)
				end,
				notCheckable = true,
			},
			{
				text = "Copy Icon",
				func = function()
					copyIcon(entity)
				end,
				notCheckable = true,
			},
			MenuItems.CANCEL,
		}
	end,

	createSpellVisualMenu = function(entity)
		local trimmedEntry = trimSpaces(entity.spellVisualID)

		return {
			MenuItems.createTitle("SpellVisual ID: " .. trimmedEntry),
			{
				text = "Copy spellVisual",
				func = function()
					print(entity.FilePath)
					local editBox = CreateFrame("EditBox")
					editBox:SetText(entity.FilePath)
					editBox:HighlightText()
					print("Ctrl+C to copy the path")
					editBox:SetScript("OnEscapePressed", function(self)
						self:ClearFocus()
						self:Hide()
					end)
					editBox:SetScript("OnEnterPressed", function(self)
						self:ClearFocus()
						self:Hide()
					end)
				end,
				notCheckable = true,
			},
			MenuItems.CANCEL,
		}
	end,
}

-- Create single context menu instance
local contextMenu = MenuFactory.createContextMenu()

-- Show menu functions
local function showContextMenu(menuType, card, entity)
	local menuCreators = {
		npc = MenuFactory.createNpcMenu,
		gameobject = MenuFactory.createGameObjectMenu,
		spell = MenuFactory.createSpellMenu,
		spellvisual = MenuFactory.createSpellVisualMenu,
	}

	local menuCreator = menuCreators[menuType]
	if menuCreator then
		EasyMenu(menuCreator(entity), contextMenu, "cursor", 0, 0, "MENU")
	end
end

-- Constants
local SEARCH_CONFIG = {
	TEXTURES = {
		SEARCH = "Interface\\Common\\UI-Searchbox-Icon",
		CLEAR = "Interface\\Buttons\\UI-Panel-MinimizeButton-Up",
	},
	SIZE = {
		WIDTH = 200,
		HEIGHT = 20,
		ICON = 14,
	},
	INSETS = 5,
}
=======
-- Example usage of MENU_CONFIG.TYPES
local function getEntityType(type)
	return MENU_CONFIG.TYPES[type:upper()] or type
end

-- Register static popup dialog
StaticPopupDialogs["CONFIRM_DELETE_ENTITY"] = {
	text = "Are you sure you want to delete this %s with ID: %s?\nHold CTRL to skip this dialog next time.",
	button1 = "Yes",
	button2 = "No",
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
	preferredIndex = 3,
	OnAccept = function(self, data)
		if not data or not data.type or not data.entry then
			return
		end

		local handlers = {
			npc = function(entry)
				AIO.Handle("GameMasterSystem", "deleteNpcEntity", entry)
			end,
			gameobject = function(entry)
				AIO.Handle("GameMasterSystem", "deleteGameObjectEntity", entry)
			end,
			spell = function(entry)
				AIO.Handle("GameMasterSystem", "deleteSpellEntity", entry)
			end,
			spellvisual = function(entry)
				AIO.Handle("GameMasterSystem", "deleteSpellVisualEntity", entry)
			end,
		}

		if handlers[data.type] then
			handlers[data.type](data.entry)
			-- Refresh data after deletion
			config.handleAIO(activeTab, currentSearchQuery, currentOffset, config.pageSize, sortOrder)
		end
	end,
}

-- Helper function to show delete confirmation
local function showDeleteConfirmation(type, entry)
	if not type or not entry then
		return
	end

	local displayType = getEntityType(type):gsub("^%l", string.upper)
	StaticPopup_Show("CONFIRM_DELETE_ENTITY", displayType, entry, {
		type = type,
		entry = entry,
	})
end

-- Common menu item templates
local MenuItems = {
	CANCEL = {
		text = "Cancel",
		func = function() end,
		notCheckable = true,
	},
	createTitle = function(text)
		return {
			text = text,
			isTitle = true,
			notCheckable = true,
		}
	end,
	createDelete = function(type, entry, handler)
		return {
			text = "Delete",
			func = function()
				if IsControlKeyDown() then
					handler(entry)
				else
					showDeleteConfirmation(type, entry)
				end
			end,
			notCheckable = true,
		}
	end,
}

MenuFactory = {
	createContextMenu = function()
		local menu = CreateFrame("Frame", "ContextMenu", UIParent, "UIDropDownMenuTemplate")
		menu:SetSize(MENU_CONFIG.SIZE.WIDTH, MENU_CONFIG.SIZE.HEIGHT)
		menu:SetPoint("CENTER")
		menu:Hide()
		return menu
	end,

	createNpcMenu = function(entity)
		local trimmedEntry = trimSpaces(entity.entry)
		return {
			MenuItems.createTitle("Creature ID: " .. trimmedEntry),
			{
				text = "Spawn",
				func = function()
					if coreName == "TrinityCore" then
						AIO.Handle("GameMasterSystem", "spawnNpcEntity", trimmedEntry)
					elseif coreName == "AzerothCore" then
						SendChatMessage(".npc add " .. trimmedEntry, "SAY")
					end
				end,
				notCheckable = true,
			},
			MenuItems.createDelete(MENU_CONFIG.TYPES.NPC, trimmedEntry, function(entry)
				AIO.Handle("GameMasterSystem", "deleteNpcEntity", entry)
			end),
			{
				text = "Morphing",
				hasArrow = true,
				menuList = MenuFactory.createMorphingSubmenu(entity),
				notCheckable = true,
			},
			MenuItems.CANCEL,
		}
	end,

	createMorphingSubmenu = function(entity)
		local submenu = {
			{
				text = "Demorph",
				func = function()
					AIO.Handle("GameMasterSystem", "demorphNpcEntity")
				end,
				notCheckable = true,
			},
		}

		-- Add model IDs
		for i, modelId in ipairs(entity.modelid) do
			table.insert(submenu, 1, {
				text = "Model ID " .. i .. ": " .. modelId,
				func = function()
					AIO.Handle("GameMasterSystem", "morphNpcEntity", trimSpaces(modelId))
				end,
				notCheckable = true,
			})
		end

		return submenu
	end,

	createGameObjectMenu = function(entity)
		local trimmedEntry = trimSpaces(entity.entry)
		return {
			MenuItems.createTitle("GameObject ID: " .. trimmedEntry),
			{
				text = "Spawn",
				func = function()
					if coreName == "TrinityCore" then
						AIO.Handle("GameMasterSystem", "spawnGameObject", trimmedEntry)
					elseif coreName == "AzerothCore" then
						SendChatMessage(".gobject add " .. trimmedEntry, "SAY")
					end
				end,
				notCheckable = true,
			},
			MenuItems.createDelete(MENU_CONFIG.TYPES.GAMEOBJECT, trimmedEntry, function(entry)
				AIO.Handle("GameMasterSystem", "deleteGameObjectEntity", entry)
			end),
			MenuItems.CANCEL,
		}
	end,

	createSpellMenu = function(entity)
		local trimmedEntry = trimSpaces(entity.spellID)
		return {
			MenuItems.createTitle("Spell ID: " .. trimmedEntry),
			{
				text = "Learn",
				func = function()
					AIO.Handle("GameMasterSystem", "learnSpellEntity", trimmedEntry)
				end,
				notCheckable = true,
			},
			MenuItems.createDelete(MENU_CONFIG.TYPES.SPELL, trimmedEntry, function(entry)
				AIO.Handle("GameMasterSystem", "deleteSpellEntity", entry)
			end),
			{
				text = "Cast on Self",
				func = function()
					AIO.Handle("GameMasterSystem", "castSelfSpellEntity", trimmedEntry)
				end,
				notCheckable = true,
			},
			{
				text = "Cast from Target",
				func = function()
					AIO.Handle("GameMasterSystem", "castTargetSpellEntity", trimmedEntry)
				end,
				notCheckable = true,
			},
			{
				text = "Copy Icon",
				func = function()
					copyIcon(entity)
				end,
				notCheckable = true,
			},
			MenuItems.CANCEL,
		}
	end,

	createSpellVisualMenu = function(entity)
		local trimmedEntry = trimSpaces(entity.spellVisualID)

		return {
			MenuItems.createTitle("SpellVisual ID: " .. trimmedEntry),
			{
				text = "Copy spellVisual",
				func = function()
					print(entity.FilePath)
					local editBox = CreateFrame("EditBox")
					editBox:SetText(entity.FilePath)
					editBox:HighlightText()
					print("Ctrl+C to copy the path")
					editBox:SetScript("OnEscapePressed", function(self)
						self:ClearFocus()
						self:Hide()
					end)
					editBox:SetScript("OnEnterPressed", function(self)
						self:ClearFocus()
						self:Hide()
					end)
				end,
				notCheckable = true,
			},
			MenuItems.CANCEL,
		}
	end,
}

-- Create single context menu instance
local contextMenu = MenuFactory.createContextMenu()

-- Show menu functions
local function showContextMenu(menuType, card, entity)
	local menuCreators = {
		npc = MenuFactory.createNpcMenu,
		gameobject = MenuFactory.createGameObjectMenu,
		spell = MenuFactory.createSpellMenu,
		spellvisual = MenuFactory.createSpellVisualMenu,
	}

	local menuCreator = menuCreators[menuType]
	if menuCreator then
		EasyMenu(menuCreator(entity), contextMenu, "cursor", 0, 0, "MENU")
	end
end
>>>>>>> fc1ced3df299c9e422fb17154d9b67b2dd0ac91e

-- Constants
local SEARCH_CONFIG = {
	TEXTURES = {
		SEARCH = "Interface\\Common\\UI-Searchbox-Icon",
		CLEAR = "Interface\\Buttons\\UI-Panel-MinimizeButton-Up",
	},
	SIZE = {
		WIDTH = 200,
		HEIGHT = 20,
		ICON = 14,
	},
	INSETS = 5,
}

-- Function to create search input field
local function createSearchInput(parent)
	-- Create main editbox using 3.3.5 template
	local searchBox = CreateFrame("EditBox", nil, parent)
	searchBox:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	searchBox:SetBackdropColor(0, 0, 0, 0.5)
	searchBox:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)

	-- Basic setup
	searchBox:SetSize(SEARCH_CONFIG.SIZE.WIDTH, SEARCH_CONFIG.SIZE.HEIGHT)
	searchBox:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -50, -10)
	searchBox:SetFontObject("GameFontHighlight")
	searchBox:SetTextInsets(SEARCH_CONFIG.INSETS, SEARCH_CONFIG.INSETS, 0, 0)
	searchBox:SetAutoFocus(false)
	searchBox:EnableMouse(true)

	-- Placeholder text (using GameFontDisable for gray color)
	local placeholder = searchBox:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	placeholder:SetPoint("LEFT", searchBox, "LEFT", SEARCH_CONFIG.INSETS, 0)
	placeholder:SetText("Search...")

	-- Search icon (left side)
	-- local searchIcon = searchBox:CreateTexture(nil, "ARTWORK")
	-- searchIcon:SetTexture(SEARCH_CONFIG.TEXTURES.SEARCH)
	-- searchIcon:SetSize(SEARCH_CONFIG.SIZE.ICON, SEARCH_CONFIG.SIZE.ICON)
	-- searchIcon:SetPoint("LEFT", searchBox, "LEFT", -18, 0)

	-- Clear button (right side)
	local clearButton = CreateFrame("Button", nil, searchBox)
	clearButton:SetSize(SEARCH_CONFIG.SIZE.ICON, SEARCH_CONFIG.SIZE.ICON)
	clearButton:SetPoint("RIGHT", searchBox, "RIGHT", -SEARCH_CONFIG.INSETS, 0)
	clearButton:SetNormalTexture(SEARCH_CONFIG.TEXTURES.CLEAR)
	clearButton:Hide()

	-- Reset function
	local function resetSearch()
		searchBox:SetText("")
		searchBox:ClearFocus()
		placeholder:Show()
		clearButton:Hide()
		currentSearchQuery = ""
		currentOffset = 0
		if config.handleAIO then
			config.handleAIO(activeTab, currentSearchQuery, currentOffset, config.PAGE_SIZE, sortOrder)
		end
	end
	-- This function creates an overlay frame that covers the entire screen and then clears the search box focus when clicked
	local function createOverlay()
		local overlay = CreateFrame("Frame", nil, UIParent)
		overlay:SetFrameStrata("FULLSCREEN_DIALOG")
		overlay:SetAllPoints(UIParent)
		overlay:EnableMouse(true)
		overlay:Hide()

		overlay:SetScript("OnMouseDown", function(self)
			searchBox:ClearFocus()
			self:Hide()
		end)

		return overlay
	end

	local clickOutOverlay = createOverlay()

	-- Event handlers

	searchBox:SetScript("OnEditFocusGained", function(self)
		clickOutOverlay:Show()
	end)

	searchBox:SetScript("OnEditFocusLost", function(self)
		clickOutOverlay:Hide()
	end)

	searchBox:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
		clickOutOverlay:Hide()
		-- resetSearch()
	end)
	searchBox:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
		clickOutOverlay:Hide()
	end)
	searchBox:SetScript("OnTextChanged", function(self)
		local text = self:GetText()
		if text and text ~= "" then
			placeholder:Hide()
			clearButton:Show()
			currentSearchQuery = text
			currentOffset = 0
			if config.handleAIO then
				config.handleAIO(activeTab, text, currentOffset, config.PAGE_SIZE, sortOrder)
			end
		else
			placeholder:Show()
			clearButton:Hide()
		end
	end)

	-- Right-click clear
	searchBox:SetScript("OnMouseDown", function(self, button)
		if button == "RightButton" then
			resetSearch()
		end
	end)

	-- Clear button functionality
	clearButton:SetScript("OnClick", resetSearch)

	return searchBox
end

-- Constants for model interaction
local MODEL_CONFIG = {
	SCALE = {
		MIN = 0.5,
		MAX = 2.0,
		STEP = 0.1,
	},
	ROTATION = {
		SPEED = 0.005,
	},
	POSITION = {
		SPEED = 0.005,
		DEFAULT = {
			X = 0,
			Y = 0,
			Z = 0,
		},
	},
}

-- Helper function to clamp values
local function clamp(value, min, max)
	return math.min(math.max(value, min), max)
end

-- Handle model rotation
local function handleModelRotation(model, mouseX, dragStartX, initialFacing)
	local deltaX = (mouseX - dragStartX) * MODEL_CONFIG.ROTATION.SPEED
	local newFacing = initialFacing + deltaX
	model:SetFacing(newFacing)
	return newFacing
end

-- Handle model position
local function handleModelPosition(model, mouseY, dragStartY, initialPosition)
	local deltaY = (mouseY - dragStartY) * MODEL_CONFIG.POSITION.SPEED
	local newZ = initialPosition.z + deltaY
	model:SetPosition(initialPosition.x, initialPosition.y, newZ)
	return newZ
end

-- Handle model scaling
local function handleModelScale(model, delta, currentScale)
	if delta > 0 and currentScale < MODEL_CONFIG.SCALE.MAX then
		return model:SetModelScale(
			clamp(currentScale + MODEL_CONFIG.SCALE.STEP, MODEL_CONFIG.SCALE.MIN, MODEL_CONFIG.SCALE.MAX)
		)
	elseif delta < 0 and currentScale > MODEL_CONFIG.SCALE.MIN then
		return model:SetModelScale(
			clamp(currentScale - MODEL_CONFIG.SCALE.STEP, MODEL_CONFIG.SCALE.MIN, MODEL_CONFIG.SCALE.MAX)
		)
	end
	return currentScale
end

-- Main setup function
local function setupModelInteraction(model)
	if not model then
		return
	end

	-- Initialize state
	local state = {
		facing = model:GetFacing(),
		position = {
			x = MODEL_CONFIG.POSITION.DEFAULT.X,
			y = MODEL_CONFIG.POSITION.DEFAULT.Y,
			z = MODEL_CONFIG.POSITION.DEFAULT.Z,
		},
		isDragging = false,
		dragStart = { x = 0, y = 0 },
	}

	-- Set initial position
	model:SetPosition(state.position.x, state.position.y, state.position.z)

	-- Enable mouse interaction
	model:EnableMouse(true)
	model:SetMovable(false)

	-- Middle mouse button drag handlers
	model:SetScript("OnMouseDown", function(self, button)
		if button == "MiddleButton" then
			state.isDragging = true
			state.dragStart.x, state.dragStart.y = GetCursorPosition()
		end
	end)

	model:SetScript("OnMouseUp", function(self, button)
		if button == "MiddleButton" then
			state.isDragging = false
		end
	end)

	-- Model update handler
	model:SetScript("OnUpdate", function(self)
		if state.isDragging then
			local mouseX, mouseY = GetCursorPosition()

			-- Update model rotation
			state.facing = handleModelRotation(self, mouseX, state.dragStart.x, state.facing)

			-- Update model position
			state.position.z = handleModelPosition(self, mouseY, state.dragStart.y, state.position)

			-- Update drag start position
			state.dragStart.x, state.dragStart.y = mouseX, mouseY
		end
	end)

	-- Mouse wheel zoom
	model:EnableMouseWheel(true)
	model:SetScript("OnMouseWheel", function(self, delta)
		local currentScale = self:GetModelScale()
		handleModelScale(self, delta, currentScale)
	end)
end

-- Constants
local VIEW_CONFIG = {
	ICONS = {
		MAGNIFIER = "Interface\\Icons\\INV_Misc_Spyglass_03",
		INFO = "Interface\\Icons\\INV_Misc_Book_09",
	},
	TEXTURES = {
		BACKDROP = "Interface\\DialogFrame\\UI-DialogBox-Background",
		BORDER = "Interface\\Tooltips\\UI-Tooltip-Border",
	},
	SIZES = {
		ICON = 16,
		FULL_VIEW = 400,
		TILE = 16,
		INSETS = 5,
	},
}

-- Create full view frame
local function createFullViewFrame(index)
	local frame = CreateFrame("Frame", "FullViewFrame" .. index, UIParent)
	frame:SetPoint("CENTER")
	frame:SetSize(VIEW_CONFIG.SIZES.FULL_VIEW, VIEW_CONFIG.SIZES.FULL_VIEW)
	frame:SetFrameStrata("DIALOG")
	frame:EnableMouse(true)
	frame:SetMovable(true)

	frame:SetBackdrop({
		bgFile = VIEW_CONFIG.TEXTURES.BACKDROP,
		edgeFile = VIEW_CONFIG.TEXTURES.BORDER,
		tile = true,
		tileSize = VIEW_CONFIG.SIZES.TILE,
		edgeSize = VIEW_CONFIG.SIZES.TILE,
		insets = {
			left = VIEW_CONFIG.SIZES.INSETS,
			right = VIEW_CONFIG.SIZES.INSETS,
			top = VIEW_CONFIG.SIZES.INSETS,
			bottom = VIEW_CONFIG.SIZES.INSETS,
		},
	})

	return frame
end

-- Constants for menu types
local BUTTON_CONFIG = {

	TOOLTIP = {
		TEXT = "Right-click to open context menu\nYou can hold middle mouse to move and scroll",
	},
}

-- Create info button
local function createInfoButton(parent, entity, type)
	if not parent or not entity or not type then
		return nil
	end

	local button = CreateFrame("Button", nil, parent)
	button:SetSize(VIEW_CONFIG.SIZES.ICON, VIEW_CONFIG.SIZES.ICON)
	button:SetPoint("TOPLEFT", parent, "TOPLEFT", 5, -5)
	button:SetNormalTexture(VIEW_CONFIG.ICONS.INFO)
	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
	button:GetHighlightTexture():SetBlendMode("ADD")

	button:SetScript("OnMouseUp", function(self, mouseButton)
		if mouseButton == "RightButton" then
			showContextMenu(MENU_CONFIG.TYPES[type:upper()], parent, entity)
		end
	end)

	addSimpleTooltip(button, BUTTON_CONFIG.TOOLTIP.TEXT)
	return button
end

-- Create model view
local function createModelView(parent, entity, type, index)
	local model = CreateFrame("DressUpModel", "FullModel" .. index, parent)
	model:SetAllPoints(parent)
	model:SetFrameStrata("DIALOG")
	model:SetFrameLevel(parent:GetFrameLevel() + 1)
	model:EnableMouse(true)
	model:SetMovable(true)
	model:ClearModel()

	-- Set up drag functionality
	model:RegisterForDrag("LeftButton")
	model:SetScript("OnDragStart", function()
		parent:StartMoving()
	end)
	model:SetScript("OnDragStop", function()
		parent:StopMovingOrSizing()
	end)

	-- Set model based on type
	local modelSetters = {
		NPC = function()
			model:SetCreature(entity.entry)
		end,
		GameObject = function()
			model:SetModel(entity.modelName)
		end,
		Spell = function()
			model:SetSpellVisualKit(entity.spellID)
		end,
		SpellVisual = function()
			model:SetModel(entity.FilePath)
		end,
	}

	if modelSetters[type] then
		modelSetters[type]()
	end

	model:SetRotation(math.rad(30))
	setupModelInteraction(model)

	return model
end

-- Main function to add magnifier icon
local function addMagnifierIcon(card, entity, index, type)
	local button = CreateFrame("Button", "MagnifierButton" .. index, card)
	button:SetSize(VIEW_CONFIG.SIZES.ICON, VIEW_CONFIG.SIZES.ICON)
	button:SetPoint("TOPRIGHT", card, "TOPRIGHT", -5, -5)
	button:SetNormalTexture(VIEW_CONFIG.ICONS.MAGNIFIER)
	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
	button:GetHighlightTexture():SetBlendMode("ADD")

	button:SetScript("OnClick", function()
		local fullViewFrame = createFullViewFrame(index)
		local closeButton = CreateFrame("Button", nil, fullViewFrame, "UIPanelCloseButton")
		closeButton:SetPoint("TOPRIGHT", fullViewFrame, "TOPRIGHT")
		closeButton:SetFrameLevel(fullViewFrame:GetFrameLevel() + 2)

		local infoButton = createInfoButton(fullViewFrame, entity, type)
		local modelView = createModelView(fullViewFrame, entity, type, index)
	end)

	return button
end

-- Helper function to set up common card properties
local function setupCard(card, parent, i, cardWidth, cardHeight)
	card:SetSize(cardWidth, cardHeight)
	card:EnableMouse(true)
	card:SetPoint(
		"TOPLEFT",
		parent,
		"TOPLEFT",
		10 + ((i - 1) % config.NUM_COLUMNS) * (cardWidth + 10),
		-10 - math.floor((i - 1) / config.NUM_COLUMNS) * (cardHeight + 10)
	)
	card:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	card:SetBackdropColor(0, 0, 0, 0.5)

	-- Add highlight texture
	local highlight = card:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
	highlight:SetBlendMode("ADD")
	highlight:SetAllPoints()
end

-- Function to create NPC card
local function createNPCCard(card, entity, i)
	local model = CreateFrame("DressUpModel", "modelNpc" .. i, card)
	model:SetSize(card:GetWidth() - 30, card:GetHeight() - 40)
	model:SetPoint("CENTER", card, "CENTER", 0, 15)
	model:SetFrameStrata("DIALOG")
	model:ClearModel()
	model:SetCreature(entity.entry)
	model:SetRotation(math.rad(30))

	local name = entity.name .. "\n" .. (entity.subname or "")
	card.nameText:SetText(name)
	card.entityText:SetText("Creature ID: " .. entity.entry)
	card.additionalText:SetText("Model ID: " .. (entity.modelid[1] or entity.modelid))

	card:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(entity.name)
		GameTooltip:AddLine("Creature ID: " .. entity.entry, 1, 1, 1)
		GameTooltip:AddLine("Model ID: " .. (entity.modelid[1] or entity.modelid), 1, 1, 1)
		GameTooltip:AddLine("Name: " .. entity.name, 1, 1, 1)
		GameTooltip:AddLine("Subname: " .. (entity.subname or ""), 1, 1, 1)
		GameTooltip:Show()
	end)

	card:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	card:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then
			showContextMenu(MENU_CONFIG.TYPES.NPC, card, entity)
		end
	end)
	addMagnifierIcon(card, entity, i, "NPC")
end

-- Function to create GameObject card
local function createGameObjectCard(card, entity, i)
	local model = CreateFrame("DressUpModel", "modelGob" .. i, card)
	model:SetSize(card:GetWidth() - 30, card:GetHeight() - 40)
	model:SetPoint("CENTER", card, "CENTER", 0, 25)
	model:SetFrameStrata("DIALOG")
	model:ClearModel()

	local modelPath = entity.modelName or "World\\Generic\\ActiveDoodads\\Chest02\\Chest02.mdx"
	local success, err = pcall(function()
		model:SetModel(modelPath)
	end)
	if not success then
		model:SetModel("World\\Generic\\ActiveDoodads\\Chest02\\Chest02.mdx")
		local errorMsg = model:CreateFontString(nil, "OVERLAY")
		errorMsg:SetFontObject("GameFontNormalLarge")
		errorMsg:SetPoint("CENTER")
		errorMsg:SetText("ERROR")
		errorMsg:SetTextColor(1, 0, 0, 1)
	end

	model:SetRotation(math.rad(30))
	card.nameText:SetText(entity.name)
	card.entityText:SetText("GameObject ID: " .. entity.entry)
	card.additionalText:SetText("Display ID: " .. entity.displayid)

	card:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then
			showContextMenu(MENU_CONFIG.TYPES.GAMEOBJECT, card, entity)
		end
	end)
	addMagnifierIcon(card, entity, i, "GameObject")
end

-- Function to create Spell card
local function createSpellCard(card, entity)
	local name, rank, icon = GetSpellInfo(entity.spellID)
	card.iconTexture = card:CreateTexture(nil, "ARTWORK")
	card.iconTexture:SetSize(32, 32)
	card.iconTexture:SetPoint("CENTER")
	card.iconTexture:SetTexture(icon or "Interface\\Icons\\INV_Misc_QuestionMark")
	card.nameText:SetText(name .. "\n" .. (rank or ""))
	card.entityText:SetText("Spell ID: " .. entity.spellID)
	card.additionalText:SetText("Icon: " .. (icon or "N/A"))

	card:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetSpellByID(entity.spellID)
		if GameTooltip:NumLines() == 0 then
			GameTooltip:SetText(
				"|cffffff00Description:|r "
					.. (entity.spellDescription or "N/A")
					.. "\n\n|cffffff00Tooltip:|r "
					.. (entity.spellToolTip or "N/A"),
				nil,
				nil,
				nil,
				nil,
				true
			)
		end
		GameTooltip:Show()
	end)

	card:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	card:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then
			showContextMenu(MENU_CONFIG.TYPES.SPELL, card, entity)
		end
	end)
end

-- Function to create SpellVisual card
local function createSpellVisualCard(card, entity, i)
	-- Set up the spell visual model
	local model = CreateFrame("DressUpModel", "modelSpellVisual" .. i, card)
	model:SetSize(card:GetWidth() - 30, card:GetHeight() - 40)
	model:SetPoint("CENTER", card, "CENTER", 0, 15)
	model:SetFrameStrata("DIALOG")
	model:ClearModel()
	model:SetModel(entity.FilePath)

	card.nameText:SetText(entity.Name or "N/A")
	card.entityText:SetText("Visual ID: " .. entity.ID)
	card.additionalText:SetText("FilePath: " .. entity.FilePath)

	card:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(entity.tooltip or "No additional information.")
		GameTooltip:Show()
	end)

	card:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	-- Right-click context menu
	card:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then
			showContextMenu(MENU_CONFIG.TYPES.SPELLVISUAL, card, entity)
		end
	end)
	addMagnifierIcon(card, entity, i, "SpellVisual")
end

-- Main function to generate cards for the given data
function config.generateCards(parent, data, type)
	local cards = {}
	local cardWidth, cardHeight = calculateCardDimensions(parent)
	local maxVisible = config.NUM_COLUMNS * config.NUM_ROWS

	for i = 1, math.min(#data, maxVisible) do
		local entity = data[i]
		local card = CreateFrame("Frame", "card" .. i, parent)
		setupCard(card, parent, i, cardWidth, cardHeight)

		card.nameText = card:CreateFontString(nil, "OVERLAY")
		card.nameText:SetFontObject("GameFontNormal")
		card.nameText:SetPoint("TOP", card, "TOP", 0, -10)
		card.nameText:SetWidth(cardWidth - 10)
		card.nameText:SetWordWrap(true)
		card.nameText:SetTextColor(1, 1, 1, 1)

		card.entityText = card:CreateFontString(nil, "OVERLAY")
		card.entityText:SetFontObject("GameFontNormal")
		card.entityText:SetPoint("BOTTOM", card, "BOTTOM", 0, 10)
		card.entityText:SetWidth(cardWidth - 10)
		card.entityText:SetWordWrap(true)
		card.entityText:SetTextColor(0.5, 0.5, 0.5, 1)

		card.additionalText = card:CreateFontString(nil, "OVERLAY")
		card.additionalText:SetFontObject("GameFontHighlight")
		card.additionalText:SetPoint("BOTTOM", card.entityText, "TOP", 0, 5)
		card.additionalText:SetWidth(cardWidth - 10)
		-- card.additionalText:SetWordWrap(true)
		-- set so text is smaller
		card.additionalText:SetFont("Fonts\\ARIALN.TTF", 10)

		card.additionalText:SetTextColor(0.5, 0.5, 0.5, 1)

		-- card.idText = card:CreateFontString(nil, "OVERLAY")
		-- card.idText:SetFontObject("GameFontNormal")
		-- card.idText:SetPoint("BOTTOM", card, "BOTTOM", 0, 10)
		-- card.idText:SetWidth(cardWidth - 10)
		-- card.idText:SetWordWrap(true)

		-- card.displayIdText = card:CreateFontString(nil, "OVERLAY")
		-- card.displayIdText:SetFontObject("GameFontNormal")
		-- card.displayIdText:SetPoint("BOTTOM", card.idText, "TOP", 0, 5)
		-- card.displayIdText:SetWidth(cardWidth - 10)
		-- card.displayIdText:SetWordWrap(true)

		if type == "NPC" then
			createNPCCard(card, entity, i)
		elseif type == "GameObject" then
			createGameObjectCard(card, entity, i)
		elseif type == "Spell" then
			createSpellCard(card, entity)
		elseif type == "SpellVisual" then
			createSpellVisualCard(card, entity, i)
		end

		cards[i] = card
	end

	return cards
end
-- Initialize the UI
local function initializeUI()
	mainFrame = createMainFrame()
	contentFrames = createContentFrames(mainFrame, menuItems)

	config.showTab(contentFrames, 1)
	currentOffset = 0
	config.handleAIO(activeTab, currentSearchQuery, currentOffset, config.PAGE_SIZE, sortOrder)

	createPaginationButtons(mainFrame)
	enableMouseWheelScrolling(mainFrame)
	createSearchInput(mainFrame)
	createSortOrderDropdown(mainFrame)

	-- Create the Kofi frame using the function
	local kofiFrame = createKofiFrame()
	-- Create the "Support Me" button
	local kofiButton = CreateFrame("Button", nil, mainFrame)
	kofiButton:SetSize(100, 30)
	kofiButton:SetPoint("BOTTOM", mainFrame, "BOTTOM", 0, 5)

	-- Create a font string with a glow effect
	local kofiButtonText = kofiButton:CreateFontString(nil, "OVERLAY")
	kofiButtonText:SetFontObject("GameFontNormal")
	kofiButtonText:SetPoint("CENTER", kofiButton, "CENTER", 0, 0)
	kofiButtonText:SetText("Support Me")
	kofiButtonText:SetTextColor(1, 1, 1, 1) -- White color
	kofiButtonText:SetShadowOffset(1, -1)
	kofiButtonText:SetShadowColor(0, 0, 0, 1) -- Black shadow

	-- Add glow effect and color cycling
	local totalElapsed = 0
	kofiButton:SetScript("OnUpdate", function(self, elapsed)
		totalElapsed = totalElapsed + elapsed
		if kofiFrame:IsShown() then
			kofiButton:LockHighlight()
			kofiButtonText:SetTextColor(1, 1, 0, 1)
		else
			kofiButton:UnlockHighlight()
			local r = (math.sin(totalElapsed * 2) + 1) / 2
			local g = (math.sin(totalElapsed * 2 + 2) + 1) / 2
			local b = (math.sin(totalElapsed * 2 + 4) + 1) / 2
			kofiButtonText:SetTextColor(r, g, b, 1)
		end
	end)

	kofiButton:SetNormalFontObject("GameFontNormal")
	kofiButton:SetHighlightFontObject("GameFontHighlight")
	kofiButton:SetScript("OnClick", function()
		if kofiFrame:IsShown() then
			kofiFrame:Hide()
		else
			kofiFrame:Show()
		end
	end)

	mainFrame:SetScript("OnShow", function()
		if kofiFrame.wasShown then
			kofiFrame:Show()
		end
	end)

	mainFrame:SetScript("OnHide", function()
		kofiFrame.wasShown = kofiFrame:IsShown()
		kofiFrame:Hide()
	end)

	kofiButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText("Support me by donating on my Ko-fi!")
		GameTooltip:Show()
	end)

	kofiButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	-- tinsert closes the frame with the escape key
	tinsert(UISpecialFrames, "MainFrame")
end

-- Open the UI with a slash command
SLASH_GAMEMASTERUI1 = "/gmui"
SlashCmdList["GAMEMASTERUI"] = function(msg)
	if mainFrame then
		if mainFrame:IsShown() then
			mainFrame:Hide()
		else
			-- debugMessage("Opening Game Master UI")
			if not isGmLevelFetched then
				-- debugMessage("Fetching GM Level")
				AIO.Handle("GameMasterSystem", "handleGMLevel")
			end
			if not isCoreNameFetched then
				-- debugMessage("Fetching Core Name")
				AIO.Handle("GameMasterSystem", "getCoreName")
			end

			-- Delay to ensure gmLevel is updated before checking
			customTimer(0.2, function()
				if gmLevel >= config.REQUIRED_GM_LEVEL then
					-- debugMessage("Opening Game Master UI with GM Level: ", gmLevel)
					mainFrame:ClearAllPoints()
					mainFrame:SetPoint("CENTER")
					mainFrame:Show()

					config.handleAIO(activeTab, currentSearchQuery, currentOffset, config.PAGE_SIZE, sortOrder)
				else
					print("You do not have the required GM rank to use this command.")
				end
			end)
		end
	else
		print("Game Master UI is not initialized.")
	end
end

print("|cff00ff00Game Master UI can be toggled with /gmui|r")

initializeUI()
