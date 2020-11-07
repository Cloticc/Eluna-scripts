-- obd deletes object and you get info
-- obc check info will not delete the item
local MSG_OBD = "#obd" -- What Message in chat box
local MSG_OBC = "#obc" -- What Message in chat box

local RANGE = 10 -- What range you want the delete to detect in.

-------------------------------------------------------------------------
local function DeleteObjectNearby(event, player, msg, _, lang)
    if (msg:find(MSG_OBD)) or (msg:find(MSG_OBC)) then
        if (gmRank <= 2) then -- change number (0-3) 0 - to all  1,2,3 GM with rank
            player:SendBroadcastMessage("You Dont have access to this.")
            return false
        end

        if not player:GetNearestGameObject(RANGE) then
            player:SendBroadcastMessage("There is nothing except the void.")
            return false
        end
        local a = player:GetNearestGameObject(RANGE)
        local b = a:GetEntry()
        local c = a:GetDisplayId()
        local d = a:GetName()
        local e = a:GetDBTableGUIDLow()
        if (msg:find(MSG_OBD)) then
            a:RemoveFromWorld(true)

            player:SendBroadcastMessage(
                "|cFFffffff Name: |r " ..
                    d ..
                        " |cFFffffff Entry Deleted:|r " ..
                            b .. " |cFFffffff GUID: |r " .. e .. " |cFFffffff Display ID: |r " .. c .. ""
            )
            return false
        elseif (msg:find(MSG_OBC)) then
            player:SendBroadcastMessage(
                "|cFFffffff Name: |r " ..
                    d ..
                        " |cFFffffff Entry:|r  " ..
                            b .. " |cFFffffff GUID: |r " .. e .. " |cFFffffff Display ID: |r " .. c .. ""
            )
            return false
        end
    end
end

RegisterPlayerEvent(18, DeleteObjectNearby)
