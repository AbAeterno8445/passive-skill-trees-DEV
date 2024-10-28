local astralForgeScreen = {
    BGSprite = Sprite("gfx/ui/skilltrees/tree_bg.anm2", true),
    UILinkSprite = Sprite("gfx/ui/skilltrees/nodes/expedition_node_link.anm2", true),
    weaponSprite = Sprite("gfx/ui/skilltrees/nodes/astral_weapons.anm2", true),
    forgeUISprite = Sprite("gfx/ui/skilltrees/astral_forge_ui.anm2", true),

    -- Camera control
    camera = Vector.Zero,
    cameraSpeed = 3,
    camCenterX = Isaac.GetScreenWidth() / 2,
    camCenterY = Isaac.GetScreenHeight() / 2,

    inputOverrides = {
        PSTKeybind.TREE_PAN_DOWN, PSTKeybind.TREE_PAN_LEFT, PSTKeybind.TREE_PAN_RIGHT, PSTKeybind.TREE_PAN_UP,
        PSTKeybind.CENTER_CAMERA, PSTKeybind.PAN_FASTER, PSTKeybind.TREE_TAB,
        PSTKeybind.ALLOCATE_NODE, PSTKeybind.RESPEC_NODE, PSTKeybind.SWITCH_TREE
    },

    -- Currently hovered/selected weapon
    ---@type PSTAstralWeapon|nil
    hoveredWeapon = nil,
    ---@type PSTAstralWeapon|nil
    selectedWeapon = nil,

    -- Inventory filters
    hoveredFilter = nil,
    appliedFilters = {
        weaponType = {},
        weaponRarity = {}
    }
}

-- Init
astralForgeScreen.BGSprite:Play("Pixel", true)
astralForgeScreen.UILinkSprite:SetFrame("AstralForgeUI", 1)
astralForgeScreen.forgeUISprite:Play("Default", true)

function astralForgeScreen:CenterCamera()
    self.camera = Vector.Zero
end

-- Input processing
function astralForgeScreen:OnInput()
    -- Input: Faster panning
    if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then self.cameraSpeed = 8
    else self.cameraSpeed = 3 end

    -- Input: Directional keys/buttons
    if PST:isKeybindActive(PSTKeybind.TREE_PAN_UP, true) then
        -- UP
        if self.camera.Y > -2000 then
            self.camera.Y = self.camera.Y - self.cameraSpeed
        end
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_DOWN, true) then
        -- DOWN
        if self.camera.Y < 2000 then
            self.camera.Y = self.camera.Y + self.cameraSpeed
        end
    end
    if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT, true) then
        -- LEFT
        if self.camera.X > -2000 then
            self.camera.X = self.camera.X - self.cameraSpeed
        end
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT, true) then
        -- RIGHT
        if self.camera.X < 2000 then
            self.camera.X = self.camera.X + self.cameraSpeed
        end
    end

    -- Input: Allocate
    if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
        -- Hovered filter, apply it
        if self.hoveredFilter then
            local tmpFilterElem = self.hoveredFilter.weaponType
            local targetTable = self.appliedFilters.weaponType
            if self.hoveredFilter.weaponRarity then
                targetTable = self.appliedFilters.weaponRarity
                tmpFilterElem = self.hoveredFilter.weaponRarity
            end
            if tmpFilterElem then
                if not PST:arrHasValue(targetTable, tmpFilterElem) then
                    table.insert(targetTable, tmpFilterElem)
                else
                    for i, tmpFilter in ipairs(targetTable) do
                        if tmpFilter == tmpFilterElem then
                            table.remove(targetTable, i)
                            break
                        end
                    end
                end
                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
            end
        end
    end

    -- Input: Center camera
    if PST:isKeybindActive(PSTKeybind.CENTER_CAMERA) then
        self:CenterCamera()
    end
end

---@param tScreen PST.treeScreen
function astralForgeScreen:Update(tScreen)
    --tScreen.hideHUD = true
    tScreen.hideNodes = true
    self.hoveredWeapon = nil
    self.hoveredFilter = nil
end

function astralForgeScreen:DrawUIBox(x, y, w, h)
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

-- Indexes for these correspond to the frame # in the UI sprite's Filters anim
local invFilters = {
    { weaponType = PSTAstralWepType.LONGSWORD },
    { weaponType = PSTAstralWepType.ESTOC },
    { weaponType = PSTAstralWepType.DAGGER },
    { weaponType = PSTAstralWepType.QUICKBLADE },
    { weaponType = PSTAstralWepType.SPEAR },
    { weaponType = PSTAstralWepType.TRIDENT },
    { weaponType = PSTAstralWepType.SCYTHE },
    { weaponType = PSTAstralWepType.AXE },
    { weaponType = PSTAstralWepType.GREATAXE },
    { weaponType = PSTAstralWepType.SHORTBOW },
    { weaponType = PSTAstralWepType.BOW },
    { weaponType = PSTAstralWepType.CROSSBOW },
    { weaponRarity = PSTAstralWepRarity.NORMAL },
    { weaponRarity = PSTAstralWepRarity.MAGIC },
    { weaponRarity = PSTAstralWepRarity.ANCIENT }
}
local wepRarityStr = {"Normal", "Magic", "Ancient"}

