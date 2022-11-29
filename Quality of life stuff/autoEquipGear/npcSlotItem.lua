--[[
----------------------
Set table name and id for npc then use other script to populate table

    might be a bug with duplicated item ids with equip function. Should be sent as mail.
----------------------
]]


local sqlWordldTableName = ""
local npcId = XXX -- npc id of the vendor/trainer

local preBuild = {}
local FILE_NAME = string.match(debug.getinfo(1, "S").source, "[^/\\]*.lua$")
local GOSSIP_EVENT_ON_HELLO = 1
local GOSSIP_EVENT_ON_SELECT = 2
local menuId = 0x7FFFFFFF


preBuild.T = {
    ["Menu"] = {
        [1] = {
            { "|TInterface/ICONS/ability_warrior_savageblow:50|t Arms", 1 },
            { "|TInterface/ICONS/spell_nature_bloodlust:50|t Fury", 2 },
            { "|TInterface/ICONS/Ability_Warrior_DefensiveStance:50|t Protection", 3 }
        },
        [2] = {
            { "|TInterface/ICONS/Spell_Holy_HolyBolt:50|t Holy", 4 },
            { "|TInterface/ICONS/Spell_Holy_AuraOfLight:50|t Protection", 5 },
            { "|TInterface/ICONS/Spell_Holy_SealOfMight:50|t Retribution", 6 }
        },
        [3] = {
            { "|TInterface/ICONS/Ability_Hunter_BeastWithin:50|t Beast Mastery", 7 },
            { "|TInterface/ICONS/Ability_Hunter_MarkedForDeath:50|t Marksmanship", 8 },
            { "|TInterface/ICONS/Ability_Hunter_SurvivalInstincts:50|t Survival", 9 }
        },
        [4] = {
            { "|TInterface/ICONS/Ability_Rogue_ShadowDance:50|t Assassination", 10 },
            { "|TInterface/ICONS/Ability_Rogue_CombatReadiness:50|t Combat", 11 },
            { "|TInterface/ICONS/Ability_Rogue_Subtlety:50|t Subtlety", 12 }
        },
        [5] = {
            { "|TInterface/ICONS/Spell_Holy_PowerWordShield:50|t Discipline", 13 },
            { "|TInterface/ICONS/Spell_Holy_GuardianSpirit:50|t Holy", 14 },
            { "|TInterface/ICONS/Spell_Shadow_ShadowWordPain:50|t Shadow", 15 }
        },
        [6] = {
            { "|TInterface/ICONS/Spell_Deathknight_BloodPresence:50|t Blood", 16 },
            { "|TInterface/ICONS/Spell_Deathknight_FrostPresence:50|t Frost", 17 },
            { "|TInterface/ICONS/Spell_Deathknight_UnholyPresence:50|t Unholy", 18 }
        },
        [7] = {
            { "|TInterface/ICONS/Spell_Nature_Lightning:50|t Elemental", 19 },
            { "|TInterface/ICONS/Spell_Nature_LightningShield:50|t Enhancement", 20 },
            { "|TInterface/ICONS/Spell_Nature_MagicImmunity:50|t Restoration", 21 }
        },
        [8] = {
            { "|TInterface/ICONS/Spell_Holy_MagicalSentry:50|t Arcane", 22 },
            { "|TInterface/ICONS/Spell_Fire_FireBolt02:50|t Fire", 23 },
            { "|TInterface/ICONS/Spell_Frost_FrostBolt02:50|t Frost", 24 }
        },
        [9] = {
            { "|TInterface/ICONS/Spell_Shadow_DeathCoil:50|t Affliction", 25 },
            { "|TInterface/ICONS/Spell_Shadow_DemonicEmpathy:50|t Demonology", 26 },
            { "|TInterface/ICONS/Spell_Shadow_Metamorphosis:50|t Destruction", 27 }
        },
        [11] = {
            { "|TInterface/ICONS/Spell_Nature_Lightning:50|t Balance", 28 },
            { "|TInterface/ICONS/Ability_Druid_CatForm:50|t Feral", 29 },
            { "|TInterface/ICONS/Spell_Nature_HealingTouch:50|t Restoration", 30 },
            { "|TInterface/ICONS/ability_racial_bearform:50|t Guardian", 31 }
        }
    }
}

local FILE_NAME = string.match(debug.getinfo(1, "S").source, "[^/\\]*.lua$")

--[[
    BUG: Can't handle 2 identical IDs in the same set. (e.g. 2x Head) - Fixed by adding a random number to the itemId.
    FIX: If inventory is full, the item will be sent to mailbox can be duped tho
 ]]
local function getFreeBagSlots(player)
    local free = 0
    for i = 23, 38 do -- backpack
        if (not player:GetItemByPos(255, i)) then free = free + 1 end
    end
    for i = 19, 22 do -- equipped bags
        local bag = player:GetItemByPos(255, i) -- get the item at this position
        if (bag) then
            if (bag:GetBagSize() > 0) then -- if it's a bag
                for x = 0, bag:GetBagSize() - 1 do
                    if (not player:GetItemByPos(i, x)) then
                        free = free + 1
                    end

                end
            end
        end
    end
    return free
end

