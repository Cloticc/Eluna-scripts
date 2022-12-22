--[[ Refactor the script 2022-12-22 ]]

local MSGQC = "#qc" -- Command
local RANK_REQUIRED = 3 -- GM Rank
local GOLD_DEDUCTION_PERCENTAGE = 0.025 -- Set the amount of gold you want to take from the player (0.025 = 2.5%)

local QUEST_STATUS_COMPLETE = 1 -- 1 = complete
local QUEST_STATUS_INCOMPLETE = 3 -- 3 = incomplete

local PLAYER_EVENT_ON_CHAT = 18 -- (event, player, msg, Type, lang) - Can return false, newMessage

local function completeQuestsForPlayer(player)
    local playerName = player:GetName()
    local playerGold = player:GetCoinage()
    local goldToDeduct = math.floor(playerGold * GOLD_DEDUCTION_PERCENTAGE)

    local incompleteQuests = {}

    -- Find all incomplete quests for the player
    local questQuery =
    WorldDBQuery(
        "SELECT ID, LogTitle FROM  world.quest_template WHERE ID IN (SELECT quest FROM characters.character_queststatus WHERE guid = "
        ..
        player:GetGUIDLow() .. " AND status = " .. QUEST_STATUS_INCOMPLETE .. ")"
    )
    if questQuery then
        repeat
            local questRow = questQuery:GetRow()
            local questId = tonumber(questRow["ID"])
            local questTitle = questRow["LogTitle"]

            table.insert(incompleteQuests, { id = questId, title = questTitle })
        until not questQuery:NextRow()
    end

    if #incompleteQuests == 0 then
        player:SendBroadcastMessage(
            "|cFFffffff|cFF00ff00The World |r|cFFffffff You have no incomplete quests. |cFF00ff00"
        )
        return
    end

    -- Complete quests and deduce gold for each incomplete quest
    for _, quest in pairs(incompleteQuests) do
        player:CompleteQuest(quest.id)
        player:ModifyMoney(-goldToDeduct)

        player:SendBroadcastMessage(
            string.format(
                "|cFFffffff|cFF00ff00Quest: |r|cFFffffff%s|cFFffffff|cFF00ff00 ID:|r |cFFffffff%d|cFFffffff|cFFffffff completed for you"
                ,
                quest.title,
                quest.id
            )
        )
        player:SendBroadcastMessage(
            string.format(
                "|cFFffffff|cFF00ff00The World |r|cFFffffff has taken |cFFffffff|cFF00ff00%.2f%%|r|cFFffffff of the |cFF00ff00%d|r|cFFffffff gold you had"
                ,
                GOLD_DEDUCTION_PERCENTAGE * 100,
                goldToDeduct
            )
        )
    end
end

local function onChatMessage(event, player, message, _, _)
    if message:find(MSGQC) then
        -- Check if the player has the required GM rank
        if player:GetGMRank() < RANK_REQUIRED then
            player:SendBroadcastMessage("|cFFffffff|cFF00ff00The World |r|cFFffffff Don't have access. |cFF00ff00")
            return
        end
        player:SaveToDB()
        completeQuestsForPlayer(player)
        return false
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_CHAT, onChatMessage)
