--[[
example: .jail <name>

Will jail the player with the name <name>

Feel free to change JailSpell ID to w/e it's for checking if the player is jailed or not.

JailLoc is the location where the player will be teleported to. Set to gmisland atm
unJailAlliance or Horde is the location where the player will be teleported to when unjailing. Set to Stormwind and Orgrimmar.


 ]] local MSG_JAIL = "jail"
local MSG_UNJAIL = "unjail"
local FILE_NAME = string.match(debug.getinfo(1, "S").source, "[^/\\]*.lua$")
local PLAYER_EVENT_ON_COMMAND = 42
local PLAYER_EVENT_ON_UPDATE_ZONE = 27
-- local PLAYER_EVENT_ON_MAP_CHANGE = 28

local jailSpell = 7

local jailLoc = {1, 16206.40625, 16216.223632812, 2.5386452674866, 1.0740673542023} --gmisland
-- 1,  16219.421875,  16403.408203125,  -64.37858581543,  0.017713271081448

local unJailAlliance = {0, -8865.5966796875, 673.04827880859, 100.587059021, 4.9373631477356} --stormwind
local unJailHorde = {1, 1635.765625, -4443.3647460938, 16.921722412109, 2.5195200443268} --orgrimmar

local function splitString(str, delimiter)
    local result = {}
    local from = 1 -- start of the word
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(str, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from) -- find the next word
    end
    table.insert(result, string.sub(str, from)) -- insert tailing element
    return result
end

local function zoneChangeWhileJail(event, player, newZone, newArea)
    if player:HasSpell(jailSpell) then

        player:Teleport(jailLoc[1], jailLoc[2], jailLoc[3], jailLoc[4], jailLoc[5])
    end
end

local function jailName(event, player, command)

    if (command:find(MSG_JAIL)) then
        if player:GetGMRank() <= 2 then
            player:SendBroadcastMessage("You Dont have access to this.")
            return false
        end
        local args = splitString(command, " ")
        local name = tostring(args[2])


        local player = GetPlayerByName(name)
        if player then
            player:Teleport(jailLoc[1], jailLoc[2], jailLoc[3], jailLoc[4], jailLoc[5])
            player:RemoveItem(6948, 1)
            player:CastSpell(player, 26, true)
            player:LearnSpell(jailSpell)


        else
            player:SendBroadcastMessage("Player not found.")
        end

    end
end

local function unJailName(event, player, command)

    if (command:find(MSG_UNJAIL)) then
        if player:GetGMRank() <= 2 then
            player:SendBroadcastMessage("You Dont have access to this.")
            return false
        end
        local args = splitString(command, " ")
        local name = tostring(args[2])

        local player = GetPlayerByName(name)
        if player then
            if player:GetTeam() == 0 then
                player:Teleport(unJailAlliance[1], unJailAlliance[2], unJailAlliance[3], unJailAlliance[4],
                    unJailAlliance[5])
            else
                player:Teleport(unJailHorde[1], unJailHorde[2], unJailHorde[3], unJailHorde[4], unJailHorde[5])
            end
            player:AddItem(6948, 1)
            player:RemoveSpell(jailSpell)

        else
            player:SendBroadcastMessage("Player not found.")
        end

    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_COMMAND, jailName)
RegisterPlayerEvent(PLAYER_EVENT_ON_COMMAND, unJailName)
RegisterPlayerEvent(PLAYER_EVENT_ON_UPDATE_ZONE, zoneChangeWhileJail)