---@param tScreen PST.treeScreen
function astralForgeScreen:Render(tScreen)
    local baseDrawX = self.camCenterX - self.camera.X
    local baseDrawY = self.camCenterY - self.camera.Y

    -- Draw inventory
    local tmpX = baseDrawX - 200
    local tmpY = baseDrawY - 80
    self:DrawUIBox(tmpX, tmpY, 170, 182)
    PST.miniFont:DrawString("Weapon Inventory", tmpX + 3, tmpY, KColor(1, 0.7, 0.3, 1))
    tmpY = tmpY + 17

    -- Inventory filter buttons
    for i, tmpFilter in ipairs(invFilters) do
        local filterX = tmpX + 3 + 18 * ((i - 1) % 8)
        local filterY = tmpY + 18 * math.floor((i - 1) / 8)

        if tmpFilter.weaponType ~= nil and PST:arrHasValue(self.appliedFilters.weaponType, tmpFilter.weaponType) or
        tmpFilter.weaponRarity ~= nil and PST:arrHasValue(self.appliedFilters.weaponRarity, tmpFilter.weaponRarity) then
            self.forgeUISprite.Color.RO = 0.4
            self.forgeUISprite.Color.GO = 0.4
            self.forgeUISprite.Color.BO = 0.4
        else
            self.forgeUISprite.Color.RO = 0
            self.forgeUISprite.Color.GO = 0
            self.forgeUISprite.Color.BO = 0
        end

        self.forgeUISprite:SetFrame("Filters", i - 1)
        self.forgeUISprite:Render(Vector(filterX, filterY))

        -- Hovered filter
        if self.camCenterX >= filterX and self.camCenterX <= filterX + 16 and
        self.camCenterY >= filterY and self.camCenterY <= filterY + 16 then
            self.hoveredFilter = tmpFilter
        end
    end
    tmpY = tmpY + math.ceil(#invFilters / 8) * 18 + 3

    -- Weapons
    local drawnWeps = {}
    local hasTypeFilter = #self.appliedFilters.weaponType > 0
    local hasRarityFilter = #self.appliedFilters.weaponRarity > 0
    -- Create filtered list
    if hasTypeFilter or hasRarityFilter then
        for _, tmpWeapon in ipairs(PST.modData.astralWepInventory) do
            if (not hasTypeFilter or (hasTypeFilter and PST:arrHasValue(self.appliedFilters.weaponType, tmpWeapon.type))) and
            (not hasRarityFilter or (hasRarityFilter and PST:arrHasValue(self.appliedFilters.weaponRarity, tmpWeapon.rarity))) then
                table.insert(drawnWeps, tmpWeapon)
            end
        end
    else
        drawnWeps = PST.modData.astralWepInventory
    end
    -- Draw weapons
    for i, tmpWeapon in ipairs(drawnWeps) do
        local wepX = tmpX + 18 + 34 * ((i - 1) % 5)
        local wepY = tmpY + 16 + 34 * math.floor((i - 1) / 5)
        PST:renderAstralWepAt(tmpWeapon, self.weaponSprite, wepX, wepY)

        -- Hovered weapon
        if self.camCenterX >= wepX - 16 and self.camCenterX <= wepX + 16 and
        self.camCenterY >= wepY - 16 and self.camCenterY <= wepY + 16 then
            self.hoveredWeapon = tmpWeapon
        end
    end

    -- Cursor
    if self.hoveredWeapon or self.hoveredFilter then
        tScreen.cursorSprite:Play("Clicked", true)
    else
        tScreen.cursorSprite:Play("Idle", true)
    end
    tScreen.cursorSprite:Render(Vector(tScreen.screenW / 2, tScreen.screenH / 2))

    -- Hovered filter description
    if self.hoveredFilter then
        local hoverStr = "Filter: "
        if self.hoveredFilter.weaponType then
            hoverStr = hoverStr .. PST.astralWepData[self.hoveredFilter.weaponType].name .. "s"
        elseif self.hoveredFilter.weaponRarity then
            hoverStr = hoverStr .. wepRarityStr[self.hoveredFilter.weaponRarity + 1]
        end
        tScreen:DrawNodeBox(hoverStr, {"Press the Allocate button to apply this filter."})
    -- Hovered weapon description
    elseif self.hoveredWeapon then
        local wepDesc = PST:getAstralWepDesc(self.hoveredWeapon, PST:isKeybindActive(PSTKeybind.PAN_FASTER, true))
        tScreen:DrawNodeBox("Astral Weapon", wepDesc)
    end
end

return astralForgeScreen