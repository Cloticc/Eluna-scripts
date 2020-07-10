-- obd deletes object and you get info
-- obc check info will not delete the item
local MSG_OBD = "#obd" -- What messege in chat box
local MSG_OBC = "#obc" -- What messege in chat box

local RANGE = 10 -- What range you want the delete to detect in.

local function DeleteObjectNearby(event, player, msg, _, lang)
    local gmRank = player:GetGMRank()
    if (gmRank >= 3) then -- change number (0-3) 0 - to all  1,2,3 GM with rank
        if (msg:find(MSG_OBD)) then
            local a = player:GetNearestGameObject(RANGE)
            local b = a:GetEntry()
            local c = a:GetDisplayId()
            local d = a:GetName()
            a:RemoveFromWorld(true)
            player:SendBroadcastMessage(
                "|cFFffffff Name: |r " ..
                    d .. " |cFFffffff Entry Deleted: |r  " .. b .. " |cFFffffff Display ID: |r " .. c .. ""
            )
            return false
        end

        if  (msg:find(MSG_OBC)) then
            local a = player:GetNearestGameObject(RANGE)
            local b = a:GetEntry()
            local c = a:GetDisplayId()
            local d = a:GetName()
            player:SendBroadcastMessage(
                "|cFFffffff Name: |r " .. d .. " |cFFffffff Entry:|r  " .. b .. " |cFFffffff Display ID: |r " .. c .. ""
        )
            return false
        end
    end
end


RegisterPlayerEvent(18, DeleteObjectNearby)
