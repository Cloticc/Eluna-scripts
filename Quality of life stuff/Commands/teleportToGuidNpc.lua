local MSG_TPN = "tpg" --#command for triggering .tpg ID

local teleportToNpc = {}
local DatabaseCache = {}

local function LoadDatabase()
    local Query =
        WorldDBQuery("SELECT guid, map, position_x, position_y, position_z, orientation FROM creature;")
    if (Query) then
        repeat
            local row = Query:GetRow()
            if (row) then
                local guid = row.guid
                local map = row.map
                local x = row.position_x
                local y = row.position_y
                local z = row.position_z
                local o = row.orientation
                DatabaseCache[guid] = {
                    map = map,
                    x = x,
                    y = y,
                    z = z,
                    o = o
                }
            end
        until not Query:NextRow()
    end
end

FILE_NAME = string.match(debug.getinfo(1, "S").source, "[^/\\]*.lua$")
function teleportToNpc.command(event, player, command)
    LoadDatabase()
    if (command:find(MSG_TPN)) then
        local npcGuid = tonumber(tostring(string.gsub(command, MSG_TPN , "")))
        if (npcGuid) then
            local npc = DatabaseCache[npcGuid]
            if (npc) then
                player:Teleport(npc.map, npc.x, npc.y, npc.z, npc.o)
                player:SendBroadcastMessage(
                    "|cff00ff00[" .. FILE_NAME .. "]|r You have been teleported to " .. npcGuid .. "."
                )
            else
                player:SendBroadcastMessage("|cff00ff00[" .. FILE_NAME .. "]|r You have entered an invalid NPC GUID.")
            end
        else
            player:SendBroadcastMessage("|cff00ff00[" .. FILE_NAME .. "]|r You have entered an invalid NPC GUID.")
        end
    end
end

RegisterPlayerEvent(42, teleportToNpc.command)