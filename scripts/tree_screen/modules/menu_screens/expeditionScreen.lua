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
        PSTKeybind.ALLOCATE_NODE, PSTKeybind.RESPEC_NODE, PSTKeybind.SWITCH_TREE,
        PSTKeybind.NUM1, PSTKeybind.NUM2, PSTKeybind.NUM3
    },

    resetTimer = 0,

    -- Currently hovered node data
    ---@type PSTExpNode|nil
    hoveredNode = nil,

    ---@type number|nil
    hoveredBoon = nil,
    ---@type number|nil
    hoveredCurse = nil,
    ---@type number|nil
    hoveredItem = nil,
    ---@type number|nil
    hoveredDepth = nil,

    -- Uber expeditions
    hoveredUberToggle = false,
    hoveredUberInfo = false,
    uberMode = false,

    tabs = {
        PST:getLocalized("ui_expedition"),
        PST:getLocalized("ui_effects"),
        PST:getLocalized("ui_depth")
    },
    currentTab = 1,
    currentDepth = 1,
}

-- Init
expeditionScreen.BGSprite:Play("Pixel", true)
expeditionScreen.expLinkSprite:Play("Idle", true)
expeditionScreen.itemRewardSprite:Play("ShopIdle", true)

-- Tab rendering funcs
local expedScreenMainTab = include("scripts.tree_screen.modules.menu_screens.expedScreenMainTab")
local expedScreenEffectTab = include("scripts.tree_screen.modules.menu_screens.expedScreenEffectTab")
local expedScreenDepthTab = include("scripts.tree_screen.modules.menu_screens.expedScreenDepthTab")

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

    self.uberMode = PST.modData.expedUberMode or false

    if not self.uberMode and PST.modData.expedLastDepth ~= self.currentDepth then
        self.currentDepth = PST.modData.expedLastDepth
    elseif self.uberMode and PST.modData.uberExpedLastDepth ~= self.currentDepth then
        self.currentDepth = PST.modData.uberExpedLastDepth
    end

    -- Make sure selected character has arcane obols defined
    local currentChar = PST:getCurrentCharData()
    if currentChar and not currentChar.arcaneObols then
        currentChar.arcaneObols = 0
    end

    if PST:getExpedData(self.currentDepth, self.uberMode) == nil then
        PST:resetExpedition(self.currentDepth, self.uberMode)
        PST.treeScreen.treeHasChanges = true
    end
    PST:updateExpedAccess(self.currentDepth, self.uberMode)
end

