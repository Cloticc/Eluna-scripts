local item = 123 -- Item ID
local Pet_Happiness = {}

function Pet_Happiness.OnUse(event, player, item)
    if player:GetLevel() < 25 then
        player:SendAreaTriggerMessage("You must be level 25 or higher to use this item.")
        return
    end

    if player:IsInCombat() then
        player:SendAreaTriggerMessage("You cannot use this item while in combat.")
        return
    end

    if player:GetLevel() >= 25 then
        player:ResetPetTalents()
        player:SendAreaTriggerMessage("Your pet's talents have been reset.")
    end


    player:RemoveItem(item, 1)
end

RegisterItemGossipEvent(item, 1, Pet_Happiness.OnUse)