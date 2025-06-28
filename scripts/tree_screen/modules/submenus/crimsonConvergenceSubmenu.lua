local crimsonConvergenceSubmenu = {
    menuX = 0,
    menuY = 0,
    crimsonBuffSprite = Sprite("gfx/ui/skilltrees/nodes/crimson_convergence_nodes.anm2", true),
    hoveredBuff = nil
}

---@param openData? table
function crimsonConvergenceSubmenu:OnOpen(openData)
    if not openData then return end
    for k, v in pairs(openData) do
        if self[k] ~= nil then self[k] = v end
    end
end

---@param tScreen PST.treeScreen
function crimsonConvergenceSubmenu:Render(tScreen, submenusModule)
    local charData = PST:getCurrentCharData()
    self.hoveredBuff = nil
    submenusModule:DrawNodeSubMenu(
        tScreen,
        PST.crimConvBuffsLen,
        tScreen.camCenterX, tScreen.camCenterY,
        self.menuX, self.menuY,
        PST:getLocalized("ui_crimsonConvergence"),
        function()
            for i, buffName in ipairs(PST.crimConvBuffOrder) do
                local nodeX = self.menuX * tScreen.zoomScale - 64 + ((i - 1) % 5) * 32
                local nodeY = self.menuY * tScreen.zoomScale + 52 + math.floor((i - 1) / 5) * 32
                local isSelected = (charData and charData.crimConvBuff == buffName)

                -- Hovered
                self.crimsonBuffSprite.Color.A = 1
                if self.hoveredBuff == nil then
                    if tScreen.camCenterX > nodeX - 16 and tScreen.camCenterX < nodeX + 16 and
                    tScreen.camCenterY > nodeY - 16 and tScreen.camCenterY < nodeY + 16 then
                        self.hoveredBuff = buffName
                        tScreen.cursorHighlight = true
                    elseif not isSelected then
                        self.crimsonBuffSprite.Color.A = 0.5
                    end
                elseif not isSelected then
                    self.crimsonBuffSprite.Color.A = 0.5
                end

                self.crimsonBuffSprite:SetFrame("Default", i - 1)
                self.crimsonBuffSprite:Render(Vector(
                    nodeX - tScreen.treeCamera.X - tScreen.camZoomOffset.X,
                    nodeY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                ))

                -- Selected
                if isSelected then
                    PST.cosmicRData.charSprite.Color.A = 1
                    PST.cosmicRData.charSprite:Play("Select", true)
                    PST.cosmicRData.charSprite:Render(Vector(
                        nodeX - tScreen.treeCamera.X - tScreen.camZoomOffset.X,
                        nodeY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                    ))
                end
            end
        end
    )
end

return crimsonConvergenceSubmenu