local MSG_GOLD = "mod gold" --#command for triggering .mod gold 123 or -123 to remove gold
local FILE_NAME = string.match(debug.getinfo(1, "S").source, "[^/\\]*.lua$")
local function goldFix(event, player, command)
    if not player:IsGM() then
        return
    end

    if (command:find(MSG_GOLD)) then
        local copperAmt = tonumber(tostring(string.gsub(command, "mod gold ", "")))
        player:ModifyMoney(copperAmt * 10000)
        player:SendBroadcastMessage("|cff00ff00[World]|r You have been given " .. copperAmt .. " gold.")

        return false
    end
end
PrintInfo("[" .. FILE_NAME .. "] module loaded.")

RegisterPlayerEvent(42, goldFix)
