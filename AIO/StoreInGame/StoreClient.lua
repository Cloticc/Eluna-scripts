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
local _G = _G

function OpenStore()

    ToggleGameMenu()
    TestFrameOne:Show()

end

-- (Fix later)
function CloseFrameOnEscape(self, keyOrButton)
    if keyOrButton == "ESCAPE" then
        TestFrameOne:Hide()
        return
    end
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
-- frames:SetSize(650, 650)

-- local TestingBackGroundNew = frames:CreateTexture("BACKGROUND")

-- TestingBackGroundNew:SetDrawLayer("BACKGROUND")
-- TestingBackGroundNew:SetPoint("CENTER")
-- TestingBackGroundNew:SetTexture("Interface/Icons/Store-Main.blp")
-- TestingBackGroundNew:SetTexCoord(0, 0.5546875, 0, 0.4560546875)
-- TestingBackGroundNew:SetSize(650,650)

-- TestingBackGroundNew:Show()

-- local RightSide = CreateFrame("Frame", "RightSide", UIParent)
-- RightSide:SetPoint("CENTER", UIParent)
-- RightSide:SetSize(578, 469)

-- local Box = frame:CreateTexture("BACKGROUND")
-- Box:SetDrawLayer("BACKGROUND")
-- Box:SetPoint("CENTER")
-- Box:SetTexture("Interface/Icons/Store-Main.blp")
-- Box:SetTexCoord(0, 0.564453125, 0, 0.4580078125)
-- Box:SetSize(578, 469)

local MainFrame = CreateFrame("Frame", "TestFrameOne", UIParent)
MainFrame:SetResizable(true)
MainFrame:SetMinResize(250, 200)
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
MainFrame:EnableMouse(true)
MainFrame:SetMovable(true)
MainFrame:RegisterForDrag("LeftButton")
MainFrame:SetScript("OnDragStart", MainFrame.StartMoving)
MainFrame:SetScript("OnDragStop", MainFrame.StopMovingOrSizing)
MainFrame:SetScript("OnHide", MainFrame.StopMovingOrSizing)

local close = CreateFrame("Button", "YourCloseButtonName", TestFrameOne,
                          "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", MainFrame, "TOPRIGHT")
close:SetScript("OnClick", function() MainFrame:Hide() end)

--[[ StaticPopupDialogs["EXAMPLE_HELLOWORLD"] = {
    text = "Do you want to greet the world today?",
    button1 = "Yes",
    button2 = "No",
    OnAccept = function() SendChatMessage("HelloWorld!", "SAY") end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true
}
StaticPopup_Show("EXAMPLE_HELLOWORLD")
-- (DropDown)
if not DropDownMenuTest then
    CreateFrame("Button", "DropDownMenuTest", TestFrameOne,
                "UIDropDownMenuTemplate")
end

DropDownMenuTest:ClearAllPoints()
DropDownMenuTest:SetPoint("TOPRIGHT", -50, 0)
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
 ]]
-- (end of dropdown menu)

print("Start LoadThisShit")

-- (LeftBar)

-- function LoadBrownBoxes()
--     local Box1 = _G["BrownBox1"]

--     if not Box1 then
--         Box1 = CreateFrame("Button", "BrownBox1", MainFrame)
--         Box1:SetSize(250, 300)
--         Box1:SetNormalTexture("interface/icons/ShopBorderItem")
--         Box1:SetPushedTexture("Interface/icons/ShopBorderItemBlue")
--         Box1:SetHighlightTexture("Interface/icons/ShopBorderGlow")
--         Box1:SetPoint("CENTER", -100, 150)
--     else
--         if Box1:IsVisible() then
--             Box1:Hide()
--         else
--             Box1:Show()
--         end
--     end
-- end

-- TestingBackGroundNew.t:SetBlendMode("ADD")

-- TestingBackGroundNew:SetScript("OnClick", function() LoadBrownBoxes2() end)

function PrevNextPage()
    local frame = _G["PageButton"]
    if not frame then end
end

local PER_PAGE = 10;
local PAGE_NUMBER = "Page %s of %s";

-- (create the navbar page info text)

local PageNumber = frame:CreateFontString("PageNumber", "OVERLAY",
                                          "GameFontNormalSmall")
PageNumber:Show()
PageNumber:ClearAllPoints()
PageNumber:SetPoint("TOP", MainFrame, "BOTTOM", 0, -10)
PageNumber:SetTextColor(1, 1, 1)
PageNumber:SetText("Page 1 of n")

