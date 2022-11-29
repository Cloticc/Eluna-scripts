local msgItemSlot = "slotitem"
local msgHelpSlot = "slothelp"
--[[
.slothelp will show u the intid that is used for each spec.

used for pushing gear to a table made with "slotitem table": example .slotitem custom_gear_equip
after table is created u can do slotitem custom_gear_equip Hunter 8 the following gear u have on u will be sent to table in db.
One all above i done get the other script and set the  local sqlWordldTableName = "custom_gear_equip"


 ]]



local slotGearId = {}
local DbItems = {}
local PLAYER_EVENT_ON_CHAT = 42
local FILE_NAME = string.match(debug.getinfo(1, "S").source, "[^/\\]*.lua$")
local function createTabel(tabelName)
    local query = "CREATE TABLE IF NOT EXISTS " .. tabelName .. " ("
    query = query .. "`id` int(11) NOT NULL AUTO_INCREMENT,"
    query = query .. "`name` varchar(255) NOT NULL,"
    query = query .. "`head` int(11) DEFAULT 0,"
    query = query .. "`neck` int(11) DEFAULT 0,"
    query = query .. "`shoulder` int(11) DEFAULT 0,"
    query = query .. "`shirt` int(11) DEFAULT 0,"
    query = query .. "`chest` int(11) DEFAULT 0,"
    query = query .. "`waist` int(11) DEFAULT 0,"
    query = query .. "`legs` int(11) DEFAULT 0,"
    query = query .. "`feet` int(11) DEFAULT 0,"
    query = query .. "`wrist` int(11) DEFAULT 0,"
    query = query .. "`hands` int(11) DEFAULT 0,"
    query = query .. "`finger1` int(11) DEFAULT 0,"
    query = query .. "`finger2` int(11) DEFAULT 0,"
    query = query .. "`trinket1` int(11) DEFAULT 0,"
    query = query .. "`trinket2` int(11) DEFAULT 0,"
    query = query .. "`back` int(11) DEFAULT 0,"
    query = query .. "`mainhand` int(11) DEFAULT 0,"
    query = query .. "`offhand` int(11) DEFAULT 0,"
    query = query .. "`ranged` int(11) DEFAULT 0,"
    query = query .. "`tabard` int(11) DEFAULT 0,"
    query = query .. "PRIMARY KEY (`id`)"
    query = query .. ") ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;"

    local result = WorldDBQuery(query)
    if result then
        print("Tabel " .. tabelName .. " created")
    end
end

-- if not createTabel("slotGearId") then
--     print("Tabel created")
-- end

function slotGearId.updateTabel(tabelName, fileName, intId)
    for dbSlot, dbItem in pairs(DbItems) do
        -- for dbSlot, dbItem in pairs(DbItems) do
        -- print(dbSlot, dbItem)
        if dbSlot == 0 then
            dbSlot = "head"
        elseif dbSlot == 1 then
            dbSlot = "neck"
        elseif dbSlot == 2 then
            dbSlot = "shoulder"
        elseif dbSlot == 3 then
            dbSlot = "shirt"
        elseif dbSlot == 4 then
            dbSlot = "chest"
        elseif dbSlot == 5 then
            dbSlot = "waist"
        elseif dbSlot == 6 then
            dbSlot = "legs"
        elseif dbSlot == 7 then
            dbSlot = "feet"
        elseif dbSlot == 8 then
            dbSlot = "wrist"
        elseif dbSlot == 9 then
            dbSlot = "hands"
        elseif dbSlot == 10 then
            dbSlot = "finger1"
        elseif dbSlot == 11 then
            dbSlot = "finger2"
        elseif dbSlot == 12 then
            dbSlot = "trinket1"
        elseif dbSlot == 13 then
            dbSlot = "trinket2"
        elseif dbSlot == 14 then
            dbSlot = "back"
        elseif dbSlot == 15 then
            dbSlot = "mainhand"
        elseif dbSlot == 16 then
            dbSlot = "offhand"
        elseif dbSlot == 17 then
            dbSlot = "ranged"
        elseif dbSlot == 18 then
            dbSlot = "tabard" or "Item"
        end
        -- print("dbSlot: " .. dbSlot .. " dbItem: " .. dbItem)

        local updateString =
        "INSERT INTO " ..
            tabelName ..
            " (id, name, " ..
            dbSlot ..
            ") VALUES (" ..
            intId ..
            ", '" ..
            fileName ..
            "', " ..
            dbItem ..
            ") ON DUPLICATE KEY UPDATE name" ..
            " = '" .. fileName .. "', " .. dbSlot .. " = " .. dbItem .. ";"
        -- local updateString = "UPDATE " ..
        --     tabelName ..
        --     " SET name = '" .. fileName .. "', " .. dbSlot .. " = " .. dbItem .. " WHERE id = " .. intId .. ";"

        -- local insertString = "INSERT INTO " ..
        --     tabelName ..
        --     " (id, name, " .. dbSlot .. ") VALUES (" .. intId .. ", '" .. fileName .. "', " .. dbItem .. ");"



        local result = WorldDBQuery(updateString)
        if result then
            print("Tabel " .. tabelName .. " updated")
        end


        DbItems = {}
    end
