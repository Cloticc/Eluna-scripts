local AIO = require("AIO")

local CustomShop = AIO.AddHandlers("CustomShop", {})

local donationItem = 600003
local voteItem = 600004

local function payGold(player, totalCost, quantity, itemLink)
    local gold = math.floor(totalCost / 10000)
    local silver = math.floor((totalCost - (gold * 10000)) / 100)
    local copper = totalCost - (gold * 10000) - (silver * 100)
    player:SendBroadcastMessage(
        "You have purchased "
        .. quantity
        .. "x "
        .. itemLink
        .. " for "
        .. gold
        .. "g "
        .. silver
        .. "s "
        .. copper
        .. "c"
    )
end

local function getPlayerCurrency(player, costType)
    if costType == "gold" then
        return player:GetCoinage()
    elseif costType == "Honor Points" then
        return player:GetHonorPoints()
    elseif costType == "Arena Points" then
        return player:GetArenaPoints()
    elseif costType == "Donation Points" then
        return player:GetItemCount(donationItem, true)
    elseif costType == "Vote Points" then
        return player:GetItemCount(voteItem, true)
    end
end

local function deductPlayerCurrency(player, costType, totalCost)
    if costType == "gold" then
        player:ModifyMoney(-totalCost)
    elseif costType == "Honor Points" then
        player:SetHonorPoints(player:GetHonorPoints() - totalCost)
    elseif costType == "Arena Points" then
        player:SetArenaPoints(player:GetArenaPoints() - totalCost)
    elseif costType == "Donation Points" then
        player:RemoveItem(donationItem, totalCost)
    elseif costType == "Vote Points" then
        player:RemoveItem(voteItem, totalCost)
    end
end

local MAIL_STATIONERY_TEST = 1
local MAIL_STATIONERY_DEFAULT = 41
local MAIL_STATIONERY_GM = 61
local MAIL_STATIONERY_AUCTION = 6
local MAIL_STATIONERY_VAL = 64
local MAIL_STATIONERY_CHR = 65
local MAIL_STATIONERY_ORP = 67

local function getFreeBagSlots(player)
    local freeSlots = 0

    for i = 23, 38 do
        if not player:GetItemByPos(255, i) then
            freeSlots = freeSlots + 1
        end
    end

    for i = 19, 22 do
        local bag = player:GetItemByPos(255, i)
        if bag then
            for x = 0, bag:GetBagSize() - 1 do
                if not player:GetItemByPos(i, x) then
                    freeSlots = freeSlots + 1
                end
            end
        end
    end

    print("Server: You have " .. freeSlots .. " free bag slots.")

    return freeSlots
end

local function purchaseItem(player, itemID, quantity, totalCost, costType)
    local freeSlots = getFreeBagSlots(player)
    local mailItemLimit = 12

    local itemLink = GetItemLink(itemID)

    deductPlayerCurrency(player, costType, totalCost)

    player:AddItem(itemID, quantity)

    if costType == "gold" then
        payGold(player, totalCost, quantity, itemLink)
    else
        player:SendBroadcastMessage(
            "You have purchased " .. quantity .. "x " .. itemLink .. " for " .. totalCost .. " " .. costType
        )
    end
end

local function purchaseSpell(player, spellID, totalCost, costType)
    if player:HasSpell(spellID) then
        return player:SendBroadcastMessage("You already have this spell.")
    end
    deductPlayerCurrency(player, costType, totalCost)

    player:LearnSpell(spellID)

    if costType == "gold" then
        payGold(player, totalCost)
    else
        player:SendBroadcastMessage("You have purchased the spell for " .. totalCost .. " " .. costType)
    end
end

local messages = {
    ["Quantity"] = {
        "Quantity cannot be 0 or nil.",
        "Quantity cannot be 0 or nil. Nice try backo",
        "Quantity cannot be 0 or nil. You're not that smart are you?",
        "Is this thing on?",
        "What else would happen?",
        "What can possibly be on the other end?",
        "Yarr there be no quantity here.",
        "Shiver me timbers, there be no quantity here.",
        "By the power of Grayskull, there be no quantity here.",
        "Quantity before quality.",
        "Got some coin for me?",
        "Bring the coin, and I'll bring the goods.",
        "Bring me the booty, and I'll bring you the goods.",
        "Kraken",
        "Shazzbot",
    },
}

function CustomShop.addItemOrSpell(player, itemOrSpellID, itemType, quantity, costType, totalCost)
    if quantity == nil or quantity == 0 then
        player:SendBroadcastMessage(messages["Quantity"][math.random(#messages["Quantity"])])

        return
    end

    print(
        "Received AIO.Handle message for itemID:",
        itemOrSpellID,
        "and itemType:",
        itemType .. " and quantity:",
        quantity .. " and costType:",
        costType .. " and totalCost:",
        totalCost
    )

    local playerCurrency = getPlayerCurrency(player, costType)

    if playerCurrency >= totalCost then
        if itemType == "item" then
            purchaseItem(player, itemOrSpellID, quantity, totalCost, costType)
        elseif itemType == "spell" then
            purchaseSpell(player, itemOrSpellID, totalCost, costType)
        end
    else
        player:SendBroadcastMessage("You don't have enough currency to purchase this item.")
    end
end
