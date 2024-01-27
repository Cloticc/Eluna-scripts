-- This script will cast buffs on a player when they /kneel near a specific NPC. It can be invisible

local npcEntry = 5406
local emoteId = 59 -- turn on debug to see the emote id and preform the emote to see the emote id is
local maxRange = 1  -- maximum range in yards
local isDebug = false
local PLAYER_EVENT_ON_TEXT_EMOTE = 24

local buffIds = {
    23735, -- Sayge's Dark Fortune of Strength
    23737, -- Sayge's Dark Fortune of Stamina
    23738, -- Sayge's Dark Fortune of Stamina
    23766, -- Sayge's Dark Fortune of Intelligence
    23767, -- Sayge's Dark Fortune of Armor
    23736, -- Sayge's Dark Fortune of Agility
}

local function debugMessage(player, message)
    if isDebug then
        player:SendBroadcastMessage(message)
    end
end

local function isInRange(player, target)
    local distance = player:GetDistance(target)
    debugMessage(player, string.format("Distance: %s", distance))
    return distance <= maxRange
end

local function castBuffs(player)
    for i = 1, #buffIds do
        player:AddAura(buffIds[i], player)
    end
end

local function onEmote(event, player, textEmote, emoteNum, guid)
    debugMessage(player, string.format("Emote: %s", textEmote))
    debugMessage(player, string.format("EmoteNum: %s", emoteNum))
    debugMessage(player, string.format("Guid: %s", guid))

    if textEmote == emoteId then
        local target = player:GetCreaturesInRange(100, npcEntry)[1] -- get the first creature in the table

        if not isInRange(player, target) then
            player:SendBroadcastMessage("|cffff0000You are too far away from the holy light to send your prayers to the light.")
            return
        end

        castBuffs(player)

        player:SendBroadcastMessage("You light a candle and pray to the holy light.")
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_TEXT_EMOTE, onEmote)


