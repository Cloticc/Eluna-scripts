--[[ made for testing  ]]

local npcid = 43284

-- local T = {
-- [0] = {}}



local function LoadDB(player)
    local guid = player:GetGUIDLow()
    local Q = CharDBQuery("SELECT spell FROM character_spell where guid = "..guid)
    if (Q) then
        repeat
            local spell = Q:GetUInt32(0)
            player:RemoveSpell(spell, false, true)
        until not Q:NextRow()
    end
end


--[[ local guid = player:GetGUIDLow()
local Q = CharDBQuery("SELECT spell FROM character_spell WHERE guid =" .. guid)
if (Q) then
    repeat
        local spell = Q:GetUInt32(0)
        player:RemoveSpell(spell, false, true)
    until not Q:NextRow()
end
player:SendBroadcastMessage(
    "|cFFFFFF9F" .. creature:GetName() .. " says: I remove all your spells " .. player:GetName()
) ]]


--[[ local DatabaseCache = {}

local function LoadDatabase()
    local guid = player:GetGUIDLow()
    local Q = CharDBQuery("SELECT guid, spell FROM character_spell where guid = "..guid)
    if (Q) then
        repeat
            DatabaseCache[Q:GetUInt32(0)] = {
                spell = Q:GetUInt32(1)
            }
        until not Q:NextRow()
    end
end
LoadDatabase() ]]

local function OnHelloTestVendor(event, player, creature)
    player:GossipMenuAddItem(6, "Give Gold", 0, 1, true, "Insert how much gold you want")
    player:GossipMenuAddItem(1, "Additem", 0, 2, true, "Insert ID for the item you want then press ACCEPT")
    player:GossipMenuAddItem(0, "Heal me & Reset Cooldowns", 0, 3)
    player:GossipMenuAddItem(3, "Reset Talents", 0, 4)
    player:GossipMenuAddItem(3, "Unlearn Everything", 0, 5)
    player:GossipMenuAddItem(3, "Add X Item", 0, 6, true, "Insert Amount")
    player:GossipMenuAddItem(0, "Nevermind", 0, 999)
    player:GossipSendMenu(1, creature)
    return
end

local function OnGossipTestVendor(event, player, creature, sender, intid, code, menu_id)
    if (intid == 1) then
        if (tonumber(code)) then
            player:SetCoinage(math.ceil(tonumber(code) * 10000))
            player:SendBroadcastMessage(
                "|cFFFFFF9F" .. creature:GetName() .. " says: I gave you " .. tonumber(code) .. " gold don't spend it all in one place."
            )
            player:GossipComplete()
        end
    end
    if (intid == 2) then
        if (tonumber(code)) then
            player:AddItem((tonumber(code)))
            player:SendBroadcastMessage(
                "|cFFFFFF9F" .. creature:GetName() .. " says: Added the item " .. GetItemLink(code) .. "."
            )
        end
    end

    if (intid == 3) then
        player:SetHealth(player:GetMaxHealth())
        player:SetPower(player:GetMaxPower(0), 0)
        player:ResetAllCooldowns()
        player:SendBroadcastMessage("|cFFFFFF9F" .. creature:GetName() .. " says: Health and Power Been Reset")
    end

    if (intid == 4) then
        player:ResetTalents(true)
        player:SendBroadcastMessage("|cFFFFFF9F" .. creature:GetName() .. " says: Talent Been Reset")
    end

    if (intid == 5) then
player:SaveToDB()
        LoadDB(player)
        -- local Entry = DatabaseCache[spell]
        -- player:RemoveSpell(Entry, false, true)
        -- player:KickPlayer()
    end

    if (intid == 6) then
        player:AddItem((tonumber(code)))
    end
    if (intid == 999) then
        player:GossipComplete()
    end

    OnHelloTestVendor(event, player, creature)

end


RegisterCreatureGossipEvent(npcid, 1, OnHelloTestVendor)
RegisterCreatureGossipEvent(npcid, 2, OnGossipTestVendor)

-- player:SendBroadcastMessage("|cFFFFFF9F" .. creature:GetName() .. " says: ")

