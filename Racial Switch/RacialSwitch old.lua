local npcid = x -- npc id
local cost = 0 --price is coppar


local SPELL_SHADOWMELD = 20580
local SPELL_STEALTH = 1784

local Racial = {
    [1] = {20598, 20597, 58985, 20864, 59752, 20599}, -- Human
    [2] = {65222, 20572, 20574}, -- Orc
    [3] = {2481, 20596, 59224, 20594}, -- Dwarf
    [4] = {21009, 20583, 20582, 58984, 20585}, -- Night Elf
    [5] = {20577, 20579, 5227, 7744}, -- Undread
    [6] = {20552, 20550, 20551, 20549}, -- Tauren
    [7] = {20592, 20593, 20589, 20591}, -- Gnome
    [8] = {20557, 26297, 26290, 58943, 20555, 20558}, -- Troll
    [10] = {28877, 822}, -- Blood Elf
    [11] = {59542, 28875, 6562, 59221} -- Draenei}
}

local function OnHelloRacialSwitch(event, player, creature)
    if
        not player:IsInCombat() and not player:HasAura(SPELL_SHADOWMELD) and not player:HasAura(SPELL_STEALTH) and
            not player:InBattleground()
     then
        player:GossipMenuAddItem(3, "Human", 0, 1, nil, "Are you sure?", cost)
        player:GossipMenuAddItem(3, "Orc", 0, 2, nil, "Are you sure?", cost)
        player:GossipMenuAddItem(3, "Dwarf", 0, 3, nil, "Are you sure?", cost)
        player:GossipMenuAddItem(3, "Night Elf", 0, 4, nil, "Are you sure?", cost)
        player:GossipMenuAddItem(3, "Undead", 0, 5, nil, "Are you sure?", cost)
        player:GossipMenuAddItem(3, "Tauren", 0, 6, nil, "Are you sure?", cost)
        player:GossipMenuAddItem(3, "Gnome", 0, 7, nil, "Are you sure?", cost)
        player:GossipMenuAddItem(3, "Troll", 0, 8, nil, "Are you sure?", cost)
        player:GossipMenuAddItem(3, "Blood Elf", 0, 10, nil, "Are you sure?", cost)
        player:GossipMenuAddItem(3, "Draenei", 0, 11, nil, "Are you sure?", cost)
        player:GossipMenuAddItem(0, "Nevermind", 0, 999)
        player:GossipSendMenu(1, creature)
    else
        player:SendBroadcastMessage("You are in Combat!")
    end
end

