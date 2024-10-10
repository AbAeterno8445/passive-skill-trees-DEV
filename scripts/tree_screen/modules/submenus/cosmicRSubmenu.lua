local cosmicRSubmenu = {
    menuX = 0,
    menuY = 0,
    hoveredCharID = nil
}

---@param openData? table
function cosmicRSubmenu:OnOpen(openData)
    if not openData then return end
    for k, v in pairs(openData) do
        if self[k] ~= nil then self[k] = v end
    end
end

---@param tScreen PST.treeScreen
function cosmicRSubmenu:Render(tScreen, submenusModule)
    self.hoveredCharID = nil
    submenusModule:DrawNodeSubMenu(
        tScreen,
        #PST.cosmicRData.characters,
        tScreen.camCenterX, tScreen.camCenterY,
        self.menuX, self.menuY,
        "Cosmic Realignment",
        function()
            local i = 1
            for charID, _ in pairs(PST.cosmicRData.characters) do
                local charName = PST.charNames[1 + charID]
                local charX = self.menuX * tScreen.zoomScale - 64 + ((i - 1) % 5) * 32
                local charY = self.menuY * tScreen.zoomScale + 52 + math.floor((i - 1) / 5) * 32

                -- Hovered
                if self.hoveredCharID == nil then
                    if tScreen.camCenterX > charX - 16 and tScreen.camCenterX < charX + 16 and
                    tScreen.camCenterY > charY - 16 and tScreen.camCenterY < charY + 16 then
                        self.hoveredCharID = charID
                        PST.cosmicRData.charSprite.Color.A = 1
                        PST.cosmicRData.charSprite:Play("Select", true)
                        PST.cosmicRData.charSprite:Render(Vector(charX - tScreen.treeCamera.X - tScreen.camZoomOffset.X, charY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y))
                        tScreen.cursorHighlight = true
                    else
                        PST.cosmicRData.charSprite.Color.A = 0.4
                    end
                else
                    PST.cosmicRData.charSprite.Color.A = 0.4
                end

                if not PST:cosmicRIsCharUnlocked(charID) then
                    PST.cosmicRData.lockedCharSprite:Play(charName, true)
                    PST.cosmicRData.lockedCharSprite:Render(Vector(charX - tScreen.treeCamera.X - tScreen.camZoomOffset.X, charY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y))

                    PST.cosmicRData.charSprite.Color.A = 1
                    PST.cosmicRData.charSprite:Play("Locked", true)
                    PST.cosmicRData.charSprite:Render(Vector(charX - tScreen.treeCamera.X - tScreen.camZoomOffset.X, charY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y))
                else
                    PST.cosmicRData.charSprite:Play(charName, true)
                    PST.cosmicRData.charSprite:Render(Vector(charX - tScreen.treeCamera.X - tScreen.camZoomOffset.X, charY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y))
                end

                i = i + 1
            end
        end
    )
end

return cosmicRSubmenu