-- (prev button)
frame = CreateFrame("Button", "PrevButton", MainFrame)
frame:SetWidth(32);
frame:SetHeight(32);
frame:Show()
frame:ClearAllPoints()
frame:SetPoint("RIGHT", PageNumber, "LEFT", -10, 0)
frame:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
frame:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
frame:SetDisabledTexture(
    "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled")
frame:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
frame:GetHighlightTexture():SetBlendMode("ADD")
frame:SetScript("OnClick", function() end)
-- (next button)
frame = CreateFrame("Button", "NextButton", MainFrame)
frame:SetWidth(32);
frame:SetHeight(32);
frame:Show()
frame:ClearAllPoints()
frame:SetPoint("LEFT", PageNumber, "RIGHT", 10, 0)
frame:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
frame:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
frame:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled")
frame:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
frame:GetHighlightTexture():SetBlendMode("ADD")
frame:SetScript("OnClick", function() end)

-- -- A transparent yellow texture will appear on mouseover:
-- local highlightTexture = frame:CreateTexture(nil, "HIGHLIGHT")
-- highlightTexture:SetAllPoints(true)
-- highlightTexture:SetTexture(1, 1, 0, 0.5)

-- -- The word "Mouse!" will appear on mouseover:
-- local highlightFontString = frame:CreateFontString(nil, "HIGHLIGHT", "GameFontNormalLarge")
-- highlightFontString:SetPoint("CENTER")
-- highlightFontString:SetText("Mouse!")

--[[ function SwitchPage(num)
    Box1 = num;

    num = num + 1; -- For easier usage
    local maxpage = ceil(GetNumCompanions("MOUNT") / PER_PAGE);
    NecrosisCompanionPageNumber:SetFormattedText(PAGE_NUMBER, num, maxpage);

    if (num <= 1) then
        PrevButton:Disable();
    else
        PrevButton:Enable();
    end

    if (num >= maxpage) then
        NextButton:Disable();
    else
        NextButton:Enable();
    end

    SwitchPage:UpdateMountButtons();

end ]]

-- local NextPage = CreateFrame("Button", "NextPage", TestFrameOne, nil)
-- NextPage:SetSize(35, 35)
-- NextPage:SetPoint("CENTER", 175, -270)
-- NextPage:EnableMouse(true)
-- NextPage:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
-- NextPage:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
-- NextPage:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
-- NextPage:SetScript("OnMouseUp", function()  end)

-- local PrevPage = CreateFrame("Button", "PrevPage", TestFrameOne, nil)
-- PrevPage:SetSize(35, 35)
-- PrevPage:SetPoint("CENTER", 100, -270)
-- PrevPage:EnableMouse(true)
-- PrevPage:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-PrevPage-Up")
-- PrevPage:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
-- PrevPage:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-PrevPage-Down")
-- PrevPage:SetScript("OnMouseUp", function()  end)

-- local frames = CreateFrame("Frame", Suck, UIParent)
-- frames:SetPoint("CENTER", UIParent)
-- frames:SetSize(650, 650)

-- local TestingBackGroundNew = frames:CreateTexture("BACKGROUND")

-- TestingBackGroundNew:SetDrawLayer("BACKGROUND")
-- TestingBackGroundNew:SetPoint("CENTER")
-- TestingBackGroundNew:SetTexture("Interface/Icons/Store-Main.blp")
-- TestingBackGroundNew:SetTexCoord(0, 0.5546875, 0, 0.4560546875)
-- TestingBackGroundNew:SetSize(650,650)

-- TestingBackGroundNew:Show()

function Boxes() end

