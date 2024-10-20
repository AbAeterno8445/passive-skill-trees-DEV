-- Hack to provide VSCode autocomplete functionality on modules (wtf?)
local moduleRequire = require
moduleRequire = include

local expeditionScreen = {
    BGSprite = Sprite("gfx/ui/skilltrees/tree_bg.anm2", true),
    expNodeSprite = Sprite("gfx/ui/skilltrees/nodes/expedition_nodes.anm2", true),
    expLinkSprite = Sprite("gfx/ui/skilltrees/nodes/expedition_node_link.anm2", true),
    itemRewardSprite = Sprite("gfx/005.100_collectible.anm2", true),

    boonSprite = Sprite("gfx/ui/skilltrees/nodes/expedition_boons.anm2", true),

    -- Camera control
    camera = Vector.Zero,
    cameraSpeed = 3,
    camZoomOffset = Vector.Zero,
    zoomScale = 1,
    camCenterX = Isaac.GetScreenWidth() / 2,
    camCenterY = Isaac.GetScreenHeight() / 2,

    inputOverrides = {
        PSTKeybind.TREE_PAN_DOWN, PSTKeybind.TREE_PAN_LEFT, PSTKeybind.TREE_PAN_RIGHT, PSTKeybind.TREE_PAN_UP,
        PSTKeybind.CENTER_CAMERA, PSTKeybind.ZOOM_IN, PSTKeybind.ZOOM_OUT, PSTKeybind.PAN_FASTER, PSTKeybind.TREE_TAB,
        PSTKeybind.ALLOCATE_NODE, PSTKeybind.RESPEC_NODE, PSTKeybind.SWITCH_TREE
    },

    -- Currently hovered node data
    ---@type PSTExpNode|nil
    hoveredNode = nil,

    ---@type number|nil
    hoveredBoon = nil,
    ---@type number|nil
    hoveredCurse = nil,
    ---@type number|nil
    hoveredItem = nil,

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

    if PST.modData.expeditionsData[self.currentDepth] == nil then
        PST:resetExpedition(self.currentDepth)
    end
    PST:updateExpedAccess(self.currentDepth)
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

    -- Input: Allocate
    if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
        local expData = PST.modData.expeditionsData[self.currentDepth]
        if expData then
            -- Hovered node, attempt to select
            if self.hoveredNode then
                if self.hoveredNode.selectable and (not expData.selectedNode or (expData.selectedNode and
                (expData.selectedNode.col ~= self.hoveredNode.col or expData.selectedNode.row ~= self.hoveredNode.row)) and
                PST.modData.skillPoints >= 1 and PST.modData.respecPoints >= 5) then
                    if expData.selectedNode then
                        PST.modData.skillPoints = PST.modData.skillPoints - 1
                        PST.modData.respecPoints = PST.modData.respecPoints - 5
                    end
                    expData.selectedNode = {
                        col = self.hoveredNode.col,
                        row = self.hoveredNode.row,
                        objProgress = 0
                    }
                    SFXManager():Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 0.7)
                end
            -- Hovered boon, attempt to upgrade
            elseif self.hoveredBoon then
                local boonData = PST.expeditionBoons[self.hoveredBoon]
                local isUpgraded = PST:arrHasValue(expData.upgradedBoons, self.hoveredBoon)
                if boonData and not isUpgraded and expData.boonUpgradePoints >= 1 then
                    PST:expedAddBoon(self.currentDepth, self.hoveredBoon)
                    SFXManager():Play(SoundEffect.SOUND_THUMBSUP, 0.8)
                    expData.boonUpgradePoints = expData.boonUpgradePoints - 1
                end
            end
        end
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
    if not expData then
        return
    end

    -- Expedition tab
    if self.currentTab == 1 then
        expedScreenMainTab(expData, self, tScreen)
    -- Effects tab
    elseif self.currentTab == 2 then
        expedScreenEffectTab(expData, self, tScreen)
    end

    -- Cursor
    if self.hoveredNode or self.hoveredBoon or self.hoveredCurse or self.hoveredItem then
        tScreen.cursorSprite:Play("Clicked", true)
    else
        tScreen.cursorSprite:Play("Idle", true)
    end
    tScreen.cursorSprite:Render(Vector(tScreen.screenW / 2, tScreen.screenH / 2))

    -- Hovered node description
    if self.hoveredNode then
        local nodeName = "Expedition Node"
        local nodeDesc = {}
        if self.hoveredNode.nodeType == PSTExpNodeType.ASTROLABE then
            nodeName = "Arcane Astrolabe"
            nodeDesc = {"Expedition Depth: " .. tostring(self.currentDepth)}
        else
            nodeDesc = PST:getExpNodeDescription(self.hoveredNode, expData)
        end
        if expData.selectedNode then
            if expData.selectedNode.col == self.hoveredNode.col and expData.selectedNode.row == self.hoveredNode.row then
                nodeName = nodeName .. " (Selected)"
            elseif self.hoveredNode.selectable then
                table.insert(nodeDesc, "Press the Allocate button to switch selected node to this one.")
                table.insert(nodeDesc, {"  > Switching node selection costs 1 global SP and 5 respec points.", KColor(1, 0.7, 0.7, 1)})
            end
        elseif self.hoveredNode.selectable then
            table.insert(nodeDesc, "Press the Allocate button to select this node.")
            table.insert(nodeDesc, {"  > Switching the selection to a different node will cost 1 global SP and 5 respec points.", KColor(1, 0.7, 0.7, 1)})
        end
        tScreen:DrawNodeBox(nodeName, nodeDesc)

    -- Hovered boon description
    elseif self.hoveredBoon then
        local tmpColor = KColor(0.7, 1, 0.7, 1)
        local boonData = PST.expeditionBoons[self.hoveredBoon]
        local boonName = "Boon of " .. boonData.name
        local isUpgraded = PST:arrHasValue(expData.upgradedBoons, self.hoveredBoon)
        if isUpgraded then boonName = boonName .. " (Upgraded)" end
        local boonDesc = {}

        -- Target description/mods based on upgrade status
        local targetDesc = boonData.description
        if isUpgraded and boonData.upgradedDescription then
            targetDesc = boonData.upgradedDescription
        end
        local targetMods = boonData.mods
        if isUpgraded then targetMods = boonData.upgradedMods end

        if type(targetDesc) == "table" then
            for _, tmpLine in ipairs(targetDesc) do
                table.insert(boonDesc, {PST:formatString(tmpLine, targetMods), tmpColor})
            end
        else
            table.insert(boonDesc, {PST:formatString(targetDesc, targetMods), tmpColor})
        end
        -- Upgrade available text
        if not isUpgraded and boonData.upgradedMods then
            local upgColor = KColor(0.4, 1, 0.4, 1)
            table.insert(boonDesc, {"+ Upgrade available:", upgColor})

            local upgDesc = boonData.upgradedDescription
            if not upgDesc then upgDesc = boonData.description end
            if type(upgDesc) == "table" then
                for _, tmpLine in ipairs(upgDesc) do
                    local tmpFormat = PST:formatString(tmpLine, boonData.upgradedMods)
                    table.insert(boonDesc, {"   " .. tmpFormat, upgColor})
                end
            else
                local tmpFormat = PST:formatString(upgDesc, boonData.upgradedMods)
                table.insert(boonDesc, {"   " .. tmpFormat, upgColor})
            end
            table.insert(boonDesc, {"Press the Allocate button to upgrade this boon.", upgColor})
            table.insert(boonDesc, {"Requires 1 boon upgrade point.", upgColor})
        end

        tScreen:DrawNodeBox(boonName, boonDesc)

    -- Hovered curse description
    elseif self.hoveredCurse then
        local tmpColor = KColor(1, 0.7, 0.7, 1)
        local curseData = PST.expeditionCurses[self.hoveredCurse]
        local curseName = "Curse of " .. curseData.name
        local curseMods = curseData.modsFunc(expData.depth)
        local curseDesc = {}

        if type(curseData.description) == "table" then
            for _, tmpLine in ipairs(curseData.description) do
                table.insert(curseDesc, {PST:formatString(tmpLine, curseMods), tmpColor})
            end
        else
            table.insert(curseDesc, {PST:formatString(curseData.description, curseMods), tmpColor})
        end

        tScreen:DrawNodeBox(curseName, curseDesc)

    -- Hovered item description
    elseif self.hoveredItem then
        local tmpColor = KColor(0.85, 0.55, 1, 1)
        local itemCfg = Isaac.GetItemConfig():GetCollectible(self.hoveredItem)
        if itemCfg then
            local itemDesc = {}
            local itemName = Isaac.GetLocalizedString("Items", itemCfg.Name, "en")
			if itemName ~= "StringTable::InvalidKey" then
				table.insert(itemDesc, {"Start with " .. itemName .. " in this expedition's runs", tmpColor})
			end
            tScreen:DrawNodeBox(itemName, itemDesc)
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

    -- HUD: resources
    local tmpX = 12
    local tmpY = tabH + 2
    -- Global SP
    PST.miniFont:DrawString("Global SP: " .. tostring(PST.modData.skillPoints), tmpX, tmpY, KColor(0.7, 0.7, 1, 1))
    tmpY = tmpY + 14
    -- Respecs
    PST.miniFont:DrawString("Respecs: " .. tostring(PST.modData.respecPoints), tmpX, tmpY, KColor(1, 1, 1, 1))
    tmpY = tmpY + 14
    -- Arcane Obols
    PST.miniFont:DrawString("Arcane Obols: " .. tostring(PST.modData.arcaneObols), tmpX, tmpY, KColor(0.8, 0.35, 1, 1))
end

return expeditionScreen