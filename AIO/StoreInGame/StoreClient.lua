-- (1)
local AIO = AIO or require("AIO")

if AIO.AddAddon() then return end

local StoreShop = AIO.AddHandlers("storeframe", {})
-- (1)
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

function OpenStore()

    ToggleGameMenu()
    TestFrameOne:Show()
end

local frame = CreateFrame("Button", "UIPanelButtonTemplateTest", GameMenuFrame,
                          "UIPanelButtonTemplate")
frame:SetHeight(20)
frame:SetWidth(145)
frame:SetText("STORE")
frame:ClearAllPoints()
frame:SetPoint("bottom", 0, -20)
frame:SetScript("OnClick", function() OpenStore() end)
frame:SetFrameLevel(100)

local MainFrame = CreateFrame("Frame", "TestFrameOne", UIParent)
MainFrame:SetResizable(true)
MainFrame:SetMinResize(250, 200)
-- (2) Main backwindow

MainFrame:SetPoint("CENTER", UIParent, 50, 0)

MainFrame:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeSize = 1
})
-- MainFrame:SetBackdropColor(0, 0, 0, .5)
-- MainFrame:SetBackdropBorderColor(0, 0, 0)
MainFrame:SetFrameLevel(0)
MainFrame:SetBackdropColor(0, 0, 0, .5)
MainFrame:SetBackdropBorderColor(0, 0, 0)

MainFrame:SetSize(1000, 750)

-- (3)
MainFrame:EnableMouse(true)
MainFrame:SetMovable(true)
MainFrame:RegisterForDrag("LeftButton")
MainFrame:SetScript("OnDragStart", MainFrame.StartMoving)
MainFrame:SetScript("OnDragStop", MainFrame.StopMovingOrSizing)
MainFrame:SetScript("OnHide", MainFrame.StopMovingOrSizing)

-- (4)
function CloseFrameOnEscape(self, keyOrButton)
    if keyOrButton == "ESCAPE" then
        MainFrame:Hide()
        return
    end
end

local close = CreateFrame("Button", "YourCloseButtonName", MainFrame,
                          "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", MainFrame, "TOPRIGHT")
close:SetScript("OnClick", function() MainFrame:Hide() end)

-- (Page function)
--[[     function ItemFlip(event)
        if (event == "STORE_SHOW")then
local FlipPage = CreateFrame("Button","PagePage1",TestFrameOne)
local page = ItemTextGetPage();
		local next = ItemTextHasNextPage();
        end ]]

-- (This is the cards on the right side of the window. Should just loop them instead dunno tho)

-- (Closes to Left/Bars)

local Square1 = CreateFrame("Frame", "Square1", ShopBar1)
Square1:SetSize(85, 85)
Square1.t = Square1:CreateTexture()
Square1.t:SetAllPoints()
Square1.t:SetTexture("interface/icons/CircleGold")
-- Square1.t:SetBlendMode("ADD")
-- Square1.t:SetVertexColor(0, 1, 0, 1)
Square1:SetPoint("TOP", 5, -45)
Square1:SetFrameLevel(1000)
Square1:SetFrameLevel(2)

-- (This is the Circle,Icon,Bar)

local CorruptedInventoryIcon = CreateFrame("Frame", "CorruptedInventoryIcon",
                                           TestFrameOne)
CorruptedInventoryIcon:SetSize(200, 200)
CorruptedInventoryIcon.t = CorruptedInventoryIcon:CreateTexture()
CorruptedInventoryIcon.t:SetAllPoints()
CorruptedInventoryIcon.t:SetTexture("interface/icons/CorruptedInventoryIcon")
-- CorruptedInventoryIcon.t:SetBlendMode("ADD")
-- CorruptedInventoryIcon.t:SetVertexColor(0, 1, 0, 1)
CorruptedInventoryIcon:SetPoint("topleft", 0, 0)

-- local OnClick = "OnClick"