function LoadBrownBoxes1()

    local Box1 = _G["BrownBox1"]
    local Box2 = _G["BrownBox2"]
    local Box3 = _G["BrownBox3"]
    local Box4 = _G["BrownBox4"]
    local Box5 = _G["BrownBox5"]
    local Box6 = _G["BrownBox6"]
    local Box7 = _G["BrownBox7"]
    local Box8 = _G["BrownBox8"]

    if not Box1 then
        Box1 = CreateFrame("Button", "BrownBox1", MainFrame)
        Box1:SetSize(250, 300)
        Box1:SetNormalTexture("interface/icons/ShopBorderItem")
        Box1:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- Remove?
        Box1:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        Box1:SetPoint("CENTER", -100, 125)

        Box2 = CreateFrame("Button", "BrownBox2", MainFrame)
        Box2:SetSize(250, 300)
        Box2:SetNormalTexture("interface/icons/ShopBorderItem")
        Box2:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- Remove?
        Box2:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        Box2:SetPoint("CENTER", -100, -125)

        Box3 = CreateFrame("Button", "BrownBox3", MainFrame)
        Box3:SetSize(250, 300)
        Box3:SetNormalTexture("interface/icons/ShopBorderItem")
        Box3:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- Remove?
        Box3:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        Box3:SetPoint("CENTER", 55, 125)

        Box4 = CreateFrame("Button", "BrownBox4", MainFrame)
        Box4:SetSize(250, 300)
        Box4:SetNormalTexture("interface/icons/ShopBorderItem")
        Box4:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- Remove?
        Box4:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        Box4:SetPoint("CENTER", 55, -125)

        Box5 = CreateFrame("Button", "BrownBox5", MainFrame)
        Box5:SetSize(250, 300)
        Box5:SetNormalTexture("interface/icons/ShopBorderItem")
        Box5:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- Remove?
        Box5:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        Box5:SetPoint("CENTER", 210, 125)

        Box6 = CreateFrame("Button", "BrownBox6", MainFrame)
        Box6:SetSize(250, 300)
        Box6:SetNormalTexture("interface/icons/ShopBorderItem")
        Box6:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- Remove?
        Box6:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        Box6:SetPoint("CENTER", 210, -125)

        Box7 = CreateFrame("Button", "BrownBox7", MainFrame)
        Box7:SetSize(250, 300)
        Box7:SetNormalTexture("interface/icons/ShopBorderItem")
        Box7:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- Remove?
        Box7:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        Box7:SetPoint("CENTER", 365, 125)

        Box8 = CreateFrame("Button", "BrownBox8", MainFrame)
        Box8:SetSize(250, 300)
        Box8:SetNormalTexture("interface/icons/ShopBorderItem")
        Box8:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- Remove?
        Box8:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        Box8:SetPoint("CENTER", 365, -125)

    else

        if Box1:IsVisible() then
            Box1:Hide()
            Box2:Hide()
            Box3:Hide()
            Box4:Hide()
            Box5:Hide()
            Box6:Hide()
            Box7:Hide()
            Box8:Hide()
            -- for _, v in pairs(T) do Box[v]:Hide() end

            -- local Box = {Box1, Box2, Box3, Box4, Box5, Box6, Box7, Box8}

            -- for i = 1, 8, -1 do Box[i]:Hide() end
        else
            -- for i = 1, 8, -1 do Box[i]:Show() end
            -- for _, v in pairs(T) do Box[v]:Show() end
            Box1:Show()
            Box2:Show()
            Box3:Show()
            Box4:Show()
            Box5:Show()
            Box6:Show()
            Box7:Show()
            Box8:Show()
        end

    end
end

local Special = CreateFrame("Button", "Special", TestFrameOne)
Special:SetSize(65, 65)
Special:SetNormalTexture("interface/icons/category-icon-featured")
Special:SetPoint("LEFT", 10, 250)

-- Special:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- replace placeholders
Special:SetHighlightTexture("Interface/icons/ShopBorderGlow") -- replace placeholders
-- Special:SetScript("OnClick", function() LoadBrownBoxes1() end)
Special:SetScript('OnEnter', function() LoadBrownBoxes1() end)
Special:SetScript('OnLeave', function() LoadBrownBoxes1() end)

local Services = CreateFrame("Button", "Services", TestFrameOne)
Services:SetSize(65, 65)
Services.t = Services:CreateTexture()
Services.t:SetAllPoints()
Services.t:SetTexture("interface/icons/category-icon-services")
Services:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- replace placeholders
Services:SetHighlightTexture("Interface/icons/ShopBorderGlow") -- replace placeholders
-- Services.t:SetBlendMode("ADD")
Services:SetPoint("LEFT", 10, 200)
-- Services:SetScript("OnClick", function() LoadBrownBoxes2() end)

local Scroll = CreateFrame("Button", "Scroll", TestFrameOne)
Scroll:SetSize(65, 65)
Scroll.t = Scroll:CreateTexture()
Scroll.t:SetAllPoints()
Scroll.t:SetTexture("interface/icons/category-icon-scroll")
Scroll:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- replace placeholders
Scroll:SetHighlightTexture("Interface/icons/ShopBorderGlow") -- replace placeholders
-- Scroll.t:SetBlendMode("ADD")
Scroll:SetPoint("LEFT", 10, 150)
-- Scroll:SetScript("OnClick", function() LoadBrownBoxes2() end)

local Enchantscroll = CreateFrame("Button", "Enchantscroll", TestFrameOne)
Enchantscroll:SetSize(65, 65)
Enchantscroll.t = Enchantscroll:CreateTexture()
Enchantscroll.t:SetAllPoints()
Enchantscroll.t:SetTexture("interface/icons/category-icon-enchantscroll")
Enchantscroll:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- replace placeholders
Enchantscroll:SetHighlightTexture("Interface/icons/ShopBorderGlow") -- replace placeholders
-- Enchantscroll.t:SetBlendMode("ADD")
Enchantscroll:SetPoint("LEFT", 10, 100)
-- Enchantscroll:SetScript("OnClick", function() LoadBrownBoxes2() end)

