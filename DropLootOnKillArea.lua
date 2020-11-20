--[[ Helped a person to fix this.]]
local npcid = 17259

local chance = 0.30

local DropSolo = {51800, 51803, 50793, 51011, 51384, 51788}

math.randomseed(os.time()) --If you want a different sequence of random numbers, then pass this. os.time() will return the time in number of seconds so it will be different every time.

function BonechewerHungerer(event, creature, killer)
    local item, range, isHostile, isDead = 12345, 50, 0, 0
    local players = creature:GetPlayersInRange(range, isHostile, isDead)

    if (players) then
        for _, player in pairs(players) do
            for _, v in pairs(DropSolo) do
                if (math.random() < chance) then
                    player:AddItem(v)
                end
            end
        end
    end
end

RegisterCreatureEvent(npcid, 4, BonechewerHungerer)
