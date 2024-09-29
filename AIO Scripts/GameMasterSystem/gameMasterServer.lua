-- AIO for TrinityCore 3.3.5 with WoW client 3.3.5
local AIO = AIO or require("AIO")

local GameMasterSystem = AIO.AddHandlers("GameMasterSystem", {})

-- configuration
local config = {
    debug = true,
    defaultPageSize = 100,

    removeFromWorld = true
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
    ["aberration"] = 15
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
    ["trapdoor"] = 35
}

-- Function to escape special characters in a string
local function escapeString(str)
    local replacements = {
        ["\\"] = "\\\\",
        ["'"] = "\\'",
        ['"'] = '\\"',
        ["%"] = "\\%",
        ["_"] = "\\_"
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
        DESC = true
    }
    return validOrders[order:upper()] and order:upper() or "ASC"
end

-- Function to fetch model data from the SQL tables
-- function GameMasterSystem.getModelDataNpc(player, modelId)
--     local query = string.format("SELECT * FROM creaturedisplayinfo WHERE ModelID = %d", modelId)
--     local result = WorldDBQuery(query)
--     if result then
--         local data = {
--             modelId = result:GetUInt32(0),
--             texture1 = result:GetString(6),
--             texture2 = result:GetString(7),
--             texture3 = result:GetString(8),
--             portraitTexture = result:GetString(9)
--         }
--         AIO.Handle(player, "GameMasterSystem", "receiveModelDataNpc", data)
--     else
--         player:SendBroadcastMessage("Error: Model data not found for ModelID: " .. modelId)
--     end
-- end

-- local npcData = {}

