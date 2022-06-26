--[[ fixed gold cost ]] local npcid = 3460608 -- You can change this to any id as you pleased!
local price = 5 * 10000 -- 5 gold
local priceFake = 5 -- this is for a message popup so change this with the price aswell so the gold correctly shows up in the message

local T = {
    ["Menu"] = {{"Headpiece", 0}, {"Shoulders", 2}, {"Chest", 4}, {"Legs", 6}, {"Boots", 7}, {"Bracers", 8},
                {"Gloves", 9}, {"Cloak", 14}, {"Main-Hand Weapons", 15}, {"Two-Handed Weapons", 151},
                {"Off-Hand Weapons", 16}, {"Shields", 161}},
    [0] = { -- Headpiece
    {"Arcanum|r of Burning Mysteries", 3820, false}, {"Arcanum|r of Blissful Mending", 3819, false},
    {"Arcanum|r of the Stalward Protector", 3818, false}, {"Arcanum|r of Torment", 3817, false},
    {"Arcanum|r of the Savage Gladiator", 3842, false}, {"Arcanum|r of Triumph", 3795, false},
    {"Arcanum|r of Dominance", 3797, false}},
    [2] = { -- Shoulders
    {"Inscription|r of Triumph", 3793, false}, {"Inscription|r of Dominance", 3794, false},
    {"Greater Inscription|r of the Gladiator", 3852, false}, {"Greater Inscription|r of the Axe", 3808, false},
    {"Greater Inscription|r of the Crag", 3809, false}, {"Greater Inscription|r of the Pinnacle", 3811, false},
    {"Greater Inscription|r of the Storm", 3810, false}},
    [4] = { -- Chest
    {"Enchant Chest|r - Powerful Stats", 3832, false}, {"Enchant Chest|r - Super Health", 3297, false},
    {"Enchant Chest|r - Greater Mana Restoration", 2381, false},
    {"Enchant Chest|r - Exceptional Resilience", 3245, false}, {"Enchant Chest|r - Greater Defense", 1953, false}},
    [6] = { -- Legs
    {"Earthen Leg Armor", 3853, false}, {"Frosthide Leg Armor", 3822, false}, {"Icescale Leg Armor", 3823, false},
    {"Brilliant Spellthread", 3719, false}, {"Sapphire Spellthread", 3721, false}},
    [7] = { -- Boots
    {"Enchant Boots|r - Greater Assault", 1597, false}, {"Enchant Boots|r - Tuskars Vitality", 3232, false},
    {"Enchant Boots|r - Superior Agility", 983, false}, {"Enchant Boots|r - Greater Spirit", 1147, false},
    {"Enchant Boots|r - Greater Vitality", 3244, false}, {"Enchant Boots|r - Icewalker", 3826, false},
    {"Enchant Boots|r - Greater Fortitude", 1075, false}},
    [8] = { -- Bracers
    {"Enchant Bracers|r - Major Stamina", 3850, false}, {"Enchant Bracers|r - Superior Spellpower", 2332, false},
    {"Enchant Bracers|r - Greater Assault", 3845, false}, {"Enchant Bracers|r - Major Spirit", 1147, false},
    {"Enchant Bracers|r - Expertise", 3231, false}, {"Enchant Bracers|r - Greater Stats", 2661, false},
    {"Enchant Bracers|r - Exceptional Intellect", 1119, false}},
    [9] = { -- Gloves
    {"Enchant Gloves|r - Greater Blasting", 3249, false}, {"Enchant Gloves|r - Armsman", 3253, false},
    {"Enchant Gloves|r - Crusher", 1603, false}, {"Enchant Gloves|r - Agility", 3222, false},
    {"Enchant Gloves|r - Precision", 3234, false}, {"Enchant Gloves|r - Expertise", 3231, false},
    {"Enchant Gloves|r - Exceptional Spellpower", 3246, false}},
    [14] = { -- Cloak
    {"Enchant Cloak|r - Shadow Armor", 3256, false}, {"Enchant Cloak|r - Wisdom", 3296, false},
    {"Enchant Cloak|r - Titan Weave", 1951, false}, {"Enchant Cloak|r - Greater Speed", 3831, false},
    {"Enchant Cloak|r - Mighty Armor", 3294, false}, {"Enchant Cloak|r - Major Agility", 1099, false},
    {"Enchant Cloak|r - Spell Piercing", 1262, false}},
    [15] = { -- Main Hand
    {"Enchant Weapon|r - Titan Guard", 3851, false}, {"Enchant Weapon|r - Accuracy", 3788, false},
    {"Enchant Weapon|r - Berserking", 3789, false}, {"Enchant Weapon|r - Black Magic", 3790, false},
    {"Enchant Weapon|r - Mighty Spellpower", 3834, false}, {"Enchant Weapon|r - Superior Potency", 3833, false},
    {"Enchant Weapon|r - Ice Breaker", 3239, false}, {"Enchant Weapon|r - Lifeward", 3241, false},
    {"Enchant Weapon|r - Blood Draining", 3870, false}, {"Enchant Weapon|r - Blade Ward", 3869, false},
    {"Enchant Weapon|r - Exceptional Agility", 1103, false}, {"Enchant Weapon|r - Exceptional Spirit", 3844, false},
    {"Enchant Weapon|r - Executioner", 3225, false}, {"Enchant Weapon|r - Mongoose", 2673, false}, -- Two-Handed
    {"Enchant 2H Weapon|r - Massacre", 3827, true}, {"Enchant 2H Weapon|r - Scourgebane", 3247, true},
    {"Enchant 2H Weapon|r - Giant Slayer", 3251, true}, {"Enchant 2H Weapon|r - Greater Spellpower", 3854, true}},
    [16] = { -- Offhand
    {"Enchant Weapon|r - Titan Guard", 3851, false}, {"Enchant Weapon|r - Accuracy", 3788, false},
    {"Enchant Weapon|r - Berserking", 3789, false}, {"Enchant Weapon|r - Black Magic", 3790, false},
    {"Enchant Weapon|r - Mighty Spellpower", 3834, false}, {"Enchant Weapon|r - Superior Potency", 3833, false},
    {"Enchant Weapon|r - Ice Breaker", 3239, false}, {"Enchant Weapon|r - Lifeward", 3241, false},
    {"Enchant Weapon|r - Blood Draining", 3870, false}, {"Enchant Weapon|r - Blade Ward", 3869, false},
    {"Enchant Weapon|r - Exceptional Agility", 1103, false}, {"Enchant Weapon|r - Exceptional Spirit", 3844, false},
    {"Enchant Weapon|r - Executioner", 3225, false}, {"Enchant Weapon|r - Mongoose", 2673, false}, -- Shields
    {"Enchant Shield|r - Defense", 1952, true}, {"Enchant Shield|r - Greater Intellect", 1128, true},
    {"Enchant Shield|r - Shield Block", 2655, true}, {"Enchant Shield|r - Resilience", 3229, true},
    {"Enchant Shield|r - Major Stamina", 1071, true}, {"Enchant Shield|r - Tough Shield", 2653, true}}
}
local pVar = {}

