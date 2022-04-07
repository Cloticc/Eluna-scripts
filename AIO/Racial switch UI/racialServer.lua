local AIO = AIO or require("AIO")

local MyHandlers = AIO.AddHandlers("racialSwitch", {})

local racialUtilityList = {
    20572,
    59752,
    20594,
    58984,
    20549,
    7744,
    26297,
    28730,
    59542,
    7
}

local racialPassiveList = {
    20573,
    65222,
    20555,
    58943,
    20550,
    822,
    20591,
    20592,
    7744,
    5227,
    6562,
    20582,
    20551,
    21009,
    20585,
    20596,
    58985,
    20599,
    20598
}

function MyHandlers.racialActivate(player, spellId)
    print("Start")

    print("Learn " .. spellId)

    player:LearnSpell(spellId)

    print("End")

end

function MyHandlers.racialDeactivate(player, spellId)
    print("Start")

    print("Unlearn " .. spellId)

    player:RemoveSpell(spellId)

    print("End")

end

function MyHandlers.unLearnAllRacials(player, spellId)


    for i = 1, #racialUtilityList do
        print("Unlearn " .. racialUtilityList[i])
        player:RemoveSpell(racialUtilityList[i])
    end
    for i = 1, #racialPassiveList do
        print("Unlearn " .. racialPassiveList[i])
        player:RemoveSpell(racialPassiveList[i])
    end



end

local function showWindowPls(event, player, command)
    if (command == "tt") then
        AIO.Handle(player, "racialSwitch", "MyAddonFrame")
        return false
    end
end
RegisterPlayerEvent(42, showWindowPls)
