--[[ Test add aura on zone, map change ]]

local Apply = {26393}


local function Add_Aura_Map_Zone_Change(event, player, newZone, newArea)
    if not player:HasAura(32728) then
        for k, v in pairs(Apply) do
            player:AddAura(v, player)
        end
    end
end



RegisterPlayerEvent(27, Add_Aura_Map_Zone_Change)-- PLAYER_EVENT_ON_UPDATE_ZONE
RegisterPlayerEvent(28, Add_Aura_Map_Zone_Change)-- PLAYER_EVENT_ON_MAP_CHANGE
