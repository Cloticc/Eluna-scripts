--[[ Will Massinvite Anyone in the world ]]

MSG_Invite = "#MassInv"
local function MassGuildInvite(event, player, msg, Type, lang)
    if (msg:find(MSG_Invite)) then
        for k, v in pairs(GetPlayersInWorld()) do
            if v:GetName() then
                if (v:IsInGuild() == true) and (v:GetGuildId() ~= player:GetGuildId()) then
                    player:SendBroadcastMessage(v:GetName() .. " is already in a guild! ")
                elseif (v:IsInGuild() == true) and (v:GetGuildId() == player:GetGuildId()) then
                    player:SendBroadcastMessage(v:GetName() .. " is already in your guild! ")
                elseif (v:IsInGuild() == false) and v:GetName() then
                    player:SendBroadcastMessage(v:GetName() .. " Has been invited to guild! ")
                    player:SendGuildInvite(v)
                end
            end
        end
    end
end


RegisterPlayerEvent(18, MassGuildInvite)