--[[ local npcId1 = 1900025

local npcId3 = 1900032 -- Stitched Brute
local npcId4 = 1900033 --Umbral
local npcId5 = 1900030 --shatterer
local npcId6 = 1900029 --Priestess

local Umbrals = {}
local boom = {}
local Naga = {}
local Naga2 = {}
local Mobs = {}

function Mobs.OnEnterCombat(event, creature, target)
    creature:RegisterEvent(Mobs.Trash, 2500, 0)
    -- creature:RegisterEvent(Mobs.DrainLife, {5000, 10000}, 0)
    creature:RegisterEvent(Mobs.Dot, 7500, 0)
end

function Mobs.OnLeaveCombat(event, creature)
    creature:RemoveEvents()
end

function Mobs.OnDied(event, creature, killer)
    creature:RemoveEvents()
end

function Mobs.Trash(event, dely, calls, creature)
    creature:CastSpell(creature:GetVictim(), 53533, false)
end

function Mobs.Dot(event, dely, calls, creature)
    local players = creature:GetPlayersInRange(100)

    creature:CastSpell(players[math.random(1, #players)], 7127, true)
end

RegisterCreatureEvent(npcId1, 1, Mobs.OnEnterCombat)
RegisterCreatureEvent(npcId1, 2, Mobs.OnLeaveCombat)
RegisterCreatureEvent(npcId1, 4, Mobs.OnDied)

function Naga.OnEnterCombat(event, creature, target)
    creature:RegisterEvent(Naga.HealTotem, 5000, 0)

    creature:RegisterEvent(Naga.ChainHeal, 7000, 0)
end

function Naga.OnLeaveCombat(event, creature)
    creature:RemoveEvents()
end

function Naga.OnDied(event, creature, killer)
    creature:RemoveEvents()
end

function Naga.HealTotem(event, dely, calls, creature)
    creature:CastSpell(creature:GetVictim(), 42376, true)
end

function Naga.ChainHeal(event, dely, calls, creature)
    creature:CastSpell(creature:GetVictim(), 1064, false)
end

RegisterCreatureEvent(npcId6, 1, Naga.OnEnterCombat)
RegisterCreatureEvent(npcId6, 2, Naga.OnLeaveCombat)
RegisterCreatureEvent(npcId6, 4, Naga.OnDied)

function Naga2.OnEnterCombat(event, creature, target)
    creature:RegisterEvent(Naga2.Knockaway, 2000, 0)
end

function Naga2.OnLeaveCombat(event, creature)
    creature:RemoveEvents()
end

function Naga2.OnDied(event, creature, killer)
    creature:RemoveEvents()
end

function Naga2.Knockaway(event, dely, calls, creature)
    creature:CastSpell(creature:GetVictim(), 33960, true)
end

RegisterCreatureEvent(npcId5, 1, Naga2.OnEnterCombat)
RegisterCreatureEvent(npcId5, 2, Naga2.OnLeaveCombat)
RegisterCreatureEvent(npcId5, 4, Naga2.OnDied)

function boom.OnEnterCombat(event, creature, target)
    creature:RegisterEvent(boom.PullTarget, 4000, 0)
    creature:RegisterEvent(boom.Explode, 5000, 0)
end

function boom.OnLeaveCombat(event, creature)
    creature:RemoveEvents()
end

function boom.OnDied(event, creature, killer)
    creature:CastSpell(creature:GetVictim(), 67729, true)
    creature:RemoveEvents()
end

function boom.Explode(event, dely, calls, creature)
    if (creature:GetHealthPct() <= 5) then
        creature:CastSpell(creature:GetVictim(), 31703, true)
    end
end

function boom.PullTarget(event, dely, calls, creature)
    local players = creature:GetPlayersInRange(100)

    creature:CastSpell(players[math.random(1, #players)], 41959, true)
end

RegisterCreatureEvent(npcId3, 1, boom.OnEnterCombat)
RegisterCreatureEvent(npcId3, 2, boom.OnLeaveCombat)
RegisterCreatureEvent(npcId3, 4, boom.OnDied)

function Umbrals.OnEnterCombat(event, creature, target)
    creature:RegisterEvent(Umbrals.BloodMirror, 5000, 0)

end

function Umbrals.OnLeaveCombat(event, creature)
    creature:RemoveEvents()
end

function Umbrals.OnDied(event, creature, killer)

    creature:RemoveEvents()
end

function Umbrals.BloodMirror(event, dely, calls, creature)
    local players = creature:GetPlayersInRange(100)

    creature:CastSpell(players[math.random(1, #players)], 50844, true)

end

RegisterCreatureEvent(npcId4, 1, Umbrals.OnEnterCombat)
RegisterCreatureEvent(npcId4, 2, Umbrals.OnLeaveCombat)
RegisterCreatureEvent(npcId4, 4, Umbrals.OnDied)
 ]]