--[[ This is still WIP ]]


--[[ NOT COMPLETED ]]







---@diagnostic disable: unused-function, undefined-global
    local AIO = AIO or require("AIO")

    if AIO.AddAddon() then return end
    local StoreShop = AIO.AddHandlers("storeframe", {})

    -- local Store = AIO.AddHandlers("DBFetch", {})
    -- local StoreShop = AIO.AddHandlers("storeframe", {})

    local OpenStoreSound = 679
    local CloseStoreSound = 680
    local ActiveBuy = 61
    local Unselect = 1193
    -- local _G = _G
    local pressed = false

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

    --[[ Box[i]:SetScript("OnEnter", OnEnterFrame)
    Box[i]:SetScript("OnLeave", OnLeaveFrame)

    local function OnEnterFrame(self, motion)
        GameTooltip:Hide()
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if (self.type == 1) then
            GameTooltip:SetHyperlink("spell:" .. self.id)
        elseif (self.type == 2) then
            GameTooltip:SetHyperlink("item:" .. self.id)
            local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType,
                  itemSubType, itemStackCount, itemEquipLoc, itemTexture,
                  itemSellPrice = GetItemInfo(self.id)
            self:SetBackdrop({
                bgFile = itemTexture,
                edgeFile = "",
                tile = false,
                tileSize = 68,
                edgeSize = 16,
                insets = {left = 4, right = 4, top = 4, bottom = 4}
            });
        end
        GameTooltip:SetFrameLevel(5)
        GameTooltip:Show()
    end

    local function OnLeaveFrame(self, motion) GameTooltip:Hide() end ]]
    -- local function OnLeaveFrame(self, motion) GameTooltip:Hide() end
    -- local _G = _G

    function OpenStore()
        ToggleGameMenu()
        ShopBackGround:Show()
    end

    -- (Fix later)
    -- function CloseFrameOnEscape(self, keyOrButton)
    --     if keyOrButton == "ESCAPE" then
    --         ShopBackGround:Hide()

    --         return false
    --     end
    -- end

    local EscapeButtonKey = CreateFrame("Button", "UIPanelButtonTemplateTest",
                                        GameMenuFrame, "UIPanelButtonTemplate")
    EscapeButtonKey:SetHeight(20)
    EscapeButtonKey:SetWidth(145)
    EscapeButtonKey:SetText("STORE")
    EscapeButtonKey:ClearAllPoints()
    EscapeButtonKey:SetPoint("bottom", 0, -20)
    EscapeButtonKey:SetScript("OnClick", function(self) OpenStore() end)
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
    -- scroll bar

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

    local BannerTop = BackGroundFrame:CreateTexture("TOPBANNER")
    BannerTop:SetDrawLayer("BACKGROUND")
    BannerTop:SetPoint("TOP", BackGroundFrame, "TOP", 0, 0)
    BannerTop:SetTexture("Interface/Icons/Store-Main.blp")
    BannerTop:SetTexCoord(0.380859375, 0.71875, 0.462890625, 0.525390625)
    BannerTop:SetSize(346, 64)

    local LeftBox = BackGroundFrame:CreateTexture("LEFTSIDE")
    LeftBox:SetDrawLayer("BACKGROUND")
    LeftBox:SetPoint("LEFT", 50, 0)
    LeftBox:SetTexture("Interface/Icons/Store-Main.blp")
    LeftBox:SetTexCoord(0, 0.18359375, 0.4619140625, 0.9375)
    LeftBox:SetSize(200, 600)

    -- (DB FETCH)
    -- function CheatCommands.getModel(informations)
    -- 	if (informations.type) then
    -- 		if informations.type == 1 then
    -- 			informations.type = "item_template"
    -- 			informations.column = "displayid"
    -- 		elseif informations.type == 2 then
    -- 			informations.type = "creature_template"
    -- 			informations.column = "modelid1"
    -- 		elseif informations.type == 3 then
    -- 			informations.type = "gameobject_template"
    -- 			informations.column = "displayid"
    -- 		end

    -- 		local getModel =
    -- 			WorldDBQuery(
    -- 			"SELECT " .. informations.column .. " FROM " .. informations.type .. " where entry=" .. informations.digits .. ";"
    -- 		)
    -- 		if (getModel) then
    -- 			informations.result = CheatCommands.Config.color5 .. getModel:GetUInt32(0)
    -- 		else
    -- 			informations.result = CheatCommands.Text.mainError
    -- 		end
    -- 	end
    -- 	return informations.result
    -- end

    -- _G["Box" .. i]:Show()
    -- if _G["Box" .. i]:IsVisible() then
    --     _G["Box" .. i]:Hide()

    -- else
    --     _G["Box" .. i]:Show()

    -- end

    -- ShopItems = {
    --     [1] = {63862},
    --     [2] = {45738},
    --     [3] = {200013, 200014},
    --     [4] = {200015, 200016},
    --     [5] = {200011, 200012},
    --     [6] = {200019},
    --     [7] = {200017, 200018},
    --     [8] = {200007, 200008},
    --     [9] = {200009, 200010},
    --     [11] = {200005, 200006}

    -- }

    -- (Should Make it so fetch Page>ItemOrSpell>Post on box.)

    -- local BoxFrame = CreateFrame("Button", "Box" .. i, ShopBackGround)

    function displayItemOrSpellToolTip(itemOrSpell)
        if (itemOrSpell) then
            if (itemOrSpell.type == 1) then
                GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
                GameTooltip:SetHyperlink("item:" .. itemOrSpell.digits)
                GameTooltip:Show()
            elseif (itemOrSpell.type == 2) then
                GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
                GameTooltip:SetHyperlink("spell:" .. itemOrSpell.digits)
                GameTooltip:Show()
            end
        end
    end

    -- (This is the name of the Tabs)

    local Text = {
        "Special", "Service", "Scroll", "Pet", "Buff", "Gift", "Spell", "Free"
    }
    local IconTexture = {
        {"interface/icons/category-icon-featured"},
        {"interface/icons/category-icon-services"},
        {"interface/icons/category-icon-scroll"},
        {"interface/icons/category-icon-enchantscroll"},
        {"interface/icons/category-icon-pets"},
        {"interface/icons/category-icon-free"},
        {"interface/icons/category-icon-book"}
    }

    -- local IconAndText = {
    --     {"Special", "interface/icons/category-icon-featured"},
    --     {"Service", "interface/icons/category-icon-services"},
    --     {"Scroll", "interface/icons/category-icon-scroll"},
    --     {"Pet", "interface/icons/category-icon-enchantscroll"},
    --     {"Buff", "interface/icons/category-icon-pets"},
    --     {"Gift", "interface/icons/category-icon-free"},
    --     {"Spell", "interface/icons/category-icon-book"},
    --     {"Free", "interface/icons/category-icon-free"}
    -- }
    --[[ Box handler ]]
    local c = 0
    local heightMod = 150

    -- local function BoxAppear()
    for BoxId = 0, 7 do
        _G["Box" .. BoxId] = CreateFrame("Button", "Box" .. BoxId, ShopBackGround)
        _G["Box" .. BoxId].texture = _G["Box" .. BoxId]:CreateTexture()
        _G["Box" .. BoxId].texture:SetAllPoints(_G["Box" .. BoxId])
        _G["Box" .. BoxId].texture:SetTexture("Interface/Icons/Store-Main.blp")
        _G["Box" .. BoxId].texture:SetTexCoord(0.1875, 0.32421875, 0.6474609375,
                                               0.84765625)
        _G["Box" .. BoxId]:SetSize(146, 209)
        _G["Box" .. BoxId]:SetPoint("CENTER", "ShopBackGround",
                                    5 + 155 * (BoxId - 1), (heightMod))
        _G["Box" .. BoxId]:SetScript("OnClick", function(self, but)
            if but == "LeftButton" then
                -- _G["Box" .. BoxId].texture:SetTexCoord(0.37109375,0.505859375,0.7421875,0.943359375) ----(For the HighLight Color)
                if not pressed then
                    pressed = true
                    _G["Box" .. BoxId]:LockHighlight()
                else
                    pressed = false
                    _G["Box" .. BoxId]:UnlockHighlight()
                end
            end
            print("Box " .. BoxId)
        end)
        _G["Box" .. BoxId]:SetScript("OnEnter", function() end)

        if (c > 3) then
            heightMod = -150
            _G["Box" .. BoxId]:SetPoint("CENTER", "ShopBackGround",
                                        -615 + 155 * (BoxId - 1), (heightMod))
        end
        c = c + 1
    end
    local LeftIconFrame = {}

    for FrameBox = 1, #Text do
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
                    -- Show Box when FrameBox pressed if pressed again hide it
                    if (FrameBox == FrameBox) then
                        for BoxId = 0, 7 do
                            _G["Box" .. BoxId]:Show()
                        end
                    else
                        for BoxId = 0, 7 do
                            _G["Box" .. BoxId]:Hide()
                        end
                    end
                else
                    pressed = false
                    LeftIconFrame[FrameBox]:UnlockHighlight()
                end

            end

            -- BoxAppear()
            -- if newFrameHidden == false then
            --     _G["Box" .. i]:Hide()
            --     -- newFrameHidden = true
            -- else
            --     _G["Box" .. i]:Show()
            --     newFrameHidden = false
            -- end

            if FrameBox == 1 then
                -- print(Text[FrameBox])
            elseif FrameBox == 2 then
                -- print(Text[FrameBox])
            end
            -- print("LeftIconFrame " .. FrameBox)
            -- print("IconName " .. Text[FrameBox] .. " Slot in the array " .. #Text[FrameBox])
        end)
    end

    local LeftIconPort = {}

    for Icon = 1, #IconTexture do
        LeftIconPort[Icon] = CreateFrame("Frame", "LeftIconPort" .. Icon,
                                         LeftIconFrame[Icon])
        LeftIconPort[Icon]:SetSize(64, 64)
        LeftIconPort[Icon].t = LeftIconPort[Icon]:CreateTexture()
        LeftIconPort[Icon].t:SetAllPoints()
        LeftIconPort[Icon].t:SetTexture(IconTexture[Icon][1])
        -- LeftIconPort[Icon].t:SetBlendMode("ADD")
        LeftIconPort[Icon]:SetPoint("LEFT", 0, 1)
        -- LeftIconPort[Icon].Tex:SetBlendMode("ADD")
        -- LeftIconPort[Icon]:SetPoint("LEFT", 0, 0)
        -- LeftIconPort[Icon]:SetScript("OnClick", function() LoadBrownBoxes2() end)
        -- print(Icon)
    end

    -- _G["Box" .. BoxId]:SetNormalTexture("Interface/Icons/Store-Main.blp")
    -- _G["Box" .. BoxId]:SetHighlightTexture("Interface/Icons/Store-Main.blp")
    -- _G["Box" .. BoxId]:SetPushedTexture("Interface/Icons/Store-Main.blp")
    -- _G["Box" .. BoxId].HighlightTexture = _G["Box" .. BoxId]:CreateTexture()
    -- _G["Box" .. BoxId].HighlightTexture:SetAllPoints(_G["Box" .. BoxId])
    -- _G["Box" .. BoxId].HighlightTexture:SetTexture("Interface/Icons/Store-Main.blp")
    -- _G["Box" .. BoxId].HighlightTexture:SetTexCoord(0.37109375, 0.505859375, 0.7421875, 0.943359375)

    --[[ Item handler ]]

    -- {Spell = {1908}},
    -- {Item = {23162, 6948, 21176, 37012, 30876, 38484, 30082, 10823}}

    -- https://wowpedia.fandom.com/wiki/API_GetSpellInfo
    -- local spellName, _, spellIcon = GetSpellInfo(currentSpellID)
    -- https://wowpedia.fandom.com/wiki/API_GetItemInfo
    -- ["Spell"] = {1908},
    -- ["Item"] = {23162, 6948, 21176, 37012, 30876, 38484, 30082, 10823}
    local Shop_items = {
        ["Page"] = {
    {1, "Spell", {1908}},
    {2, "Item", {23162, 6948, 21176, 37012, 30876, 38484, 30082, 10823}},
    {3, "Spell", {1908}},
    {4, "Item", {23162, 6948, 21176, 37012, 30876, 38484, 30082, 10823}},
    {5, "Spell", {1908}},
    {6, "Item", {23162, 6948, 21176, 37012, 30876, 38484, 30082, 10823}},
    {7, "Spell", {1908}},
    {8, "Item", {23162, 6948, 21176, 37012, 30876, 38484, 30082, 10823}},


        }

    }

    Boxx = 0
    print(Shop_items["Page"][1][2])


    for i, v in ipairs(Shop_items.page.Items) do
        -- print(i)
        -- print(v)
        print(i .. " : " .. v)

        local itemName, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(v)
        local ItemInsideBox = CreateFrame("Frame", "ItemOrSpell", _G["Box" .. Boxx])
        ItemInsideBox:SetPoint("TOP", 0, -25)
        ItemInsideBox:SetSize(64, 64)

        ItemInsideBox.tex = ItemInsideBox:CreateTexture()
        ItemInsideBox.tex:SetAllPoints(ItemInsideBox)
        SetPortraitToTexture(ItemInsideBox.tex, itemIcon)

        ItemInsideBox.IconTextForShop = ItemInsideBox:CreateFontString(nil,
                                                                       "ARTWORK")
        ItemInsideBox.IconTextForShop:SetPoint("BOTTOM", 0, -25)
        ItemInsideBox.IconTextForShop:SetFontObject(GameFontNormal)
        ItemInsideBox.IconTextForShop:SetText(itemName)

        ItemInsideBox.GoldShow = ItemInsideBox:CreateFontString(nil, "ARTWORK")
        ItemInsideBox.GoldShow:SetFontObject(GameFontNormal)
        ItemInsideBox.GoldShow:SetPoint("BOTTOM", 0, -45)
        -- ItemInsideBox.GoldShow:SetText(GetCoinTextureString())

        Boxx = Boxx + 1

    end
    -- _G["Box" .. BoxId].Toggle = CreateFrame("CheckButton", nil, _G["Box" .. BoxId], "UICheckButtonTemplate")
    -- _G["Box" .. BoxId].Toggle:SetPoint("CENTER", _G["Box" .. BoxId])
    -- _G["Box" .. BoxId].Toggle:SetSize(146, 209)

    -- local checked = _G["Box" .. BoxId].Toggle:GetCheckedTexture()
    -- checked:SetTexture("Interface/Icons/Store-Main.blp")
    -- checked:SetTexCoord(0.37109375, 0.505859375, 0.7421875, 0.943359375)

    -- local normal = _G["Box" .. BoxId].Toggle:GetNormalTexture()
    -- normal:SetTexture("Interface/Icons/Store-Main.blp")
    -- normal:SetTexCoord(0.1875, 0.32421875, 0.6474609375, 0.84765625)

    -- local pushed = _G["Box" .. BoxId].Toggle:GetPushedTexture()
    -- pushed:SetTexture("Interface/Icons/Store-Main.blp")
    -- pushed:SetTexCoord(0.37109375, 0.505859375, 0.7421875, 0.943359375)

    -- end

    -- (GET THIS TO WORK LATER FOR DB INSTEAD)
    -- nextRow = 1
    -- BoxSkip = 0
    -- for indexName,indexFill in pairs(Store) do

    --     print(indexName)
    --     print(indexFill)
    --     local itemName, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(indexFill)

    -- local ItemInsideBox = CreateFrame("Frame", "ItemOrSpell", Box[BoxSkip])
    -- ItemInsideBox:SetPoint("TOP", 0, -25)
    -- ItemInsideBox:SetSize(64, 64)

    -- ItemInsideBox.tex = ItemInsideBox:CreateTexture()
    -- ItemInsideBox.tex:SetAllPoints(ItemInsideBox)
    -- SetPortraitToTexture(ItemInsideBox.tex, itemIcon)

    -- ItemInsideBox.IconTextForShop = ItemInsideBox:CreateFontString(nil, "ARTWORK")
    -- ItemInsideBox.IconTextForShop:SetPoint("BOTTOM", 0, -25)
    -- ItemInsideBox.IconTextForShop:SetFontObject(GameFontNormal)
    -- ItemInsideBox.IconTextForShop:SetText(itemName)
    -- nextRow = nextRow +1
    -- BoxSkip = BoxSkip +1
    -- end

    -- local ItemInsideBox = CreateFrame("Frame", "ItemOrSpell", Box[BoxSkip])
    -- ItemInsideBox:SetPoint("TOP", 0, -25)
    -- ItemInsideBox:SetSize(64, 64)

    -- ItemInsideBox.tex = ItemInsideBox:CreateTexture()
    -- ItemInsideBox.tex:SetAllPoints(ItemInsideBox)
    -- SetPortraitToTexture(ItemInsideBox.tex, itemIcon)

    -- ItemInsideBox.IconTextForShop = ItemInsideBox:CreateFontString(nil, "ARTWORK")
    -- ItemInsideBox.IconTextForShop:SetPoint("BOTTOM", 0, -25)
    -- ItemInsideBox.IconTextForShop:SetFontObject(GameFontNormal)
    -- ItemInsideBox.IconTextForShop:SetText(itemName)
    -- BoxSkip = BoxSkip +1

    -- for Poop=1, #Dump do
    --     local itemName, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(Dump[Poop][2])

    --     local ItemInsideBox = CreateFrame("Frame", "ItemOrSpell", _G["Box" .. Boxx])
    --     ItemInsideBox:SetPoint("TOP", 0, -25)
    --     ItemInsideBox:SetSize(64, 64)

    --     ItemInsideBox.tex = ItemInsideBox:CreateTexture()
    --     ItemInsideBox.tex:SetAllPoints(ItemInsideBox)
    --     SetPortraitToTexture(ItemInsideBox.tex, itemIcon)

    --     ItemInsideBox.IconTextForShop = ItemInsideBox:CreateFontString(nil,
    --                                                                    "ARTWORK")
    --     ItemInsideBox.IconTextForShop:SetPoint("BOTTOM", 0, -25)
    --     ItemInsideBox.IconTextForShop:SetFontObject(GameFontNormal)
    --     ItemInsideBox.IconTextForShop:SetText(itemName)

    --     ItemInsideBox.GoldShow = ItemInsideBox:CreateFontString(nil, "ARTWORK")
    --     ItemInsideBox.GoldShow:SetFontObject(GameFontNormal)
    --     ItemInsideBox.GoldShow:SetPoint("BOTTOM", 0, -45)
    --     ItemInsideBox.GoldShow:SetText(GetCoinTextureString(10000000))
    --     Boxx = Boxx + 1

    -- end
    -- --(PageSystem?)
    -- Store.PageCount = 0
    -- Store.MaxItemsPerPage = 8
    -- Store.CurrentPage = 1

    -- local function UpdateListInfo(list, pagenumber)
    --     Store.ItemsCurrent = {}

    --     if not(pagenumber) then
    --         pagenumber = 1
    --     end

    --     for _, v in pairs(list) do
    --         table.insert(Store.ItemsCurrent, v)
    --     end

    --     Store.PageCount = math.ceil(#Store.ItemsCurrent/Store.MaxItemsPerPage)

    --     if (Store.PageCount < 1) then
    --         Store.PageCount = 1
    --     end

    --     Store.CurrentPage = pagenumber
    --     UpdatePageInfo(Store.CurrentPage)

    --     if (Store.PageCount <= 1) then
    --         Store.CollectionList.NextButton:Disable()
    --     else
    --         Store.CollectionList.NextButton:Enable()
    --     end

    --     if (pagenumber == 1) then
    --         Store.CollectionList.PrevButton:Disable()
    --     end

    --     UpdateListButtons(pagenumber)
    -- end

    -- local function StoreCollectionListNextPage(self)
    --     PlaySound("igMainMenuContinue")
    --     Store.CurrentPage = Store.CurrentPage+1

    --     if (Store.CurrentPage == Store.PageCount) then
    --         self:Disable()
    --     end

    --     if (Store.CollectionList.PrevButton:IsEnabled() == 0) then
    --         Store.CollectionList.PrevButton:Enable()
    --     end

    --     UpdatePageInfo(Store.CurrentPage)
    --     UpdateListButtons(Store.CurrentPage)
    -- end

    -- (Buy Box)
    local BuyButton = CreateFrame("Button", nil, BackGroundFrame,
                                  "UIPanelButtonTemplate")
    BuyButton:SetPoint("BOTTOM")
    BuyButton:SetSize(100, 35)
    BuyButton:SetText("Buy")
    BuyButton:SetScript("OnClick", function(self, button)
        print("You clicked me with " .. button)

        PlaySound(ActiveBuy)

        print("Works?")
    end)

    -- local NextPageFrame = CreateFrame("Button", "NextPageFrame", BackGroundFrame, nil)
    -- NextPageFrame:SetSize(30, 30)
    -- NextPageFrame:SetPoint("BOTTOM", 395, 45)
    -- NextPageFrame:EnableMouse(true)

    -- NextPageFrame:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
    -- NextPageFrame:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
    -- NextPageFrame:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled")
    -- NextPageFrame:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
    -- NextPageFrame:SetScript("OnClick", function(self, button) nextPageOrPrevPage() end)

    -- local PrevPageFrame = CreateFrame("Button", "PrevPageFrame", BackGroundFrame, nil)
    -- PrevPageFrame:SetSize(30, 30)
    -- PrevPageFrame:SetPoint("BOTTOM", 365, 45)
    -- PrevPageFrame:EnableMouse(true)

    -- PrevPageFrame:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
    -- PrevPageFrame:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
    -- PrevPageFrame:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled")
    -- PrevPageFrame:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

    -- NextPageFrame.Text = NextPageFrame:CreateFontString("NextPageFrame.Text")
    -- NextPageFrame.Text:SetPoint("CENTER", -30, 0)
    -- NextPageFrame.Text:SetFontObject(GameFontHighlightSmall)
    -- NextPageFrame.Text:SetShadowOffset(1, -1)

    -- PrevPageFrame.Text = PrevPageFrame:CreateFontString("PrevPageFrame.Text")
    -- PrevPageFrame.Text:SetPoint("CENTER", 30, 0)
    -- PrevPageFrame.Text:SetFontObject(GameFontHighlightSmall)
    -- PrevPageFrame.Text:SetShadowOffset(1, -1)

    print("Loaded")