local queries = {
    TrinityCore = {
        loadCreatureDisplays = function()
            return [[
                SELECT `entry`, `name`, `subname`, `IconName`, `type_flags`, `type`, `family`, `rank`, `KillCredit1`, `KillCredit2`, `HealthModifier`, `ManaModifier`, `RacialLeader`, `MovementType`, `modelId1`, `modelId2`, `modelId3`, `modelId4` 
                FROM `creature_template`
            ]]
        end,
        npcData = function(sortOrder, pageSize, offset)
            return string.format([[ 
                SELECT entry, modelid1, modelid2, modelid3, modelid4, name, subname, type 
                FROM creature_template 
                WHERE modelid1 != 0 OR modelid2 != 0 OR modelid3 != 0 OR modelid4 != 0 
                ORDER BY entry %s
                LIMIT %d OFFSET %d;
            ]], sortOrder, pageSize, offset)
        end,
        gobData = function(sortOrder, pageSize, offset)
            return string.format([[ 
            SELECT g.entry, g.displayid, g.name, m.ModelName 
            FROM gameobject_template g 
            LEFT JOIN gameobjectdisplayinfo m ON g.displayid = m.ID 
            ORDER BY g.entry %s
            LIMIT %d OFFSET %d;
            ]], sortOrder, pageSize, offset)
        end,
        spellData = function(sortOrder, pageSize, offset)
            return string.format([[ 
            SELECT id, spellName0, spellDescription0, spellToolTip0 
            FROM spell 
            ORDER BY id %s
            LIMIT %d OFFSET %d;
            ]], sortOrder, pageSize, offset)
        end,
        searchNpcData = function(query, typeId, sortOrder, pageSize, offset)
            return string.format([[ 
                SELECT entry, modelid1, modelid2, modelid3, modelid4, name, subname, type
                FROM creature_template 
                WHERE name LIKE '%%%s%%' OR subname LIKE '%%%s%%' OR entry LIKE '%%%s%%' %s
                ORDER BY entry %s
                LIMIT %d OFFSET %d;
            ]], query, query, query, typeId and string.format("OR type = %d", typeId) or "", sortOrder, pageSize,
                offset * pageSize)
        end,
        searchGobData = function(query, typeId, sortOrder, pageSize, offset)
            return string.format([[ 
                SELECT g.entry, g.displayid, g.name, g.type, m.ModelName 
                FROM gameobject_template g 
                LEFT JOIN gameobjectdisplayinfo m ON g.displayid = m.ID 
                WHERE g.name LIKE '%%%s%%' OR g.entry LIKE '%%%s%%' %s
                ORDER BY g.entry %s
                LIMIT %d OFFSET %d;
            ]], query, query, typeId and string.format("OR g.type = %d", typeId) or "", sortOrder, pageSize,
                offset * pageSize)
        end,
        searchSpellData = function(query, sortOrder, pageSize, offset)
            return string.format([[ 
                SELECT id, spellName0, spellDescription0, spellToolTip0 
                FROM spell 
                WHERE spellName0 LIKE '%%%s%%' OR id LIKE '%%%s%%' 
                ORDER BY id %s
                LIMIT %d OFFSET %d;
            ]], query, query, sortOrder, pageSize, offset * pageSize)
        end
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
            return string.format([[ 
                SELECT ct.entry, ctm.CreatureDisplayID, ct.name, ct.subname, ct.type 
                FROM creature_template ct
                LEFT JOIN creature_template_model ctm ON ct.entry = ctm.CreatureID
                ORDER BY ct.entry %s
                LIMIT %d OFFSET %d;
            ]], sortOrder, pageSize, offset)
        end,
        gobData = function(sortOrder, pageSize, offset)
            return string.format([[ 
                SELECT g.entry, g.displayId, g.name, g.type, g.size, m.ModelName 
                FROM gameobject_template g 
                LEFT JOIN gameobjectdisplayinfo m ON g.displayId = m.ID 
                ORDER BY g.entry %s
                LIMIT %d OFFSET %d;
            ]], sortOrder, pageSize, offset)
        end,
        spellData = function(sortOrder, pageSize, offset)
            return string.format([[ 
            SELECT id, spellName0, spellDescription0, spellToolTip0 
            FROM spell 
            ORDER BY id %s
            LIMIT %d OFFSET %d;
            ]], sortOrder, pageSize, offset)
        end,
        searchNpcData = function(query, typeId, sortOrder, pageSize, offset)
            return string.format([[ 
                SELECT ct.entry, ctm.CreatureDisplayID, ct.name, ct.subname, ct.type
                FROM creature_template ct
                LEFT JOIN creature_template_model ctm ON ct.entry = ctm.CreatureID
                WHERE ct.name LIKE '%%%s%%' OR ct.subname LIKE '%%%s%%' OR ct.entry LIKE '%%%s%%' %s
                ORDER BY ct.entry %s
                LIMIT %d OFFSET %d;
            ]], query, query, query, typeId and string.format("OR ct.type = %d", typeId) or "", sortOrder, pageSize,
            offset)
        end,
        searchGobData = function(query, typeId, sortOrder, pageSize, offset)
            return string.format([[ 
                SELECT g.entry, g.displayId, g.name, g.type, g.size, m.ModelName 
                FROM gameobject_template g 
                LEFT JOIN gameobjectdisplayinfo m ON g.displayId = m.ID 
                WHERE g.name LIKE '%%%s%%' OR g.entry LIKE '%%%s%%' %s
                ORDER BY g.entry %s
                LIMIT %d OFFSET %d;
            ]], query, query, typeId and string.format("OR g.type = %d", typeId) or "", sortOrder, pageSize, offset)
        end,
        searchSpellData = function(query, sortOrder, pageSize, offset)
            return string.format([[ 
                SELECT id, spellName0, spellDescription0, spellToolTip0 
                FROM spell 
                WHERE spellName0 LIKE '%%%s%%' OR id LIKE '%%%s%%' 
                ORDER BY id %s
                LIMIT %d OFFSET %d;
            ]], query, query, sortOrder, pageSize, offset * pageSize)
        end
    }
}

