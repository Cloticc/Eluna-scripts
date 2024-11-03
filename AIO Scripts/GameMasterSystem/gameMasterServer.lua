-- AIO for TrinityCore 3.3.5 with WoW client 3.3.5
local AIO = AIO or require("AIO")

local GameMasterSystem = AIO.AddHandlers("GameMasterSystem", {})

-- configuration
local config = {
	debug = false,
	defaultPageSize = 100,

	removeFromWorld = true,
}

-- Mapping of NPC type names to their corresponding type IDs
local npcTypes = {
	["none"] = 0,
	["beast"] = 1,
	["dragonkin"] = 2,
	["demon"] = 3,
	["elemental"] = 4,
	["giant"] = 5,
	["undead"] = 6,
	["humanoid"] = 7,
	["critter"] = 8,
	["mechanical"] = 9,
	["not specified"] = 10,
	["totem"] = 11,
	["non-combat pet"] = 12,
	["gas cloud"] = 13,
	["wild pet"] = 14,
	["aberration"] = 15,
}

-- Mapping of GameObject type names to their corresponding type IDs
local gameObjectTypes = {
	["door"] = 0,
	["button"] = 1,
	["questgiver"] = 2,
	["chest"] = 3,
	["binder"] = 4,
	["generic"] = 5,
	["trap"] = 6,
	["chair"] = 7,
	["spell focus"] = 8,
	["text"] = 9,
	["goober"] = 10,
	["transport"] = 11,
	["areadamage"] = 12,
	["camera"] = 13,
	["map object"] = 14,
	["mo transport"] = 15,
	["duel arbiter"] = 16,
	["fishingnode"] = 17,
	["summoning ritual"] = 18,
	["mailbox"] = 19,
	["do not use"] = 20,
	["guardpost"] = 21,
	["spellcaster"] = 22,
	["meetingstone"] = 23,
	["flagstand"] = 24,
	["fishinghole"] = 25,
	["flagdrop"] = 26,
	["mini game"] = 27,
	["do not use 2"] = 28,
	["capture point"] = 29,
	["aura generator"] = 30,
	["dungeon difficulty"] = 31,
	["barber chair"] = 32,
	["destructible_building"] = 33,
	["guild bank"] = 34,
	["trapdoor"] = 35,
}

-- Function to escape special characters in a string
local function escapeString(str)
	local replacements = {
		["\\"] = "\\\\",
		["'"] = "\\'",
		['"'] = '\\"',
		["%"] = "\\%",
		["_"] = "\\_",
	}
	return str:gsub("[\\'\"%%_]", replacements)
end

-- Function to display debug messages
local function debugMessage(...)
	if config.debug then
		print("DEBUG:", ...)
	end
end

-- Function to validate the page size
local function validatePageSize(pageSize)
	local minPageSize = 10
	local maxPageSize = 500
	if pageSize < minPageSize then
		return minPageSize
	elseif pageSize > maxPageSize then
		return maxPageSize
	else
		return pageSize
	end
end

-- Function to validate the sort order
local function validateSortOrder(order)
	local validOrders = {
		ASC = true,
		DESC = true,
	}
	return validOrders[order:upper()] and order:upper() or "ASC"
end

