local triggerItem = 414                    -- Item that triggers the menu when used

local checkClassRestrictionsEnabled = true -- Set to false to disable class restrictions so mage can upgrade warrior items and vice versa


local itemsPerPage = 10                                -- Number of items to display per page

local custom_item_upgrader = "custom_item_upgrader_v1" -- Name of the table in the database
----------------------------------------------------------
-----------------[Don't edit below]-----------------------
----------------------------------------------------------



if not WorldDBQuery("SHOW TABLES LIKE '" .. custom_item_upgrader .. "'") then
	WorldDBExecute([[
				CREATE TABLE IF NOT EXISTS `]] .. custom_item_upgrader .. [[` (
					`entry` int(10) NOT NULL,
					`upgraded_entry` int(10) NOT NULL,
					`cost_1` int(10) NOT NULL DEFAULT '0',
					`amount_1` int(10) NOT NULL DEFAULT '0',
					`cost_2` int(10) NOT NULL DEFAULT '0',
					`amount_2` int(10) NOT NULL DEFAULT '0',
					`cost_3` int(10) NOT NULL DEFAULT '0',
					`amount_3` int(10) NOT NULL DEFAULT '0',
					`chance` int(10) NOT NULL DEFAULT '0'
				) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		]])
end

local debug = false -- Set to true to enable debug messages in console (not recommended for live server)



local function debugMessage(...)
	if (debug == true) then
		print("DEBUG: ", ...)
	end
end


-- math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))) --Random number seed
local itemUpgrades = {}
local itemClasses = {}

local allowedClasses = {
	[1] = "Warrior",
	[2] = "Paladin",
	[3] = "Hunter",
	[4] = "Rogue",
	[5] = "Priest",
	[6] = "Death Knight",
	[7] = "Shaman",
	[8] = "Mage",
	[9] = "Warlock",
	[11] = "Druid"
}

-- Define a new function to perform the database query
local function loadItemUpgrades()
	local result = WorldDBQuery(
		"SELECT entry, upgraded_entry, cost_1, amount_1, cost_2, amount_2, cost_3, amount_3, chance FROM " ..
		custom_item_upgrader
	)

	if result then
		repeat
			local entry, upgraded_entry, cost_1, amount_1, cost_2, amount_2, cost_3, amount_3, chance = result:GetUInt32(0),
					result:GetUInt32(1),
					result:GetUInt32(2), result:GetUInt32(3), result:GetUInt32(4), result:GetUInt32(5), result:GetUInt32(6),
					result:GetUInt32(7), result:GetUInt32(8)
			itemUpgrades[entry] = { upgraded_entry, cost_1, amount_1, cost_2, amount_2, cost_3, amount_3, chance }

			debugMessage("Item", entry, "Upgrade", upgraded_entry, "Item Cost 1", cost_1, "Cost Amount 1", amount_1,
				"Item Cost 2", cost_2, "Cost Amount 2", amount_2, "Item Cost 3", cost_3, "Cost Amount 3", amount_3, "Chance",
				chance)
		until not result:NextRow()
	end
end



local function loadItemClasses()
	-- local result = WorldDBQuery("SELECT entry, AllowableClass FROM item_template")
	local result = WorldDBQuery("SELECT entry, AllowableClass FROM item_template WHERE AllowableClass > 0")

	if result then
		repeat
			local entry, AllowableClass = result:GetUInt32(0), result:GetUInt32(1)
			if AllowableClass ~= 0 then
				-- If AllowableClass is -1, set it to a bitmask representing all classes
				if AllowableClass == -1 then
					AllowableClass = 0x7FF -- Bitmask for all classes (1+2+4+8+16+32+64+128+256+1024)
				end
				itemClasses[entry] = AllowableClass
				debugMessage("Item", entry, "AllowableClass", AllowableClass)
			end
		until not result:NextRow()
	end
end


local function loadDataBase()
	loadItemUpgrades()
	loadItemClasses()
