local AIO = AIO or require("AIO")


local racialHandler = AIO.AddHandlers("racialSwitch", {})



local enableItem = false  --if true it cost item
local itemRequired = 5140 --item it cost

local function hasRequiredItem(player)
    if enableItem then
        return player:HasItem(itemRequired)
    else
        return true
    end
end

function racialHandler.racialActivate(player, spellId, ...)
    if (player:IsInCombat() and player:InBattleground() == true) then
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
        return false
    end

    player:LearnSpell(spellId)

    player:SaveToDB()
end

function racialHandler.racialDeactivate(player, spellId, ...)
    if (player:IsInCombat() and player:InBattleground() == true) then
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
        return false
    end

    if not hasRequiredItem(player) then
        player:SendBroadcastMessage(
            "|cff00ff00[World]|r |cffff0000You don't have |cffff0000|cff00ff00 " ..
            GetItemLink(itemRequired) .. " |cffff0000 |cffff0000in your inventory!"
        )
    else
        player:RemoveItem(itemRequired, 1)
        player:RemoveSpell(spellId)
        player:SaveToDB()
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You have removed your racial!")
    end
end

function racialHandler.unLearnAllRacials(player, spellId)
    if (player:IsInCombat() and player:InBattleground() == true) then
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
        return false
    end

    if not hasRequiredItem(player) then
        player:SendBroadcastMessage(
            "|cff00ff00[World]|r |cffff0000You don't have |cffff0000|cff00ff00 " ..
            GetItemLink(itemRequired) .. " |cffff0000 |cffff0000in your inventory!"
        )
    else
        player:RemoveItem(itemRequired, 1)
        player:RemoveSpell(spellId)
        player:SaveToDB()
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You have removed your racial!")
    end
end

local function showWindowPls(event, player, command)
    if (command == "rs") then
        AIO.Handle(player, "racialSwitch", "MyAddonFrame")
        return false
    end
end

RegisterPlayerEvent(42, showWindowPls)
