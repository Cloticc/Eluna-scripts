--     remade it to work in DB instead.

--     Do chatCommand help to see the commands. Ingame


-- table name will be zone_buffs change it if u want other name. Just change the sqlName = "zone_buffs" to what u want.


--However i already set a create table if not exist so u dont need to create it manual. Just add the buffs u want to the table and it will work.
--This is the SQL table that will store the zone IDs, buff IDs, and buff amounts
-- CREATE TABLE IF NOT EXISTS custom_zone_buffs (zoneId INTEGER, buffId INTEGER, amount INTEGER DEFAULT 0, duration INTEGER DEFAULT 0, comment VARCHAR(255));
-- INSERT INTO zone_buffs (zoneId, buffId, amount, duration, comment) VALUES (zoneId, buffId, amount, duration, comment);
-- zoneId = zone id
-- buffId = buff id
-- amount = buff amount
-- duration = buff duration
-- comment = comment
-- example:
-- INSERT INTO zone_buffs (zoneId, buffId, amount, duration, comment) VALUES (0, 20217, 0, 0, 'all zones');
-- INSERT INTO zone_buffs (zoneId, buffId, amount, duration, comment) VALUES (10, 20217, 0, 0, 'DuskWood');




local chatCommand = "#zonebuff"
local sqlName = "custom_zone_buffs" --Set this to whatever u want the table to be called.
---------------------------- DO NOT EDIT BELOW THIS LINE ----------------------------

-- local function createTableIfNotExist(tableName)
--     -- Define the table structure
--     local tableToQuery =
--         "CREATE TABLE IF NOT EXISTS " ..
--         tableName ..
--         " (zoneId INTEGER, buffId INTEGER, amount INTEGER DEFAULT 0, duration INTEGER DEFAULT 0, comment VARCHAR(255))"

--     -- Check if the table already exists
--     local result = WorldDBQuery("SHOW TABLES LIKE '" .. tableName .. "'")
--     if not result then
--         -- If the table doesn't exist, create it
--         WorldDBQuery(tableToQuery)
--     end
-- end

-- -- Call the function with the table name
-- createTableIfNotExist(sqlName)

--This is the player event that will trigger when a player sends a chat message
local PLAYER_EVENT_ON_CHAT = 18 ----- can use this one if u want to use the command in chat
-- local PLAYER_EVENT_ON_CHAT = 42 ----- will use this one if u want to use the command in chat
-- This is the player event that will trigger when a player updates their zone
local PLAYER_EVENT_ON_UPDATE_ZONE = 27
-- This is the player event that will trigger when a player logs in
local PLAYER_EVENT_ON_LOGIN = 3


-- Create the buff table if it doesn't already exist
local tableToQuery =
    "CREATE TABLE IF NOT EXISTS " ..
    sqlName ..
    " (zoneId INTEGER, buffId INTEGER, amount INTEGER DEFAULT 0, duration INTEGER DEFAULT 0, comment VARCHAR(255))"

-- Check if the table already exists
local result = WorldDBQuery("SHOW TABLES LIKE '" .. sqlName .. "'")
if not result then
    -- If the table doesn't exist, create it
    WorldDBQuery(tableToQuery)
end

-- WorldDBQuery(
--     "CREATE TABLE IF NOT EXISTS " ..
--     sqlName ..
--     " (zoneId INTEGER, buffId INTEGER, amount INTEGER DEFAULT 0, duration INTEGER DEFAULT 0, comment VARCHAR(255))"
-- )

local config = {} -- This table will store the zone IDs, buff IDs, and buff amounts

-- This table will store the current zone for each player
local playerZone = {}

local function initializeZoneBuffs()
    -- This query will retrieve the zone IDs, buff IDs, and buff amounts from the SQL table
    local zoneBuffsQuery = WorldDBQuery("SELECT zoneId, buffId, amount, duration FROM " .. sqlName)
    -- Loop through the query results and add them to the zoneBuffs table
    config.zoneBuffs = {}
    if zoneBuffsQuery then
        repeat
            local row = zoneBuffsQuery:GetRow()

            -- Check if the timestamp of the last update is older than the current time

            if not config.zoneBuffs[row.zoneId] then
                config.zoneBuffs[row.zoneId] = {}
            end
            table.insert(
                config.zoneBuffs[row.zoneId],
                { buffId = row.buffId, amount = row.amount, duration = row.duration }
            )
        until not zoneBuffsQuery:NextRow()
    end
end

local function removeAllZoneBuffs(player)
    for _, zoneBuff in pairs(config.zoneBuffs) do
        for _, buffId in pairs(zoneBuff) do
            local aura = player:GetAura(buffId.buffId)
            if aura then
                aura:Remove()
            end
        end
    end
