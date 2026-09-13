local eggsPerPage = 25
local astralIncubatorSubmenu = {
    menuX = 0,
    menuY = 0,
    eggSprite = Sprite("gfx/ui/skilltrees/nodes/astral_companions.anm2", true),
    hoveredEgg = nil,

    invPage = 0
}

---@param openData? table
function astralIncubatorSubmenu:OnOpen(openData)
    if not openData then return end
    for k, v in pairs(openData) do
        if self[k] ~= nil then self[k] = v end
    end
end

---@param tScreen PST.treeScreen
function astralIncubatorSubmenu:Render(tScreen, submenusModule)
    self.hoveredEgg = nil
    local totalPages = math.ceil(PST.astralCompanionsLen / eggsPerPage)
    submenusModule:DrawNodeSubMenu(
        tScreen,
        eggsPerPage,
        tScreen.camCenterX, tScreen.camCenterY,
        self.menuX, self.menuY,
        PST:getLocalized("node_astralincubator_name") .. " " .. PST.selectedAstralIncubator,
        function()
            for i=1,eggsPerPage do
                local eggID = i + self.invPage * eggsPerPage
                local compName = PST.astralCompanionsOrdered[eggID]
                local compData = PST.astralCompanions[compName]
                if compData then
                    local eggX = self.menuX * tScreen.zoomScale - 64 + ((i - 1) % 5) * 32
                    local eggY = self.menuY * tScreen.zoomScale + 52 + math.floor((i - 1) / 5) * 32
                    local isEquipped = PST:isCompEquipped(compName, true)

                    -- Hovered
                    self.eggSprite.Color.A = 1
                    if self.hoveredEgg == nil then
                        if tScreen.camCenterX > eggX - 16 and tScreen.camCenterX < eggX + 16 and
                        tScreen.camCenterY > eggY - 16 and tScreen.camCenterY < eggY + 16 then
                            self.hoveredEgg = compName
                            tScreen.cursorHighlight = true
                        else
                            self.eggSprite.Color.A = 0.5
                        end
                    else
                        self.eggSprite.Color.A = 0.5
                    end

                    local eggDrawX = eggX - tScreen.treeCamera.X - tScreen.camZoomOffset.X
                    local eggDrawY = eggY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                    self.eggSprite:SetFrame("Eggs", compData.compSprite)
                    self.eggSprite:Render(Vector(eggDrawX, eggDrawY))

                    -- Equipped
                    if isEquipped then
                        PST.miniFont:DrawStringUTF8("E", eggDrawX + 8, eggDrawY + 4, PST.kcolors.LIGHTYELLOW1)
                    end

                    -- Not yet found
                    if not PST.modData.astralcomps[compName] then
                        local tmpJewelSprite = PST.treeScreen.modules.nodeDrawingModule.SCJewelSprite
                        tmpJewelSprite:Play("Unidentified", true)
                        tmpJewelSprite:Render(Vector(eggDrawX, eggDrawY))
                    elseif PST.modData.astralcomps[compName].level > 0 then
                        -- Hatched
                        local tmpJewelSprite = PST.treeScreen.modules.nodeDrawingModule.SCJewelSprite
                        tmpJewelSprite:Play("AncientDone", true)
                        tmpJewelSprite:Render(Vector(eggDrawX, eggDrawY))
                    end
                end
            end
        end,
        {
            prevFunc = function()
                self.invPage = math.max(0, self.invPage - 1)
            end,
            prevDisabled = self.invPage == 0,
            nextFunc = function()
                self.invPage = math.min(totalPages - 1, self.invPage + 1)
            end,
            nextDisabled = self.invPage >= totalPages - 1,
            maxItems = PST.astralCompanionsLen
        }
    )
end

return astralIncubatorSubmenu