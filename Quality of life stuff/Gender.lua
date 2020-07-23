local MSG_GEN = "#gender"
local Cost = 1000000 --This is in copper so the value that is now 100g so 1000000c

local function SwitchGender(event, player, msg, Type, lang)
    if player:IsInCombat() then
        player:SendBroadcastMessage("You are in combat!")
    else
        local gmRank = player:GetGMRank()
        if (gmRank >= 0) then -- change number (0-3) 0 - to all  1,2,3 GM with rank
            if (msg:find(MSG_GEN)) then
                if player:GetCoinage() >= Cost then
                else
                    player:SendAreaTriggerMessage("You need 100 gold")
                    return false
                end
                player:SetCoinage(player:GetCoinage() - Cost)
                player:SendAreaTriggerMessage("You feel a change.")
                player:SendBroadcastMessage("100 gold been taken")

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
    end
end

RegisterPlayerEvent(18, SwitchGender)
