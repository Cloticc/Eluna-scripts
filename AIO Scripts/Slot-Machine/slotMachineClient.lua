local AIO = AIO or require("AIO")

if AIO.AddAddon() then
  return
end
-- Slot Machine Addon for Eluna with Betting

local SlotMachineHandler = AIO.AddHandlers("SlotMachine", {})
-- Debug flag
local config = {
  debug = true,
  toggled = false,
  width = 400,
  height = 400
}
--  Function to debug messages
local function debugMessage(...)
  if (config.debug == true) then
    print("DEBUG: ", ...)
  end
end

-- Create a toggle button
local toggleButton = CreateFrame("Button", "SlotMachineToggleButton", UIParent)
toggleButton:SetSize(32, 32)
-- toggleButton:SetText("Toggle Slot Machine")
toggleButton:SetPoint("CENTER", UIParent, "CENTER", 600, 100)
toggleButton:SetNormalFontObject("GameFontNormalLarge")
toggleButton:SetHighlightFontObject("GameFontHighlightLarge")
toggleButton:SetNormalTexture("Interface\\Icons\\INV_Misc_Coin_01")
toggleButton:SetHighlightTexture("Interface\\Icons\\INV_Misc_Coin_01")
toggleButton:SetScript(
  "OnClick",
  function()
    AIO.Handle("SlotMachine", "ToggleWindow", config.toggled)
  end
)

local symbols = {
  {icon = "Interface\\Icons\\INV_Misc_Coin_06", probability = 0.75, winMultiplier = 0}, -- Further increased
  {icon = "Interface\\Icons\\INV_Misc_Coin_04", probability = 0.10, winMultiplier = 1.5}, -- Lowered
  {icon = "Interface\\Icons\\INV_Misc_Coin_02", probability = 0.13, winMultiplier = 2}, -- Slightly increased
  {icon = "Interface\\Icons\\achievement_reputation_kirintor", probability = 0.1, winMultiplier = 3}, -- Further lowered
  {icon = "Interface\\Icons\\achievement_boss_cthun", probability = 0.02, winMultiplier =  "jackpot"} -- Jackpot
}

local slotMachineFrame = CreateFrame("Frame", "SlotMachineFrame", UIParent, "UIPanelDialogTemplate")
local spinButton = CreateFrame("Button", nil, slotMachineFrame, "GameMenuButtonTemplate")
local autoSpinButton = CreateFrame("Button", nil, slotMachineFrame, "GameMenuButtonTemplate")
local betSlider = CreateFrame("Slider", "BetSlider", slotMachineFrame, "OptionsSliderTemplate")

tinsert(UISpecialFrames, slotMachineFrame:GetName())
-- Handles hiding the frame from the player.
function SlotMachineHandler.HideWindow(player)
  if config.toggled == true then
    config.toggled = false
    -- hide frames
    slotMachineFrame:Hide()

    debugMessage("Slots Closed")
  end
end

function SlotMachineHandler.ShowWindow(player)
  config.toggled = true
  -- Create main frame
  slotMachineFrame:SetSize(config.width, config.height)
  slotMachineFrame:SetPoint("CENTER", UIParent, "CENTER") -- Position in the middle of the screen
  slotMachineFrame:SetBackdrop(
    {
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
      edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
      edgeSize = 16,
      insets = {left = 8, right = 6, top = 8, bottom = 8}
    }
  )
  slotMachineFrame:SetBackdropBorderColor(0, 0, 0)
  slotMachineFrame:SetBackdropColor(0, 0, 0, 0.5)
  slotMachineFrame:SetPoint("CENTER", UIParent, "CENTER") -- Position in the middle of the screen

  -- Title text
  slotMachineFrame.title = slotMachineFrame:CreateFontString(nil, "OVERLAY")
  slotMachineFrame.title:SetFontObject("GameFontHighlight")
  slotMachineFrame.title:SetPoint("TOP", slotMachineFrame, "TOP", 0, -10)
  slotMachineFrame.title:SetText("Slots")

  -- Create a spin button
  spinButton:SetPoint("BOTTOM", slotMachineFrame, "BOTTOM", -60, 20)
  spinButton:SetSize(100, 40)
  spinButton:SetText("Spin")
  spinButton:SetNormalFontObject("GameFontNormalLarge")
  spinButton:SetHighlightFontObject("GameFontHighlightLarge")

  -- Create an auto-spin button
  autoSpinButton:SetPoint("BOTTOM", slotMachineFrame, "BOTTOM", 60, 20)
  autoSpinButton:SetSize(100, 40)
  autoSpinButton:SetText("Auto Spin: Off")
  autoSpinButton:SetNormalFontObject("GameFontNormalLarge")
  autoSpinButton:SetHighlightFontObject("GameFontHighlightLarge")

  -- Create a slider for betting gold
  betSlider:SetPoint("BOTTOM", slotMachineFrame, "BOTTOM", 0, 100)

  -- Get player's current gold and convert from copper
  local playerGold = math.floor(GetMoney() / 10000)

  betSlider:SetMinMaxValues(1, playerGold) -- Set min to 1 and max to player's gold
  betSlider:SetValue(1) -- Default value
  betSlider:SetValueStep(1) -- Step size

  BetSliderLow:SetText("1") -- Min value text
  BetSliderHigh:SetText(tostring(playerGold)) -- Max value text, converted player's gold to string
  BetSliderText:SetText("Bet Amount: 1") -- Current value text

  -- Update the bet amount text as the slider value changes
  betSlider:SetScript(
    "OnValueChanged",
    function(self, value)
      value = math.floor(value)
      self:SetValue(value)
      BetSliderText:SetText("Bet Amount: " .. value)
    end
  )

  betSlider:SetScript(
    "OnUpdate",
    function()
      BetSliderText:SetText("Bet Amount: " .. betSlider:GetValue())
      -- Update the bet slider's maximum value based on the player's current gold
      UpdateBetSliderMax()
    end
  )
  slotMachineFrame:Show()
  debugMessage("Slots Opened")
