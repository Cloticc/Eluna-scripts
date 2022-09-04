--NOTE: Can have multipile buffs like [zoneID] = {buffId, buffId, buffId}

local zoneBuffs = {
    --zoneId, buffId
    [123] = {123}
}

local PLAYER_EVENT_ON_UPDATE_ZONE = 27

local function zoneBuff(event, player, newZone, newArea)
    if player:IsDead() then --check if dead
        return
    end

    for zone, buffs in pairs(zoneBuffs) do
        if newZone ~= zone then --not in zone remove buff
            for _, buff in pairs(buffs) do
                player:RemoveAura(buff)
            end
        else
            for _, buff in pairs(buffs) do --if in zone then apply buffs
                if not player:HasAura(buff) then
                    player:AddAura(buff, player)
                end
            end
        end
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_UPDATE_ZONE, zoneBuff)
