--[[
example: .stackaura <aura> <amount>


 ]] local MSG_STACKAURA = "stackaura" -- #command for triggering
 local FILE_NAME = string.match(debug.getinfo(1, "S").source, "[^/\\]*.lua$")
 local PLAYER_EVENT_ON_COMMAND = 42

 local function splitString(str, delimiter)
     local result = {}
     local from = 1 -- start of the word
     local delim_from, delim_to = string.find(str, delimiter, from)
     while delim_from do
         table.insert(result, string.sub(str, from, delim_from - 1))
         from = delim_to + 1
         delim_from, delim_to = string.find(str, delimiter, from) -- find the next word
     end
     table.insert(result, string.sub(str, from)) -- insert tailing element
     return result
 end

 local function stackAura(event, player, command)
     if player:GetGMRank() <= 2 then
         player:SendBroadcastMessage("You Dont have access to this.")
         return false
     end
     if (command:find(MSG_STACKAURA)) then

         local args = splitString(command, " ")
         local auraID = tonumber(args[2])
         local stackSize = tonumber(args[3])

         if not stackSize then -- will check if chat msg contants args3 if not will set it to 1
             stackSize = 1
         end
         local selectTarget = player:GetSelection()
         if (not selectTarget or player) then
             selectTarget = player
         end

         -- if aura is not active then add aura and set stacks
         if not selectTarget:HasAura(auraID) then
             selectTarget:AddAura(auraID, selectTarget)
             selectTarget:GetAura(auraID):SetStackAmount(stackSize)
         else
             -- if aura is active then add stacks
             selectTarget:GetAura(auraID):SetStackAmount(selectTarget:GetAura(auraID):GetStackAmount() + stackSize)
             selectTarget:SendBroadcastMessage("Aura is already active, stacks increased by " .. stackSize)
         end

     end
 end

 RegisterPlayerEvent(PLAYER_EVENT_ON_COMMAND, stackAura)