end


local function addAuras(player, buff)
    player:AddAura(buff.buffId, player)
    local aura = player:GetAura(buff.buffId)
    if aura then
        if buff.amount > 1 then
            aura:SetStackAmount(buff.amount)
        end
        if buff.duration and buff.duration > 1 then
            aura:SetDuration(buff.duration * 60000) -- convert minutes to milliseconds
        end
    end
end




local function applyAllZones(player)
    if config.zoneBuffs[0] then -- add a check for nil
        for _, buff in ipairs(config.zoneBuffs[0]) do
            if not player:HasAura(buff.buffId) then
                addAuras(player, buff)
            end
        end
    end
end




local function checkZone(event, player, newZone, newArea)
    -- Return if player is not valid or not in world
    if type(player) ~= "userdata" or player:GetObjectType() ~= "Player" or not player:IsInWorld() then
        return
    end

    local zoneId = player:GetZoneId()
    local zone = config.zoneBuffs[zoneId]
    local playerGUID = player:GetGUIDLow()
    local currentZone = playerZone[playerGUID]

    -- If the player has entered a new zone, remove all buff auras and update current zone
    if zone ~= currentZone then
        removeAllZoneBuffs(player)
        playerZone[playerGUID] = zone
    end

    applyAllZones(player)

    -- Return if there's no corresponding zone in the zoneBuffs table
    if not zone then
        return
    end

    -- Apply the appropriate buff auras for the player's current zone
    if zone ~= currentZone then
        for _, buff in ipairs(zone) do
            if not player:HasAura(buff.buffId) then
                addAuras(player, buff)
            end
        end
    end
end



local function addZoneAura(player, buffId, amount, duration, comment)
    local zoneId = player:GetZoneId()
    if zoneId == 0 then
        comment = "All Zones"
    else
        comment = GetAreaName(zoneId)
    end

    WorldDBExecute(
        "INSERT INTO " ..
        sqlName ..
        " (zoneId, buffId, amount, duration, comment) VALUES (" ..
        zoneId .. ", " .. buffId .. ", " .. amount .. ", " .. duration .. ", '" .. comment .. "')"
    )

    player:SendBroadcastMessage("Aura " .. buffId .. " added to current zone")
end

local function addAuraToZone(player, zoneId, buffId, amount, duration, comment)
    local query =
      WorldDBQuery("SELECT * FROM " .. sqlName .. " WHERE zoneId = " .. zoneId .. " AND buffId = " .. buffId)
    if query then
        player:SendBroadcastMessage("Aura " .. buffId .. " is already added to zone " .. zoneId)
        return false
    end

    if zoneId == 0 then
        comment = "All Zones"
    else
        comment = GetAreaName(zoneId)
    end

    WorldDBExecute(
        "INSERT INTO " ..
        sqlName ..
        " (zoneId, buffId, amount, duration, comment) VALUES (" ..
        zoneId .. ", " .. buffId .. ", " .. amount .. ", " .. duration .. ", '" .. comment .. "')"
    )

    player:SendBroadcastMessage("Aura " .. buffId .. " added to zone " .. zoneId)
end

local function removeAuraFromZone(player, zoneId, buffId)
    -- Remove buff from all players before removing from SQL
    local players = GetPlayersInWorld()
    for _, p in pairs(players) do
        local aura = p:GetAura(buffId)
        if aura and p:GetZoneId() == zoneId then
            aura:Remove()
        end
    end

    local query =
        WorldDBQuery("SELECT * FROM " .. sqlName .. " WHERE zoneId = " .. zoneId .. " AND buffId = " .. buffId)
    if query == nil then
        player:SendBroadcastMessage("Aura " .. buffId .. " is not added to zone " .. zoneId)
        return false
    end

    WorldDBExecute("DELETE FROM " .. sqlName .. " WHERE zoneId = " .. zoneId .. " AND buffId = " .. buffId)

    player:SendBroadcastMessage("Aura " .. buffId .. " removed from zone " .. zoneId)
