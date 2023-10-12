local mythic = {}
-- local npcEntry = 182773
-- local npcEntry = 500156
local npcEntry = 500171

local mythicItemRequired = 76509


-- CREATE TABLE IF NOT EXISTS `custom_mythic_dungeon` (
--   `guid` int(10) unsigned NOT NULL,
--   `level` int(10) unsigned NOT NULL,
--   `mythicFlag` tinyint(3) unsigned NOT NULL DEFAULT '0'
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- mythicFlag
-- 0 = attempt to enter in a dungeon
-- 1 = is on dungeon
-- 2 = as start a timer

-- mythic.AffixRandom = {
--     48161, 48469

-- }

-- 82189 - Mythic I (Affixes)
-- 82190- Mythic II (Affxes)
-- 82191- Mythic Ill (Affixes)
-- 82192 - Mythic IV (Affixes)
-- 82193 - Mythic V (Affixes)
-- 82194 - Myt1ic VI (Affixes)
-- 82195 - Mytiic VII (Affixes)
-- 82196 - VIII (Affixes)
-- 82197 - IX (Affixes)
-- 82198 - My+icX (Affixes)
mythic.Affix = {
    -- Level is [1]
    -- Affix List is {123}
    -- [1] = { 23738, },                     -- affix level 1
    -- [2] = { 23738, 23737 },               -- affix level 2
    -- [3] = { 23738, 23737, 34767 },        -- affix level 3
    -- [4] = { 23738, 23737, 34767, 23768 }, -- affix level 4
    -- [5] = { 48161, 15473 },               -- affix level 5
    -- add more entries for higher affix levels
    [1] = { 82189 },
    [2] = { 82190 },
    [3] = { 82191 },
    [4] = { 82192 },
    [5] = { 82193 },
    [6] = { 82194 },
    [7] = { 82195 },
    [8] = { 82196 },
    [9] = { 82197 },
    [10] = { 82198 },
}

mythic.AffixLoot = {
    [1] = { item1 = 4540, quantity1 = 1, item2 = 4554, quantity2 = 1 }, -- affix level 1
    [2] = { item1 = 4540, quantity1 = 2, item2 = 4554, quantity2 = 2 }, -- affix level 2
    [3] = { item1 = 4540, quantity1 = 3, item2 = 4554, quantity2 = 3 }, -- affix level 3
    [4] = { item1 = 4540, quantity1 = 4, item2 = 4554, quantity2 = 4 }, -- affix level 4


    -- add more entries for higher affix levels
}

mythic.blockCreature = {
    416, 1860, 1863, 417, 17252
}

mythic.bosses = {
    27960
}
mythic.lastBoss = {
    27971
}

local CREATURE_EVENT_ON_DIED = 4 -- (event, creature, killer) - Can return true to stop normal action


function mythic.normalBoss(event, creature, killer)
    local range, isHostile, isDead = 999, 0, 0
    local players = creature:GetPlayersInRange(range, isHostile, isDead)
    local mythicLevel = killer:GetData("mythicLevel")
    if mythicLevel then
        local affixLoot = mythic.AffixLoot[mythicLevel]
        if affixLoot then
            -- add loot corresponding to the affix level
            for _, player in pairs(players) do
                player:AddItem(affixLoot.item1, affixLoot.quantity1)
            end
        end
    end
end

for _, v in pairs(mythic.bosses) do
    RegisterCreatureEvent(v, CREATURE_EVENT_ON_DIED, mythic.normalBoss)
end

function mythic.lootDrop(event, creature, killer)
    local range, isHostile, isDead = 999, 0, 0
    local players = creature:GetPlayersInRange(range, isHostile, isDead)
    local mythicLevel = killer:GetData("mythicLevel")
    if mythicLevel then
        local affixLoot = mythic.AffixLoot[mythicLevel]
        if affixLoot then
            -- add loot corresponding to the affix level
            for _, player in pairs(players) do
                player:AddItem(affixLoot.item2, affixLoot.quantity2)
            end
        end
    end
end

for _, v in pairs(mythic.lastBoss) do
    RegisterCreatureEvent(v, CREATURE_EVENT_ON_DIED, mythic.lootDrop)
end


-------------------------------
-- [npc start]
-------------------------------
local function creatureOnSpawn(event, creature)
    creature:SetFaction(35)
    creature:SetNPCFlags(3)
end



local GOSSIP_EVENT_ON_HELLO = 1
local GOSSIP_EVENT_ON_SELECT = 2
local CREATURE_EVENT_ON_SPAWN = 5

local menuId = 0x7FFFFFFF

local function helloOnVendor(event, player, object)
    -- show what current mythic level is
    local mythicLevel = player:GetData("mythicLevel")
    if mythicLevel then
        player:GossipSetText(string.format("You are in Mythic +" .. mythicLevel .. " dungeon.\n \n\n "))
    else
        player:GossipSetText(string.format("You are in Mythic +1 dungeon.\n \n\n "))
    end

    if player:HasItem(mythicItemRequired) then
        player:GossipMenuAddItem(0, "|TInterface/Icons/inv_relics_hourglass:24:24|tStart", 0, 1)
    end

    -- player:GossipMenuAddItem(0, "|TInterface/Icons/inv_relics_hourglass:24:24|tIncrease Keystone", 0, 1)
    -- player:GossipMenuAddItem(0, "Decrease Keystone", 0, 2)
    -- player:GossipMenuAddItem(0, "Reset to 1", 0, 3)

    player:GossipMenuAddItem(0, "Close ", 0, 999)
    player:GossipSendMenu(menuId, object)
end

local function vendorOnSelection(event, player, object, sender, intid, code)
    local group = player:GetGroup()
    if (intid == 1) then
        local mythicLevel = player:GetData("mythicLevel")
        if mythicLevel then
            if mythicLevel < 100 then
                -- update all in group to the same level
                if group then
                    for key, players in pairs(group:GetMembers()) do
                        players:SetData("mythicLevel", mythicLevel + 1)
                        players:SendAreaTriggerMessage("You are in Mythic +" ..
                            players:GetData("mythicLevel") .. " dungeon.")
                        players:SaveToDB()
                    end
                end
            else
                player:SendAreaTriggerMessage("You are in Mythic +" .. player:GetData("mythicLevel") .. " dungeon.")
            end
        else
            player:SetData("mythicLevel", 1)
            player:SendAreaTriggerMessage("You are in Mythic +" .. player:GetData("mythicLevel") .. " dungeon.")
        end
        player:SaveToDB()
        helloOnVendor(event, player, object)
        -- player:GossipComplete()
    elseif (intid == 2) then
        local mythicLevel = player:GetData("mythicLevel")
        if mythicLevel then
            if mythicLevel > 1 then
                -- update all in group to the same level
                if group then
                    for key, players in pairs(group:GetMembers()) do
                        players:SetData("mythicLevel", mythicLevel - 1)
                        players:SendAreaTriggerMessage("You are in Mythic +" ..
                            players:GetData("mythicLevel") .. " dungeon.")
                        players:SaveToDB()
                    end
                end
            else
                player:SendAreaTriggerMessage("You are in Mythic +" .. player:GetData("mythicLevel") .. " dungeon.")
            end
        else
            player:SetData("mythicLevel", 1)
            player:SendAreaTriggerMessage("You are in Mythic +" .. player:GetData("mythicLevel") .. " dungeon.")
        end
        player:SaveToDB()
        helloOnVendor(event, player, object)
        -- player:GossipComplete()
    elseif (intid == 3) then
        player:SetData("mythicLevel", 1)
        player:SendAreaTriggerMessage("You are in Mythic +" .. player:GetData("mythicLevel") .. " dungeon.")
        player:SaveToDB()
        helloOnVendor(event, player, object)
        -- player:GossipComplete()
    elseif (intid == 999) then
        player:GossipComplete()
    end
end

RegisterCreatureEvent(npcEntry, CREATURE_EVENT_ON_SPAWN, creatureOnSpawn)
RegisterCreatureGossipEvent(npcEntry, GOSSIP_EVENT_ON_HELLO, helloOnVendor)
RegisterCreatureGossipEvent(npcEntry, GOSSIP_EVENT_ON_SELECT, vendorOnSelection)

-------------------------------
-- [npc end]
-------------------------------


-- -- on login set the data
-- function mythic.OnLogin(event, player)
--     local guid = player:GetGUIDLow()
--     local result = CharDBQuery("SELECT * FROM custom_mythic_dungeon WHERE guid = " .. guid .. ";")
--     if result then
--         player:SetData("mythicLevel", result:GetUInt32(1))
--         player:SetData("mythicFlag", result:GetUInt32(2))
--         -- player:SetData("mythicTimer", result:GetUInt32(3))
--     else
--         CharDBExecute("INSERT INTO custom_mythic_dungeon VALUES (" .. guid .. ", 0, 0, 0);")
--         player:SetData("mythicLevel", 0)
--         player:SetData("mythicFlag", 0)
--         -- player:SetData("mythicTimer", 0)
--     end
-- end

-- -- on login set the data
-- function mythic.OnLogin(event, player)
--     local guid = player:GetGUIDLow()
--     local result = CharDBQuery("SELECT * FROM custom_mythic_dungeon WHERE guid = " .. guid .. ";")
--     if result then
--         player:SetData("mythicLevel", result:GetUInt32(1))
--         player:SetData("mythicFlag", result:GetUInt32(2))
--         -- player:SetData("mythicTimer", result:GetUInt32(3))
--     else
--         CharDBExecute("INSERT INTO custom_mythic_dungeon VALUES (" .. guid .. ", 0, 0, 0);")
--         player:SetData("mythicLevel", 0)
--         player:SetData("mythicFlag", 0)
--         -- player:SetData("mythicTimer", 0)
--     end
-- end

-- RegisterPlayerEvent(3, mythic.OnLogin)


-- gets data from sql on reload or server start
function mythic.OnLogin(event, player)
    -- if table empty set to level 1
    if not mythic.Affix[player:GetData("mythicLevel")] then
        player:SetData("mythicLevel", 1)
    end
    local guid = player:GetGUIDLow()
    local result = CharDBQuery("SELECT * FROM custom_mythic_dungeon WHERE guid = " .. guid .. ";")
    if result then
        player:SetData("mythicLevel", result:GetUInt32(1))
        player:SetData("mythicFlag", result:GetUInt32(2))
        -- player:SetData("mythicTimer", result:GetUInt32(3))
    else
        CharDBExecute("INSERT INTO custom_mythic_dungeon VALUES (" .. guid .. ", 0, 0, 0);")
        player:SetData("mythicLevel", 0)
        player:SetData("mythicFlag", 0)
        -- player:SetData("mythicTimer", 0)
    end
end

RegisterPlayerEvent(3, mythic.OnLogin)

local ELUNA_EVENT_ON_LUA_STATE_OPEN = 33 -- (event) - triggers after all scripts are loaded
function mythic.OnReload(event)
    local players = GetPlayersInWorld()
    for _, player in pairs(players) do
        -- if table empty set to level 1
        if not mythic.Affix[player:GetData("mythicLevel")] then
            player:SetData("mythicLevel", 1)
        end
        local guid = player:GetGUIDLow()
        local result = CharDBQuery("SELECT * FROM custom_mythic_dungeon WHERE guid = " .. guid .. ";")
        if result then
            player:SetData("mythicLevel", result:GetUInt32(1))
            player:SetData("mythicFlag", result:GetUInt32(2))
            -- player:SetData("mythicTimer", result:GetUInt32(3))
        else
            CharDBExecute("INSERT INTO custom_mythic_dungeon VALUES (" .. guid .. ", 0, 0, 0);")
            player:SetData("mythicLevel", 0)
            player:SetData("mythicFlag", 0)
            -- player:SetData("mythicTimer", 0)
        end
    end
end

RegisterServerEvent(ELUNA_EVENT_ON_LUA_STATE_OPEN, mythic.OnReload)

-- -- on logout save the data
-- function mythic.OnLogout(event, player)
--     local guid = player:GetGUIDLow()
--     local level = player:GetData("mythicLevel")
--     local flag = player:GetData("mythicFlag")
--     -- local timer = player:GetData("mythicTimer")
--     CharDBExecute("UPDATE custom_mythic_dungeon SET level = " .. level .. " WHERE guid = " .. guid .. ";")
-- end

-- on logout save the data
function mythic.OnLogout(event, player)
    local guid = player:GetGUIDLow()
    local level = player:GetData("mythicLevel")
    local flag = player:GetData("mythicFlag")
    -- local timer = player:GetData("mythicTimer")
    -- if table empty set to level 1
    if not mythic.Affix[player:GetData("mythicLevel")] then
        player:SetData("mythicLevel", 1)
    end
    CharDBExecute("UPDATE custom_mythic_dungeon SET level = " .. level .. " WHERE guid = " .. guid .. ";")
end

RegisterPlayerEvent(4, mythic.OnLogout)






-- on death reset the data
function mythic.OnDeath(event, player)
    player:SetData("mythicFlag", 0)
    -- player:SetData("mythicTimer", 0)
end

RegisterPlayerEvent(6, mythic.OnDeath)


function mythic.setMythicLevel(event, player, msg, Type, lang)
    local command = string.lower(string.sub(msg, 1, 8))

    mythic.subcommand = {
        ["setlevel"] = {
            enabled = true,
            gmRankRequired = 0,
            description = "Set the mythic level of the player, the level must be between 1 and " .. #mythic.Affix .. ".",
            execute = function(settolevel)
                print("settolevel: " .. settolevel .. ".) ")
                local level = tonumber(settolevel)
                print("level: " .. level .. ".) ")
                if level and level > 0 and level <= #mythic.Affix then
                    CharDBExecute("UPDATE custom_mythic_dungeon SET level = " ..
                        level .. " WHERE guid = " .. player:GetGUIDLow() .. ";")
                    player:SetData("mythicLevel", level)
                    player:SendBroadcastMessage("Your mythic level has been set to " .. level)
                else
                    player:SendBroadcastMessage("Invalid mythic level. Please enter a number between 1 and " ..
                        #mythic.Affix)
                end
                player:SaveToDB()
            end
        },
        ["showCurrent"] = {
            -- get the current mythic level of the player
            enabled = true,
            gmRankRequired = 0,
            description = "Show the current mythic level of the player.",
            execute = function()
                player:SendBroadcastMessage("Your current mythic level is " .. player:GetData("mythicLevel"))
            end

        }
    }
    if (string.lower(string.sub(msg, 1, 8)) == "#mythic ") then -- if the first
        local map = player:GetMap()
        local isDungeon = map:IsDungeon()
        if (isDungeon) then -- if the player is inside a dungeon
            player:SendBroadcastMessage("You cannot use this command inside a dungeon.")
            return false
        end

        -- 8 characters of the
        -- message are
        -- "#mythic "
        local subcommand = string.lower(string.sub(msg, 9)) -- get the subcommand
        -- (everything after
        -- "#mythic ")
        local subcommand = string.match(subcommand, "%S+") -- get the first word of
        -- the subcommand
        -- (everything before
        -- the first space)
        if (subcommand) then                                    -- if the subcommand exists
            if (mythic.subcommand[subcommand]) then             -- if the subcommand exists in
                -- the table
                if (mythic.subcommand[subcommand].enabled) then -- if the subcommand is
                    -- enabled
                    if (mythic.subcommand[subcommand].gmRankRequired == 0 or player:GetGMRank() >=
                            mythic.subcommand[subcommand].gmRankRequired) then -- if the player has the required
                        -- GM rank to execute the
                        -- subcommand
                        local subcommandArgs = string.sub(msg, 9 + string.len(subcommand) + 1) -- get the
                        -- subcommand
                        -- arguments
                        -- (everything
                        -- after the
                        -- subcommand)
                        if (subcommandArgs) then                                  -- if the subcommand has arguments
                            mythic.subcommand[subcommand].execute(subcommandArgs) -- execute the
                            -- subcommand
                            -- with the
                            -- arguments
                        else                                        -- if the subcommand doesn"t have arguments
                            mythic.subcommand[subcommand].execute() -- execute the
                            -- subcommand
                        end
                    else -- if the player doesn"t have the required GM rank to execute the
                        -- subcommand
                        player:SendBroadcastMessage("You don't have the required GM rank to execute this subcommand.")
                    end
                else -- if the subcommand is disabled
                    player:SendBroadcastMessage("This subcommand is disabled.")
                end
            else -- if the subcommand doesn"t exist in the table
                player:SendBroadcastMessage("This subcommand doesn't exist.")
            end
        else -- if the subcommand doesn"t exist
            player:SendBroadcastMessage("You must specify a subcommand.")
        end
        return false
    end
end

RegisterPlayerEvent(18, mythic.setMythicLevel)



-- if critter then dont buff  CREATURE_TYPE_CRITTER          = 8,
local CREATURE_TYPE_CRITTER = 8
function mythic.setAllAffix(player, creature)
    local affixes = {}
    local map = player:GetMap()       -- get the map the player is in
    local isDungeon = map:IsDungeon() -- check if the map is a dungeon
    if not isDungeon then             -- if the map is not a dungeon
        return                        -- stop the function
    end
    if creature:GetCreatureType() == CREATURE_TYPE_CRITTER then
        return
    end




    local mythicLevel = player:GetData("mythicLevel")
    --    if mythic level change remove all affixes and add new ones
    if mythicLevel ~= creature:GetData("mythicLevel") then
        creature:RemoveAllAuras()
        creature:SetData("mythicLevel", mythicLevel)
    end
    -- check if correct level and auras are active if not remove and add new ones
    for key, spellId in pairs(mythic.Affix[player:GetData("mythicLevel")]) do
        local hasAura = creature:HasAura(spellId)
        if not hasAura then
            table.insert(affixes, spellId)
        end
    end

    for _, spellId in ipairs(affixes) do
        -- if creature entry is 416 then dont add buffs to it
        -- for _, v in pairs(mythic.blockCreature) do
        --     if creature:GetEntry() == v then
        --         return
        --     end
        -- end
        local isElite = creature:IsElite()
        if isElite then
            creature:CastSpell(creature, spellId, true)
        end
    end
end

function mythic.buffLoop(event, delay, repeats, player)
    for positionInTable, creature in pairs(player:GetCreaturesInRange(100)) do
        if creature then
            -- check correct level and auras are active if not remove and add new ones
            mythic.setAllAffix(player, creature)
        end
    end
end

--
function mythic.onEnterDungeon(event, player)
    local map = player:GetMap()
    local isDungeon = map:IsDungeon()



    if isDungeon then
        if player:GetData("mythicFlag") == 0 then
            print("Enter in dungeon   " .. player:GetName())
            local group = player:GetGroup()

            local tempPlayer = player
            if group and not mythic[group:GetGUID()] then
                player = GetPlayerByGUID(group:GetLeaderGUID())
            end
            tempPlayer:SendAreaTriggerMessage("You are in Mythic +" .. player:GetData("mythicLevel") .. " dungeon.")

            player = tempPlayer
            tempPlayer = nil

            player:RemoveEvents()


            player:RegisterEvent(mythic.buffLoop, { 1000, 1000 }, 0)
            -- player:RegisterEvent(mythic.buffRandomAffix, { 1000, 1000 }, 0)
            player:SetData("mythicFlag", 1)
        end
    else
        if player:GetData("mythicFlag") then
            player:SetData("mythicFlag", nil)
            local group = player:GetGroup()

            if mythic[group:GetGUID()] then
                mythic.delGroupInfo(group)
            end
        end
    end
end

RegisterPlayerEvent(28, mythic.onEnterDungeon)

function mythic.onKillCreature(event, player, creature)
    local group = player:GetGroup()
    if group then
        player = GetPlayerByGUID(group:GetLeaderGUID())
    end

    if player:GetData("mythicFlag") == 1 then
        player:SetData("mythicFlag", 2)
        player:SetData("mythicStart", os.time())
    end
end

RegisterPlayerEvent(7, mythic.onKillCreature)

function mythic.onGroupLeaderChange(event, group, newLeaderGuid, oldLeaderGuid)
    GetPlayerByGUID(newLeaderGuid):SetData("mythicStart", GetPlayerByGUID(oldLeaderGuid):GetData("mythicStart"))
    GetPlayerByGUID(newLeaderGuid):SetData("mythicLevel", GetPlayerByGUID(oldLeaderGuid):GetData("mythicLevel"))

    local mythicLevel = GetPlayerByGUID(newLeaderGuid):GetData("mythicLevel")
    for key, player in pairs(group:GetMembers()) do
        player:SendAreaTriggerMessage("You are in Mythic +" .. mythicLevel .. " level group.")
    end
end

RegisterGroupEvent(4, mythic.onGroupLeaderChange)

function mythic.onNewMember(event, group, guid)
    local mythicLevel = GetPlayerByGUID(group:GetLeaderGUID()):GetData("mythicLevel")
    if not mythicLevel then
        mythicLevel = 1
    end

    -- set newmember to the same level as the leader
    GetPlayerByGUID(guid):SetData("mythicLevel", mythicLevel)



    -- save new member to db
    local result = CharDBQuery("SELECT * FROM custom_mythic_dungeon WHERE guid = " .. tostring(guid) .. ";")
    if result then
        CharDBExecute("UPDATE custom_mythic_dungeon SET level = " ..
            mythicLevel .. " WHERE guid = " .. tostring(guid) .. ";")
    else
        CharDBExecute("INSERT INTO custom_mythic_dungeon VALUES (" .. tostring(guid) .. ", " .. mythicLevel .. ", 0, 0);")
    end


    if not GetPlayerByGUID(guid):GetData("mythicFlag") then
        GetPlayerByGUID(guid):SetData("mythicFlag", 0)
    end

    GetPlayerByGUID(guid):SendAreaTriggerMessage("You are in Mythic +" .. mythicLevel .. " level group.")
    GetPlayerByGUID(guid):SaveToDB()
end

RegisterGroupEvent(1, mythic.onNewMember)



-- function mythic.getMythicLevel(event, player)
--     local mythicLevel = CharDBQuery("SELECT level FROM custom_mythic_dungeon WHERE guid = " .. player:GetGUIDLow())

--     if not mythicLevel then
--         CharDBExecute("INSERT INTO custom_mythic_dungeon (guid, level) VALUES (" .. player:GetGUIDLow() .. ", 1);")
--         player:SetData("mythicLevel", 1)
--     else
--         player:SetData("mythicLevel", mythicLevel:GetUInt32(0))
--     end
-- end

-- RegisterPlayerEvent(3, mythic.getMythicLevel)


-- if not GetPlayerByGUID(guid):GetData("mythicFlag") then
--     GetPlayerByGUID(guid):SetData("mythicFlag", 0)
-- end
-- function mythic.onEnterDungeon(event, player)
--     local map = player:GetMap()
--     local isDungeon = map:IsDungeon()

--     if isDungeon then
--         if player:GetData("mythicFlag") == 0 then
--             print("Enter in dungeon   " .. player:GetName())
--             local group = player:GetGroup()

--             if group and not mythic[group:GetGUID()] then
--                 player = GetPlayerByGUID(group:GetLeaderGUID())
--             end

--             player:SendAreaTriggerMessage("You are in Mythic +" .. player:GetData("mythicLevel") .. " dungeon.")

--             player:RemoveEvents()
--             player:RegisterEvent(mythic.buffLoop, 1000, 0)
--             player:SetData("mythicFlag", 1)
--         end
--     else
--         if player:GetData("mythicFlag") then
--             player:SetData("mythicFlag", nil)
--             local group = player:GetGroup()

--             if mythic[group:GetGUID()] then
--                 mythic.delGroupInfo(group)
--             end
--         end
--     end
-- end

-- RegisterPlayerEvent(27, mythic.onEnterDungeon)




-- function mythic.setAllAffix(player, creature)
--     for key, spellId in pairs(mythic.Affix[player:GetData("mythicLevel")]) do
--         local hasAura = creature:HasAura(spellId)
--         if not hasAura then
--             creature:CastSpell(creature, spellId, true)
--         end
--     end
-- end

-- function mythic.SetRandomAffix(player, creature)
--     local randomAffixs = {}

--     local affixSetMaxForRandom = 1 + math.floor(player:GetData("mythicLevel") / 2)
--     -- print("affixSetMaxForRandom: " .. affixSetMaxForRandom .. ".) ")
--     for i = 1, affixSetMaxForRandom do
--         local spellId = mythic.AffixRandom[math.random(#mythic.AffixRandom)]
--         table.insert(randomAffixs, spellId)
--     end

--     for _, spellId in ipairs(randomAffixs) do
--         local hasAura = creature:HasAura(spellId)
--         if not hasAura then
--             creature:CastSpell(creature, spellId, true)
--         end
--     end
-- end

-- function mythic.buffRandomAffix(event, delay, repeats, player)
--     for positionInTable, creature in pairs(player:GetCreaturesInRange(1000)) do
--         if creature then
--             mythic.SetRandomAffix(player, creature)
--         end
--     end
-- end













-- -- Sends a message to new group members indicating the Mythic+ level of the group.
-- function mythic.onNewMember(_, group, guid)
--     -- Get the Mythic+ level of the group leader.
--     local mythicLevel = GetPlayerByGUID(group:GetLeaderGUID()):GetData("mythicLevel") or 1

--     -- Send a message to the new member indicating the Mythic+ level of the group.
--     GetPlayerByGUID(guid):SendAreaTriggerMessage("You are in Mythic +" .. mythicLevel .. " level group.")

--     -- Set a default value for the mythicFlag data variable if it doesn"t exist.
--     if not GetPlayerByGUID(guid):GetData("mythicFlag") then
--         GetPlayerByGUID(guid):SetData("mythicFlag", false)
--     end
-- end

-- -- Register the onNewMember function to be called when a new member joins the group.
-- RegisterGroupEvent(1, mythic.onNewMember)