local function forceEquip(player, slot, itemId)

    if slot == nil then
        return false
    end
    if itemId == nil or itemId == 0 then
        return -- no item to equip
    end

    local del = player:GetEquippedItemBySlot(slot)
    if (del) then
        local entry = del:GetEntry()
        -- if (entry == itemId) then -- item is already equipped
        --     return
        -- end

        player:RemoveItem(del, 1)

        if (getFreeBagSlots(player) == 0) then
            local mail = SendMail("Inventory Full",
                "Your inventory is full. Please make room for the item you just unequipped.",
                player:GetGUIDLow(), 0, 0, 0, 0, 0, entry, 1)
            if (not mail) then
                PrintError("[" .. FILE_NAME ..
                    "] ERROR: Could not send mail to player " ..
                    player:GetName() .. " while using [" .. FILE_NAME ..
                    "] and the item was destroyed. This should NOT happen. Please report this to the developer.")
            end
        else
            local add = player:AddItem(entry, 1)

            if (not add) then
                PrintError("[" .. FILE_NAME .. "] ERROR: Could not add item " ..
                    entry .. " to player " .. player:GetName() ..
                    " while using [" .. FILE_NAME ..
                    "] and the item was destroyed. This should NOT happen. Please report this to the developer.")
            end
        end
    end
    local item = player:GetItemByEntry(itemId) -- item is in bag
    local equip

    if (item) then
        equip = player:EquipItem(item, slot)
    else
        equip = player:EquipItem(itemId, slot)
    end



    if (not equip) then
        if (not item) then -- item is not in the player's inventory'
            item = player:AddItem(itemId, 1) -- add item to inventory
        end
        PrintError("[" .. FILE_NAME .. "] ERROR: Could not equip item " ..
            itemId .. ' on player "' .. player:GetName() ..
            '"  This should NOT happen.')
    end
    -- return true
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local DatabaseCache = {}
function preBuild.LoadDatabase()
    local query = WorldDBQuery("SELECT * FROM " .. sqlWorldTableName .. ";")

    if (query) then
        repeat
            DatabaseCache[query:GetUInt32(0)] = {
                -- name = query:GetString(1),
                head = query:GetUInt32(2),
                neck = query:GetUInt32(3),
                shoulders = query:GetUInt32(4),
                shirt = query:GetUInt32(5),
                chest = query:GetUInt32(6),
                waist = query:GetUInt32(7),
                legs = query:GetUInt32(8),
                feet = query:GetUInt32(9),
                wrist = query:GetUInt32(10),
                hands = query:GetUInt32(11),
                finger1 = query:GetUInt32(12),
                finger2 = query:GetUInt32(13),
                trinket1 = query:GetUInt32(14),
                trinket2 = query:GetUInt32(15),
                back = query:GetUInt32(16),
                mainHand = query:GetUInt32(17),
                offHand = query:GetUInt32(18),
                ranged = query:GetUInt32(19),
                tabard = query:GetUInt32(20)
            }

        until not query:NextRow()
        print(query:GetRowCount() .. " gear sets loaded from database.")
    else
        print("No gear sets found in database.")
    end
end

function preBuild.Hello(event, player, object)
    player:GossipSetText("Hello there, " .. player:GetName() .. ". I am a gear vendor. Select a Spec to equip your gear.")
    local class = player:GetClass()

    if preBuild.T["Menu"][class] then
        for i = 1, #preBuild.T["Menu"][class] do
            player:GossipMenuAddItem(0, preBuild.T["Menu"][class][i][1], 0, preBuild.T["Menu"][class][i][2])
        end
    end
    if player:IsGM() then
        player:GossipMenuAddItem(0, "|TInterface/ICONS/inv_misc_note_01:50|t Update Gear Data", 0, 100)
    end
    player:GossipSendMenu(menuId, object)
end

function preBuild.Selection(event, player, object, sender, intid, code, menuid)


    if intid == 100 then
        player:GossipComplete()
        player:SendBroadcastMessage("Updating SQL...")
        preBuild.LoadDatabase()
        player:SendBroadcastMessage("SQL updated.")
        return
    end

    local class = player:GetClass()
    --get the gear set from the database and equip it
    local gearSet = DatabaseCache[intid]
    if gearSet then

        for slot, item in pairs(gearSet) do
            -- print(slot, item)
            if item == 0 then
                item = nil
            end
            --change all slot to the correct slot for some reason sql didnt like when i set head to 0?
            if slot == "head" then
                slot = 0
            elseif slot == "neck" then
                slot = 1
            elseif slot == "shoulders" then
                slot = 2
            elseif slot == "shirt" then
                slot = 3
            elseif slot == "chest" then
                slot = 4
            elseif slot == "waist" then
                slot = 5
            elseif slot == "legs" then
                slot = 6
            elseif slot == "feet" then
                slot = 7
            elseif slot == "wrist" then
                slot = 8
            elseif slot == "hands" then
                slot = 9
            elseif slot == "finger1" then
                slot = 10
            elseif slot == "finger2" then
                slot = 11
            elseif slot == "trinket1" then
                slot = 12
            elseif slot == "trinket2" then
                slot = 13
            elseif slot == "back" then
                slot = 14
            elseif slot == "mainHand" then
                slot = 15
            elseif slot == "offHand" then
                slot = 16
            elseif slot == "ranged" then
                slot = 17
            elseif slot == "tabard" then
                slot = 18
            else
                -- if item == nil or item == 0 then
                --     return
                -- end

            end


            forceEquip(player, slot, item)
        end
    end
    for i, v in pairs(preBuild.T["Menu"][class]) do
        if intid == v[2] then
            player:SendNotification("You have selected " .. v[1] .. " ")
        end
    end


    preBuild.Hello(event, player, object)
end

preBuild.LoadDatabase()
RegisterCreatureGossipEvent(npcId, GOSSIP_EVENT_ON_HELLO, preBuild.Hello)
RegisterCreatureGossipEvent(npcId, GOSSIP_EVENT_ON_SELECT, preBuild.Selection)

PrintInfo("[" .. FILE_NAME .. "] loaded.")