local queries = {
	TrinityCore = {
		loadCreatureDisplays = function()
			return [[
                SELECT `entry`, `name`, `subname`, `IconName`, `type_flags`, `type`, `family`, `rank`, `KillCredit1`, `KillCredit2`, `HealthModifier`, `ManaModifier`, `RacialLeader`, `MovementType`, `modelId1`, `modelId2`, `modelId3`, `modelId4`
                FROM `creature_template`
            ]]
		end,
		npcData = function(sortOrder, pageSize, offset)
			return string.format(
				[[
                SELECT entry, modelid1, modelid2, modelid3, modelid4, name, subname, type
                FROM creature_template
                WHERE modelid1 != 0 OR modelid2 != 0 OR modelid3 != 0 OR modelid4 != 0
                ORDER BY entry %s
                LIMIT %d OFFSET %d;
            ]],
				sortOrder,
				pageSize,
				offset
			)
		end,
		gobData = function(sortOrder, pageSize, offset)
			return string.format(
				[[
            SELECT g.entry, g.displayid, g.name, m.ModelName
            FROM gameobject_template g
            LEFT JOIN gameobjectdisplayinfo m ON g.displayid = m.ID
            ORDER BY g.entry %s
            LIMIT %d OFFSET %d;
            ]],
				sortOrder,
				pageSize,
				offset
			)
		end,
		spellData = function(sortOrder, pageSize, offset)
			return string.format(
				[[
            SELECT id, spellName0, spellDescription0, spellToolTip0
            FROM spell
            ORDER BY id %s
            LIMIT %d OFFSET %d;
            ]],
				sortOrder,
				pageSize,
				offset
			)
		end,
		searchNpcData = function(query, typeId, sortOrder, pageSize, offset)
			return string.format(
				[[
                SELECT entry, modelid1, modelid2, modelid3, modelid4, name, subname, type
                FROM creature_template
                WHERE name LIKE '%%%s%%' OR subname LIKE '%%%s%%' OR entry LIKE '%%%s%%' %s
                ORDER BY entry %s
                LIMIT %d OFFSET %d;
            ]],
				query,
				query,
				query,
				typeId and string.format("OR type = %d", typeId) or "",
				sortOrder,
				pageSize,
				offset * pageSize
			)
		end,
		searchGobData = function(query, typeId, sortOrder, pageSize, offset)
			return string.format(
				[[
                SELECT g.entry, g.displayid, g.name, g.type, m.ModelName
                FROM gameobject_template g
                LEFT JOIN gameobjectdisplayinfo m ON g.displayid = m.ID
                WHERE g.name LIKE '%%%s%%' OR g.entry LIKE '%%%s%%' %s
                ORDER BY g.entry %s
                LIMIT %d OFFSET %d;
            ]],
				query,
				query,
				typeId and string.format("OR g.type = %d", typeId) or "",
				sortOrder,
				pageSize,
				offset * pageSize
			)
		end,
		searchSpellData = function(query, sortOrder, pageSize, offset)
			return string.format(
				[[
                SELECT id, spellName0, spellDescription0, spellToolTip0
                FROM spell
                WHERE spellName0 LIKE '%%%s%%' OR id LIKE '%%%s%%'
                ORDER BY id %s
                LIMIT %d OFFSET %d;
            ]],
				query,
				query,
				sortOrder,
				pageSize,
				offset * pageSize
			)
		end,

		spellVisualData = function(sortOrder, pageSize, offset)
			return string.format(
				[[
            SELECT ID, Name, FilePath, AreaEffectSize, Scale, MinAllowedScale, MaxAllowedScale
            FROM spellvisualeffectname
            ORDER BY ID %s
            LIMIT %d OFFSET %d;
            ]],
				sortOrder,
				pageSize,
				offset
			)
		end,
		searchSpellVisualData = function(query, sortOrder, pageSize, offset)
			return string.format(
				[[
            SELECT ID, Name, FilePath, AreaEffectSize, Scale, MinAllowedScale, MaxAllowedScale
            FROM spellvisualeffectname
            WHERE Name LIKE '%%%s%%' OR ID LIKE '%%%s%%'
            ORDER BY ID %s
            LIMIT %d OFFSET %d;
            ]],
				query,
				query,
				sortOrder,
				pageSize,
				offset * pageSize
			)
		end,
	},

	AzerothCore = {
		loadCreatureDisplays = function()
			return [[
                SELECT ct.`entry`, ct.`name`, ct.`subname`, ct.`IconName`, ct.`type_flags`, ct.`type`, ct.`family`, ct.`rank`, ct.`KillCredit1`, ct.`KillCredit2`, ct.`HealthModifier`, ct.`ManaModifier`, ct.`RacialLeader`, ct.`MovementType`, ctm.`CreatureDisplayID`
                FROM `creature_template` ct
                LEFT JOIN `creature_template_model` ctm ON ct.`entry` = ctm.`CreatureID`
            ]]
		end,
		npcData = function(sortOrder, pageSize, offset)
			return string.format(
				[[
                SELECT ct.entry, ctm.CreatureDisplayID, ct.name, ct.subname, ct.type
                FROM creature_template ct
                LEFT JOIN creature_template_model ctm ON ct.entry = ctm.CreatureID
                ORDER BY ct.entry %s
                LIMIT %d OFFSET %d;
            ]],
				sortOrder,
				pageSize,
				offset
			)
		end,
		gobData = function(sortOrder, pageSize, offset)
			return string.format(
				[[
            SELECT g.entry, g.displayid, g.name, m.ModelName
            FROM gameobject_template g
            LEFT JOIN gameobjectdisplayinfo m ON g.displayid = m.ID
            ORDER BY g.entry %s
            LIMIT %d OFFSET %d;
            ]],
				sortOrder,
				pageSize,
				offset
			)
		end,
		spellData = function(sortOrder, pageSize, offset)
			return string.format(
				[[
                SELECT id, spellName0, spellDescription0, spellToolTip0
                FROM spell
                ORDER BY id %s
                LIMIT %d OFFSET %d;
            ]],
				sortOrder,
				pageSize,
				offset
			)
		end,
		searchNpcData = function(query, typeId, sortOrder, pageSize, offset)
			return string.format(
				[[
                SELECT ct.entry, ctm.CreatureDisplayID, ct.name, ct.subname, ct.type
                FROM creature_template ct
                LEFT JOIN creature_template_model ctm ON ct.entry = ctm.CreatureID
                WHERE ct.name LIKE '%%%s%%' OR ct.subname LIKE '%%%s%%' OR ct.entry LIKE '%%%s%%' %s
                ORDER BY ct.entry %s
                LIMIT %d OFFSET %d;
            ]],
				escapeString(query),
				escapeString(query),
				escapeString(query),
				typeId and string.format("OR ct.type = %d", typeId) or "",
				sortOrder,
				pageSize,
				offset
			)
		end,
		searchGobData = function(query, typeId, sortOrder, pageSize, offset)
			return string.format(
				[[
                SELECT g.entry, g.displayid, g.name, g.type, m.ModelName
                FROM gameobject_template g
                LEFT JOIN gameobjectdisplayinfo m ON g.displayid = m.ID
                WHERE g.name LIKE '%%%s%%' OR g.entry LIKE '%%%s%%' %s
                ORDER BY g.entry %s
                LIMIT %d OFFSET %d;
            ]],
				query,
				query,
				typeId and string.format("OR g.type = %d", typeId) or "",
				sortOrder,
				pageSize,
				offset * pageSize
			)
		end,
		searchSpellData = function(query, sortOrder, pageSize, offset)
			return string.format(
				[[
                SELECT id, spellName0, spellDescription0, spellToolTip0
                FROM spell
                WHERE spellName0 LIKE '%%%s%%' OR id LIKE '%%%s%%'
                ORDER BY id %s
                LIMIT %d OFFSET %d;
            ]],
				query,
				query,
				sortOrder,
				pageSize,
				offset * pageSize
			)
		end,
	},
}

