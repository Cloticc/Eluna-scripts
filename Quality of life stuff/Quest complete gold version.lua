local MSG_QC = "#qc" -- Command
local Rank_command = 2 -- GM Rank
local Money_take = 0.025 -- Set the amount of gold you want to take from the player (0.025 = 2.5%)
local Quest = {}

function Quest.Update(player)

    local query = CharDBQuery("SELECT  name, Money FROM characters")
    if query then
        repeat
            local row = query:GetRow()

            local CurrentName = (row["name"])
            local Gold = tonumber(row["Money"])
            local Gold_new = math.floor(Gold * Money_take)
            if (CurrentName == player:GetName()) then
                local gmRank = player:GetGMRank()
                if (gmRank <= Rank_command) then
                    player:SaveToDB()
                    player:SendBroadcastMessage(
                        "|cFFffffff|cFF00ff00The World |r|cFFffffff Require more coin. |cFF00ff00")

                else
                    player:SaveToDB()
                    player:ModifyMoney(-Gold_new)
                    player:SendBroadcastMessage(
                        "|cFFffffff|cFF00ff00The World |r|cFFffffff has taken |cFFffffff|cFF00ff00" ..
                            Money_take .. "%|r|cFFffffff of the |cFF00ff00" ..
                            Gold_new .. "|r|cFFffffff coins")

                    player:SaveToDB()
                    local query1 = WorldDBQuery(
                                       "SELECT ID, LogTitle FROM quest_template")
                    if query1 then
                        repeat

                            local row = query1:GetRow()
                            local row2 = query1:GetRow()
                            local Quest = tonumber(row["ID"])
                            local LogTitle = string.format(row2["LogTitle"])
                            if player:HasQuest(Quest) then
                                player:CompleteQuest(Quest)
                                player:SendBroadcastMessage(
                                    "|cFFffffffLogTitle:|r " .. LogTitle ..
                                        " |cFFffffffID:|r " .. Quest .. "")
                            end
                        until not query1:NextRow()

                    end
                end
            end
        until not query:NextRow()

    end

end

function Quest.Complete(_, player, msg, _, _)
    if msg:find(MSG_QC) then
        Quest.Update(player)
        return false
    end

end

RegisterPlayerEvent(18, Quest.Complete)
