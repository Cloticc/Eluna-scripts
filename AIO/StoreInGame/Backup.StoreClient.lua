local AIO = AIO or require("AIO")

if AIO.AddAddon() then return end

local StoreShop = AIO.AddHandlers("storeframe", {})
-- (ToolTip)
-- local function OnEnterFrame(self, motion)
--     GameTooltip:Hide()
--     GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
--     if (self.type == 1) then
--         GameTooltip:SetHyperlink("spell:" .. self.spellid)
--     elseif (self.type == 2) then
--         GameTooltip:SetHyperlink("item:" .. self.itemid)
--     elseif (self.type == 3) then
--         GameTooltip:SetHyperlink("quest:" .. self.questid)

--         GameTooltip:SetFrameLevel(5)
--         GameTooltip:Show()
--     end
-- end

-- local function OnLeaveFrame(self, motion) GameTooltip:Hide() end
-- local _G = _G
local pressed = false
function OpenStore()

    ToggleGameMenu()
    ShopBackGround:Show()

end

-- (Fix later)
function CloseFrameOnEscape(self, keyOrButton)
    if keyOrButton == "ESCAPE" then
        BackGroundFrame:Hide()
        return false
    end
end

local EscapeButtonKey = CreateFrame("Button", "UIPanelButtonTemplateTest",
                                    GameMenuFrame, "UIPanelButtonTemplate")
EscapeButtonKey:SetHeight(20)
EscapeButtonKey:SetWidth(145)
EscapeButtonKey:SetText("STORE")
EscapeButtonKey:ClearAllPoints()
EscapeButtonKey:SetPoint("bottom", 0, -20)
EscapeButtonKey:SetScript("OnClick", function() OpenStore() end)
EscapeButtonKey:SetFrameLevel(100)

--[[
This is for the Background box rightside
Size-> 578
Coord -> 0.564453125
Size -> 469
Coord -> 0.4580078125

Right side bar
Size -> 188
Coord -> 0.564453125
Size -> 487
Coord -> 0.4755859375

]]

-- local frames = CreateFrame("Frame", Suck, UIParent)
-- frames:SetPoint("CENTER", UIParent)
-- frames:SetSize(650, 500)

-- local TestingBackGroundNew = frames:CreateTexture("BACKGROUND")

-- TestingBackGroundNew:SetDrawLayer("BACKGROUND")
-- TestingBackGroundNew:SetPoint("CENTER")
-- TestingBackGroundNew:SetTexture("Interface/Icons/Store-Main.blp")
-- TestingBackGroundNew:SetTexCoord(0, 0.5546875, 0, 0.4560546875)
-- TestingBackGroundNew:SetSize(650,650)

-- TestingBackGroundNew:Show()

local BackGroundFrame = CreateFrame("Frame", "ShopBackGround", UIParent)
BackGroundFrame:SetPoint("CENTER", UIParent)
BackGroundFrame:SetSize(1000, 750)
BackGroundFrame:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeSize = 1
})
BackGroundFrame:SetBackdropColor(0, 0, 0, .5) -- (Remove)
BackGroundFrame:SetBackdropBorderColor(0, 0, 0) -- (Remove)

BackGroundFrame:EnableMouse(true)
BackGroundFrame:SetMovable(true)
BackGroundFrame:RegisterForDrag("LeftButton")
BackGroundFrame:SetScript("OnDragStart", BackGroundFrame.StartMoving)
BackGroundFrame:SetScript("OnDragStop", BackGroundFrame.StopMovingOrSizing)
BackGroundFrame:SetScript("OnHide", BackGroundFrame.StopMovingOrSizing)
-- BackGroundFrame:SetFrameLevel(5)

-- BackGroundFrame:Show()

local close = CreateFrame("Button", "YourCloseButtonName", BackGroundFrame,
                          "UIPanelCloseButton")

close:SetPoint("TOPRIGHT", BackGroundFrame, "TOPRIGHT")
close:SetScript("OnClick", function() BackGroundFrame:Hide() end)
close:SetFrameLevel(6)

-- local RightBox = BackGroundFrame:CreateTexture("BACKGROUND")
-- RightBox:SetDrawLayer("BACKGROUND")
-- RightBox:SetPoint("RIGHT")
-- RightBox:SetTexture("Interface/Icons/Store-Main.blp")
-- RightBox:SetTexCoord(0, 0.564453125, 0, 0.4580078125)
-- RightBox:SetSize(750, 600)

