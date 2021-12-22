local MSG_TJ = "#tj"

local function Target_jump(event, player, msg, Type, lang)
    local selectTarget = player:GetSelection()-- Make it so you select target
    if (not selectTarget) then -- Make it so you select urself
         selectTarget = player -- Make it so you select urself
    end

    local gmRank = player:GetGMRank()
    if (gmRank >= 3) then -- change number (0-3) 0 - to all  1,2,3 GM with rank
if (msg:find(MSG_TJ)) then
            x = selectTarget:GetX()
            y = selectTarget:GetY()
            z = selectTarget:GetZ()
            player:MoveJump(x, y, z, 20, 25, 0)
            return false
        end
    end
end

RegisterPlayerEvent(18, Target_jump)