local fightMaster = {}
fightMaster.Entry = 100009 -- Npc entry for the arena master qeueu

-- Configuration
local QUEUE_CHECK_INTERVAL = 5000 -- seconds
local FIGHT_PREPARATION_TIME = 5 -- seconds
-- Replace MIN_LEVEL with level brackets
local LEVEL_BRACKETS = {
	{ min = 1, max = 80 },

	-- Example of multiple brackets
	-- {min = 1, max = 10},
	-- {min = 11, max = 20},
	-- {min = 21, max = 30},
}

-- Modify QueuedPlayers to store level bracket information
local QueuedPlayers = {} -- Format: { {name = "playername", bracket = bracketIndex}, ... }

local PendingMatches = {}

-- Add new table to track responses
local PlayerResponses = {}

--  ArenaSpawns locations
local ArenaSpawns = {
	-- Gurubashi Arena
	{
        [1] = { map = 0, x = -13228.735351562, y = 292.84020996094, z = 21.857097625732, o = 5.6819310188293 },
        [2] = { map = 0, x = -13182.891601562, y = 258.3525390625, z = 21.857097625732, o = 2.5481877326965 },
	},
	-- -- Example of multiple locations
	-- {
	--     [1] = { map = 559, x = 4085.4497070312, y = 2866.8286132812, z = 12.005926132202, o = 2.0538132190704 },
	--     [2] = { map = 559, x = 4029.5668945312, y = 2972.3181152344, z = 12.110907554626, o = 5.2621712684631 }
	-- },
}

-- Add after configuration section
local ActivePhases = {}

local function GeneratePhaseFromGuids()
	-- Use powers of 2 for phase masks (2, 4, 8, 16, 32, 64, 128, 256, 512)
	local availablePhases = {
		2,
		4,
		8,
		16,
		32,
		64,
		128,
		256,
		512,
		1024,
		2048,
		4096,
		8192,
		16384,
		32768,
		65536,
		131072,
		262144,
		524288,
		1048576,
	}

	-- Find first available phase mask
	for _, phase in ipairs(availablePhases) do
		if not ActivePhases[phase] then
			-- print("Generated phase mask:", phase)
			ActivePhases[phase] = true
			return phase
		end
	end

	-- No available phases found
	return nil
end

local function ReleasePhase(phase)
	if phase then
		ActivePhases[phase] = nil
	end
end

-- Add function to get player's bracket
local function GetPlayerBracket(level)
	for i, bracket in ipairs(LEVEL_BRACKETS) do
		if level >= bracket.min and level <= bracket.max then
			return i
		end
	end
	return nil
end

-- Modify IsPlayerValid to check brackets
local function IsPlayerValid(player)
	if not player then
		return false
	end
	if type(player) ~= "userdata" then
		return false
	end

	-- Use pcall for all potentially dangerous operations
	local success = pcall(function()
		return player:IsInWorld() and player:GetName() ~= nil
	end)

	if not success then
		return false
	end

	-- Check if player's level fits any bracket
	return player:IsInWorld() and GetPlayerBracket(player:GetLevel()) ~= nil
end

-- Modify IsPlayerInQueue
local function IsPlayerInQueue(playerName)
	for _, entry in ipairs(QueuedPlayers) do
		if entry.name == playerName then
			return true
		end
	end
	return false
end

-- Modify RemoveFromQueue
local function RemoveFromQueue(playerName)
	for i, entry in ipairs(QueuedPlayers) do
		if entry.name == playerName then
			table.remove(QueuedPlayers, i)
			return true
		end
	end
	return false
end

local PlayerPositions = {}

local function SavePlayerPosition(player)
	if not IsPlayerValid(player) then
		return
	end
	local name = player:GetName()
	PlayerPositions[name] = {
		map = player:GetMapId(),
		x = player:GetX(),
		y = player:GetY(),
		z = player:GetZ(),
		o = player:GetO(),
	}
end

local function RestorePlayerPosition(player)
	if not IsPlayerValid(player) then
		return
	end
	local name = player:GetName()
	local pos = PlayerPositions[name]
	if pos then
		player:Teleport(pos.map, pos.x, pos.y, pos.z, pos.o)
		PlayerPositions[name] = nil
	end
end

local ActiveFights = {} -- Track active fights and their phases