-- local ntex = button:CreateTexture()
-- ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
-- ntex:SetTexCoord(0, 0.625, 0, 0.6875)
-- ntex:SetAllPoints()
-- button:SetNormalTexture(ntex)

-- local htex = button:CreateTexture()
-- htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
-- htex:SetTexCoord(0, 0.625, 0, 0.6875)
-- htex:SetAllPoints()
-- button:SetHighlightTexture(htex)

-- local ptex = button:CreateTexture()
-- ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
-- ptex:SetTexCoord(0, 0.625, 0, 0.6875)
-- ptex:SetAllPoints()
-- button:SetPushedTexture(ptex)

local BannerTop = BackGroundFrame:CreateTexture("TOPBANNER")
BannerTop:SetDrawLayer("BACKGROUND")
BannerTop:SetPoint("TOP", BackGroundFrame, "TOP", 0, 0)
BannerTop:SetTexture("Interface/Icons/Store-Main.blp")
BannerTop:SetTexCoord(0.380859375, 0.71875, 0.462890625, 0.525390625)
BannerTop:SetSize(346, 64)

--[[ local LeftBox={}

LeftBox = CreateFrame("Frame","LeftBoxForTab",BackGroundFrame)
-- LeftBox:SetDrawLayer("BACKGROUND")
LeftBox:SetPoint("LEFT", 50, 0)
LeftBox.texture = LeftBox:CreateTexture()
LeftBox.texture:SetAllPoints(LeftBox)
LeftBox.texture:SetTexture("Interface/Icons/Store-Main.blp")
-- LeftBox:SetTexture("Interface/Icons/Store-Main.blp")
LeftBox.texture:SetTexCoord(0, 0.18359375, 0.4619140625, 0.9375)
LeftBox:SetSize(200, 600) ]]

local LeftBox = BackGroundFrame:CreateTexture("LEFTSIDE")
LeftBox:SetDrawLayer("BACKGROUND")
LeftBox:SetPoint("LEFT", 50, 0)
LeftBox:SetTexture("Interface/Icons/Store-Main.blp")
LeftBox:SetTexCoord(0, 0.18359375, 0.4619140625, 0.9375)
LeftBox:SetSize(200, 600)


local BoxUp = {}
local BoxDown = {}

-- function LoadBox()
    -- local BoxUp, BoxDown = {}
    -- if not BoxUp and BoxDown then

        for i = 1, 4 do
        -- BoxUp = _G["UpBox" .. i]
            -- local BoxUp = _G["UpBox" .. i]
            BoxUp[i] = CreateFrame("Button", "UpBox" .. i, BackGroundFrame)
            BoxUp[i].texture = BoxUp[i]:CreateTexture()
            BoxUp[i].texture:SetAllPoints(BoxUp[i])
            BoxUp[i].texture:SetTexture("Interface/Icons/Store-Main.blp")

            BoxUp[i].texture:SetTexCoord(0.1875, 0.32421875, 0.6474609375,
                                         0.84765625)
            BoxUp[i]:SetPoint("CENTER", -65 + 155 * (i - 1), 145)
            BoxUp[i]:SetSize(146, 209)
            BoxUp[i]:SetScript("OnClick", function(self, but)
                if but == "LeftButton" then
                    if not pressed then
                        pressed = true
                        BoxUp[i]:LockHighlight()

                    else
                        pressed = false
                        BoxUp[i]:UnlockHighlight()
                    end
                end
                print("BoxUp " .. i)
            end)
            BoxUp[i]:Show()
        end

        for i = 1, 4 do
            --  BoxDown = _G["DownBox" .. i]

            BoxDown[i] = CreateFrame("Button", "DownBox" .. i, BackGroundFrame)
            BoxDown[i].texture = BoxDown[i]:CreateTexture()
            BoxDown[i].texture:SetAllPoints(BoxDown[i])
            BoxDown[i].texture:SetTexture("Interface/Icons/Store-Main.blp")
            BoxDown[i].texture:SetTexCoord(0.1875, 0.32421875, 0.6474609375,
                                           0.84765625)
            BoxDown[i]:SetPoint("CENTER", -65 + 155 * (i - 1), -145)
            BoxDown[i]:SetSize(146, 209)
            BoxDown[i]:SetScript("OnClick", function(self, but)
                if but == "LeftButton" then
                    if not pressed then
                        pressed = true
                        BoxDown[i]:LockHighlight()
                    else
                        pressed = false
                        BoxDown[i]:UnlockHighlight()
                    end
                end
                print("BoxDown " .. i)
            end)
            BoxDown[i]:Show()

        end
