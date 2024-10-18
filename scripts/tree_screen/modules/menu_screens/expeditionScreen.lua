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
        PSTKeybind.CENTER_CAMERA, PSTKeybind.ZOOM_IN, PSTKeybind.ZOOM_OUT, PSTKeybind.PAN_FASTER
    },

    -- Currently hovered node data
    ---@type PSTExpNode|nil
    hoveredNode = nil,

    tabs = {
        "Expedition",
        "Effects"
    },
    currentTab = "Expedition",
    currentDepth = 1,
}

-- Init
expeditionScreen.BGSprite:Play("Pixel", true)
expeditionScreen.expLinkSprite:Play("Idle", true)
expeditionScreen.itemRewardSprite:Play("ShopIdle", true)

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
    self.currentTab = "Expedition"
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

local expNodeRewardFrame = {
    [PSTExpNodeRewardType.EXP] = 0,
    [PSTExpNodeRewardType.OBOLS] = 1,
    [PSTExpNodeRewardType.BOON] = 2,
    [PSTExpNodeRewardType.ATTEMPTS] = 3
}

local nodeSpacing = Vector(80, 60)
---@param tScreen PST.treeScreen
function expeditionScreen:Render(tScreen)
    local expData = PST.modData.expeditionsData[self.currentDepth]
    if expData then
        -- Drawing position func
        local function PST_getNodePos(col, colTotal, row)
            local xPos = self.camCenterX + (col - 1) * nodeSpacing.X - self.camera.X - self.camZoomOffset.X
            local yPos = self.camCenterY - self.camera.Y - (colTotal + 1) * (nodeSpacing.Y / 2) + row * nodeSpacing.Y - self.camZoomOffset.Y
            return Vector(xPos, yPos) * self.zoomScale
        end

        -- Draw links
        for i, tmpColumn in ipairs(expData.nodes) do
            local nextColumn = expData.nodes[i + 1]
            if nextColumn then
                for j, tmpNode in ipairs(tmpColumn) do
                    if #tmpNode.connections > 0 then
                        for _, targetNode in ipairs(tmpNode.connections) do
                            local linkBeam = Beam(self.expLinkSprite, 0, false, false)
                            local startPos = PST_getNodePos(i, #tmpColumn, j)
                            local endPos = PST_getNodePos(i + 1, #nextColumn, targetNode)
                            local dist = math.ceil(startPos:Distance(endPos))
                            linkBeam:Add(startPos, 0)
                            linkBeam:Add(endPos, math.min(129, dist))
                            linkBeam:Render()
                        end
                    end
                end
            end
        end

        -- Draw nodes
        for i, tmpColumn in ipairs(expData.nodes) do
            for j, tmpNode in ipairs(tmpColumn) do
                local drawPos = PST_getNodePos(i, #tmpColumn, j)
                self.expNodeSprite:SetFrame("Nodes", tmpNode.nodeType)
                self.expNodeSprite:Render(drawPos)

                if tmpNode.rewardType ~= PSTExpNodeRewardType.ITEM then
                    if expNodeRewardFrame[tmpNode.rewardType] ~= nil then
                        self.expNodeSprite:SetFrame("Icons", expNodeRewardFrame[tmpNode.rewardType])
                        self.expNodeSprite:Render(drawPos - Vector.One)
                    end
                elseif tmpNode.rewardData then
                    local itemCfg = Isaac.GetItemConfig():GetCollectible(tmpNode.rewardData)
                    if itemCfg then
                        self.itemRewardSprite:ReplaceSpritesheet(1, itemCfg.GfxFileName, true)
                        self.itemRewardSprite:Render(drawPos - Vector(1, -8))
                    end
                end

                -- Hovered node
                local nodeHalf = 16 * tScreen.zoomScale
                if self.camCenterX >= drawPos.X - nodeHalf and self.camCenterX <= drawPos.X + nodeHalf and
                self.camCenterY >= drawPos.Y - nodeHalf and self.camCenterY <= drawPos.Y + nodeHalf then
                    self.hoveredNode = tmpNode
                end
            end
        end

        -- Cursor
        if self.hoveredNode ~= nil then
            tScreen.cursorSprite:Play("Clicked", true)
        else
            tScreen.cursorSprite:Play("Idle", true)
        end
        tScreen.cursorSprite:Render(Vector(tScreen.screenW / 2, tScreen.screenH / 2))

        -- Hovered node description
        if self.hoveredNode ~= nil then
            local nodeName = "Expedition Node"
            local nodeDesc = {}
            if self.hoveredNode.nodeType == PSTExpNodeType.ASTROLABE then
                nodeName = "Arcane Astrolabe"
                nodeDesc = {"Expedition Depth: " .. tostring(self.currentDepth)}
            else
                nodeDesc = PST:getExpNodeDescription(self.hoveredNode, self.currentDepth)
            end
            tScreen:DrawNodeBox(nodeName, nodeDesc, tScreen.screenW, tScreen.screenH)
        end
    end
end

return expeditionScreen