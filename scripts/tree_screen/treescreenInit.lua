include("scripts.tree_screen.modules.siderealArtifact")
include("scripts.tree_screen.modules.crimsonConvergence")

---@class PST.treeScreen
PST.treeScreen = {
    open = false,

    screenW = 0,
    screenH = 0,
    resized = false,

    disabledInputs = {},

    -- Camera control
    treeCamera = Vector(-Isaac.GetScreenWidth() / 2, -Isaac.GetScreenHeight() / 2),
    cameraSpeed = 3,
    camZoomOffset = Vector.Zero,
    zoomScale = 1,
    camCenterX = 0,
    camCenterY = 0,

    -- Sprites
    treeBGSprite = Sprite("gfx/ui/skilltrees/tree_bg.anm2", true),
    descBGSprite = Sprite("gfx/ui/skilltrees/tree_bg.anm2", true),
    UILinkSprite = Sprite("gfx/ui/skilltrees/nodes/expedition_node_link.anm2", true),
    cursorSprite = Sprite("gfx/ui/cursor.anm2", true),
    cursorHighlight = false,
    disableCursor = false,

    -- Currently displayed tree or character name for character trees
    currentTree = "global",

    -- Trees that are tied to specific character names
    treeAliases = {},

    -- Tree name aliases for display
    treeNameAliases = {},

    -- For controls help popups
    helpPopup = "",

    -- For total mods screen
    totalModsList = {},

    -- Currently hovered node data
    ---@type any
    hoveredNode = nil,

    -- Backups popup data
    backupsPopup = false,
    saveBackups = {},
    selectedBackup = 1,

    -- If true, triggers a save when closing the tree
    treeHasChanges = false,

    -- Star tree
    starcursedTotalMods = {},

    -- Used for toggleDebugMode, to update tree node states
    debugAvailableUpdate = false,

    -- Stop rendering the HUD (tree name & level, 'Press H for help', etc.) when true
    hideHUD = false,

    -- Whether to render tree nodes
    hideNodes = false,

    -- Node positions to pan the camera to when hitting Tab
    tabNodes = {},
    currentNodeTab = 0,

    -- List of modules with update/render functionality, each ideally containing Update() or Render() funcs
    modules = {
        spaceBGModule = include("scripts.tree_screen.modules.spaceBackground"),
        nodeDrawingModule = include("scripts.tree_screen.modules.nodeDrawing"),
        submenusModule = include("scripts.tree_screen.modules.submenus"),
        descriptionBoxes = include("scripts.tree_screen.modules.descriptionBoxes"),
        menuScreensModule = include("scripts.tree_screen.modules.menuScreens")
    },
}

-- Init
PST.treeScreen.treeBGSprite:Play("Default", true)
PST.treeScreen.descBGSprite:Play("Pixel", true)
PST.treeScreen.cursorSprite.Color.A = 0.7
PST.treeScreen.cursorSprite:Play("Idle", true)
PST.treeScreen.UILinkSprite:Play("DescBoxUI", true)

-- Tab-able nodes
local tabNodes = {
    global = {"Star Tree"},
    starTree = {"Sidereal Tree", "Arcane Astrolabe"},
    sidereal = {"Astral Forge"}
}
for treeName, nodeNameList in pairs(tabNodes) do
    PST.treeScreen.tabNodes[treeName] = {}
    for _, nodeName in ipairs(nodeNameList) do
        for _, tmpNode in pairs(PST.trees[treeName]) do
            if tmpNode.name == nodeName then
                table.insert(PST.treeScreen.tabNodes[treeName], tmpNode.pos * 38)
                break
            end
        end
    end
end

function PST.treeScreen:switchCurrentTree(newTree)
    self.currentTree = newTree
    self:CenterCamera()
    self.modules.submenusModule:CloseSubmenu()
end

include("scripts.tree_screen.treescreenRender")
include("scripts.tree_screen.treescreenUpdate")
include("scripts.tree_screen.treescreenUtility")

