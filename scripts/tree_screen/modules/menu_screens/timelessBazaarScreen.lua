local timelessBazaarScreen = {
    BGSprite = Sprite("gfx/ui/skilltrees/tree_bg.anm2", true),
    UILinkSprite = Sprite("gfx/ui/skilltrees/nodes/expedition_node_link.anm2", true),
    bazaarUISprite = Sprite("gfx/ui/skilltrees/bazaar_ui.anm2", true),
    itemSprite = Sprite("gfx/005.100_collectible.anm2", true),

    inputOverrides = {
        PSTKeybind.TREE_PAN_DOWN, PSTKeybind.TREE_PAN_LEFT, PSTKeybind.TREE_PAN_RIGHT, PSTKeybind.TREE_PAN_UP,
        PSTKeybind.CENTER_CAMERA, PSTKeybind.PAN_FASTER, PSTKeybind.TREE_TAB,
        PSTKeybind.ALLOCATE_NODE, PSTKeybind.RESPEC_NODE, PSTKeybind.SWITCH_TREE,
        PSTKeybind.CLOSE_TREE
    },

    selectedItem = 0,

    refreshTimer = 0,
    refreshPause = false,
    buyTimer = 0,
    buyPause = false,

    siderealMods = {}
}

-- Init
timelessBazaarScreen.BGSprite:Play("Pixel", true)
timelessBazaarScreen.UILinkSprite:SetFrame("BazaarUI", 1)
timelessBazaarScreen.itemSprite:Play("ShopIdle", true)

function timelessBazaarScreen:CanRefresh()
    local charData = PST:getCurrentCharData()
    return (PST:isNodeNameAllocated("sidereal", "Bazaar Refresh") and charData and not charData.bazaarDone) or PST.debugOptions.freeBazaar
end

function timelessBazaarScreen:OnOpen()
    -- Generate item selection on first entrance
    local charData = PST:getCurrentCharData()
    if charData and not charData.bazaarSelection then
        PST:bazaarGenSelection()
    end

    self.siderealMods = PST:getAllTreeMods("sidereal")
    PST.treeScreen.treeHasChanges = true
end

function timelessBazaarScreen:OnInput()
    -- Input: Directional keys/buttons
    if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT) then
        -- LEFT
        local charData = PST:getCurrentCharData()
        if charData and charData.bazaarSelection and #charData.bazaarSelection > 0 then
            if self.selectedItem == 0 then
                self.selectedItem = #charData.bazaarSelection
            elseif self.selectedItem > 0 then
                self.selectedItem = self.selectedItem - 1
            end
            SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.6, 2, false, 1.2)
        end
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT) then
        -- RIGHT
        local charData = PST:getCurrentCharData()
        if charData and charData.bazaarSelection and #charData.bazaarSelection > 0 then
            if self.selectedItem == 0 then
                self.selectedItem = 1
            elseif self.selectedItem <= #charData.bazaarSelection then
                self.selectedItem = self.selectedItem + 1
                if self.selectedItem > #charData.bazaarSelection then
                    self.selectedItem = 0
                end
            end
            SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.6, 2, false, 1.2)
        end
    end

    -- Input: Allocate (hold)
    if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE, true) then
        -- Purchase selected item
        if self.selectedItem >= 0 and not self.buyPause then
            self.buyTimer = self.buyTimer + 1
            if self.buyTimer == 60 then
                self.buyPause = true

                local result = PST:bazaarTryPurchase(self.selectedItem)
                if result then
                    SFXManager():Play(SoundEffect["SOUND_POWERUP" .. tostring(math.random(1, 3))], 0.7)
                    self.selectedItem = 0
                else
                    SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.8)
                end
            end
        end
    else
        self.buyTimer = 0
        self.buyPause = false
    end

    -- Input: Switch Tree (freeze/unfreeze items)
    if PST:isKeybindActive(PSTKeybind.SWITCH_TREE) then
        local charData = PST:getCurrentCharData()
        if charData then
            if not charData.bazaarFrozen then
                charData.bazaarFrozen = true
                SFXManager():Play(SoundEffect.SOUND_FREEZE, 0.7, 2, false, 1.2)
            else
                charData.bazaarFrozen = nil
                SFXManager():Play(SoundEffect.SOUND_FREEZE_SHATTER, 0.7, 2, false, 1.2)
            end
        end
    end

    -- Input: Respec
    if PST:isKeybindActive(PSTKeybind.RESPEC_NODE) then
        if not self:CanRefresh() then
            SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.8)
        end
    end

    -- Input: Respec (hold)
    if PST:isKeybindActive(PSTKeybind.RESPEC_NODE, true) then
        if not self.refreshPause then
            local charData = PST:getCurrentCharData()
            if charData and self:CanRefresh() then
                self.refreshTimer = self.refreshTimer + 1
                if self.refreshTimer == 60 then
                    self.refreshPause = true

                    local result = PST:bazaarTryRefresh()
                    if result then
                        SFXManager():Play(SoundEffect.SOUND_DEATH_CARD, 0.8, 2, false, 1.2)
                        self.selectedItem = 0
                    else
                        SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.8)
                    end
                end
            end
        end
    else
        self.refreshTimer = 0
        self.refreshPause = false
    end

    -- Input: Close
    if PST:isKeybindActive(PSTKeybind.CLOSE_TREE) then
        if self.selectedItem > 0 then
            self.selectedItem = 0
        else
            PST.treeScreen.modules.menuScreensModule:CloseMenu()
        end
    end
