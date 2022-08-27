local zoneBuffs = {
    --{zoneId, buffId, amount, duration},
    --example: Below is an example of a zone buff that gives battleShout in Elwynn Forest and in Westfall Commanding Shout. duration is in miliseconds.

    [12] = {
        {buffId = 47436, amount = 5, duration = 60000}
    },
    [40] = {
        {buffId = 47440, amount = 2, duration = 60000}
    }
}
local PLAYER_EVENT_ON_UPDATE_ZONE = 27

local function zoneBuff(event, player, newZone, newArea)
    if player:IsDead() then
        return
    end

    local playerZoneId = player:GetZoneId()
    local zoneCheck = zoneBuffs[playerZoneId]

    if newZone then
        for tableZoneId, tableBuffs in pairs(zoneBuffs) do
            if tableZoneId ~= zoneCheck then
                for _, buff in pairs(tableBuffs) do
                    player:RemoveAura(buff.buffId)
                end
            end
        end
    end

    if zoneCheck then
        for _, buff in pairs(zoneCheck) do
            if not player:HasAura(buff.buffId) then
                player:AddAura(buff.buffId, player)
                if buff.amount > 1 then
                    local aura = player:GetAura(buff.buffId)
                    if aura then
                        aura:SetStackAmount(buff.amount)
                        if buff.duration > 2 then
                            aura:GetDuration(aura:SetDuration(buff.duration))
                        end
                    end
                end
            end
        end
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_UPDATE_ZONE, zoneBuff)
