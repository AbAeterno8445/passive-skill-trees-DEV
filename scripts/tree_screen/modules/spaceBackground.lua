local colorStep = 0.02

local spaceBGModule = {
    targetSpaceColor = Color(1, 1, 1, 1),

    -- Space movement
    spaceOffPos = Vector.Zero,
    spaceOffDir = Vector(-1 + 2 * math.random(), -1 + 2 * math.random()),
    spaceOffStep = 0,
    spaceOffTotalSteps = 1000,

    treeSpaceSprite = Sprite("gfx/ui/skilltrees/tree_space_bg.anm2", true),
    treeStarfieldSprite = Sprite("gfx/ui/skilltrees/tree_starfield.anm2", true),

    treeStarfieldList = {}
}

-- Init sprites
spaceBGModule.treeSpaceSprite.Color.A = 0.5
spaceBGModule.treeSpaceSprite:Play("Default", true)
spaceBGModule.treeStarfieldSprite.Color.A = 0.6

function spaceBGModule:ShuffleStarfield()
    self.treeStarfieldList = {}
    for _=1,9 do
        local tmpStarfields = {}
        for i=1,5 do
            if math.random() < 100 / (i ^ 2) then
                table.insert(tmpStarfields, {
                    sprite = "Starfield" .. tostring(i),
                    offsetMult = -0.2 - 0.2 * math.random()
                })
            end
        end
        table.insert(self.treeStarfieldList, tmpStarfields)
    end
end

---@param tScreen PST.treeScreen
function spaceBGModule:Update(tScreen)
    -- Space background color shifting
    if self.treeSpaceSprite.Color.R < self.targetSpaceColor.R then
        self.treeSpaceSprite.Color.R = self.treeSpaceSprite.Color.R + colorStep
        self.treeStarfieldSprite.Color.R = self.treeStarfieldSprite.Color.R + colorStep
    elseif self.treeSpaceSprite.Color.R > self.targetSpaceColor.R then
        self.treeSpaceSprite.Color.R = self.treeSpaceSprite.Color.R - colorStep
        self.treeStarfieldSprite.Color.R = self.treeStarfieldSprite.Color.R - colorStep
    end
    if self.treeSpaceSprite.Color.G < self.targetSpaceColor.G then
        self.treeSpaceSprite.Color.G = self.treeSpaceSprite.Color.G + colorStep
        self.treeStarfieldSprite.Color.G = self.treeStarfieldSprite.Color.G + colorStep
    elseif self.treeSpaceSprite.Color.G > self.targetSpaceColor.G then
        self.treeSpaceSprite.Color.G = self.treeSpaceSprite.Color.G - colorStep
        self.treeStarfieldSprite.Color.G = self.treeStarfieldSprite.Color.G - colorStep
    end
    if self.treeSpaceSprite.Color.B < self.targetSpaceColor.B then
        self.treeSpaceSprite.Color.B = self.treeSpaceSprite.Color.B + colorStep
        self.treeStarfieldSprite.Color.B = self.treeStarfieldSprite.Color.B + colorStep
    elseif self.treeSpaceSprite.Color.B > self.targetSpaceColor.B then
        self.treeSpaceSprite.Color.B = self.treeSpaceSprite.Color.B - colorStep
        self.treeStarfieldSprite.Color.B = self.treeStarfieldSprite.Color.B - colorStep
    end

    -- Space background movement
    if self.spaceOffStep < self.spaceOffTotalSteps / 2 then
        self.spaceOffPos = self.spaceOffPos + self.spaceOffDir * PST:ParametricBlend(self.spaceOffStep / self.spaceOffTotalSteps)
    elseif self.spaceOffStep < self.spaceOffTotalSteps then
        self.spaceOffPos = self.spaceOffPos + self.spaceOffDir * PST:ParametricBlend((self.spaceOffTotalSteps - self.spaceOffStep) / self.spaceOffTotalSteps)
    else
        self.spaceOffStep = 0
        self.spaceOffDir = self.spaceOffDir * -1
    end
    self.spaceOffStep = self.spaceOffStep + 1
end

---@param tScreen PST.treeScreen
function spaceBGModule:Render(tScreen)
    -- Draw space BG
    if tScreen.resized then
        self.treeSpaceSprite.Scale = Vector(tScreen.screenW / 600, tScreen.screenH / 400)
    end
    local starfieldID = 1
    for i=-1,1 do
        for j=-1,1 do
            local xOff = 600 * j * self.treeSpaceSprite.Scale.X
            local yOff = 400 * i * self.treeSpaceSprite.Scale.Y
            local startX = tScreen.camCenterX - tScreen.screenW / 2
            local startY = tScreen.camCenterY - tScreen.screenH / 2
            self.treeSpaceSprite:Render(Vector(startX * -0.1 + xOff + self.spaceOffPos.X * 0.1, startY * -0.1 + yOff + self.spaceOffPos.Y * 0.1))

            if self.treeStarfieldList[starfieldID] then
                for _, tmpStarfield in ipairs(self.treeStarfieldList[starfieldID]) do
                    self.treeStarfieldSprite:Play(tmpStarfield.sprite)
                    self.treeStarfieldSprite:Render(Vector(
                        startX * tmpStarfield.offsetMult + xOff + self.spaceOffPos.X * tmpStarfield.offsetMult,
                        startY * tmpStarfield.offsetMult + yOff + self.spaceOffPos.Y * tmpStarfield.offsetMult
                    ))
                end
            end
            starfieldID = starfieldID + 1
        end
    end
end

return spaceBGModule