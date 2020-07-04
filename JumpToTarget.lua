local MSG_TJ = "#tj"

local function TargetJump(event, player, msg, Type, lang)
    selectTarget = player:GetSelection()
    if (not selectTarget) then
        selectTarget = player
    end

    gmRank = player:GetGMRank()
    if (gmRank >= 3) then -- change number (0-3) 0 - to all  1,2,3 GM with rank
        msg = msg:lower()
        if (msg == MSG_TJ) then
            x = selectTarget:GetX()
            y = selectTarget:GetY()
            z = selectTarget:GetZ()
            -- o = :GetO()
            player:MoveJump(x, y, z, 20, 25, 0)
        end
    end
end

RegisterPlayerEvent(18, TargetJump)
