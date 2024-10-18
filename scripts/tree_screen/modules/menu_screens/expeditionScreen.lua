-- Hack to provide VSCode autocomplete functionality on modules (wtf?)
local moduleRequire = require
moduleRequire = include

local expeditionScreen = {
    BGSprite = Sprite("gfx/ui/skilltrees/tree_bg.anm2", true),
    expNodeSprite = Sprite("gfx/ui/skilltrees/nodes/expedition_nodes.anm2", true),
    expLinkSprite = Sprite("gfx/ui/skilltrees/nodes/expedition_node_link.anm2", true),
    itemRewardSprite = Sprite("gfx/005.100_collectible.anm2", true),

    -- Camera control
    camera = Vector.Zero,
    cameraSpeed = 3,
    camZoomOffset = Vector.Zero,
    zoomScale = 1,
    camCenterX = Isaac.GetScreenWidth() / 2,
    camCenterY = Isaac.GetScreenHeight() / 2,

    inputOverrides = {
        PSTKeybind.TREE_PAN_DOWN, PSTKeybind.TREE_PAN_LEFT, PSTKeybind.TREE_PAN_RIGHT, PSTKeybind.TREE_PAN_UP,
        PSTKeybind.CENTER_CAMERA, PSTKeybind.ZOOM_IN, PSTKeybind.ZOOM_OUT, PSTKeybind.PAN_FASTER, PSTKeybind.TREE_TAB
    },

    -- Currently hovered node data
    ---@type PSTExpNode|nil
    hoveredNode = nil,

    tabs = {
        "Expedition",
        "Effects"
    },
    currentTab = 1,
    currentDepth = 1,
}

-- Init
expeditionScreen.BGSprite:Play("Pixel", true)
expeditionScreen.expLinkSprite:Play("Idle", true)
expeditionScreen.itemRewardSprite:Play("ShopIdle", true)

-- Tab rendering funcs
local expedScreenMainTab = moduleRequire("scripts.tree_screen.modules.menu_screens.expedScreenMainTab")
local expedScreenEffectTab = moduleRequire("scripts.tree_screen.modules.menu_screens.expedScreenEffectTab")

-- Camera funcs
function expeditionScreen:UpdateCamZoomOffset()
    local translateX = -self.camCenterX - self.camera.X
    local translateY = -self.camCenterY - self.camera.Y
    self.camZoomOffset.X = translateX - translateX * self.zoomScale
    self.camZoomOffset.Y = translateY - translateY * self.zoomScale

    if self.expNodeSprite.Scale.X ~= self.zoomScale then
        self.expNodeSprite.Scale = Vector(self.zoomScale, self.zoomScale)
    end
    if self.expLinkSprite.Scale.X ~= self.zoomScale then
        self.expLinkSprite.Scale = Vector(self.zoomScale, self.zoomScale)
    end
    if self.itemRewardSprite.Scale.X ~= self.zoomScale then
        self.itemRewardSprite.Scale = Vector(self.zoomScale, self.zoomScale)
    end
end
function expeditionScreen:CenterCamera()
    self.camera = Vector.Zero
    self.camZoomOffset.X = 0
    self.camZoomOffset.Y = 0
end

function expeditionScreen:OnOpen(openData)
    self.currentTab = 1
end

-- Input processing
function expeditionScreen:OnInput()
    -- Input: Faster panning
    if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
        self.cameraSpeed = 8 * (1 + 1 - self.zoomScale ^ 6)
    else
        self.cameraSpeed = 3 * (1 + 1 - self.zoomScale ^ 6)
    end
    -- Input: Directional keys/buttons
    if PST:isKeybindActive(PSTKeybind.TREE_PAN_UP, true) then
        -- UP
        if self.camera.Y > -2000 then
            self.camera.Y = self.camera.Y - self.cameraSpeed
            self:UpdateCamZoomOffset()
        end
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_DOWN, true) then
        -- DOWN
        if self.camera.Y < 2000 then
            self.camera.Y = self.camera.Y + self.cameraSpeed
            self:UpdateCamZoomOffset()
        end
    end
    if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT, true) then
        -- LEFT
        if self.camera.X > -2000 then
            self.camera.X = self.camera.X - self.cameraSpeed
            self:UpdateCamZoomOffset()
        end
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT, true) then
        -- RIGHT
        if self.camera.X < 2000 then
            self.camera.X = self.camera.X + self.cameraSpeed
            self:UpdateCamZoomOffset()
        end
    end

    -- Input: Change tab
    if PST:isKeybindActive(PSTKeybind.TREE_TAB) then
        self.currentTab = self.currentTab + 1
        if self.currentTab > #self.tabs then self.currentTab = 1 end
        self:CenterCamera()
        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.7)
    end

    if Isaac.GetFrameCount() % 2 == 0 then
        -- Input: Zoom in
        if PST:isKeybindActive(PSTKeybind.ZOOM_IN, true) and self.zoomScale < 1 then
            self.zoomScale = self.zoomScale + 0.1
            self:UpdateCamZoomOffset()
        -- Input: Zoom out
        elseif PST:isKeybindActive(PSTKeybind.ZOOM_OUT, true) and self.zoomScale > 0.6 then
            self.zoomScale = self.zoomScale - 0.1
            self:UpdateCamZoomOffset()
        end
    end

    -- Input: Center camera
    if PST:isKeybindActive(PSTKeybind.CENTER_CAMERA) then
        self:CenterCamera()
    end
end

---@param tScreen PST.treeScreen
function expeditionScreen:Update(tScreen)
    tScreen.hideHUD = true
    tScreen.hideNodes = true

    self.hoveredNode = nil

    if PST.modData.expeditionsData[self.currentDepth] == nil then
        PST:resetExpedition(self.currentDepth)
    end
end

---@param tScreen PST.treeScreen
function expeditionScreen:Render(tScreen)
    local expData = PST.modData.expeditionsData[self.currentDepth]
    if expData then
        -- Expedition tab
        if self.currentTab == 1 then
            expedScreenMainTab(expData, self, tScreen)
        -- Effects tab
        elseif self.currentTab == 2 then
            expedScreenEffectTab(expData, self, tScreen)
        end
    end

    -- HUD: Tabs
    local tabW, tabH = 50, 20
    self.BGSprite.Scale = Vector(tabW, tabH)
    for i, tmpTab in ipairs(self.tabs) do
        local drawX = tScreen.screenW / 2 - (#self.tabs * tabW) / 2 + ((i - 1) * tabW)

        local tmpColor = KColor(1, 1, 1, 1)
        local tmpBGColor = Color(1, 1, 1, 1, 0.1, 0.1, 0.1)
        if i == self.currentTab then
            tmpColor = KColor(0.5, 0.75, 1, 1)
            tmpBGColor = Color(1, 1, 1, 1, 0.1, 0.45, 0.6)
        end
        self.BGSprite.Color = tmpBGColor
        self.BGSprite:Render(Vector(drawX, 0))

        PST.miniFont:DrawString(tmpTab, drawX, 2, tmpColor, tabW, true)
    end
end

return expeditionScreen