local compsPerPage = 25
local companionSlotSubmenu = {
    menuX = 0,
    menuY = 0,
    compSprite = Sprite("gfx/ui/skilltrees/nodes/astral_companions.anm2", true),
    hoveredComp = nil,

    invPage = 0
}

local function PST_countHatchedCompanions()
    if PST.modData.astralcomps then
        local count = 0
        for _, compData in pairs(PST.modData.astralcomps) do
            if compData.level > 0 then
                count = count + 1
            end
        end
        return count
    end
    return 0
end

---@param openData? table
function companionSlotSubmenu:OnOpen(openData)
    if not openData then return end
    for k, v in pairs(openData) do
        if self[k] ~= nil then self[k] = v end
    end
end

---@param tScreen PST.treeScreen
function companionSlotSubmenu:Render(tScreen, submenusModule)
    self.hoveredComp = nil

    local compCount = PST_countHatchedCompanions()
    local totalPages = math.ceil(compCount / compsPerPage)
    submenusModule:DrawNodeSubMenu(
        tScreen,
        compsPerPage,
        tScreen.camCenterX, tScreen.camCenterY,
        self.menuX, self.menuY,
        PST:getLocalized("node_companionslot_name"),
        function()
            local drawnComps = 0
            for i=1,compsPerPage do
                local compID = i + self.invPage * compsPerPage
                local compName = PST.astralCompanionsOrdered[compID]
                local baseCompData = PST.astralCompanions[compName]
                local compData = PST.modData.astralcomps[compName]
                if baseCompData and compData and compData.level > 0 then
                    local compX = self.menuX * tScreen.zoomScale - 64 + (drawnComps % 5) * 32
                    local compY = self.menuY * tScreen.zoomScale + 52 + math.floor(drawnComps / 5) * 32
                    local isEquipped = PST:isCompEquipped(compName)

                    -- Hovered
                    self.compSprite.Color.A = 1
                    if self.hoveredComp == nil then
                        if tScreen.camCenterX > compX - 16 and tScreen.camCenterX < compX + 16 and
                        tScreen.camCenterY > compY - 16 and tScreen.camCenterY < compY + 16 then
                            self.hoveredComp = compName
                            tScreen.cursorHighlight = true
                        else
                            self.compSprite.Color.A = 0.5
                        end
                    else
                        self.compSprite.Color.A = 0.5
                    end

                    local compDrawX = compX - tScreen.treeCamera.X - tScreen.camZoomOffset.X
                    local compDrawY = compY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                    self.compSprite:SetFrame("Default", baseCompData.compSprite)
                    self.compSprite:Render(Vector(compDrawX, compDrawY))

                    -- Equipped
                    if isEquipped then
                        PST.miniFont:DrawStringUTF8("E", compDrawX + 8, compDrawY + 4, PST.kcolors.LIGHTYELLOW1)
                    end

                    if compData.level >= 3 then
                        -- Max level
                        local tmpJewelSprite = PST.treeScreen.modules.nodeDrawingModule.SCJewelSprite
                        tmpJewelSprite:Play("AncientDone", true)
                        tmpJewelSprite:Render(Vector(compDrawX, compDrawY))
                    end

                    drawnComps = drawnComps + 1
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
            maxItems = compCount
        }
    )
end

return companionSlotSubmenu