local Free = CreateFrame("Button", "Free", TestFrameOne)
Free:SetSize(65, 65)
Free.t = Free:CreateTexture()
Free.t:SetAllPoints()
Free.t:SetTexture("interface/icons/category-icon-free")
Free:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- replace placeholders
Free:SetHighlightTexture("Interface/icons/ShopBorderGlow") -- replace placeholders
-- Free.t:SetBlendMode("ADD")
Free:SetPoint("LEFT", 10, 50)
-- Free:SetScript("OnClick", function() LoadBrownBoxes2() end)

local Book = CreateFrame("Button", "Book", TestFrameOne)
Book:SetSize(65, 65)
Book.t = Book:CreateTexture()
Book.t:SetAllPoints()
Book.t:SetTexture("interface/icons/category-icon-book")
Book:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- replace placeholders
Book:SetHighlightTexture("Interface/icons/ShopBorderGlow") -- replace placeholders
-- Book.t:SetBlendMode("ADD")
Book:SetPoint("LEFT", 10, 0)
-- Book:SetScript("OnClick", function() LoadBrownBoxes2() end)

-- (Gonna use this later for gear choose weapons. Will change it if i figure out better way)

print("End of file")











-- local AIO = AIO or require("AIO")

-- if AIO.AddAddon() then return end

-- local StoreShop = AIO.AddHandlers("storeframe", {})
-- -- (ToolTip)
-- -- local function OnEnterFrame(self, motion)
-- --     GameTooltip:Hide()
-- --     GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
-- --     if (self.type == 1) then
-- --         GameTooltip:SetHyperlink("spell:" .. self.spellid)
-- --     elseif (self.type == 2) then
-- --         GameTooltip:SetHyperlink("item:" .. self.itemid)
-- --     elseif (self.type == 3) then
-- --         GameTooltip:SetHyperlink("quest:" .. self.questid)

--         GameTooltip:SetFrameLevel(5)
--         GameTooltip:Show()
--     end
-- end

-- local function OnLeaveFrame(self, motion) GameTooltip:Hide() end
-- local _G = _G

-- function OpenStore()

--     ToggleGameMenu()
--     Shop:Show()

-- end

-- -- (Fix later)
-- function CloseFrameOnEscape(self, keyOrButton)
--     if keyOrButton == "ESCAPE" then
--         TestFrameOne:Hide()
--         return
--     end
-- end

-- local EscapeButtonKey = CreateFrame("Button", "UIPanelButtonTemplateTest",
--                                     GameMenuFrame, "UIPanelButtonTemplate")
-- EscapeButtonKey:SetHeight(20)
-- EscapeButtonKey:SetWidth(145)
-- EscapeButtonKey:SetText("STORE")
-- EscapeButtonKey:ClearAllPoints()
-- EscapeButtonKey:SetPoint("bottom", 0, -20)
-- EscapeButtonKey:SetScript("OnClick", function() OpenStore() end)
-- EscapeButtonKey:SetFrameLevel(100)

-- --[[
-- This is for the Background box rightside
-- Size-> 578
-- Coord -> 0.564453125
-- Size -> 469
-- Coord -> 0.4580078125

-- Right side bar
-- Size -> 188
-- Coord -> 0.564453125
-- Size -> 487
-- Coord -> 0.4755859375

-- ]]

-- -- local frames = CreateFrame("Frame", Suck, UIParent)
-- -- frames:SetPoint("CENTER", UIParent)
-- -- frames:SetSize(650, 500)

-- -- local TestingBackGroundNew = frames:CreateTexture("BACKGROUND")

-- -- TestingBackGroundNew:SetDrawLayer("BACKGROUND")
-- -- TestingBackGroundNew:SetPoint("CENTER")
-- -- TestingBackGroundNew:SetTexture("Interface/Icons/Store-Main.blp")
-- -- TestingBackGroundNew:SetTexCoord(0, 0.5546875, 0, 0.4560546875)
-- -- TestingBackGroundNew:SetSize(650,650)

-- -- TestingBackGroundNew:Show()

-- local frame = CreateFrame("Frame", "Shop", UIParent)
-- frame:SetPoint("CENTER", UIParent)
-- frame:SetSize(1000, 750)
-- frame:SetBackdrop({
--     bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
--     edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
--     edgeSize = 1
-- })
-- frame:SetBackdropColor(0, 0, 0, .5) -- (Remove)
-- frame:SetBackdropBorderColor(0, 0, 0) -- (Remove)