--     else
--         if BoxUp[i] and BoxDown[i]:IsVisible() then
--             BoxUp[i]:Hide()
--             BoxDown[i]:Hide()
--         else
--             BoxUp[i]:Show()
--             BoxDown[i]:Show()
--         end
--     end
-- end

-- local Brown_Box = CreateFrame("Button", "Brown_Box", BackGroundFrame)
-- Brown_Box.texture = Brown_Box:CreateTexture()
-- Brown_Box.texture:SetAllPoints(Brown_Box)
-- Brown_Box.texture:SetTexture("Interface/Icons/Store-Main.blp")
-- -- Brown_Box.texture:SetTexCoord(0.001953125, 0.287109375, 0.00390625, 0.8203125)
-- Brown_Box.texture:SetTexCoord(0.1875, 0.32421875, 0.6474609375, 0.84765625)
-- Brown_Box:SetPoint("CENTER", 0, 0)
-- Brown_Box:SetSize(146, 209)
-- -- Brown_Box:SetText("Buy")
-- -- Brown_Box:SetNormalFontObject("GameFontNormal")
-- -- Brown_Box:SetScript("OnEnter", function(self) self:SetAlpha(0.5) end)
-- -- Brown_Box:SetScript("OnLeave", function(self) self:SetAlpha(1) end)
-- Brown_Box:SetScript("OnClick", function(self, but)
--     if but == "LeftButton" then
--         if not pressed then
--             pressed = true
--             Brown_Box:LockHighlight()

--         else
--             pressed = false
--             Brown_Box:UnlockHighlight()
--         end

--     end
-- end)

-- Brown_Box:Show()
-- DiceMasterInspectFrame.traits[i]:SetPoint( "CENTER", -56 + 28*(i-1), -14 )

-- local LeftIconFrame1 = CreateFrame("Button", "LeftIconFrame1", ShopBackGround)
-- LeftIconFrame1:SetSize(172, 34)
-- LeftIconFrame1.t = LeftIconFrame1:CreateTexture()
-- LeftIconFrame1.t:SetAllPoints()
-- LeftIconFrame1.t:SetTexture("Interface/Icons/Store-Main.blp")
-- -- LeftIconFrame1:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- replace placeholders
-- -- LeftIconFrame1:SetHighlightTexture("Interface/icons/ShopBorderGlow") -- replace placeholders
-- LeftIconFrame1.t:SetTexCoord(0.5673828125,0.7353515625,0.4208984375,0.4541015625)
-- -- LeftIconFrame1.t:SetBlendMode("ADD")
-- LeftIconFrame1:SetPoint("LEFT", 65, 250)
-- -- LeftIconFrame1:SetScript("OnClick", function() LoadBrownBoxes2() end)
-- LeftIconFrame1:SetScript("OnClick", function(self, but)
--     if but == "LeftButton" then
--         if not pressed then
--             pressed = true
--             LeftIconFrame1:LockHighlight()
--         else
--             pressed = false
--             LeftIconFrame1:UnlockHighlight()
--         end

--     end
--     print("ASDASDASDAS")
-- end)

local LeftIconFrame = {}
local Text = {
    "Special", "Service", "Scroll", "Pet", "Buff", "Gift", "Spell", "TEST",
    "TEST", "TEST"

}
for FrameBox = 1, #Text do
    -- for FrameBox = #Text, 1, -1 do ----(Should reverse?)

    LeftIconFrame[FrameBox] = CreateFrame("Button", "LeftIconFrame" .. FrameBox,
                                          BackGroundFrame)
    LeftIconFrame[FrameBox]:SetSize(172, 34)
    LeftIconFrame[FrameBox]:SetFrameLevel(100)
    LeftIconFrame[FrameBox].t = LeftIconFrame[FrameBox]:CreateTexture()
    LeftIconFrame[FrameBox].t:SetAllPoints()
    LeftIconFrame[FrameBox].t:SetTexture("Interface/Icons/Store-Main.blp")
    LeftIconFrame[FrameBox].t:SetTexCoord(0.5673828125, 0.7353515625,
                                          0.4208984375, 0.4541015625)
    -- LeftIconFrame[FrameBox].t:SetBlendMode("ADD")
    -- LeftIconFrame[FrameBox]:SetPoint("LEFT", 65, -56 + 55 * (FrameBox - 1))
    LeftIconFrame[FrameBox]:SetPoint("CENTER", LeftBox, "TOP", 0,
                                     -56 + 55 * (1 - FrameBox))
    LeftIconFrame[FrameBox]:SetNormalFontObject("GameFontNormal")
    LeftIconFrame[FrameBox]:SetText(Text[FrameBox])
    -- LeftIconFrame[FrameBox]:SetScript("OnClick", function() end)
    LeftIconFrame[FrameBox]:SetScript("OnClick", function(self, but)
        if but == "LeftButton" then
            if not pressed then
                pressed = true
                LeftIconFrame[FrameBox]:LockHighlight()


            else
                pressed = false
                LeftIconFrame[FrameBox]:UnlockHighlight()
            end

        end
        print("LeftIconFrame " .. FrameBox)
    end)

