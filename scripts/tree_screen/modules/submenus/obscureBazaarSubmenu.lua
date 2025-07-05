local obsBazaarSubmenu = {
    menuX = 0,
    menuY = 0,
    expNodeSprite = Sprite("gfx/ui/skilltrees/nodes/expedition_nodes.anm2", true),
    hoveredItem = nil
}

local obsBazaarItems = {
    {
        name = PST:getLocalized("ui_crimsonCore"),
        price = 6666,
        type = PSTExpNodeRewardType.C_STARCORE,
        purchaseFunc = function(charData)
            if not charData then return end
            charData.crimsonStarcores = charData.crimsonStarcores + 1
        end
    },
    {
        name = PST:getLocalized("ui_starblessedPrism"),
        price = 8000,
        type = PSTExpNodeRewardType.STARBLESS_PRISM,
        purchaseFunc = function(charData)
            PST.modData.starblessPrism = PST.modData.starblessPrism + 1
        end
    },
    {
        name = PST:getLocalized("ui_characterSkillPoint"),
        price = 2000,
        type = PSTExpNodeRewardType.GLOBAL_SP,
        purchaseFunc = function(charData)
            if not charData then return end
            charData.skillPoints = charData.skillPoints + 1
        end
    }
}

function PST:getObsBazaarPrice(price)
    local newPrice = price
    local starMods = PST:getAllTreeMods("starTree")
    if starMods.obsBazaarDiscount then
        newPrice = math.max(100, math.floor(newPrice * (1 - starMods.obsBazaarDiscount / 100)))
    end
    return newPrice
end

---@param openData? table
function obsBazaarSubmenu:OnOpen(openData)
    if not openData then return end
    for k, v in pairs(openData) do
        if self[k] ~= nil then self[k] = v end
    end
end

---@param tScreen PST.treeScreen
function obsBazaarSubmenu:Render(tScreen, submenusModule)
    self.hoveredItem = nil
    submenusModule:DrawNodeSubMenu(
        tScreen,
        #obsBazaarItems,
        tScreen.camCenterX, tScreen.camCenterY,
        self.menuX, self.menuY,
        PST:getLocalized("ui_obscureBazaar"),
        function()
            local i = 1
            for _, tmpItem in ipairs(obsBazaarItems) do
                local nodeX = self.menuX * tScreen.zoomScale - 64 + ((i - 1) % 5) * 32
                local nodeY = self.menuY * tScreen.zoomScale + 52 + math.floor((i - 1) / 5) * 32

                -- Hovered
                self.expNodeSprite.Color.A = 0.5
                if self.hoveredItem == nil then
                    if tScreen.camCenterX > nodeX - 16 and tScreen.camCenterX < nodeX + 16 and
                    tScreen.camCenterY > nodeY - 16 and tScreen.camCenterY < nodeY + 16 then
                        self.hoveredItem = tmpItem
                        self.expNodeSprite.Color.A = 1
                        tScreen.cursorHighlight = true
                    end
                end

                self.expNodeSprite:SetFrame("Icons", tmpItem.type - 1)
                self.expNodeSprite:Render(Vector(
                    nodeX - tScreen.treeCamera.X - tScreen.camZoomOffset.X,
                    nodeY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                ))

                i = i + 1
            end
        end
    )
end

return obsBazaarSubmenu