--[[
TODO: Add timer how long the player has the VIP


#vip update to update the spell on all characters on the account. This works for everyone.
#vip remove to remove the spell from targeted person.

#vip gm to learn spell witch is Vip.SpellId = 36356 change to w/e u want


 ]]
-- INSERT INTO `item_template` (`entry`, `class`, `subclass`, `SoundOverrideSubclass`, `name`, `displayid`, `Quality`, `Flags`, `FlagsExtra`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`, `RequiredSkill`, `RequiredSkillRank`, `requiredspell`, `requiredhonorrank`, `RequiredCityRank`, `RequiredReputationFaction`, `RequiredReputationRank`, `maxcount`, `stackable`, `ContainerSlots`, `StatsCount`, `stat_type1`, `stat_value1`, `stat_type2`, `stat_value2`, `stat_type3`, `stat_value3`, `stat_type4`, `stat_value4`, `stat_type5`, `stat_value5`, `stat_type6`, `stat_value6`, `stat_type7`, `stat_value7`, `stat_type8`, `stat_value8`, `stat_type9`, `stat_value9`, `stat_type10`, `stat_value10`, `ScalingStatDistribution`, `ScalingStatValue`, `dmg_min1`, `dmg_max1`, `dmg_type1`, `dmg_min2`, `dmg_max2`, `dmg_type2`, `armor`, `holy_res`, `fire_res`, `nature_res`, `frost_res`, `shadow_res`, `arcane_res`, `delay`, `ammo_type`, `RangedModRange`, `spellid_1`, `spelltrigger_1`, `spellcharges_1`, `spellppmRate_1`, `spellcooldown_1`, `spellcategory_1`, `spellcategorycooldown_1`, `spellid_2`, `spelltrigger_2`, `spellcharges_2`, `spellppmRate_2`, `spellcooldown_2`, `spellcategory_2`, `spellcategorycooldown_2`, `spellid_3`, `spelltrigger_3`, `spellcharges_3`, `spellppmRate_3`, `spellcooldown_3`, `spellcategory_3`, `spellcategorycooldown_3`, `spellid_4`, `spelltrigger_4`, `spellcharges_4`, `spellppmRate_4`, `spellcooldown_4`, `spellcategory_4`, `spellcategorycooldown_4`, `spellid_5`, `spelltrigger_5`, `spellch  arges_5`, `spellppmRate_5`, `spellcooldown_5`, `spellcategory_5`, `spellcategorycooldown_5`, `bonding`, `description`, `PageText`, `LanguageID`, `PageMaterial`, `startquest`, `lockid`, `Material`, `sheath`, `RandomProperty`, `RandomSuffix`, `block`, `itemset`, `MaxDurability`, `area`, `Map`, `BagFamily`, `TotemCategory`, `socketColor_1`, `socketContent_1`, `socketColor_2`, `socketContent_2`, `socketColor_3`, `socketContent_3`, `socketBonus`, `GemProperties`, `RequiredDisenchantSkill`, `ArmorDamageModifier`, `duration`, `ItemLimitCategory`, `HolidayId`, `ScriptName`, `DisenchantID`, `FoodType`, `minMoneyLoot`, `maxMoneyLoot`, `flagsCustom`, `VerifiedBuild`) VALUES (56846, 7, 11, -1, 'Certificate of VIP', 55297, 5, 0, 0, 1, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62408, 0, -1, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 'The VIP token gives you access to exclusive commands for ultimate power in Azeroth. Unleash your character\'s full potential and dominate the game. Hold it tight and impress your friends and enemies alike.', 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 12340);


local Vip = {
    ItemId = 56846,        -- Item ID to be consumed by the VIP
    SpellId = 36356,       -- SpellId ID For enabling the commands
    AnnounceModule = true, -- change to false if u wanna disable this shows a message in the chat that it is enabled
    Mapid = 0,
    X = -9443.9541015625,
    Y = 65.456764221191,
    Z = 56.173454284668,
    O = 0, -- mapid, x, y, z, o
    -- Change the values to true or false to enable or disable the features
    Commands = {
        Buff = true,          --buffs the player
        ResetInstance = true, --reset instance
        ResetTalents = true,  --reset talents
        ResetPet = false,     --reset pet talent
        RepairAll = true,     -- repair all items
        MaxSkills = true,     -- max all skills
        Mall = true,          -- teleport to mall
        Bank = true,          -- open bank
        GroupReset = true,    --reset group instance
        List = true,          --list all commands
        isGM = true,          -- learn the spell
        Update = true,        -- update the vip status
        ResetAll = true,      -- reset all
        Remove = true,        -- remove vip from target
        PetHappy = true,      -- happy pet
    },
    Buffs = {
        8385, 26393, 23735, 23737, 23738, 23769, 23766, 23768, 23767, 23736, 48074, 48170, 43223, 36880,
        467, 48469, 48162, 21564, 26035, 48469, 48073, 16609, 36880, 15366, 43223, 48074, 38734, 35912, 35874
    },
    Pet = {
        PET_STARTWITH_HAPPINESS = 5000000,
        POWER_HAPPINESS = 4
    }

}



local FILE_NAME                        = string.match(debug.getinfo(1, "S").source, "[^/\\]*.lua$")
local PLAYER_EVENT_ON_CHAT             = 18
local PLAYER_EVENT_ON_LOGIN            = 3
local ITEM_EVENT_ON_USE                = 2
local PLAYER_EVENT_ON_CHARACTER_CREATE = 1
function Vip.TimerTeleport(eventId, delay, repeats, player)
    -- local TeleportIn = 6 -- This will be TeleportIn - repeats, start at 6 to have 5 seconds
    player:SendAreaTriggerMessage("Teleporting in " .. repeats .. " seconds.")

    if (player:IsInCombat()) then
        player:SendAreaTriggerMessage("You are in combat, cancelling teleport.")
        return
    end
    if repeats == 1 then
        player:Teleport(Vip.Mapid, Vip.X, Vip.Y, Vip.Z, Vip.O)
    end
end

function Vip.Activation(event, player, item, target)
    if player:HasSpell(Vip.SpellId) then
        player:SendAreaTriggerMessage("You already have VIP.")
        player:AddItem(Vip.ItemId, 1)
        return -- do not continue if player already has the spell
    end

    if player:IsInCombat() then
        player:SendAreaTriggerMessage("You cannot use this item while in combat.")
        return -- do not continue if player is in combat
    end

    player:LearnSpell(Vip.SpellId)


    player:SendBroadcastMessage("VIP Activated by " .. player:GetName())
end

RegisterItemEvent(Vip.ItemId, ITEM_EVENT_ON_USE, Vip.Activation)



function Vip.setVipAllCharAccount(event, selectTarget)
    --Give VIP to all characters on account if they have the item or spell
    local account = selectTarget:GetAccountId()
    local hasSpellQuery = CharDBQuery(
        "SELECT characters.guid FROM characters JOIN character_spell ON characters.guid = character_spell.guid WHERE characters.account = " ..
        account .. " AND character_spell.spell = " .. Vip.SpellId)
    if (hasSpellQuery) then
        -- account has spell, add it to new character
        local guid = selectTarget:GetGUIDLow()
        local hasSpellQuery2 = CharDBQuery("SELECT 1 FROM character_spell WHERE guid = " ..
            guid .. " AND spell = " .. Vip.SpellId)
        if (not hasSpellQuery2) then
            CharDBExecute("INSERT INTO character_spell (guid, spell, active, disabled) VALUES (" ..
                guid .. ", " .. Vip.SpellId .. ", 1, 0)")
        end
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_CHARACTER_CREATE, Vip.setVipAllCharAccount)
-- Function to remove the spell from all characters on the accountId

function Vip.removeVipAllCharAccount(event, selectTarget)
    local account = selectTarget:GetAccountId()
    local hasSpellQuery = CharDBQuery(
        "SELECT characters.guid FROM characters JOIN character_spell ON characters.guid = character_spell.guid WHERE characters.account = " ..
        account .. " AND character_spell.spell = " .. Vip.SpellId)
    if (hasSpellQuery) then
        -- account has spell, remove it from all characters
        CharDBExecute("DELETE FROM character_spell WHERE spell = " .. Vip.SpellId)
    end
end

function Vip.chatVipCommands(event, player, msg, Type, lang)
    local command = string.lower(string.sub(msg, 6)) -- extract the command name from the message

    local selectTarget = player:GetSelection()
    if (not selectTarget or selectTarget == player) then
        selectTarget = player
    end



    local vipCommands = {
        ["gm"] = {
            enabled = Vip.Commands.isGM,
            gmRankRequired = 2,
            description = "Learn Vip.SpellId spell",
            execute = function()
                -- player:LearnSpell(Vip.SpellId)
                Vip.setVipAllCharAccount(event, player)
            end
        },
        -- set remove vip
        ["remove"] = {
            enabled = Vip.Commands.Remove,
            gmRankRequired = 2,
            description = "Removes VIP status from a target",
            execute = function()
                player:SendAreaTriggerMessage("Removing your VIP.")
                Vip.removeVipAllCharAccount(event, player)
            end
        },
        ["buff"] = {
            enabled = Vip.Commands.Buff,
            description = "Buff yourself",
            execute = function()
                for _, v in pairs(Vip.Buffs) do
                    player:AddAura(v, player)
                end
                player:SendAreaTriggerMessage("You have been buffed.")
            end
        },
        ["resetinstance"] = {
            enabled = Vip.Commands.ResetInstance,
            description = "Reset all instances",
            execute = function()
                player:UnbindAllInstances()
                player:SendAreaTriggerMessage("Instance has been reset.")
            end
        },
        ["resettalent"] = {
            enabled = Vip.Commands.ResetTalents,
            description = "Reset your talents",
            execute = function()
                player:ResetTalents()
                player:SendAreaTriggerMessage("You have reset your talents.")
            end
        },
        ["resetpet"] = {
            enabled = Vip.Commands.ResetPet,
            description = "Reset your pet talents",
            execute = function()
                player:ResetPetTalents()
                player:SendAreaTriggerMessage("You have reset your pet talents.")
            end
        },
        ["repair"] = {
            enabled = Vip.Commands.RepairAll,
            description = "Repair all your items free of charge",
            execute = function()
                player:DurabilityRepairAll(false)
                player:SendAreaTriggerMessage("You have repaired all your items.")
            end
        },
        ["maxskill"] = {
            enabled = Vip.Commands.MaxSkills,
            description = "Max all your skills",
            execute = function()
                player:AdvanceAllSkills(1000)
                player:SendAreaTriggerMessage("You have maxed all your skills.")
            end
        },
        ["mall"] = {
            enabled = Vip.Commands.Mall,
            description = "Teleport to the mall",
            execute = function()
                player:SendAreaTriggerMessage("Teleported to the mall in.")
                player:RegisterEvent(Vip.TimerTeleport, 1000, 5) -- 5 seconds
            end
        },
        ["bank"] = {
            enabled = Vip.Commands.Bank,
            description = "Open the bank",
            execute = function()
                player:SendAreaTriggerMessage("Open the bank.")
                player:SendShowBank(player)
            end
        },
        ["resetgroup"] = {
            enabled = Vip.Commands.GroupReset,
            description = "Reset all group instances",
            execute = function()
                player:SendAreaTriggerMessage("You have reset your group instances.")
                local party = player:GetGroup()
                if party then
                    for _, member in pairs(party:GetMembers()) do
                        member:UnbindAllInstances()
                    end
                end
            end
        },
        ["resetall"] = {
            enabled = Vip.Commands.ResetAll,
            description = "Reset all your talents, instances, skills and sets your level to 1",
            execute = function()
                --add static popup telling player that this will reset all their talents, instances, skills, and repair all their items

                player:ResetTalents()
                player:ResetPetTalents()
                player:UnbindAllInstances()
                player:DurabilityRepairAll(false)
                player:AdvanceAllSkills(1000)
                player:SetLevel(1)
                player:ResetAllCooldowns()

                -- reset all spells player has learned (except for the VIP spell)

                local hasSpellQuery = CharDBQuery(
                    "SELECT characters.guid FROM characters JOIN character_spell ON characters.guid = character_spell.guid WHERE characters.account = " ..
                    player:GetAccountId() .. " AND character_spell.spell = " .. Vip.SpellId)
                if (hasSpellQuery) then
                    CharDBExecute(
                        "DELETE FROM character_spell WHERE guid = " ..
                        player:GetGUIDLow() .. " AND spell != " .. Vip.SpellId)
                end



                player:SendAreaTriggerMessage(
                    "You have reset all your talents, instances, skills, and repaired all your items.")
            end
        },
        ["update"] = {
            enabled = Vip.Commands.Update,
            description = "Update your VIP to other characters",
            execute = function()
                player:SendAreaTriggerMessage("Updating your VIP.")
                Vip.setVipAllCharAccount(event, player)
            end
        },
        ["pethappy"] = {
            enabled = Vip.Commands.PetHappy,
            description = "Set your pet's happiness to 100",
            execute = function()
                local petguid = player:GetPetGUID()
                if (petguid) then
                    local pet = player:GetMap():GetWorldObject(petguid)
                    if (pet) then
                        pet:ToUnit()
                        pet:SetPower(Vip.Pet.PET_STARTWITH_HAPPINESS, Vip.Pet.POWER_HAPPINESS)


                        player:SendAreaTriggerMessage("Your pet's happiness has been set to 100.")
                    end
                end
            end
        }
    }
    if (string.lower(string.sub(msg, 1, 5)) == "#vip ") then -- if the first 5 letters are #vip
        if (player:IsInCombat()) then
            player:SendAreaTriggerMessage("You cannot use this command while in combat.")
            return
        end

        if (string.lower(string.sub(msg, 6, 12)) == "update") then
            if (player:IsInCombat()) then
                player:SendAreaTriggerMessage("You cannot use this command while in combat.")
                return
            end
            player:SendAreaTriggerMessage("Updating your VIP.")
            Vip.setVipAllCharAccount(event, player)

            return false
        end



        if (string.lower(string.sub(msg, 6, 12)) == "remove") then
            if not player:IsGM() then
                player:SendAreaTriggerMessage("You are not a GM.")
                return
            end
            if (player:IsInCombat()) then
                player:SendAreaTriggerMessage("You cannot use this command while in combat.")
                return
            end
            player:SendAreaTriggerMessage("Removing your VIP.")
            selectTarget:RemoveSpell(Vip.SpellId)
            Vip.removeVipAllCharAccount(event, selectTarget)
            print("Removing VIP from " .. selectTarget:GetName())
            return false
        end

        if (not player:HasSpell(Vip.SpellId)) then -- if player is not vip
            if (not player:IsGM()) then            -- if player is not a GM
                return player:SendAreaTriggerMessage("You are not a VIP or GM.")
            else                                   -- if player is a GM, learn the spell for them
                player:LearnSpell(Vip.SpellId)
                player:SendBroadcastMessage("You have learned the VIP spell.")
            end
        end


        if vipCommands[command] and vipCommands[command].enabled then
            if vipCommands[command].gmRankRequired and player:GetGMRank() <= vipCommands[command].gmRankRequired then
                return
            end

            vipCommands[command].execute()
        else
            player:SendAreaTriggerMessage("This command is disabled.")
        end


        -- code for displaying the list or help
        if string.lower(string.sub(msg, 6, 10)) == "help" or string.lower(string.sub(msg, 6, 9)) == "list" then
            if Vip.Commands then
                player:SendBroadcastMessage("VIP Commands:")
                for k, v in pairs(vipCommands) do
                    print("k: " .. k .. " v: " .. v.description .. "")
                    -- player:SendBroadcastMessage("#vip " .. k .. ": " .. v.description)
                    player:SendBroadcastMessage("|cff00ff00#vip " .. k .. "|r: " .. v.description)
                end
                if player:IsGM() then
                    player:SendBroadcastMessage("#vip gm: Grants VIP status to all characters on the account")
                end
            else
                player:SendAreaTriggerMessage("This command is disabled.")
            end
        end
        return false
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_CHAT, Vip.chatVipCommands)

local function onLogin(event, player)
    player:SendBroadcastMessage("This server is running the |cff4CFF00" .. FILE_NAME .. "|r module loaded.")
end

if (Vip.AnnounceModule) then
    RegisterPlayerEvent(PLAYER_EVENT_ON_LOGIN, onLogin) -- PLAYER_EVENT_ON_LOGIN
end
PrintInfo("[" .. FILE_NAME .. "] loaded.")
