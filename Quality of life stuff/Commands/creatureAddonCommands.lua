-- use ingame "#set list or help" for more info
-- use #set npcemote ID
-- use #set npcaura ID
-- use #set npcmount ID


local CHAT_COMMAND_PREFIX = "#set"

local PLAYER_EVENT_ON_CHAT = 18



local function npcEmote(spawnID, emoteID)
    -- creature_addon -- guid	path_id	mount	MountCreatureID	bytes1	bytes2	emote	visibilityDistanceType	auras

    -- Check if the spawnID is valid
    if not spawnID then
        return false
    end

    -- make query for just spawnID and emoteID
    local query1 = WorldDBQuery("SELECT * FROM creature_addon WHERE guid = " .. spawnID .. ";")
    if (query1) then
        local query3 = WorldDBExecute(
            "UPDATE creature_addon SET emote = " ..
            emoteID .. " WHERE guid = " .. spawnID .. ";")
        if query3 then
            return true
        end
        print("Update for spawnID: " ..
            spawnID .. " emoteID: " .. emoteID .. "")
    elseif not query1 then
        -- Get the data from fun and insert it into the database
        local query2 = WorldDBExecute(
            "INSERT INTO creature_addon (guid, path_id, mount, MountCreatureID, bytes1, bytes2, emote, visibilityDistanceType, auras) VALUES (" ..
            spawnID .. ", 0, 0, 0, 0, 0, " .. emoteID .. ", 0, 0);")
        if (query2) then
            return true
        end
        print("Insert for spawnID: " ..
            spawnID .. " emoteID: " .. emoteID .. "")
    end

    -- return false
end
local function npcAura(spawnID, auraID)
    -- Check if the spawnID is valid
    if not spawnID then
        return false
    end

    -- Check if the auraID is 0, indicating that all auras should be removed
    if auraID == 0 then
        local query = WorldDBExecute("UPDATE creature_addon SET auras = '' WHERE guid = " .. spawnID .. ";")
        if query then
            return true
        end
        print("Remove all auras for spawnID: " .. spawnID)
        return false
    end

    -- Retrieve the existing auras value from the database
    local query1 = WorldDBQuery("SELECT auras FROM creature_addon WHERE guid = " .. spawnID .. ";")
    if query1 then
        local auras = query1:GetString(0)
        -- Check if the auraID is already in the auras field
        if string.find(auras, auraID, 1, true) then
            print("AuraID " .. auraID .. " already exists for spawnID " .. spawnID)
            return false
        end
        -- Append the new auraID to the existing auras value with a space separator
        auraID = auras .. " " .. auraID
        local query2 = WorldDBExecute("UPDATE creature_addon SET auras = '" ..
            auraID .. "' WHERE guid = " .. spawnID .. ";")
        if query2 then
            return true
        end
        print("Update for spawnID: " .. spawnID .. " auraID: " .. auraID)
    else
        -- Insert the new auraID into the database
        local query3 = WorldDBExecute(
            "INSERT INTO creature_addon (guid, path_id, mount, MountCreatureID, bytes1, bytes2, emote, visibilityDistanceType, auras) VALUES (" ..
            spawnID .. ", 0, 0, 0, 0, 0, 0, 0, '" .. auraID .. "');")
        if query3 then
            return true
        end
        print("Insert for spawnID: " .. spawnID .. " auraID: " .. auraID)
    end

    return false
end


local function npcMount(spawnID, MountID)
    -- creature_addon -- guid	path_id	mount	MountCreatureID	bytes1	bytes2	emote	visibilityDistanceType	auras

    -- Check if the spawnID is valid
    if not spawnID then
        return false
    end

    -- make query for just spawnID and emoteID
    local query1 = WorldDBQuery("SELECT * FROM creature_addon WHERE guid = " .. spawnID .. ";")
    if (query1) then
        local query3 = WorldDBExecute(
            "UPDATE creature_addon SET MountCreatureID = " ..
            MountID .. " WHERE guid = " .. spawnID .. ";")
        if query3 then
            return true
        end
        print("Update for spawnID: " ..
            spawnID .. " MountID: " .. MountID .. "")
    elseif not query1 then
        -- Get the data from fun and insert it into the database
        local query2 = WorldDBExecute(
            "INSERT INTO creature_addon (guid, path_id, mount, MountCreatureID, bytes1, bytes2, emote, visibilityDistanceType, auras) VALUES (" ..
            spawnID .. ", 0, 0, " .. MountID .. ", 0, 0, 0, 0, 0);")
        if (query2) then
            return true
        end
        print("Insert for spawnID: " ..
            spawnID .. " MountID: " .. MountID .. "")
    end

    -- return false