end
local function updateAuraInZone(player, zoneId, buffId, amount, duration, comment)
    local query =
        WorldDBQuery("SELECT * FROM " .. sqlName .. " WHERE zoneId = " .. zoneId .. " AND buffId = " .. buffId)
    if query == nil then
        player:SendBroadcastMessage("Aura " .. buffId .. " is not added to zone " .. zoneId)
        return false
    end

    if not comment or comment == "" then
        if zoneId == 0 then
            comment = "All Zones"
        else
            -- comment = GetAreaName(zoneId)
            comment = GetAreaName(zoneId) .. " " .. GetSpellInfo(buffId)
        end
    end

    WorldDBExecute(
        "UPDATE " ..
        sqlName ..
        " SET amount = " ..
        amount ..
        ", duration = " ..
        duration ..
        ", comment = '" ..
        comment .. "' WHERE zoneId = " .. zoneId .. " AND buffId = " .. buffId
    )

    player:SendBroadcastMessage("Aura " .. buffId .. " in zone " .. zoneId .. " updated")

    -- reapply aura to all players in the zone
    local players = GetPlayersInWorld()
    for _, p in pairs(players) do
        if p:GetZoneId() == zoneId then
            local aura = p:GetAura(buffId)
            if aura then
                aura:Remove()
                p:AddAura(buffId, p)
            end
        end
    end
end

local function listAllAuras(player)
    local query = WorldDBQuery("SELECT * FROM " .. sqlName)
    if query then
        repeat
            local zoneId = query:GetUInt32(0)
            local buffId = query:GetUInt32(1)
            local amount = query:GetUInt32(2)
            local duration = query:GetUInt32(3)
            local comment = query:GetString(4)

            player:SendBroadcastMessage(
                "Zone: " ..
                comment ..
                " (ID: " ..
                zoneId .. "), Aura: " .. buffId .. ", Amount: " .. amount .. ", Duration: " .. duration
            )
        until not query:NextRow()
    else
        player:SendBroadcastMessage("No auras found in any zone")
    end
end

local function listAurasInZone(player, zoneId)
    local query = WorldDBQuery("SELECT * FROM " .. sqlName .. " WHERE zoneId = " .. zoneId)

    if query then
        repeat
            local buffId = query:GetUInt32(1)
            local amount = query:GetUInt32(2)
            local duration = query:GetUInt32(3)
            local comment = query:GetString(4)

            player:SendBroadcastMessage(
                "Zone: " ..
                GetAreaName(zoneId) ..
                " (ID: " ..
                zoneId .. "), Aura: " .. buffId .. ", Amount: " .. amount .. ", Duration: " .. duration
            )
        until not query:NextRow()
    else
        player:SendBroadcastMessage("No auras found in zone " .. zoneId)
    end
end

-- Update function
local function updateZoneBuffs()
    initializeZoneBuffs()
    local players = GetPlayersInWorld()
    for _, player in pairs(players) do
        if player then
            removeAllZoneBuffs(player)
            checkZone(_, player)
            applyAllZones(player)
        end
    end

    SendWorldMessage("[System]: Zone buffs table updated")
end

local function onEnterWorld(event, player)
    player:RegisterEvent(checkZone, 1000, 0)
end


-- -- Register update function to run every hour
-- local updateInterval = 60 * 60 -- 1 hour
-- CreateLuaEvent(updateZoneBuffs, updateInterval * 1000, 0)

