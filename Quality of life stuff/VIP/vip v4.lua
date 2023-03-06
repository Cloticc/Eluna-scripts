--[[
TODO: Add timer how long the player has the VIP


#vip update to update the spell on all characters on the account. This works for everyone.
#vip remove to remove the spell from targeted person.

#vip gm to learn spell witch is Vip.SpellId = 36356 change to w/e u want


 ]]
Vip                = {}
Vip.ItemId         = 2070  -- Item ID to be consumed by the VIP
Vip.SpellId        = 36356 -- Title ID For enabling the commands
Vip.AnnounceModule = true  -- change to false if u wanna disable this shows a message in the chat that it is enabled
-- change to false if u wanna disable this





--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Vip.CordMall = mappId, xCoord, yCoord, zCoord. Just Change after "=" to the values you want.
Vip.Mapid, Vip.X, Vip.Y, Vip.Z, Vip.O  = 0, -9443.9541015625, 65.456764221191, 56.173454284668, 0 -- mapid, x, y, z, o
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--true is active. false is not active.
Vip.Commands                           = true -- show command list
Vip.Buff                               = true
Vip.ResetInstance                      = true
Vip.ResetTalents                       = true
Vip.Pet                                = false -- change to true if u wanna enable this. Not sure if this works on ur server might sql crash it.
Vip.RepairAll                          = true  -- Repair all gear
Vip.Maxskill                           = true  -- max skill
Vip.Mall                               = true  -- teleport mall
Vip.Bank                               = true  -- openBank
Vip.groupreset                         = true  -- reset group
Vip.List                               = true  -- list of commands
Vip.GM                                 = true  -- GM learn spell
Vip.Update                             = true  -- Use this to trigger the update when new toon is created

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Vip.Buffs                              = {
    -- Place the buffs here just do exmaple:
    8385,
    26393, -- Eluns blessing 10% Stats
    23735, -- Sayge's Dark Fortune of Strength
    23737, -- Sayge's Dark Fortune of Stamina
    23738, -- Sayge's Dark Fortune of Stamina
    23769, -- Sayge's Dark Fortune of Resistance
    23766, -- Sayge's Dark Fortune of Intelligence
    23768, -- Sayge's Dark Fortune of Damage
    23767, -- Sayge's Dark Fortune of Armor
    23736, -- Sayge's Dark Fortune of Agility
    48074,
    48170,
    43223,
    36880,
    467,
    48469,
    48162,
    21564,
    26035,
    48469,
    48073,
    16609,
    36880,
    15366,
    43223, -- 65077, -- tower of frost 40% health
    -- 65075, -- tower of fire 40% health 50% fire damage
    48074,
    38734, -- Master Ranged Buff
    35912, -- Master Magic Buff
    35874  -- Master Melee Buff
}          -- vip buffs for players
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
    if (player:IsInCombat() == true) then
        player:SendAreaTriggerMessage("You cannot use this item while in combat.")
        return
    end
    player:LearnSpell(Vip.SpellId)
    -- player:RemoveItem(Vip.ItemId, 1)
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
            enabled = Vip.GM,
            gmRankRequired = 2,
            description = "Learn Vip.SpellId spell",
            execute = function()
                -- player:LearnSpell(Vip.SpellId)
                Vip.setVipAllCharAccount(event, player)
            end
        },
        -- set remove vip
        ["remove"] = {
            enabled = true,
            gmRankRequired = 2,
            description = "Removes VIP status from a target",
            execute = function()
                player:SendAreaTriggerMessage("Removing your VIP.")
                Vip.removeVipAllCharAccount(event, player)
            end
        },
        ["buff"] = {
            enabled = Vip.Buff,
            description = "Buff yourself",
            execute = function()
                for _, v in pairs(Vip.Buffs) do
                    player:AddAura(v, player)
                end
                player:SendAreaTriggerMessage("You have been buffed.")
            end
        },
        ["resetinstance"] = {
            enabled = Vip.ResetInstance,
            description = "Reset all instances",
            execute = function()
                player:UnbindAllInstances()
                player:SendAreaTriggerMessage("Instance has been reset.")
            end
        },
        ["resettalent"] = {
            enabled = Vip.ResetTalents,
            description = "Reset your talents",
            execute = function()
                player:ResetTalents()
                player:SendAreaTriggerMessage("You have reset your talents.")
            end
        },
        ["resetpet"] = {
            enabled = Vip.ResetPet,
            description = "Reset your pet talents",
            execute = function()
                player:ResetPetTalents()
                player:SendAreaTriggerMessage("You have reset your pet talents.")
            end
        },
        ["repair"] = {
            enabled = Vip.RepairAll,
            description = "Repair all your items",
            execute = function()
                player:DurabilityRepairAll(false)
                player:SendAreaTriggerMessage("You have repaired all your items.")
            end
        },
        ["maxskill"] = {
            enabled = Vip.Maxskill,
            description = "Max all your skills",
            execute = function()
                player:AdvanceAllSkills(1000)
                player:SendAreaTriggerMessage("You have maxed all your skills.")
            end
        },
        ["mall"] = {
            enabled = Vip.Mall,
            description = "Teleport to the mall",
            execute = function()
                player:SendAreaTriggerMessage("Teleported to the mall in.")
                player:RegisterEvent(Vip.TimerTeleport, 1000, 5) -- 5 seconds
            end
        },
        ["bank"] = {
            enabled = Vip.Bank,
            description = "Open the bank",
            execute = function()
                player:SendAreaTriggerMessage("Open the bank.")
                player:SendShowBank(player)
            end
        },
        ["resetgroup"] = {
            enabled = Vip.groupreset,
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
            enabled = Vip.ResetAll,
            description = "Reset all your talents, instances, skills, and repair all your items",
            execute = function()
                player:ResetTalents()
                player:ResetPetTalents()
                player:UnbindAllInstances()
                player:DurabilityRepairAll(false)
                player:AdvanceAllSkills(1000)
                player:SendAreaTriggerMessage(
                    "You have reset all your talents, instances, skills, and repaired all your items.")
            end
        },
        ["update"] = {
            enabled = Vip.Update,
            description = "Update your VIP to other characters",
            execute = function()
                player:SendAreaTriggerMessage("Updating your VIP.")
                Vip.setVipAllCharAccount(event, player)
            end
        },
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
            if Vip.List then
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
