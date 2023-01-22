--[[
Lottery script for eluna using a database to store the lottery numbers and tickets bought by players.
This script might be bugs open an issue on github if you find any bugs.

creates 2 tables in the database lottery and lottery_tickets if they don't exist already
you need to add "lottery" numbers to the database manually for now (might add a command for it later.)

 ]]
local npcId = 43295

local lottery_tickets = {}

-- local GOSSIP_ACTION_INFO_DEF = 1000
-- local GOSSIP_SENDER_MAIN = 1

local menuId = 0x7FFFFFFF
-----------------------------------------------------
-- Events
local PLAYER_EVENT_ON_LOGIN = 3
local PLAYER_EVENT_ON_LOGOUT = 4
local GAME_EVENT_START = 34
local GAME_EVENT_STOP = 35

local GOSSIP_EVENT_ON_HELLO = 1
local GOSSIP_EVENT_ON_SELECT = 2
-----------------------------------------------------
--color picker function :D
local function SetColor(colorId, text)
    return "|c" .. colorId .. text .. "|r"
end

-- player:GossipMenuAddItem(0, SetColor("FF7D2DBE", "Buy a ticket"), 0, 1) example of how to use SetColor function to change the color of the text
-----------------------------------------------------
----this part will create a table in the database if it doesn't exist


local lotteryExe = WorldDBExecute([[
     CREATE TABLE IF NOT EXISTS lottery (
         week_number INT UNSIGNED NOT NULL,
         number1 INT UNSIGNED NOT NULL,
         number2 INT UNSIGNED NOT NULL,
         number3 INT UNSIGNED NOT NULL,
         number4 INT UNSIGNED NOT NULL,
         number5 INT UNSIGNED NOT NULL,
         number6 INT UNSIGNED NOT NULL,
         amount INT UNSIGNED NOT NULL,
         PRIMARY KEY (week_number)
     )
 ]])

local lotteryTicketExe = WorldDBExecute([[
     CREATE TABLE IF NOT EXISTS lottery_tickets (
         ticket_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
         week_number INT UNSIGNED NOT NULL,
         player_guid INT UNSIGNED NOT NULL,
         player_account_id INT UNSIGNED NOT NULL,
         number1 INT UNSIGNED NOT NULL,
         number2 INT UNSIGNED NOT NULL,
         number3 INT UNSIGNED NOT NULL,
         number4 INT UNSIGNED NOT NULL,
         number5 INT UNSIGNED NOT NULL,
         number6 INT UNSIGNED NOT NULL,
         PRIMARY KEY (ticket_id),
         FOREIGN KEY (week
         _number) REFERENCES lottery(week_number)
     )
     ]])

if (lotteryExe == false) then
    print("Error creating lottery table")
end

if (lotteryTicketExe == false) then
    print("Error creating lottery_tickets table")
end


-----------------------------------------------------

local function LotteryOnLogin(event, player)
    local guid = player:GetGUIDLow()
    lottery_tickets[guid] = {}
    local tickets = WorldDBQuery("SELECT * FROM lottery_tickets WHERE player_guid=" .. guid)

    -----------------------------------------------------
    if (tickets) then
        while (tickets:NextRow()) do
            local ticket = {
                ticket_id = tickets:GetUInt32(0),
                week_number = tickets:GetUInt32(1),
                player_guid = tickets:GetUInt32(2),
                player_account_id = tickets:GetUInt32(3),
                number1 = tickets:GetUInt32(4),
                number2 = tickets:GetUInt32(5),
                number3 = tickets:GetUInt32(6),
                number4 = tickets:GetUInt32(7),
                number5 = tickets:GetUInt32(8),
                number6 = tickets:GetUInt32(9)
            }

            --Add the ticket to the lookup table
            if lottery_tickets[guid] == nil then
                lottery_tickets[guid] = {}
            end

            lottery_tickets[guid][ticket.ticket_id] = ticket
        end
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_LOGIN, LotteryOnLogin)
--------------------------------------------------------

-- --RegisterPlayerEvent for when a player logs out
-- function LotteryOnLogout(event, player)
--     --Remove the entry from the lottery_tickets table
--     if (lottery_tickets[player:GetGUIDLow()]) then
--         lottery_tickets[player:GetGUIDLow()] = nil
--     end
-- end

-- RegisterPlayerEvent(PLAYER_EVENT_ON_LOGOUT, LotteryOnLogout)
local function LotteryOnLogout(event, player)
    lottery_tickets[player:GetGUIDLow()] = nil
end

