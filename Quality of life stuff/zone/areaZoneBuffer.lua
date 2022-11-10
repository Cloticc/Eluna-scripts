local min1 = 60000
local min5 = 300000
local min10 = 600000
local min30 = 1800000
local min60 = 3600000


--[[

the zoneBuffs how to use it: the [1] = zoneID, buffId is the spellId u want to applie, amount is if it stacks might work on non stackable buffs aswell, duration is the duration of the buff in seconds. Added example for the buff 1 hour in table can either use variable or just put the number in there.

 ]]


-- example: Below is an example of a zone buff that gives battleShout in Elwynn Forest and in Westfall Commanding Shout. duration is in miliseconds.
local zoneBuffs = {

    [1] = {
        { buffId = 47440, amount = 5, duration = min60 }, --atm it's commanding shout for 1 hour
        { buffId = 47436, amount = 5, duration = 3600000 } --atm it's battle shout for 1 hour
    },
    [12] = {
        { buffId = 47440, amount = 5, duration = 0 }, --atm it's commanding shout
        { buffId = 47436, amount = 5, duration = 0 } --atm it's battle shout

    }
}
local PLAYER_EVENT_ON_UPDATE_ZONE = 27

local function checkZone(_, player, _, _)
    local zoneId = player:GetZoneId() -- get the zone id
    local zone = zoneBuffs[zoneId] -- get the zone from the table

    for _, buff in pairs(zoneBuffs) do
        for _, buffId in pairs(buff) do
            local aura = player:GetAura(buffId.buffId)
            if aura then
                aura:Remove()
            end
        end
    end


    if zone then

        for _, buff in ipairs(zone) do

            if player:HasAura(buff.buffId) then
                player:RemoveAura(buff.buffId)
            end

            player:AddAura(buff.buffId, player)
            -- player:CastSpell(player, buff.buffId, true) --Bad

            if buff.amount > 1 then

                local aura = player:GetAura(buff.buffId)
                if aura then aura:SetStackAmount(buff.amount) end

            end
            if buff.duration > 1 then

                local aura = player:GetAura(buff.buffId)
                if aura then aura:SetDuration(buff.duration) end

            end
        end
        return
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_UPDATE_ZONE, checkZone)