-- frame:EnableMouse(true)
-- frame:SetMovable(true)
-- frame:RegisterForDrag("LeftButton")
-- frame:SetScript("OnDragStart", frame.StartMoving)
-- frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
-- frame:SetScript("OnHide", frame.StopMovingOrSizing)
-- frame:SetFrameLevel(5)
-- -- local RightBox = frame:CreateTexture("BACKGROUND")
-- -- RightBox:SetDrawLayer("BACKGROUND")
-- -- RightBox:SetPoint("RIGHT")
-- -- RightBox:SetTexture("Interface/Icons/Store-Main.blp")
-- -- RightBox:SetTexCoord(0, 0.564453125, 0, 0.4580078125)
-- -- RightBox:SetSize(750, 600)


-- -- local ntex = button:CreateTexture()
-- -- ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
-- -- ntex:SetTexCoord(0, 0.625, 0, 0.6875)
-- -- ntex:SetAllPoints()
-- -- button:SetNormalTexture(ntex)

-- -- local htex = button:CreateTexture()
-- -- htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
-- -- htex:SetTexCoord(0, 0.625, 0, 0.6875)
-- -- htex:SetAllPoints()
-- -- button:SetHighlightTexture(htex)

-- -- local ptex = button:CreateTexture()
-- -- ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
-- -- ptex:SetTexCoord(0, 0.625, 0, 0.6875)
-- -- ptex:SetAllPoints()
-- -- button:SetPushedTexture(ptex)

-- local BannerTop = frame:CreateTexture("TOPBANNER")
-- BannerTop:SetDrawLayer("BACKGROUND")
-- BannerTop:SetPoint("TOP", frame, "TOP", 0, 0)
-- BannerTop:SetTexture("Interface/Icons/Store-Main.blp")
-- BannerTop:SetTexCoord(0.380859375, 0.71875, 0.462890625, 0.525390625)
-- BannerTop:SetSize(346, 64)


-- local LeftBox = frame:CreateTexture("LEFTSIDE")
-- LeftBox:SetDrawLayer("BACKGROUND")
-- LeftBox:SetPoint("LEFT", 50, 0)
-- LeftBox:SetTexture("Interface/Icons/Store-Main.blp")
-- LeftBox:SetTexCoord(0, 0.18359375, 0.4619140625, 0.9375)
-- LeftBox:SetSize(200, 600)


-- --[[ local BoxItem = frame:CreateTexture("RightBrownBoxe")
-- BoxItem:SetDrawLayer("BACKGROUND")
-- BoxItem:SetPoint("CENTER", 0, 0)
-- BoxItem:SetTexture("Interface/Icons/Store-Main.blp")
-- BoxItem:SetTexCoord(0.1875, 0.32421875, 0.6474609375, 0.84765625)
-- BoxItem:SetSize(140, 205) ]]
-- local button = CreateFrame("Button", nil, frame)
-- button:SetPoint(nil, frame, "CENTER", 0, 0)
-- button:SetWidth(140)
-- button:SetHeight(205)
-- button:SetText("Buy")
-- button:SetNormalFontObject("GameFontNormal")



-- local HighlightTextureForBrownBox = frame:CreateTexture("RightBrownBoxe")
-- HighlightTextureForBrownBox:SetDrawLayer("BACKGROUND")
-- HighlightTextureForBrownBox:SetPoint("CENTER", 0, 0)
-- HighlightTextureForBrownBox:SetTexture("Interface/Icons/Store-Main.blp")
-- HighlightTextureForBrownBox:SetTexCoord(0.369140625, 0.5068359375, 0.7421875,
--                                         0.9404296875)
-- HighlightTextureForBrownBox:SetSize(140, 205)

-- local BoxItem1 = frame:CreateTexture("RightBrownBox1")
-- BoxItem1:SetDrawLayer("BACKGROUND")
-- BoxItem1:SetPoint("CENTER", 0, 0)
-- BoxItem1:SetTexture("Interface/Icons/Store-Main.blp")
-- BoxItem1:SetTexCoord(0.1875, 0.32421875, 0.6474609375, 0.84765625)
-- BoxItem1:SetSize(140, 205)
-- button:SetPushedTexture(HighlightTextureForBrownBox)
-- button:SetHighlightTexture(HighlightTextureForBrownBox)
-- button:SetScript("OnClick", function() print("fuck")end)

