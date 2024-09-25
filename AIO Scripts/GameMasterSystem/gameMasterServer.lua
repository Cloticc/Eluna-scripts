-- AIO for TrinityCore 3.3.5 with WoW client 3.3.5
local AIO = AIO or require("AIO")

local GameMasterSystem = AIO.AddHandlers("GameMasterSystem", {})

-- configuration
local config = {
    debug = false,
    defaultPageSize = 15
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

-- local npcData = {}

-- Function to query NPC data from the database with pagination
function GameMasterSystem.getNPCData(player, offset, pageSize)
    offset = offset or 0
    pageSize = validatePageSize(pageSize or config.defaultPageSize)

    local query = string.format([[ 
        SELECT entry, modelid1, modelid2, modelid3, modelid4, name, subname, type 
        FROM creature_template 
        WHERE modelid1 != 0 OR modelid2 != 0 OR modelid3 != 0 OR modelid4 != 0 
        LIMIT %d OFFSET %d;
    ]], pageSize, offset)

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
function GameMasterSystem.searchNPCData(player, query, offset, pageSize)
    query = escapeString(query) -- Escape special characters
    local searchQuery = string.format([[ 
        SELECT entry, modelid1, modelid2, modelid3, modelid4, name, subname, type
        FROM creature_template 
        WHERE name LIKE '%%%s%%' OR subname LIKE '%%%s%%' OR entry LIKE '%%%s%%'
        LIMIT %d OFFSET %d;
    ]], query, query, query, pageSize, offset * pageSize)

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

-- Function to fetch model data from the SQL tables
function GameMasterSystem.getModelDataNpc(player, modelId)
    local query = string.format("SELECT * FROM creaturedisplayinfo WHERE ModelID = %d", modelId)
    local result = WorldDBQuery(query)
    if result then
        local data = {
            modelId = result:GetUInt32(0),
            texture1 = result:GetString(6),
            texture2 = result:GetString(7),
            texture3 = result:GetString(8),
            portraitTexture = result:GetString(9)
        }
        AIO.Handle(player, "GameMasterSystem", "receiveModelDataNpc", data)
    else
        player:SendBroadcastMessage("Error: Model data not found for ModelID: " .. modelId)
    end
end


-- Function to query GameObject data from the database with pagination
function GameMasterSystem.getGameObjectData(player, offset, pageSize)
    offset = offset or 0
    pageSize = validatePageSize(pageSize or config.defaultPageSize)

    local query = string.format([[ 
        SELECT g.entry, g.displayid, g.name, m.ModelName 
        FROM gameobject_template g 
        LEFT JOIN gameobjectdisplayinfo m ON g.displayid = m.ID 
        LIMIT %d OFFSET %d;
    ]], pageSize, offset)

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
    else
        debugMessage("No results returned from query")
    end

    local hasMoreData = #gobData == pageSize

    if #gobData == 0 then
        player:SendBroadcastMessage("No gameobject data available for the given page.")
    else
        AIO.Handle(player, "GameMasterSystem", "receiveGameObjectData", gobData, offset, pageSize, hasMoreData)
    end
end

-- Server-side handler to search GameObject data
function GameMasterSystem.searchGameObjectData(player, query, offset, pageSize)
    query = escapeString(query) -- Escape special characters
    local searchQuery = string.format([[ 
        SELECT g.entry, g.displayid, g.name, m.ModelName 
        FROM gameobject_template g 
        LEFT JOIN gameobjectdisplayinfo m ON g.displayid = m.ID 
        WHERE g.name LIKE '%%%s%%' OR g.entry LIKE '%%%s%%' 
        LIMIT %d OFFSET %d;
    ]], query, query, pageSize, offset * pageSize)

    local result = WorldDBQuery(searchQuery)
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
        player:SendBroadcastMessage("No gameobject data found for the given query and page.")
    else
        AIO.Handle(player, "GameMasterSystem", "receiveGameObjectData", gobData, offset, pageSize, hasMoreData)
    end
end

-- Server-side handler to get the spell data for tab3
function GameMasterSystem.getSpellData(player, offset, pageSize)
    offset = offset or 0
    pageSize = validatePageSize(pageSize or config.defaultPageSize)
    local query = string.format([[ 
        SELECT id, spellName0, spellDescription0, spellToolTip0 
        FROM spell 
        LIMIT %d OFFSET %d;
    ]], pageSize, offset)

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

-- -- Server-side handler to get the spell_dbc data
-- function GameMasterSystem.getSpellDBCData(player, offset, pageSize)
--     offset = offset or 0
--     pageSize = validatePageSize(pageSize or config.defaultPageSize)
--     local query = string.format([[ 
--         SELECT Id, SpellName 
--         FROM spell_dbc 
--         LIMIT %d OFFSET %d;
--     ]], pageSize, offset)

--     local result = WorldDBQuery(query)
--     local spellDBCData = {}

--     if result then
--         repeat
--             local spell = {
--                 spellID = result:GetUInt32(0),
--                 spellName = result:GetString(1)
--             }
--             table.insert(spellDBCData, spell)
--         until not result:NextRow()
--     end

--     local hasMoreData = #spellDBCData == pageSize

--     if #spellDBCData == 0 then
--         player:SendBroadcastMessage("No spell_dbc data available for the given page.")
--     else
--         AIO.Handle(player, "GameMasterSystem", "receiveSpellDBCData", spellDBCData, offset, pageSize, hasMoreData)
--     end
-- end

-- Server-side handler to search spell data
function GameMasterSystem.searchSpellData(player, query, offset, pageSize)
    query = escapeString(query) -- Escape special characters
    local searchQuery = string.format([[ 
        SELECT id, spellName0, spellDescription0, spellToolTip0 
        FROM spell 
        WHERE spellName0 LIKE '%%%s%%' OR id LIKE '%%%s%%' 
        LIMIT %d OFFSET %d;
    ]], query, query, pageSize, offset * pageSize)

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

-- -- Server-side handler to search spell_dbc data
-- function GameMasterSystem.searchSpellDBCData(player, query, offset, pageSize)
--     query = escapeString(query) -- Escape special characters
--     local searchQuery = string.format([[ 
--         SELECT Id, SpellName 
--         FROM spell_dbc 
--         WHERE SpellName LIKE '%%%s%%' OR Id LIKE '%%%s%%' 
--         LIMIT %d OFFSET %d;
--     ]], query, query, pageSize, offset * pageSize)

--     local result = WorldDBQuery(searchQuery)
--     local spellDBCData = {}

--     if result then
--         repeat
--             local spell = {
--                 spellID = result:GetUInt32(0),
--                 spellName = result:GetString(1)
--             }
--             table.insert(spellDBCData, spell)
--         until not result:NextRow()
--     end

--     local hasMoreData = #spellDBCData == pageSize

--     if #spellDBCData == 0 then
--         player:SendBroadcastMessage("No spell_dbc data found for the given query and page.")
--     else
--         AIO.Handle(player, "GameMasterSystem", "receiveSpellDBCData", spellDBCData, offset, pageSize, hasMoreData)
--     end
-- end


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
    local spawnedCreature = PerformIngameSpawn(1, entry, mapId, instanceId, x, y, z, oppositeAngle, save, durorresptime, phase)

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
        creature:RemoveFromWorld(false)
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
        gob:RemoveFromWorld(false)
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
        spawnedCreature:RemoveFromWorld(false)
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

    if coreName == "TrinityCore" then
        query = "SELECT `entry`, `name`, `subname`, `IconName`, `type_flags`, `type`, `family`, `rank`, `KillCredit1`, `KillCredit2`, `HealthModifier`, `ManaModifier`, `RacialLeader`, `MovementType`, `modelId1`, `modelId2`, `modelId3`, `modelId4` FROM `creature_template`"
    elseif coreName == "AzerothCore" then
        query = "SELECT `entry`, `name`, `subname`, `IconName`, `type_flags`, `type`, `family`, `rank`, `KillCredit1`, `KillCredit2`, `HealthModifier`, `ManaModifier`, `RacialLeader`, `MovementType` FROM `creature_template`"
    end

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
            local creatureDisplay = {
                entry,
                result:GetString(1),
                result:GetString(2),
                result:GetString(3),
                result:GetUInt32(4),
                result:GetUInt32(5),
                result:GetUInt32(6),
                result:GetUInt32(7),
                result:GetUInt32(8),
                result:GetUInt32(9),
                model1,
                model2,
                model3,
                model4,
                result:GetFloat(10),
                result:GetFloat(11),
                result:GetUInt32(12),
                result:GetUInt32(13)
            }

            if coreName == "AzerothCore" then
                -- Adjust the indices for AzerothCore since it has fewer columns
                creatureDisplay[11] = nil
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
