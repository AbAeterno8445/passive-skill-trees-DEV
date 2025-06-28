local infMeridionSubmenu = {
    menuX = 0,
    menuY = 0,
    statusSprite = Sprite("gfx/ui/skilltrees/nodes/infectious_meridion_status.anm2", true),
    hoveredStatus = nil
}

local infStatus = { "poison", "fear", "charm", "slow", "burn" }

---@param openData? table
function infMeridionSubmenu:OnOpen(openData)
    if not openData then return end
    for k, v in pairs(openData) do
        if self[k] ~= nil then self[k] = v end
    end
end

---@param tScreen PST.treeScreen
function infMeridionSubmenu:Render(tScreen, submenusModule)
    local charData = PST:getCurrentCharData()
    self.hoveredStatus = nil
    submenusModule:DrawNodeSubMenu(
        tScreen,
        #infStatus,
        tScreen.camCenterX, tScreen.camCenterY,
        self.menuX, self.menuY,
        PST:getLocalized("ui_infectiousMeridion"),
        function()
            local i = 1
            for _, tmpStatus in ipairs(infStatus) do
                local nodeX = self.menuX * tScreen.zoomScale - 64 + ((i - 1) % 5) * 32
                local nodeY = self.menuY * tScreen.zoomScale + 52 + math.floor((i - 1) / 5) * 32
                local isSelected = (charData and charData.artiInfMeridionStatus == tmpStatus)

                -- Hovered
                self.statusSprite.Color.A = 1
                if self.hoveredStatus == nil then
                    if tScreen.camCenterX > nodeX - 16 and tScreen.camCenterX < nodeX + 16 and
                    tScreen.camCenterY > nodeY - 16 and tScreen.camCenterY < nodeY + 16 then
                        self.hoveredStatus = tmpStatus
                        tScreen.cursorHighlight = true
                    elseif not isSelected then
                        self.statusSprite.Color.A = 0.5
                    end
                elseif not isSelected then
                    self.statusSprite.Color.A = 0.5
                end

                self.statusSprite:Play(tmpStatus, true)
                self.statusSprite:Render(Vector(
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

                i = i + 1
            end
        end
    )
end

return infMeridionSubmenu