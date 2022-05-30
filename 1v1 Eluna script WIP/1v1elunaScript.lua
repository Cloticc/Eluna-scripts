--[[
    1v1 arena script.
Make sure change entry to your npc id.
i have not tried this on live server only local with a other client.
 If you have any problem with this script please open issue on github.


Credit: Clotic, Foe for que system.



 ]] local arena1 = {} -- #1v1 Arena

arena1.Entry = 3460610 -- NPC entry
arena1.Arena1 = {562, 6184.9853515625, 235.77510070801, 6.1149973869324, 0.89535737037659} -- Arena 1 location for player 1
arena1.Arena2 = {562, 6293.8432617188, 290.15078735352, 6.559232711792, 0.89535403251648} -- Arena 2 location for player 2

--[[
don't edit below this line :)
 ]]

local GOSSIP_EVENT_ON_HELLO = 1
--  // (event, player, object)
local GOSSIP_EVENT_ON_SELECT = 2
-- // (event, player, object, sender, intid, code, menu_id)

local SizeOfTeam = 1

local RawPlayerTable = {}
local TeamTable = {
    unassembled = {},
    assembled = {}
}

local function ConvertRawToUnassembled(T)
    for i = 1, #T do -- Check first table
        -- print("Raw players: " .. T[i])
    end

    -- print("--------")

    math.randomseed(tonumber(tostring(os.time() * #T):reverse():sub(1, 6))) -- Recommended Lua seed generation
    for i1 = 1, math.floor(#T / SizeOfTeam) do -- runs if any players are in raw table
        TeamTable.unassembled[i1] = {}
        -- print("\nTEAM NR: " .. i1 .. "\n")

        for i2 = 1, SizeOfTeam do -- increments to 3 on each loop for 3 players max per random group
            -- print("Player count: " .. i2)
            -- print("Players in raw table: " .. #T)

            local k = math.random(1, #T) -- Retrieve random player
            -- print("Picked for team: " .. T[k])
            TeamTable.unassembled[i1][i2] = T[k]

            table.remove(T, k)
            -- print("--------")
        end
        TeamTable.unassembled[i1][SizeOfTeam + 1] = false
    end
    -- print()
end

local function CheckUnassembledTeams()
    for k, v in ipairs(TeamTable.unassembled) do -- Print all the teams signed up
        for i = 1, SizeOfTeam do
            -- print("Team " .. k .. " includes players: " .. v[i])
        end
        -- print("Is team in queue; " .. tostring(v[SizeOfTeam + 1]) .. "\n")
    end
end

local function AssembleTeam()
    for k, v in ipairs(TeamTable.unassembled) do -- Assemble group code and remove from unassembled team table
        if v[SizeOfTeam + 1] == false then
            -- print("Team " .. k .. " is not yet assembled, ASSEMBLE IT!")
            TeamTable.assembled[k] = v
            -- print("DEBUG KEY: " .. k .. "\n")
        end
    end
    TeamTable.unassembled = {}
end

local function WhateverComesNext()
    for k, v in ipairs(TeamTable.assembled) do -- Send summon/whatever code
        -- print("Team " .. k .. " is assembled, send summon.")
    end
    -- print()
end

local function CheckAllTables()
    if #TeamTable.unassembled ~= 0 then -- Print all the teams signed up, just to see if they were removed successfully on assemble
        for k, v in ipairs(TeamTable.unassembled) do
            for i = 1, SizeOfTeam do
                -- print("Team " .. k .. " includes players: " .. v[i])
            end
            -- print("Is team in queue; " .. tostring(v[4]) .. "\n")
        end
    else
        -- print("No players in unassembled team queue\n")
    end

    for k, v in ipairs(TeamTable.assembled) do -- Print all the assembled teams
        for i = 1, SizeOfTeam do
            -- print("Assembled team " .. k .. " includes players: " .. v[i])
        end
        -- print()
    end

    for i = 1, #RawPlayerTable do
        -- print("Players still in Raw player table: " .. RawPlayerTable[i])
    end
end

local function teleportToArena(eventId, delay, repeats, player)
    ConvertRawToUnassembled(RawPlayerTable)
    CheckUnassembledTeams()
    AssembleTeam()
    WhateverComesNext()
    CheckAllTables()

    for k, v in ipairs(TeamTable.assembled) do
        local player = GetPlayerByName(v[1])

        if k == 1 then -- Team 1
            player:Teleport(arena1.Arena1[1], arena1.Arena1[2], arena1.Arena1[3], arena1.Arena1[4], arena1.Arena1[5])
        elseif k == 2 then -- Team 2
            player:Teleport(arena1.Arena2[1], arena1.Arena2[2], arena1.Arena2[3], arena1.Arena2[4], arena1.Arena2[5])
        end
    end
end

function arena1.NpcHello(event, player, object)
    player:GossipMenuAddItem(0, "1v1 Arena", 0, 1)

    player:GossipMenuAddItem(0, "Show players in queue: " .. #RawPlayerTable, 0, 2)

    player:GossipSendMenu(1, object)
end

function arena1.Selection(event, player, object, sender, intid, code, menu_id)
    if (intid == 1) then
        table.insert(RawPlayerTable, player:GetName())
        if #RawPlayerTable == 2 then
            player:RegisterEvent(teleportToArena, 5000, 1)
        end
    end
    player:GossipComplete()
end

RegisterCreatureGossipEvent(arena1.Entry, GOSSIP_EVENT_ON_HELLO, arena1.NpcHello)
RegisterCreatureGossipEvent(arena1.Entry, GOSSIP_EVENT_ON_SELECT, arena1.Selection)
