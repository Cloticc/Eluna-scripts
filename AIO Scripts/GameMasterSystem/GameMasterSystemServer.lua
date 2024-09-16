-- AIO for TrinityCore 3.3.5 with WoW client 3.3.5
local AIO = AIO or require("AIO")

local GameMasterSystem = AIO.AddHandlers("GameMasterSystem", {})

-- configuration
local config = {
    debug = true
}

-- function to display debug messages
local function debugMessage(...)
    if config.debug then
        print("DEBUG:", ...)
    end
end

-- local npcData = {}

-- query NPC data 
function GameMasterSystem.getNPCData(player, offset, pageSize)
    -- debugMessage("Fetching NPC Data, offset:", offset, "pageSize:", pageSize)
    offset = offset or 0
    pageSize = pageSize or 100  -- Default page size

    local query = string.format([[
        SELECT entry, modelid1, modelid2, modelid3, modelid4, name, subname 
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
                subname = result:GetString(6)
            }
            table.insert(npcData, npc)
            debugMessage("NPC Data:", npc)
        until not result:NextRow()
    end

    AIO.Handle(player, "GameMasterSystem", "receiveNPCData", npcData, offset, pageSize)
end


-- local gobData = {}

-- Function to query GameObject data from the database with pagination
function GameMasterSystem.getGameObjectData(player, offset, pageSize)
    -- debugMessage("Fetching GameObject Data, offset:", offset, "pageSize:", pageSize)
    offset = offset or 0
    pageSize = pageSize or 100  
    local query = string.format([[
        SELECT entry, displayid, name 
        FROM gameobject_template 
        WHERE displayid != 0 
        LIMIT %d OFFSET %d;
    ]], pageSize, offset)

    local result = WorldDBQuery(query)
    local gobData = {}  
    if result then
        repeat
            local gob = {
                entry = result:GetUInt32(0),
                displayid = result:GetUInt32(1),
                name = result:GetString(2)
            }
            table.insert(gobData, gob)
            debugMessage("GameObject Data:", gob)
        until not result:NextRow()
    else
        debugMessage("No results returned from query")
    end

    debugMessage("Sending GameObject Data to client:", gobData)
    AIO.Handle(player, "GameMasterSystem", "receiveGameObjectData", gobData, offset, pageSize)
end


