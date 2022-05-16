local SwitchGender = {}
local MSG_GEN = "#gender"

local Cost = 0 --This is in copper so the value that is now 100g so 1000000c
local Gold = 0 -- Gold value for visual on screen to showup. Can probably improve this later

local function SwitchGender(event, player, msg, Type, lang)
    if (msg:find(MSG_GEN)) then
        local gmRank = player:GetGMRank()
        if (gmRank <= 2) then -- change number (0-3) 0 - to all  1,2,3 GM with rank
            player:SendAreaTriggerMessage("You Dont have access to this.")
            return
        end

        if player:GetCoinage() >= Cost then
        else
            player:SendAreaTriggerMessage("You require" .. Gold .. " Gold")
            return false
        end

        player:SetCoinage(player:GetCoinage() - Cost)
        player:SendAreaTriggerMessage(Gold .. " Gold Been taken")

        if player:GetGender() == 0 then
            player:SetGender(1)
            return false
        end

        if player:GetGender() == 1 then
            player:SetGender(0)
            return false
        end
    end
end
RegisterPlayerEvent(18, SwitchGender)
