--[[
    remade it to work in DB instead.
You can now use .fetchzb to udpate the table from the DB. instead of reload eluna
--Running the command will update the table with the latest data from the DB. If you have added new buffs to the DB, you will need to run the command again to update the table.

-- there are commands to add and remove buffs from the DB
msgFetchSql + del zone buff amount duration comment
like .fetchzb del 0 123 0 0 all zones

msgFetchSql + add zone buff amount duration comment
like .fetchzb add 0 123 10 180000 all zones will add 10 stacks. Think it's in ms so 180000 = 3min

msgFetchSql + list will show all rows in the DB
example: .fetchzb list will show all rows in the DB

msgFetchSql + listzone will show all buff in that zone
example: .fetchzb listzone 10 will show all buffs in that zone aka duskwood

--However i already set a create table if not exist so u dont need to create it manual. Just add the buffs u want to the table and it will work.
--This is the SQL table that will store the zone IDs, buff IDs, and buff amounts
-- CREATE TABLE IF NOT EXISTS zone_buffs (zoneId INTEGER, buffId INTEGER, amount INTEGER DEFAULT 0, duration INTEGER DEFAULT 0, comment VARCHAR(255));
-- INSERT INTO zone_buffs (zoneId, buffId, amount, duration, comment) VALUES (zoneId, buffId, amount, duration, comment);
-- zoneId = zone id
-- buffId = buff id
-- amount = buff amount
-- duration = buff duration
-- comment = comment
-- example:
-- INSERT INTO zone_buffs (zoneId, buffId, amount, duration, comment) VALUES (0, 20217, 0, 0, 'all zones');
-- INSERT INTO zone_buffs (zoneId, buffId, amount, duration, comment) VALUES (10, 20217, 0, 0, 'DuskWood');


]]
local sqlName = "zone_buffs" --Set this to whatever u want the table to be called.
-- local msgFetchSql = "#fetchzb" --Set this to whatever u want the command to be called.
local msgFetchSql = "fetchzb" --Set this to whatever u want the command to be called.

local gmRank = 3 -- 0 = player, 1 = moderator, 2 = gamemaster, 3 = administrator, 4 = console

------------------------ DO NOT EDIT BELOW THIS LINE ------------------------

-- Create the buff table if it doesn't already exist
WorldDBQuery(
    "CREATE TABLE IF NOT EXISTS " ..
    sqlName ..
    " (zoneId INTEGER, buffId INTEGER, amount INTEGER DEFAULT 0, duration INTEGER DEFAULT 0, comment VARCHAR(255))"
)

local config = {}

--This is the player event that will trigger when a player sends a chat message
-- local PLAYER_EVENT_ON_CHAT = 18 ----- can use this one if u want to use the command in chat like #fetchzb
local PLAYER_EVENT_ON_CHAT = 42 ----- will use this one if u want to use the command in chat like .fetchzb
-- This is the player event that will trigger when a player updates their zone
local PLAYER_EVENT_ON_UPDATE_ZONE = 27
-- This is the player event that will trigger when a player logs in
local PLAYER_EVENT_ON_LOGIN = 3
-- This table will store the current zone for each player
local playerZone = {}



local function OnStartup()
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

local function forceRemoveIfDontExist(player, deleteFromDb)
    if player == nil then
        return
    end
    --remove all buffs that are not in the DB

    for rowInDb, zoneBuff in pairs(config.zoneBuffs) do
        for _, buff in ipairs(zoneBuff) do
            if not player:HasAura(buff.buffId) then
                local aura = player:GetAura(buff.buffId)
                if aura then
                    aura:Remove()
                    WorldDBQuery("DELETE FROM " .. sqlName .. " WHERE buffId = " .. buff.buffId)
                end
            end
        end
    end
end

--this handle zones that u want to have same buff in all zones so set 0 in db for all zones
local function applyAllZones(player)
    if player == nil then
        return
    end
    for rowInDb, zoneBuff in pairs(config.zoneBuffs) do
        if rowInDb == 0 then
            for _, buff in ipairs(zoneBuff) do
                local aura = player:GetAura(buff.buffId)
                if aura then
                    aura:Remove()
                end

                player:AddAura(buff.buffId, player)
                if buff.amount >= 0 then
                    local aura = player:GetAura(buff.buffId)
                    if aura then
                        aura:SetStackAmount(buff.amount)
                    end
                end
                if buff.duration >= 1 then
                    local aura = player:GetAura(buff.buffId)
                    if aura then
                        aura:SetDuration(buff.duration)
                    end
                end
            end
        end
    end
