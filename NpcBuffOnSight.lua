
--Probably want to change Buffs you want active. All the non targeted once are normal class buffs.
local NPC_ID = xXx -- Npcs ID

--Remove or add buffs you want the npc to buff. BUFF_CHECK is buff that npc will check if u got buffs.
local BUFF_CHECK = 467

local BUFF_IDS = {
    23735, -- Sayge's Dark Fortune of Strength
    23737, -- Sayge's Dark Fortune of Stamina
    23738, -- Sayge's Dark Fortune of Stamina
    23769, -- Sayge's Dark Fortune of Resistance
    23766, -- Sayge's Dark Fortune of Intelligence
    23768, -- Sayge's Dark Fortune of Damage
    23767, -- Sayge's Dark Fortune of Armor
    23736, -- Sayge's Dark Fortune of Agility
    26393, --Eluns blessing 10% Stats
    48074,
    48170,
    43223,
    36880,
    467,
    48469,
    48162,
    32728, --Arena prep free spell casting
    21564,
    26035,
    48469,
    48073,
    16609,
    36880,
    15366,
    43223,

    -- 65077, -- tower of frost 40% health
    -- 65075, -- tower of fire 40% health 50% fire damage
    38734, -- Master Ranged Buff
    35912, -- Master Magic Buff
    35874, -- Master Melee Buff
    48074
}

local function Buff_on_Sight(event, creature, player)
    if creature:IsInRange(player, 1, 15) then
       local playerGUID = player:GetGUIDLow()
        if (playerGUID > 0) then
            local player = GetPlayerByGUID(playerGUID)
            if (player ~= nil) then
                if not player:HasAura(BUFF_CHECK) then
                    for k, v in pairs(BUFF_IDS) do
                        player:AddAura(v, player)
                    end
                    creature:SendChatMessageToPlayer(8, 0, "You been buffed enjoy.", player)
                end
            end
        end
    end
end
RegisterCreatureEvent(NPC_ID, 27, Buff_on_Sight)
