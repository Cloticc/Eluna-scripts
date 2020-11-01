local StackTest = {26393} -- Can put mkae in with ,

local MSG_TESTSTACK = ("#stack")

local function TestStack(event, player, msg, Type, lang)
    if (msg:find(MSG_TESTSTACK)) then
        for _, v in pairs(StackTest) do
            if not player:HasAura(v) then
                player:AddAura(v, player)
            else
                local v = player:GetAura(v)
                if v:GetStackAmount() < 100 then
                    v:SetStackAmount(v:GetStackAmount() + 3) --Give stacks from StackTest
                end

                player:SendBroadcastMessage("|cFFFFFF9F" .. "You Have max stacks " .. v:GetStackAmount())
            end
        end
        return false
    end
end
RegisterPlayerEvent(18, TestStack)
