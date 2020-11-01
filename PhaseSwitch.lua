local npcid = XXX -- Entry For npc

local T = {
    [1] = {"Return me to the real world", true, {1}},
    [2] = {"Dungeon Phase", true, {2}},
    [3] = {"Mythic Phase", true, {3}},
    [4] = {"Raid Phase", true, {4}}
}

local function OnHelloPhaseSwitch(event, player, creature)
    if player:IsInCombat() then
        player:SendBroadcastMessage("You are in combat!")
        player:GossipComplete()
        return
    end
    --Set so true shows and false dont in the table.
    for i, v in ipairs(T) do
        if (v[2]) then
            player:GossipMenuAddItem(2, v[1], 0, i, nil, nil)
        end
    end
    player:GossipSendMenu(1, creature)
end

local function OnGossipPhaseSwitch(event, player, creature, sender, intid, code, menu_id)
    if (intid < 500) then
        local ID = intid

        if (T[ID]) then
            for i, v in ipairs(T[ID][3]) do
                player:SetPhaseMask(v)
            end
            player:CastSpell(player, 62003)
        end
    end

    local PlayerPhase = player:GetPhaseMask()
    player:SendBroadcastMessage("Phase is set to: " .. PlayerPhase .. " ")
    player:GossipComplete()
end

RegisterCreatureGossipEvent(npcid, 1, OnHelloPhaseSwitch)
RegisterCreatureGossipEvent(npcid, 2, OnGossipPhaseSwitch)
