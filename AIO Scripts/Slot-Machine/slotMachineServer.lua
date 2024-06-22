-- This is the server side only eluna functions and db querys can be ran here no client side code.
local AIO = AIO or require("AIO")

local SlotMachineHandler = AIO.AddHandlers("SlotMachine", {})

local debug = false

local function debugMessage(...)
  if (debug == true) then
    print("DEBUG: ", ...)
  end
end

-- Player:GetCoinage	()-- Returns the Players amount of money in copper
-- Player:SetCoinage()-- Sets the Players amount of money to copper specified
-- player:ModifyMoney( copperAmt )
-- Function to update player's gold based on slot machine result
function SlotMachineHandler.updatePlayerBalance(player, amount)
  -- Assuming 'player' is an Eluna Player object and 'amount' can be positive (winnings) or negative (losses)
  local currentGold = player:GetCoinage() -- Get current gold in copper
  local newGoldAmount = currentGold + (amount * 10000) -- Convert amount to copper and calculate new balance
  if newGoldAmount < 0 then
    newGoldAmount = 0 -- Ensure balance doesn't go negative
  end
  player:SetCoinage(newGoldAmount) -- Update player's gold
  player:CastSpell(player, 11544)
  -- Debug message
  debugMessage("Updated player balance:", player:GetName(), "New Balance:", newGoldAmount / 10000, "gold")
end

-- Function to handle deducted gold from player's balance when they play the slot machine
function SlotMachineHandler.deductGold(player, amount)
  -- Assuming 'player' is an Eluna Player object and 'amount' is the cost to play the slot machine
  local currentGold = player:GetCoinage() -- Get current gold in copper
  local newGoldAmount = currentGold - (amount * 10000) -- Convert amount to copper and calculate new balance
  if newGoldAmount < 0 then
    player:SendAreaTriggerMessage("You do not have enough gold to play the slot machine!")
    return
  end
  player:SetCoinage(newGoldAmount) -- Update player's gold

  -- Debug message
  debugMessage(
    "Deducted gold from player:",
    player:GetName(),
    "Amount:",
    amount,
    "New Balance:",
    newGoldAmount / 10000,
    "gold"
  )
end

function SlotMachineHandler.ToggleWindow(player, toggled)
  if (toggled == true) then
    AIO.Handle(player, "SlotMachine", "HideWindow", false)
  else
    AIO.Handle(player, "SlotMachine", "ShowWindow", true)
  end
end
