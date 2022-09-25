--[[
    Open with #druidmorph
    Morph to other form using #druidmorph gossip will appear however this is not  persistent

 ]]
local PLAYER_EVENT_ON_CHAT = 18
local GOSSIP_EVENT_ON_SELECT = 2

local druidMorph = {}
druidMorph.chatMsg = "#druidmorph"
druidMorph.druidMorhValid = {
    ["Menu"] = {
        {"Bear", 1},
        {"Aquatic", 2},
        {"Cat", 3},
        {"Travel", 4},
        {"Flight", 5}
    },
    [3] = {
        -- Night Elf
        [1] = {
            {"Night Elf Cat Form (Black)", 892},
            {"Night Elf Cat Form (Violet)", 29405},
            {"Night Elf Cat Form (Purple)", 29406},
            {"Night Elf Cat Form (Dark Blue)", 29407},
            {"Night Elf Cat Form (White)", 29408},
            {"White Striped Tiger", 9956},
            {"Red Tiger", 320},
            {"Black Tiger", 599}
        },
        [2] = {
            -- Tauren
            {"Tauren Cat Form (White)", 29409},
            {"Tauren Cat Form (Yellow)", 29410},
            {"Tauren Cat Form (Red)", 29411},
            {"Tauren Cat Form (Black)", 29412},
            {"Tauren Cat Form (Black)", 50214},
            {"White Striped Tiger", 9956},
            {"Red Tiger", 320},
            {"Black Tiger", 599}
        }
    },
    [4] = {}
}
--change so name is first and id is second
local MENU_ID = 100
function druidMorph.menu(event, player, object)
    local race = player:GetRace()
    local class = player:GetClass()
    player:GossipClearMenu()
    for _, menuName in ipairs(druidMorph.druidMorhValid["Menu"]) do
        player:GossipMenuAddItem(10, menuName[1] .. " Form.", 0, menuName[2])
        -- print(menuName[1], menuName[2])
    end
    player:GossipSendMenu(1, player, MENU_ID)
end
function druidMorph.selectionMorph(event, player, object, sender, intid, code, menu_id)
    if intid == 1 then
        if not player:HasAura(5487 or 9634) then
            player:SendBroadcastMessage("You are not in bear form.")
            return druidMorph.menu(event, player, object)
        end
        player:GossipClearMenu()
        -- print("Bear")
        player:GossipComplete()
    elseif intid == 2 then
        if not player:HasAura(1066) then
            player:SendBroadcastMessage("You are not in Aquatic form.")
            return druidMorph.menu(event, player, object)
        end
        player:GossipClearMenu()
        -- print("Aquatic")
        player:GossipComplete()
    elseif intid == 3 then
        -- print(" Cat")
        player:GossipClearMenu()
        if not player:HasAura(768) then
            player:SendBroadcastMessage("You are not in Cat form")
            return druidMorph.menu(event, player, object)
        end
        if (player:GetRace() == 4) then
            for _, menuName in ipairs(druidMorph.druidMorhValid[3][1]) do
                player:GossipMenuAddItem(10, menuName[1], 0, menuName[2])
            end
        elseif (player:GetRace() == 6) then
            for _, menuName in ipairs(druidMorph.druidMorhValid[3][2]) do
                player:GossipMenuAddItem(10, menuName[1], 0, menuName[2])
            end
        end

        player:GossipSendMenu(1, player, MENU_ID)
    elseif intid == 4 then
        if not player:HasAura(783) then
            player:SendBroadcastMessage("You are not in Travel form.")
            return druidMorph.menu(event, player, object)
        end
        -- print("Travel"

        player:GossipClearMenu()

        player:GossipSendMenu(1, player, MENU_ID)
    elseif intid == 5 then
        if not player:HasAura(33943) then
            player:SendBroadcastMessage("You are not in Flight form.")
            return druidMorph.menu(event, player, object)
        end
        -- print("Flight")
        player:GossipComplete()
    end

    if intid ~= 1 and intid ~= 2 and intid ~= 3 and intid ~= 4 and intid ~= 5 then
        player:GossipComplete()
        player:GossipClearMenu()
        player:SetDisplayId(intid)
    end
end
function druidMorph.callMenu(event, player, msg, lang, type)
    if (msg:find(druidMorph.chatMsg)) then
        druidMorph.menu(event, player)
        return false
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_CHAT, druidMorph.callMenu)
RegisterPlayerGossipEvent(MENU_ID, GOSSIP_EVENT_ON_SELECT, druidMorph.selectionMorph)
