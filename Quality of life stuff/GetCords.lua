--Give xyzo cords
local MSG_CO = "#xyz" --#command for triggering

local function RandomPenis(event, player, msg, Type, lang)
    local msg = msg:lower()
    if (msg == MSG_CO) then
        local x = player:GetX()
        local y = player:GetY()
        local z = player:GetZ()
        local o = player:GetO()
        player:SendBroadcastMessage(("|cffffffff Test X |r " .. x .. ""))
        player:SendBroadcastMessage(("|cffffffff Test Y |r " .. y .. ""))
        player:SendBroadcastMessage(("|cffffffff Test Z |r " .. z .. ""))
        player:SendBroadcastMessage(("|cffffffff Test O |r " .. o .. ""))
        return false
    end

end

RegisterPlayerEvent(18, RandomPenis)