-- Function to get the appropriate query based on the core name
local function getQuery(coreName, queryType)
    -- debugMessage("coreName: ", coreName , "queryType: ", queryType)
    return queries[coreName] and queries[coreName][queryType] or nil
end

-- Function to query NPC data from the database with pagination
function GameMasterSystem.getNPCData(player, offset, pageSize, sortOrder)
    offset = offset or 0
    pageSize = validatePageSize(pageSize or config.defaultPageSize)
    sortOrder = validateSortOrder(sortOrder or "DESC")
    local query = getQuery(GetCoreName(), "npcData")(sortOrder, pageSize, offset)

    local result = WorldDBQuery(query)
    local npcData = {}

    if result then
        repeat
            local npc = {
                entry = result:GetUInt32(0),
                modelids = {result:GetUInt32(1), result:GetUInt32(2), result:GetUInt32(3), result:GetUInt32(4)},
                name = result:GetString(5),
                subname = result:GetString(6),
                type = result:GetUInt32(7)
            }
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

    local typeQuery = query:match("^%((.-)%)$")
    if typeQuery then
        typeId = npcTypes[typeQuery]
        if not typeId then
            player:SendBroadcastMessage("Invalid NPC type: " .. typeQuery)
            return
        end
    end

    local searchQuery = getQuery(GetCoreName(), "searchNpcData")(query, typeId, sortOrder, pageSize, offset)

    local result = WorldDBQuery(searchQuery)
    local npcData = {}
    if result then
        repeat
            local npc = {
                entry = result:GetUInt32(0),
                modelids = {result:GetUInt32(1), result:GetUInt32(2), result:GetUInt32(3), result:GetUInt32(4)},
                name = result:GetString(5),
                subname = result:GetString(6),
                type = result:GetUInt32(7)
            }
            table.insert(npcData, npc)
        until not result:NextRow()
    end

    local hasMoreData = #npcData == pageSize

    if #npcData == 0 then
        player:SendBroadcastMessage("No NPC data found for the given query and page.")
    end

    AIO.Handle(player, "GameMasterSystem", "receiveNPCData", npcData, offset, pageSize, hasMoreData)
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
                modelName = result:GetString(3)
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
                modelName = result:GetString(4)
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
                spellToolTip = result:GetString(3)
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
                spellToolTip = result:GetString(3)
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

local function sendErrorMessage(player, message)
    player:SendBroadcastMessage("Error: " .. message)
end

local function sendSuccessMessage(player, message)
    player:SendBroadcastMessage("Success: " .. message)
end

-- Server-side handler to spawn an entity
function GameMasterSystem.spawnNpcEntity(player, entry)
    entry = tostring(entry):match("^%s*(.-)%s*$") -- Trim spaces
    if not entry or entry == "" then
        sendErrorMessage(player, "Entry is nil or empty")
        return
    end

    sendSuccessMessage(player, "Received spawn request for NPC with entry: " .. entry)

    local x, y, z, oppositeAngle = calculatePosition(player, 3)
    local mapId = player:GetMapId()
    local instanceId = player:GetInstanceId()
    local save = true
    local durorresptime = 60000 -- 1 minute in milliseconds
    local phase = 1

    -- Commented out the old SpawnCreature method
    -- local spawnedCreature = player:SpawnCreature(entry, x, y, z, oppositeAngle)

    -- Replaced with PerformIngameSpawn
    local spawnedCreature = PerformIngameSpawn(1, entry, mapId, instanceId, x, y, z, oppositeAngle, save, durorresptime,
        phase)

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

-- Server-side handler to add spell learnSpell
function GameMasterSystem.learnSpellEntity(player, spellID)
    sendSuccessMessage(player, "Learning spell with spellID: " .. spellID)
    player:LearnSpell(spellID)
end

-- Server-side handler to delete spell deleteEntitySpell
function GameMasterSystem.deleteSpellEntity(player, spellID)
    sendSuccessMessage(player, "Deleting spell with spellID: " .. spellID)
    player:RemoveSpell(spellID)