-- Function to get the appropriate query based on the core name
local function getQuery(coreName, queryType)
	-- debugMessage("coreName: ", coreName , "queryType: ", queryType)
	return queries[coreName] and queries[coreName][queryType] or nil
end

--  Function to ge the spell visual data
function GameMasterSystem.getSpellVisualData(player, offset, pageSize, sortOrder)
	offset = offset or 0
	pageSize = validatePageSize(pageSize or config.defaultPageSize)
	sortOrder = validateSortOrder(sortOrder or "DESC")

	local coreName = GetCoreName()
	local query = getQuery(coreName, "spellVisualData")(sortOrder, pageSize, offset)

	local result = WorldDBQuery(query)

	local spellVisualData = {}

	if result then
		repeat
			local spellVisual = {
				ID = result:GetUInt32(0),
				Name = result:GetString(1),
				FilePath = result:GetString(2),
				AreaEffectSize = result:GetFloat(3),
				Scale = result:GetFloat(4),
				MinAllowedScale = result:GetFloat(5),
				MaxAllowedScale = result:GetFloat(6),
			}

			table.insert(spellVisualData, spellVisual)
		until not result:NextRow()
	end

	local hasMoreData = #spellVisualData == pageSize

	if #spellVisualData == 0 then
		player:SendBroadcastMessage("No spell visual data available for the given page.")
	else
		AIO.Handle(player, "GameMasterSystem", "receiveSpellVisualData", spellVisualData, offset, pageSize, hasMoreData)
	end
end

-- Function to search spell visual data
function GameMasterSystem.searchSpellVisualData(player, query, offset, pageSize, sortOrder)
	query = escapeString(query) -- Escape special characters
	sortOrder = validateSortOrder(sortOrder or "DESC")
	local coreName = GetCoreName()

	local searchQuery = getQuery(coreName, "searchSpellVisualData")(query, sortOrder, pageSize, offset)
	local result = WorldDBQuery(searchQuery)
	local spellVisualData = {}

	if result then
		repeat
			local spellVisual = {
				ID = result:GetUInt32(0),
				Name = result:GetString(1),
				FilePath = result:GetString(2),
				AreaEffectSize = result:GetFloat(3),
				Scale = result:GetFloat(4),
				MinAllowedScale = result:GetFloat(5),
				MaxAllowedScale = result:GetFloat(6),
			}
			table.insert(spellVisualData, spellVisual)
		until not result:NextRow()
	end

	local hasMoreData = #spellVisualData == pageSize

	if #spellVisualData == 0 then
		player:SendBroadcastMessage("No spell visual data found for the given query and page.")
	else
		AIO.Handle(player, "GameMasterSystem", "receiveSpellVisualData", spellVisualData, offset, pageSize, hasMoreData)
	end
end

