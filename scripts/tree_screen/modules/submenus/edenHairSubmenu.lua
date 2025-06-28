local edenHairSubmenu = {
    menuX = 0,
    menuY = 0,
    edenHairSprite = Sprite("gfx/characters/character_009_edenhair1.anm2", true),
    hoveredHair = nil
}

local isaacHeadSprite = Sprite("gfx/001.000_player.anm2", true)
isaacHeadSprite:SetFrame("HeadDown", 0)

local hairstyleCount = 40
edenHairSubmenu.edenHairSprite:SetFrame("HeadDown", 0)

local headFrames = {"HeadDown", "HeadLeft", "HeadUp", "HeadRight"}
local currentHeadFrame = 1
local headFrameTimer = 0

---@param openData? table
function edenHairSubmenu:OnOpen(openData)
    if not openData then return end
    for k, v in pairs(openData) do
        if self[k] ~= nil then self[k] = v end
    end
end

---@param tScreen PST.treeScreen
function edenHairSubmenu:Render(tScreen, submenusModule)
    local charData = PST:getCurrentCharData()
    self.hoveredHair = nil
    submenusModule:DrawNodeSubMenu(
        tScreen,
        hairstyleCount,
        tScreen.camCenterX, tScreen.camCenterY,
        self.menuX, self.menuY,
        PST:getLocalized("ui_edenHairdo"),
        function()
            for i=1,hairstyleCount do
                local nodeX = self.menuX * tScreen.zoomScale - 64 + ((i - 1) % 5) * 32
                local nodeY = self.menuY * tScreen.zoomScale + 52 + math.floor((i - 1) / 5) * 32
                local isSelected = (charData and charData.hairdo == i)

                -- Hovered
                self.edenHairSprite.Color.A = 1
                if self.hoveredHair == nil then
                    if tScreen.camCenterX > nodeX - 16 and tScreen.camCenterX < nodeX + 16 and
                    tScreen.camCenterY > nodeY - 16 and tScreen.camCenterY < nodeY + 16 then
                        self.hoveredHair = i
                        tScreen.cursorHighlight = true
                    elseif not isSelected then
                        self.edenHairSprite.Color.A = 0.5
                    end
                elseif not isSelected then
                    self.edenHairSprite.Color.A = 0.5
                end

                self.edenHairSprite:ReplaceSpritesheet(0, "gfx/characters/costumes/character_009_edenhair" .. i .. ".png", true)
                self.edenHairSprite:Render(Vector(
                    nodeX - tScreen.treeCamera.X - tScreen.camZoomOffset.X,
                    nodeY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y + 16
                ))

                -- Selected
                if isSelected then
                    PST.cosmicRData.charSprite.Color.A = 0.4
                    PST.cosmicRData.charSprite:Play("Select", true)
                    PST.cosmicRData.charSprite:Render(Vector(
                        nodeX - tScreen.treeCamera.X - tScreen.camZoomOffset.X,
                        nodeY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                    ))
                    PST.cosmicRData.charSprite.Color.A = 1
                end
            end

            -- Preview
            headFrameTimer = headFrameTimer + 1
            if headFrameTimer == 90 then
                currentHeadFrame = currentHeadFrame + 1
                if currentHeadFrame > 4 then currentHeadFrame = 1 end
                headFrameTimer = 0
            end
            if charData and charData.hairdo > 0 then
                local headX = self.menuX * tScreen.zoomScale + 35 - tScreen.treeCamera.X - tScreen.camZoomOffset.X
                local headY = self.menuY * tScreen.zoomScale + 18 - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                local tmpAnim = headFrames[currentHeadFrame]

                isaacHeadSprite:SetFrame(tmpAnim, 0)
                isaacHeadSprite:Render(Vector(headX, headY))

                self.edenHairSprite.Color.A = 1
                self.edenHairSprite:ReplaceSpritesheet(0, "gfx/characters/costumes/character_009_edenhair" .. charData.hairdo .. ".png", true)
                self.edenHairSprite:SetFrame(tmpAnim, 0)
                self.edenHairSprite:Render(Vector(headX, headY))
                if tmpAnim ~= "HeadDown" then
                    self.edenHairSprite:SetFrame("HeadDown", 0)
                end
            end
        end
    )
end

return edenHairSubmenu