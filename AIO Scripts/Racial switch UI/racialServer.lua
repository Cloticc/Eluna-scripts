local AIO = AIO or require("AIO")

local MyHandlers = AIO.AddHandlers("racialSwitch", {})

function MyHandlers.racialActivate(player, spellId, ...)
    if (player:IsInCombat() and player:InBattleground() == true) then
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
        return false
    end


    player:LearnSpell(spellId)
end

function MyHandlers.racialDeactivate(player, spellId, ...)
    if (player:IsInCombat() == true) then
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
        return false
    end

    player:RemoveSpell(spellId)


    player:SaveToDB()
end

function MyHandlers.unLearnAllRacials(player, spellId, ...)
    if (player:IsInCombat() == true) then
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
        return false
    end
    player:RemoveSpell(spellId)
    player:SaveToDB()
end

local function showWindowPls(event, player, command)
    if (command == "rs") then
        AIO.Handle(player, "racialSwitch", "MyAddonFrame")
        return false
    end
end

RegisterPlayerEvent(42, showWindowPls)
