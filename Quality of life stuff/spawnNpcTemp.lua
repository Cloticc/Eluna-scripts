
--[[
Spawn a npc infront of you with a given time.
Example: /npt 123 10 -- Spawns a npc with id 123 for 10 minutes.


 ]]

local MSG_NPT = "npt" --#command for triggering

local FILE_NAME = string.match(debug.getinfo(1, "S").source, "[^/\\]*.lua$")

local function splitString(str, delimiter)
    local result = {}
    local from = 1  -- start of the word
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(str, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)  -- find the next word
    end
    table.insert(result, string.sub(str, from))  -- insert tailing element
    return result
end

local function spawnNpt(event, player, command)
    if player:GetGMRank() <= 2 then
        player:SendBroadcastMessage("You Dont have access to this.")
        return false
    end
    if (command:find(MSG_NPT)) then

        local args = splitString(command, " ")  --split the command into args
        local npcId = tonumber(args[2]) --get the npcId from the args
        local time = tonumber(args[3]) --get the time to spawn


        local angle = player:GetO()
        local x = player:GetX() + math.cos(angle) * 2
        local y = player:GetY() + math.sin(angle) * 2
        local z = player:GetZ()
        local o = player:GetO()
        local npc = player:SpawnCreature(npcId, x, y, z, o, 3, time * 60000)
        npc:SetFacingToObject(player)
        local npcName = npc:GetName()
        player:SendBroadcastMessage("|cff00ff00[" .. FILE_NAME .. "]|r Spawn NPC: " .. npcName .. " " .. npcId .. " "..time.." Minutes despawn.")
    end
end

RegisterPlayerEvent(42, spawnNpt)
