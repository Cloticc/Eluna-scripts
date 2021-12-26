local MSG_ADV = "#maxskill" --Change to whatever u want it to be. Recommend keeping the #infront to not mess up other commands
local advance_skills = {}

function advance_skills(event, player, msg, type, language)
    if (msg:find(MSG_ADV)) then
       local gmRank = player:GetGMRank()
        if (gmRank <= 2) then -- change number (0-3) 0 - to all  1,2,3 GM with rank
            return false
        end

        player:AdvanceAllSkills(999)
        player:SendBroadcastMessage("You skills been maxed")
        return false
    end
end

RegisterPlayerEvent(18, advance_skills)