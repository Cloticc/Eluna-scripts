--[[ Test add aura on zone, map change ]]

local Apply = {26393}


local function AddAuraMapZoneChange(event, player, newZone, newArea)
    if not player:HasAura(32728) then
        for k, v in pairs(Apply) do
            player:AddAura(v, player)
        end
    end
end



RegisterPlayerEvent(27, AddAuraMapZoneChange)-- PLAYER_EVENT_ON_UPDATE_ZONE
RegisterPlayerEvent(28, AddAuraMapZoneChange)-- PLAYER_EVENT_ON_MAP_CHANGE
