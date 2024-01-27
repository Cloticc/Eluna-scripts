local timeToSet = 5           -- time will runs the applyCorruptionDebuff function to check if player has item on them and that they got correct buffs. (in seconds)

local corruptionSpell = 82215 -- Spell to show the corruption stacks need a spell that can stack as i apply the stacks to the spell (The id i use is custom spell)

local AnnounceModule = true   -- Announce module on player login ?


local corruption = {}
local corruptionStacks = {}

-- [itemId] = stack to give {sizeOfStack}
local items = {
    [148] = 100,
    [12185] = 40,
    [22745] = 20,
    [22742] = 20,
    [22743] = 40,
    [22744] = 60,
}

-- [sizeOfStack] = { spellDebuffId, spellDebuffId, spellDebuffId, etc } The ids that are now just example on how you can set it.
local spellDebuffs = {

    [20] = { 82217 },
    [40] = { 82219 },
    [60] = { 82216, 28609 },
    [80] = { 10157 },
    [100] = { 23028 },

}

local FILE_NAME = string.match(debug.getinfo(1, "S").source, "[^/\\]*.lua$")
local PLAYER_EVENT_ON_SPELL_CAST = 5 -- ,        // (event, player, spell, skipCheck)
local WORLD_EVENT_ON_UPDATE = 13     --,       // (event, diff)

function corruption.applyCorruptionDebuff(player)
    local guidLow = player:GetGUIDLow()

    if player:IsDead() then
        return
    end
    --  check if player has any of the items
    local hasItem = false
    for itemId, stack in pairs(items) do
        hasItem = player:HasItem(itemId)
        if hasItem then
            break
        end
    end

    if not hasItem then
        if corruptionStacks[guidLow] then
            corruptionStacks[guidLow] = nil
        end
        return
    end

    if not player:HasAura(corruptionSpell) then
        player:AddAura(corruptionSpell, player)
    end

    for itemId, stack in pairs(items) do --This code block checks if the player has any of the items specified in the items table.
        local hasItemInBag = player:HasItem(itemId)
        if hasItemInBag then
            local IsEquipped = player:GetItemByEntry(itemId):IsEquipped()
            if IsEquipped then
                if corruptionStacks[guidLow] and corruptionStacks[guidLow][itemId] then
                    if stack > corruptionStacks[guidLow][itemId] then
                        corruptionStacks[guidLow][itemId] = stack
                    end
                else
                    if not corruptionStacks[guidLow] then
                        corruptionStacks[guidLow] = {}
                    end
                    corruptionStacks[guidLow][itemId] = stack
                end
            else
                if corruptionStacks[guidLow] and corruptionStacks[guidLow][itemId] then
                    corruptionStacks[guidLow][itemId] = nil
                end
            end
        else
            if corruptionStacks[guidLow] and corruptionStacks[guidLow][itemId] then
                corruptionStacks[guidLow][itemId] = nil
            end
        end
    end

    local totalStacks = 0 -- This code block calculates the total stack count for all items on the player.
    for _, stacks in pairs(corruptionStacks[guidLow] or {}) do
        totalStacks = totalStacks + stacks
    end

    local corraura = player:GetAura(corruptionSpell)
    local corrstack = corraura:GetStackAmount()
    if totalStacks >= corrstack then
        corraura:SetStackAmount(totalStacks)

        -- check corresponding items stack with spellDebuff stack match them up
        for stack, spellDebuffs in pairs(spellDebuffs) do
            for _, spellDebuff in ipairs(spellDebuffs) do
                if stack <= totalStacks then
                    if not player:HasAura(spellDebuff) then
                        player:AddAura(spellDebuff, player)
                    end
                    -- player:CastSpell(player, spellDebuff, true) -- -- tested to use this instead of addaura but will cast animation so bad idea.
                else
                    player:RemoveAura(spellDebuff)
                end
            end
        end
    else
        player:RemoveAura(corruptionSpell)
        for stack, spellDebuffs in pairs(spellDebuffs) do
            for _, spellDebuff in ipairs(spellDebuffs) do
                player:RemoveAura(spellDebuff)
            end
        end
        corruptionStacks[guidLow] = nil
    end
end

local time = os.time()
function corruption.serverUpdate(event, diff) --TODO: See if theres a better way to do this.
    if os.time() - time >= timeToSet then
        for _, player in ipairs(GetPlayersInWorld()) do
            corruption.applyCorruptionDebuff(player)
        end
        time = os.time()
    end
end

RegisterServerEvent(WORLD_EVENT_ON_UPDATE, corruption.serverUpdate)

function corruption.OnSpellCast(event, player, spell, skipCheck) --TODO: Prboably need to change this might be to resoruce heavy to run on every spell cast.
    -- check if player has aura on them to
    if not player:HasAura(corruptionSpell) then
        return
    end
    corruption.applyCorruptionDebuff(player)
end

RegisterPlayerEvent(PLAYER_EVENT_ON_SPELL_CAST, corruption.OnSpellCast)

if AnnounceModule then
    RegisterPlayerEvent(3, function(event, player)
        player:SendBroadcastMessage("This server is running the |cff4CFF00" .. FILE_NAME .. "|r module.")
    end) -- PLAYER_EVENT_ON_LOGIN
end