local function GetFightRewards(condition)
	local rewards = {}
	local query = WorldDBQuery(string.format(
		[[
        SELECT reward_type, entry, amount
        FROM custom_fight_rewards
        WHERE `condition` = '%s'
        AND enabled = 1
    ]],
		condition
	))

	if query then
		repeat
			table.insert(rewards, {
				reward_type = query:GetString(0),
				entry = query:GetUInt32(1),
				amount = query:GetUInt32(2),
			})
		until not query:NextRow()
	end
	return rewards
end

local function DistributeRewards(player, condition)
	if not IsPlayerValid(player) then
		return
	end

	local rewards = GetFightRewards(condition)
	for _, reward in ipairs(rewards) do
		if reward.reward_type == "MONEY" then
			player:ModifyMoney(reward.entry * reward.amount)
			player:SendBroadcastMessage(
				string.format("You received %d copper for %s!", reward.entry * reward.amount, string.lower(condition))
			)
		elseif reward.reward_type == "ITEM" then
			for i = 1, reward.amount do
				if player:AddItem(reward.entry, 1) then
					local itemLink = "|cff00ff00|Hitem:"
						.. reward.entry
						.. ":0:0:0:0:0:0:0:0|h"
						.. GetItemLink(reward.entry)
						.. "|r"
					player:SendBroadcastMessage(
						string.format("You received %s for %s!", itemLink, string.lower(condition))
					)
				end
			end
		end
	end
end

local function HandleFightEnd(player1, player2, fightPhase)
	-- Store names and positions immediately
	local player1Data = {
		name = player1 and player1:GetName(),
		position = player1 and PlayerPositions[player1:GetName()],
		isAlive = player1 and player1:IsAlive(),
	}
	local player2Data = {
		name = player2 and player2:GetName(),
		position = player2 and PlayerPositions[player2:GetName()],
		isAlive = player2 and player2:IsAlive(),
	}

	-- Determine winner and loser
	local winner = nil
	local loser = nil
	if player1Data.isAlive and not player2Data.isAlive then
		winner = player1
		loser = player2
	elseif player2Data.isAlive and not player1Data.isAlive then
		winner = player2
		loser = player1
	end

	-- Distribute rewards
	if winner and loser then
		DistributeRewards(winner, "WIN")
		DistributeRewards(loser, "LOSE")
	end

	-- First delay to ensure combat is fully cleared
	CreateLuaEvent(function()
		-- Try to get players again
		local p1 = player1Data.name and GetPlayerByName(player1Data.name)
		local p2 = player2Data.name and GetPlayerByName(player2Data.name)

		-- Handle player 1
		if p1 then
			pcall(function()
				p1:SetPhaseMask(1, true)
				-- set setffa and setpvp
				p1:SetFFA(false)
				p1:SetPvP(false)
				p1:RestoreFaction()

				if not p1:IsAlive() then
					p1:ResurrectPlayer(100, false)
					p1:SetHealth(p1:GetMaxHealth())
				end
			end)
		end

		-- Handle player 2
		if p2 then
			pcall(function()
				p2:SetPhaseMask(1, true)
				-- set setffa and setpvp
				p2:SetFFA(false)
				p2:SetPvP(false)
				p2:RestoreFaction()

				if not p2:IsAlive() then
					p2:ResurrectPlayer(100, false)
					p2:SetHealth(p2:GetMaxHealth())
				end
			end)
		end

		-- Try to get players one final time
		p1 = player1Data.name and GetPlayerByName(player1Data.name)
		p2 = player2Data.name and GetPlayerByName(player2Data.name)

		-- Final restoration attempts
		if p1 and player1Data.position then
			pcall(function()
				p1:Teleport(
					player1Data.position.map,
					player1Data.position.x,
					player1Data.position.y,
					player1Data.position.z,
					player1Data.position.o
				)
			end)
		end

		if p2 and player2Data.position then
			pcall(function()
				p2:Teleport(
					player2Data.position.map,
					player2Data.position.x,
					player2Data.position.y,
					player2Data.position.z,
					player2Data.position.o
				)
			end)
		end

		-- Clean up
		if player1Data.name then
			PlayerPositions[player1Data.name] = nil
			ActiveFights[player1Data.name] = nil
		end
		if player2Data.name then
			PlayerPositions[player2Data.name] = nil
			ActiveFights[player2Data.name] = nil
		end

		ReleasePhase(fightPhase)
	end, 500, 1)
