
local npcid = XXX --npc id
local MaxRating = XXX --Raiting
local TitleReward = XXX --Title
local Items = {XXX} --Random items u want them to get

local function onGossipHello(event, player, object)
    local Q = CharDBQuery("SELECT rating FROM arena_team WHERE captainGuid='" .. player:GetGUIDLow() .. "';")
    local Rating = Q:GetUInt32(0)
    player:GossipMenuAddItem(0, "You need " .. MaxRating .. " to be eligible for rewards you got " .. Rating, 0, 1)

    if Rating >= MaxRating then
        player:GossipMenuAddItem(0, "Arena Rewards", 0, 2)
    end

    player:GossipSendMenu(1, object)
end

local function onGossipSelect(event, player, object, sender, intid, code, menu_id)
    if (intid == 2) then
        player:SetKnownTitle(TitleReward)
        for _, v in pairs(Items) do
            player:AddItem(v, 1)
        end
        player:SendBroadcastMessage("|cFFFFFF9F" .. object:GetName() .. " says: Ah you got the fame!")
    end

    player:GossipComplete()
end
RegisterCreatureGossipEvent(npcid, 1, onGossipHello)
RegisterCreatureGossipEvent(npcid, 2, onGossipSelect)