local Unlearn = {
    20598,
    20597,
    58985,
    20864,
    59752,
    20599,
    33702,
    20573,
    65222,
    20572,
    20574,
    2481,
    20596,
    59224,
    20594,
    21009,
    20583,
    20582,
    58984,
    20585,
    20577,
    20579,
    5227,
    7744,
    20552,
    20550,
    20551,
    20549,
    20592,
    20593,
    20589,
    20591,
    20557,
    26297,
    26290,
    58943,
    20555,
    20558,
    28877,
    822,
    25046,
    28730,
    50613,
    59542,
    28875,
    6562,
    59221
}
local function OnGossipRacialSwitch(event, player, creature, sender, intid, code, menu_id)
    if (intid == 1) then
        if not player:HasSpell(59752) then
            for _, v in ipairs(Unlearn) do
                player:RemoveSpell(v)
            end
            for _, v in ipairs(Racial[1]) do
                player:LearnSpell(v)
            end
        else
            player:SendBroadcastMessage("|cFFFFFF9F" .. creature:GetName() .. " Says: You Got The Human Traits Already")
        end
        player:GossipComplete()
    end

    if (intid == 2) then
        if not player:HasSpell(33702) then
            for _, v in ipairs(Unlearn) do
                player:RemoveSpell(v)
            end
            if player:GetPower(1 or 2 or 6) then
                player:LearnSpell(20572)
            elseif player:GetPower(0) then
                player:LearnSpell(33702)
            end
            for _, v in ipairs(Racial[2]) do
                player:LearnSpell(v)
            end
        else
            player:SendBroadcastMessage("|cFFFFFF9F" .. creature:GetName() .. " Says: You Got The Orc Traits Already")
        end
        player:GossipComplete()
    end

    if (intid == 3) then
        if not player:HasSpell(2481) then
            for _, v in ipairs(Unlearn) do
                player:RemoveSpell(v)
            end
            for k, v in ipairs(Racial[3]) do
                player:LearnSpell(v)
            end
        else
            player:SendBroadcastMessage("|cFFFFFF9F" .. creature:GetName() .. " Says: You Got the Dwarf Traits Already")
        end
        player:GossipComplete()
    end

    if (intid == 4) then
        if not player:HasSpell(21009) then
            for _, v in ipairs(Unlearn) do
                player:RemoveSpell(v)
            end
            for k, v in pairs(Racial[4]) do
                player:LearnSpell(v)
            end
        else
            player:SendBroadcastMessage(
                "|cFFFFFF9F" .. creature:GetName() .. " Says: You Got the Night Elf Traits Already"
            )
        end
        player:GossipComplete()
    end
    if (intid == 5) then
        if not player:HasSpell(20577) then
            for _, v in ipairs(Unlearn) do
                player:RemoveSpell(v)
            end
            for k, v in pairs(Racial[5]) do
                player:LearnSpell(v)
            end
        else
            player:SendBroadcastMessage(
                "|cFFFFFF9F" .. creature:GetName() .. " Says: You Got the Undead Traits Already"
            )
        end
        player:GossipComplete()
    end
    if (intid == 6) then
        if not player:HasSpell(20552) then
            for _, v in ipairs(Unlearn) do
                player:RemoveSpell(v)
            end
            for k, v in pairs(Racial[6]) do
                player:LearnSpell(v)
            end
        else
            player:SendBroadcastMessage(
                "|cFFFFFF9F" .. creature:GetName() .. " Says: You Got the Tauren Traits Already"
            )
        end
        player:GossipComplete()
    end
    if (intid == 7) then
        if not player:HasSpell(20592) then
            for _, v in ipairs(Unlearn) do
                player:RemoveSpell(v)
            end
            for k, v in pairs(Racial[7]) do
                player:LearnSpell(v)
            end
        else
            player:SendBroadcastMessage("|cFFFFFF9F" .. creature:GetName() .. " Says: You Got the Gnome Traits Already")
        end
        player:GossipComplete()
    end
    if (intid == 8) then
        if not player:HasSpell(20557) then
            for _, v in ipairs(Unlearn) do
                player:RemoveSpell(v)
            end
            for k, v in pairs(Racial[8]) do
                player:LearnSpell(v)
            end
        else
            player:SendBroadcastMessage("|cFFFFFF9F" .. creature:GetName() .. " Says: You Got the Troll Traits Already")
        end
        player:GossipComplete()
    end
    if (intid == 10) then
        if not player:HasSpell(28877) then
            for _, v in ipairs(Unlearn) do
                player:RemoveSpell(v)
            end
            if player:GetPower(0) then
                player:LearnSpell(28730)
            elseif player:GetPower(2) then
                player:LearnSpell(25046)
            elseif player:GetPower(6) then
                player:LearnSpell(50613)
            end
            for k, v in pairs(Racial[10]) do
                player:LearnSpell(v)
            end
        else
            player:SendBroadcastMessage(
                "|cFFFFFF9F" .. creature:GetName() .. " Says: You Got the Blood Elf Traits Already"
            )
        end

        player:GossipComplete()
    end
    if (intid == 11) then
        if not player:HasSpell(59542) then
            for _, v in ipairs(Unlearn) do
                player:RemoveSpell(v)
            end
            for k, v in pairs(Racial[11]) do
                player:LearnSpell(v)
            end
        else
            player:SendBroadcastMessage(
                "|cFFFFFF9F" .. creature:GetName() .. " Says: You Got the Draenei Traits Already"
            )
        end
        player:GossipComplete()
    end

    if (intid == 999) then
        player:GossipComplete()
    end

    return false
end

RegisterCreatureGossipEvent(npcid, 1, OnHelloRacialSwitch)
RegisterCreatureGossipEvent(npcid, 2, OnGossipRacialSwitch)
