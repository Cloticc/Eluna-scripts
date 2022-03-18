--[[ WIP testing sending mail. Atm u do .ttest mail <itemEntry> <itemCount>]]


local mailMan = {}
local MSG_SEND = "ttest" --#command for triggering
local FILE_NAME = string.match(debug.getinfo(1, "S").source, "[^/\\]*.lua$")

function mailMan.stringShit(inputstr)
    local t = {}
    local e, i = 0, 1

    while true do
        local b = e + 1
        b = inputstr:find("%S", b)

        if b == nil then
            break
        end

        if inputstr:sub(b, b) == "'" then
            e = inputstr:find("'", b + 1)
            b = b + 1
        elseif inputstr:sub(b, b) == '"' then
            e = inputstr:find('"', b + 1)
            b = b + 1
        else
            e = inputstr:find("%s", b + 1)
        end

        if e == nil then
            e = #inputstr + 1
        end

        t[i] = inputstr:sub(b, e - 1)
        i = i + 1
    end

    return t
end

function mailMan.sendMail(event, player, command)
    if not player:IsGM() then
        return
    end

    if (command:find(MSG_SEND)) then
        local reciver = ""

        local itemEntry, itemCount = tonumber((mailMan.stringShit(command)[2]) or 0), tonumber((mailMan.stringShit(command)[3]) or 0)

        SendMail(
            "Lost Item",
            "Your inventory was full so this item was mailed to you.",
            player:GetGUIDLow(),
            player:GetGUIDLow(),
            41,
            0,
            0,
            0,
            itemEntry,
            itemCount
        )
print(itemEntry, itemCount)
        return false
    end
end
PrintInfo("["..FILE_NAME.."] module loaded.")
RegisterPlayerEvent(42, mailMan.sendMail)
