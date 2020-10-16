--[[ local npcId = XXX

local Hogger = {}

local PAW = XXX  --For summon aid thing

function Hogger.OnEnterCombat(event, creature, target)
    creature:RegisterEvent(Hogger.Slap, 5000, 0)
    creature:RegisterEvent(Hogger.Charge, 6750, 0)
    creature:RegisterEvent(Hogger.ArmorReduce, 300000, 0)
    creature:RegisterEvent(Hogger.SpawnHelp, 1000, 0)
end

local function CleanUp(creature)
    local DESPAWN = creature:GetCreaturesInRange(50, PAW, 0, 0)

    for _, v in pairs(DESPAWN) do
        v:DespawnOrUnsummon(0)
    end

end

function Hogger.Slap(event, dely, calls, creature)
    creature:CastSpell(creature:GetVictim(), 6730, true)
end

function Hogger.Charge(event, dely, calls, creature)
    creature:CastSpell(creature:GetVictim(), 6268, true)
end

function Hogger.ArmorReduce(event, dely, calls, creature)
    creature:CastSpell(creature:GetVictim(), 6016, true)
end

function Hogger.SummonHelp(creature, target)
    local x, y, z = creature:GetRelativePoint(math.random() * 9, math.random() * math.pi * 2)
    local creatureO = creature:GetO()
    local mapId = creature:GetMapId()
    local Victim = creature:GetVictim()
    -- local HogHelp = creature:SpawnCreature(1900021, x, y, z, 0, 4, 300000)
    local HogHelp = PerformIngameSpawn(1, PAW, mapId, 0, x, y, z, creatureO, false, 0, 2)

    if (HogHelp) then
        HogHelp:AttackStart(Victim)
    end

    HogHelp:SetRespawnDelay(696969)
end

function Hogger.SpawnHelp(event, delay, calls, creature)
    Hogger.SummonHelp(creature, creature:GetVictim())
    Hogger.SummonHelp(creature, creature:GetVictim())
    Hogger.SummonHelp(creature, creature:GetVictim())
    creature:SendUnitYell("AID ME!!!", 0)
end

function Hogger.OnEnterCombat(event, creature, target)
    creature:RegisterEvent(Hogger.Slap, 5000, 0)
    creature:RegisterEvent(Hogger.Charge, 6750, 0)
    creature:RegisterEvent(Hogger.ArmorReduce, 300000, 0)
    creature:RegisterEvent(Hogger.SpawnHelp, 2000, 0)
end

function Hogger.OnLeaveCombat(event, creature)
    CleanUp(creature)
    creature:RemoveEvents()
end

function Hogger.OnDied(event, creature, killer)
    if (killer:GetObjectType() == "Player") then
        killer:SendBroadcastMessage("You killed " .. creature:GetName() .. "!")
    end
    creature:RemoveEvents()
end

RegisterCreatureEvent(npcId, 1, Hogger.OnEnterCombat)
RegisterCreatureEvent(npcId, 2, Hogger.OnLeaveCombat)
RegisterCreatureEvent(npcId, 4, Hogger.OnDied)
 ]]