-- Function to query NPC data from the database with pagination
function GameMasterSystem.getNPCData(player, offset, pageSize, sortOrder)
	offset = offset or 0
	pageSize = validatePageSize(pageSize or config.defaultPageSize)
	sortOrder = validateSortOrder(sortOrder or "DESC")
	local coreName = GetCoreName()
	local query = getQuery(coreName, "npcData")(sortOrder, pageSize, offset)
	local result = WorldDBQuery(query)
	local npcData = {}

	if result then
		repeat
			local npc = {
				entry = result:GetUInt32(0),
				modelid = {},
				name = result:GetString(coreName == "TrinityCore" and 5 or 2),
				subname = result:GetString(coreName == "TrinityCore" and 6 or 3),
				type = result:GetUInt32(coreName == "TrinityCore" and 7 or 4),
			}

			if coreName == "TrinityCore" then
				for i = 1, 4 do
					local modelId = result:GetUInt32(i)
					if modelId ~= 0 then
						table.insert(npc.modelid, modelId)
					end
				end
			elseif coreName == "AzerothCore" then
				local modelId = result:GetUInt32(1)
				if modelId ~= 0 then
					table.insert(npc.modelid, modelId)
				end
			end

			table.insert(npcData, npc)
		until not result:NextRow()
	end

	local hasMoreData = #npcData == pageSize
	if #npcData == 0 then
		player:SendBroadcastMessage("No NPC data available for the given page.")
	else
		AIO.Handle(player, "GameMasterSystem", "receiveNPCData", npcData, offset, pageSize, hasMoreData)
	end
end

-- Server-side handler to search NPC data
function GameMasterSystem.searchNPCData(player, query, offset, pageSize, sortOrder)
	query = escapeString(query) -- Escape special characters
	local typeId = nil
	sortOrder = validateSortOrder(sortOrder or "DESC")
	local coreName = GetCoreName()

	local typeQuery = query:match("^%((.-)%)$")
	if typeQuery then
		typeId = npcTypes[typeQuery]
		if not typeId then
			player:SendBroadcastMessage("Invalid NPC type: " .. typeQuery)
			return
		end
	end

	local searchQuery = getQuery(coreName, "searchNpcData")(query, typeId, sortOrder, pageSize, offset)
	local result = WorldDBQuery(searchQuery)
	local npcData = {}

	if result then
		repeat
			local npc = {
				entry = result:GetUInt32(0),
				modelid = {},
				name = result:GetString(coreName == "TrinityCore" and 5 or 2),
				subname = result:GetString(coreName == "TrinityCore" and 6 or 3),
				type = result:GetUInt32(coreName == "TrinityCore" and 7 or 4),
			}

			if coreName == "TrinityCore" then
				for i = 1, 4 do
					local modelId = result:GetUInt32(i)
					if modelId ~= 0 then
						table.insert(npc.modelid, modelId)
					end
				end
			elseif coreName == "AzerothCore" then
				local modelId = result:GetUInt32(1)
				if modelId ~= 0 then
					table.insert(npc.modelid, modelId)
				end
			end

			table.insert(npcData, npc)
		until not result:NextRow()
	end

	local hasMoreData = #npcData == pageSize
	if #npcData == 0 then
		player:SendBroadcastMessage("No NPC data found for the given query and page.")
	else
		AIO.Handle(player, "GameMasterSystem", "receiveNPCData", npcData, offset, pageSize, hasMoreData)
	end
end

-- Function to query GameObject data from the database with pagination
function GameMasterSystem.getGameObjectData(player, offset, pageSize, sortOrder)
	offset = offset or 0
	pageSize = validatePageSize(pageSize or config.defaultPageSize)
	sortOrder = validateSortOrder(sortOrder or "DESC")

	local query = getQuery(GetCoreName(), "gobData")(sortOrder, pageSize, offset)

	local result = WorldDBQuery(query)
	local gobData = {}

	if result then
		repeat
			local gob = {
				entry = result:GetUInt32(0),
				displayid = result:GetUInt32(1),
				name = result:GetString(2),
				modelName = result:GetString(3),
			}
			table.insert(gobData, gob)
		until not result:NextRow()
	end

	local hasMoreData = #gobData == pageSize

	if #gobData == 0 then
		player:SendBroadcastMessage("No gameobject data available for the given page.")
	else
		AIO.Handle(player, "GameMasterSystem", "receiveGameObjectData", gobData, offset, pageSize, hasMoreData)
	end
end

-- Server-side handler to search GameObject data
function GameMasterSystem.searchGameObjectData(player, query, offset, pageSize, sortOrder)
	query = escapeString(query) -- Escape special characters
	local typeId = nil
	sortOrder = validateSortOrder(sortOrder or "DESC")

	-- Check if the query is enclosed in parentheses
	local typeQuery = query:match("^%((.-)%)$")
	if typeQuery then
		typeQuery = typeQuery:lower() -- Convert the type query to lowercase
		typeId = gameObjectTypes[typeQuery] -- Get the type ID from the extracted type name
		if not typeId then
			player:SendBroadcastMessage("Invalid GameObject type: " .. typeQuery)
			return
		end
	end

	local searchQuery = getQuery(GetCoreName(), "searchGobData")(query, typeId, sortOrder, pageSize, offset)
	local result = WorldDBQuery(searchQuery)
	local gobData = {}

	if result then
		repeat
			local gob = {
				entry = result:GetUInt32(0),
				displayid = result:GetUInt32(1),
				name = result:GetString(2),
				type = result:GetUInt32(3),
				modelName = result:GetString(4),
			}
			table.insert(gobData, gob)
		until not result:NextRow()
	end

	local hasMoreData = #gobData == pageSize

	if #gobData == 0 then
		player:SendBroadcastMessage("No gameobject data found for the given query and page.")
	else
		AIO.Handle(player, "GameMasterSystem", "receiveGameObjectData", gobData, offset, pageSize, hasMoreData)
	end