end

function timelessBazaarScreen:DrawUIBox(x, y, w, h)
    self.BGSprite.Scale.X = w
    self.BGSprite.Scale.Y = h
    self.BGSprite:Render(Vector(x, y))

    -- Top decor beam
    local linkBeam = Beam(self.UILinkSprite, 0, false, false)
    local startPos = Vector(x, y)
    local endPos = Vector(x + w, y)
    linkBeam:Add(startPos, 0)
    linkBeam:Add(endPos, 129)
    linkBeam:Render()

    -- Left decor beam
    startPos = Vector(x, y)
    endPos = Vector(x, y + h)
    linkBeam:Add(startPos, 0)
    linkBeam:Add(endPos, 129)
    linkBeam:Render()

    -- Right decor beam
    startPos = Vector(x + w, y + h)
    endPos = Vector(x + w, y)
    linkBeam:Add(startPos, 0)
    linkBeam:Add(endPos, 129)
    linkBeam:Render()

    -- Bottom decor beam
    startPos = Vector(x + w, y + h)
    endPos = Vector(x, y + h)
    linkBeam:Add(startPos, 0)
    linkBeam:Add(endPos, 129)
    linkBeam:Render()
end

local tmpResources = {
    {
        name = "Global SP",
        targetVal = function() return PST.modData.skillPoints end,
        color = PST.kcolors.BLUE1
    },
    {
        name = "Arcane Obols",
        targetVal = function()
            local charData = PST:getCurrentCharData()
            if charData and charData.arcaneObols then return charData.arcaneObols end
            return 0
        end,
        color = PST.kcolors.PURPLE1
    },
    {
        name = "Respecs",
        targetVal = function() return PST.modData.respecPoints end,
        color = PST.kcolors.WHITE
    }
}