end

-- Function to update the bet slider's maximum value based on the player's current gold
function UpdateBetSliderMax()
  local playerGold = math.floor(GetMoney() / 10000) -- Update player's gold
  betSlider:SetMinMaxValues(1, playerGold) -- Update the slider's max value
  BetSliderHigh:SetText(tostring(playerGold)) -- Update the max value text
  -- Ensure the current bet amount does not exceed the new max
  if betSlider:GetValue() > playerGold then
    betSlider:SetValue(playerGold)
    print("Bet amount adjusted to match new maximum.")
  end
end
-- Inside the spinSlotMachine function, after calculating winnings or losses, call updateBetSliderMax
-- For example, after the line where you print "Total winnings: " .. totalWinnings
UpdateBetSliderMax()
-- Create grid
local gridSize = 3
local iconSize = 50
local spacing = 10
local totalWidth = (iconSize + spacing) * gridSize - spacing
local totalHeight = (iconSize + spacing) * gridSize - spacing
local startX = (config.width - totalWidth) / 2
local startY = (config.height - totalHeight) / 4
local icons = {}

for row = 1, gridSize do
  icons[row] = {}
  for col = 1, gridSize do
    local icon = slotMachineFrame:CreateTexture(nil, "ARTWORK")
    icon:SetSize(iconSize, iconSize)
    -- Calculate position for each icon to center the grid
    local posX = startX + (col - 1) * (iconSize + spacing)
    local posY = startY + (row - 1) * (iconSize + spacing)
    icon:SetPoint("TOPLEFT", slotMachineFrame, "TOPLEFT", posX, -posY)
    icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark") -- Placeholder icon
    icons[row][col] = icon
  end