end

-- This function checks the player's current zone and applies the appropriate buffs
-- local function checkZone(event, player, _, _)
local function checkZone(event, player, newZone, newArea)
    if player == nil then
        return
    end

    -- Get the player's current zone ID
    local zoneId = player:GetZoneId()

    -- Get the corresponding zone from the zoneBuffs table
    local zone = config.zoneBuffs[zoneId]

    -- Get the player's current zone from the playerZone table
    local currentZone = playerZone[player:GetGUIDLow()]

    -- If the player has entered a new zone, remove all buff auras
    if zone ~= currentZone then
        for _, zoneBuff in pairs(config.zoneBuffs) do
            for _, buffId in pairs(zoneBuff) do
                local aura = player:GetAura(buffId.buffId)
                if aura then
                    aura:Remove()
                end
            end
        end

        playerZone[player:GetGUIDLow()] = zone
    end

    --this handle zones that u want to have same buff in all zones so set 0 in db for all zones
    if zone ~= currentZone then
        applyAllZones(player)
        playerZone[player:GetGUIDLow()] = zone
    end

    -- Apply the appropriate buff auras for the player's current zone
    --this handle the zones that specific
    if zone ~= currentZone then
        if not zone then
            return
        end
        for _, buff in ipairs(zone) do
            if not player:HasAura(buff.buffId) then
                player:AddAura(buff.buffId, player)
                if buff.amount > 1 then
                    local aura = player:GetAura(buff.buffId)
                    if aura then
                        aura:SetStackAmount(buff.amount)
                    end
                end
                if buff.duration > 1 then
                    local aura = player:GetAura(buff.buffId)
                    if aura then
                        aura:SetDuration(buff.duration)
                    end
                end
            end
        end
    end
end

local function onEnterWorld(event, player)
    --this will trigger when player enter world and apply all zones buffs
    forceRemoveIfDontExist(player)
    checkZone(event, player)
    applyAllZones(player)
end

