--[[ local npcId = XXX

local Izrentaph = {}

function Izrentaph.OnEnterCombat(event, creature, target)
    creature:SendUnitYell("Ssssssstop them at onnesssss", 0)
    creature:RegisterEvent(Izrentaph.FreezeTrap, 5000, 0)
    creature:RegisterEvent(Izrentaph.Arrow, 6000, 0)
    creature:RegisterEvent(Izrentaph.Static, 20000, 0)
    creature:RegisterEvent(Izrentaph.ChainLight, 30000, 0)
end

function Izrentaph.OnLeaveCombat(event, creature)
    creature:RemoveEvents()
end

function Izrentaph.OnDied(event, creature, killer)
    if (killer:GetObjectType() == "Player") then
        killer:SendBroadcastMessage("You killed " .. creature:GetName() .. "!")
    end
    creature:RemoveEvents()
end

function Izrentaph.FreezeTrap(event, dely, calls, creature)
    if (math.random(1, 100) <= 75) then
    creature:CastSpell(creature:GetVictim(), 13809, true)
    end
end

function Izrentaph.Arrow(event, dely, calls, creature)
    if (math.random(1, 100) <= 75) then
    creature:CastSpell(creature:GetVictim(), 38310, true)
    end
end

function Izrentaph.Static(event, dely, calls, creature)
    if (math.random(1, 100) <= 85) then
        local players = creature:GetPlayersInRange()
        creature:CastSpell(players[math.random(1, #players)], 38280)
    end
end



function Izrentaph.ChainLight(event, dely, calls, creature)
    creature:CastSpell(creature:GetVictim(), 10605, false)
end

RegisterCreatureEvent(npcId, 1, Izrentaph.OnEnterCombat)
RegisterCreatureEvent(npcId, 2, Izrentaph.OnLeaveCombat)
RegisterCreatureEvent(npcId, 4, Izrentaph.OnDied)
 ]]