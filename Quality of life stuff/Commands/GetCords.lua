--Give xyzo cords
local MSG_CO = "#xyz" -- Command in chat for it to appear

local function GetCords(event, player, msg, Type, lang)
    if (msg:find(MSG_CO)) then
        local x = player:GetX()
        local y = player:GetY()
        local z = player:GetZ()
        local o = player:GetO()

        player:SendBroadcastMessage(("|cffffffff X |r " .. x .. ""))
        player:SendBroadcastMessage(("|cffffffff Y |r " .. y .. ""))
        player:SendBroadcastMessage(("|cffffffff Z |r " .. z .. ""))
        player:SendBroadcastMessage(("|cffffffff O |r " .. o .. ""))

        return false
    end
end

RegisterPlayerEvent(18, GetCords)
