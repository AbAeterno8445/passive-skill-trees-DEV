-- Hack to provide VSCode autocomplete functionality on modules (wtf?)
local moduleRequire = require
moduleRequire = include

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

    -- For deconstruction
    deconMode = false,
    deconHovered = false,
    deconTimer = 0,

    -- Forge actions
    ---@type table|nil
    hoveredForgeButton = nil,
    imprintMode = false,

    -- Inventory filters
    ---@type table|nil
    hoveredFilter = nil,
    appliedFilters = {
        weaponType = {},
        weaponRarity = {}
    },

    -- Inventory pagination
    rowsPerPage = 6,
    invPage = 1,
}

-- Init
astralForgeScreen.BGSprite:Play("Pixel", true)
astralForgeScreen.UILinkSprite:SetFrame("AstralForgeUI", 1)
astralForgeScreen.forgeUISprite:Play("Default", true)

-- Astral Forge rendering func
local astralForgeScreenRender = moduleRequire("scripts.tree_screen.modules.menu_screens.astralForgeRender")

local function PSTDeconstructWeapon(targetWep)
    for i, tmpWeapon in ipairs(PST.modData.astralWepInventory) do
        if tmpWeapon == targetWep then
            local wepMats = PST:getAstralWepDeconMats(targetWep)
            PST.modData.mundaneEssence = PST.modData.mundaneEssence + wepMats.mundane
            PST.modData.sparkEssence = PST.modData.sparkEssence + wepMats.spark
            PST.modData.ancientEssence = PST.modData.ancientEssence + wepMats.ancient
            table.remove(PST.modData.astralWepInventory, i)
            break
        end
    end
end

function astralForgeScreen:CenterCamera()
    self.camera = Vector.Zero
end

function astralForgeScreen:OnClose()
    self.deconMode = false
    self.imprintMode = false
    self.selectedWeapon = nil
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
        -- Hovered decon button, toggle mode
        elseif self.deconHovered then
            self.deconMode = not self.deconMode
            if self.deconMode then self.imprintMode = false end
            SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
        -- Hovered weapon
        elseif self.hoveredWeapon then
            if not self.imprintMode then
                -- Select hovered weapon
                if self.selectedWeapon ~= self.hoveredWeapon then
                    self.selectedWeapon = self.hoveredWeapon
                else
                    self.selectedWeapon = nil
                end
                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
            -- Imprinting mode + magic weapon, attempt imprint
            elseif self.imprintMode then
                if self.selectedWeapon and self.selectedWeapon.rarity == PSTAstralWepRarity.ANCIENT then
                    if self.hoveredWeapon.rarity == PSTAstralWepRarity.MAGIC then
                        local result = PST:astralWepForgeImprint(self.selectedWeapon, self.hoveredWeapon)
                        if result then
                            -- Successful imprint
                            PSTDeconstructWeapon(self.hoveredWeapon)
                            SFXManager():Play(SoundEffect.SOUND_FLASHBACK)
                            SFXManager():Play(SoundEffect.SOUND_DEATH_CARD, 0.8)
                            self.imprintMode = false
                        else
                            SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.8)
                        end
                    else
                        SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.8)
                    end
                else
                    self.imprintMode = false
                end
            end
        -- Hovered forge action
        elseif self.hoveredForgeButton and self.selectedWeapon then
            local forgeCosts = PST:getAstralWepCraftCosts(self.selectedWeapon)[self.hoveredForgeButton.targetAction]

            if self.hoveredForgeButton.targetAction ~= "imprinting" then
                local canAfford = true
                for matName, matCost in pairs(forgeCosts) do
                    if not PST.modData[matName] or (PST.modData[matName] and PST.modData[matName] < matCost) then
                        canAfford = false
                        break
                    end
                end
                if canAfford or PST.debugOptions.freeForging then
                    local result = self.hoveredForgeButton.actionFunc(PST, self.selectedWeapon)
                    if result ~= false then
                        -- Successful craft
                        if self.hoveredForgeButton.soundFunc then self.hoveredForgeButton.soundFunc() end
                        if not PST.debugOptions.freeForging then
                            for matName, matCost in pairs(forgeCosts) do
                                PST.modData[matName] = PST.modData[matName] - matCost
                            end
                        end
                    else
                        SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.8)
                    end
                else
                    SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.8)
                end
            else
                -- Imprint mode toggle
                self.imprintMode = not self.imprintMode
                if self.imprintMode then self.deconMode = false end
                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
            end
        end
    end

    -- Input: Shift + Allocate
    if PST:isKeybindActive(PSTKeybind.SHIFT_ALLOCATE_NODE) then
        -- Equip hovered weapon
        if self.hoveredWeapon then
            PST:equipAstralWep(self.hoveredWeapon)
            SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
        end
    end

    -- Input: Respec (hold)
    if PST:isKeybindActive(PSTKeybind.RESPEC_NODE, true) then
        -- Ancient weapon deconstruction
        if self.deconMode and self.hoveredWeapon and self.hoveredWeapon.rarity == PSTAstralWepRarity.ANCIENT then
            self.deconTimer = self.deconTimer + 1
            if self.deconTimer == 60 then
                if not self.hoveredWeapon.equipped then
                    SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE)
                    if self.selectedWeapon == self.hoveredWeapon then
                        self.selectedWeapon = nil
                    end
                    PSTDeconstructWeapon(self.hoveredWeapon)
                else
                    SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN)
                end
                self.deconTimer = 0
            end
        else
            self.deconTimer = 0
        end

        -- Input: Respec (once)
        if PST:isKeybindActive(PSTKeybind.RESPEC_NODE) then
            -- Deconstruct weapon
            if self.deconMode and self.hoveredWeapon and self.hoveredWeapon.rarity ~= PSTAstralWepRarity.ANCIENT then
                if not self.hoveredWeapon.equipped then
                    SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE)
                    if self.selectedWeapon == self.hoveredWeapon then
                        self.selectedWeapon = nil
                    end
                    PSTDeconstructWeapon(self.hoveredWeapon)
                else
                    SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN)
                end
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
    tScreen.hideHUD = true
    tScreen.hideNodes = true
    self.hoveredWeapon = nil
    self.hoveredFilter = nil
    self.hoveredForgeButton = nil

    self.camCenterX = Isaac.GetScreenWidth() / 2
    self.camCenterY = Isaac.GetScreenHeight() / 2
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

---@param tScreen PST.treeScreen
function astralForgeScreen:Render(tScreen)
    astralForgeScreenRender(self, tScreen)
end

return astralForgeScreen