--Probably want to change Buffs you want active. All the non targeted once are normal class buffs.
local MSG_BUFF = "#buff"
local Cost = 1000000 --- How much buff msg cost to use. 10gold atm
local buffID = {
    26393, --Eluns blessing 10% Stats
    23735, -- Sayge's Dark Fortune of Strength
    23737, -- Sayge's Dark Fortune of Stamina
    23738, -- Sayge's Dark Fortune of Stamina
    23769, -- Sayge's Dark Fortune of Resistance
    23766, -- Sayge's Dark Fortune of Intelligence
    23768, -- Sayge's Dark Fortune of Damage
    23767, -- Sayge's Dark Fortune of Armor
    23736, -- Sayge's Dark Fortune of Agility
    48074,
    48170,
    43223,
    32728, --Arena prep free spell casting
    36880,
    467,
    48469,
    48162,
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
    48074,
    38734, -- Master Ranged Buff
    35912, -- Master Magic Buff
    35874 -- Master Melee Buff
}

local function Buff_Command(event, player, msg, type, language)
    local gmRank = player:GetGMRank()
    if (gmRank >= 3) then -- change number (0-3) 0 - to all  1,2,3 GM with rank
        selectTarget = player:GetSelection()
        if (not selectTarget) then
            selectTarget = player
        end
    end
    if (msg:find(MSG_BUFF)) then
        if (player:GetCoinage() >= Cost) then
            player:ModifyMoney(-Cost)
            for k, v in pairs(buffID) do
                selectTarget:AddAura(v, selectTarget)
            end
            player:SendBroadcastMessage("|cFDFEFEbuffed, Enjoy!|r")
        end

        return false
    end
end

RegisterPlayerEvent(18, Buff_Command)