end
-- LeftIconFrame[i]:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- replace placeholders
-- LeftIconFrame[i]:SetHighlightTexture("Interface/icons/ShopBorderGlow") -- replace placeholders
-- function(self, but)
--     if but == "LeftButton" then
--         if not pressed then
--             pressed = true
--             Services:LockHighlight()
--         else
--             pressed = false
--             Services:UnlockHighlight()
--         end

--     end

local LeftIconPort = {}
local Textures = {
    {"interface/icons/category-icon-featured"},
    {"interface/icons/category-icon-services"},
    {"interface/icons/category-icon-scroll"},
    {"interface/icons/category-icon-enchantscroll"},
    {"interface/icons/category-icon-pets"},
    {"interface/icons/category-icon-free"},
    {"interface/icons/category-icon-book"}
}

for Icon = 1, #Textures do
    LeftIconPort[Icon] = CreateFrame("Frame", "LeftIconPort" .. Icon,
                                     LeftIconFrame[Icon])
    LeftIconPort[Icon]:SetSize(64, 64)
    LeftIconPort[Icon].t = LeftIconPort[Icon]:CreateTexture()
    LeftIconPort[Icon].t:SetAllPoints()
    LeftIconPort[Icon].t:SetTexture(Textures[Icon][1])
    -- LeftIconPort[Icon].t:SetBlendMode("ADD")
    LeftIconPort[Icon]:SetPoint("LEFT", 0, 1)
    -- LeftIconPort[Icon].Tex:SetBlendMode("ADD")
    -- LeftIconPort[Icon]:SetPoint("LEFT", 0, 0)
    -- LeftIconPort[Icon]:SetScript("OnClick", function() LoadBrownBoxes2() end)
    print(Icon)
end
print("LOAD END")

-- name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(spellId or "spellName"[, "spellRank"])

-- local Special = CreateFrame("Button", "Special", LeftIconFrame1)
-- Special:SetSize(65, 65)
-- Special:SetNormalTexture("interface/icons/category-icon-featured")
-- Special:SetPoint("LEFT", 0, 0)
-- -- Special:SetScript("OnClick", function() LoadBrownBoxes1() end)
-- Special:SetScript('OnEnter', function() end)
-- Special:SetScript('OnLeave', function() end)
-- Special:SetScript("OnClick", function(self, but)
--     if but == "LeftButton" then
--         if not pressed then
--             pressed = true
--             Special:LockHighlight()
--             -- button:SetText("AutoMacro ON")
--             -- for i = 1, 12 do
--             --     frames[i]:Show()
--             --     LCG.ButtonGlow_Start(frames[i])
--             -- end
--         else
--             pressed = false
--             Special:UnlockHighlight()
--             -- button:SetText("AutoMacro")
--             -- for i = 1, 12 do
--             --     LCG.ButtonGlow_Stop(frames[i])
--             --     frames[i]:Hide()
--             -- end
--         end
--         -- elseif but == "RightButton" then
--         --     if IsShiftKeyDown() then
--         --         pcall(SlashCmdList["MACRO"])
--         --     else
--         --         config.main:Show()
--         --     end
--     end
-- end)

-- local Services = CreateFrame("Button", "Services", LeftIconFrame2)
-- Services:SetSize(65, 65)
-- Services.t = Services:CreateTexture()
-- Services.t:SetAllPoints()
-- Services.t:SetTexture("interface/icons/category-icon-services")
-- -- Services.t:SetBlendMode("ADD")
-- Services:SetPoint("LEFT", 0, 0)
-- -- Services:SetScript("OnClick", function() LoadBrownBoxes2() end)

