-- This will make so if you /pray near the npcEntry it will cast the buffs on you.



local npcEntry                   = 44114

local emoteId                    = 74
local isDebug                    = false

local maxRange                   = 1  -- maximum range in yards

local PLAYER_EVENT_ON_TEXT_EMOTE = 24 --,       // (event, player, textEmote, emoteNum, guid)

local buffIds                    = {
    23735, -- Sayge's Dark Fortune of Strength
    23737, -- Sayge's Dark Fortune of Stamina
    23738, -- Sayge's Dark Fortune of Stamina
    23766, -- Sayge's Dark Fortune of Intelligence
    23767, -- Sayge's Dark Fortune of Armor
    23736, -- Sayge's Dark Fortune of Agility
}


local function onEmote(event, player, textEmote, emoteNum, guid)
    -- creaturesInRange = WorldObject:GetCreaturesInRange( range, entryId )
    if (isDebug) then
        player:SendBroadcastMessage(string.format("Emote: %s", textEmote))
        player:SendBroadcastMessage(string.format("EmoteNum: %s", emoteNum))
        player:SendBroadcastMessage(string.format("Guid: %s", guid))
    end
    if (textEmote == emoteId) then
        player:SendBroadcastMessage("")

        -- local target = player:GetSelection():ToCreature()
        -- if (not target or target:GetEntry() ~= npcEntry) then
        --     player:SendBroadcastMessage("|cffff0000You are too far away from the holy light to send your prayers to the gods.")
        --     return
        -- end

        local target = player:GetCreaturesInRange(100, npcEntry)
        target = target[1] -- get the first creature in the table


        local distance = player:GetDistance(target) -- get the distance between the player and the target
        -- player:SendBroadcastMessage(string.format("Distance: %s", distance))
        if (distance > maxRange) then
            player:SendBroadcastMessage(
                "|cffff0000You are too far away from the holy light to send your prayers to the gods.")
            return
        end

        -- cast the buffs on player
        for i = 1, #buffIds do
            player:AddAura(buffIds[i], player)
        end
        -- target:SendChatMessageToPlayer(8, 0, "As you step foot into the sacred Dreamway, the divine powers of the gods envelop you, infusing you with their blessings and empowering you for the epic adventures that lie ahead.", player)

        player:SendBroadcastMessage(
            "You offer your sincere prayers to the mighty deities of Ankhara and, in response, you are bestowed with divine blessings and empowering buffs.")
    end
end



RegisterPlayerEvent(PLAYER_EVENT_ON_TEXT_EMOTE, onEmote)