end

-- Add this helper function for safe faction checks
local function SafelyCheckFaction(player)
	if not IsPlayerValid(player) then
		return false
	end

	local success, faction = pcall(function()
		return player:GetFaction()
	end)

	if not success then
		return false
	end

	return faction == 14
end

-- Replace the PreparePlayerForCombat function
local function PreparePlayerForCombat(player)
	if not IsPlayerValid(player) then
		return false
	end

	-- Set initial combat flags
	pcall(function()
		player:SetFFA(true)
		player:SetPvP(true)
		player:SetFaction(14)
	end)

	-- Verify settings with multiple retries
	local verificationAttempts = 0
	local maxAttempts = 3

	local function VerifyAndFixSettings()
		verificationAttempts = verificationAttempts + 1

		if not IsPlayerValid(player) then
			return false
		end

		local needsRetry = false

		-- Safe faction check and fix
		if not SafelyCheckFaction(player) then
			pcall(function()
				player:SetFaction(14)
			end)
			needsRetry = true
		end

		-- Safe PvP flag check and fix
		local pvpSuccess, isPvP = pcall(function()
			return player:IsPvPFlagged()
		end)
		if not (pvpSuccess and isPvP) then
			pcall(function()
				player:SetPvP(true)
			end)
			needsRetry = true
		end

		-- Safe FFA check and fix
		local ffaSuccess, isFFA = pcall(function()
			return player:IsFFAPvPFlagged()
		end)
		if not (ffaSuccess and isFFA) then
			pcall(function()
				player:SetFFA(true)
			end)
			needsRetry = true
		end

		if needsRetry and verificationAttempts < maxAttempts then
			CreateLuaEvent(VerifyAndFixSettings, 100, 1)
			return false
		end

		return true
	end

	-- Start the verification process
	VerifyAndFixSettings()
	return true
end

