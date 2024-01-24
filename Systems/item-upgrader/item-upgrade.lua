local triggerItem = 414                                -- Item that triggers the menu when used

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
-- Define a new function to perform the database query
local function loadDataBase()
	local result = WorldDBQuery(
		"SELECT entry, upgraded_entry, cost_1, amount_1, cost_2, amount_2,cost_3, amount_3, chance FROM custom_item_upgrader_v1")
	if (result) then
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

loadDataBase()

local currentPage = 1 -- Current page number
local totalPages = 1  -- Total number of pages

local function stripColor(s)
	return string.gsub(s, "|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
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
			table.insert(items, { entry, upgradeData })
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
				GetItemLink(entry),
				GetItemLink(upgradeData[1])
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

local function upgradeItem(player, intid, upgradeData)
	-- If the "Confirm Upgrade" button was clicked, perform the upgrade
	local hasCost1 = not (upgradeData[2] == 0 or upgradeData[2] == -1 or upgradeData[3] == 0 or upgradeData[3] == -1)
	local hasCost2 = not (upgradeData[4] == 0 or upgradeData[4] == -1 or upgradeData[5] == 0 or upgradeData[5] == -1)
	local hasCost3 = not (upgradeData[6] == 0 or upgradeData[6] == -1 or upgradeData[7] == 0 or upgradeData[7] == -1)

	if player:HasItem(intid) and
			(not hasCost1 or player:HasItem(upgradeData[2], upgradeData[3])) and
			(not hasCost2 or player:HasItem(upgradeData[4], upgradeData[5])) and
			(not hasCost3 or player:HasItem(upgradeData[6], upgradeData[7])) then
		-- Generate a random number between 1 and 100
		local rand = math.random(100)

		-- Check if the random number is less than or equal to the upgrade chance
		if rand <= upgradeData[8] then
			-- Remove the original item and the upgrade cost from the player's inventory
			player:RemoveItem(intid, 1)
			if hasCost1 then
				player:RemoveItem(upgradeData[2], upgradeData[3])
			end
			if hasCost2 then
				player:RemoveItem(upgradeData[4], upgradeData[5])
			end
			if hasCost3 then
				player:RemoveItem(upgradeData[6], upgradeData[7])
			end

			-- Add the upgraded item to the player's inventory
			player:AddItem(upgradeData[1], 1)

			player:SendBroadcastMessage("Item upgraded successfully.")
		else
			-- Remove the upgrade cost from the player's inventory
			if hasCost1 then
				player:RemoveItem(upgradeData[2], upgradeData[3])
			end
			if hasCost2 then
				player:RemoveItem(upgradeData[4], upgradeData[5])
			end
			if hasCost3 then
				player:RemoveItem(upgradeData[6], upgradeData[7])
			end

			player:SendBroadcastMessage("Upgrade attempt failed, The materials were consumed.")
		end
	else
		player:SendBroadcastMessage("You do not have the necessary items to upgrade.")
	end
end




local function itemSelect(event, player, object, sender, intid, code, menuId)
	-- Check if the intid corresponds to the "Next Page" or "Previous Page" options
	if intid == currentPage - 1 then
		-- "Previous Page" was clicked
		currentPage = currentPage - 1
		itemHello(event, player, object, sender)
		return
	elseif intid == currentPage + 1 then
		-- "Next Page" was clicked
		currentPage = currentPage + 1
		itemHello(event, player, object, sender)
		return
	end

	-- Retrieve the upgrade data for the clicked item
	local upgradeData = itemUpgrades[intid]

	if sender == 1 then
		player:GossipComplete() -- Close the menu
		-- itemHello(event, player, object, sender) ---- Reopen the menu
		upgradeItem(player, intid, upgradeData)
	elseif upgradeData then
		player:GossipClearMenu()
		local itemLink = GetItemLink(intid)
		local upgradeLink = GetItemLink(upgradeData[1])
		player:SendBroadcastMessage(string.format("You selected: %s", itemLink))
		player:SendBroadcastMessage(string.format("Upgrades to: %s", upgradeLink))
		-- Display the upgrade cost and chance in the submenu disabled cus i didnt like the layout change so it has its own rows now
		-- local upgradeText = string.format("Upgrade %s to %s\nCost: %dx %s and %dx %s\nChance: %d%%",
		-- 	GetItemLink(intid),
		-- 	GetItemLink(upgradeData[1]),
		-- 	upgradeData[3],
		-- 	GetItemLink(upgradeData[2]),
		-- 	upgradeData[5],
		-- 	GetItemLink(upgradeData[4]),
		-- 	upgradeData[6]
		-- )
		-- player:GossipMenuAddItem(1, upgradeText, 0, intid)
		-- Display the upgrade in the submenu

		local upgradeText = string.format("Upgrade %s to %s",
			"|cFFFF0000" .. stripColor(GetItemLink(intid)) .. "|r",
			"|cFF00FF00" .. stripColor(GetItemLink(upgradeData[1])) .. "|r"
		)
		player:GossipMenuAddItem(1, upgradeText, 0, intid)

		-- Display the cost in the submenu
		local costText = "Cost:"

		-- Check if the first cost item is valid
		if type(upgradeData[2]) == 'number' and upgradeData[2] > 0 and upgradeData[3] > 0 then
			costText = costText .. "\n" .. string.format("%dx %s", upgradeData[3], GetItemLink(upgradeData[2]))
		end

		-- Check if the second cost item is valid
		if type(upgradeData[4]) == 'number' and upgradeData[4] > 0 and upgradeData[5] > 0 then
			costText = costText .. "\n" .. string.format("%dx %s", upgradeData[5], GetItemLink(upgradeData[4]))
		end

		-- Check if the third cost item is valid
		if type(upgradeData[6]) == 'number' and upgradeData[6] > 0 and upgradeData[7] > 0 then
			costText = costText .. "\n" .. string.format("%dx %s", upgradeData[7], GetItemLink(upgradeData[6]))
		end

		-- If no cost items are valid, the upgrade is free
		if costText == "Cost:" then
			costText = costText .. " Free"
		end

		player:GossipMenuAddItem(1, costText, 0, intid)

		-- Display the chance in the submenu
		local chanceText = string.format("Chance: %d%%", upgradeData[8])
		player:GossipMenuAddItem(1, chanceText, 0, intid)
		-- Add a confirm button to the submenu
		player:GossipMenuAddItem(0, "Confirm Upgrade", 1, intid, nil, "Are you sure you want to upgrade this item?")


		-- player:GossipComplete()
	else
		-- If the clicked item does not have upgrade data, display an error message
		player:SendBroadcastMessage("This item cannot be upgraded.")
	end

	player:GossipSendMenu(1, object)
end

RegisterItemEvent(triggerItem, 2, itemHello);
RegisterItemGossipEvent(triggerItem, 2, itemSelect);