function expeditionScreen:OnSwitchTab()
    self:CenterCamera()
    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.7)
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
        self:OnSwitchTab()
    end

    -- Input: Nums (for tab switching)
    for i=1,#self.tabs do
        if PST:isKeybindActive(PSTKeybind["NUM" .. tostring(i)]) then
            self.currentTab = i
            self:OnSwitchTab()
            break
        end
    end

    -- Input: Allocate
    if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
        local expData = PST:getExpedData(self.currentDepth, self.uberMode)
        if expData then
            -- Hovered node
            if self.hoveredNode then
                -- Attempt to complete if pending
                if (expData.selectedNode and self.hoveredNode.col == expData.selectedNode.col and self.hoveredNode.row == expData.selectedNode.row and
                PST:expedNodeIsObjectiveDone(self.currentDepth, self.hoveredNode, self.uberMode)) or
                self.hoveredNode.nodeType == PSTExpNodeType.REWARD then
                    -- Final node: center camera since expedition resets
                    if (self.hoveredNode.nodeType == PSTExpNodeType.FINAL and self.hoveredNode.rewardType ~= PSTExpNodeRewardType.UBER_CHOICE) or
                    (self.hoveredNode.nodeType == PSTExpNodeType.REWARD and not expData.nodes[self.hoveredNode.col + 1]) then
                        self:CenterCamera()
                        SFXManager():Play(SoundEffect.SOUND_LAZARUS_FLIP_ALIVE)
                    end
                    PST:completeExpedNode(self.currentDepth, self.hoveredNode.col, self.hoveredNode.row, true, expData.uber)
                    SFXManager():Play(SoundEffect.SOUND_THUMBSUP, 0.9)
                    PST.treeScreen.treeHasChanges = true
                -- Attempt to select selectable node
                elseif self.hoveredNode.selectable and (not expData.selectedNode or (expData.selectedNode and
                (expData.selectedNode.col ~= self.hoveredNode.col or expData.selectedNode.row ~= self.hoveredNode.row))) then
                    -- Switching selection costs
                    local charData = PST:getCurrentCharData()
                    local switchCosts = PST:getExpedNodeSwitchCost(self.currentDepth, self.uberMode)
                    if not expData.selectedNode or PST.debugOptions.infSP or (PST.modData.skillPoints >= (switchCosts.sp or 0) and PST.modData.respecPoints >= (switchCosts.respecs or 0) and
                    (not switchCosts.obols or (switchCosts.obols and charData and charData.arcaneObols >= switchCosts.obols))) then
                        if expData.selectedNode then
                            if not PST.debugOptions.infSP then
                                PST.modData.skillPoints = PST.modData.skillPoints - (switchCosts.sp or 0)
                                PST.modData.respecPoints = PST.modData.respecPoints - (switchCosts.respecs or 0)
                                if charData and switchCosts.obols then
                                    charData.arcaneObols = charData.arcaneObols - switchCosts.obols
                                end
                            end

                            -- Remove other node's curse if present
                            local selNode = expData.nodes[expData.selectedNode.col][expData.selectedNode.row]
                            if selNode and selNode.curse and selNode.curse > 0 then
                                PST:expedRemoveCurse(self.currentDepth, selNode.curse, self.uberMode)
                            end
                        end
                        PST:expedSelectNode(self.currentDepth, self.hoveredNode.col, self.hoveredNode.row, self.uberMode)
                        SFXManager():Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 0.7)

                        expData.nodeQueue = nil
                        PST:updateExpedAccess(self.currentDepth, self.uberMode)
                        PST.treeScreen.treeHasChanges = true
                    end
                -- Attempt to queue queuable node
                elseif self.hoveredNode.queuable then
                    if not expData.nodeQueue then expData.nodeQueue = {} end
                    table.insert(expData.nodeQueue, {self.hoveredNode.col, self.hoveredNode.row})
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                    PST:updateExpedAccess(self.currentDepth, self.uberMode)
                    PST.treeScreen.treeHasChanges = true
                else
                    -- Attempt to remove queued (and following) nodes
                    if expData.nodeQueue then
                        local queueIdx
                        for i, queuePos in ipairs(expData.nodeQueue) do
                            if queuePos[1] == self.hoveredNode.col and queuePos[2] == self.hoveredNode.row then
                                queueIdx = i
                                break
                            end
                        end
                        if queueIdx then
                            for i = #expData.nodeQueue, queueIdx, -1 do
                                table.remove(expData.nodeQueue, i)
                            end
                            SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                            PST:updateExpedAccess(self.currentDepth, self.uberMode)
                            PST.treeScreen.treeHasChanges = true
                        end
                    end
                end
            -- Hovered boon, attempt to upgrade
            elseif self.hoveredBoon then
                local boonData = PST.expeditionBoons[self.hoveredBoon]
                local isUpgraded = PST:arrHasValue(expData.upgradedBoons, self.hoveredBoon)
                if boonData and not isUpgraded and expData.boonUpgradePoints >= 1 then
                    PST:expedAddBoon(self.currentDepth, self.hoveredBoon)
                    SFXManager():Play(SoundEffect.SOUND_THUMBSUP, 0.8)
                    expData.boonUpgradePoints = expData.boonUpgradePoints - 1
                    PST.treeScreen.treeHasChanges = true
                end
            -- Hovered depth, attempt to switch to it
            elseif self.hoveredDepth then
                if self.hoveredDepth ~= self.currentDepth then
                    local lastDepth = PST.modData.expeditionDepth
                    if self.uberMode then
                        lastDepth = PST.modData.uberExpedDepth
                    end
                    if self.hoveredDepth <= lastDepth then
                        if not PST:getExpedData(self.hoveredDepth, self.uberMode) then
                            PST:resetExpedition(self.hoveredDepth, self.uberMode)
                        end
                        self.currentDepth = self.hoveredDepth
                        if not self.uberMode then
                            PST.modData.expedLastDepth = self.hoveredDepth
                        else
                            PST.modData.uberExpedLastDepth = self.hoveredDepth
                        end
                        SFXManager():Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 0.7)
                        PST.treeScreen.treeHasChanges = true
                    else
                        SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.7)
                    end
                end
            -- Hovered Uber Expedition toggle button, switch uber mode
            elseif self.hoveredUberToggle then
                self.uberMode = not self.uberMode
                PST.modData.expedUberMode = self.uberMode
                if self.uberMode then
                    self.currentDepth = PST.modData.uberExpedLastDepth
                    if not PST:getExpedData(self.currentDepth, self.uberMode) then
                        PST:resetExpedition(self.currentDepth, self.uberMode)
                    end
                    SFXManager():Play(SoundEffect.SOUND_DEATH_CARD, 0.4, 2, false, 1.3)
                    PST.treeScreen.treeHasChanges = true
                else
                    self.currentDepth = PST.modData.expedLastDepth
                end
                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.7)
            end
        end
    end

    -- Input: Respec (hold)
    if PST:isKeybindActive(PSTKeybind.RESPEC_NODE, true) then
        -- Hold Respec on Astrolabe for 3 seconds to reset expedition, if you can afford it
        if self.hoveredNode and self.hoveredNode.nodeType == PSTExpNodeType.ASTROLABE then
            self.resetTimer = self.resetTimer + 1
            if self.resetTimer == 180 then
                local obolCost = PST:getExpedResetObolCost(self.currentDepth, self.uberMode)
                local respecCost = PST:getExpedResetCost(self.currentDepth, self.uberMode)
                local currentChar = PST:getCurrentCharData()
                if currentChar and ((PST.modData.skillPoints >= 1 and PST.modData.respecPoints >= respecCost and currentChar.arcaneObols >= obolCost) or PST.debugOptions.infSP) then
                    if not PST.debugOptions.infSP then
                        PST.modData.skillPoints = PST.modData.skillPoints - 1
                        PST.modData.respecPoints = PST.modData.respecPoints - respecCost
                        currentChar.arcaneObols = currentChar.arcaneObols - obolCost
                    end
                    PST:resetExpedition(self.currentDepth, self.uberMode)
                    SFXManager():Play(SoundEffect.SOUND_LAZARUS_FLIP_ALIVE)
                    PST.treeScreen.treeHasChanges = true
                else
                    SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.7)
                end
                self.resetTimer = 0
            elseif self.resetTimer % 60 == 0 then
                SFXManager():Play(SoundEffect.SOUND_1UP)
            end
        end
    else
        self.resetTimer = 0
    end

    -- Input: Switch tree (enable/disable expeditions)
    if PST:isKeybindActive(PSTKeybind.SWITCH_TREE) then
        PST.modData.expedEnabled = not PST.modData.expedEnabled
        SFXManager():Play(SoundEffect.SOUND_BEEP)
        PST.treeScreen.treeHasChanges = true
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
    self.hoveredBoon = nil
    self.hoveredCurse = nil
    self.hoveredItem = nil
    self.hoveredDepth = nil
    self.hoveredUberToggle = false
    self.hoveredUberInfo = false

    if PST:getExpedData(self.currentDepth, self.uberMode) == nil then
        PST:resetExpedition(self.currentDepth, self.uberMode)
    end

    self.camCenterX = Isaac.GetScreenWidth() / 2
    self.camCenterY = Isaac.GetScreenHeight() / 2

    if not self.uberMode then
        PST.modData.expedSelDepth = self.currentDepth
    else
        PST.modData.uberExpedSelDepth = self.currentDepth
    end