-- (LeftBar)
function LoadThisShit(self, event)

    if event == OnClick then
        local ShopBar1 = CreateFrame("Button", "ShopBar1", TestFrameOne)
        ShopBar1:SetSize(250, 300)
        ShopBar1.t = ShopBar1:CreateTexture()
        ShopBar1.t:SetAllPoints()
        ShopBar1.t:SetTexture("interface/icons/ShopBorderItem")
        ShopBar1:SetPushedTexture("Interface/icons/ShopBorderItemBlue")
        ShopBar1:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        -- ShopBar1.t:SetBlendMode("ADD")
        -- ShopBar1.t:SetVertexColor(0, 1, 0, 1)
        ShopBar1:SetPoint("center", -100, 150)
        ShopBar1:Show()

        local ShopBar2 = CreateFrame("Button", "ShopBar2", TestFrameOne)
        ShopBar2:SetSize(250, 300)
        ShopBar2.t = ShopBar2:CreateTexture()
        ShopBar2.t:SetAllPoints()
        ShopBar2.t:SetTexture("interface/icons/ShopBorderItem")
        ShopBar2:SetPushedTexture("Interface/icons/ShopBorderItemBlue")
        ShopBar2:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        -- ShopBar2.t:SetBlendMode("ADD")
        -- ShopBar2.t:SetVertexColor(0, 1, 0, 1)
        ShopBar2:SetPoint("center", -100, -125)
        ShopBar2:Show()
        -- (Left)
        local ShopBar3 = CreateFrame("Button", "ShopBar3", TestFrameOne)
        ShopBar3:SetSize(250, 300)
        ShopBar3.t = ShopBar3:CreateTexture()
        ShopBar3.t:SetAllPoints()
        ShopBar3.t:SetTexture("interface/icons/ShopBorderItem")
        ShopBar3:SetPushedTexture("Interface/icons/ShopBorderItemBlue")
        ShopBar3:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        -- ShopBar3.t:SetBlendMode("ADD")
        -- ShopBar3.t:SetVertexColor(0, 1, 0, 1)
        ShopBar3:SetPoint("center", 55, 150)
        ShopBar3:Show()
        local ShopBar4 = CreateFrame("Button", "ShopBar4", TestFrameOne)
        ShopBar4:SetSize(250, 300)
        ShopBar4.t = ShopBar4:CreateTexture()
        ShopBar4.t:SetAllPoints()
        ShopBar4.t:SetTexture("interface/icons/ShopBorderItem")
        ShopBar4:SetPushedTexture("Interface/icons/ShopBorderItemBlue")
        ShopBar4:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        -- ShopBar4.t:SetBlendMode("ADD")
        -- ShopBar4.t:SetVertexColor(0, 1, 0, 1)
        ShopBar4:SetPoint("center", 55, -125)
        ShopBar4:Show()
        -- (Right)
        local ShopBar5 = CreateFrame("Button", "ShopBar5", TestFrameOne)
        ShopBar5:SetSize(250, 300)
        ShopBar5.t = ShopBar5:CreateTexture()
        ShopBar5.t:SetAllPoints()
        ShopBar5.t:SetTexture("interface/icons/ShopBorderItem")
        ShopBar5:SetPushedTexture("Interface/icons/ShopBorderItemBlue")
        ShopBar5:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        -- ShopBar5.t:SetBlendMode("ADD")
        -- ShopBar5.t:SetVertexColor(0, 1, 0, 1)
        ShopBar5:SetPoint("center", 210, 150)
        ShopBar5:Show()
        local ShopBar6 = CreateFrame("Button", "ShopBar6", TestFrameOne)
        ShopBar6:SetSize(250, 300)
        ShopBar6.t = ShopBar6:CreateTexture()
        ShopBar6.t:SetAllPoints()
        ShopBar6.t:SetTexture("interface/icons/ShopBorderItem")
        ShopBar6:SetPushedTexture("Interface/icons/ShopBorderItemBlue")
        ShopBar6:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        -- ShopBar6.t:SetBlendMode("ADD")
        -- ShopBar6.t:SetVertexColor(0, 1, 0, 1)
        ShopBar6:SetPoint("center", 210, -125)
        ShopBar6:Show()
        -- (Closes to the right)
        local ShopBar7 = CreateFrame("Button", "ShopBar7", TestFrameOne)
        ShopBar7:SetSize(250, 300)
        ShopBar7.t = ShopBar7:CreateTexture()
        ShopBar7.t:SetAllPoints()
        ShopBar7.t:SetTexture("interface/icons/ShopBorderItem")
        ShopBar7:SetPushedTexture("Interface/icons/ShopBorderItemBlue")
        ShopBar7:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        -- ShopBar7.t:SetBlendMode("ADD")
        -- ShopBar7.t:SetVertexColor(0, 1, 0, 1)
        ShopBar7:SetPoint("center", 365, 150)
        ShopBar7:Show()
        local ShopBar8 = CreateFrame("Button", "ShopBar8", TestFrameOne)
        ShopBar8:SetSize(250, 300)
        ShopBar8.t = ShopBar8:CreateTexture()
        ShopBar8.t:SetAllPoints()
        ShopBar8.t:SetTexture("interface/icons/ShopBorderItem")
        ShopBar8:SetPushedTexture("Interface/icons/ShopBorderItemBlue")
        ShopBar8:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        -- ShopBar8.t:SetBlendMode("ADD")
        -- ShopBar8.t:SetVertexColor(0, 1, 0, 1)
        ShopBar8:SetPoint("center", 365, -125)
        ShopBar8:Show()
    else

        ShopBar1:Hide()
        ShopBar2:Hide()
        ShopBar3:Hide()
        ShopBar4:Hide()
        ShopBar5:Hide()
        ShopBar6:Hide()
        ShopBar7:Hide()
        ShopBar8:Hide()
    end
