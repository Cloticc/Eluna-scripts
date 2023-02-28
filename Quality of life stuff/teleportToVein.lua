local ITEM_ID = 1179 -- Replace 12345 with the item ID you want to use
local TELEPORT_DISTANCE = 200 -- Replace 200 with the maximum distance (in yards) the player can teleport


--[[
Chance that you might be teleported to a non mining node
TODO: Fix teleport to non mining node
U can change the veins they are based on the entry ides for the veins/deposit in the gameobject_template table ]]
----------------- DO NOT EDIT BELOW THIS LINE -----------------
local ITEM_EVENT_ON_USE = 2


local veins = {
    324,
    1610,
    1667,
    1731,
    1732,
    1733,
    1734,
    2054,
    2055,
    3763,
    3764,
    19903,
    73940,
    73941,
    103711,
    103713,
    105569,
    123848,
    150080,
    150082,
    175404,
    176643,
    177388,
    179144,
    179224,
    180215,
    181109,
    181248,
    181249,
    181557,
    185557,
    191133,
    1735,
    2040,
    2047,
    2653,
    73939,
    123309,
    123310,
    150079,
    150081,
    165658,
    176645,
    181108,
    181555,
    181556,
    181569,
    181570,
    185877,
    189978,
    189979,
    189980,
    189981,
    195036,
}


local nearestNodeCache = {}

local function TeleportToNearestNode(player)
    local nearestDistance = math.huge
    local nearestNode = nil

    for i = 1, #veins do
        local nodeID = veins[i]
        local node = nearestNodeCache[nodeID]

        if not node then
            node = player:GetNearObject(TELEPORT_DISTANCE, 3, nodeID)
            nearestNodeCache[nodeID] = node
        end

        if node then
            local distance = player:GetDistance(node)
            if distance < nearestDistance and distance <= TELEPORT_DISTANCE then
                nearestDistance = distance
                nearestNode = node
            end
            nearestNodeCache = {}
        end
    end

    if nearestNode then
        player:Teleport(nearestNode:GetMapId(), nearestNode:GetX(), nearestNode:GetY(), nearestNode:GetZ() + 1,
            nearestNode:GetO())
    else
        player:SendBroadcastMessage("No mining nodes found.")
        player:AddItem(ITEM_ID, 1)
    end
end
local function OnUse(event, player, item)
    if item:GetEntry() == ITEM_ID then
        --check if player is in combat and if so, don't allow teleport
        if player:IsInCombat() then
            player:SendBroadcastMessage("You can't use this item while in combat.")
            return
        end

        TeleportToNearestNode(player)
    end
end

RegisterItemEvent(ITEM_ID, ITEM_EVENT_ON_USE, OnUse)
