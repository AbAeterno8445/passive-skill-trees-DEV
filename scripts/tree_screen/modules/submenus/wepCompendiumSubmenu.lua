local weaponCompendiumSubmenu = {
    menuX = 0,
    menuY = 0,
    selectedType = nil,
    hoveredID = nil,
    hoveredBackButton = false,

    weaponSprite = Sprite("gfx/ui/skilltrees/nodes/astral_weapons.anm2", true)
}

local ancWeaponList = {}
for _, tmpType in pairs(PSTAstralWepType) do
    local wepData = PST.astralWepData[tmpType]
    if wepData then
        ancWeaponList[tmpType] = {}
        for i, ancData in ipairs(wepData.ancients) do
            local newWep = PST:createAstralWep(tmpType, PSTAstralWepRarity.ANCIENT, 1, i)
            newWep.name = ancData.name
            table.insert(ancWeaponList[tmpType], newWep)
        end
    end
end

---@param openData? table
function weaponCompendiumSubmenu:OnOpen(openData)
    if not openData then return end
    self.selectedType = nil
    for k, v in pairs(openData) do
        if self[k] ~= nil then self[k] = v end
    end
end

---@param tScreen PST.treeScreen
function weaponCompendiumSubmenu:Render(tScreen, submenusModule)
    self.hoveredID = nil
    self.hoveredBackButton = false

    local tmpTitle = "Weapon Compendium"
    local itemCount = 14
    local selectedData = PST.astralWepData[self.selectedType]
    if selectedData then
        tmpTitle = selectedData.name .. " Compendium"
        itemCount = #selectedData.ancients + 5
    end
    submenusModule:DrawNodeSubMenu(
        tScreen,
        itemCount,
        tScreen.camCenterX, tScreen.camCenterY,
        self.menuX, self.menuY,
        tmpTitle,
        function()
            if not selectedData then
                local i = 1
                for tmpType, _ in pairs(ancWeaponList) do
                    local wepData = PST.astralWepData[tmpType]
                    if wepData then
                        local drawX = self.menuX * tScreen.zoomScale - 64 + ((i - 1) % 5) * 32
                        local drawY = self.menuY * tScreen.zoomScale + 52 + math.floor((i - 1) / 5) * 32

                        -- Hovered
                        if self.hoveredID == nil then
                            if tScreen.camCenterX > drawX - 16 and tScreen.camCenterX < drawX + 16 and
                            tScreen.camCenterY > drawY - 16 and tScreen.camCenterY < drawY + 16 then
                                self.hoveredID = tmpType
                                self.weaponSprite.Color.A = 1
                                tScreen.cursorHighlight = true
                            else
                                self.weaponSprite.Color.A = 0.4
                            end
                        else
                            self.weaponSprite.Color.A = 0.4
                        end

                        local finalDrawX = drawX - tScreen.treeCamera.X - tScreen.camZoomOffset.X
                        local finalDrawY = drawY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                        self.weaponSprite:SetFrame("Normal", wepData.spriteFrames[0])
                        self.weaponSprite:Render(Vector(finalDrawX, finalDrawY))

                        i = i + 1
                    end
                end
            else
                local tmpWepList = ancWeaponList[self.selectedType]
                for i, tmpWep in ipairs(tmpWepList) do
                    local drawX = self.menuX * tScreen.zoomScale - 64 + ((i - 1) % 5) * 32
                    local drawY = self.menuY * tScreen.zoomScale + 52 + math.floor((i - 1) / 5) * 32

                    -- Hovered
                    if self.hoveredID == nil then
                        if tScreen.camCenterX > drawX - 16 and tScreen.camCenterX < drawX + 16 and
                        tScreen.camCenterY > drawY - 16 and tScreen.camCenterY < drawY + 16 then
                            self.hoveredID = tmpWep
                            self.weaponSprite.Color.A = 1
                            tScreen.cursorHighlight = true
                        else
                            self.weaponSprite.Color.A = 0.4
                        end
                    else
                        self.weaponSprite.Color.A = 0.4
                    end

                    local finalDrawX = drawX - tScreen.treeCamera.X - tScreen.camZoomOffset.X
                    local finalDrawY = drawY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                    PST:renderAstralWepAt(tmpWep, self.weaponSprite, finalDrawX, finalDrawY, 1)
                end

                -- Back button
                local buttonX = self.menuX * tScreen.zoomScale - 70
                local buttonY = self.menuY * tScreen.zoomScale + 45 + 32 * math.floor(itemCount / 5)
                local tmpColor = PST.kcolors.WHITE
                if tScreen.camCenterX > buttonX - 4 and tScreen.camCenterX < buttonX + 32 and
                tScreen.camCenterY > buttonY - 4 and tScreen.camCenterY < buttonY + 18 then
                    self.hoveredBackButton = true
                    tScreen.cursorHighlight = true
                    tmpColor = PST.kcolors.ANCIENT_ORANGE
                end
                PST.normalFont:DrawString("Back", buttonX - tScreen.treeCamera.X - tScreen.camZoomOffset.X, buttonY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y, tmpColor)
            end
        end
    )
end

return weaponCompendiumSubmenu