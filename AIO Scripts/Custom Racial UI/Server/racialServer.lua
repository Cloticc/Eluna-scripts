local AIO = AIO or require("AIO")






local enableItem = false  -- set to true if you want to use an item to remove racial
local itemRequired = 4540 -- item required to remove racial
local amountRequired = 1  -- amount of item required to remove racial

local IsNpc = false       --  set to true if you want to use an npc to open UI at
local npcEntry = 50252    --  npc entry to open UI at

local racialHandler = AIO.AddHandlers("RACIAL_SERVER", {})



----------------------------------------------------------
-----------------[Npc Interaction]------------------------
----------------------------------------------------------
if IsNpc then
    local function creatureOnSpawn(event, creature) creature:SetNPCFlags(3) end

    local CREATURE_EVENT_ON_MOVE_IN_LOS = 27

    local GOSSIP_EVENT_ON_HELLO         = 1
    local GOSSIP_EVENT_ON_SELECT        = 2
    local CREATURE_EVENT_ON_SPAWN       = 5
    local menuId                        = 0x7FFFFFFF


    local isWindowOpen = false -- add this global variable



    local function creatureOnMoveInLos(event, creature, object)
        if (object:GetObjectType() == "Player") then
            if object:GetDistance(creature) < 2 then
                -- dismount player if mounted
                if object:IsMounted() then
                    object:Dismount()
                end
                return false
            end
            if object:GetDistance(creature) > 2 then
                if isWindowOpen then     -- add this check to only close the window when it's open
                    AIO.Handle(object, "RACIAL_CLIENT", "racialCloseUI")
                    isWindowOpen = false -- set the global variable to false when the window is closed
                end
                return false
            elseif isWindowOpen then -- add this check to only execute the rest of the function when the window is open
                return false
            end
        end
    end

    local function helloOnVendor(event, player, object)
        if (player:IsInCombat() and player:InBattleground() == true) then
            player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
            return false
        end

        AIO.Handle(player, "RACIAL_CLIENT", "racialOpenUI")
        isWindowOpen = true -- set the global variable to true when the window is opened
        -- player:GossipSendMenu(menuId, object)
    end

    -- local function vendorOnSelection(event, player, object, sender, intid, code)
    --     if (intid == 1) then
    --         -- send menu for racial change

    --         AIO.Handle(player, "RACIAL_CLIENT", "racialOpenUI")
    --         player:GossipComplete()
    --     elseif (intid == 2) then -- add this line to handle the new option
    --         -- AIO.Handle(player, "RACIAL_SERVER", "racialOpenUI")
    --         player:GossipComplete()
    --     elseif (intid == 999) then
    --         player:GossipComplete()
    --     end
    -- end

    RegisterCreatureEvent(npcEntry, CREATURE_EVENT_ON_MOVE_IN_LOS, creatureOnMoveInLos)
    RegisterCreatureEvent(npcEntry, CREATURE_EVENT_ON_SPAWN, creatureOnSpawn)
    RegisterCreatureGossipEvent(npcEntry, GOSSIP_EVENT_ON_HELLO, helloOnVendor)
    -- RegisterCreatureGossipEvent(npcEntry, GOSSIP_EVENT_ON_SELECT, vendorOnSelection)
end
----------------------------------------------------------
-----------------[End of Interaction]---------------------
----------------------------------------------------------

local function hasRequiredItem(player)
    if enableItem then
        return player:HasItem(itemRequired)
    else
        return true
    end
end




-- function racialHandler.checkSpell(player, spellId, itemType)
--     local hasSpellOrItem

--     if itemType == "spell" then
--         hasSpellOrItem = player:HasSpell(spellId)
--     elseif itemType == "item" then
--         hasSpellOrItem = player:HasItem(spellId)
--     end

--     -- Send the response back to the client
--     AIO.Handle(player, "racialHandler", "updateOverlay", spellId, hasSpellOrItem)
-- end

function racialHandler.racialActivate(player, spellId, itemType)
    if (player:IsInCombat() and player:InBattleground() == true) then
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
        return false
    end

    -- check if has item before adding item or spell that being sent



    if itemType == "spell" then
        if player:HasSpell(spellId) then
            player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You already have this racial!")
            return false
        end
        player:LearnSpell(spellId)
    elseif itemType == "item" then
        -- check if has item
        if player:HasItem(spellId) then
            player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You already have this racial item!")
            return false
        end
        player:AddItem(spellId, 1)
    end
    player:SaveToDB()
end

function racialHandler.racialDeactivate(player, spellId, itemType)
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
        if itemType == "spell" then
            player:RemoveSpell(spellId)
        elseif itemType == "item" then
            player:RemoveItem(spellId, 1)
        end

        player:RemoveItem(itemRequired, amountRequired)

        player:SaveToDB()
        -- player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You have removed your racial!")
    end
end

function racialHandler.unLearnAllRacials(player, spellId, itemType)
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
        if itemType == "spell" then
            player:RemoveSpell(spellId)
        elseif itemType == "item" then
            player:RemoveItem(spellId, 1)
            player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000 have removed " ..
                GetItemLink(spellId) .. " |cffff0000Racial item!")
        end

        player:RemoveItem(itemRequired, amountRequired)


        player:SaveToDB()
    end
end

