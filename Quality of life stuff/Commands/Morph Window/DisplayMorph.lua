-- Open with #morph A menu that allows player to go threw morph ids and see what they look like.


local PLAYER_EVENT_ON_CHAT = 18
-- local GOSSIP_EVENT_ON_HELLO = 1
local GOSSIP_EVENT_ON_SELECT = 2
local MENU_ID = 1

local chatMsg = "#morph"
local morphMenu = {}

local function menuToggle(event, player, object)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Next", 0, 1)
    player:GossipMenuAddItem(0, "Demorph", 0, 2)
    player:GossipMenuAddItem(0, "Prev", 0, 3)
    player:GossipMenuAddItem(0, player:GetDisplayId() .. " <-Display ID Click to print to chat", 0, 4)
    player:GossipSendMenu(1, player, 1)
end

local function onSelect(event, player, object, sender, intid, code, menu_id)
    if (intid == 1) then
        if (player:GetDisplayId() == flase) then
            player:SetDisplayId(1)
        end
        player:SetDisplayId(player:GetDisplayId() + 1)

        menuToggle(event, player)
    end

    if (intid == 2) then
        player:DeMorph()
        player:GossipComplete()
    end
    if (intid == 3) then
        player:SetDisplayId(player:GetDisplayId() - 1)
        menuToggle(event, player)
    end
    if (intid == 4) then
        player:SendBroadcastMessage("Display ID: " .. player:GetDisplayId())
        menuToggle(event, player)
    end
end

local function openFrameForMorph(event, player, msg, lang, type)
    if (msg:find(chatMsg)) then
        menuToggle(event, player)
        return false
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_CHAT, openFrameForMorph)
RegisterPlayerGossipEvent(MENU_ID, GOSSIP_EVENT_ON_SELECT, onSelect)