RegisterPlayerEvent(PLAYER_EVENT_ON_LOGOUT, LotteryOnLogout)
--------------------------------------------------------------------------------------------------------------------

local function LotteryTicketEventEnd(event, gameeventid)
    if (gameeventid == 89) then
        -- local week_number = WorldDBQuery("SELECT week_number FROM lottery WHERE week_number=(SELECT MAX(week_number) FROM lottery)"):GetUInt32(0);
        local week_number =
        WorldDBQuery("SELECT week_number FROM lottery WHERE week_number=" .. lottery_tickets.week_number):GetUInt32(
            0
        )

        --Get the lottery numbers for the current week
        local number1 = WorldDBQuery("SELECT number1 FROM lottery WHERE week_number=" .. week_number):GetUInt32(0)
        local number2 = WorldDBQuery("SELECT number2 FROM lottery WHERE week_number=" .. week_number):GetUInt32(0)
        local number3 = WorldDBQuery("SELECT number3 FROM lottery WHERE week_number=" .. week_number):GetUInt32(0)
        local number4 = WorldDBQuery("SELECT number4 FROM lottery WHERE week_number=" .. week_number):GetUInt32(0)
        local number5 = WorldDBQuery("SELECT number5 FROM lottery WHERE week_number=" .. week_number):GetUInt32(0)
        local number6 = WorldDBQuery("SELECT number6 FROM lottery WHERE week_number=" .. week_number):GetUInt32(0)
        local amount = WorldDBQuery("SELECT amount FROM lottery WHERE week_number=" .. week_number):GetUInt32(0)
        local winners = 0
        local winnings = 0

        --Get all lottery tickets for the current week
        local tickets = WorldDBQuery("SELECT * FROM lottery_tickets WHERE week_number=" .. week_number)

        --Loop through all tickets and check if any of them match the lottery numbers
        if (tickets) then
            while (tickets:NextRow()) do
                local ticket_number1 = tickets:GetUInt32(4)
                local ticket_number2 = tickets:GetUInt32(5)
                local ticket_number3 = tickets:GetUInt32(6)
                local ticket_number4 = tickets:GetUInt32(7)
                local ticket_number5 = tickets:GetUInt32(8)
                local ticket_number6 = tickets:GetUInt32(9)
                local player_lowguid = tickets:GetUInt32(2)

                if (ticket_number1 == number1 and ticket_number2 == number2 and ticket_number3 == number3 and
                    ticket_number4 == number4 and
                    ticket_number5 == number5 and
                    ticket_number6 == number6)
                then
                    --Send mail to the player with the amount of money won
                    winners = winners + 1
                end
                winnings = amount / winners
                SendMail(
                    "Lottery Winner!",
                    "Congratulations! You have won the lottery and have been awarded " .. winnings .. " copper!",
                    player_lowguid,
                    0,
                    0,
                    0,
                    winnings
                )
            end
        end
    end
end

RegisterServerEvent(GAME_EVENT_STOP, LotteryTicketEventEnd)

-----------------------------------------------------

--Generates the initial lottery numbers.
local function LotteryTicketEventBegin(event, gameeventid)
    if (gameeventid == 89) then
        local week_number =
        WorldDBQuery("SELECT week_number FROM lottery ORDER BY week_number DESC LIMIT 1"):GetUInt32(0)
        local week = 0
        if (week_number == 0) then
            week = 1
        else
            week = week_number + 1
        end

        local number1 = math.random(1, 32)
        local number2 = math.random(1, 32)
        local number3 = math.random(1, 32)
        local number4 = math.random(1, 32)
        local number5 = math.random(1, 32)
        local number6 = math.random(1, 32)

        WorldDBExecute(
            "REPLACE lottery (week_number, number1, number2, number3, number4, number5, number6, amount) VALUES (" ..
            week ..
            ", " ..
            number1 ..
            ", " ..
            number2 ..
            ", " .. number3 .. ", " .. number4 .. ", " .. number5 .. ", " .. number6 .. ", 0)"
        )
    end
end

RegisterServerEvent(GAME_EVENT_START, LotteryTicketEventBegin)

--------------------------------------------------------------------------------------------------------------------

