-- {zoneId, buffId, amount, duration},
--duration is in miliseconds
--amount not all spells have stacks
-- example: Below is an example of a zone buff that gives battleShout in Elwynn Forest and in Westfall Commanding Shout. duration is in miliseconds.
local zoneBuffs = {
    --[[
        [zoneId] = { ---this is the format
            { buffId = 80893, amount = 0, duration = 0 },
            { buffId = 80896, amount = 5, duration = 0 }
        }
    ]]
    [1] = {
        { buffId = 80893, amount = 5, duration = 0 },
        { buffId = 80896, amount = 5, duration = 0 }
    },
    [12] = { --Elwynn Forest
        { buffId = 80893, amount = 2, duration = 0 },
        { buffId = 80896, amount = 5, duration = 0 }
    },
    [40] = { --Westfall
        { buffId = 80893, amount = 25, duration = 0 },
        { buffId = 80896, amount = 25, duration = 0 }
    },
    [10] = { --Duskwood
        { buffId = 47241, amount = 0, duration = 1800000 },
        { buffId = 47893, amount = 0, duration = 0 },
        { buffId = 34074, amount = 0, duration = 0 },
        { buffId = 80896, amount = 3, duration = 0 }
    },
    [141] = {

        { buffId = 80893, amount = 5, duration = 0 },
        { buffId = 80896, amount = 5, duration = 0 }
    },
    [14] = {
        { buffId = 80893, amount = 5, duration = 0 },
        { buffId = 80896, amount = 5, duration = 0 }
    }
}


local PLAYER_EVENT_ON_UPDATE_ZONE = 27
local playerZone = {}

local function checkZone(event, player, _, _)
    local zoneId = player:GetZoneId() -- get the zone id
    local zone = zoneBuffs[zoneId] -- get the zone from the table
    local currentZone = playerZone[player:GetGUIDLow()] -- get the current zone from the playerZone table

    if zone ~= currentZone then
        for _, zoneBuff in pairs(zoneBuffs) do
            for _, buffId in pairs(zoneBuff) do
                local aura = player:GetAura(buffId.buffId)
                if aura then
                    aura:Remove()
                end
            end
        end
        playerZone[player:GetGUIDLow()] = zone
    end



    if zone ~= currentZone then
        if not zone then
            return
        end
        for _, buff in ipairs(zone) do
            if not player:HasAura(buff.buffId) then

                player:AddAura(buff.buffId, player)
                if buff.amount > 1 then
                    local aura = player:GetAura(buff.buffId)

                    if aura then
                        aura:SetStackAmount(buff.amount)
                    end
                end
                if buff.duration > 1 then
                    local aura = player:GetAura(buff.buffId)

                    if aura then
                        aura:SetDuration(buff.duration)
                    end
                end
            end
        end
        return

    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_UPDATE_ZONE, checkZone)
