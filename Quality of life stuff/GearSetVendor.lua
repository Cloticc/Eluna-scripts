--[[ To get this to work u need to have a npc and get the entry and put it on Pre_Build.Npc_Id=123.
Change the ids in the Gear list to whatever u want it to be u can give more items or less. The ids that are in the gear list now are t3 and some other random ids. ]]

local Pre_Build = {}

Pre_Build.Npc_Id = nil --npc id of the vendor/trainer

local Gear = {
    --  [intid] = {item1, item2,so on ...},
    [1] = {22418, 22419, 22416, 22423, 22421, 22422, 22417, 22420, 23059}, -- Warrior Arms
    [2] = {51227, 22419, 22416, 22423, 22421, 22422, 22417, 22420, 23059}, -- Warrior Fury
    [3] = {22418, 22419, 22416, 22423, 22421, 22422, 22417, 22420, 23059}, -- Warrior Prot
    [4] = {22428, 22429, 22425, 22424, 22426, 22431, 22427, 22430, 23066}, -- Paladin Holy
    [5] = {22428, 22429, 22425, 22424, 22426, 22431, 22427, 22430, 23066}, -- Paladin Protection
    [6] = {22428, 22429, 22425, 22424, 22426, 22431, 22427, 22430, 23066}, -- Paladin Retribution
    [7] = {22438, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Hunter Beast Mastery
    [8] = {22438, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Hunter Marksmanship
    [9] = {22438, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Hunter Survival
    [10] = {51252, 51254, 51251, 22443, 22441, 22442, 22437, 22440, 23067}, -- Rogue Assassination
    [11] = {22478, 22479, 22476, 22483, 22481, 22482, 22477, 22480, 23060}, -- Rogue Subtlety
    [12] = {22478, 22479, 22476, 22483, 22481, 22482, 22477, 22480, 23060}, -- Rogue Combat
    [13] = {22438, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Priest Discipline
    [14] = {22438, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Priest Holy
    [15] = {22438, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Priest Shadow
    [16] = {22438, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Death Knight Blood
    [17] = {22438, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Death Knight Frost
    [18] = {22438, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Death Knight Unholy
    [19] = {22438, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Shaman Elemental
    [20] = {22438, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Shaman Enhancement
    [21] = {22438, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Shaman Restoration
    [22] = {22438, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Mage Arcane
    [23] = {22438, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Mage Fire
    [24] = {46129, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Mage Frost
    [25] = {46129, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Warlock Affliction
    [26] = {22438, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Warlock Demonology
    [27] = {22438, 22439, 22436, 22443, 22441, 22442, 22437, 22440, 23067}, -- Warlock Destruction
    [28] = {22490, 22491, 22488, 22495, 22493, 22494, 22489, 22492, 23064}, -- Druid Balance
    [29] = {22490, 22491, 22488, 22495, 22493, 22494, 22489, 22492, 23064}, -- Druid Feral
    [30] = {22490, 22491, 22488, 22495, 22493, 22494, 22489, 22492, 23064}, -- Druid Restoration
    [31] = {22490, 22491, 22488, 22495, 22493, 22494, 22489, 22492, 23064} -- Druid Restoration
}

Pre_Build.T = {
    ["Menu"] = {
        [1] = {
            {"|TInterface/ICONS/Ability_Warrior_DefensiveStance:50|t Arms", 1},
            {"|TInterface/ICONS/spell_nature_bloodlust:50|t Fury", 2},
            {"|TInterface/ICONS/Ability_Warrior_BattleShout:50|t Protection", 3}
        },
        [2] = {
            {"|TInterface/ICONS/Spell_Holy_HolyBolt:50|t Holy", 4},
            {"|TInterface/ICONS/Spell_Holy_AuraOfLight:50|t Protection", 5},
            {"|TInterface/ICONS/Spell_Holy_SealOfMight:50|t Retribution", 6}
        },
        [3] = {
            {"|TInterface/ICONS/Ability_Hunter_BeastWithin:50|t Beast Mastery", 7},
            {"|TInterface/ICONS/Ability_Hunter_MarkedForDeath:50|t Marksmanship", 8},
            {"|TInterface/ICONS/Ability_Hunter_SurvivalInstincts:50|t Survival", 9}
        },
        [4] = {
            {"|TInterface/ICONS/Ability_Rogue_ShadowDance:50|t Assassination", 10},
            {"|TInterface/ICONS/Ability_Rogue_CombatReadiness:50|t Combat", 11},
            {"|TInterface/ICONS/Ability_Rogue_Subtlety:50|t Subtlety", 12}
        },
        [5] = {
            {"|TInterface/ICONS/Spell_Holy_PowerWordShield:50|t Discipline", 13},
            {"|TInterface/ICONS/Spell_Holy_GuardianSpirit:50|t Holy", 14},
            {"|TInterface/ICONS/Spell_Shadow_ShadowWordPain:50|t Shadow", 15}
        },
        [6] = {
            {"|TInterface/ICONS/Spell_Deathknight_BloodPresence:50|t Blood", 16},
            {"|TInterface/ICONS/Spell_Deathknight_FrostPresence:50|t Frost", 17},
            {"|TInterface/ICONS/Spell_Deathknight_UnholyPresence:50|t Unholy", 18}
        },
        [7] = {
            {"|TInterface/ICONS/Spell_Nature_Lightning:50|t Elemental", 19},
            {"|TInterface/ICONS/Spell_Nature_LightningShield:50|t Enhancement", 20},
            {"|TInterface/ICONS/Spell_Nature_MagicImmunity:50|t Restoration", 21}
        },
        [8] = {
            {"|TInterface/ICONS/Spell_Holy_MagicalSentry:50|t Arcane", 22},
            {"|TInterface/ICONS/Spell_Fire_FireBolt02:50|t Fire", 23},
            {"|TInterface/ICONS/Spell_Frost_FrostBolt02:50|t Frost", 24}
        },
        [9] = {
            {"|TInterface/ICONS/Spell_Shadow_DeathCoil:50|t Affliction", 25},
            {"|TInterface/ICONS/Spell_Shadow_DemonicEmpathy:50|t Demonology", 26},
            {"|TInterface/ICONS/Spell_Shadow_Metamorphosis:50|t Destruction", 27}
        },
        [11] = {
            {"|TInterface/ICONS/Spell_Nature_Lightning:50|t Balance", 28},
            {"|TInterface/ICONS/Ability_Druid_CatForm:50|t Feral", 29},
            {"|TInterface/ICONS/Spell_Nature_HealingTouch:50|t Restoration", 30},
            {"|TInterface/ICONS/ability_racial_bearform:50|t Guardian", 31}
        }
    }
}

function Pre_Build.Hello(event, player, object)
    local class = player:GetClass()

    if Pre_Build.T["Menu"][class] then
        for i = 1, #Pre_Build.T["Menu"][class] do
            player:GossipMenuAddItem(0, Pre_Build.T["Menu"][class][i][1], 0, Pre_Build.T["Menu"][class][i][2])

        end
    end
    player:GossipSendMenu(1, object)
end

function Pre_Build.Selection(event, player, object, sender, intid, code, menuid)
    for i = 1, #Gear do
        if i == intid then
            for j = 1, #Gear[i] do
                if j == 1 then
                    for i, v in ipairs(Gear[i]) do
                        player:AddItem(v)

                    end

                end

            end
        end
    end
    Pre_Build.Hello(event, player, object)
end

RegisterCreatureGossipEvent(Pre_Build.Npc_Id, 1, Pre_Build.Hello)
RegisterCreatureGossipEvent(Pre_Build.Npc_Id, 2, Pre_Build.Selection)
