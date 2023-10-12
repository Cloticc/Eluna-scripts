local isSpellCast = 123

local woodCuttingSkill = 123


local PLAYER_EVENT_ON_SPELL_CAST = 5 --,        // (event, player, spell, skipCheck)


local treeLoot = {
    -- objectId is in [] and the item recieved is in {}
    -- [123] = { 123 },
    -- [123] = { 123 },
}

local success = false

local function onSpellCast(event, player, spell, skipCheck)
    if (spell:GetEntry() == isSpellCast) then
        local skill = player:GetSkillValue(woodCuttingSkill)
        if (skill) then
            player:AdvanceSkill(woodCuttingSkill, math.random(1, 2))
            success = true
        end

        if (success == true) then
            -- player:SendBroadcastMessage("SUCCESS")
            for treeID, loot in pairs(treeLoot) do
                local treeFinder = player:GetNearestGameObject(5, treeID)
                if treeFinder then
                    local item = loot[math.random(1, #loot)]
                    player:AddItem(item, 1)
                end
            end



            success = false
        end
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_SPELL_CAST, onSpellCast)