end

-- Server-side handler to castSelfSpellEntity
function GameMasterSystem.castSelfSpellEntity(player, spellID)
    sendSuccessMessage(player, "Casting spell with spellID: " .. spellID)
    player:CastSpell(player, spellID, true)
end

-- Server-side handler to castTargetSpellEntity
function GameMasterSystem.castTargetSpellEntity(player, spellID)
    local target = player:GetSelection()
    if target then
        sendSuccessMessage(player, "Casting spell with spellID: " .. spellID .. " on target.")
        target:CastSpell(player, spellID, true)
    else
        sendErrorMessage(player, "No target selected")
    end
end

-- Server-side handler to send creature displays to the player
-- yoink from foe shoutout to him
local CreatureDisplays = {
    Cache = {}
}

local function LoadCreatureDisplays()
    local query = nil
    local coreName = GetCoreName()

    local query = getQuery(coreName, "loadCreatureDisplays")()

    local result = WorldDBQuery(query)

    if result then
        repeat
            local model1, model2, model3, model4 = 0, 0, 0, 0

            if coreName == "TrinityCore" then
                model1 = result:GetUInt32(14)
                model2 = result:GetUInt32(15)
                model3 = result:GetUInt32(16)
                model4 = result:GetUInt32(17)
            end

            local entry = result:GetUInt32(0)
            local creatureDisplay = {entry, result:GetString(1), result:GetString(2), result:GetString(3),
                                     result:GetUInt32(4), result:GetUInt32(5), result:GetUInt32(6), result:GetUInt32(7),
                                     result:GetUInt32(8), result:GetUInt32(9), model1, model2, model3, model4,
                                     result:GetFloat(10), result:GetFloat(11), result:GetUInt32(12),
                                     result:GetUInt32(13)}

            if coreName == "AzerothCore" then
                -- Adjust the indices for AzerothCore since it has fewer columns
                creatureDisplay[12] = nil
                creatureDisplay[13] = nil
                creatureDisplay[14] = nil
                creatureDisplay[15] = result:GetFloat(10)
                creatureDisplay[16] = result:GetFloat(11)
                creatureDisplay[17] = result:GetUInt32(12)
                creatureDisplay[18] = result:GetUInt32(13)
            end

            table.insert(CreatureDisplays.Cache, creatureDisplay)
        until not result:NextRow()
    else
        debugMessage("No creature display data found.")
    end
end

LoadCreatureDisplays()

local function SendCreatureQueryResponse(player, data)
    local packet = CreatePacket(97, 100)
    packet:WriteULong(data[1])
    packet:WriteString(data[2] or "")
    packet:WriteUByte(0)
    packet:WriteUByte(0)
    packet:WriteUByte(0)
    packet:WriteString(data[3] or "")
    packet:WriteString(data[4] or "")
    packet:WriteULong(data[5])
    packet:WriteULong(data[6])
    packet:WriteULong(data[7])
    packet:WriteULong(data[8])
    packet:WriteULong(data[9])
    packet:WriteULong(data[10])
    packet:WriteULong(data[11])
    packet:WriteULong(data[12])
    packet:WriteULong(data[13])
    packet:WriteULong(data[14])
    packet:WriteFloat(data[15])
    packet:WriteFloat(data[16])
    packet:WriteUByte(data[17])
    packet:WriteULong(0)
    packet:WriteULong(0)
    packet:WriteULong(0)
    packet:WriteULong(0)
    packet:WriteULong(0)
    packet:WriteULong(0)
    packet:WriteULong(data[18])
    player:SendPacket(packet)
end
local function OnLogin(event, player)
    for _, v in pairs(CreatureDisplays.Cache) do
        -- player:SendBroadcastMessage(v[1])
        SendCreatureQueryResponse(player, v)
    end
end

RegisterPlayerEvent(3, OnLogin)
