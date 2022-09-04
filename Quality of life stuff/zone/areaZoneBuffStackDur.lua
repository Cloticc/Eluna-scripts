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
    local playerZoneId = player:GetZoneId()
    if player:IsDead() then
        return
    end

    for zoneId, buffs in pairs(zoneBuffs) do
        for _, buff in pairs(buffs) do
            player:RemoveAura(buff.buffId)
        end
    end
    if zoneBuffs[playerZoneId] then
        for _, buff in pairs(zoneBuffs[newZone]) do
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
RegisterPlayerEvent(PLAYER_EVENT_ON_UPDATE_ZONE, zoneBuff)
