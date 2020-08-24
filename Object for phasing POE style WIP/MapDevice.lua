-- local npcid = 43283
local objectid = 244607 -- object id for device
local portal = 244606 -- object for portal ID
local Cost = 1000000 -- Cost to Open portal
local Phase = 10 -- sets phase to go to
local Monsters = 43283

local function MapDevice(event, player, object)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Activate", 0, 1, false, "Are you sure", 1000000)
    player:GossipMenuAddItem(
        0,
        "Deactivate",
        0,
        2,
        false,
        "Are you sure. Clicking this will despawn the Device & Portal"
    )
    player:GossipSendMenu(99, object)
    return false
end

local function MapDeviceOnSelect(event, player, object, sender, intid, code, menu_id)
    if (intid == 1) then
        if (player:GetCoinage() >= Cost) then
            player:ModifyMoney(-Cost)

            local map = object:GetMapId()
            local instanceid = object:GetInstanceId()
            local o = object:GetO()
            local x = object:GetX()
            local y = object:GetY()

            local r = 60

            for i = 1, 6 do
                w = i * math.pi / 180
                pt = x + r * math.cos(w) and y + r * math.sin(w)
                --   print( pt )
                local x1, y1, z1 = object:GetRelativePoint(4, pt)

                PerformIngameSpawn(2, portal, map, instanceid, x1, y1, z1, o, false, 2, 1)


            end
            player:GossipComplete()
        end
    end
    if (intid == 2) then
        for i = 1, 6 do
            local a = object:GetNearestGameObject(4)
            a:RemoveFromWorld(true)
        end
        object:RemoveFromWorld(true)
        player:GossipComplete()
    end
end

local function PortalOnHello(event, player, object)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Enter", 0, 1, false, "Portal will deplete once you enter.")
    player:GossipSendMenu(98, object)
end

local function PortalOnSelect(event, player, object, sender, intid, code, menu_id)
    if (intid == 1) then
        player:CastSpell(player, 36937)
        player:CastSpell(player, 36018)
        player:SetPhaseMask(Phase, true)
        object:RemoveFromWorld(true)
    end
    player:GossipComplete()
end

RegisterGameObjectGossipEvent(objectid, 1, MapDevice)
RegisterGameObjectGossipEvent(objectid, 2, MapDeviceOnSelect)
RegisterGameObjectGossipEvent(portal, 1, PortalOnHello)
RegisterGameObjectGossipEvent(portal, 2, PortalOnSelect)
-- RegisterCreatureGossipEvent(npcid, 1, MapDevice)
-- RegisterCreatureGossipEvent(npcid, 2, MapDeviceActivate)
-- 1 * math.pi / 180
--  65 * math.pi / 180
-- 120 * math.pi / 180
-- 185 * math.pi / 180
-- 245 * math.pi / 180
-- 290 * math.pi / 180




-- PerformIngameSpawn( spawnType, entry, mapId, instanceId, x, y, z, o, save, durorresptime, phase )

-- for p = 1, 25 do
--     w = p * math.pi / 180
--     pt = r + r * math.cos(w) and y + r * math.sin(w)
--     --   print( pt )
--     local x2, y2, z2 = object:GetRelativePoint(6, pt)
-- end
-- PerformIngameSpawn(2, Monsters, map, instanceid, x2, y2, z2, o, false, 2, Phase)
