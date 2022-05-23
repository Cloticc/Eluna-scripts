--[[
* This pretty much scuffed waypoint movement. You pretty much get noclip sometimes it choose to path correctly....
* Example: #moveme 10495  This will make you move to King Varian Wrynn in stormwind city. Has to be in Eastern Kingdoms. If not i move to that continent GUID NPC
 ]] local PLAYER_EVENT_ON_CHAT = 18
-- local PLAYER_EVENT_ON_CHAT = 42

local MSG_MF = "#moveme"

local DatabaseCache = {}

local function LoadDatabase()
    local Query = WorldDBQuery("SELECT guid,  position_x, position_y, position_z FROM creature;")
    if (Query) then
        repeat
            local row = Query:GetRow()
            if (row) then
                local guid = row.guid

                local x = row.position_x
                local y = row.position_y
                local z = row.position_z

                DatabaseCache[guid] = {

                    x = x,
                    y = y,
                    z = z

                }
            end
        until not Query:NextRow()
    end
end

local FILE_NAME = string.match(debug.getinfo(1, "S").source, "[^/\\]*.lua$")

local function moveMe(event, player, msg, Type, lang)
    LoadDatabase()

    if msg:find(MSG_MF) then
        if not player:IsGM() then
            return false
        end
        local npcGuid = tonumber(tostring(string.gsub(msg, MSG_MF, "")))
        if (npcGuid) then
            local npc = DatabaseCache[npcGuid]
            if (npc) then
                player:MoveTo(0, npc.x, npc.y, npc.z, false) -- TODO: Check for better option
                player:SendBroadcastMessage("|cff00ff00[" .. FILE_NAME .. "]|r Moving to " .. npcGuid .. ".")
            else
                player:SendBroadcastMessage("|cff00ff00[" .. FILE_NAME .. "]|r You have entered an invalid GUID ID.")
            end
        else
            player:SendBroadcastMessage("|cff00ff00[" .. FILE_NAME .. "]|r You have entered an invalid GUID ID.")
        end
        return false
    end

end

RegisterPlayerEvent(PLAYER_EVENT_ON_CHAT, moveMe)