end

-- local LeftBar = CreateFrame("Frame", "TestFrameOne", TestFrameOne)
-- LeftBar:SetBackdrop({
--     bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
--     edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
--     edgeSize = 5
-- })
-- -- LeftBar:SetBackdropColor(0, 0, 0, .5)
-- -- LeftBar:SetBackdropBorderColor(0, 0, 0)

-- LeftBar:SetBackdropColor(0, 0, 0, .6)
-- LeftBar:SetBackdropBorderColor(0, 0, 0)
-- LeftBar:SetPoint("LEFT", MainFrame, 0)
-- LeftBar:SetSize(265, 745)

--[[ local BlackBar1 = CreateFrame("Frame", "TestFrameOne", TestFrameOne)
BlackBar1:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeSize = 5
})
-- BlackBar:SetBackdropColor(0, 0, 0, .5)
-- BlackBar:SetBackdropBorderColor(0, 0, 0)

BlackBar1:SetBackdropColor(0, 0, 0, .6)
BlackBar1:SetBackdropBorderColor(0, 0, 0)
BlackBar1:SetSize(200, 50)
BlackBar1:SetPoint("LEFT", 25, 225) ]]

local Special = CreateFrame("Button", "Special", MainFrame)
Special:SetSize(65, 65)
Special.t = Special:CreateTexture()
Special.t:SetAllPoints()
Special.t:SetTexture("interface/icons/category-icon-featured")
-- Special.t:SetBlendMode("ADD")
Special:SetPoint("LEFT", 10, 250)
Special:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- replace placeholders
Special:SetHighlightTexture("Interface/icons/ShopBorderGlow") -- replace placeholders
Special:SetScript("OnClick", function() LoadThisShit() end)

local Services = CreateFrame("Button", "Services", MainFrame)
Services:SetSize(65, 65)
Services.t = Services:CreateTexture()
Services.t:SetAllPoints()
Services.t:SetTexture("interface/icons/category-icon-services")
-- Services.t:SetBlendMode("ADD")
Services:SetPoint("LEFT", 10, 200)
Services:SetScript("OnClick", function() LoadThisShit() end)

local Scroll = CreateFrame("Button", "Scroll", MainFrame)
Scroll:SetSize(65, 65)
Scroll.t = Scroll:CreateTexture()
Scroll.t:SetAllPoints()
Scroll.t:SetTexture("interface/icons/category-icon-scroll")
-- Scroll.t:SetBlendMode("ADD")
Scroll:SetPoint("LEFT", 10, 150)

