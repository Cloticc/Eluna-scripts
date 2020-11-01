local npcid = XXX -- npc ID

local cost = 0 --   its in coppar so if u want 100 gold you do 100000


-- This is the traits / Racials
local T = {
    [0] = {
        "UNLEARN ONLY",
        false,
        {
            33697,
            54562,
            21563,
            20576,
            33702,
            65222,
            20572,
            59545,
            59539,
            28880,
            59543,
            59544,
            59547,
            59548,
            28878,
            59535,
            59536,
            59538,
            59540,
            59541,
            50613,
            25046,
            28730
        }
    }, -- Special cases that are not part of native class spells?
    [1] = {"Human", true, {20598, 20597, 58985, 20864, 59752, 20599}}, -- Human
    [2] = {"Orc", true, {20575, 20574, 20573}, {[0] = 33697, [1] = 20572, [3] = 20572, [5] = 20572}}, -- Orc
    [3] = {"Dwarf", true, {2481, 20596, 59224, 20594}}, -- Dwarf
    [4] = {"Night Elf", true, {21009, 20583, 20582, 58984, 20585}}, -- Night Elf
    [5] = {"Undread", true, {20577, 20579, 5227, 7744}}, -- Undread
    [6] = {"Tauren", true, {20552, 20550, 20551, 20549}}, -- Tauren
    [7] = {"Gnome", true, {20592, 20593, 20589, 20591}}, -- Gnome
    [8] = {"Troll", true, {20557, 26297, 26290, 58943, 20555, 20558}}, -- Troll
    [9] = {"Blood Elf", true, {28877, 822}, {[0] = 28730, [3] = 25046, [6] = 50613}}, -- Blood Elf
    [10] = {"Draenei", true, {59542, 28875, 6562, 59221}} -- Draenei
}

local function OnHelloRacialSwitch(event, player, creature)
    if player:IsInCombat() then
        player:SendBroadcastMessage("You are in combat!")
        player:GossipComplete()
        return
    end

    for i, v in ipairs(T) do
        -- If the race is enabled (t[i][2] == true) then list the option in the menu
        if (v[2]) then
            player:GossipMenuAddItem(3, v[1], 0, i, nil, nil, cost)
        end
    end
    player:GossipSendMenu(8238, creature)
end

local function OnGossipRacialSwitch(event, player, creature, sender, intid, code, menu_id)
    --[[     if (intid == 2 and player:GetClass() == 2) then
        player:SendBroadcastMessage(
            "|cFFFFFF9F" .. creature:GetName() .. " says: This Racial not available for you try another."
        )
    else ]]
    -- Assume the player always selects a new race, thus remove all traits and racials
    -- Could also check whether the player actually has the spell before removing, but who cares
    for _, raceTable in pairs(T) do
        for _, unlearnSpellId in pairs(raceTable[3]) do
            player:RemoveSpell(unlearnSpellId)
        end
    end

    -- Teach the player all the spells associated with the new race of their choice
    -- Again, could check whether the player has the spell already, or whether they are already that race, but again, who cares

    for _, learnSpellId in pairs(T[intid][3]) do
        player:LearnSpell(learnSpellId)
    end

    -- Special handling for belfs
    if (intid == 9) then
        for powerType, belfSpellId in pairs(T[intid][4]) do
            if (player:GetPowerType() == powerType) then
                player:LearnSpell(belfSpellId)
            end
        end
    end
    -- end


    -- had to do this to make racial of the orc work correctly for each class special case for hunters
    if (intid == 2) then
        if (player:GetClass() == 3) then
            player:LearnSpell(20572)
        else
            for powerType, orcSpellId in pairs(T[intid][4]) do
                -- print(powerType, orcSpellId)

                if (player:GetPowerType() == powerType) then
                    player:LearnSpell(orcSpellId)
                end
            end
        end
    end
    -- creature:SendUnitSay("|cFFFFFF9F" .. creature:GetName() .. " says: You learn " .. tostring(T[intid][1]) .. " Racial.", 0)
    player:SendBroadcastMessage(
        "|cFFFFFF9F" .. creature:GetName() .. " says: You learn " .. tostring(T[intid][1]) .. " Racial."
    ) -- wil say that u learn x racial
    player:GossipComplete()
end

RegisterCreatureGossipEvent(npcid, 1, OnHelloRacialSwitch)
RegisterCreatureGossipEvent(npcid, 2, OnGossipRacialSwitch)