local function StartFight(player1, player2)
	if not IsPlayerValid(player1) or not IsPlayerValid(player2) then
		return false
	end

	-- Generate unique phase from player GUIDs
	local fightPhase = GeneratePhaseFromGuids()
	if not fightPhase then
		player1:SendBroadcastMessage("Could not find available phase. Please try again.")
		player2:SendBroadcastMessage("Could not find available phase. Please try again.")
		return false
	end

	-- Set and verify phases
	player1:SetPhaseMask(fightPhase, true)
	player2:SetPhaseMask(fightPhase, true)

	-- Verify phase setting worked
	if player1:GetPhaseMask() ~= fightPhase or player2:GetPhaseMask() ~= fightPhase then
		ReleasePhase(fightPhase)
		return false
	end

	-- Send phase info to players
	player1:SendBroadcastMessage("You are in phase " .. fightPhase)
	player2:SendBroadcastMessage("You are in phase " .. fightPhase)

	-- Save positions before teleporting
	SavePlayerPosition(player1)
	SavePlayerPosition(player2)

	-- Randomly select an arena
	local arenaIndex = math.random(1, #ArenaSpawns)
	local selectedArena = ArenaSpawns[arenaIndex]

	-- Teleport players to random arena
	player1:Teleport(
		selectedArena[1].map,
		selectedArena[1].x,
		selectedArena[1].y,
		selectedArena[1].z,
		selectedArena[1].o
	)
	player2:Teleport(
		selectedArena[2].map,
		selectedArena[2].x,
		selectedArena[2].y,
		selectedArena[2].z,
		selectedArena[2].o
	)

	--  Prepare players for combat
	if not PreparePlayerForCombat(player1) or not PreparePlayerForCombat(player2) then
		ReleasePhase(fightPhase)
		return false
	end

	-- Double check after a short delay to ensure settings stuck
	CreateLuaEvent(function()
		PreparePlayerForCombat(player1)
		PreparePlayerForCombat(player2)
	end, 500, 1)

	-- Prepare players for fight
	player1:RemoveAllAuras()
	player2:RemoveAllAuras()
	player1:ResetAllCooldowns()
	player2:ResetAllCooldowns()
	player1:SetHealth(player1:GetMaxHealth())
	player2:SetHealth(player2:GetMaxHealth())

	-- Store fight information
	local player1Name = player1:GetName()
	local player2Name = player2:GetName()
	ActiveFights[player1Name] = {
		opponent = player2Name,
		phase = fightPhase,
	}
	ActiveFights[player2Name] = {
		opponent = player1Name,
		phase = fightPhase,
	}

	-- Start the fight after preparation time
	CreateLuaEvent(function()
		if IsPlayerValid(player1) and IsPlayerValid(player2) then
			player1:SendBroadcastMessage("Fight starting against " .. player2:GetName())
			player2:SendBroadcastMessage("Fight starting against " .. player1:GetName())
			-- player1:StartFight(player2)
			print("Fight starting")
			-- Create event to monitor fight end and reset phases
			CreateLuaEvent(function()
				-- if not player1:IsInCombat() and not player2:IsInCombat() then
				-- Resurrect players if they're dead
				if not player1:IsAlive() then
					player1:ResurrectPlayer(100, false)
					player1:SetHealth(player1:GetMaxHealth())
					print("Player 1 is dead")
				end
				if not player2:IsAlive() then
					player2:ResurrectPlayer(100, false)
					player2:SetHealth(player2:GetMaxHealth())
					print("Player 2 is dead")
				end

				-- Short delay before teleporting back
				CreateLuaEvent(function()
					-- Reset phases
					player1:SetPhaseMask(1, true)
					player2:SetPhaseMask(1, true)
					ReleasePhase(fightPhase)
					-- Restore original positions
					RestorePlayerPosition(player1)
					RestorePlayerPosition(player2)
					print("Restored positions")
				end, 500, 1)
			end, 1000, 30) -- Check every second for 30 seconds
		end
	end, FIGHT_PREPARATION_TIME * 1000, 1)

	return true
end

local function CreateMatchConfirmation(player1, player2)
	if not IsPlayerValid(player1) or not IsPlayerValid(player2) then
		return
	end

	-- Create unique match ID
	local matchId = tostring(player1:GetGUID()) .. "-" .. tostring(player2:GetGUID())

	-- Clear any previous responses for these players
	PlayerResponses[player1:GetName()] = nil
	PlayerResponses[player2:GetName()] = nil

	PendingMatches[matchId] = {
		player1 = player1:GetName(),
		player2 = player2:GetName(),
		accepted1 = false,
		accepted2 = false,
		timeoutEvent = nil,
	}

	-- Send confirmation messages to both players
	local function SendMatchInfo(player, opponent)
		player:SendBroadcastMessage("=========================")
		player:SendBroadcastMessage("Fight match found vs " .. opponent:GetName())
		player:SendBroadcastMessage("Type #yes to accept or #no to decline")
		player:SendBroadcastMessage("You have 30 seconds to respond")
		player:SendBroadcastMessage("=========================")
		player:PlayDirectSound(8959)
	end

	SendMatchInfo(player1, player2)
	SendMatchInfo(player2, player1)

	-- Store eventId for proper removal
	PendingMatches[matchId].timeoutEvent = CreateLuaEvent(function()
		if PendingMatches[matchId] then
			local p1, p2 =
				GetPlayerByName(PendingMatches[matchId].player1), GetPlayerByName(PendingMatches[matchId].player2)

			if IsPlayerValid(p1) then
				p1:SendBroadcastMessage("Fight request timed out!")
			end
			if IsPlayerValid(p2) then
				p2:SendBroadcastMessage("Fight request timed out!")
			end

			PendingMatches[matchId] = nil
		end
	end, 30000, 1)
end

local function IsPhaseAvailable()
	local availablePhases = {
		2,
		4,
		8,
		16,
		32,
		64,
		128,
		256,
		512,
		1024,
		2048,
		4096,
		8192,
		16384,
		32768,
		65536,
		131072,
		262144,
		524288,
		1048576,
	}

	for _, phase in ipairs(availablePhases) do
		if not ActivePhases[phase] then
			return true
		end
	end
	return false
end

-- Modify ProcessQueue to match players in same bracket
local function ProcessQueue(eventId, delay, repeats)
	-- Group players by bracket
	local bracketQueues = {}
	for _, entry in ipairs(QueuedPlayers) do
		bracketQueues[entry.bracket] = bracketQueues[entry.bracket] or {}
		table.insert(bracketQueues[entry.bracket], entry)
	end

	-- Process each bracket
	for bracket, players in pairs(bracketQueues) do
		if #players >= 2 and IsPhaseAvailable() then
			-- Pick two random players from same bracket
			local idx1 = math.random(1, #players)
			local player1 = GetPlayerByName(players[idx1].name)
			RemoveFromQueue(players[idx1].name)

			local idx2 = math.random(1, #players - 1)
			if idx2 >= idx1 then
				idx2 = idx2 + 1
			end
			local player2 = GetPlayerByName(players[idx2].name)
			RemoveFromQueue(players[idx2].name)

			if IsPlayerValid(player1) and IsPlayerValid(player2) then
				CreateMatchConfirmation(player1, player2)
			end
		end
	end
end

local function onSpawn(event, creature)
	creature:SetFaction(35)
	creature:SetNPCFlags(3)
end


-- Player:GossipSendPOI( x, y, icon, flags, data, iconText )
-- Modify gossip menu to show bracket information
function fightMaster.NpcHello(event, player, object)
	local playerName = player:GetName()
	local queueStatus = IsPlayerInQueue(playerName) and "|cFF00FF00In Queue|r" or "|cFFFF0000Not in Queue|r"
	local playerBracket = GetPlayerBracket(player:GetLevel())

	player:GossipMenuAddItem(0, "Queue For 1v1 Fight", 0, 1)
	player:GossipMenuAddItem(0, "Leave Queue", 0, 2)
	player:GossipMenuAddItem(0, "Your Status: " .. queueStatus, 0, 3)
	player:GossipMenuAddItem(
		0,
		"Your Bracket: " .. LEVEL_BRACKETS[playerBracket].min .. "-" .. LEVEL_BRACKETS[playerBracket].max,
		0,
		4
	)
	player:GossipMenuAddItem(0, "Players in queue: " .. #QueuedPlayers, 0, 5)
	-- add queue for each bracket with min-max range
	for i, bracket in ipairs(LEVEL_BRACKETS) do
		local count = 0
		for _, entry in ipairs(QueuedPlayers) do
			if entry.bracket == i then
				count = count + 1
			end
		end
		player:GossipMenuAddItem(
			0,
			string.format("Players in bracket %d-%d: %d", bracket.min, bracket.max, count),
			0,
			6 + i
		)
	end
	player:GossipSendMenu(1, object)
end

-- Modify Selection to include bracket information
function fightMaster.Selection(event, player, object, sender, intid, code, menu_id)
	if intid == 1 then
		if not IsPlayerValid(player) then
			player:SendBroadcastMessage("You cannot queue at this time.")
			return
		end

		if not IsPlayerInQueue(player:GetName()) then
			local bracket = GetPlayerBracket(player:GetLevel())
			table.insert(QueuedPlayers, {
				name = player:GetName(),
				bracket = bracket,
			})
			player:SendBroadcastMessage(
				string.format(
					"You have been added to the 1v1 queue (Bracket: %d-%d)",
					LEVEL_BRACKETS[bracket].min,
					LEVEL_BRACKETS[bracket].max
				)
			)
		end
	elseif intid == 2 then
		if RemoveFromQueue(player:GetName()) then
			player:SendBroadcastMessage("You have been removed from the queue.")
		end
	end

	player:GossipComplete()
end

local function IsPlayerInPendingMatch(playerName)
	for _, match in pairs(PendingMatches) do
		if match.player1 == playerName or match.player2 == playerName then
			return true
		end
	end
	return false
end

-- Add new chat command handler
local function HandleChatCommand(event, player, msg, Type, lang)
	if not IsPlayerValid(player) then
		return true
	end

	local playerName = player:GetName()
	local lowerMsg = msg:lower()

	-- Only handle #yes/#no if player has a pending match
	if (lowerMsg == "#yes" or lowerMsg == "#no") and IsPlayerInPendingMatch(playerName) then
		if PlayerResponses[playerName] then
			player:SendBroadcastMessage("You have already responded to the fight request!")
			return false
		end

		for matchId, match in pairs(PendingMatches) do
			if match.player1 == playerName or match.player2 == playerName then
				if lowerMsg == "#yes" then
					-- Mark player as responded
					PlayerResponses[playerName] = true

					if match.player1 == playerName then
						match.accepted1 = true
					else
						match.accepted2 = true
					end

					player:SendBroadcastMessage("You accepted the fight!")

					-- If both accepted, start the fight
					if match.accepted1 and match.accepted2 then
						local p1 = GetPlayerByName(match.player1)
						local p2 = GetPlayerByName(match.player2)

						if IsPlayerValid(p1) and IsPlayerValid(p2) then
							StartFight(p1, p2)
						end

						-- Clear responses when match starts
						PlayerResponses[match.player1] = nil
						PlayerResponses[match.player2] = nil

						if match.timeoutEvent then
							RemoveEventById(match.timeoutEvent)
						end
						PendingMatches[matchId] = nil
					end
					return false
				elseif lowerMsg == "#no" then
					-- Mark player as responded
					PlayerResponses[playerName] = true

					local p1 = GetPlayerByName(match.player1)
					local p2 = GetPlayerByName(match.player2)

					if p1 then
						p1:SendBroadcastMessage("Fight was declined!")
					end
					if p2 then
						p2:SendBroadcastMessage("Fight was declined!")
					end

					-- Clear responses when match is declined
					PlayerResponses[match.player1] = nil
					PlayerResponses[match.player2] = nil

					if match.timeoutEvent then
						RemoveEventById(match.timeoutEvent)
					end
					PendingMatches[matchId] = nil
					return false
				end
			end
		end
		return false -- Only block #yes/#no commands
	end
	-- Let all other chat messages through
	return true
end

local function OnPlayerDeath(event, player, killer)
	if not IsPlayerValid(player) then
		return
	end

	local playerName = player:GetName()
	local fightInfo = ActiveFights[playerName]

	if fightInfo then
		local opponent = GetPlayerByName(fightInfo.opponent)
		if IsPlayerValid(opponent) then
			HandleFightEnd(player, opponent, fightInfo.phase)
		else
			-- Handle case where opponent is invalid
			if IsPlayerValid(player) then
				player:SetPhaseMask(1, true)
				RestorePlayerPosition(player)
				ActiveFights[playerName] = nil
			end
			ReleasePhase(fightInfo.phase)
		end
	end
end

local function OnPlayerLogout(event, player)
	if not player then
		return
	end

	local playerName = player:GetName()

	-- Remove from queue
	RemoveFromQueue(playerName)

	-- Clean up any pending matches
	for matchId, match in pairs(PendingMatches) do
		if match.player1 == playerName or match.player2 == playerName then
			local opponent = match.player1 == playerName and match.player2 or match.player1
			local opponentPlayer = GetPlayerByName(opponent)

			if opponentPlayer then
				opponentPlayer:SendBroadcastMessage("Match cancelled - opponent logged out")
			end

			if match.timeoutEvent then
				RemoveEventById(match.timeoutEvent)
			end
			PendingMatches[matchId] = nil
		end
	end

	-- Clean up any active fights
	local fightInfo = ActiveFights[playerName]
	if fightInfo then
		local opponent = GetPlayerByName(fightInfo.opponent)
		if opponent then
			HandleFightEnd(player, opponent, fightInfo.phase)
		else
			ReleasePhase(fightInfo.phase)
		end
		ActiveFights[playerName] = nil
	end

	-- Clean up stored positions
	PlayerPositions[playerName] = nil
end

local CREATURE_EVENT_ON_SPAWN = 5
--  // (event, creature)
local GOSSIP_EVENT_ON_HELLO = 1
--  // (event, player, object)
local GOSSIP_EVENT_ON_SELECT = 2
-- // (event, player, object, sender, intid, code, menu_id)
local PLAYER_EVENT_ON_CHAT = 18
-- // (event, player, msg, Type, lang)

local PLAYER_EVENT_ON_DEATH = 6
-- // (event, player, killer)
local PLAYER_EVENT_ON_LOGOUT = 4
-- // (event, player)

-- Register events
CreateLuaEvent(ProcessQueue, QUEUE_CHECK_INTERVAL, 0)
RegisterCreatureEvent(fightMaster.Entry, CREATURE_EVENT_ON_SPAWN, onSpawn)
RegisterCreatureGossipEvent(fightMaster.Entry, GOSSIP_EVENT_ON_HELLO, fightMaster.NpcHello)
RegisterCreatureGossipEvent(fightMaster.Entry, GOSSIP_EVENT_ON_SELECT, fightMaster.Selection)
RegisterPlayerEvent(PLAYER_EVENT_ON_CHAT, HandleChatCommand)
RegisterPlayerEvent(PLAYER_EVENT_ON_DEATH, OnPlayerDeath)
RegisterPlayerEvent(PLAYER_EVENT_ON_LOGOUT, OnPlayerLogout)
