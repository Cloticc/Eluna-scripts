local NpcId = nil -- NPC ID The ID for the npc that will show you the menu

local Weapon_Master = {}

local CLASS_WARRIOR = 1
local CLASS_PALADIN = 2
local CLASS_HUNTER = 3
local CLASS_ROGUE = 4
local CLASS_PRIEST = 5
local CLASS_DEATH_KNIGHT = 6
local CLASS_SHAMAN = 7
local CLASS_MAGE = 8
local CLASS_WARLOCK = 9
local CLASS_DRUID = 11

Skills = {
    ["Menu"] = {
        {"Warrior", 1},
        {"Paladin", 2},
        {"Hunter", 3},
        {"Rogue", 4},
        {"Priest", 5},
        {"Shaman", 7},
        {"Mage", 8},
        {"Warlock", 9},
        {"Druid", 11},
        {"Death Knight", 6}
    },
    [CLASS_WARRIOR] = {202,199,197,227,200,201,198,196,266,15590,1180,5011,264},
    [CLASS_PALADIN] = {202, 199,197,200,201,198,196},
    [CLASS_HUNTER] = {202,197,227,200,201,196,266,15590,1180,5011,264},
    [CLASS_ROGUE] = {201,198,196,266,15590,1180,5011,264},
    [CLASS_PRIEST] = {227,198,1180},
    [CLASS_SHAMAN] = {199,197,227,198,196,15590,1180},
    [CLASS_MAGE] = {227,201,1180},
    [CLASS_WARLOCK] = {227,201,1180},
    [CLASS_DRUID] = {199,227,200,198,15590,1180},
    [CLASS_DEATH_KNIGHT] = {202,199,197,200,201,198,196}
}
function Weapon_Master.Hello(event, player, object)
    for _, v in ipairs(Skills["Menu"]) do
        player:GossipMenuAddItem(3, " " .. v[1] .. ".|R", 0, v[2])
    end

    player:GossipSendMenu(1, object)
end

function Weapon_Master.Select(event, player, object, sender, intid, code, menu_id)
    local playerclass = player:GetClass()
    if (intid == playerclass) then
        for k, v in pairs(Skills) do
            if (k == playerclass) then
                for _, v in ipairs(v) do
                    if player:HasSpell(v) == false then
                        player:LearnSpell(v)
                    end

                end
            end
        end
        object:SendChatMessageToPlayer(8, 0, "You have learned all your weapon skills!", player)
        player:GossipComplete()
    else
        object:SendChatMessageToPlayer(8, 0, "Wrong Class " .. player:GetName(), player)

        Weapon_Master.Hello(event, player, object)
    end
end

RegisterCreatureGossipEvent(NpcId, 1, Weapon_Master.Hello)
RegisterCreatureGossipEvent(NpcId, 2, Weapon_Master.Select)
