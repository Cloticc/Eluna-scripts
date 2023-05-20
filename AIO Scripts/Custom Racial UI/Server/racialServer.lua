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
