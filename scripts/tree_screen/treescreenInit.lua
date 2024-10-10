-- Hack to provide VSCode autocomplete functionality on modules (wtf?)
local moduleRequire = require
moduleRequire = include

---@class PST.treeScreen
PST.treeScreen = {
    open = false,

    screenW = 0,
    screenH = 0,
    resized = false,

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
    cursorSprite = Sprite("gfx/ui/cursor.anm2", true),
    cursorHighlight = false,

    -- Currently displayed tree, "global", "starTree", or character name
    currentTree = "global",

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

    -- List of modules with update/render functionality, each ideally containing Update() or Render() funcs
    modules = {
        spaceBGModule = moduleRequire("scripts.tree_screen.modules.spaceBackground"),
        nodeDrawingModule = moduleRequire("scripts.tree_screen.modules.nodeDrawing"),
        submenusModule = moduleRequire("scripts.tree_screen.modules.submenus"),
        descriptionBoxes = moduleRequire("scripts.tree_screen.modules.descriptionBoxes"),
        menuScreensModule = moduleRequire("scripts.tree_screen.modules.menuScreens")
    },
}

-- Init
PST.treeScreen.treeBGSprite:Play("Default", true)
PST.treeScreen.descBGSprite:Play("Pixel", true)
PST.treeScreen.cursorSprite.Color.A = 0.7
PST.treeScreen.cursorSprite:Play("Idle", true)

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

    if PST.treeScreen.open and ((not Isaac.IsInGame() and not isCharMenu) or (Isaac.IsInGame() and not Game():IsPauseMenuOpen())) then
        PST:closeTreeMenu(true, true)
    -- Input: Open tree menu
    elseif PST:isKeybindActive(PSTKeybind.OPEN_TREE) or (not PST.treeScreen.open and PST:IsActionTriggered(ButtonAction.ACTION_ITEM, 1)) then
        if isCharMenu or Game():IsPauseMenuOpen() then
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
                tmpStr = tmpStr .. " (V / LT or LB to open tree)"
                if PST.modData.treeDisabled then
                    tmpStr = tmpStr .. " (tree disabled)"
                end
                PST.miniFont:DrawString(
                    tmpStr,
                    Isaac.GetScreenWidth() / 2 - string.len(tmpStr) * 2,
                    Isaac.GetScreenHeight() - 18,
                    KColor(1, 0.8, 1, 1)
                )
            end
        end
    elseif Game():IsPauseMenuOpen() and not PST.treeScreen.open and PST.config.drawPauseText then
        local tmpStr = "V / LT or LB to open tree"
        PST.miniFont:DrawString(
            tmpStr,
            Isaac.GetScreenWidth() / 2 - string.len(tmpStr) * 2.5,
            Isaac.GetScreenHeight() - 40,
            KColor(1, 0.8, 1, 1)
        )
    end

    -- Actual tree rendering when opened
    if PST.treeScreen.open then
        PST.treeScreen:Update()
        PST.treeScreen:Render()
    end
end

-- Pause menu render func
function PST:treePauseRender()
    if PST.treeScreen.open then
        -- Force pause menu to loop between options and open in the background, while tree is open
        if Options.Language == "en" then
            PauseMenu.SetState(PauseMenuStates.OPTIONS)
        end
        OptionsMenu.SetSelectedElement(999)
        return false
    end
end

PST:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, PST.treeScreenMenuRender)
PST:AddCallback(ModCallbacks.MC_POST_RENDER, PST.treeScreenMenuRender)
PST:AddCallback(ModCallbacks.MC_PRE_PAUSE_SCREEN_RENDER, PST.treePauseRender)