end
-------------------------
-- Function to animate rolling effect
local function animateSlot(icon, finalSymbol)
  local rollDuration = 2 -- Duration of the roll in seconds
  local rollSpeed = 0.05 -- Speed of texture changes in seconds

  local ticker = nil

  local startTime = GetTime()

  ticker =
    C_Timer.NewTicker(
    rollSpeed,
    function()
      if GetTime() - startTime >= rollDuration then
        icon:SetTexture(finalSymbol)
        if ticker then
          ticker:Cancel()
        end
        return
      end
      local randomIndex = math.random(#symbols)
      local randomSymbol = symbols[randomIndex].icon
      icon:SetTexture(randomSymbol)
    end
  )
end

local function blinkIcon(icon, duration)
  local show = true
  local blinkDuration = 0.5 -- Duration in seconds for each blink
  local endTime = GetTime() + duration
  local ticker = nil
  ticker =
    C_Timer.NewTicker(
    blinkDuration,
    function()
      if GetTime() >= endTime then
        if ticker then
          ticker:Cancel()
        end
        icon:Show() -- Ensure the icon is visible after blinking ends
      else
        if show then
          icon:Hide()
        else
          icon:Show()
        end
        show = not show
      end
    end
  )
end

-- Disable and enable buttons
local function disableSpinButton()
  spinButton:Disable()
end
local function enableSpinButton()
  spinButton:Enable()
end

-- Get player's current gold amount
local function getPlayerGold()
  return GetMoney() / 10000
end

-- Deduct bet and check if the player has enough gold
local function hasEnoughGold(betAmount)
  local playerGold = getPlayerGold()
  if playerGold < betAmount then
    print("Not enough gold to place that bet.")
    return false
  end
  return true
end

function generateResults(gridSize, symbols)
  local results = {}
  for row = 1, gridSize do
    results[row] = {}
    for col = 1, gridSize do
      local symbol = selectSymbolBasedOnProbability(symbols)
      results[row][col] = symbol.icon
      animateSlot(icons[row][col], symbol.icon)
    end
  end
  return results
end
function selectSymbolBasedOnProbability(symbols)
  local userGold = getPlayerGold() -- Assume this function returns the user's current gold amount
  local goldAdjustmentFactor = calculateAdjustmentFactor(userGold) -- Calculate an adjustment factor based on gold

  local adjustedSymbols = {}
  for _, symbol in ipairs(symbols) do
    local adjustedSymbol = {
      icon = symbol.icon,
      probability = symbol.probability * goldAdjustmentFactor, -- Adjust probability
      winMultiplier = symbol.winMultiplier
    }
    table.insert(adjustedSymbols, adjustedSymbol)
  end

  local totalProbability = 0
  for _, symbol in ipairs(adjustedSymbols) do
    totalProbability = totalProbability + symbol.probability -- Calculate total probability of adjusted symbols
  end

  local randomPoint = math.random() * totalProbability
  local cumulativeProbability = 0
  for _, symbol in ipairs(adjustedSymbols) do
    cumulativeProbability = cumulativeProbability + symbol.probability -- Calculate cumulative probability of adjusted symbols
    -- debugMessage("Random point: ", randomPoint, "Cumulative probability: ", cumulativeProbability)
    if randomPoint <= cumulativeProbability then
      return symbol
    end
  end
end



function calculateAdjustmentFactor(gold)
  -- TODO adjustments to logi later when i care about this
  local minimumFactor = 0.1 -- Minimum factor to cap the probability decrease
  local maximumFactor = 1.5 -- Maximum factor to cap the probability increase
  local goldThreshold = 1000 -- Gold amount to start adjusting probability
  local goldFactor = math.min(gold / goldThreshold, 1) -- Calculate a factor based on gold
  local adjustmentFactor = minimumFactor + (maximumFactor - minimumFactor) * goldFactor
  debugMessage("Gold: ", gold, "Adjustment factor: ", adjustmentFactor)
  return adjustmentFactor
end
-- function selectSymbolBasedOnProbability(symbols)
--   local totalProbability = 0
--   for _, symbol in ipairs(symbols) do
--     totalProbability = totalProbability + symbol.probability -- Calculate total probability
--   end
--   local randomPoint = math.random() * totalProbability
--   local cumulativeProbability = 0
--   for _, symbol in ipairs(symbols) do
--     cumulativeProbability = cumulativeProbability + symbol.probability -- Calculate cumulative probability
--     debugMessage("Random point: ", randomPoint, "Cumulative probability: ", cumulativeProbability)
--     if randomPoint <= cumulativeProbability then
--       return symbol
--     end
--   end
-- end

---- remove duplicates from winning line
function calculateWinnings(results, betAmount, gridSize, symbols)
  local totalWinnings = 0
  local winsAwarded = {}
  for row = 1, gridSize do
    local lastSymbol = nil
    local consecutiveCount = 1
    local sequenceStartCol = 1
    for col = 1, gridSize do
      local symbol = results[row][col]
      if symbol == lastSymbol then
        consecutiveCount = consecutiveCount + 1
      else
        if consecutiveCount >= 2 and not winsAwarded[lastSymbol] then
          local winMultiplier = getWinMultiplier(lastSymbol, symbols, consecutiveCount)
          local winnings = betAmount * winMultiplier
          totalWinnings = totalWinnings + winnings
          winsAwarded[lastSymbol] = true
          for winCol = sequenceStartCol, sequenceStartCol + consecutiveCount - 1 do
            blinkIcon(icons[row][winCol], 1.2)
          end
          -- Return immediately after the first win is awarded
          return totalWinnings
        end
        consecutiveCount = 1
        sequenceStartCol = col
      end
      lastSymbol = symbol
    end
    -- Check again after the loop in case the winning sequence is at the end
    if consecutiveCount >= 2 and not winsAwarded[lastSymbol] then
      local winMultiplier = getWinMultiplier(lastSymbol, symbols, consecutiveCount)
      local winnings = betAmount * winMultiplier
      totalWinnings = totalWinnings + winnings
      winsAwarded[lastSymbol] = true
      for winCol = sequenceStartCol, sequenceStartCol + consecutiveCount - 1 do
        blinkIcon(icons[row][winCol], 1.2)
      end
      -- Return immediately after the first win is awarded
      return totalWinnings
    end
  end
  return totalWinnings
end

----will win all duplicates if i you use this
-- function calculateWinnings(results, betAmount, gridSize, symbols)
--   local totalWinnings = 0
--   local winsAwarded = {}
--   for row = 1, gridSize do
--     local lastSymbol = nil
--     local consecutiveCount = 1
--     local sequenceStartCol = 1
--     for col = 1, gridSize do
--       local symbol = results[row][col]
--       if symbol == lastSymbol then
--         consecutiveCount = consecutiveCount + 1
--       else
--         if consecutiveCount >= 2 and not winsAwarded[lastSymbol] then
--           local winMultiplier = getWinMultiplier(lastSymbol, symbols, consecutiveCount)
--           local winnings = betAmount * winMultiplier
--           totalWinnings = totalWinnings + winnings
--           if lastSymbol then
--             winsAwarded[lastSymbol] = true
--           end
--           for winCol = sequenceStartCol, sequenceStartCol + consecutiveCount - 1 do
--             blinkIcon(icons[row][winCol], 1.2)
--           end
--         end
--         consecutiveCount = 1
--         sequenceStartCol = col
--       end
--       lastSymbol = symbol
--     end
--     if consecutiveCount >= 2 and not winsAwarded[lastSymbol] then
--       local winMultiplier = getWinMultiplier(lastSymbol, symbols, consecutiveCount)
--       local winnings = betAmount * winMultiplier
--       totalWinnings = totalWinnings + winnings
--       winsAwarded[lastSymbol] = true
--       for winCol = sequenceStartCol, sequenceStartCol + consecutiveCount - 1 do
--         blinkIcon(icons[row][winCol], 1.2)
--       end
--     end
--   end
--   return totalWinnings
-- end

function getWinMultiplier(symbol, symbols, count)
  for _, sym in ipairs(symbols) do
    if sym.icon == symbol then
      -- Check if the symbol is "Interface\Icons\INV_Misc_Coin_06" and count is 3
      if symbol == "Interface\\Icons\\INV_Misc_Coin_06" and count == 3 then
        return 1
      elseif sym.winMultiplier == "jackpot" and count == 3 then
        return 100
      else
        return sym.winMultiplier
      end
    end
  end
  return 1
end
-- function getWinMultiplier(symbol, symbols, count)
--   for _, sym in ipairs(symbols) do
--     if sym.icon == symbol then
--       if sym.winMultiplier == "jackpot" and count == 3 then
--         return 100
--       else
--         return sym.winMultiplier
--       end
--     end
--   end
--   return 1
-- end

local function awardWin(totalWinnings)
  if totalWinnings > 0 then
    print("Congratulations! You won: " .. totalWinnings .. " gold.")
    AIO.Handle("SlotMachine", "updatePlayerBalance", totalWinnings)
  else
    print("Try again!")
  end
end

local function spinSlotMachine()
  disableSpinButton()
  local betAmount = betSlider:GetValue()
  if not hasEnoughGold(betAmount) then
    return
  end
  debugMessage("Bet amount: ", betAmount)
  AIO.Handle("SlotMachine", "deductGold", betAmount)
  local results = generateResults(gridSize, symbols)
  C_Timer.After(
    2.1,
    function()
      local totalWinnings = calculateWinnings(results, betAmount, gridSize, symbols)
      awardWin(totalWinnings)
      enableSpinButton()
      UpdateBetSliderMax()
    end
  )
end

-- Variable to track auto-spin state
local autoSpinActive = false
local autoSpinTicker

-- Function to toggle auto-spin
local function toggleAutoSpin()
  autoSpinActive = not autoSpinActive
  if autoSpinActive then
    autoSpinButton:SetText("Auto Spin: On")
    spinButton:Disable()
    autoSpinTicker = C_Timer.NewTicker(3, spinSlotMachine) -- Auto spin every 3 seconds
  else
    autoSpinButton:SetText("Auto Spin: Off")
    spinButton:Enable()
    if autoSpinTicker then
      autoSpinTicker:Cancel()
      autoSpinTicker = nil
    end
  end
  UpdateBetSliderMax() -- Update the bet slider's max value when toggling auto-spin
end

-- Ensure updateBetSliderMax is called after deducting gold in onSpinButtonClick
local function onSpinButtonClick()
  local betAmount = betSlider:GetValue() -- Get the current bet amount from the slider
  if hasEnoughGold(betAmount) then
    -- Deduct the bet amount from the player's gold
    -- AIO.Handle("SlotMachine", "deductGold", betAmount)
    -- Update the bet slider's maximum value and the displayed gold amount
    UpdateBetSliderMax()
    -- Proceed with spinning the slot machine
    spinSlotMachine()
  else
    print("Not enough gold.")
  end
end

spinButton:SetScript("OnClick", onSpinButtonClick)
autoSpinButton:SetScript("OnClick", toggleAutoSpin)