end

-- Server-side handler to get the spell data for tab3
function GameMasterSystem.getSpellData(player, offset, pageSize, sortOrder)
	offset = offset or 0
	pageSize = validatePageSize(pageSize or config.defaultPageSize)
	sortOrder = validateSortOrder(sortOrder or "DESC")

	local query = getQuery(GetCoreName(), "spellData")(sortOrder, pageSize, offset)

	local result = WorldDBQuery(query)
	local spellData = {}

	if result then
		repeat
			local spell = {
				spellID = result:GetUInt32(0),
				spellName = result:GetString(1),
				spellDescription = result:GetString(2),
				spellToolTip = result:GetString(3),
			}
			table.insert(spellData, spell)
		until not result:NextRow()
	end

	local hasMoreData = #spellData == pageSize

	if #spellData == 0 then
		player:SendBroadcastMessage("No spell data available for the given page.")
	else
		AIO.Handle(player, "GameMasterSystem", "receiveSpellData", spellData, offset, pageSize, hasMoreData)
	end
end

-- Server-side handler to search spell data
function GameMasterSystem.searchSpellData(player, query, offset, pageSize, sortOrder)
	query = escapeString(query) -- Escape special characters
	sortOrder = validateSortOrder(sortOrder or "DESC")

	local searchQuery = getQuery(GetCoreName(), "searchSpellData")(query, sortOrder, pageSize, offset)

	local result = WorldDBQuery(searchQuery)
	local spellData = {}

	if result then
		repeat
			local spell = {
				spellID = result:GetUInt32(0),
				spellName = result:GetString(1),
				spellDescription = result:GetString(2),
				spellToolTip = result:GetString(3),
			}
			table.insert(spellData, spell)
		until not result:NextRow()
	end

	local hasMoreData = #spellData == pageSize

	if #spellData == 0 then
		player:SendBroadcastMessage("No spell data found for the given query and page.")
	else
		AIO.Handle(player, "GameMasterSystem", "receiveSpellData", spellData, offset, pageSize, hasMoreData)
	end
end

----------------------------------------------------------

local function calculatePosition(player, distance)
	local angle = player:GetO()
	local x = player:GetX() + distance * math.cos(angle)
	local y = player:GetY() + distance * math.sin(angle)
	-- local z = player:GetMap():GetHeight(x, y) -- -- This work if you have exctracted the vmaps
	local z = player:GetZ()
	local oppositeAngle = angle + math.pi
	return x, y, z, oppositeAngle
end

-- Enhanced Messaging Functions for GameMasterSystem

-- Function to send a broadcast message to a player with a specific type and optional color
local function sendMessage(player, messageType, message)
	if not player or not message then
		return
	end

	-- Define message types with their prefixes and colors
	local messageTypes = {
		error = { prefix = "Error: ", color = "|cFFFF0000" }, -- Red
		success = { prefix = "Success: ", color = "|cFF00FF00" }, -- Green
		info = { prefix = "Info: ", color = "|cFF00FFFF" }, -- Cyan
		warning = { prefix = "Warning: ", color = "|cFFFFFF00" }, -- Yellow
	}

	local typeInfo = messageTypes[messageType:lower()]
	if not typeInfo then
		-- Default to info if unknown type
		typeInfo = messageTypes.info
	end

	-- Construct the full message with color and prefix
	local fullMessage = string.format("%s%s%s|r", typeInfo.color, typeInfo.prefix, message)

	-- Send the broadcast message to the player
	player:SendBroadcastMessage(fullMessage)

	-- Log the message to the server logs with timestamp
	local timestamp = os.date("%Y-%m-%d %H:%M:%S")
	local logMessage = string.format("[%s] %s: %s", timestamp, messageType:upper(), message)
	print(logMessage) -- Assuming 'print' sends to server console/log
end

-- Specific functions for error and success messages
local function sendErrorMessage(player, message)
	sendMessage(player, "error", message)
end

local function sendSuccessMessage(player, message)
	sendMessage(player, "success", message)
end

-- Optional: Additional functions for info and warning messages
local function sendInfoMessage(player, message)
	sendMessage(player, "info", message)
end

local function sendWarningMessage(player, message)
	sendMessage(player, "warning", message)
end

-- Usage Examples:
-- sendErrorMessage(player, "Invalid spell ID.")
-- sendSuccessMessage(player, "Spell learned successfully.")
-- sendInfoMessage(player, "You have 10 seconds remaining.")
-- sendWarningMessage(player, "Low health!")

