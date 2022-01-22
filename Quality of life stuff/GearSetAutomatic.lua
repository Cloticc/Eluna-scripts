local Pre_Build = {}

Pre_Build.Npc_Id = nil-- npc id of the vendor/trainer


--[[ So this might be a bit painful for the first time u need to add all the gear u want urself. Where it says nil = u highlight it and write the id of the item u want to be equipped when u select the option. ]]

local Gear = {
    [1] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Warrior Arms
    [2] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Warrior Fury
    [3] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Warrior Prot
    [4] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Paladin Holy
    [5] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Paladin Protection
    [6] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Paladin Retribution
    [7] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Hunter  Beast         Mastery
    [8] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Hunter  Marksmanship
    [9] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Hunter  Survival
    [10] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Rogue   Assassination
    [11] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Rogue   Subtlety
    [12] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Rogue   Combat
    [13] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Priest  Discipline
    [14] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Priest  Holy
    [15] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Priest  Shadow
    [16] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Death   Knight        Blood
    [17] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Death   Knight        Frost
    [18] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Death   Knight        Unholy
    [19] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Shaman  Elemental
    [20] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Shaman  Enhancement
    [21] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Shaman  Restoration
    [22] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Mage    Arcane
    [23] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Mage    Fire
    [24] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Mage    Frost
    [25] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Warlock Affliction
    [26] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Warlock Demonology
    [27] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Warlock Destruction
    [28] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Druid   Balance
    [29] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Druid   Feral
    [30] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    }, -- Druid   Restoration
    [31] = {
        [0] = nil, -- Head
        [1] = nil, -- Neck
        [2] = nil, -- Shoulders
        [3 and 4] = nil, -- Chest
        [5] = nil, -- waist
        [6] = nil, -- Legs
        [7] = nil, -- Feet
        [8] = nil, -- Wrist
        [9] = nil, -- Hands
        [10] = nil, -- Finger1
        [11] = nil, -- Finger2
        [12] = nil, -- Trinket1
        [13] = nil, -- Trinket2
        [14] = nil, -- Back
        [15] = nil, -- MainHand
        [16] = nil, -- OffHand
        [17] = nil, -- Ranged
        [18] = nil -- Tabard
    } -- Druid   Restoration
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
            {
                "|TInterface/ICONS/Ability_Hunter_BeastWithin:50|t Beast Mastery",
                7
            },
            {
                "|TInterface/ICONS/Ability_Hunter_MarkedForDeath:50|t Marksmanship",
                8
            },
            {
                "|TInterface/ICONS/Ability_Hunter_SurvivalInstincts:50|t Survival",
                9
            }
        },
        [4] = {
            {
                "|TInterface/ICONS/Ability_Rogue_ShadowDance:50|t Assassination",
                10
            },
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
            {
                "|TInterface/ICONS/Spell_Deathknight_UnholyPresence:50|t Unholy",
                18
            }
        },
        [7] = {
            {"|TInterface/ICONS/Spell_Nature_Lightning:50|t Elemental", 19},
            {
                "|TInterface/ICONS/Spell_Nature_LightningShield:50|t Enhancement",
                20
            },
            {
                "|TInterface/ICONS/Spell_Nature_MagicImmunity:50|t Restoration",
                21
            }
        },
        [8] = {
            {"|TInterface/ICONS/Spell_Holy_MagicalSentry:50|t Arcane", 22},
            {"|TInterface/ICONS/Spell_Fire_FireBolt02:50|t Fire", 23},
            {"|TInterface/ICONS/Spell_Frost_FrostBolt02:50|t Frost", 24}
        },
        [9] = {
            {"|TInterface/ICONS/Spell_Shadow_DeathCoil:50|t Affliction", 25},
            {
                "|TInterface/ICONS/Spell_Shadow_DemonicEmpathy:50|t Demonology",
                26
            },
            {
                "|TInterface/ICONS/Spell_Shadow_Metamorphosis:50|t Destruction",
                27
            }
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
            for i, v in pairs(Gear[i]) do
                player:EquipItem(v, i)
            end
        end
    end
    player:SendBroadcastMessage("|cff00ff00 Gear has been equipped. |r")
    Pre_Build.Hello(event, player, object)
end
RegisterCreatureGossipEvent(Pre_Build.Npc_Id, 1, Pre_Build.Hello)
RegisterCreatureGossipEvent(Pre_Build.Npc_Id, 2, Pre_Build.Selection)
