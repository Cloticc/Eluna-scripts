
--[[
    spawnNpcTemp.lua
    script to spawn a npc infront of player location with despawn time in minutes.
    usage: .npt entry min

 ]]

local MSG_NPE = "npt" --#command for triggering


local function splitString(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(str, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
    table.insert(result, string.sub(str, from))
    return result
end

local FILE_NAME = string.match(debug.getinfo(1, "S").source, "[^/\\]*.lua$")
local function spawnNPE(event, player, command)
    if player:GetGMRank() <= 2 then
        player:SendBroadcastMessage("You Dont have access to this.")
        return false
    end
    if (command:find(MSG_NPE)) then
-- set so i can set ID then timeDespawn
        local args = splitString(command, " ")
        local npcId = tonumber(args[2])
        local time = tonumber(args[3])


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

RegisterPlayerEvent(42, spawnNPE)
