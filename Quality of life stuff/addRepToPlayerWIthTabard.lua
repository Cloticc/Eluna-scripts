local PLAYER_EVENT_ON_KILL_CREATURE = 7 --,        // (event, killer, killed)


local startRoll = 10 -- chance to get rep lowest roll
local endRoll = 50   -- chance to get rep highest roll


-- local Herakles = 1161 example or just add the id to the table directly
-- replace factionIDEntry with faction id
local tabardBuff = {
    -- [factionIDEntry] = { Herakles },
    -- [123] = { 123 },
}
local CREATURE_TYPE_CRITTER = 8




local function giveRepSlayCreature(evnet, killer, killed)
    for k, v in pairs(tabardBuff) do
        if killer:HasAura(k) then
            if killed:GetCreatureType() == CREATURE_TYPE_CRITTER then
                return
            end
            for i, factionId in pairs(v) do
                local reputationAmt = killer:GetReputation(factionId)
                killer:SetReputation(factionId, reputationAmt + math.random(startRoll, endRoll))
            end
        end
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_KILL_CREATURE, giveRepSlayCreature)
