
local npcEntry = 1198 -- The entry of the NPC


 -------------------------------

CharDBQuery(
  "CREATE TABLE IF NOT EXISTS `custom_gold_storage` (`guid` int(11) NOT NULL, `gold` int(11) NOT NULL, PRIMARY KEY (`guid`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;")


-- Function to store gold
local function storeGold(player, amount)
  -- Check if the amount is a whole number
  if amount % 1 ~= 0 then
    player:SendBroadcastMessage("You can only store whole numbers of gold.")
    return
  end

  if player:GetCoinage() < amount * 10000 then
    player:SendBroadcastMessage("You don't have enough gold.")
    return
  end

  local guid = player:GetGUIDLow()
  local query = string.format(
    "INSERT INTO `custom_gold_storage` (`guid`, `gold`) VALUES (%d, %d) ON DUPLICATE KEY UPDATE `gold` = `gold` + %d;",
    guid, amount, amount)
  CharDBQuery(query)

  player:ModifyMoney(-amount * 10000)
end

-- Function to withdraw gold
local function withdrawGold(player, amount)
  local guid = player:GetGUIDLow()
  local query = string.format(
    "UPDATE `custom_gold_storage` SET `gold` = `gold` - %d WHERE `guid` = %d AND `gold` >= %d;", amount, guid, amount)
  CharDBQuery(query)

  player:ModifyMoney(amount * 10000)
end
-- Function to check balance
local function checkBalance(player)
  local guid = player:GetGUIDLow()
  local query = string.format("SELECT `gold` FROM `custom_gold_storage` WHERE `guid` = %d;", guid)
  local result = CharDBQuery(query)
  if result then
    local gold = result:GetUInt32(0)
    return gold
  else
    return 0
  end
end

-- Function to display top 5 players with most gold
local function displayTop5(player)
  local query = "SELECT `guid`, `gold` FROM `custom_gold_storage` ORDER BY `gold` DESC LIMIT 5;"
  local result = CharDBQuery(query)
  local topPlayers = {}
  if result then
    for i = 1, result:GetRowCount() do
      local guid = result:GetUInt32(0)
      local name = GetPlayerByGUID(guid):GetName()
      local gold = result:GetUInt32(1)
      table.insert(topPlayers, { name = name, gold = gold })
      result:NextRow()
    end
  end
  return topPlayers
end

local menuIds = 0x7FFFFFFF
local function objectOnSpawn(event, creature)
  creature:SetNPCFlags(3)
end

local function helloOnVendor(event, player, creature)
  player:GossipSetText(string.format("You have %d gold in your account.", checkBalance(player)))
  player:GossipMenuAddItem(7, "I would like to store my gold.", 1, 1, true)
  player:GossipMenuAddItem(7, "I would like to withdraw my gold.", 1, 2, true)
  player:GossipMenuAddItem(0, "-------------------------------------------", 1,3)
  
  local topPlayers = displayTop5(player)
  for i, playerInfo in ipairs(topPlayers) do
    player:GossipMenuAddItem(0, string.format("%s has %d gold.", playerInfo.name, playerInfo.gold), 0, 0)
  end
  player:GossipSendMenu(menuIds, creature)
end

local function vendorOnSelection(event, player, creature, sender, intId, code, menuId)
  if (intId == 1) then
    storeGold(player, code)
    player:GossipComplete()
  elseif (intId == 2) then
    withdrawGold(player, code)
    player:GossipComplete()
  elseif (intId == 3) then
    player:GossipComplete()
  end
end

local GOSSIP_EVENT_ON_HELLO = 1;
local GOSSIP_EVENT_ON_SELECT = 2;
local CREATURE_EVENT_ON_SPAWN = 5

RegisterCreatureEvent(npcEntry, CREATURE_EVENT_ON_SPAWN, objectOnSpawn)
RegisterCreatureGossipEvent(npcEntry, GOSSIP_EVENT_ON_HELLO, helloOnVendor)
RegisterCreatureGossipEvent(npcEntry, GOSSIP_EVENT_ON_SELECT, vendorOnSelection)