-- Server-side handler to spawn an entity
function GameMasterSystem.spawnNpcEntity(player, entry)
	entry = tostring(entry):match("^%s*(.-)%s*$") -- Trim spaces
	if not entry or entry == "" then
		sendErrorMessage(player, "Entry is nil or empty")
		return
	end

	local x, y, z, oppositeAngle = calculatePosition(player, 3)
	local mapId = player:GetMapId()
	local instanceId = player:GetInstanceId()
	local save = true
	local durorresptime = 60000 -- 1 minute in milliseconds
	local phase = 1

	-- Commented out the old SpawnCreature method
	-- local spawnedCreature = player:SpawnCreature(entry, x, y, z, oppositeAngle)

	local coreName = GetCoreName()
	local spawnedCreature

	if coreName == "TrinityCore" then
		spawnedCreature =
			PerformIngameSpawn(1, entry, mapId, instanceId, x, y, z, oppositeAngle, save, durorresptime, phase)
	elseif coreName == "AzerothCore" then -- THis is for AzerothCore this might not work if you dont restart the server after spawning in the creature
		spawnedCreature =
			PerformIngameSpawn(1, entry, mapId, instanceId, x, y, z, oppositeAngle, save, durorresptime, phase)

		debugMessage("Spawned creature with entry:", entry)
	else
		sendErrorMessage(player, "Unsupported core: " .. coreName)
		return
	end

	sendSuccessMessage(player, "Received spawn request for NPC with entry: " .. entry)

	if not spawnedCreature then
		debugMessage("Failed to spawn entity with entry:", entry)
	end
end

-- Server-side handler to delete an entity
function GameMasterSystem.deleteNpcEntity(player, entry)
	if not entry or entry == "" then
		sendErrorMessage(player, "Entry is nil or empty")
		return
	end
	debugMessage("Received delete request for NPC with entry: " .. entry)
	-- nearestCreature = WorldObject:GetNearestCreature( range, entryId, hostile, dead )

	local creature = player:GetNearestCreature(100, entry)
	if creature then
		creature:RemoveFromWorld(config.removeFromWorld)
	end
end

-- Server-side handler to morph an entity
function GameMasterSystem.morphNpcEntity(player, entry)
	if not entry or entry == "" then
		sendErrorMessage(player, "Entry is nil or empty")
		return
	end

	local target = player:GetSelection()
	if target then
		target:SetDisplayId(entry)
		sendSuccessMessage(player, "Morphed target entity with displayid: " .. entry)
	else
		player:SetDisplayId(entry)
		sendSuccessMessage(player, "Morphed self with displayid: " .. entry)
	end
end

-- Server-side handler to demorph an entity
function GameMasterSystem.demorphNpcEntity(player)
	local target = player:GetSelection()
	if target then
		target:DeMorph()
		sendSuccessMessage(player, "Demorphed target entity.")
	else
		player:DeMorph()
		sendSuccessMessage(player, "Demorphed self.")
	end
end

-- Server-side handler to spawn a GameObject entity
function GameMasterSystem.spawnGameObject(player, entry)
	entry = tostring(entry):match("^%s*(.-)%s*$") -- Trim spaces
	if not entry or entry == "" then
		sendErrorMessage(player, "Entry is nil or empty")
		return
	end

	local x, y, z, oppositeAngle = calculatePosition(player, 3)

	local mapId = player:GetMapId()
	local instanceId = player:GetInstanceId()
	local save = true
	local durorresptime = 60000 -- 1 minute in milliseconds
	local phase = 1

	-- Commented out the old SummonGameObject method
	-- local gob = player:SummonGameObject(entry, x, y, z, oppositeAngle, respawnTime)

	-- Replaced with PerformIngameSpawn
	local gob = PerformIngameSpawn(2, entry, mapId, instanceId, x, y, z, oppositeAngle, save, durorresptime, phase)

	sendSuccessMessage(player, "spawn request for GameObject with entry: " .. entry)
	if not gob then
		debugMessage("Failed to spawn GameObject with entry:", entry)
	end
end

-- Server-side handler to delete a GameObject entity
function GameMasterSystem.deleteGameObjectEntity(player, entry)
	if not entry or entry == "" then
		sendErrorMessage(player, "Entry is nil or empty")
		return
	end

	-- worldObject = WorldObject:GetNearObject( range, type, entry )
	local gob = player:GetNearObject(100, 3, entry)
	sendSuccessMessage(player, "Received delete request for GameObject with entry: " .. entry)
	if gob then
		gob:RemoveFromWorld(config.removeFromWorld)
	end
end

-- Server-side handler to spawn and delete an NPC entity
function GameMasterSystem.spawnAndDeleteNpcEntity(player, entry)
	entry = tostring(entry):match("^%s*(.-)%s*$") -- Trim spaces
	if not entry or entry == "" then
		sendErrorMessage(player, "Entry is nil or empty")
		return
	end

	sendSuccessMessage(player, "Received spawn and delete request for NPC with entry: " .. entry)

	local x, y, z, oppositeAngle = calculatePosition(player, 3)

	local spawnedCreature = player:SpawnCreature(entry, x, y, z, oppositeAngle)

	if spawnedCreature and spawnedCreature:IsInWorld() then
		spawnedCreature:RemoveFromWorld(config.removeFromWorld)
		spawnedCreature:SetFaction(player:GetFaction())
	else
		sendErrorMessage(player, "Failed to spawn entity with entry: " .. entry)
	end
