local copyPlayersAmazingGear = "#copyplayer"
local PLAYER_EVENT_ON_CHAT = 18

local storeIds = {}
local function copyPlayerGear(event, player, msg, Type, lang)
    -- add if msg is equal to #copyGearFromPlayer then
    if (msg == copyPlayersAmazingGear) then
        -- add if not gm return
        if (not player:IsGM()) then
            return false
        end
        local selectTarget = player:GetSelection()
        if (not selectTarget) then
            selectTarget = player
        end



        -- local enchantId = Item:GetEnchantmentId(enchantSlot)
        -- local enchantmentSuccess = Item:SetEnchantment(enchantId, enchantSlot)
        --   local  slot = Item:GetSlot()

        for i = 0, 18 do
            if (selectTarget:GetEquippedItemBySlot(i) ~= nil) then
                storeIds[i] = selectTarget:GetEquippedItemBySlot(i):GetEntry()
            end
        end





        for i, v in pairs(storeIds) do
            player:AddItem(v, 1)
        end

        player:SendBroadcastMessage("You have copied the gear from " .. selectTarget:GetName() .. "!")
        storeIds = {}
    end
end
RegisterPlayerEvent(PLAYER_EVENT_ON_CHAT, copyPlayerGear)
