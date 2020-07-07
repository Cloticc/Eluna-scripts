

local MSG_GD = "#gd" -- What messege in chat box
local RANGE = 5 -- What range you want the delete to detect in.


local function DeleteObjectNearby(event, player, msg, Type, lang)
    local gmRank = player:GetGMRank()
    if (gmRank >= 3) then -- change number (0-3) 0 - to all  1,2,3 GM with rank
        local msg = msg:lower()
        if (msg == MSG_GD) then
            
            local FOOP = player:GetNearestGameObject(RANGE, objectid)
            FOOP:RemoveFromWorld(true)
        
        
        end
    
    end
end

RegisterPlayerEvent(18, DeleteObjectNearby)
