local NPC_ID = nil --Change this to your npc

local Level = 60 -- Level of the player when they use npc.

local HUMAN = 1
local ORC = 2
local DWARF = 3
local NIGHT_ELF = 4
local UNDREAD = 5
local TAUREN = 6
local GNOME = 7
local TROLL = 8
local BLOOD_ELF = 10
local DRAENEI = 11

local Teleport_Alliance = {
    0, --Map
    -8865.8984375, --X
    670.66961669922, --Y
    97.903465270996, --Z
    5.3065047264099  --o
}
local Teleport_Hord = {
    1,--Map
    1633.3148193359, --X
    -4441.4111328125, --Y
    15.634137153625, --Z
    2.4645304679871 --O
}

function On_Gossip_Hello(event, player, object)
    if (player:IsInCombat() == false) then
        player:GossipClearMenu()
        questRewardStatus = player:GetQuestRewardStatus(13188)
        if ((player:GetClass() == 6) and (questRewardStatus == false)) then
            player:GossipMenuAddItem(
                0,
                "Complete all Dk quests, afther that please use the teleporter and go to the starting zone, enjoy!",
                1,
                10
            )
        end
        player:GossipSendMenu(NPC_ID, object, 1000001)
    end
end

function On_Gossip_Select(event, player, object, sender, intid, code, menuid)
    if (intid == 10) then
        quests = {
            12593,
            12619,
            12842,
            12848,
            12636,
            12641,
            12657,
            12850,
            12670,
            12678,
            12680,
            12687,
            12679,
            12733,
            12711,
            12697,
            12698,
            12700,
            12701,
            12706,
            12714,
            12849,
            12715,
            12716,
            12717,
            12718,
            12719,
            12722,
            12720,
            12723,
            12724,
            12725,
            12727,
            12738,
            12751,
            12754,
            12755,
            12756,
            12757,
            12778,
            12779,
            12800,
            12801,
            13165,
            13166
        }
        for i, quest in ipairs(quests) do
            questRewardStatus = player:GetQuestRewardStatus(quest)
            if (questRewardStatus == false) then
                player:AddQuest(quest)
                player:CompleteQuest(quest)
                player:RewardQuest(quest)
            end
        end
        teamId = player:GetTeam()
        if (teamId == 0) then
            questRewardStatus = player:GetQuestRewardStatus(13188)
            if (questRewardStatus == false) then
                if (player:GetRace() == HUMAN) then
                    player:AddQuest(12742)
                    player:CompleteQuest(12742)
                    player:RewardQuest(12742)
                end
                if (player:GetRace() == NIGHT_ELF) then
                    player:AddQuest(12743)
                    player:CompleteQuest(12743)
                    player:RewardQuest(12743)
                end
                if (player:GetRace() == DRAENEI) then
                    player:AddQuest(12746)
                    player:CompleteQuest(12746)
                    player:RewardQuest(12746)
                end
                if (player:GetRace() == DWARF) then
                    player:AddQuest(12744)
                    player:CompleteQuest(12744)
                    player:RewardQuest(12744)
                end
                if (player:GetRace() == GNOME) then
                    player:AddQuest(12745)
                    player:CompleteQuest(12745)
                    player:RewardQuest(12745)
                end
                player:AddQuest(13188)
                player:CompleteQuest(13188)
                player:RewardQuest(13188)
                player:SetLevel(Level)
                -- player teleport Alliance
                player:Teleport(table.unpack(Teleport_Alliance))
            end
        end
        if (teamId == 1) then
            questRewardStatus = player:GetQuestRewardStatus(13189)
            if (questRewardStatus == false) then
                if (player:GetRace() == BLOOD_ELF) then
                    player:AddQuest(12747)
                    player:CompleteQuest(12747)
                    player:RewardQuest(12747)
                end
                if (player:GetRace() == ORC) then
                    player:AddQuest(12748)
                    player:CompleteQuest(12748)
                    player:RewardQuest(12748)
                end
                if (player:GetRace() == TAUREN) then
                    player:AddQuest(12739)
                    player:CompleteQuest(12739)
                    player:RewardQuest(12739)
                end
                if (player:GetRace() == UNDREAD) then
                    player:AddQuest(12750)
                    player:CompleteQuest(12750)
                    player:RewardQuest(12750)
                end
                if (player:GetRace() == TROLL) then
                    player:AddQuest(12749)
                    player:CompleteQuest(12749)
                    player:RewardQuest(12749)
                end
                player:AddQuest(13189)
                player:CompleteQuest(13189)
                player:RewardQuest(13189)
                player:SetLevel(Level)
                player:Teleport(table.unpack(Teleport_Hord)) -- map , x , y , z ,o
            end
        end
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(NPC_ID, 1, On_Gossip_Hello)
RegisterCreatureGossipEvent(NPC_ID, 2, On_Gossip_Select)
