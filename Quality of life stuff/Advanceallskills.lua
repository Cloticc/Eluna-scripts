local MSG_ADV = "#ss"

function AdvanceSkillsToMax(event, player, msg, type, language)
    
    gmRank = player:GetGMRank()
    if (gmRank >= 3) then -- change number (0-3) 0 - to all  1,2,3 GM with rank
        selectTarget = player:GetSelection()
        if (not selectTarget) then
            selectTarget = player
        end
    end
    msg = msg:lower()
    if (msg == MSG_ADV) then
        selectTarget:AdvanceAllSkills(999)
        selectTarget:AdvanceSkillsToMax()
        selectTarget:SendBroadcastMessage("You skills been maxed")
        return false
    end
    
end


RegisterPlayerEvent(18, AdvanceSkillsToMax)
