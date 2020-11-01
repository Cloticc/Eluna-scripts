local MSG_ADV = "#adv"

function AdvanceSkillsToMax(event, player, msg, type, language)

    gmRank = player:GetGMRank()
    if (gmRank >= 3) then -- change number (0-3) 0 - to all  1,2,3 GM with rank

            if (msg:find(MSG_ADV)) then
            player:AdvanceAllSkills(999)
            player:AdvanceSkillsToMax()
            player:SendBroadcastMessage("You skills been maxed")
            return false
        end
    end
end


RegisterPlayerEvent(18, AdvanceSkillsToMax)