end

---@param tScreen PST.treeScreen
function expeditionScreen:Render(tScreen)
    local expData = PST:getExpedData(self.currentDepth, self.uberMode)
    if not expData then
        return
    end

    -- Expedition tab
    if self.currentTab == 1 then
        expedScreenMainTab(expData, self, tScreen)
    -- Effects tab
    elseif self.currentTab == 2 then
        expedScreenEffectTab(expData, self, tScreen)
    -- Depth tab
    elseif self.currentTab == 3 then
        expedScreenDepthTab(expData, self, tScreen)
    end

    -- Cursor
    if self.hoveredNode or self.hoveredBoon or self.hoveredCurse or self.hoveredItem or self.hoveredDepth or self.hoveredUberToggle or
    self.hoveredUberInfo then
        tScreen.cursorSprite:Play("Clicked", true)
    else
        tScreen.cursorSprite:Play("Idle", true)
    end
    tScreen.cursorSprite:Render(Vector(tScreen.screenW / 2, tScreen.screenH / 2))

    -- Hovered node description
    if self.hoveredNode then
        local nodeName = PST:getLocalized("ui_expNode")
        local isRewardNode = (self.hoveredNode.nodeType == PSTExpNodeType.REWARD)
        if isRewardNode then
            nodeName = PST:getLocalized("ui_rewardNode")
        end

        local isQueued = false
        if expData.nodeQueue then
            for _, queuePos in ipairs(expData.nodeQueue) do
                if queuePos[1] == self.hoveredNode.col and queuePos[2] == self.hoveredNode.row then
                    isQueued = true
                    break
                end
            end
        end

        local nodeDesc = {}
        if self.hoveredNode.nodeType == PSTExpNodeType.ASTROLABE then
            -- Arcane Astrolabe description
            nodeName = PST:getLocalized("node_arcaneastrolabe_name")
            -- Depth
            local uberExtra = ""
            if expData.uber then uberExtra = " (" .. PST:getLocalized("ui_uber") .. ")" end
            table.insert(nodeDesc, PST:getLocalized("ui_expedDepth") .. ": " .. tostring(self.currentDepth) .. uberExtra)
            -- Expedition enabled/disabled
            if PST.modData.expedEnabled then
                local tmpColor = PST.kcolors.GREEN1
                local tmpStr = "Exp. Run ON"
                if not PST:expedMeetsRequirements(self.currentDepth, self.uberMode) then
                    tmpColor = PST.kcolors.RED1
                    tmpStr = tmpStr .. " (Reqs!)"
                end
                table.insert(nodeDesc, {tmpStr, tmpColor})
            else
                table.insert(nodeDesc, {"Exp. Run OFF", PST.kcolors.RED1})
            end
            -- Respec for reset
            local respecCost = PST:getExpedResetCost(self.currentDepth, self.uberMode)
            local obolCost = PST:getExpedResetObolCost(self.currentDepth, self.uberMode)
            table.insert(nodeDesc, PST:getLocalized("ui_expRespecReset"))
            table.insert(nodeDesc, {" > " .. PST:getLocalizedFormatStr("ui_expRespecResetCost", {respecCost = respecCost, obolCost = obolCost}), PST.kcolors.PURPLE1})
        else
            -- Normal expedition node description
            nodeDesc = PST:getExpNodeDescription(self.hoveredNode, expData)
        end
        if self.hoveredNode.queuable then
            table.insert(nodeDesc, {PST:getLocalized("ui_expAllocToQueue"), PST.kcolors.STAR_ORANGE})
        elseif isQueued then
            table.insert(nodeDesc, {PST:getLocalized("ui_expAllocToUnqueue"), PST.kcolors.STAR_ORANGE})
        end
        if not isRewardNode then
            local switchCosts = PST:getExpedNodeSwitchCost(self.currentDepth, self.uberMode)
            local costStr = ""
            local tmpCosts = {}
            if switchCosts.sp then table.insert(tmpCosts, switchCosts.sp .. " " .. PST:getLocalized("ui_globalSP")) end
            if switchCosts.respecs then table.insert(tmpCosts, switchCosts.respecs .. " " .. PST:getLocalized("ui_respecs")) end
            if switchCosts.obols then table.insert(tmpCosts, switchCosts.obols .. " " .. PST:getLocalized("ui_obols")) end
            costStr = table.concat(tmpCosts, ", ") .. "."

            if expData.selectedNode then
                if expData.selectedNode.col == self.hoveredNode.col and expData.selectedNode.row == self.hoveredNode.row then
                    nodeName = nodeName .. " (" .. PST:getLocalized("ui_selected") .. ")"
                    if PST:expedNodeIsObjectiveDone(self.currentDepth, self.hoveredNode, expData.uber) then
                        table.insert(nodeDesc, PST:getLocalized("ui_expAllocToComp"))
                        -- Final node
                        if self.hoveredNode.nodeType == PSTExpNodeType.FINAL then
                            table.insert(nodeDesc, PST:getLocalized("ui_expFinalNodeDesc"))
                        end
                    end
                elseif self.hoveredNode.selectable then
                    table.insert(nodeDesc, PST:getLocalized("ui_expAllocToSwitch"))
                    table.insert(nodeDesc, {"  > " .. PST:getLocalized("ui_expSwitchingCosts") .. " " .. costStr, PST.kcolors.RED2})
                end
            elseif self.hoveredNode.selectable then
                table.insert(nodeDesc, PST:getLocalized("ui_expAllocToSelect"))
                table.insert(nodeDesc, {"  > " .. PST:getLocalized("ui_expSwitchingWillCost") .. " " .. costStr, PST.kcolors.RED2})
            end
        else
            table.insert(nodeDesc, PST:getLocalized("ui_expAllocToClaimReward"))
            if not expData.nodes[self.hoveredNode.col + 1] then
                table.insert(nodeDesc, PST:getLocalized("ui_expResetOnClaim"))
            end
        end
        tScreen:DrawNodeBox(nodeName, nodeDesc)

    -- Hovered boon description
    elseif self.hoveredBoon then
        local tmpColor = PST.kcolors.GREEN2
        local boonData = PST.expeditionBoons[self.hoveredBoon]
        local boonName = PST:getLocalized(boonData.localeID)
        local isUpgraded = PST:arrHasValue(expData.upgradedBoons, self.hoveredBoon)
        if isUpgraded then boonName = boonName .. " (" .. PST:getLocalized("ui_upgraded") .. ")" end
        local boonDesc = {}

        -- Target description/mods based on upgrade status
        local targetDesc = PST:getLocalized(boonData.localeID .. "_desc")
        if isUpgraded and PST:localeIDExists(boonData.localeID .. "_upgdesc") then
            targetDesc = PST:getLocalized(boonData.localeID .. "_upgdesc")
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
            local upgColor = PST.kcolors.DARKGREEN1
            table.insert(boonDesc, {"+ " .. PST:getLocalized("ui_upgAvailable") .. ":", upgColor})

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
            table.insert(boonDesc, {PST:getLocalized("ui_expAllocToUpgBoon"), upgColor})
            table.insert(boonDesc, {PST:getLocalized("ui_expUpgBoonReq"), upgColor})
        end

        tScreen:DrawNodeBox(boonName, boonDesc)

    -- Hovered curse description
    elseif self.hoveredCurse then
        local tmpColor = PST.kcolors.RED2
        local curseData = PST.expeditionCurses[self.hoveredCurse]
        local curseName = PST:getLocalized(curseData.localeID)
        local curseMods = curseData.modsFunc(expData.depth)
        local curseDesc = {}

        local targetDesc = PST:getLocalized(curseData.localeID .. "_desc")
        if targetDesc then
            if type(targetDesc) == "table" then
                for _, tmpLine in ipairs(targetDesc) do
                    table.insert(curseDesc, {PST:formatString(tmpLine, curseMods), tmpColor})
                end
            else
                table.insert(curseDesc, {PST:formatString(targetDesc, curseMods), tmpColor})
            end
        end

        tScreen:DrawNodeBox(curseName, curseDesc)

    -- Hovered item description
    elseif self.hoveredItem then
        local tmpColor = PST.kcolors.EXPED_PURPLE
        local itemCfg = Isaac.GetItemConfig():GetCollectible(self.hoveredItem)
        if itemCfg then
            local itemDesc = {}
            local itemName = Isaac.GetLocalizedString("Items", itemCfg.Name, Options.Language)
			if itemName ~= "StringTable::InvalidKey" then
				table.insert(itemDesc, {PST:getLocalizedFormatStr("ui_expItemStart", {itemName = itemName}), tmpColor})
            else
                itemName = PST:getLocalized("ui_unkItem")
            end
            tScreen:DrawNodeBox(itemName, itemDesc)
        end
    -- Hovered depth description
    elseif self.hoveredDepth then
        local depthDesc = {}
        local tgtExped = PST:getExpedData(self.hoveredDepth, self.uberMode)

        local farthestDepth = PST.modData.expeditionDepth
        if self.uberMode then farthestDepth = PST.modData.uberExpedDepth end

        -- Locked depth
        if self.hoveredDepth > farthestDepth then
            table.insert(depthDesc, PST:getLocalized("ui_expCompPrevDepthUnlock"))
        -- Unvisited depth
        elseif not tgtExped then
            table.insert(depthDesc, PST:getLocalized("ui_expNotVisited"))
        -- Depth info
        elseif self.hoveredDepth <= farthestDepth then
            local compNodes = 0
            for _, tmpCol in ipairs(tgtExped.nodes) do
                for _, tmpNode in ipairs(tmpCol) do
                    if tmpNode.nodeType == PSTExpNodeType.COMPLETED then
                        compNodes = compNodes + 1
                    end
                end
            end
            -- Uber
            if tgtExped.uber then
                table.insert(depthDesc, {"(" .. PST:getLocalized("ui_uber") .. ")", PST.kcolors.RED2})
            end
            -- Attempts
            table.insert(depthDesc, {PST:getLocalized("ui_attempts") .. ": " .. tgtExped.attempts .. "/" .. tgtExped.startAttempts, PST.kcolors.BLUE2})
            -- Completed nodes
            table.insert(depthDesc, {PST:getLocalized("ui_compNodes") .. ": " .. compNodes, PST.kcolors.BLUE2})
            -- Items
            if #tgtExped.items > 0 then
                table.insert(depthDesc, {PST:getLocalized("ui_items") .. ": " .. #tgtExped.items, PST.kcolors.EXPED_PURPLE})
            end
            -- Boons
            if not tgtExped.uber then
                table.insert(depthDesc, {PST:getLocalized("ui_boons") .. ": " .. #tgtExped.boons, PST.kcolors.DARKGREEN1})
            end
            -- Curses
            table.insert(depthDesc, {PST:getLocalized("ui_curses") .. ": " .. #tgtExped.curses, PST.kcolors.RED2})
            if tgtExped.uber then
                -- Order (uber)
                table.insert(depthDesc, {PST:getLocalized("ui_Order") .. ": " .. (tgtExped.order or 0), PST.kcolors.TEAL1})
                -- Entropy (uber)
                table.insert(depthDesc, {PST:getLocalized("ui_Entropy") .. ": " .. (tgtExped.entropy or 0), PST.kcolors.RED1})
            end
        end
        tScreen:DrawNodeBox(PST:getLocalized("ui_depth") .. " " .. self.hoveredDepth, depthDesc)
    -- Hovered uber toggle description
    elseif self.hoveredUberToggle then
        local uberDesc = {
            PST:getLocalized("ui_expAllocToggleUber"),
            PST:getLocalized("ui_expAllocToggleUber2")
        }
        tScreen:DrawNodeBox(PST:getLocalized("ui_uberExpeds"), uberDesc)
    -- Hovered uber info
    elseif self.hoveredUberInfo then
        local uberInfoDesc
        if not PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
            uberInfoDesc = {
                PST:getLocalized("ui_expHoldShiftUberInfo"),
                {PST:getLocalized("ui_Order") .. ": " .. (expData.order or 0), PST.kcolors.TEAL1},
                {PST:getLocalized("ui_Entropy") .. ": " .. (expData.entropy or 0), PST.kcolors.RED1},
            }
            if expData.version == 1 and expData.depth < 5 then
                table.insert(uberInfoDesc, PST:getLocalized("ui_expUberInfo1_v1"))
                table.insert(uberInfoDesc, PST:getLocalized("ui_expUberInfo2_v1"))
            elseif expData.version == 2 and expData.depth < 4 then
                table.insert(uberInfoDesc, PST:getLocalized("ui_expUberInfo_v2"))
            end
            if expData.dsMods and #expData.dsMods > 0 then
                table.insert(uberInfoDesc, {PST:getLocalized("ui_dsdMods"), PST.kcolors.RED2})
                for _, tmpModID in ipairs(expData.dsMods) do
                    local tmpModName = PST.expedDeepSpaceMods[tmpModID]
                    local tmpModDesc = PST.expedDescriptions[tmpModName]
                    if tmpModDesc then
                        table.insert(uberInfoDesc, {"  " .. tmpModDesc, PST.kcolors.RED2})
                    end
                end
            end
        else
            if expData.version == 1 then
                uberInfoDesc = PST:getLocalized("ui_expUberInfoDesc_v1")
            else
                uberInfoDesc = PST:getLocalized("ui_expUberInfoDesc_v2")
            end
        end
        tScreen:DrawNodeBox(PST:getLocalized("ui_uberInfo"), uberInfoDesc)
    end

    -- HUD: Tabs
    local tabW, tabH = 50, 20
    self.BGSprite.Scale = Vector(tabW, tabH)
    for i, tmpTab in ipairs(self.tabs) do
        local drawX = tScreen.screenW / 2 - (#self.tabs * tabW) / 2 + ((i - 1) * tabW)

        local tmpColor = PST.kcolors.WHITE
        local tmpBGColor = Color(1, 1, 1, 1, 0.1, 0.1, 0.1)
        if i == self.currentTab then
            tmpColor = PST.kcolors.SKY_BLUE
            tmpBGColor = Color(1, 1, 1, 1, 0.1, 0.45, 0.6)
        end
        self.BGSprite.Color = tmpBGColor
        self.BGSprite:Render(Vector(drawX, 0))

        PST.miniFont:DrawString(tmpTab, drawX, 2, tmpColor, tabW, true)
    end
    local tmpStr = PST:getLocalized("ui_tabNumsToSwitch")
    PST.miniFont:DrawStringScaled(tmpStr, tScreen.screenW / 2 - PST.luaminiFont:GetStringWidth(tmpStr) / 4, tabH, 0.5, 0.5, PST.kcolors.WHITE)

    local currentChar = PST:getCurrentCharData()

    -- HUD: resources
    local tmpX = 12
    local tmpY = tabH + 2
    -- Global SP
    PST.miniFont:DrawString(PST:getLocalized("ui_globalSP") .. ": " .. PST.modData.skillPoints, tmpX, tmpY, PST.kcolors.LIGHTBLUE1)
    tmpY = tmpY + 14
    -- Respecs
    PST.miniFont:DrawString(PST:getLocalized("ui_Respecs") .. ": " .. PST.modData.respecPoints, tmpX, tmpY, PST.kcolors.WHITE)
    tmpY = tmpY + 14
    -- Arcane Obols
    if currentChar then
        PST.miniFont:DrawString(PST:getLocalized("ui_char") .. ": " .. PST:getCurrentCharName(), tmpX, tmpY, PST.kcolors.PURPLE1)
        tmpY = tmpY + 14
        PST.miniFont:DrawString(PST:getLocalized("ui_arcaneObols") .. ": " .. currentChar.arcaneObols, tmpX, tmpY, PST.kcolors.PURPLE1)
        tmpY = tmpY + 28
    end
    -- Expedition attempts
    PST.miniFont:DrawString(PST:getLocalized("ui_attempts") .. ": " .. expData.attempts .. "/" .. expData.startAttempts, tmpX, tmpY, PST.kcolors.EXPED_BLUE)
    -- Order/Entropy (uber)
    if expData.uber then
        tmpY = tmpY + 14
        PST.miniFont:DrawString(PST:getLocalized("ui_Order") .. ": " .. (expData.order or 0), tmpX, tmpY, PST.kcolors.TEAL1)
        tmpY = tmpY + 14
        PST.miniFont:DrawString(PST:getLocalized("ui_Entropy") .. ": " .. (expData.entropy or 0), tmpX, tmpY, PST.kcolors.RED1)
    end
    tmpY = tmpY + 28
    if self.currentTab == 1 then
        -- Expedition enabled/disabled
        if PST.modData.expedEnabled then
            local tmpColor = PST.kcolors.GREEN1
            local uberExtra = ""
            if expData.uber then
                uberExtra = " (" .. PST:getLocalized("ui_uber") .. ")"
            end
            tmpStr = "Exp. Run ON" .. uberExtra
            if not PST:expedMeetsRequirements(self.currentDepth, self.uberMode) then
                tmpColor = PST.kcolors.RED1
                tmpStr = tmpStr .. " (Reqs!)"
            end
            PST.miniFont:DrawString(tmpStr, tmpX, tmpY, tmpColor)
        else
            PST.miniFont:DrawString("Exp. Run OFF", tmpX, tmpY, PST.kcolors.RED1)
        end
        tmpY = tmpY + 14
        PST.miniFont:DrawStringScaled("(" .. PST:getLocalized("ui_expQToToggle") .. ")", tmpX, tmpY, 0.5, 0.5, PST.kcolors.WHITE)
        tmpY = tmpY + 28

        -- In run - Progress enabled/disabled (for selected objective)
        local runDepth = PST:getTreeSnapshotMod("expedDepth", 0)
        if Isaac.IsInGame() and runDepth > 0 then
            if PST:expedCanProgress(runDepth, PST:getTreeSnapshotMod("isExpeduber", false)) then
                PST.miniFont:DrawString(PST:getLocalized("ui_expInRunProgEnabled"), tmpX, tmpY, PST.kcolors.GREEN1)
            else
                PST.miniFont:DrawString(PST:getLocalized("ui_expInRunProgDisabled"), tmpX, tmpY, PST.kcolors.RED1)
            end
        end
    end
end

return expeditionScreen