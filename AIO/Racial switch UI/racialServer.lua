local AIO = AIO or require("AIO")

local MyHandlers = AIO.AddHandlers("racialSwitch", {})

local con = {}

con.utilityList = {
    59752,
    20572,
    20594,
    58984,
    20549,
    7744,
    20577,
    26297,
    28730,
    59542,
    2481,
    20589
}

con.passiveList = {
    20592,
    20596,
    20579,
    20551,
    822,
    20573,
    65222,
    20555,
    58943,
    20550,
    20591,
    5227,
    6562,
    20582,
    -- 21009,
    20585,
    58985,
    20599,
    20598
}
con.weapList = {
    20574,
    26290,
    20595,
    59224,
    20597,
    20558

    -- 5586,
    -- 4500,
    -- 12700,
    -- 7514,
    -- 22811
}
-- config.profList = {
--     59188,
--     20593,
--     20552,
--     28877
-- }

-- local function sendList()
--     local msg = AIO.Msg()
--     msg:Add("racialSwitch", "utilityList", AIO.unpack(con.utilityList))
--     msg:Add("racialSwitch", "passiveList", AIO.unpack(con.passiveList))
--     msg:Add("racialSwitch", "weapSpec", AIO.unpack(con.weapSpec))
--     return msg
-- end

-- AIO.AddOnInit(sendList)

--send con.utilityList to client to populate config.utilityList
--send con.passiveList to client to populate config.passiveList
--send con.weapSpec to client to populate config.weapSpec

function MyHandlers.racialActivate(player, spellId, ...)
    -- for i = 1, #utilityList do
    --     if player:HasSpell(utilityList[i]) then
    --         player:RemoveSpell(utilityList[i])
    --     end
    -- end
    -- player:LearnSpell(spellId)
    -- player:SaveToDB()

    if (player:IsInCombat() and player:InBattleground() == true) then
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
        return false
    end

    if player:HasSpell(spellId) then
        player:RemoveSpell(spellId)
    end
    player:LearnSpell(spellId)
end

function MyHandlers.racialDeactivateUtility(player, spellId, ...)
    if (player:IsInCombat() == true) then
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
        return false
    end
    for i = 1, #con.utilityList do
        if spellId == con.utilityList[i] then
            if player:HasSpell(spellId) then
                player:RemoveSpell(spellId)
            end
        end
    end
    player:SaveToDB()
end

function MyHandlers.racialDeactivatePassive(player, spellId, ...)
    if (player:IsInCombat() == true) then
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
        return false
    end
    for i = 1, #con.passiveList do
        if spellId == con.passiveList[i] then
            if player:HasSpell(spellId) then
                player:RemoveSpell(spellId)
            end
        end
    end
    player:SaveToDB()
end
function MyHandlers.racialDeactivateWeaponSpecialization(player, spellId, ...)
    if (player:IsInCombat() == true) then
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
        return false
    end
    for i = 1, #con.weapList do
        if spellId == con.weapList[i] then
            if player:HasSpell(spellId) then
                player:RemoveSpell(spellId)
            end
        end
    end
    player:SaveToDB()
end

function MyHandlers.unLearnAllRacials(player, spellId, ...)
    if (player:IsInCombat() == true) then
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
        return false
    end
    for i = 1, #con.utilityList do
        player:RemoveSpell(con.utilityList[i])
    end
    for i = 1, #con.passiveList do
        player:RemoveSpell(con.passiveList[i])
    end
    for i = 1, #con.weapList do
        player:RemoveSpell(con.weapList[i])
    end
    player:SaveToDB()
end

local function showWindowPls(event, player, command)
    if (command == "rs") then
        AIO.Handle(player, "racialSwitch", "MyAddonFrame")
        return false
    end
end
RegisterPlayerEvent(42, showWindowPls)