local function LotteryGossipNpc(event, player, creature)
    local jackpot_amount =
    WorldDBQuery("SELECT amount FROM lottery WHERE week_number=(SELECT MAX(week_number) FROM lottery)"):GetUInt32(0)
    local jackpot_amount_gold = math.floor(jackpot_amount / 10000)
    -- player:GossipSetText(string.format("Welcome to the lottery!. Current jackpot: %u gold!", jackpot_amount_gold)) ---- simple version
    -- player:GossipSetText(string.format(SetColor("FF1B1B1B", "Welcome to the lottery!. Current jackpot: %u gold!"), jackpot_amount_gold)) ---- color version

    player:GossipSetText(
        string.format(
            SetColor("FF000000", "Welcome to the lottery!. Current jackpot: ") .. SetColor("FFFFD700", "%u") .. " gold!"
            ,
            jackpot_amount_gold
        )
    ) ---- color version with gold color

    local ticket_count = 0
    if lottery_tickets[player:GetGUIDLow()] then
        for ticket_key, ticket in pairs(lottery_tickets[player:GetGUIDLow()]) do
            local ticket_string =
            string.format(
                "Ticket #%u: %u, %u, %u, %u, %u, %u",
                ticket.ticket_id,
                ticket.number1,
                ticket.number2,
                ticket.number3,
                ticket.number4,
                ticket.number5,
                ticket.number6
            )
            player:GossipMenuAddItem(0, ticket_string, 0, 0)
            ticket_count = ticket_count + 1
        end
    end

    --made check so if u got 3 tickets u cant buy more so the player knows he cant buy more tickets.
    if (ticket_count == 3) then
        player:GossipMenuAddItem(0, "You have reached the maximum amount of tickets you can purchase.", 0, 0)
    end

    if (ticket_count < 3) then
        -- player:GossipMenuAddItem(0, "Purchase Lottery Ticket", 0, 1, GOSSIP_ACTION_INFO_DEF + 1) ????
        player:GossipMenuAddItem(0, "Purchase Lottery Ticket", 0, 1)
    end

    player:GossipSendMenu(menuId, creature)
end

local function LotteryGossipNpcSelect(event, player, creature, sender, intid)
    if (intid == 1) then
        --Check if the player has enough money
        if (player:GetCoinage() < 100000) then
            creature:SendUnitSay("You do not have enough money to buy a lottery ticket!", 0)
        else
            --Subtract the money from the player
            player:ModifyMoney(-100000)

            --Generate the 6 lottery numbers
            local number1 = math.random(1, 32)
            local number2 = math.random(1, 32)
            local number3 = math.random(1, 32)
            local number4 = math.random(1, 32)
            local number5 = math.random(1, 32)
            local number6 = math.random(1, 32)

            --Get the current week number
            local week_number =
            WorldDBQuery("SELECT week_number FROM lottery ORDER BY week_number DESC LIMIT 1"):GetUInt32(0)

            --Increase the amount in the pot by 70000 copper
            WorldDBQuery("UPDATE lottery SET amount=amount+70000 WHERE week_number=" .. week_number)

            --Insert the ticket into the database
            WorldDBQuery(
                "INSERT INTO lottery_tickets (week_number, player_guid, player_account_id, number1, number2, number3, number4, number5, number6) VALUES ("
                ..
                week_number ..
                ", " ..
                player:GetGUIDLow() ..
                ", " ..
                player:GetAccountId() ..
                ", " ..
                number1 ..
                ", " ..
                number2 ..
                ", " ..
                number3 ..
                ", " ..
                number4 .. ", " .. number5 .. ", " .. number6 .. ")"
            )

            --Add the ticket to the players session
            local new_ticket = {
                ticket_id = WorldDBQuery("SELECT ticket_id FROM lottery_tickets ORDER BY ticket_id DESC LIMIT 1"):
                    GetUInt32(
                        0
                    ),
                week_number = week_number,
                player_guid = player:GetGUIDLow(),
                player_account_id = player:GetAccountId(),
                number1 = number1,
                number2 = number2,
                number3 = number3,
                number4 = number4,
                number5 = number5,
                number6 = number6
            }

            if (lottery_tickets[player:GetGUIDLow()] == nil) then
                lottery_tickets[player:GetGUIDLow()] = {}
            end
            lottery_tickets[player:GetGUIDLow()][new_ticket.ticket_id] = new_ticket
            creature:SendUnitSay("Your lottery ticket has been purchased! Good luck!", 0)
        end
    end

    LotteryGossipNpc(event, player, creature)
end

RegisterCreatureGossipEvent(npcId, GOSSIP_EVENT_ON_HELLO, LotteryGossipNpc)
RegisterCreatureGossipEvent(npcId, GOSSIP_EVENT_ON_SELECT, LotteryGossipNpcSelect)

local function onSpawnNpc(event, creature) creature:SetNPCFlags(3) end

RegisterCreatureEvent(npcId, 5, onSpawnNpc)