-- local Scroll = CreateFrame("Button", "Scroll", LeftIconFrame3)
-- Scroll:SetSize(65, 65)
-- Scroll.t = Scroll:CreateTexture()
-- Scroll.t:SetAllPoints()
-- Scroll.t:SetTexture("interface/icons/category-icon-scroll")
-- -- Scroll.t:SetBlendMode("ADD")
-- Scroll:SetPoint("LEFT", 0, 0)
-- -- Scroll:SetScript("OnClick", function() LoadBrownBoxes2() end)

-- local Pet = CreateFrame("Button", "Pet", LeftIconFrame4)
-- Pet:SetSize(65, 65)
-- Pet.t = Pet:CreateTexture()
-- Pet.t:SetAllPoints()
-- Pet.t:SetTexture("interface/icons/category-icon-pets")
-- -- Pet.t:SetBlendMode("ADD")
-- Pet:SetPoint("LEFT", 0, 0)
-- -- Pet:SetScript("OnClick", function() LoadBrownBoxes2() end)

-- local Enchantscroll = CreateFrame("Button", "Enchantscroll", LeftIconFrame5)
-- Enchantscroll:SetSize(65, 65)
-- Enchantscroll.t = Enchantscroll:CreateTexture()
-- Enchantscroll.t:SetAllPoints()
-- Enchantscroll.t:SetTexture("interface/icons/category-icon-enchantscroll")
-- -- Enchantscroll.t:SetBlendMode("ADD")
-- Enchantscroll:SetPoint("LEFT", 0, 0)
-- -- Enchantscroll:SetScript("OnClick", function() LoadBrownBoxes2() end)

-- local Free = CreateFrame("Button", "Free", LeftIconFrame6)
-- Free:SetSize(65, 65)
-- Free.t = Free:CreateTexture()
-- Free.t:SetAllPoints()
-- Free.t:SetTexture("interface/icons/category-icon-free")
-- -- Free.t:SetBlendMode("ADD")
-- Free:SetPoint("LEFT", 0, 0)
-- -- Free:SetScript("OnClick", function() LoadBrownBoxes2() end)

-- local Book = CreateFrame("Button", "Book", LeftIconFrame7)
-- Book:SetSize(65, 65)
-- Book.t = Book:CreateTexture()
-- Book.t:SetAllPoints()
-- Book.t:SetTexture("interface/icons/category-icon-book")
-- -- Book.t:SetBlendMode("ADD")
-- Book:SetPoint("LEFT", 0, 0)
-- -- Book:SetScript("OnClick", function() LoadBrownBoxes2() end)

-- Brown_Box:SetText(GetCoinTextureString(5000000))

--[[ local BoxItem = BackGroundFrame:CreateTexture("RightBrownBoxe")
BoxItem:SetDrawLayer("BACKGROUND")
BoxItem:SetPoint("CENTER", 0, 0)
BoxItem:SetTexture("Interface/Icons/Store-Main.blp")
BoxItem:SetTexCoord(0.1875, 0.32421875, 0.6474609375, 0.84765625)
BoxItem:SetSize(140, 205) ]]

-- local HighlightTextureForBrownBox =BackGroundFrame:CreateTexture("RightBrownBoxe")
-- HighlightTextureForBrownBox:SetDrawLayer("BACKGROUND")
-- HighlightTextureForBrownBox:SetPoint("CENTER", 0, 0)
-- HighlightTextureForBrownBox:SetTexture("Interface/Icons/Store-Main.blp")
-- HighlightTextureForBrownBox:SetTexCoord(0.369140625, 0.5068359375, 0.7421875,0.9404296875)
-- HighlightTextureForBrownBox:SetSize(140, 205)
-- -- HighlightTextureForBrownBox:SetFrameLevel(1)
-- print("HighlightTextureForBrownBox")

-- local HighlightTextureForBrownBox = BackGroundFrame:CreateTexture("RightBrownBoxe")
-- HighlightTextureForBrownBox:SetDrawLayer("BACKGROUND")
-- HighlightTextureForBrownBox:SetPoint("CENTER", 0, 0)
-- HighlightTextureForBrownBox:SetTexture("Interface/Icons/Store-Main.blp")
-- HighlightTextureForBrownBox:SetTexCoord(0.369140625, 0.5068359375, 0.7421875,0.9404296875)
-- HighlightTextureForBrownBox:SetSize(140, 205)
-- -- HighlightTextureForBrownBox:SetFrameLevel(1)
-- print("HighlightTextureForBrownBox")

-- local Highlight = "Interface/Icons/Store-Main.blp"
-- local Cords = "0.369140625, 0.5068359375, 0.7421875,0.9404296875"
-- local button = CreateFrame("Button", name, BackGroundFrame)