end

-- Server-side handler to spawn and delete a GameObject entity
function GameMasterSystem.spawnAndDeleteGameObjectEntity(player, entry)
	entry = tostring(entry):match("^%s*(.-)%s*$") -- Trim spaces
	if not entry or entry == "" then
		sendErrorMessage(player, "Entry is nil or empty")
		return
	end

	sendSuccessMessage(player, "Received spawn and delete request for GameObject with entry: " .. entry)

	local x, y, z, oppositeAngle = calculatePosition(player, 3)
	local mapId = player:GetMapId()
	local instanceId = player:GetInstanceId()
	local save = false
	local durorresptime = 30000
	local phase = 1

	local gob = PerformIngameSpawn(2, entry, mapId, instanceId, x, y, z, oppositeAngle, save, durorresptime, phase)
	if gob then
		gob:Despawn()
		sendSuccessMessage(player, "Spawned and despawned GameObject with entry: " .. entry)
	else
		sendErrorMessage(player, "Failed to spawn GameObject with entry: " .. entry)
	end
end

-- Function to get the target of the player
function GameMasterSystem.getTarget(player)
	local target = player:GetSelection()
	local isSelf = false

	if not target then
		sendInfoMessage(player, "No valid target selected. Defaulting to yourself.")
		target = player
		isSelf = true
	else
		sendInfoMessage(player, "Target selected: " .. target:GetName())
	end

	return target, isSelf
end

-- Server-side handler to add spell learnSpell
function GameMasterSystem.learnSpellEntity(player, spellID)
	local target, isSelf = GameMasterSystem.getTarget(player)

	if not target:HasSpell(spellID) then
		target:LearnSpell(spellID)
		if isSelf then
			sendSuccessMessage(player, string.format("You have successfully learned spell (ID: %d).", spellID))
		else
			sendSuccessMessage(player, string.format("Target has successfully learned spell (ID: %d).", spellID))
		end
	else
		if isSelf then
			sendWarningMessage(player, string.format("You already know spell (ID: %d).", spellID))
		else
			sendWarningMessage(player, string.format("Target already knows spell (ID: %d).", spellID))
		end
	end
end

-- Server-side handler to delete spell deleteEntitySpell
function GameMasterSystem.deleteSpellEntity(player, spellID)
	local target, isSelf = GameMasterSystem.getTarget(player)

	if target:HasSpell(spellID) then
		target:RemoveSpell(spellID)
		if isSelf then
			sendSuccessMessage(player, string.format("You have successfully removed spell (ID: %d).", spellID))
		else
			sendSuccessMessage(player, string.format("Target has successfully removed spell (ID: %d).", spellID))
		end
	else
		if isSelf then
			sendWarningMessage(player, string.format("You do not know spell (ID: %d).", spellID))
		else
			sendWarningMessage(player, string.format("Target does not know spell (ID: %d).", spellID))
		end
	end
end

-- Server-side handler to castSelfSpellEntity
function GameMasterSystem.castSelfSpellEntity(player, spellID)
	local target, isSelf = GameMasterSystem.getTarget(player)
	if not target or isSelf then
		sendSuccessMessage(player, "Casting spell on yourself.")
		player:CastSpell(player, spellID, true)
	else
		sendSuccessMessage(player, "Cast spell on target.")
		player:CastSpell(target, spellID, true)
	end
end

-- Server-side handler to castTargetSpellEntity
function GameMasterSystem.castTargetSpellEntity(player, spellID)
	local target, isSelf = GameMasterSystem.getTarget(player)
	if not isSelf then
		sendSuccessMessage(player, "Cast spell from target.")
		target:CastSpell(player, spellID, true)
	end
end

local CreatureDisplays = {
	Cache = {},
}

local function LoadCreatureDisplays()
	local coreName = GetCoreName()
	local query = getQuery(coreName, "loadCreatureDisplays")()

	local result = WorldDBQuery(query)

	if result then
		repeat
			local creatureDisplay = {
				entry = result:GetUInt32(0),
				name = result:GetString(1),
				subname = result:GetString(2),
				iconName = result:GetString(3),
				type_flags = result:GetUInt32(4),
				cType = result:GetUInt32(5),
				family = result:GetUInt32(6),
				rank = result:GetUInt32(7),
				killCredit1 = result:GetUInt32(8),
				killCredit2 = result:GetUInt32(9),
				healthMod = result:GetFloat(10),
				manaMod = result:GetFloat(11),
				racialLeader = result:GetUInt32(12),
				movementType = result:GetUInt32(13),
				model1 = 0,
				model2 = 0,
				model3 = 0,
				model4 = 0,
			}

			if coreName == "TrinityCore" then
				creatureDisplay.model1 = result:GetUInt32(14)
				creatureDisplay.model2 = result:GetUInt32(15)
				creatureDisplay.model3 = result:GetUInt32(16)
				creatureDisplay.model4 = result:GetUInt32(17)
			elseif coreName == "AzerothCore" then
				creatureDisplay.model1 = result:GetUInt32(14)
			end

			table.insert(CreatureDisplays.Cache, creatureDisplay)
		until not result:NextRow()
	else
		debugMessage("No creature display data found.")
	end