local Enchantscroll = CreateFrame("Button", "Enchantscroll", MainFrame)
Enchantscroll:SetSize(65, 65)
Enchantscroll.t = Enchantscroll:CreateTexture()
Enchantscroll.t:SetAllPoints()
Enchantscroll.t:SetTexture("interface/icons/category-icon-enchantscroll")
-- Enchantscroll.t:SetBlendMode("ADD")
Enchantscroll:SetPoint("LEFT", 10, 100)

local Free = CreateFrame("Button", "Free", MainFrame)
Free:SetSize(65, 65)
Free.t = Free:CreateTexture()
Free.t:SetAllPoints()
Free.t:SetTexture("interface/icons/category-icon-free")
-- Free.t:SetBlendMode("ADD")
Free:SetPoint("LEFT", 10, 50)

local Book = CreateFrame("Button", "Book", MainFrame)
Book:SetSize(65, 65)
Book.t = Book:CreateTexture()
Book.t:SetAllPoints()
Book.t:SetTexture("interface/icons/category-icon-book")
-- Book.t:SetBlendMode("ADD")
Book:SetPoint("LEFT", 10, 0)

-- local BarRightSide = CreateFrame("Button", "BarRightSide", Special)
-- BarRightSide:SetSize(100, 100)
-- BarRightSide.t = BarRightSide:CreateTexture()
-- BarRightSide.t:SetAllPoints()
-- BarRightSide.t:SetTexture("interface/icons/ShopBar")
-- BarRightSide:SetPushedTexture("Interface/icons/ShopBorderItemBlue")
-- BarRightSide:SetHighlightTexture("Interface/icons/BlueBar")
-- -- BarRightSide.t:SetBlendMode("ADD")
-- -- BarRightSide.t:SetVertexColor(0, 1, 0, 1)
-- BarRightSide:SetPoint("center", 0, "center")

-- if Buffs then
--     Frame1:Show()
-- else
-- Frame1:Hide()
-- end

print("Check after if condition")

-- (This will be something )

-- local f = CreateFrame("Frame", "Buffs", TestFrameOne)
-- f:SetSize(135, 125)
-- f.t = f:CreateTexture()
-- f.t:SetAllPoints()
-- f.t:SetTexture("interface/icons/UI-SpellbookIcon-NextPage-Up")
-- -- f.t:SetBlendMode("ADD")
-- f:SetPoint("center", 0, 0)

-- local f = CreateFrame("Frame", "UI-QuestLog-BookIcon", TestFrameOne)
-- f:SetSize(100, 100)
-- f.t = f:CreateTexture()
-- f.t:SetAllPoints()
-- f.t:SetTexture("interface/icons/UI-QuestLog-BookIcon")
-- -- f.t:SetBlendMode("ADD")
-- f:SetPoint("bottomright", 0, 0)

-- local f = CreateFrame("Frame", "ButtonFrame1", TestFrameOne)
-- f:SetSize(135, 125)
-- f.t = f:CreateTexture()
-- f.t:SetAllPoints()
-- f.t:SetTexture("interface/icons/TransmogToast2")
-- -- f.t:SetBlendMode("ADD")
-- f:SetPoint("left", 0, 0)

-- ItemTextNextPageButton()
-- ItemTextPrevPageButton()

-- ItemTextGetPage() - Get the page number of the currently viewed page.
-- ItemTextGetText() - Get the page contents of the currently viewed page.

if not DropDownMenuTest then
    CreateFrame("Button", "DropDownMenuTest", MainFrame,
                "UIDropDownMenuTemplate")
end

DropDownMenuTest:ClearAllPoints()
DropDownMenuTest:SetPoint("TOPRIGHT", 0, 0)
DropDownMenuTest:Show()

local items = {"HUE", "OK", "asdasd"}

local function OnClick(self)
    UIDropDownMenu_SetSelectedID(DropDownMenuTest, self:GetID())
end