local function updateZoneFromSql(event, player, msg, Type, lang)
    -- if (msg == msgFetchSql) then
    if (msg:find(msgFetchSql) == nil) then
        return
    end
    -- not player:IsGM() or
    if (player:GetGMRank() < gmRank) then
        player:SendBroadcastMessage("You are not allowed to use this command")
        return false
    end

    --will remove it
    local msgSplit = msg:split(" ")
    if msgSplit[1] == msgFetchSql then
        if msgSplit[2] == "del" then
            if msgSplit[3] == nil then
                player:SendBroadcastMessage("You need to add zoneId and buffId")
                return false
            end
            if msgSplit[4] == nil then
                player:SendBroadcastMessage("You need to add buffId")
                return false
            end
            local zoneId = msgSplit[3]
            local buffId = msgSplit[4]
            --remove buff from all players before remove from sql
            local players = GetPlayersInWorld()
            for _, player in pairs(players) do
                if player then
                    local aura = player:GetAura(buffId)
                    if aura then
                        aura:Remove()
                    end
                end
            end

            WorldDBQuery("DELETE FROM " .. sqlName .. " WHERE zoneId = " .. zoneId .. " AND buffId = " .. buffId)
            player:SendBroadcastMessage("buffId " .. buffId .. " removed from zoneId " .. zoneId)
            return false
        end
    end
    -- will add it to sql
    if msgSplit[1] == msgFetchSql then
        if msgSplit[2] == "add" then
            if msgSplit[3] == nil then
                player:SendBroadcastMessage("You need to add zoneId")
                return false
            end
            if msgSplit[4] == nil then
                player:SendBroadcastMessage("You need to add buffId")
                return false
            end
            if msgSplit[5] == nil then
                player:SendBroadcastMessage("You need to add amount")
                return false
            end
            if msgSplit[6] == nil then
                player:SendBroadcastMessage("You need to add duration")
                return false
            end
            local zoneId = msgSplit[3]
            local buffId = msgSplit[4]
            local amount = msgSplit[5]
            local duration = msgSplit[6]
            local comment = msgSplit[7]
            if comment == nil then
                comment = " "
            end
            WorldDBQuery(
                "INSERT INTO " ..
                sqlName ..
                " (zoneId, buffId, amount, duration, comment) VALUES (" ..
                zoneId .. ", " .. buffId .. ", " .. amount .. ", " .. duration .. ", '" .. comment .. "')"
            )
            player:SendBroadcastMessage("buffId " .. buffId .. " added to zoneId " .. zoneId)
            return false
        end
    end
    -- will update the row
    if msgSplit[1] == msgFetchSql then
        if msgSplit[2] == "update" then
            if msgSplit[3] == nil then
                player:SendBroadcastMessage("You need to add zoneId")
                return false
            end
            if msgSplit[4] == nil then
                player:SendBroadcastMessage("You need to add buffId")
                return false
            end
            if msgSplit[5] == nil then
                player:SendBroadcastMessage("You need to add amount")
                return false
            end
            if msgSplit[6] == nil then
                player:SendBroadcastMessage("You need to add duration")
                return false
            end
            local zoneId = msgSplit[3]
            local buffId = msgSplit[4]
            local amount = msgSplit[5]
            local duration = msgSplit[6]
            local comment = msgSplit[7]
            if comment == nil then
                comment = " "
            end
            WorldDBQuery(
                "UPDATE " ..
                sqlName ..
                " SET amount = " ..
                amount ..
                ", duration = " ..
                duration ..
                ", comment = '" ..
                comment .. "' WHERE zoneId = " .. zoneId .. " AND buffId = " .. buffId
            )
            player:SendBroadcastMessage("buffId " .. buffId .. " updated in zoneId " .. zoneId)
            return false
        end
    end
    --list will show all buffs in sql
    if msgSplit[1] == msgFetchSql then
        if msgSplit[2] == "list" then
            local query = WorldDBQuery("SELECT * FROM " .. sqlName)
            if query then
                repeat
                    local zoneId = query:GetUInt32(0)
                    local buffId = query:GetUInt32(1)
                    local amount = query:GetUInt32(2)
                    local duration = query:GetUInt32(3)
                    local comment = query:GetString(4)
                    player:SendBroadcastMessage(
                        "zoneId: " ..
                        zoneId ..
                        " buffId: " ..
                        buffId ..
                        " amount: " .. amount .. " duration: " .. duration .. " comment: " .. comment
                    )
                until not query:NextRow()
            end
            return false
        end
    end
    --listzone show all buffs in zone
    if msgSplit[1] == msgFetchSql then
        if msgSplit[2] == "listZone" then
            if msgSplit[3] == nil then
                player:SendBroadcastMessage("You need to add zoneId")
                return false
            end
            local zoneId = msgSplit[3]
            local query = WorldDBQuery("SELECT * FROM " .. sqlName .. " WHERE zoneId = " .. zoneId)
            if query then
                repeat
                    local zoneId = query:GetUInt32(0)
                    local buffId = query:GetUInt32(1)
                    local amount = query:GetUInt32(2)
                    local duration = query:GetUInt32(3)
                    local comment = query:GetString(4)
                    player:SendBroadcastMessage(
                        "zoneId: " ..
                        zoneId ..
                        " buffId: " ..
                        buffId ..
                        " amount: " .. amount .. " duration: " .. duration .. " comment: " .. comment
                    )
                until not query:NextRow()
            end
            return false
        end
    end

    OnStartup()
    local players = GetPlayersInWorld()
    for _, player in pairs(players) do
        if player then
            forceRemoveIfDontExist(player)
            checkZone(event, player)
            applyAllZones(player)
        end
    end
    player:SendBroadcastMessage(sqlName .. " table updated")
    return false
end

OnStartup()
RegisterPlayerEvent(PLAYER_EVENT_ON_LOGIN, onEnterWorld)
RegisterPlayerEvent(PLAYER_EVENT_ON_CHAT, updateZoneFromSql)
RegisterPlayerEvent(PLAYER_EVENT_ON_UPDATE_ZONE, checkZone)