function CanBuy(event, player)
    local coinage = player:GetCoinage()
    local setCoin = player:SetCoinage(coinage - price)

    if coinage < price then
        player:SendBroadcastMessage("You do not have enough money to buy this item.")

        return false
    else
        return true
    end
end

function Enchanter(event, player, object)
    pVar[player:GetName()] = nil
    for event, v in ipairs(T["Menu"]) do
        player:GossipMenuAddItem(10, "|cff182799Enchant|r " .. v[1] .. ".", 0, v[2])
    end
    player:GossipSendMenu(700000, object)
end

function EnchanterSelect(event, player, object, sender, intid, code, menu_id)
    if (intid < 500) then
        local ID = intid
        local f
        if (intid == 161 or intid == 151) then
            ID = math.floor(intid / 10)
            f = true
        end
        pVar[player:GetName()] = intid
        if (T[ID]) then
            for i, v in ipairs(T[ID]) do
                if ((not f and not v[3]) or (f and v[3])) then
                    player:GossipMenuAddItem(10, "|cff182799" .. v[1] .. ".", 0, v[2])
                end
            end
        end
        player:GossipMenuAddItem(10, "[Back]", 0, 500)
        player:GossipSendMenu(700000, object)
    elseif (intid == 500) then
        Enchanter(event, player, object)
    elseif (intid >= 900) then
        local ID = pVar[player:GetName()]
        if (ID == 161 or ID == 151) then
            ID = math.floor(ID / 10)
        end
        for k, v in pairs(T[ID]) do
            if v[2] == intid then
                local item = player:GetEquippedItemBySlot(ID)
                if item then
                    if (CanBuy(event, player)) then
                        if v[3] then
                            local WType = item:GetSubClass()
                            if pVar[player:GetName()] == 151 then
                                if (WType == 1 or WType == 5 or WType == 6 or WType == 8 or WType == 10) then
                                    item:ClearEnchantment(0, 0)
                                    item:SetEnchantment(intid, 0, 0)
                                else
                                    player:SendAreaTriggerMessage("You do not have a Two-Handed Weapon equipped!")
                                end
                            elseif pVar[player:GetName()] == 161 then
                                if (WType == 6) then
                                    item:ClearEnchantment(0, 0)
                                    item:SetEnchantment(intid, 0, 0)
                                else
                                    player:SendAreaTriggerMessage("You do not have a Shield equipped!")
                                end
                            elseif pVar[player:GetName()] == 17 then
                                if (WType == 2 or WType == 3 or Wtype == 18) then
                                    item:ClearEnchantment(0, 0)
                                    item:SetEnchantment(intid, 0, 0)
                                else
                                    player:SendAreaTriggerMessage("You do not have a Ranged equipped!")
                                end
                            end
                        else
                            item:ClearEnchantment(0)
                            item:SetEnchantment(intid, 0)
                            player:SendAreaTriggerMessage("|Cffff0000[Enchanter]|r: " .. item:GetItemLink(0) ..
                                                              " is succesfully enchanted!")
                        end
                    else
                        player:SendAreaTriggerMessage(
                            "|Cffff0000[Enchanter]|r: You do not have enough money to enchant " .. priceFake ..
                                " this item.")
                    end
                else
                    player:SendAreaTriggerMessage(
                        "|Cffff0000[Enchanter]|r: You have no item to enchant in the selected slot!")
                end
            end
        end
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(npcid, 1, Enchanter)
RegisterCreatureGossipEvent(npcid, 2, EnchanterSelect)
