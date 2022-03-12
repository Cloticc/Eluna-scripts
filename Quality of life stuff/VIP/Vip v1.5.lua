--Will use a spell so u can only use the commands when player HasSpell(Vip.SpellId). If they dont have the spell then they cant use the commands. Dont forget to setup the ItemId, SpellId, Cord for mall.

Vip = {}

Vip.ItemId = 1 -- Item ID to be consumed by the VIP
Vip.SpellId = 36356 -- Spell ID For enabling the commands to be used by the VIP atm it set to https://wotlkdb.com/?spell=36356
Vip.AnnounceModule = true -- change to false if u wanna disable this shows a message in the chat that it is enabled
-- change to false if u wanna disable this
Vip.Buffenabled = true -- Buffs
Vip.ResetInstance = true -- Reset Instance
Vip.ResetTalents = true -- Reset Talents
Vip.Pet = false -- change to true if u wanna enable this. Not sure if this works on ur server might sql crash it.
Vip.RepairAll = true -- Repair all gear
Vip.Commands = true -- show command list
Vip.Maxskill = true -- max skill
Vip.Mall = true -- teleport mall
-- Vip.CordMall = mappId, xCoord, yCoord, zCoord
Vip.Mapid, Vip.X, Vip.Y, Vip.Z, Vip.O = 1, 16226.200195312, 16257, 13.202199935913, 1.6500699520111 -- mapid, x, y, z, o This is the MALL location atm it set to gmisland

Vip.List = {"#buff", "#resetinstance", "#resettalent", "#resetpet", "#repair", "#vip", "#maxskill", "#vipmall"}

Vip.Buffs = {
    -- Place the buffs here just do exmaple:
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
    35874 -- Master Melee Buff
} -- vip buffs for players

function Vip.TimerTeleport(eventid, delay, repeats, player)
    -- local TeleportIn = 6 -- This will be TeleportIn - repeats, start at 6 to have 5 seconds

    player:SendAreaTriggerMessage("Teleporting in " .. repeats .. " seconds.")
end

function Vip.TeleportMall(event, delay, repeats, player)
    player:Teleport(Vip.Mapid, Vip.X, Vip.Y, Vip.Z, Vip.O)
end

local FILE_NAME = string.match(debug.getinfo(1, "S").source, "[^/\\]*.lua$")

function Vip.Activation(event, player, item, target)
    if player:IsInCombat() then
        player:SendAreaTriggerMessage("You cannot use this item while in combat.")
        return
    end
    player:LearnSpell(Vip.SpellId)
    -- player:RemoveItem(Vip.ItemId, 1)
end
RegisterItemEvent(Vip.ItemId, 2, Vip.Activation)
function Vip.Chat_Commands(event, player, msg, Type, lang)
    if (Vip.Buffenabled) then
        if (msg == Vip.List[1]) then
            if not (player:HasSpell(Vip.SpellId)) then
                return
            end
            player:SendBroadcastMessage("|cff00ff00VIP|r|cff00ffff Buff|r")
            for _, v in pairs(Vip.Buffs) do
                player:AddAura(v, player)
            end
            return false
        end
    end
    if (Vip.ResetInstance) then
        if (msg == Vip.List[2]) then
            if not (player:HasSpell(Vip.SpellId)) then
                return
            end
            player:SendBroadcastMessage("|cff00ff00[VIP]|r You have reset your|cff00ffff instance|r.")
            player:UnbindAllInstances()
            return false
        end
    end

    if (Vip.ResetTalents) then
        if (msg == Vip.List[3]) then
            if not (player:HasSpell(Vip.SpellId)) then
                return
            end
            player:SendBroadcastMessage("|cff00ff00[VIP]|r You have reset your|cff00ffff talents|r.")
            player:ResetTalents()
            return false
        end
    end
    if (Vip.Pet) then
        if (msg == Vip.List[4]) then
            if not (player:HasSpell(Vip.SpellId)) then
                return
            end
            if not (player:GetClass() == 3) then
                player:SendBroadcastMessage("You are not a hunter.")
                return
            end
            player:SendBroadcastMessage("|cff00ff00[VIP]|r You have |cff00ffffreset pet talent|r.")
            player:ResetPetTalents()
            return false
        end
    end
    if (Vip.RepairAll) then
        if (msg == Vip.List[5]) then
            if not (player:HasSpell(Vip.SpellId)) then
                return
            end
            player:SendBroadcastMessage("|cff00ff00[VIP]|r You have |cff00ffff repaired |r your gear.")
            player:DurabilityRepairAll(false)
            return false
        end
    end
    if (Vip.Commands) then
        if (msg == Vip.List[6]) then
            if not (player:HasSpell(Vip.SpellId)) then
                return
            end
            for _, v in pairs(Vip.List) do
                player:SendBroadcastMessage("|cff00ff00[VIP]|r You have |cff00ffff" .. v .. "|r.")
            end
            return false
        end
    end
    if (Vip.Maxskill) then
        if (msg == Vip.List[7]) then
            if not (player:HasSpell(Vip.SpellId)) then
                return
            end
            player:AdvanceAllSkills(999)
            player:SendBroadcastMessage("|cff00ff00[VIP]|r You have |cff00ffffmaxskill|r.")
            return false
        end
    end
    if (Vip.Mall) then
        if (msg == Vip.List[8]) then
            if not (player:HasSpell(Vip.SpellId)) then
                return
            end
            if (player:IsInCombat() == true) then
                player:SendBroadcastMessage("|cff00ff00[VIP]|r You can't use this command in combat.")
            end
            player:SendBroadcastMessage("|cff00ff00[VIP]|r Teleported to |cff00ffffmall|r.")
            player:RegisterEvent(Vip.TimerTeleport, 1000, 5) -- 5 seconds
            player:RegisterEvent(Vip.TeleportMall, 6000, 0)
            return false
        end
    end
end

RegisterPlayerEvent(18, Vip.Chat_Commands)

local function onLogin(event, player)
    player:SendBroadcastMessage("This server is running the |cff4CFF00" .. FILE_NAME .. "|r module loaded.")
end
if (Vip.AnnounceModule) then
    RegisterPlayerEvent(3, onLogin)
end
PrintInfo("[" .. FILE_NAME .. "] loaded.")