local function initialize(self, level)
    local info = UIDropDownMenu_CreateInfo()
    for k, v in pairs(items) do
        info = UIDropDownMenu_CreateInfo()
        info.text = v
        info.value = v
        info.func = OnClick
        UIDropDownMenu_AddButton(info, level)
    end
end

UIDropDownMenu_Initialize(DropDownMenuTest, initialize)
UIDropDownMenu_SetWidth(DropDownMenuTest, 100);
UIDropDownMenu_SetButtonWidth(DropDownMenuTest, 124)
UIDropDownMenu_SetSelectedID(DropDownMenuTest, 1)
UIDropDownMenu_JustifyText(DropDownMenuTest, "LEFT")

print(End)

-- local frameVars = {

--     {x = 0, y = 65},
--     {x = 0, y = 130},
--     {x = 0, y = 195},
--     {x = 0, y = 260},
--     {x = 0, y = 325}

-- }

-- for i = 1, #frameVars do
--     local FFIAS = CreateFrame("Frame", "FrameForITemAndSpell", TestDupeFrame)
--     FFIAS:SetSize(65, 65)
--     FFIAS.t = FFIAS:CreateTexture()
--     FFIAS.t:SetAllPoints()
--     FFIAS.t:SetTexture("interface/icons/Artifacts-PerkRing-Final-Mask")
--     -- f.t:SetBlendMode("ADD")
--     -- f.t:SetVertexColor(0, 0, 0, 0)
--     FFIAS:SetPoint("TOPLEFT", TestFrameOne, "BOTTOMLEFT", frameVars[i].x, frameVars[i].y)
-- end

-- local framefill = {
--     {"interface/icons/wowtoken"},
--     {"interface/icons/garr_currencyicon-xp"}
-- }

-- for i = 1, #framefill do
--     local f = CreateFrame("Frame", nil, TestDupeFrame)

--     f:SetSize(50, 50)

--     f.tex = f:CreateTexture()
--     f.tex:SetAllPoints(f)
--     f.tex:SetTexCoord(0.1, 0.9, 0.1, 0.9) -- cut out crappy icon border
--     f.tex:SetTexture(framefill[i])
--     f:SetFrameLevel(2)
--     f:SetPoint("TOPLEFT", TestDupeFrame, "BOTTOMLEFT", frameVars[i].x, frameVars[i].y)
-- end

-- local rb = CreateFrame("Button", nil, MainFrame)
-- rb:SetPoint("BOTTOMRIGHT", -6, 7)
-- rb:SetSize(16, 16)
-- rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
-- rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
-- rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

-- rb:SetScript("OnMouseDown", function()
-- 	MainFrame:StartSizing("BOTTOMRIGHT")
-- end)
-- rb:SetScript("OnMouseUp", function()
-- 	MainFrame:StopMovingOrSizing()
-- end)

-- local MainFrameTest = CreateFrame("Frame", "YourFrameName", UIParent)
-- MainFrameTest:SetSize(400, 400)
-- MainFrameTest:SetPoint("CENTER")
-- AIO.SavePosition(MainFrameTest)

-- function StoreShop.ShowFrame(player)
--     MainFrameTest:Show()
-- end
-- -- (2)
-- MainFrameTest:SetBackdrop(
--     {
--         bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
--         edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
--         edgeSize = 1
--     }
-- )
-- MainFrameTest:SetBackdropColor(0, 0, 0, .5)
-- MainFrameTest:SetBackdropBorderColor(0, 0, 0)

-- -- -- (3)
-- MainFrameTest:EnableMouse(true)
-- MainFrameTest:SetMovable(true)
-- MainFrameTest:RegisterForDrag("LeftButton")
-- MainFrameTest:SetScript("OnDragStart", MainFrameTest.StartMoving)
-- MainFrameTest:SetScript("OnDragStop", MainFrameTest.StopMovingOrSizing)
-- MainFrameTest:SetScript("OnHide", MainFrameTest.StopMovingOrSizing)