end


local chatCmd = {
    ["npcemote"] = {
        gmRankRequired = 2,
        helpText = "Set npc emote. In the Database",
        execute = function(player, emoteID, auraID)
            local selectTarget = player:GetSelection()
            if (not selectTarget) then
                selectTarget = player
            end

            -- Get creature's SpawnID guidLow = Object:GetGUIDLow()
            local spawnID = selectTarget:GetDBTableGUIDLow()

            -- Convert the arguments to numbers using tonumber
            emoteID = tonumber(emoteID)


            print("spawnID: " .. spawnID .. " emoteID: " .. emoteID .. "")

            --  if emote is 0 set nil
            if emoteID == nil then
                emoteID = 0
            end


            -- Call the npcEmote function with the provided arguments
            npcEmote(spawnID, emoteID)
        end
    },

    ["npcmount"] = {
        gmRankRequired = 2,
        helpText = "Set npc mount. In the Database",
        execute = function(player, mountID)
            local selectTarget = player:GetSelection()
            if (not selectTarget) then
                selectTarget = player
            end

            -- Get creature's SpawnID guidLow = Object:GetGUIDLow()
            local spawnID = selectTarget:GetDBTableGUIDLow()

            -- Convert the argument to a number using tonumber
            mountID = tonumber(mountID)

            -- print("spawnID: " .. spawnID .. " mountID: " .. mountID)

            --  if mount is 0 set nil
            if mountID == nil then
                mountID = 0
            end

            -- Call the npcMount function with the provided arguments
            npcMount(spawnID, mountID)
        end
    },

    ["npcaura"] = {
        gmRankRequired = 2,
        helpText = "Set NPC aura in the database",
        execute = function(player, auraID)
            local selectTarget = player:GetSelection()
            if (not selectTarget) then
                selectTarget = player
            end

            -- Get creature's SpawnID guidLow = Object:GetGUIDLow()
            local spawnID = selectTarget:GetDBTableGUIDLow()

            -- Convert the argument to a number using tonumber
            auraID = tonumber(auraID)

            -- print("spawnID: " .. spawnID .. " auraID: " .. auraID)

            --  if aura is 0 set nil
            if auraID == nil then
                auraID = 0
            end

            -- Call the npcAura function with the provided arguments
            npcAura(spawnID, auraID)
        end
    }
}

-- Define the function to handle player chat messages
local function oonPlayerChat(event, player, message, msgType, language)
    -- Check if the message starts with the chat command prefix
    if (string.lower(string.sub(message, 1, #CHAT_COMMAND_PREFIX)) == CHAT_COMMAND_PREFIX) then
        -- Parse the command and argument from the message
        local command, args = message:match("^%s*#set%s*(%w+)%s*(.*)$")

        -- Check if the command is valid and the player has permission to use it
        if chatCmd[command] and player:GetGMRank() >= chatCmd[command].gmRankRequired then
            -- Execute the command with the given argument
            local arg1, arg2 = string.match(args, "(%S+)%s*(%S*)")
            chatCmd[command].execute(player, arg1, arg2)
        elseif command == "help" or command == "list" then
            -- Send a list of available commands to the player
            local commandList = {}
            for command2, data in pairs(chatCmd) do
                if player:GetGMRank() >= data.gmRankRequired then
                    table.insert(commandList, CHAT_COMMAND_PREFIX .. " " .. command2 .. " - " .. data.helpText)
                end
            end
            player:SendBroadcastMessage("Available commands:\n" .. table.concat(commandList, "\n"))
        else
            player:SendNotification("Command not found or you don't have permission to use it. Type " ..
                CHAT_COMMAND_PREFIX .. " help for a list of commands.")
        end
        return false
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_CHAT, oonPlayerChat)
