local npcEntry = 2118 -- The entry of the NPC


-------------------------------

CharDBQuery(
  "CREATE TABLE IF NOT EXISTS `custom_gold_storage` (`account` int(11) NOT NULL, `name` varchar(255) NOT NULL, `gold` bigint(20) NOT NULL, PRIMARY KEY (`account`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;"
)



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

  local accountId = player:GetAccountId()
  local playerName = player:GetName()
  local query = string.format(
    "INSERT INTO `custom_gold_storage` (`account`, `name`, `gold`) VALUES (%d, '%s', %d) ON DUPLICATE KEY UPDATE `gold` = `gold` + %d, `name` = VALUES(`name`);",
    accountId, playerName, amount, amount)
  CharDBQuery(query)

  player:ModifyMoney(-amount * 10000)
end

-- Function to withdraw gold
local function withdrawGold(player, amount)
  local accountId = player:GetAccountId()
  local query = string.format(
    "UPDATE `custom_gold_storage` SET `gold` = `gold` - %d WHERE `account` = %d AND `gold` >= %d;", amount, accountId, amount)
  CharDBQuery(query)

  player:ModifyMoney(amount * 10000)
end

-- Function to check balance
local function checkBalance(player)
  local accountId = player:GetAccountId()
  local query = string.format("SELECT `gold` FROM `custom_gold_storage` WHERE `account` = %d;", accountId)
  local result = CharDBQuery(query)
  if result then
    local gold = result:GetUInt32(0)
    return gold
  else
    return 0
  end
end

-- Function to display top 5 players with most gold
local function displayTop5()
  local query = "SELECT `name`, SUM(`gold`) as total_gold FROM `custom_gold_storage` GROUP BY `account` ORDER BY total_gold DESC LIMIT 5;"
  local result = CharDBQuery(query)
  local topPlayers = {}
  if result then
    for i = 1, result:GetRowCount() do
      local playerName = result:GetString(0)
      local gold = result:GetUInt32(1)
      table.insert(topPlayers, { name = playerName, gold = gold })
      result:NextRow()
    end
  end
  return topPlayers
end

-- Function to deal with big numbers
local function comma_value(n)
  local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
  return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

local menuIds = 0x7FFFFFFF
local function objectOnSpawn(event, creature)
  creature:SetNPCFlags(3)
end

local function helloOnVendor(event, player, creature)
  player:GossipSetText(string.format("You have %s gold stored.", comma_value(checkBalance(player))))
  player:GossipMenuAddItem(7, "I would like to store my gold.", 1, 1, true)
  player:GossipMenuAddItem(7, "I would like to withdraw my gold.", 1, 2, true)
  -- player:GossipMenuAddItem(0, "--------------------------------------", 1, 3)
  player:GossipMenuAddItem(0, "-----------Leaderboard------------", 1, 3)
  -- player:GossipMenuAddItem(0, "--------------------------------------", 1, 3)

  local topPlayers = displayTop5()
  for i, topPlayer in ipairs(topPlayers) do
    print(topPlayer.name, comma_value(topPlayer.gold))
    player:GossipMenuAddItem(0, string.format("%d. %s - %s gold", i, topPlayer.name, comma_value(topPlayer.gold)), 1, 3)
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