-- local BoxItem2 = frame:CreateTexture("RightBrownBox2")
-- BoxItem2:SetDrawLayer("BACKGROUND")
-- BoxItem2:SetPoint("CENTER", 250, 0)
-- BoxItem2:SetTexture("Interface/Icons/Store-Main.blp")
-- BoxItem2:SetTexCoord(0.1875, 0.32421875, 0.6474609375, 0.84765625)
-- BoxItem2:SetSize(140, 205)
-- button:SetPushedTexture(HighlightTextureForBrownBox)
-- button:SetHighlightTexture(HighlightTextureForBrownBox)
-- button:SetScript("OnClick", function() print("fuck2")end)

-- local WowIcon = frame:CreateTexture("LEFTSIDE")
-- WowIcon:SetDrawLayer("BACKGROUND")
-- WowIcon:SetPoint("TOPLEFT", 0, 0)
-- WowIcon:SetTexture("Interface/Icons/Store-Main.blp")
-- WowIcon:SetTexCoord(0.9736328125, 0.9560546875, 0.2900390625, 0.978515625)
-- WowIcon:SetSize(100, 100)

-- frame:Show()

-- local close = CreateFrame("Button", "YourCloseButtonName", Shop,
--                           "UIPanelCloseButton")

-- close:SetPoint("TOPRIGHT", Shop, "TOPRIGHT")
-- close:SetScript("OnClick", function() frame:Hide() end)
-- close:SetFrameLevel(6)

-- (Left Bottom. Right Bottom. Heigt from TOP. Icons end from top)






































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
local _G = _G

function OpenStore()

    ToggleGameMenu()
    TestFrameOne:Show()
end

-- (Fix later)
function CloseFrameOnEscape(self, keyOrButton)
    if keyOrButton == "ESCAPE" then
        TestFrameOne:Hide()
        return
    end
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
--  (Main backwindow)

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
MainFrame:EnableMouse(true)
MainFrame:SetMovable(true)
MainFrame:RegisterForDrag("LeftButton")
MainFrame:SetScript("OnDragStart", MainFrame.StartMoving)
MainFrame:SetScript("OnDragStop", MainFrame.StopMovingOrSizing)
MainFrame:SetScript("OnHide", MainFrame.StopMovingOrSizing)

local close = CreateFrame("Button", "YourCloseButtonName", TestFrameOne,
                          "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", MainFrame, "TOPRIGHT")
close:SetScript("OnClick", function() MainFrame:Hide() end)

StaticPopupDialogs["EXAMPLE_HELLOWORLD"] = {
    text = "Do you want to greet the world today?",
    button1 = "Yes",
    button2 = "No",
    OnAccept = function() SendChatMessage("HelloWorld!", "SAY") end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true
}
StaticPopup_Show("EXAMPLE_HELLOWORLD")
-- (DropDown)
if not DropDownMenuTest then
    CreateFrame("Button", "DropDownMenuTest", TestFrameOne,
                "UIDropDownMenuTemplate")
end

DropDownMenuTest:ClearAllPoints()
DropDownMenuTest:SetPoint("TOPRIGHT", -50, 0)
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

-- (end of dropdown menu)

print("Start LoadThisShit")
-- (LeftBar)

-- function LoadBrownBoxes()
--     local Box1 = _G["BrownBox1"]

--     if not Box1 then
--         Box1 = CreateFrame("Button", "BrownBox1", MainFrame)
--         Box1:SetSize(250, 300)
--         Box1:SetNormalTexture("interface/icons/ShopBorderItem")
--         Box1:SetPushedTexture("Interface/icons/ShopBorderItemBlue")
--         Box1:SetHighlightTexture("Interface/icons/ShopBorderGlow")
--         Box1:SetPoint("CENTER", -100, 150)
--     else
--         if Box1:IsVisible() then
--             Box1:Hide()
--         else
--             Box1:Show()
--         end
--     end
-- end

function PrevNextPage()
    local frame = _G["PageButton"]
    if not frame then end
end

local PER_PAGE = 10;
local PAGE_NUMBER = "Page %s of %s";

-- (create the navbar page info text)

local PageNumber = frame:CreateFontString("PageNumber", "OVERLAY",
                                          "GameFontNormalSmall")
PageNumber:Show()
PageNumber:ClearAllPoints()
PageNumber:SetPoint("TOP", MainFrame, "BOTTOM", 0, -10)
PageNumber:SetTextColor(1, 1, 1)
PageNumber:SetText("Page 1 of n")