-- -- -- (4)
-- local close = CreateFrame("Button", "YourCloseButtonName", MainFrameTest, "UIPanelCloseButton")
-- close:SetPoint("TOPRIGHT", MainFrameTest, "TOPRIGHT")
-- close:SetScript(
--     "OnClick",
--     function()
--         MainFrameTest:Hide()
--     end
-- )

-- -- -- (5)
-- local text = MainFrameTest:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
-- text:SetPoint("CENTER")
-- text:SetText("Is this thing on?!")
-- MainFrameTest:EnableMouse(true)
-- MainFrameTest:SetMovable(true)
-- MainFrameTest:SetScript(
--     "OnMouseDown",
--     function(self, button)
--         if button == "LeftButton" then
--             self:StartMoving()
--         end
--     end
-- )

--[[ local function Tab_OnClick(self)
    PanelTemplates_SetTab(self:GetParent(), self:GetID())

    local scrollChild = MainFrameTest.ScrollFrame:GetScrollChild()
    if (scrollChild) then
        scrollChild:Hide()
    end

    MainFrameTest.ScrollFrame:SetScrollChild(self.content)
    self.content:Show()
end

local function SetTabs(frame, numTabs, ...)
    frame.numTabs = numTabs

    local contents = {}
    local frameName = frame:GetName()

    for i = 1, numTabs do
        local tab = CreateFrame("Button", frameName .. "Tab" .. i, frame, "CharacterFrameTabButtonTemplate")
        tab:SetID(i)
        tab:SetText(select(i, ...))
        tab:SetScript("OnClick", Tab_OnClick)

        tab.content = CreateFrame("Frame", nil, MainFrameTestl.ScrollFrame)
        tab.content:SetSize(308, 500)
        tab.content:Hide()

        table.insert(contents, tab.content)

        if (i == 1) then
            tab:SetPoint("TOPLEFT", MainFrameTest, "BOTTOMLEFT", 5, 7)
        else
            tab:SetPoint("TOPLEFT", _G[frameName .. "Tab" .. (i - 1)], "TOPRIGHT", -14, 0)
        end
    end

    Tab_OnClick(_G[frameName .. "Tab1"])

    return unpack(contents)
end ]]
--[[ local content1, content2, content3 = SetTabs(MainFrameTest, 3, "VIP", "Gear", "Visual")

function config:CreateMenu()
    content3.btn = CreateFrame("Button", nil, content3, "UIPanelButtonTemplate")
    content3.btn:SetPoint("CENTER")
    content3.btn:SetSize(100, 40)
    content3.btn:SetText("Click me")
    content3.btn:SetScript(
        "OnClick",
        function(self, button)
            print("You clicked me with " .. button)
        end
    )

    content3:Hide()
    return content3
end ]]

--[[ local f = CreateFrame("Frame", nil, MainFrameTest)
f:SetPoint("CENTER")
f:SetSize(50, 50)
f.tex = f:CreateTexture()
f.tex:SetAllPoints(f)
f.tex:SetTexCoord(0.1, 0.9, 0.1, 0.9) -- cut out crappy icon border
f.tex:SetTexture("interface/icons/inv_misc_note_02")
f:SetFrameLevel(2) ]]

-- local f = CreateFrame("Frame", nil, UIParent)
-- f:SetPoint("CENTER")
-- f:SetSize(64, 64)

-- f.tex = f:CreateTexture()
-- f.tex:SetAllPoints(f)
-- f.tex:SetTexture("interface/icons/inv_mushroom_11")

-- (1)

--[[ local f = CreateFrame("Frame", "YourFrameName", UIParent)
f:SetSize(400, 400)
f:SetPoint("CENTER")
AIO.SavePosition(f)

function StoreShop.ShowFrame(player) f:Show() end
-- (2)
f:SetBackdrop({
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeSize = 1,
})
f:SetBackdropColor(0, 0, 0, .5)
f:SetBackdropBorderColor(0, 0, 0)

-- (3)
f:EnableMouse(true)
f:SetMovable(true)
f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", f.StartMoving)
f:SetScript("OnDragStop", f.StopMovingOrSizing)
f:SetScript("OnHide", f.StopMovingOrSizing)

-- (4)
local close = CreateFrame("Button", "YourCloseButtonName", f, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", f, "TOPRIGHT")
close:SetScript("OnClick", function()
	f:Hide()
end)

-- (5)
local text = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
text:SetPoint("CENTER")
text:SetText("Hello World!")
f:EnableMouse(true)
f:SetMovable(true)
f:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" then
        self:StartMoving()
    end
end)
f:SetScript("OnMouseUp", f.StopMovingOrSizing) ]]

