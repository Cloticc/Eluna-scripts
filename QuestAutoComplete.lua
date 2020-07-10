local MSG_QC = "#qc"

local function UpdateQuest(player)
    local query = WorldDBQuery("SELECT ID, LogTitle FROM quest_template")
    if query then
        repeat
            local row = query:GetRow()
            local row2 = query:GetRow()
            local Quest = tonumber(row["ID"])
            local LogTitle = string.format(row2["LogTitle"])
            if player:HasQuest(Quest) then
                player:CompleteQuest(Quest)
                player:SendBroadcastMessage("|cFFffffffLogTitle:|r " .. LogTitle .. " |cFFffffffID:|r " .. Quest .. "")
            end
        until not query:NextRow()
    end
end

local function QuestAutoComplete(event, player, msg, Type, lang)
    local gmRank = player:GetGMRank()
    if (gmRank >= 3) then
        local msg = msg:lower()
        if (msg == MSG_QC) then
            UpdateQuest(player)
            player:SendBroadcastMessage(" Quest Been Completed  ")
            return false
        end
    end
end

RegisterPlayerEvent(18, QuestAutoComplete)