end

LoadCreatureDisplays()

-- Constants for packet information
local CREATURE_QUERY_RESPONSE = 97
local PACKET_SIZE = 100
local DEFAULT_STRING = ""
local DEFAULT_FLAGS = 0

---Sends creature information to the player
---@param player Player The player object receiving the packet
---@param data table Creature data containing entry, name, flags etc.
---@return boolean success Whether the packet was sent successfully
local function SendCreatureQueryResponse(player, data)
	-- Input validation
	if not player or not data then
		return false
	end

	-- Validate required data
	if not data.entry then
		return false
	end

	-- Create response packet
	local packet = CreatePacket(CREATURE_QUERY_RESPONSE, PACKET_SIZE)
	if not packet then
		return false
	end

	-- Helper function to safely write data
	local function SafeWrite(value, default)
		return value or default
	end

	-- Write packet data with safe defaults
	pcall(function()
		packet:WriteULong(data.entry)
		packet:WriteString(SafeWrite(data.name, DEFAULT_STRING))
		packet:WriteUByte(DEFAULT_FLAGS) -- Flags 1
		packet:WriteUByte(DEFAULT_FLAGS) -- Flags 2
		packet:WriteUByte(DEFAULT_FLAGS) -- Flags 3
		packet:WriteString(SafeWrite(data.subname, DEFAULT_STRING))
		packet:WriteString(SafeWrite(data.iconName, DEFAULT_STRING))
		packet:WriteULong(SafeWrite(data.type_flags, DEFAULT_FLAGS))
		packet:WriteULong(SafeWrite(data.cType, DEFAULT_FLAGS))
		packet:WriteULong(SafeWrite(data.family, DEFAULT_FLAGS))
		packet:WriteULong(SafeWrite(data.rank, DEFAULT_FLAGS))
		packet:WriteULong(SafeWrite(data.killCredit1, DEFAULT_FLAGS))
		packet:WriteULong(SafeWrite(data.killCredit2, DEFAULT_FLAGS))
		packet:WriteULong(SafeWrite(data.model1, DEFAULT_FLAGS))
		packet:WriteULong(SafeWrite(data.model2, DEFAULT_FLAGS))
		packet:WriteULong(SafeWrite(data.model3, DEFAULT_FLAGS))
		packet:WriteULong(SafeWrite(data.model4, DEFAULT_FLAGS))
		packet:WriteFloat(SafeWrite(data.healthMod, 1.0))
		packet:WriteFloat(SafeWrite(data.manaMod, 1.0))
		packet:WriteUByte(SafeWrite(data.racialLeader, DEFAULT_FLAGS))

		-- Write remaining default values
		for i = 1, 6 do
			packet:WriteULong(DEFAULT_FLAGS)
		end
		-- TODO!: This will make npc moonwalk some odd behavior
		-- packet:WriteULong(SafeWrite(data.movementType, DEFAULT_FLAGS))
	end)

	-- Send packet and return success
	return player:SendPacket(packet)
end

local function OnLogin(event, player)
	for _, v in pairs(CreatureDisplays.Cache) do
		-- player:SendBroadcastMessage(v[1])
		SendCreatureQueryResponse(player, v)
	end
end

RegisterPlayerEvent(3, OnLogin)

-- Check GM rank and handle GM level for GameMasterSystem
function GameMasterSystem.handleGMLevel(player)
	local gmRank = player:GetGMRank()
	-- if gmRank < 2 then
	--     player:SendBroadcastMessage("You do not have permission to use this command.")
	--     return false
	-- end

	AIO.Handle(player, "GameMasterSystem", "receiveGmLevel", gmRank)
	-- return true
end

-- send core to player with functions
function GameMasterSystem.getCoreName(player)
	local coreName = GetCoreName()
	AIO.Handle(player, "GameMasterSystem", "receiveCoreName", coreName)
end

-- -- This is one way to send it to the player kinda bad if slow pc
-- local function SendCoreName(event, player)
-- 	-- Send the core name to the player
-- 	local players = GetPlayersInWorld()
-- 	for i, v in ipairs(players) do
-- 		AIO.Handle(v, "GameMasterSystem", "receiveCoreName", GetCoreName())
-- 	end
-- end

-- -- RegisterPlayerEvent(3, SendCoreName)
-- RegisterServerEvent(33, SendCoreName)