-- (4)

-- (5)

-- local close = CreateFrame("Button", "YourCloseButtonName", f)
-- close:SetSize(25, 25)
-- close:SetPoint("TOPRIGHT", f)
-- close:SetScript("OnMouseUp", function() f:Hide() end)

-- local texture1 = close:CreateTexture("TextureTest1")
-- texture1:SetAllPoints(close)
-- texture1:SetTexture(0.5, 1, 1, 0.5)
-- close:SetNormalTexture(texture1)

-- local fontstring1 = close:CreateFontString("FontTest1")
-- fontstring1:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE, MONOCHROME")
-- fontstring1:SetShadowOffset(1, -1)
-- close:SetFontString(fontstring1)
-- close:SetText("X")

-- -- (6)
-- local button = CreateFrame("Button", "ButtonTest", f)
-- button:SetSize(100, 30)
-- button:SetPoint("bottom", f)

-- button:SetScript("OnMouseUp",
--                  function() AIO.Handle("storeframe", "LearnSpells") end)

-- local texture = button:CreateTexture("TextureTest")
-- texture:SetAllPoints(button)
-- texture:SetTexture(0.5, 1, 1, 0.5)
-- button:SetNormalTexture(texture)

-- local fontstring = button:CreateFontString("FontTest")
-- fontstring:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE, MONOCHROME")
-- fontstring:SetShadowOffset(1, -1)
-- button:SetFontString(fontstring)
-- button:SetText("Learn Everything")

-- local TabTestFirst = CreateFrame("Frame", "VIP", f)
-- TabTestFirst:SetSize(400, 400)
-- TabTestFirst:SetPoint("right")
-- AIO.SavePosition(TabTestFirst)
-- TabTestFirst:SetBackdrop(
-- 	{
-- 		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
-- 		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
-- 		edgeSize = 1
-- 	}
-- )
-- TabTestFirst:SetBackdropColor(0, 0, 0, .5)
-- TabTestFirst:SetBackdropBorderColor(0, 0, 0)
-- TabTestFirst:EnableMouse(true)
-- TabTestFirst:SetMovable(true)
-- TabTestFirst:SetScript(
-- 	"OnMouseDown",
-- 	function(self, button)
-- 		if button == "LeftButton" then
-- 			self:StartMoving()
-- 		end
-- 	end
-- )
-- TabTestFirst:SetScript("OnMouseUp", TabTestFirst.StopMovingOrSizing)

-- local f = CreateFrame("f", nil, f)
-- f:SetPoint("BOTTOMLEFT")
-- f:SetSize(64, 64)
-- f.tooltipText = "This might not work"
-- f.tex = f:CreateTexture()
-- f.tex:SetAllPoints(f)
-- f.tex:SetTexture("interface/icons/inv_mushroom_11")
-- f:Show()

-- function OnEnterTippedButton(self)
-- 	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
--     GameTooltip:SetHyperlink("spell:80871:0:0:0:0:0:0:0")
-- 	GameTooltip:Show()
-- end
-- function OnLeaveTippedButton()
-- 	GameTooltip_Hide()
-- end

-- function SetTooltip(self, text)
-- 	if text then
-- 		self.tooltipText = text

-- 		self:SetScript("OnEnter", OnEnterTippedButton)
-- 		self:SetScript("OnLeave", OnLeaveTippedButton)
-- 	else
-- 		self:SetScript("OnEnter", nil)
-- 		self:SetScript("OnLeave", nil)
-- 	end
-- end

-- SetTooltip(hs, "123")