end

local function splitString(str, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(
        pattern,
        function(c)
            fields[#fields + 1] = c
        end
    )
    return fields
end

local function getSlotItems(event, player, msg, Type, lang)
    if (msg:find(msgHelpSlot)) then
        player:SendBroadcastMessage(" warrior arms: 1\n warrior fury: 2\n warrior protection: 3\n paladin holy: 4\n paladin protection: 5\n paladin retribution: 6\n hunter beast mastery: 7\n hunter marksmanship: 8\n hunter survival: 9\n rogue assassination: 10\n rogue combat: 11\n rogue sublety: 12\n priest discipline: 13\n priest holy   : 14\n priest shadow: 15\n deathknight blood: 16\n deathknight frost: 17\n deathknight unholy: 18\n shaman elemental: 19\n shaman enhancement: 20\n shaman restoration: 21\n mage arcane: 22\n mage fire: 23\n mage frost: 24\n warlock affliction: 25\n warlock demonology: 26\n warlock destruction: 27\n druid balance: 28\n druid feral: 29\ndruid restoration: 30 \n druid guardian: 31")
        return false

    end
    if (msg:find(msgItemSlot)) then
        if not player:IsGM() then
            return false

        end



        splitString(msg, " ")
        local tabelName = splitString(msg, " ")[2]
        local fileName = splitString(msg, " ")[3]
        local intId = splitString(msg, " ")[4]

        if tabelName and not fileName then
            createTabel(tabelName)
            return false
        end
        -- player:SendBroadcastMessage("past the second with creating a table if not exist")
        slotGearId.updateTabel(tabelName, fileName, intId)


        -- If the player doesn't have a target, set the target to the player.
        local selectTarget = player:GetSelection()
        if (not selectTarget) then
            selectTarget = player
        end
        -- player:SendBroadcastMessage("past the third sel tar")
        for slotIds = 1, 19 do
            if slotIds == 1 then
                slotIds = 0
            elseif slotIds == 2 then
                slotIds = 1
            elseif slotIds == 3 then
                slotIds = 2
            elseif slotIds == 4 then
                slotIds = 3
            elseif slotIds == 5 then
                slotIds = 4
            elseif slotIds == 6 then
                slotIds = 5
            elseif slotIds == 7 then
                slotIds = 6
            elseif slotIds == 8 then
                slotIds = 7
            elseif slotIds == 9 then
                slotIds = 8
            elseif slotIds == 10 then
                slotIds = 9
            elseif slotIds == 11 then
                slotIds = 10
            elseif slotIds == 12 then
                slotIds = 11
            elseif slotIds == 13 then
                slotIds = 12
            elseif slotIds == 14 then
                slotIds = 13
            elseif slotIds == 15 then
                slotIds = 14
            elseif slotIds == 16 then
                slotIds = 15
            elseif slotIds == 17 then
                slotIds = 16
            elseif slotIds == 18 then
                slotIds = 17
            elseif slotIds == 19 then
                slotIds = 18
            else
                print("error" .. slotIds)
                player:SendBroadcastMessage("error" .. slotIds)
            end

            local item = selectTarget:GetItemByPos(255, slotIds)
            if item then
                local itemEntry = item:GetEntry()

                -- print("Slot " .. slotIds .. " " .. itemEntry)
                DbItems[slotIds] = itemEntry
            else
                -- print("Slot " .. slotIds .. " is empty")
                DbItems[slotIds] = 0
            end

        end
        -- player:SendBroadcastMessage("past the fourth for loop")
        player:SendBroadcastMessage("Successful" .. tabelName .. " " .. fileName .. " " .. intId)
        return false

    end

    -- return false
end

RegisterPlayerEvent(PLAYER_EVENT_ON_CHAT, getSlotItems)
print(FILE_NAME .. " loaded")
