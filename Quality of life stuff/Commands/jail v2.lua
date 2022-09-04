-- example: .jail <name>

-- Will jail the player with the name <name>

-- Feel free to change JailSpell ID to w/e it's for checking if the player is jailed or not.

-- JailLoc is the location where the player will be teleported to. Set to gmisland atm

-- unJailAlliance or Horde is the location where the player will be teleported to when unjailing. Set to Stormwind and Orgrimmar.
--  if player is jailed and teleports to another zone, he will be teleported back to jail.
-- if player makes new toon or login with another character it will automatically get the jailSpell. if u unjail it will remove it from account
-- TODO: Add a timer to unjail the player after a certain amount of time.

local MSG_JAIL = "jail"
local MSG_UNJAIL = "unjail"

local jailSpell = 7 -- The spell ID for the spell "Jail" this is used to check if the player is jailed or not.

local jailLoc = {1, 16205.743164062, 16215.9453125, 1.1090109348297, 1.0335397720337} -- gmisland
-- 1,  16219.421875,  16403.408203125,  -64.37858581543,  0.017713271081448  ----White room at gmisland

local unJailAlly = {0, -8865.5966796875, 673.04827880859, 100.587059021, 4.9373631477356} -- stormwind
local unJailHorde = {1, 1635.765625, -4443.3647460938, 16.921722412109, 2.5195200443268} -- orgrimmar
local zoneCheck = 876

local FILE_NAME = string.match(debug.getinfo(1, "S").source, "[^/\\]*.lua$")

local PLAYER_EVENT_ON_COMMAND = 42
local PLAYER_EVENT_ON_UPDATE_ZONE = 27
local PLAYER_EVENT_ON_LOGIN = 3
local function splitString(str, delimiter) -- Splits a string into a table of strings
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

local function zoneChangeWhileJail(event, player, newZone, newArea)
    --check if player already at jail zone and if so, do nothing
    if player:GetZoneId() == zoneCheck then
        return
    end
    if player:HasSpell(jailSpell) then
        player:Teleport(jailLoc[1], jailLoc[2], jailLoc[3], jailLoc[4], jailLoc[5])
    end
end

local function applieGlobalJail(event, player)
    --check if player has any toon with jailSpell in database
    local accountId = player:GetAccountId()
    local result = CharDBQuery("SELECT guid FROM characters WHERE account = " .. accountId .. ";")
    --learn spell JailSpell to all characters on account "character_spell"
    if result then
        repeat
            --check if any toon has jailSpell
            local guid = result:GetUInt32(0)
            local result2 =
                CharDBQuery(
                "SELECT spell FROM character_spell WHERE guid = " .. guid .. " AND spell = " .. jailSpell .. ";"
            )
            if result2 then
                player:LearnSpell(jailSpell)
            end
        until not result:NextRow()
    end
end

local function jailPlayer(event, player, command)
    if (string.lower(string.sub(command, 1, string.len(MSG_JAIL))) == MSG_JAIL) then
        -- local name = string.sub(command, string.len(MSG_JAIL) + 2)
        local accountName = player:GetAccountName()
        local args = splitString(command, " ")
        local name = tostring(args[2])

        local fakePlayer = GetPlayerByName(name)

        if player:GetGMRank() <= 2 then
            player:SendBroadcastMessage("You Dont have access to this.")
            return false
        end
        if fakePlayer then
            fakePlayer:LearnSpell(jailSpell)
            fakePlayer:SaveToDB()
            fakePlayer:Teleport(jailLoc[1], jailLoc[2], jailLoc[3], jailLoc[4], jailLoc[5])
        else
            player:SendBroadcastMessage("Player not found.")
        end
        print("Player " .. name .. " been jailed and all characters on account " .. accountName .. ".")
    end
end
local function unJailPlayer(event, player, command)
    if (string.lower(string.sub(command, 1, string.len(MSG_UNJAIL))) == MSG_UNJAIL) then
        -- local name = string.sub(command, string.len(MSG_UNJAIL) + 2)

        local args = splitString(command, " ")
        local name = tostring(args[2])
        if player:GetGMRank() <= 2 then
            player:SendBroadcastMessage("You Dont have access to this.")
            return false
        end

        local accountName = player:GetAccountName()
        local accountId = player:GetAccountId()
        local result = CharDBQuery("SELECT guid FROM characters WHERE account = " .. accountId .. ";")
        if result then
            repeat
                local guid = result:GetUInt32(0)
                CharDBExecute(
                    "DELETE FROM character_spell WHERE guid = " .. guid .. " AND spell = " .. jailSpell .. ";"
                )
            until not result:NextRow()
            player:SendBroadcastMessage("You have unjailed all characters on account " .. accountName .. ".")
        end

        local fakePlayer = GetPlayerByName(name)
        if fakePlayer then
            fakePlayer:RemoveSpell(jailSpell)
            fakePlayer:SaveToDB()
            if fakePlayer:GetTeam() == 0 then
                fakePlayer:Teleport(unJailAlly[1], unJailAlly[2], unJailAlly[3], unJailAlly[4], unJailAlly[5])
            elseif fakePlayer:GetTeam() == 1 then
                fakePlayer:Teleport(unJailHorde[1], unJailHorde[2], unJailHorde[3], unJailHorde[4], unJailHorde[5])
            end
        else
            player:SendBroadcastMessage("Player not found.")
        end
        print("Player " .. name .. " and all characters on account " .. accountName .. " unjailed.")
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_COMMAND, jailPlayer)
RegisterPlayerEvent(PLAYER_EVENT_ON_COMMAND, unJailPlayer)
RegisterPlayerEvent(PLAYER_EVENT_ON_UPDATE_ZONE, zoneChangeWhileJail)
RegisterPlayerEvent(PLAYER_EVENT_ON_LOGIN, applieGlobalJail)
