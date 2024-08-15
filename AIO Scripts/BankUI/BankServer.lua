local AIO = AIO or require("AIO")

local BankSystemHandler = AIO.AddHandlers("BankSystem", {})

local config = {
    debug = true
}

-- Function to display debug messages
local function debugMessage(...)
    if config.debug then
        print("DEBUG:", ...)
    end
end

-- Cache table for storing gold amounts reduce database queries hopefully
local goldCache = {}

function BankSystemHandler.DepositGold(player, amount)
    local accountId = player:GetAccountId()
    local playerGold = player:GetCoinage() / 10000 -- Convert copper to gold will just do gold

    -- print("Debug: Player gold: " .. tostring(playerGold))
    -- print("Debug: Amount to deposit: " .. tostring(amount))

    if playerGold >= amount then
        print("Debug: Depositing gold.")
        local query = string.format(
            "INSERT INTO auth.account_bank (account_id, gold_amount) VALUES (%d, %d) ON DUPLICATE KEY UPDATE gold_amount = gold_amount + %d",
            accountId, amount, amount)
        AuthDBExecute(query)
        player:ModifyMoney(-amount * 10000)
        player:SendBroadcastMessage("You have deposited " .. amount .. " gold into your bank account.")

        -- Update the cache
        goldCache[accountId] = (goldCache[accountId] or 0) + amount

        BankSystemHandler.SendGoldAmount(player)
    else
        print("Debug: Not enough gold to deposit.")
        player:SendBroadcastMessage("You do not have enough gold to deposit.")
    end
end

function BankSystemHandler.WithdrawGold(player, amount)
    local accountId = player:GetAccountId()
    local goldAmount = goldCache[accountId]

    if goldAmount == nil then
        local query = string.format("SELECT gold_amount FROM auth.account_bank WHERE account_id = %d", accountId)
        local result = AuthDBQuery(query)
        if result then
            goldAmount = result:GetInt32(0)
            goldCache[accountId] = goldAmount
        else
            player:SendBroadcastMessage("You do not have a bank account.")
            return
        end
    end

    if goldAmount >= amount then
        local updateQuery = string.format(
            "UPDATE auth.account_bank SET gold_amount = gold_amount - %d WHERE account_id = %d", amount, accountId)
        AuthDBExecute(updateQuery)
        player:ModifyMoney(amount * 10000)
        player:SendBroadcastMessage("You have withdrawn " .. amount .. " gold from your bank account.")

        -- Update the cache
        goldCache[accountId] = goldAmount - amount

        BankSystemHandler.SendGoldAmount(player)
    else
        player:SendBroadcastMessage("You do not have enough gold in your bank account.")
    end
end

function BankSystemHandler.SendGoldAmount(player)
    local accountId = player:GetAccountId()
    local goldAmount = goldCache[accountId]

    if goldAmount == nil then
        local query = string.format("SELECT gold_amount FROM auth.account_bank WHERE account_id = %d", accountId)
        local result = AuthDBQuery(query)
        if result then
            goldAmount = result:GetInt32(0)
            goldCache[accountId] = goldAmount
        else
            goldAmount = 0
            goldCache[accountId] = goldAmount
        end
    end

    AIO.Msg():Add("BankSystem", "UpdateGoldAmount", goldAmount):Send(player)
end

function BankSystemHandler.RequestGoldAmount(player)
    BankSystemHandler.SendGoldAmount(player)
end

-- Can ignore this if you already took it from readme

-- CREATE TABLE `account_bank` (
-- 	`account_id` INT(10) UNSIGNED NOT NULL,
-- 	`gold_amount` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
-- 	PRIMARY KEY (`account_id`) USING BTREE
-- )
-- COLLATE='utf8mb4_unicode_ci'
-- ENGINE=InnoDB
-- ;