-- (prev button)
frame = CreateFrame("Button", "PrevButton", MainFrame)
frame:SetWidth(32);
frame:SetHeight(32);
frame:Show()
frame:ClearAllPoints()
frame:SetPoint("RIGHT", PageNumber, "LEFT", -10, 0)
frame:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
frame:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
frame:SetDisabledTexture(
    "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled")
frame:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
frame:GetHighlightTexture():SetBlendMode("ADD")
frame:SetScript("OnClick", function() end)
-- (next button)
frame = CreateFrame("Button", "NextButton", MainFrame)
frame:SetWidth(32);
frame:SetHeight(32);
frame:Show()
frame:ClearAllPoints()
frame:SetPoint("LEFT", PageNumber, "RIGHT", 10, 0)
frame:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
frame:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
frame:SetDisabledTexture(
    "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled")
frame:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
frame:GetHighlightTexture():SetBlendMode("ADD")
frame:SetScript("OnClick", function() end)



-- local NextPage = CreateFrame("Button", "NextPage", TestFrameOne, nil)
-- NextPage:SetSize(35, 35)
-- NextPage:SetPoint("CENTER", 175, -270)
-- NextPage:EnableMouse(true)
-- NextPage:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Up")
-- NextPage:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
-- NextPage:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-NextPage-Down")
-- NextPage:SetScript("OnMouseUp", function()  end)

-- local PrevPage = CreateFrame("Button", "PrevPage", TestFrameOne, nil)
-- PrevPage:SetSize(35, 35)
-- PrevPage:SetPoint("CENTER", 100, -270)
-- PrevPage:EnableMouse(true)
-- PrevPage:SetNormalTexture("Interface/BUTTONS/UI-SpellbookIcon-PrevPage-Up")
-- PrevPage:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
-- PrevPage:SetPushedTexture("Interface/BUTTONS/UI-SpellbookIcon-PrevPage-Down")
-- PrevPage:SetScript("OnMouseUp", function()  end)

function LoadBrownBoxes1()

    local Box1 = _G["BrownBox1"]
    local Box2 = _G["BrownBox2"]
    local Box3 = _G["BrownBox3"]
    local Box4 = _G["BrownBox4"]
    local Box5 = _G["BrownBox5"]
    local Box6 = _G["BrownBox6"]
    local Box7 = _G["BrownBox7"]
    local Box8 = _G["BrownBox8"]

    if not Box1 then
        Box1 = CreateFrame("Button", "BrownBox1", MainFrame)
        Box1:SetSize(250, 300)
        Box1:SetNormalTexture("interface/icons/ShopBorderItem")
        Box1:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- Remove?
        Box1:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        Box1:SetPoint("CENTER", -100, 125)

        Box2 = CreateFrame("Button", "BrownBox2", MainFrame)
        Box2:SetSize(250, 300)
        Box2:SetNormalTexture("interface/icons/ShopBorderItem")
        Box2:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- Remove?
        Box2:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        Box2:SetPoint("CENTER", -100, -125)

        Box3 = CreateFrame("Button", "BrownBox3", MainFrame)
        Box3:SetSize(250, 300)
        Box3:SetNormalTexture("interface/icons/ShopBorderItem")
        Box3:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- Remove?
        Box3:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        Box3:SetPoint("CENTER", 55, 125)

        Box4 = CreateFrame("Button", "BrownBox4", MainFrame)
        Box4:SetSize(250, 300)
        Box4:SetNormalTexture("interface/icons/ShopBorderItem")
        Box4:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- Remove?
        Box4:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        Box4:SetPoint("CENTER", 55, -125)

        Box5 = CreateFrame("Button", "BrownBox5", MainFrame)
        Box5:SetSize(250, 300)
        Box5:SetNormalTexture("interface/icons/ShopBorderItem")
        Box5:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- Remove?
        Box5:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        Box5:SetPoint("CENTER", 210, 125)

        Box6 = CreateFrame("Button", "BrownBox6", MainFrame)
        Box6:SetSize(250, 300)
        Box6:SetNormalTexture("interface/icons/ShopBorderItem")
        Box6:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- Remove?
        Box6:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        Box6:SetPoint("CENTER", 210, -125)

        Box7 = CreateFrame("Button", "BrownBox7", MainFrame)
        Box7:SetSize(250, 300)
        Box7:SetNormalTexture("interface/icons/ShopBorderItem")
        Box7:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- Remove?
        Box7:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        Box7:SetPoint("CENTER", 365, 125)

        Box8 = CreateFrame("Button", "BrownBox8", MainFrame)
        Box8:SetSize(250, 300)
        Box8:SetNormalTexture("interface/icons/ShopBorderItem")
        Box8:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- Remove?
        Box8:SetHighlightTexture("Interface/icons/ShopBorderGlow")
        Box8:SetPoint("CENTER", 365, -125)

    else

        if Box1:IsVisible() then
            Box1:Hide()
            Box2:Hide()
            Box3:Hide()
            Box4:Hide()
            Box5:Hide()
            Box6:Hide()
            Box7:Hide()
            Box8:Hide()
            -- for _, v in pairs(T) do Box[v]:Hide() end

            -- local Box = {Box1, Box2, Box3, Box4, Box5, Box6, Box7, Box8}

            -- for i = 1, 8, -1 do Box[i]:Hide() end
        else
            -- for i = 1, 8, -1 do Box[i]:Show() end
            -- for _, v in pairs(T) do Box[v]:Show() end
            Box1:Show()
            Box2:Show()
            Box3:Show()
            Box4:Show()
            Box5:Show()
            Box6:Show()
            Box7:Show()
            Box8:Show()
        end

    end