end

loadDataBase()


local function bitwise_and(a, b)
	local result = 0
	local bitval = 1
	while a > 0 and b > 0 do
		if a % 2 == 1 and b % 2 == 1 then -- if last bits of a and b are 1
			result = result + bitval      -- set a bit of result to 1
		end
		bitval = bitval * 2             -- shift to next bit
		a = math.floor(a / 2)           -- shift bits to right
		b = math.floor(b / 2)
	end
	return result
end

local function checkClassRestrictions(item, class)
	local allowableClassMask = itemClasses[item]
	if allowableClassMask then
		-- Shift 1 to the left by (class - 1) places to create a mask for the class
		local classMask = 2 ^ (class - 1)
		-- Check if the bitwise AND of allowableClassMask and classMask is not zero
		-- If it's not zero, then the class is allowed
		return bitwise_and(allowableClassMask, classMask) ~= 0
	else
		-- If the item is not in the itemClasses array, assume it has no class restrictions
		return true
	end
end

local currentPage = 1 -- Current page number
local totalPages = 1  -- Total number of pages

local function stripColor(s)
	return string.gsub(s, "|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
end

local function GetItemLinkWithColor(entry, color)
	local itemTemplate = GetItemTemplate(entry)
	if itemTemplate then
			local itemName = itemTemplate:GetName()
			local itemLink = string.format("|Hitem:%d|h[%s]|h", entry, itemName)
			return color .. itemLink .. "|r"
	end
	return nil
end

local function itemHello(event, player, item, target)
	-- if (player:IsInCombat()) then
	-- 	player:SendAreaTriggerMessage("You are in combat!")
	-- 	return
	-- end
	if debug then
		player:SendAreaTriggerMessage("DEBUG MODE ENABLED")
		player:MoveTo(0, player:GetX() + 0, player:GetY(), player:GetZ())
	end

	player:GossipClearMenu()

	-- get table data from itemUpgrades
	local items = {}

	for entry, upgradeData in pairs(itemUpgrades) do
		-- Check if player has the item
		if player:HasItem(entry) then
			if not checkClassRestrictionsEnabled or checkClassRestrictions(entry, player:GetClass()) then
				table.insert(items, { entry, upgradeData })
			end
			-- table.insert(items, { entry, upgradeData })
		end
	end


	local totalItems = #items
	totalPages = math.ceil(totalItems / itemsPerPage)

	-- Display items for the current page
	local start = (currentPage - 1) * itemsPerPage + 1
	local end_ = math.min(start + itemsPerPage - 1, totalItems)
	for i = start, end_ do
			local itemData = items[i]
			if itemData then
					local entry = itemData[1]
					local upgradeData = itemData[2]
					local upgradeText = string.format("Upgrade %s to %s",
							GetItemLinkWithColor(entry, "|cFFFF0000"),
							GetItemLinkWithColor(upgradeData[1], "|cFF00FF00")
					)
					player:GossipMenuAddItem(1, upgradeText, 0, entry)
			end
	end


	-- Add "Previous Page" and "Next Page" options if necessary
	if currentPage > 1 then
		debugMessage("Previous Page", currentPage, totalPages, currentPage - 1)
		player:GossipMenuAddItem(0, "Previous Page", 0, currentPage - 1)
	end
	if currentPage < totalPages then
		debugMessage("Next Page", currentPage, totalPages, currentPage + 1)
		player:GossipMenuAddItem(0, "Next Page", 0, currentPage + 1)
	end

	player:GossipSendMenu(1, item)
end

local function hasCost(player, upgradeData, index)
	local costIndex = index * 2
	local amountIndex = costIndex + 1
	if upgradeData[costIndex] <= 0 or upgradeData[amountIndex] <= 0 then
		-- If the cost or amount is zero or negative, the upgrade is free
		return true
	else
		-- Otherwise, check if the player has the necessary items
		return player:HasItem(upgradeData[costIndex], upgradeData[amountIndex])
	end
end

local function removeCost(player, upgradeData, index)
	local costIndex = index * 2
	local amountIndex = costIndex + 1
	if hasCost(player, upgradeData, index) then
		player:RemoveItem(upgradeData[costIndex], upgradeData[amountIndex])
	end
end

local function upgradeItem(player, intid, upgradeData)
	-- If the "Confirm Upgrade" button was clicked, perform the upgrade
	if player:HasItem(intid) and hasCost(player, upgradeData, 1) and hasCost(player, upgradeData, 2) and hasCost(player, upgradeData, 3) then
		-- Generate a random number between 1 and 100
		local rand = math.random(100)

		-- Check if the random number is less than or equal to the upgrade chance
		if rand <= upgradeData[8] then
			-- Remove the original item and the upgrade cost from the player's inventory
			player:RemoveItem(intid, 1)
			for i = 1, 3 do
				removeCost(player, upgradeData, i)
			end

			-- Add the upgraded item to the player's inventory
			player:AddItem(upgradeData[1], 1)

			player:SendBroadcastMessage("Item upgraded successfully.")
		else
			-- Remove the upgrade cost from the player's inventory
			for i = 1, 3 do
				removeCost(player, upgradeData, i)
			end

			player:SendBroadcastMessage("Upgrade attempt failed, The materials were consumed.")
		end
	else
		player:SendBroadcastMessage("You do not have the necessary items to upgrade.")
	end
end


local function itemSelect(event, player, object, sender, intid, code, menuId)
	local function changePage(delta)
		currentPage = currentPage + delta
		itemHello(event, player, object, sender)
	end

	local function addMenuItem(text)
		player:GossipMenuAddItem(1, text, 0, intid)
	end

	if intid == currentPage - 1 then
		changePage(-1)
		return
	elseif intid == currentPage + 1 then
		changePage(1)
		return
	end

	local upgradeData = itemUpgrades[intid]
	local upgradeIndices = { item = 1, cost1 = 2, amount1 = 3, cost2 = 4, amount2 = 5, cost3 = 6, amount3 = 7, chance = 8 }

	if sender == 1 then
		player:GossipComplete()
		upgradeItem(player, intid, upgradeData)
	elseif upgradeData then
		player:GossipClearMenu()
		local itemLink = GetItemLink(intid)
		local upgradeLink = GetItemLink(upgradeData[upgradeIndices.item])
		player:SendBroadcastMessage(string.format("You selected: %s", itemLink))
		player:SendBroadcastMessage(string.format("Upgrades to: %s", upgradeLink))

		local upgradeText = string.format("Upgrade %s to %s",
			"|cFFFF0000" .. stripColor(itemLink) .. "|r",
			"|cFF00FF00" .. stripColor(upgradeLink) .. "|r"
		)
		addMenuItem(upgradeText)

		local costText = "Cost:"
		for i = 1, 3 do
			local costIndex = upgradeIndices["cost" .. i]
			local amountIndex = upgradeIndices["amount" .. i]
			if type(upgradeData[costIndex]) == 'number' and upgradeData[costIndex] > 0 and upgradeData[amountIndex] > 0 then
				costText = costText ..
				"\n" .. string.format("%dx %s", upgradeData[amountIndex], GetItemLink(upgradeData[costIndex]))
			end
		end

		if costText == "Cost:" then
			costText = costText .. " Free"
		end
		addMenuItem(costText)

		local chanceText = string.format("Chance: %d%%", upgradeData[upgradeIndices.chance])
		addMenuItem(chanceText)

		player:GossipMenuAddItem(0, "Confirm Upgrade", 1, intid, nil, "Are you sure you want to upgrade this item?")
	else
		player:SendBroadcastMessage("This item cannot be upgraded.")
	end

	player:GossipSendMenu(1, object)
end

RegisterItemEvent(triggerItem, 2, itemHello);
RegisterItemGossipEvent(triggerItem, 2, itemSelect);