--[[ This will make a file where u have set the dir @.
("Usage: #coords <output file name> <coordinates name>")
("#coords myNewFile test")
("#coords myNewFile test2")
Example on how it will look
[
    {
        "name": "test",
        "mapName": "Eastern Kingdoms",
        "mapId": 0,
        "areaName": "Elwynn Forest",
        "areaId": 12,
        "o": 0.000000,
        "x": -8949.950195,
        "y": -132.492004,
        "z": 83.531197
    },
    {
        "name": "test2",
        "mapName": "Eastern Kingdoms",
        "mapId": 0,
        "areaName": "Elwynn Forest",
        "areaId": 12,
        "o": 0.000000,
        "x": -8949.950195,
        "y": -132.492004,
        "z": 83.531197
    }
]

]]
-- local dir = "D:\\worldOfWarcraftStuff\\MyServer\\TrinityCore\\lua_scripts\\Clotic Scripts\\Test\\cords\\" -- example
--local dir = "D:/worldOfWarcraftStuff/MyServer/TrinityCore/lua_scripts/Clotic Scripts/Test/cords/" -- example
local dir = "LOCTION/TO/FILE/TO/SAVE/" --change this to where u want to save the file

------------------------------------DO NOT EDIT BELOW THIS LINE------------------------------------
local function orderedTableToJson(t)
    local jsonStr = "{"
    local first = true
    local orderedKeys = {
        "name",
        "mapName",
        "mapId",
        "areaName",
        "areaId",
        "o",
        "x",
        "y",
        "z"
    }
    for i, k in ipairs(orderedKeys) do
        local v = t[k]
        if not first then
            jsonStr = jsonStr .. ","
        end
        jsonStr = jsonStr .. '"' .. k .. '":'
        if type(v) == "table" then
            jsonStr = jsonStr .. orderedTableToJson(v)
        elseif type(v) == "string" then
            jsonStr = jsonStr .. '"' .. v .. '"'
        else
            jsonStr = jsonStr .. tostring(v)
        end
        first = false
    end
    jsonStr = jsonStr .. "}"
    return jsonStr
end

-- Create a function to retrieve the player's current coordinates and write them to a JSON file
local function writeCoordsToFile(event, player, msg, Type, lang)
    if msg:sub(1, 7) == "#coords" then
        -- Parse the command arguments to extract the output file name and the coordinates name
        local fileName, coordsName = msg:match("#coords%s+(%w+)%s+(%w+)")
        if fileName == nil or coordsName == nil then
            player:SendBroadcastMessage("Usage: #coords <file name> <coordinates name>")
            return
        end

        -- Retrieve the player's current coordinates
        local map = player:GetMap()
        local x, y, z = player:GetLocation()

        local areaId = map:GetAreaId(x, y, z)

        if areaId == 0 then
            areaId = 876 -- gmisland if u in custom area and not update area table

            print("This Should not be happening you probably forget to update area table")
        end
        local areaName = GetAreaName(areaId, 0)

        if areaName == nil then
            areaName = "Unknown"
            print("This Should not be happening you probably forget to update area table")
        end


        -- print("areaId: " .. areaId .. " areaName: " .. areaName)

        local o = player:GetO()
        local coords = {
            name = coordsName,
            mapName = map:GetName(),
            mapId = map:GetMapId(),
            areaName = areaName,
            areaId = areaId,
            o = o,
            x = x,
            y = y,
            z = z
        }

        -- Load existing coordinates from the file, if any
        local coordsList = {}


        -- Add the new coordinates to the list
        table.insert(coordsList, coords)

        -- Convert the coordinates list to an ordered JSON string

        -- if no file exist create file
        local file1 = io.open(dir .. fileName .. ".json", "r")
        if file1 == nil then
            local fileCheck = io.open(dir .. fileName .. ".json", "w")
            if not fileCheck then
                player:SendBroadcastMessage("Error: Could not open file " .. fileName)
                return
            end
            -- fileCheck:write("[]")
            fileCheck:close()
        end



        -- check if "[" and "]" if already exist then dont add and if not then add
        local file2 = io.open(dir .. fileName .. ".json", "r")
        if file2 == nil then
            player:SendBroadcastMessage("Error: Could not open file " .. fileName)
            return
        end
        local jsonStr = ""
        for line in file2:lines() do
            jsonStr = jsonStr .. line
        end
        file2:close()
        if jsonStr:sub(1, 1) == "[" then
            jsonStr = jsonStr:sub(2, jsonStr:len() - 1)
        end
        if jsonStr:sub(jsonStr:len() - 1, jsonStr:len()) == "]" then
            jsonStr = jsonStr:sub(1, jsonStr:len() - 2)
        end
        if jsonStr:sub(1, 1) == "," then
            jsonStr = jsonStr:sub(2, jsonStr:len())
        end
        if jsonStr:sub(jsonStr:len(), jsonStr:len()) == "," then
            jsonStr = jsonStr:sub(1, jsonStr:len() - 1)
        end

        jsonStr = "[" .. jsonStr .. "," .. orderedTableToJson(coords) .. "]"
        -- jsonStr = jsonStr .. "\n]"





        -- Open the output file in write mode
        local file3 = io.open(dir .. fileName .. ".json", "w")


        if file3 == nil then
            player:SendBroadcastMessage("Error: Could not open file " .. fileName)
            return
        end

        -- Write the JSON string to the output file
        file3:write(jsonStr)

        -- Close the output file
        file3:close()

        -- clear the table for next use
        -- coordsList = {}

        --  check if files are closed after use
        if file1 ~= nil then
            file1:close()
        end

        if file2 ~= nil then
            file2:close()
        end

        if file3 ~= nil then
            file3:close()
        end




        -- Send a confirmation message to the player
        player:SendBroadcastMessage("Coordinates written to " .. fileName .. " (name: " .. coordsName .. ")")
    end
end


RegisterPlayerEvent(18, writeCoordsToFile)

-- Register a command to display usage information
local function showUsage(event, player, msg, Type, lang)
    if msg == "#coords" then
        player:SendBroadcastMessage("Usage: #coords <output file name>")
        player:SendBroadcastMessage("Example: #coords mycoords.json")
    end
end
RegisterPlayerEvent(18, showUsage)