local function executeAuraZoneCommand(player, command, args)
    config.chatCommands = {
        ["addzone"] = {
            enabled = true,
            gmRankRequired = 2,
            description = "Adds aura to current player's zone eg #zonebuff addzone <buffId> <amount> <duration> <comment>",
            execute = function(player, args)
                local buffId, amount, duration, comment =
                    tonumber(args[1]),
                    tonumber(args[2]) or 0,
                    tonumber(args[3]) or 0,
                    args[4] or ""
                addZoneAura(player, buffId, amount, duration, comment)
            end
        },
        ["add"] = {
            enabled = true,
            gmRankRequired = 2,
            description = "Adds aura to a specific zone eg #zonebuff add <zoneId> <buffId> <amount> <duration> <comment>",
            execute = function(player, args)
                local zoneId, buffId, amount, duration, comment =
                    tonumber(args[1]),
                    tonumber(args[2]),
                    tonumber(args[3]) or 0,
                    tonumber(args[4]) or 0,
                    args[5] or ""
                addAuraToZone(player, zoneId, buffId, amount, duration, comment)
            end
        },
        ["del"] = {
            enabled = true,
            gmRankRequired = 2,
            description = "Deletes aura from a specific zone eg #zonebuff del <zoneId> <buffId>",
            execute = function(player, args)
                local zoneId, buffId = tonumber(args[1]), tonumber(args[2])
                removeAuraFromZone(player, zoneId, buffId)
            end
        },
        ["update"] = {
            enabled = true,
            gmRankRequired = 2,
            description = "Updates an aura's details in a specific zone eg #zonebuff update <zoneId> <buffId> <amount> <duration> <comment>",
            execute = function(player, args)
                -- local zoneId = tonumber(args[2])
                -- local buffId = tonumber(args[3])
                -- local amount = tonumber(args[4]) or 0
                -- local duration = tonumber(args[5]) or 0
                -- local comment = args[6] or ""

                -- updateAuraInZone(player, zoneId, buffId, amount, duration, comment)
                --------------------------------------------------------------------
                local zoneId, buffId, amount, duration, comment = unpack(args)
                if not zoneId or not buffId then
                    player:SendBroadcastMessage(
                        "Usage: " .. chatCommand .. " update <zoneId> <buffId> <amount> <duration> <comment> "
                    )
                    return
                end
                amount = tonumber(amount) or 0
                duration = tonumber(duration) or 0
                -- comment = comment or ""
                comment = table.concat(args, " ", 6)
                updateAuraInZone(player, tonumber(zoneId), tonumber(buffId), amount, duration, comment)
                --------------------------------------------------------------------
                -- local zoneId, buffId, amount, duration, comment = tonumber(args[1]), tonumber(args[2]),
                --     tonumber(args[3]) or 0, tonumber(args[4]) or 0, args[5] or ""
                -- updateAuraInZone(player, zoneId, buffId, amount, duration, comment)
                --------------------------------------------------------------------
            end
        },
        ["list"] = {
            -- List all auras in all zones or list all auras in a specific zone if zoneId is provided
            enabled = true,
            gmRankRequired = 2,
            description = "Lists all auras in all zones or lists all auras in a specific zone if zoneId is provided eg #zonebuff list <zoneId>",
            execute = function(player, args)
                local zoneId = tonumber(args[1])
                if zoneId then
                    listAurasInZone(player, zoneId)
                else
                    listAllAuras(player)
                end
            end
        },
        -- ["listall"] = {
        --     enabled = true,
        --     gmRankRequired = 2,
        --     description = "Lists all auras added to all zones",
        --     execute = function(player, args)
        --         listAllAuras(player)
        --     end,
        -- },
        -- ["listzone"] = {
        --     enabled = true,
        --     gmRankRequired = 2,
        --     description = "Lists all auras added to a specific zone",
        --     execute = function(player, args)
        --         local zoneId = tonumber(args[1])
        --         listAurasInZone(player, zoneId)
        --     end,
        -- },
        ["refresh"] = {
            --refresh all zones
            enabled = true,
            gmRankRequired = 2,
            description = "Lists all auras in all zones or lists all auras in a specific zone if zoneId is provided.",
            execute = function(player, args)
                -- checkZone(event, player)
                -- applyAllZones(player)
                updateZoneBuffs()
            end
        },
        ["help"] = {
            enabled = true,
            gmRankRequired = 2,
            description = "Displays all available commands eg #zonebuff help",
            execute = function(player, args)
                player:SendBroadcastMessage("Commands: ")
                for command, cmdTable in pairs(config.chatCommands) do
                    print(command .. " " .. cmdTable.description)
                    if cmdTable.enabled and player:GetGMRank() >= cmdTable.gmRankRequired then
                        player:SendBroadcastMessage("" .. chatCommand .." ".. command .. "  " .. cmdTable.description)
                        -- add message saying you can set default values for amount and duration
                    end
                end
                player:SendBroadcastMessage("You can set default values for amount and duration")
            end
        }
    }

    if config.chatCommands[command] and config.chatCommands[command].enabled then
        if player:GetGMRank() < config.chatCommands[command].gmRankRequired then
            player:SendBroadcastMessage("You do not have permission to use this command")
            return
        end
        config.chatCommands[command].execute(player, args)
    end
end

local function onChat(event, player, message, Type, lang)
    local words = {}
    for word in string.gmatch(message, "[^%s]+") do
        table.insert(words, word)
    end

    if #words == 0 then
        return
    end

    local command = words[1]:lower() -- Get the command
    table.remove(words, 1)           -- Remove the command from the words table

    if command == chatCommand then
        -- if not player:IsGM() then
        --     player:SendBroadcastMessage("You do not have permission to use this command")
        --     return
        -- end

        local success, error = pcall(function()
            executeAuraZoneCommand(player, words[1], { select(2, unpack(words)) }) -- Execute the command
        end)

        if not success then
            print("Error executing command: "..error)
        end

        return false
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_LOGIN, onEnterWorld)
RegisterPlayerEvent(PLAYER_EVENT_ON_CHAT, onChat)
RegisterPlayerEvent(PLAYER_EVENT_ON_UPDATE_ZONE, checkZone)

initializeZoneBuffs()