-- Render hooks func
local firstRender = false
function PST:treeScreenMenuRender()
    local isCharMenu = false
    if not Isaac.IsInGame() then
        isCharMenu = MenuManager.GetActiveMenu() == MainMenuType.CHARACTER
        ---@diagnostic disable-next-line: undefined-field
        if CharacterMenu.GetActiveStatus then
            ---@diagnostic disable-next-line: undefined-field
            isCharMenu = isCharMenu and CharacterMenu.GetActiveStatus() == 0
        end
    end

    -- First MC_MAIN_MENU_RENDER
    if not firstRender then
        firstRender = true
        PST:firstRenderInit()
        PST.treeScreen:UpdateStarTreeTotals()

        if not Isaac.IsInGame() then
            -- Reset input mask if restarting
            if MenuManager.GetInputMask() ~= PST.menuInputMask then
                ---@diagnostic disable-next-line: param-type-mismatch
                MenuManager.SetInputMask(PST.menuInputMask)
            end
        end
    end

    -- Input: Open tree menu (outside game)
    if not Isaac.IsInGame() then
        if PST.treeScreen.open and not isCharMenu then
            PST:closeTreeMenu(true, true)
        elseif (PST:isKeybindActive(PSTKeybind.OPEN_TREE) or (not PST.treeScreen.open and PST:IsActionTriggered(ButtonAction.ACTION_ITEM, 1))) and isCharMenu then
            if PST.treeScreen.open then
                PST:closeTreeMenu()
            else
                PST:openTreeMenu()
            end
        end
    end

    if not PST.treeScreen.open and isCharMenu and PST.selectedMenuChar ~= -1 then
        local selCharName = PST.charNames[1 + PST.selectedMenuChar]
        if selCharName then
            local selCharData = PST.modData.charData[selCharName]
            if selCharData and PST.config.charSelectInfoText then
                local tmpStr = selCharName .. " LV " .. selCharData.level
                tmpStr = tmpStr .. " (" .. PST:getLocalized("ui_openTreeKey") .. ")"
                if PST.modData.treeDisabled then
                    tmpStr = tmpStr .. " (" .. PST:getLocalized("ui_treeDisabled") .. ")"
                end
                PST.miniFont:DrawStringUTF8(
                    tmpStr,
                    Isaac.GetScreenWidth() / 2 - string.len(tmpStr) * 2,
                    Isaac.GetScreenHeight() - 18,
                    PST.kcolors.UI_PINK
                )
            end
        end
    elseif Game():IsPauseMenuOpen() and not PST.treeScreen.open and PST.config.drawPauseText then
        local tmpStr = PST:getLocalized("ui_openTreeKey")
        PST.miniFont:DrawStringUTF8(
            tmpStr,
            Isaac.GetScreenWidth() / 2 - string.len(tmpStr) * 2.5,
            Isaac.GetScreenHeight() - 40,
            PST.kcolors.UI_PINK
        )
    end

    -- Actual tree rendering when opened
    if PST.treeScreen.open then
        if Isaac.IsInGame() and PauseMenu.GetState() ~= 4 then
            -- Pause screen state 4 seems to keep the game paused without interface interaction in the background
            ---@diagnostic disable-next-line: param-type-mismatch
            PauseMenu.SetState(4)
        end

        PST.treeScreen:Update()
        PST.treeScreen:Render()
    end
end

-- Pause menu render func
function PST:treePauseRender()
end

-- Post pause menu render
function PST:postPauseRender()
    -- Expedition objective display
    if Isaac.IsInGame() and PST.config.drawPauseText and PST:getTreeSnapshotMod("isExpedRun", false) then
        local depth = PST:getTreeSnapshotMod("expedDepth", 1)
        local expData = PST:getExpedData(depth, PST:getTreeSnapshotMod("isExpedUber", false))
        if expData and expData.selectedNode then
            local tmpNode = expData.nodes[expData.selectedNode.col][expData.selectedNode.row]
            local tmpOrderObjData = PST:getExpedOrderObjDataAt(depth, expData.uber, expData.selectedNode.col - 1, expData.selectedNode.row)
            if tmpNode then
                local tmpScale = 0.5
                local tmpY = 6
                if not PST:isKeybindActive(PSTKeybind.TREE_TAB, true) then
                    local tmpDesc = {table.unpack(PST:getExpNodeObjectiveDesc(tmpNode, expData))}
                    if not PST:expedCanProgress(depth) then
                        table.insert(tmpDesc, {"(" .. PST:getLocalized("ui_cantProgInRun") .. ")", PST.kcolors.RED1})
                    end
                    for _, tmpLine in ipairs(tmpDesc) do
                        local tmpStr = tmpLine[1]
                        if tmpStr == PST:getLocalized("ui_objective") .. ":" then
                            tmpStr = PST:getLocalized("ui_ExpObjective") .. ":"
                            if tmpOrderObjData then
                                tmpStr = tmpStr .. " (" .. PST:getLocalized("ui_holdTabOrderObj") .. ")"
                            end
                        end
                        local tmpX = Isaac.GetScreenWidth() / 2 - PST.miniFont:GetStringWidth(tmpStr) / (2 / tmpScale)
                        PST.miniFont:DrawStringScaledUTF8(tmpStr, tmpX, tmpY, tmpScale, tmpScale, tmpLine[2])
                        tmpY = tmpY + 14 * tmpScale
                    end
                elseif tmpOrderObjData then
                    local tmpStr = PST:getLocalized("ui_expOrderObjectives")
                    local tmpX = Isaac.GetScreenWidth() / 2 - PST.miniFont:GetStringWidth(tmpStr) / (2 / tmpScale)
                    PST.miniFont:DrawStringScaledUTF8(tmpStr, tmpX, tmpY, tmpScale, tmpScale, PST.kcolors.TEAL1)
                    tmpY = tmpY + 14 * tmpScale
                    for _, tmpOrdMod in ipairs(tmpOrderObjData) do
                        local ordModData = PST.expedOrderMods[tmpOrdMod.obj]
                        if ordModData then
                            tmpStr = PST:getExpedOrderModDescLine(tmpOrdMod)
                            local tmpColor = PST.kcolors.TEAL1
                            if tmpOrdMod.prog >= ordModData.max then
                                tmpColor = PST.kcolors.GREEN1
                            end
                            tmpX = Isaac.GetScreenWidth() / 2 - PST.miniFont:GetStringWidth(tmpStr) / (2 / tmpScale)
                            PST.miniFont:DrawStringScaledUTF8(tmpStr, tmpX, tmpY, tmpScale, tmpScale, tmpColor)
                            tmpY = tmpY + 14 * tmpScale
                        end
                    end
                end
            end
        end
    end
end

PST:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, PST.treeScreenMenuRender)
PST:AddCallback(ModCallbacks.MC_POST_RENDER, PST.treeScreenMenuRender)
PST:AddCallback(ModCallbacks.MC_PRE_PAUSE_SCREEN_RENDER, PST.treePauseRender)
PST:AddCallback(ModCallbacks.MC_POST_PAUSE_SCREEN_RENDER, PST.postPauseRender)