---@param tScreen PST.treeScreen
function timelessBazaarScreen:Render(tScreen)
    local boxW, boxH = 300, 255
    local startX = tScreen.screenW / 2 - boxW / 2
    local startY = tScreen.screenH / 2 - boxH / 2
    self:DrawUIBox(startX, startY, boxW, boxH)
    PST.miniFont:DrawString("Timeless Bazaar", startX + 3, startY, PST.kcolors.PURPLE1)
    local drawX = startX + 22
    local drawY = startY + 36

    -- Decor bazaar icon at the top
    local nodeSprite = tScreen.modules.nodeDrawingModule.nodesSprite
    local oldScaleX, oldScaleY, oldAlpha = nodeSprite.Scale.X, nodeSprite.Scale.Y, nodeSprite.Color.A
    nodeSprite.Scale.X = 1
    nodeSprite.Scale.Y = 1

    nodeSprite:SetFrame("Default", 792)
    nodeSprite:Render(Vector(startX + boxW / 2, startY))

    -- Refresh button & usage info
    local canRefresh = self:CanRefresh()
    nodeSprite:SetFrame("Default", 797)
    if not canRefresh then
        nodeSprite.Color.A = 0.4
    elseif self.refreshTimer > 0 and not self.refreshPause then
        nodeSprite.Color.A = 1 + (self.refreshTimer / 60) * 10
    end
    nodeSprite:Render(Vector(drawX, drawY))
    drawX = drawX + 17
    drawY = drawY - 18

    local tmpStr = "Bazaar Refresh"
    if not canRefresh then tmpStr = tmpStr .. " (locked)" end
    PST.miniFont:DrawString(tmpStr, drawX, drawY, PST.kcolors.PURPLE1)
    drawY = drawY + 12

    if not canRefresh then
        PST.luaminiFont:DrawString("Allocate the 'Bazaar Refresh' node to unlock.", drawX, drawY, PST.kcolors.WHITE)
        drawY = drawY + 11
    else
        PST.luaminiFont:DrawString("Hold Respec for 1 second to refresh the item selection.", drawX, drawY, PST.kcolors.WHITE)
        drawY = drawY + 11
        PST.luaminiFont:DrawString("Doing this will remove any purchased items!", drawX, drawY, PST.kcolors.WHITE)
        drawX = startX + 8
        drawY = drawY + 11
        local refreshCosts = PST:bazaarGetCost("refresh")
        tmpStr = "Refreshing costs " .. tostring(refreshCosts.SP) .. " global SP, " .. tostring(refreshCosts.obols) .. " obols, and " .. tostring(refreshCosts.respecs) .. " respecs."
        PST.luaminiFont:DrawString(tmpStr, drawX, drawY, PST.kcolors.LEVEL_PURPLE)
    end
    drawX = startX + 5
    drawY = drawY + 22

    -- Draw player resources
    for i=0,2 do
        self.bazaarUISprite:SetFrame("Default", i)
        self.bazaarUISprite:Render(Vector(drawX, drawY))

        local tmpRes = tmpResources[i + 1]
        tmpStr = tmpRes.name .. ": " .. tostring(tmpRes.targetVal())
        PST.miniFont:DrawString(tmpStr, drawX + 17, drawY, tmpRes.color)
        drawY = drawY + 15
    end
    drawX = drawX - 2
    drawY = drawY + 3

    local charData = PST:getCurrentCharData()

    -- Draw offered items
    local tmpColor = PST.kcolors.PURPLE1
    tmpStr = "Offered Items:"
    if charData and charData.bazaarFrozen then
        tmpColor = PST.kcolors.SKY_BLUE
        tmpStr = tmpStr .. " (frozen)"
        self.bazaarUISprite:SetFrame("Default", 3)
        self.bazaarUISprite:Render(Vector(drawX + PST.miniFont:GetStringWidth(tmpStr) + 3, drawY - 5))
    end
    PST.miniFont:DrawString(tmpStr, drawX, drawY, tmpColor)
    drawY = drawY + 15

    local itemBoxW = boxW - 10
    local itemBoxH = 36
    self.BGSprite.Color.RO = 0.16
    self.BGSprite.Color.GO = 0.1
    self.BGSprite.Color.BO = 0.2
    if charData and charData.bazaarFrozen then
        self.BGSprite.Color.RO = 0.05
        self.BGSprite.Color.GO = 0.05
    end
    self:DrawUIBox(tScreen.screenW / 2 - itemBoxW / 2, drawY, itemBoxW, itemBoxH)

    if charData and charData.bazaarSelection then
        local gameCfg = Isaac.GetItemConfig()
        for i, tmpItem in ipairs(charData.bazaarSelection) do
            local itemCfg = gameCfg:GetCollectible(tmpItem)
            if itemCfg then
                local isSelected = self.selectedItem == i
                local itemX = drawX + 17 + 34 * (i - 1)
                local itemY = drawY + 26
                self.itemSprite:ReplaceSpritesheet(1, itemCfg.GfxFileName, true)
                if isSelected then
                    self.itemSprite.Color.RO = 0.2
                    self.itemSprite.Color.GO = 0.2
                    self.itemSprite.Color.BO = 0.2
                    if self.buyTimer > 0 and not self.buyPause then
                        local tmpPerc = self.buyTimer / 60
                        self.itemSprite.Color.RO = 0.2 + 0.4 * tmpPerc
                        self.itemSprite.Color.GO = 0.2 + 0.15 * tmpPerc
                        self.itemSprite.Color.BO = 0.2 + 0.6 * tmpPerc
                    end
                end
                self.itemSprite:Render(Vector(itemX, itemY))
                self.itemSprite.Color.RO = 0
                self.itemSprite.Color.GO = 0
                self.itemSprite.Color.BO = 0

                self.bazaarUISprite:SetFrame("Quality", itemCfg.Quality)
                self.bazaarUISprite:Render(Vector(itemX, itemY - 5))
            end
        end
    end
    drawX = drawX + 3
    drawY = drawY + 36
    PST.luaminiFont:DrawString("Left/Right to select item.", drawX, drawY, PST.kcolors.WHITE)
    drawY = drawY + 12
    PST.luaminiFont:DrawString("Press Q to freeze/unfreeze offered items.", drawX, drawY, PST.kcolors.SKY_BLUE)
    drawY = drawY + 16

    -- Draw purchased items
    PST.miniFont:DrawString("Purchased Items:", drawX, drawY, PST.kcolors.PURPLE1)
    drawY = drawY + 15

    self.BGSprite.Color.RO = 0.1
    self.BGSprite.Color.GO = 0.1
    self.BGSprite.Color.BO = 0.2
    self:DrawUIBox(tScreen.screenW / 2 - itemBoxW / 2, drawY, itemBoxW, itemBoxH)
    self.BGSprite.Color.RO = 0
    self.BGSprite.Color.GO = 0
    self.BGSprite.Color.BO = 0

    if charData and charData.bazaarPurchased then
        local gameCfg = Isaac.GetItemConfig()
        for i, tmpItem in ipairs(charData.bazaarPurchased) do
            local itemCfg = gameCfg:GetCollectible(tmpItem)
            if itemCfg then
                local itemX = drawX + 17 + 34 * (i - 1)
                local itemY = drawY + 26
                self.itemSprite:ReplaceSpritesheet(1, itemCfg.GfxFileName, true)
                self.itemSprite:Render(Vector(itemX, itemY))

                self.bazaarUISprite:SetFrame("Quality", itemCfg.Quality)
                self.bazaarUISprite:Render(Vector(itemX, itemY - 5))
            end
        end
    end

    -- Selected item description box
    if charData and self.selectedItem ~= 0 then
        local tmpItem = charData.bazaarSelection[self.selectedItem]
        local itemCfg = Isaac.GetItemConfig():GetCollectible(tmpItem)
        if itemCfg then
            local itemName = Isaac.GetLocalizedString("Items", itemCfg.Name, "en")
            if itemName == "StringTable::InvalidKey" then
                itemName = itemCfg.Name
            end
            local itemCost = PST:bazaarGetCost(itemCfg.Quality)
            local costColor = PST.kcolors.LEVEL_PURPLE
            if not PST:bazaarCanAffordCost(itemCfg.Quality) and not PST.debugOptions.freeBazaar then
                costColor = PST.kcolors.RED1
            end
            local itemDesc = { "Hold allocate for 1 second to purchase this item." }
            -- Chance to keep other items
            local tmpMod = self.siderealMods["bazaarSelKeep"]
            if tmpMod and tmpMod > 0 then
                table.insert(itemDesc, tostring(tmpMod) .. "% chance to keep the other item options when purchasing.")
            else
                table.insert(itemDesc, "Purchasing this item will remove the other options!")
            end
            -- Cost
            table.insert(itemDesc, {"Cost: " .. tostring(itemCost.obols) .. " arcane obols.", costColor})

            -- Final item description box
            tScreen:DrawNodeBox(itemName, itemDesc, startX + 7, 190, true, 1)
        end
    end

    -- Reset tree nodes sprite
    nodeSprite.Scale.X = oldScaleX
    nodeSprite.Scale.Y = oldScaleY
    nodeSprite.Color.A = oldAlpha
end

return timelessBazaarScreen