local function showWindowPls(event, player, command)
    if (command == "rc") then
        AIO.Handle(player, "RACIAL_CLIENT", "racialOpenUI")
        return false
    end
end

RegisterPlayerEvent(42, showWindowPls)



-- -------------------------------
-- -- [Old]
-- local enableItem = true
-- local itemRequired = 5140

-- -------------------------------



-- function racialHandler.racialActivate(player, spellId, ...)
--     if (player:IsInCombat() and player:InBattleground() == true) then
--         player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
--         return false
--     end

--     player:LearnSpell(spellId)

--     player:SaveToDB()
-- end

-- function racialHandler.racialDeactivate(player, spellId, ...)
--     if (player:IsInCombat() and player:InBattleground() == true) then
--         player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
--         return false
--     end

--     if (enableItem) then
--         player:SendBroadcastMessage(
--             "|cff00ff00[World]|r |cffff0000You don't have |cffff0000|cff00ff00 " ..
--             GetItemLink(itemRequired) .. " |cffff0000 |cffff0000in your inventory!"
--         )
--     else
--         if player:HasItem(itemRequired) then
--             player:RemoveItem(itemRequired, 1)
--             player:RemoveSpell(spellId)
--             player:SaveToDB()
--             player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You have removed your racial!")
--         end
--     end
-- end

-- function racialHandler.unLearnAllRacials(player, spellId)
--     if (player:IsInCombat() and player:InBattleground() == true) then
--         player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
--         return false
--     end
--     if (enableItem) then
--         player:SendBroadcastMessage(
--             "|cff00ff00[World]|r |cffff0000You don't have |cffff0000|cff00ff00 " ..
--             GetItemLink(itemRequired) .. " |cffff0000 |cffff0000in your inventory!"
--         )
--     else
--         if player:HasItem(itemRequired) then
--             player:RemoveItem(itemRequired, 1)
--             player:RemoveSpell(spellId)
--             player:SaveToDB()
--             player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You have removed your racial!")
--         end
--     end
-- end




-------------------------------
-- [xXx]
-------------------------------






-- local racialHandler = AIO.AddHandlers("RACIAL_SERVER", {})
-- -- local racialDataToSend = GetRacialData()
-- -- local racialSpellsToSend = GetRacialSpells()
-- -- function SendRacialDataToClient(player)
-- --     local racialDataToSend = GetRacialData()
-- --     local racialSpellsToSend = GetRacialSpells()

-- --     AIO.Handle(player, "RACIAL_CLIENT", "UpdateRacialData", racialDataToSend, racialSpellsToSend)
-- -- end

-- function racialHandler.racialDataToClient()
--     AIO.Handle("RACIAL_CLIENT", "racialDataToClient", GetRacialData(), GetRacialSpells())
-- end

-- racialHandler.racialDataToClient()



-- -- To send the racial data and spells cache to a player when they log in, you can hook into the OnLogin event and call the racialDataToClient function:
-- local function OnLogin(event, player)
--     racialHandler.racialDataToClient()
-- end

-- RegisterPlayerEvent(42, OnLogin)




-- local racialData = GetRacialData()
-- local racialSpells = GetRacialSpells()




-- function racialHandler.OnPlayerLogin(event, player)
--     racialHandler.SendRacialData(player)
-- end

-- function racialHandler.OnPlayerLogout(event, player)
--     player:SaveToDB()
-- end

-- function racialHandler.OnPlayerEnterWorld(event, player)
--     player:SaveToDB()
-- end

-- function racialHandler.SendRacialData(player)
--     local racialDataToSend = {}
--     for tab_id, data in pairs(racialData) do
--         racialDataToSend[tab_id] = {
--             name = data.name,
--             max_active = data.max_active
--         }
--         print(data.name, data.max_active)
--     end

--     local racialSpellsToSend = {}
--     for tab_id, spells in pairs(racialSpells) do
--         racialSpellsToSend[tab_id] = {}
--         for _, spell in ipairs(spells) do
--             print(spell.tab_id, spell.id, spell.spell_id, spell.itemType, spell.costType, spell.cost)
--             table.insert(racialSpellsToSend[tab_id], {
--                 tab_id = spell.tab_id,
--                 id = spell.id,
--                 spell_id = spell.spell_id,
--                 itemType = spell.itemType,
--                 costType = spell.costType,
--                 cost = spell.cost
--             })
--         end
--     end


--     AIO.Handle(player, "racialHandler", "UpdateRacialData", racialDataToSend, racialSpellsToSend)
-- end

-- racialHandler.SendRacialData()



-- function MyHandlers.racialDeactivatePassive(player, spellId, ...)
--     if (player:IsInCombat() == true) then
--         player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
--         return false
--     end
--     for i = 1, #con.passiveList do
--         if spellId == con.passiveList[i] then
--             if player:HasSpell(spellId) then
--                 player:RemoveSpell(spellId)
--             end
--         end
--     end
--     player:SaveToDB()
-- end
-- function MyHandlers.racialDeactivateWeaponSpecialization(player, spellId, ...)
--     if (player:IsInCombat() == true) then
--         player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
--         return false
--     end
--     for i = 1, #con.weaponList do
--         if spellId == con.weaponList[i] then
--             if player:HasSpell(spellId) then
--                 player:RemoveSpell(spellId)
--             end
--         end
--     end
--     player:SaveToDB()
-- end
