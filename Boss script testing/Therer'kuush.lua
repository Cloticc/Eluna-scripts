local npcId = XXX

local Therer = {}

function Therer.OnEnterCombat(event, creature, target)
    creature:RegisterEvent(Therer.ArcaneBolt, 12000, 0)
    creature:RegisterEvent(Therer.DrainLife, 7500, 0)
    creature:RegisterEvent(Therer.DigestiveAcid, 100000, 0)
    creature:RegisterEvent(Therer.ArcaneExplode, 150000, 0)

end

function Therer.OnLeaveCombat(event, creature)
    creature:SendUnitYell("Didn't even stand a chance", 0)
    creature:CastSpell(creature, 36393, true)
    creature:RemoveEvents()
end

function Therer.OnDied(event, creature, killer)
    if (killer:GetObjectType() == "Player") then
        killer:SendBroadcastMessage("You killed " .. creature:GetName() .. "!")
    end
    creature:RemoveEvents()
end

function Therer.ArcaneExplode(event, dely, calls, creature)
    local TARGET3 = creature:GetAITarget(4, true, 0, 45)
    creature:CastSpell(TARGET3, 34656, true)


    
end

function Therer.ArcaneBolt(event, dely, calls, creature)
    local TARGET2 = creature:GetAITarget(4, true, 0, 45)
    creature:CastSpell(TARGET2, 58456, true)
end

function Therer.DrainLife(event, dely, calls, creature)
    creature:CastSpell(creature:GetVictim(), 17620, false)
end

function Therer.DigestiveAcid(event, dely, calls, creature)
    local TARGET1 = creature:GetAITarget(1, true, 0, 45)
    creature:CastSpell(TARGET1, 26476, true)
end



RegisterCreatureEvent(npcId, 1, Therer.OnEnterCombat)
RegisterCreatureEvent(npcId, 2, Therer.OnLeaveCombat)
RegisterCreatureEvent(npcId, 4, Therer.OnDied)
