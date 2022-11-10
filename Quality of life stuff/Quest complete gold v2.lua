--[[


Added status to check if COMPLETE or INCOMPLETE should not take gold if already completed
Aswell as added LogTitle and ID to the broadcast message


 ]]

local MSGQC = "#qc" -- Command
local rankCommand = 3 -- GM Rank
local takeMoney = 0.025 -- Set the amount of gold you want to take from the player (0.025 = 2.5%)
local Quest = {}

local QUEST_STATUS_COMPLETE = 1
local QUEST_STATUS_INCOMPLETE = 3

function Quest.Update(player)
    local query = CharDBQuery("SELECT  name, Money FROM characters")
    if query then
        repeat
            local row = query:GetRow()

            local CurrentName = (row["name"]) -- Get the name of the player
            local Gold = tonumber(row["Money"]) -- Get the amount of gold of the player
            local Gold_new = math.floor(Gold * takeMoney) -- Calculate the amount of gold to take
            if (CurrentName == player:GetName()) then
                player:SaveToDB()

                local query1 = WorldDBQuery(
                    "SELECT ID, LogTitle FROM quest_template")
                if query1 then
                    repeat
                        local Entry = query1:GetRow() -- Get the row
                        local QuestTitle = query1:GetRow() -- Get the name of the player
                        local QuestID = tonumber(Entry["ID"]) -- Get the ID of the quest
                        local LogTitle = string.format(QuestTitle["LogTitle"])
                        -- check if already completed if so skip it
                        local isCompleted = player:GetQuestStatus(QuestID)
                        if isCompleted == QUEST_STATUS_COMPLETE then
                            player:SendBroadcastMessage(
                                "|cFFffffff|cFF00ff00The World |r|cFFffffff already completed |cFFffffff|cFF00ff00" ..
                                LogTitle .. "|r|cFFffffff for you")

                        end

                        if isCompleted == QUEST_STATUS_INCOMPLETE then

                            if player:HasQuest(QuestID) then
                                player:CompleteQuest(QuestID)

                                player:SendBroadcastMessage(
                                    "|cFFffffff|cFF00ff00Quest: |r|cFFffffff" ..
                                    LogTitle ..
                                    "|cFFffffff|cFF00ff00 ID:|r |cFFffffff" ..
                                    QuestID ..
                                    "|cFFffffff|cFFffffff completed for you")
                                player:ModifyMoney(-Gold_new)
                                player:SendBroadcastMessage(
                                    "|cFFffffff|cFF00ff00The World |r|cFFffffff has taken |cFFffffff|cFF00ff00" ..
                                    takeMoney ..
                                    "%|r|cFFffffff of the |cFF00ff00" ..
                                    Gold_new .. "|r|cFFffffff coins")

                            end

                        end
                    until not query1:NextRow()
                end
            end
        until not query:NextRow()
    end
end

function Quest.Complete(_, player, msg, _, _)
    if msg:find(MSGQC) then
        local gmRank = player:GetGMRank()
        if (gmRank < rankCommand) then
            player:SendBroadcastMessage(
                "|cFFffffff|cFF00ff00The World |r|cFFffffff Don't have access. |cFF00ff00")
            return
        end

        Quest.Update(player)
        return false
    end
end

RegisterPlayerEvent(18, Quest.Complete)