-- button.texture:SetAllPoints(button)
-- button:SetNormalTexture(Highlight.."-".."Normal")
-- button.texture:SetTexCoord(0.1875, 0.32421875, 0.6474609375, 0.84765625)

-- button:SetNormalTexture(Highlight.."-".."Normal")
-- button:SetPushedTexture(Highlight.."-".."Pushed")
-- button:SetHighlightTexture(Highlight.."-".."Highlight")

-- button:SetHitRectInsets(4, 4, 2, 2);
-- button:SetSize(500, 500)

-- btn:SetScript("OnShow",OnShow);
-- btn:SetScript("OnHide",OnHide);
-- btn:SetScript("OnClick",OnClick);
-- btn:SetScript("OnEnter",ex.ItemButton_OnEnter);
-- btn:SetScript("OnLeave",ex.ItemButton_OnLeave);
-- btn:SetScript("OnEvent",OnEvent);
-- btn:SetScript("OnDragStart",OnDrag);
-- btn:SetScript("OnReceiveDrag",OnDrag);

-- for i = 1, BOXES do

-- 	if (i == 1) then
-- 		btn:SetPoint("TOPLEFT",8,-68);
-- 		btn:SetPoint("TOPRIGHT",-28,-68);
-- 	else
-- 		btn:SetPoint("TOPLEFT",buttons[i - 1],"BOTTOMLEFT");
-- 		btn:SetPoint("TOPRIGHT",buttons[i - 1],"BOTTOMRIGHT");
-- 	end
-- end

-- local button = CreateFrame("Button", nil, BackGroundFrame)
-- button:SetPoint("CENTER", BackGroundFrame, "CENTER", 0, 0)
-- button:SetWidth(200)
-- button:SetHeight(50)

-- button:SetText("test")
-- button:SetNormalFontObject("GameFontNormal")

-- local ntex = button:CreateTexture()
-- ntex:SetTexture("Interface/Icons/Store-Main.blp")
-- ntex:SetTexCoord(0, 0.625, 0, 0.6875)
-- ntex:SetAllPoints()
-- button:SetNormalTexture(ntex)

-- local htex = button:CreateTexture()
-- htex:SetTexCoord(0.369140625, 0.5068359375, 0.7421875,0.9404296875)
-- htex:SetSize(140, 205)
-- htex:SetAllPoints()
-- button:SetHighlightTexture(htex)

-- local ptex = button:CreateTexture()
-- ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
-- ptex:SetTexCoord(0, 0.625, 0, 0.6875)
-- ptex:SetAllPoints()
-- button:SetPushedTexture(ptex)

-- local BoxItem1 = BackGroundFrame:CreateTexture("RightBrownBox1")
-- BoxItem1:SetDrawLayer("BACKGROUND")
-- BoxItem1:SetPoint("CENTER", 0, 0)
-- BoxItem1:SetTexture("Interface/Icons/Store-Main.blp")
-- BoxItem1:SetTexCoord(0.1875, 0.32421875, 0.6474609375, 0.84765625)
-- BoxItem1:SetSize(140, 205)
-- -- button:SetPushedTexture(HighlightTextureForBrownBox)
-- button:SetHighlightTexture(HighlightTextureForBrownBox)
-- button:SetScript("OnClick", function() print("fuck")end)

-- local BoxItem2 = BackGroundFrame:CreateTexture("RightBrownBox2")
-- BoxItem2:SetDrawLayer("BACKGROUND")
-- BoxItem2:SetPoint("CENTER", 250, 0)
-- BoxItem2:SetTexture("Interface/Icons/Store-Main.blp")
-- BoxItem2:SetTexCoord(0.1875, 0.32421875, 0.6474609375, 0.84765625)
-- BoxItem2:SetSize(140, 205)
-- -- button:SetPushedTexture(HighlightTextureForBrownBox)
-- button:SetHighlightTexture(HighlightTextureForBrownBox)
-- button:SetScript("OnClick", function() print("fuck2")end)

-- local WowIcon = BackGroundFrame:CreateTexture("LEFTSIDE")
-- WowIcon:SetDrawLayer("BACKGROUND")
-- WowIcon:SetPoint("TOPLEFT", 0, 0)
-- WowIcon:SetTexture("Interface/Icons/Store-Main.blp")
-- WowIcon:SetTexCoord(0.9736328125, 0.9560546875, 0.2900390625, 0.978515625)
-- WowIcon:SetSize(100, 100)

-- (Left Bottom. Right Bottom. Heigt from TOP. Icons end from top)
