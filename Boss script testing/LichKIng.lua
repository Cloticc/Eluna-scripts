--[[ local npcid = XXX

local LichKing = {}

function LichKing.Suicide(event, delay, calls, creature)
    if (creature:HasAura(40733) == true) then
        creature:SendUnitSay("I will return however. I will not be killed by the likes of you", 0)
        creature:CastSpell(creature, 7, true)
    end
end

function LichKing.PhaseEnd(event, delay, calls, creature)
    if (creature:GetHealthPct() <= 10) then
        creature:RemoveEvents()
        creature:CastSpell(creature, 40733, true)
        creature:SendUnitSay("Is it true?. It can't be.", 0)
        creature:RegisterEvent(LichKing.Suicide, 8000, 0)
    end
end

function LichKing.PhaseThree(event, delay, calls, creature)
    if (creature:GetHealthPct() <= 30) then
        creature:RemoveEvents()
        local TARGET3 = creature:GetAITarget(1, true, 0, 45)

        creature:CastSpell(TARGET3, 40733, true)
        creature:RegisterEvent(LichKing.PhaseEnd, 1000, 0)
    end
end

function LichKing.PhaseTwo(event, delay, calls, creature)
    if (creature:GetHealthPct() <= 75) then
        creature:RemoveEvents()

        creature:SendUnitSay("Sleep", 0)
        for i = 1, 5 do
            local x, y, z = creature:GetRelativePoint(math.random() * 9, math.random() * math.pi * 2)
            creature:CastSpellAoF(x, y, z, 24778, true)
        end
        creature:RegisterEvent(LichKing.PhaseThree, 1000, 0)
    end
end

function LichKing.PhaseOne(event, delay, calls, creature)
    if (creature:GetHealthPct() <= 90) then
        creature:RemoveEvents()
        local TARGET2 = creature:GetAITarget(0, true, 0, 45)
        local TARGET3 = creature:GetAITarget(1, true, 0, 45)
        creature:CastSpell(TARGET2, 16803, true)
        creature:SendUnitSay("You are doomed, haha!", 0)
        creature:CastSpell(TARGET3, 36145, true)

        creature:RegisterEvent(LichKing.PhaseTwo, 1000, 0)
    end
end

function LichKing.OnEnterCombat(event, creature, target)
    local TARGET = creature:GetAITarget(1, true, 0, 45)
    creature:SendUnitSay("You dare challenge me!", 0)
    creature:CastSpell(TARGET, 33547, true)
    creature:RegisterEvent(LichKing.PhaseOne, 1000, 0)
end

function LichKing.OnLeaveCombat(event, creature)
    creature:SendUnitYell("Ha, Weaklings", 0)
    creature:RemoveEvents()
end

RegisterCreatureEvent(npcid, 1, LichKing.OnEnterCombat)
RegisterCreatureEvent(npcid, 2, LichKing.OnLeaveCombat)
RegisterCreatureEvent(npcid, 4, LichKing.Suicide)
 ]]