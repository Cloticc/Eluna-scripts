--[[ This will just lock the character and not delete it. ]]
local Perma_Death = {}

function Perma_Death.Died(event, killer, killed)
    if (killed:GetGMRank() >= 1) then
        return
    end
    local guid = killed:GetGUIDLow()
    CharDBExecute(
        "INSERT INTO character_banned (guid,bannedby,banreason, active) VALUES (" ..
            guid .. ",'PermaDeath', 'Death', 1)"
    )

    killed:SaveToDB()
    SendWorldMessage(
        "|cFFffffffPlayer |cFF00ff00" ..
            killed:GetName() .. "|r |cFFffffffwas killed by|cFF00ff00 " .. killer:GetName() .. "|r"
    )

    local players = GetPlayersInWorld()
    for i = 1, #players do
        players[i]:SendAreaTriggerMessage(
            "|cFFffffffPlayer |cFF00ff00" ..
                killed:GetName() .. "|r |cFFffffffwas killed by|cFF00ff00 " .. killer:GetName() .. "|r"
        )
    end
    killed:KickPlayer()
end

RegisterPlayerEvent(6, Perma_Death.Died)
RegisterPlayerEvent(8, Perma_Death.Died)
