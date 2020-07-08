local MSG_GD = "#gd" -- What messege in chat box
local RANGE = 10 -- What range you want the delete to detect in.

local function DeleteObjectNearby(event, player, msg, Type, lang)
    local gmRank = player:GetGMRank()
    if (gmRank >= 3) then -- change number (0-3) 0 - to all  1,2,3 GM with rank
        local msg = msg:lower()
        if (msg == MSG_GD) then
            local a = player:GetNearestGameObject(RANGE)
            local b = a:GetEntry()
            local c = a:GetDisplayId()
            local d = a:GetName()
            local e = a:GetGUIDLow()
            a:RemoveFromWorld(true)
            player:SendBroadcastMessage(
            ("|cFFffffff Name: |r " .. d .. " |cFFffffff Guid Low: |r " .. e .. " |cFFffffff Entry Deleted: |r  " .. b .. " |cFFffffff Display ID: |r " .. c .. "!")
        )
        end
    end
end
RegisterPlayerEvent(18, DeleteObjectNearby)
