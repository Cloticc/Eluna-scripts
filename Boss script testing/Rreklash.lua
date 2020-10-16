local npcid = 43290

local Rreklash = {}
local T = {
    {616, 792.57660, 1336.438843, 268.231201, 3.874872},
    {616, 802.544434, 1282.252319, 268.231201, 2.805945},
    {616, 763.569580, 1250.908203, 268.231201, 1.785713},
    {616, 714.493286, 1268.802856, 268.231201, 0.683798}
}

local function Banish(creature)
    local players = creature:GetPlayersInRange(0, 0, 2)
    local map, x, y, z, o = table.unpack(T[math.random(1, #T)])

    for i, v in ipairs(players) do
        v:SendBroadcastMessage("You been banished wait the time")
        v:ResetAllCooldowns()
        v:ResurrectPlayer()
        -- v:SetHealth(v:GetMaxHealth())
        -- v:SetPower(v:GetMaxPower(0), 0)
        v:Teleport(map, x, y, z, o)
        v:AddAura(710, v)
 
    end
end

--[[ function Rreklash.Banish(event, dely, calls, creature, player)
    local players = creature:GetPlayersInRange()

    local map, x, y, z, o = table.unpack(T[math.random(1, #T)])

    for i, v in ipairs(players) do
        if (v:GetHealthPct() <= 10) then
            v:ResurrectPlayer(100)
            v:AddAura(710, v)
            v:ResetAllCooldowns()
            -- v:SetHealth(v:GetMaxHealth())
            -- v:SetPower(v:GetMaxPower(0), 0)
            v:Teleport(map, x, y, z, o)
        end
    end
end ]]

function Rreklash.OnEnterCombat(event, creature, target)
    Banish(creature)
    creature:RegisterEvent(Rreklash.Enrage, 300000, 0)
    creature:RegisterEvent(Rreklash.CaveIn, 15000, 0)
    creature:RegisterEvent(Rreklash.Shatter, 5000, 0)
    creature:RegisterEvent(Rreklash.GroundSlam, 30000, 0)
    creature:RegisterEvent(Rreklash.Boulder, 2500, 0)
    creature:RegisterEvent(Rreklash.RockRumble, 5000, 0) --knock playerup
end

function Rreklash.OnLeaveCombat(event, creature)
    Banish(creature)
    creature:RemoveEvents()
end

function Rreklash.OnDied(event, creature, killer)
    if (killer:GetObjectType() == "Player") then
        killer:SendBroadcastMessage("You killed " .. creature:GetName() .. "!")
    end
    creature:RemoveEvents()
end

function Rreklash.CaveIn(event, dely, calls, creature)
    if (math.random(1, 100) <= 70) then
        local players = creature:GetPlayersInRange()
        -- creature:CastSpell(players[math.random(1, #players)], 36240) --Cant use this it will destroy low levelplayers
        creature:CastCustomSpell(players[math.random(1, #players)], 36240, false, 500, 0, 0) --Use CustomSpell Cast instead so i can handle the dmg
    --Instead of using spellregulator seems like it didnt like this spell
    end
end

function Rreklash.Shatter(event, dely, calls, creature)
    creature:CastSpell(creature:GetVictim(), 33654, false)
end

function Rreklash.GroundSlam(event, dely, calls, creature)
    creature:SendUnitYell("ME SMASH", 0)
    creature:CastSpell(creature:GetVictim(), 33525, false)
end

function Rreklash.Boulder(event, dely, calls, creature)
    if (math.random(1, 100) <= 95) then
        local players = creature:GetPlayersInRange()
        creature:CastSpell(players[math.random(1, #players)], 42139, false)
    end
end
function Rreklash.RockRumble(event, dely, calls, creature)
    if (math.random(1, 100) <= 60) then
        local players = creature:GetPlayersInRange()
        creature:CastSpell(players[math.random(1, #players)], 38777, false)
    end
end

function Rreklash.Enrage(event, dely, calls, creature)
    creature:CastSpell(creature, 38771, true)
end

RegisterCreatureEvent(npcid, 1, Rreklash.OnEnterCombat)
RegisterCreatureEvent(npcid, 2, Rreklash.OnLeaveCombat)
RegisterCreatureEvent(npcid, 4, Rreklash.OnDied)

--[[ local function PlayerInsideEternity(event, killer, killed)
    local map, x, y, z, o = table.unpack(T[math.random(1, #T)])

    if killed:GetMapId() == 616 then
        killed:SendBroadcastMessage("You been banished wait the time")
        killed:ResurrectPlayer(100)
        killed:ResetAllCooldowns()
        killed:Teleport(map, x, y, z, o)
        killer:AddAura(710, killed)
    end
end

RegisterPlayerEvent(8, PlayerInsideEternity)
 ]]