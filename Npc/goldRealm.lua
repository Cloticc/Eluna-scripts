local npcEntry = 123

local GOSSIP_EVENT_ON_HELLO = 1
local GOSSIP_EVENT_ON_SELECT = 2

local menuId = 0x7FFFFFFF


local function getGoldInCirculation(player)
    --get the gold in circulation from db and return it as a number
    local goldInCirculation = 0
    local goldInCirculationString = ""
    -- local query = CharDBQuery("SELECT guid, name, money FROM characters WHERE account = " ..
    -- player:GetAccountId() .. " ORDER BY money DESC LIMIT 10;")

    local query = CharDBQuery("SELECT guid, name, money FROM characters ORDER BY money DESC LIMIT 10;") --gets top 10 players with the most gold
    if query then
        repeat
            local guid = query:GetUInt32(0)
            local name = query:GetString(1)
            local money = query:GetUInt32(2)
            goldInCirculation = goldInCirculation + money
            goldInCirculationString = goldInCirculationString .. name .. " " .. money .. " "
        until not query:NextRow()
    end

    goldInCirculation = goldInCirculation / 10000 --convert to gold
    return goldInCirculation, goldInCirculationString
end

local function onHelloVendor(event, player, object)
    player:GossipSetText("Welcome to VileBranch. Here you can see how much gold is in circulation on your server.")
    --get top 10 players with the most gold
    local goldInCirculation, goldInCirculationString = getGoldInCirculation(player)
    player:GossipMenuAddItem(0, "Gold in circulation: " .. goldInCirculation, menuId, 0)
    --put each name and gold amount on a new line

    for name, gold in string.gmatch(goldInCirculationString, "([^%s]+) ([^%s]+)") do
        player:GossipMenuAddItem(4, name .. " " .. gold / 10000 .. "g", menuId, 0)
    end
    --if intract with npc refresh the gossip menu so it shows the updated gold in circulation





    player:GossipMenuAddItem(0, "Update (takes few sec to refresh) ", 0, 1)
    player:GossipMenuAddItem(0, "Close ", 0, 999)
    -- player:GossipSendMenu(menuId, object)
    player:GossipSendMenu(1, object, menuId)
end

local function onVendorSelection(event, player, object, sender, intid, code)
    if (intid == 1) then
        player:SaveToDB()
        -- player:GossipComplete()
        onHelloVendor(event, player, object)
    elseif (intid == 999) then
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(npcEntry, GOSSIP_EVENT_ON_HELLO, onHelloVendor)
RegisterCreatureGossipEvent(npcEntry, GOSSIP_EVENT_ON_SELECT, onVendorSelection)