end

local Special = CreateFrame("Button", "Special", TestFrameOne)
Special:SetSize(65, 65)
Special.t = Special:CreateTexture()
Special.t:SetAllPoints()
Special.t:SetTexture("interface/icons/category-icon-featured")
-- Special.t:SetBlendMode("ADD")
Special:SetPoint("LEFT", 10, 250)
Special:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- replace placeholders
Special:SetHighlightTexture("Interface/icons/ShopBorderGlow") -- replace placeholders
Special:SetScript("OnClick", function() LoadBrownBoxes1() end)

local Services = CreateFrame("Button", "Services", TestFrameOne)
Services:SetSize(65, 65)
Services.t = Services:CreateTexture()
Services.t:SetAllPoints()
Services.t:SetTexture("interface/icons/category-icon-services")
Services:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- replace placeholders
Services:SetHighlightTexture("Interface/icons/ShopBorderGlow") -- replace placeholders
-- Services.t:SetBlendMode("ADD")
Services:SetPoint("LEFT", 10, 200)
-- Services:SetScript("OnClick", function() LoadBrownBoxes2() end)

local Scroll = CreateFrame("Button", "Scroll", TestFrameOne)
Scroll:SetSize(65, 65)
Scroll.t = Scroll:CreateTexture()
Scroll.t:SetAllPoints()
Scroll.t:SetTexture("interface/icons/category-icon-scroll")
Scroll:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- replace placeholders
Scroll:SetHighlightTexture("Interface/icons/ShopBorderGlow") -- replace placeholders
-- Scroll.t:SetBlendMode("ADD")
Scroll:SetPoint("LEFT", 10, 150)
-- Scroll:SetScript("OnClick", function() LoadBrownBoxes2() end)

local Enchantscroll = CreateFrame("Button", "Enchantscroll", TestFrameOne)
Enchantscroll:SetSize(65, 65)
Enchantscroll.t = Enchantscroll:CreateTexture()
Enchantscroll.t:SetAllPoints()
Enchantscroll.t:SetTexture("interface/icons/category-icon-enchantscroll")
Enchantscroll:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- replace placeholders
Enchantscroll:SetHighlightTexture("Interface/icons/ShopBorderGlow") -- replace placeholders
-- Enchantscroll.t:SetBlendMode("ADD")
Enchantscroll:SetPoint("LEFT", 10, 100)
-- Enchantscroll:SetScript("OnClick", function() LoadBrownBoxes2() end)

local Free = CreateFrame("Button", "Free", TestFrameOne)
Free:SetSize(65, 65)
Free.t = Free:CreateTexture()
Free.t:SetAllPoints()
Free.t:SetTexture("interface/icons/category-icon-free")
Free:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- replace placeholders
Free:SetHighlightTexture("Interface/icons/ShopBorderGlow") -- replace placeholders
-- Free.t:SetBlendMode("ADD")
Free:SetPoint("LEFT", 10, 50)
-- Free:SetScript("OnClick", function() LoadBrownBoxes2() end)

local Book = CreateFrame("Button", "Book", TestFrameOne)
Book:SetSize(65, 65)
Book.t = Book:CreateTexture()
Book.t:SetAllPoints()
Book.t:SetTexture("interface/icons/category-icon-book")
Book:SetPushedTexture("Interface/icons/ShopBorderItemBlue") -- replace placeholders
Book:SetHighlightTexture("Interface/icons/ShopBorderGlow") -- replace placeholders
-- Book.t:SetBlendMode("ADD")
Book:SetPoint("LEFT", 10, 0)
-- Book:SetScript("OnClick", function() LoadBrownBoxes2() end)

-- (Gonna use this later for gear choose weapons. Will change it if i figure out better way)

print("End of file")
