-- Made by Foereaper
-- Fixed by rochet
-- edit by Clotic Updated with Ranged bows and added some other enchants

local npcid = XXX -- ID for npc

local T = {
    ["Menu"] = {
        {"Headpiece", 0},
        {"Shoulders", 2},
        {"Chest", 4},
        {"Legs", 6},
        {"Boots", 7},
        {"Bracers", 8},
        {"Gloves", 9},
        {"Cloak", 14},
        {"Main-Hand Weapons", 15},
        {"Two-Handed Weapons", 151},
        {"Off-Hand Weapons", 16},
        {"Shields", 161},
        {"Ranged", 17}

    },
    [0] = {
        -- Headpiece
        {"Arcanum of Burning Mysteries", 3820, false},
        {"Arcanum of Blissful Mending", 3819, false},
        {"Arcanum of the Stalward Protector", 3818, false},
        {"Arcanum of Torment", 3817, false},
        {"Arcanum of the Savage Gladiator", 3842, false},
        {"Arcanum of Triumph", 3795, false},
        {"Arcanum of Dominance", 3797, false}
    },
    [2] = {
        -- Shoulders
        {"Inscription of Triumph", 3793, false},
        {"Inscription of Dominance", 3794, false},
        {"Greater Inscription of the Gladiator", 3852, false},
        {"Greater Inscription of the Axe", 3808, false},
        {"Greater Inscription of the Crag", 3809, false},
        {"Greater Inscription of the Pinnacle", 3811, false},
        {"Greater Inscription of the Storm", 3810, false},
        {"Might of the Scourge", 2717, false},
        {"Power of the Scourge", 2721, false},
        {"Zandalar Signet of Might", 2606, false}
    },
    [4] = {
        -- Chest
        {"Enchant Chest - Powerful Stats", 3832, false},
        {"Enchant Chest - Super Health", 3297, false},
        {"Enchant Chest - Greater Mana Restoration", 2381, false},
        {"Enchant Chest - Exceptional Resilience", 3245, false},
        {"Enchant Chest - Greater Defense", 1953, false}
    },
    [6] = {
        -- Legs
        {"Earthen Leg Armor", 3853, false},
        {"Frosthide Leg Armor", 3822, false},
        {"Icescale Leg Armor", 3823, false},
        {"Brilliant Spellthread", 3719, false},
        {"Sapphire Spellthread", 3721, false}
    },
    [7] = {
        -- Boots
        {"Greater Assault", 1597, false},
        {"Tuskars Vitality", 3232, false},
        {"Superior Agility", 983, false},
        {"Greater Spirit", 1147, false},
        {"Greater Vitality", 3244, false},
        {"Icewalker", 3826, false},
        {"Greater Fortitude", 1075, false}
    },
    [8] = {
        -- Bracers
        {"Socket bracers test ", 3717, false},
        {"Major Stamina", 3850, false},
        {"Superior Spellpower", 2332, false},
        {"Greater Assault", 3845, false},
        {"Major Spirit", 1147, false},
        {"Expertise", 3231, false},
        {"Greater Stats", 2661, false},
        {"Exceptional Intellect", 1119, false}

    },
    [9] = {
        -- Gloves
        {"Socket gloves", 3723, false},
        {"Riding SKill Increase", 930, false},
        {"Greater Blasting", 3249, false},
        {"Armsman", 3253, false},
        {"Crusher", 1603, false},
        {"Agility", 3222, false},
        {"Precision", 3234, false},
        {"Expertise", 3231, false},
        {"Exceptional Spellpower", 3246, false}

    },
    [14] = {
        -- Cloak
        {"Shadow Armor", 3256, false},
        {"Wisdom", 3296, false},
        {"Titan Weave", 1951, false},
        {"Greater Speed", 3831, false},
        {"Mighty Armor", 3294, false},
        {"Major Agility", 1099, false},
        {"Spell Piercing", 1262, false}
    },
    [15] = {
        -- Main Hand
        {"Crusader", 1900, false},
        {"Titan Guard", 3851, false},
        {"Accuracy", 3788, false},
        {"Berserking", 3789, false},
        {"Black Magic", 3790, false},
        {"Mighty Spellpower", 3834, false},
        {"Superior Potency", 3833, false},
        {"Ice Breaker", 3239, false},
        {"Lifeward", 3241, false},
        {"Blood Draining", 3870, false},
        {"Blade Ward", 3869, false},
        {"Exceptional Agility", 1103, false},
        {"Exceptional Spirit", 3844, false},
        {"Executioner", 3225, false},
        {"Mongoose", 2673, false},
        -- Two-Handed
        {"Massacre", 3827, true},
        {"Scourgebane", 3247, true},
        {"Giant Slayer", 3251, true},
        {"Greater Spellpower", 3854, true}

    },
    [16] = {
        -- Offhand
        {"Titan Guard", 3851, false},
        {"Accuracy", 3788, false},
        {"Berserking", 3789, false},
        {"Black Magic", 3790, false},
        {"Mighty Spellpower", 3834, false},
        {"Superior Potency", 3833, false},
        {"Ice Breaker", 3239, false},
        {"Lifeward", 3241, false},
        {"Blood Draining", 3870, false},
        {"Blade Ward", 3869, false},
        {"Exceptional Agility", 1103, false},
        {"Exceptional Spirit", 3844, false},
        {"Executioner", 3225, false},
        {"Mongoose", 2673, false},
        -- Shields
        {"Defense", 1952, true},
        {"Greater Intellect", 1128, true},
        {"Shield Block", 2655, true},
        {"Resilience", 3229, true},
        {"Major Stamina", 1071, true},
        {"Tough Shield", 2653, true},

    },
    [17] = {
		--Ranged
        {"Diamond-cut Refractor Scope", 3843, false},
        {"Sun Scope", 3607, false},
        {"Heartseeker Scope", 3608, false}
        -- {"Khorium Scope", 2723, false}

    }
}
local pVar = {}

function Enchanter(event, player, unit)
    pVar[player:GetName()] = nil

    for _, v in ipairs(T["Menu"]) do
        player:GossipMenuAddItem(3, "|cFFffffff " .. v[1] .. ".|R", 0, v[2])
    end
    player:GossipSendMenu(1, unit)
end

function EnchanterSelect(event, player, unit, sender, intid, code)
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
                    player:GossipMenuAddItem(3, "|cFFffffff " .. v[1] .. ".|R", 0, v[2])
                end
            end
        end
        player:GossipMenuAddItem(3, "[Back]", 0, 500)
        player:GossipSendMenu(1, unit)
    elseif (intid == 500) then
        Enchanter(event, player, unit)
    elseif (intid >= 900) then
        local ID = pVar[player:GetName()]
        if (ID == 161 or ID == 151) then
            ID = math.floor(ID / 10)
        end
        for k, v in pairs(T[ID]) do
            if v[2] == intid then
                local item = player:GetEquippedItemBySlot(ID)
                if item then
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
                        item:ClearEnchantment(0, 0)
                        item:SetEnchantment(intid, 0, 0)
                        player:CastSpell(player, 36937)
                    end
                else
                    player:SendAreaTriggerMessage("You have no item to enchant in the selected slot!")
                end
            end
        end
        EnchanterSelect(event, player, unit, sender, pVar[player:GetName()], nil)
    end
end

RegisterCreatureGossipEvent(npcid, 1, Enchanter)
RegisterCreatureGossipEvent(npcid, 2, EnchanterSelect)
