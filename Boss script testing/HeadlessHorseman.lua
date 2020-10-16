--[[ local npcid = XXX

local Headless = {}

function Headless.OnEnterCombat(event, creature, target)
    creature:RegisterEvent(Headless.Shadowbolt, 3000, 0)
    creature:RegisterEvent(Headless.RainOfFire, 10000, 0)
    creature:RegisterEvent(Headless.Disarm, 12000, 0)
    -- creature:RegisterEvent(Headless.SpawnHelp, 8000, 1)
end

function Headless.OnLeaveCombat(event, creature)
    creature:RemoveEvents()
end

function Headless.OnDied(event, creature, killer)
    if (killer:GetObjectType() == "Player") then
        killer:SendBroadcastMessage("You killed " .. creature:GetName() .. "!")
    end
    creature:RemoveEvents()
end

function Headless.Shadowbolt(event, dely, calls, creature)
    local TARGET2 = creature:GetAITarget(0, true, 0, 45)
    creature:CastSpell(TARGET2, 1088, false)
end

function Headless.RainOfFire(event, dely, calls, creature)
    creature:SendUnitYell("Let there be FIRE", 0)


    local x1, y1, z1 = creature:GetRelativePoint(math.random(3, 6), (math.random(math.pi / 12, math.pi * 2)))
    creature:CastSpellAoF(x1, y1, z1, 20754, true)
end

function Headless.Disarm(event, dely, calls, creature)
    creature:CastSpell(creature:GetVictim(), 13534, true)
end



RegisterCreatureEvent(npcid, 1, Headless.OnEnterCombat)
RegisterCreatureEvent(npcid, 2, Headless.OnLeaveCombat)
RegisterCreatureEvent(npcid, 4, Headless.OnDied)
 ]]