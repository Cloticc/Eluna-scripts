----------------------------------------------------------
-----------------[Time Rifts]------------------------------
----------------------------------------------------------
local PLAYER_EVENT_ON_KILL_CREATURE = 7  --,        // (event, killer, killed)
local WORLD_EVENT_ON_UPDATE         = 13 --,       // (event, diff)
local WORLD_EVENT_ON_STARTUP        = 14 --,       // (event)


local TEMPSUMMON_TIMED_DESPAWN           = 3 --, // despawns after a specified time
local TEMPSUMMON_TIMED_OR_CORPSE_DESPAWN = 2 --, // despawns after a specified time OR when the creature dies

local timeRifts                          = {}

local timeBetweenSpawn                   = 10     -- will tbe world tic update in seconds
local timePortal                         = 120000 -- 2min
-- local timePortal                         = 9000
local timeNpc                            = timePortal - 1000
local mobsAlive                          = 0
local distance                           = 10 -- distance in front of the player to spawn the creature
local time                               = os.time()
local portalActive                       = {}


timeRifts.riftPortalSpawn = {
    [1] = { npcEntry = 43284, displayEntry = 26501, mapId = 1, x = 16207.109375, y = 16219.059570, z = 1.096828, o = 4.230113, },  -- rift identifier
    [2] = { npcEntry = 43284, displayEntry = 26501, mapId = 1, x = 16201.745117, y = 16255.228516, z = 20.975187, o = 6.158247, }, -- rift identifier
    [3] = { npcEntry = 43284, displayEntry = 26501, mapId = 1, x = 16253.876953, y = 16233.604492, z = 33.788204, o = 2.321586, }, -- rift identifier
}

timeRifts.riftMobsSpawn   = {
    [1] = { npcEntry = 5450, displayEntry = 3194 }, -- rift id



}

function timeRifts.spawnAPortal(npcEntry, mapid, x, y, z, o, displayEntry)
    if not npcEntry then
        return
    end

    local riftPortal = PerformIngameSpawn(1, npcEntry, mapid, 0, x, y, z, o, false, 0)

    if not riftPortal or not riftPortal:IsInWorld() then
        print("Failed to spawn portal")
        return
    end

    riftPortal:SetDisplayId(displayEntry)
    riftPortal:SetScale(1.2)

    local px, py, pz = riftPortal:GetLocation()
    timeRifts.spawnAMob(timeRifts.riftMobsSpawn[1].npcEntry, timeRifts.riftMobsSpawn[1].displayEntry, 6, mapid, o,
        riftPortal, px, py, pz)

    -- table.insert(portalActive, riftPortal:GetGUID())

    return riftPortal
end

function timeRifts.onUpdate(event, diff)
    if (os.time() >= time + timeBetweenSpawn) then --TODO: change timer
        timeRifts.spawnPortal()
        time = os.time()                           -- reset time
    end
end

local lastPortalSpawn = nil
function timeRifts.spawnPortal()
    local portalSpawn = nil
    repeat
        -- get random portal spawn
        portalSpawn = math.random(1, #timeRifts.riftPortalSpawn)
    until lastPortalSpawn ~= portalSpawn
    lastPortalSpawn = portalSpawn

    -- get portal location
    local portalInfo = timeRifts.riftPortalSpawn[portalSpawn]
    local px = portalInfo.x
    local py = portalInfo.y
    local pz = portalInfo.z
    local po = portalInfo.o
    local mapid = portalInfo.mapId
    local npcEntry = portalInfo.npcEntry
    local displayEntry = portalInfo.displayEntry
    local portal = timeRifts.spawnAPortal(npcEntry, mapid, px, py, pz, po, displayEntry)

    if portal == nil then
        print("portal is nil")
        return
    end

    if portal:IsInWorld() and #portalActive >= 0 then
        -- print("is in world and more then 2 portals active despawning portal: " .. portal:GetGUIDLow())
        local despawnPortal = portal:DespawnOrUnsummon(timePortal)

        if despawnPortal then
            -- print("Removing portal from portalActive table: " .. portal:GetGUIDLow())
            -- Removing from portalActive table
            table.remove(portalActive, portal:GetGUID())
        end
    else
    end

    table.insert(portalActive, portal:GetGUID())
end

function timeRifts.spawnAMob(npcEntry, displayEntry, mobsToSpawn, mapid, o, riftPortal, px, py, pz)
    for i = 1, mobsToSpawn do
        -- riftPortal:GetLocation()
        -- spawn on portal make the creature walk out in random direction
        local riftMob = riftPortal:SpawnCreature(npcEntry, px, py, pz, o, TEMPSUMMON_TIMED_OR_CORPSE_DESPAWN, timeNpc) --TODO: might need to adjust tempsummon thing
        if riftMob then                                                                                                -- if mob is spawned then do this
            -- make the mob walk out of the portal
            local mobX, mobY, mobZ = riftMob:GetLocation()
            local mobO = riftMob:GetO()
            local spawnX = mobX + distance * math.cos(mobO)
            local spawnY = mobY + distance * math.sin(mobO)
            --    make rift mob spread out when walking out
            local spreadX = spawnX + math.random(-5, 10)
            local spreadY = spawnY + math.random(-5, 10)

            riftMob:MoveTo(mapid, spreadX, spreadY, mobZ, mobO)
            -- add a check if display is nill don't use this
            if displayEntry ~= 0 then
                riftMob:SetDisplayId(displayEntry)
            end
            -- riftMob:SetScale(math.random(0.9, 1.2))
            -- mobsAlive = mobsAlive + 1
            -- print("mobsAlive: " .. mobsAlive)
            mobsAlive = 0
        end
    end
end

function timeRifts.onCreatureDeath(event, killer, killed)
    if killed:GetEntry() == timeRifts.riftMobsSpawn[1].npcEntry then
        -- get the portal closest to the killed creature
        local riftPortal = killed:GetNearestCreature(100, timeRifts.riftPortalSpawn[1].npcEntry, 0, 0)

        -- spawnAMob(npcEntry, displayEntry, mobsToSpawn, mapid, o, riftPortal, px, py, pz)
        if riftPortal then
            -- get portal location
            local px, py, pz = riftPortal:GetLocation()
            -- spawn mobs
            timeRifts.spawnAMob(timeRifts.riftMobsSpawn[1].npcEntry, timeRifts.riftMobsSpawn[1].displayEntry, 1,
                timeRifts.riftPortalSpawn[1].mapId, timeRifts.riftPortalSpawn[1].o, riftPortal, px, py, pz)
            -- decrement mobsAlive counter
            mobsAlive = mobsAlive - 1
        end

        -- decrement mobsAlive counter
        mobsAlive = mobsAlive - 1
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_KILL_CREATURE, timeRifts.onCreatureDeath)
RegisterServerEvent(WORLD_EVENT_ON_UPDATE, timeRifts.onUpdate)


local msgXxx = "#removePortals"
local PLAYER_EVENT_ON_CHAT = 18

local function DDD(event, player, msg, Type, lang)
    if (msg == msgXxx) then
        -- Get all riftPortals and remove them from world
        -- worldObjectList = WorldObject:GetNearObjects( range, type, entry, hostile, dead )
        local riftPortals = player:GetNearObjects(100, 1, 43284, 0, 0)
        for _, riftPortal in ipairs(riftPortals) do
            riftPortal:DespawnOrUnsummon(0)
        end

        player:SendBroadcastMessage("Removed all the portals")
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_CHAT, DDD)
