include("scripts.tree_screen.modules.input.inputAllocate")
include("scripts.tree_screen.modules.input.inputRespec")

local menuKeys = {
    [PSTKeybind.TOGGLE_CHANGELOG] = PSTTreeScreenMenu.CHANGELOG,
    [PSTKeybind.TOGGLE_TOTAL_MODS] = PSTTreeScreenMenu.TOTALMODS,
    [PSTKeybind.TOGGLE_HELP] = PSTTreeScreenMenu.HELP,
    [PSTKeybind.TREE_TAB] = PSTTreeScreenMenu.MENU_TABBER
}

function PST.treeScreen:Inputs()
    local menuScreensModule = self.modules.menuScreensModule
    local currentMenu = menuScreensModule.currentMenu
    local currentMenuModule = menuScreensModule.menus[currentMenu]

    -- Current menu input overrides
    if currentMenuModule and currentMenuModule.inputOverrides then
        for _, tmpInput in ipairs(currentMenuModule.inputOverrides) do
            table.insert(self.disabledInputs, tmpInput)
        end
    end

    -- Input: Close tree
    if PST:isKeybindActive(PSTKeybind.CLOSE_TREE) and not PST:arrHasValue(self.disabledInputs, PSTKeybind.CLOSE_TREE) then
        if self.backupsPopup then
            self.backupsPopup = false
        elseif currentMenu ~= PSTTreeScreenMenu.NONE then
            menuScreensModule:CloseMenu()
        elseif self.currentTree == "sidereal" then
            self:switchCurrentTree("starTree")
        elseif self.currentTree == "starTree" then
            self:switchCurrentTree("global")
        else
            PST:closeTreeMenu()
        end
    end

    -- Menu inputs
    if currentMenuModule and currentMenuModule.OnInput then
        menuScreensModule.menus[currentMenu]:OnInput()
    end

    -- Input: Allocate node
    if not PST:arrHasValue(self.disabledInputs, PSTKeybind.ALLOCATE_NODE) or self.backupsPopup then
        self:InputAllocate()
    end

    -- Input: Respec node
    if not PST:arrHasValue(self.disabledInputs, PSTKeybind.RESPEC_NODE) then
        self:InputRespec()
    end

    -- Input: Faster panning
    if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) and not PST:arrHasValue(self.disabledInputs, PSTKeybind.PAN_FASTER) then
        self.cameraSpeed = 8 * (1 + 1 - self.zoomScale)
    end
    -- Input: Directional keys/buttons
    if not self.backupsPopup then
        -- UP
        if PST:isKeybindActive(PSTKeybind.TREE_PAN_UP, true) and not PST:arrHasValue(self.disabledInputs, PSTKeybind.TREE_PAN_UP) then
            if currentMenu == PSTTreeScreenMenu.NONE then
                if self.treeCamera.Y > -2000 then
                    self.treeCamera.Y = self.treeCamera.Y - self.cameraSpeed
                    self:UpdateCamZoomOffset()
                end
            else
                menuScreensModule.menuScrollY = math.min(0, menuScreensModule.menuScrollY + math.floor(self.cameraSpeed * 1.5))
            end
        -- DOWN
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_DOWN, true) and not PST:arrHasValue(self.disabledInputs, PSTKeybind.TREE_PAN_DOWN) then
            if currentMenu == PSTTreeScreenMenu.NONE then
                if self.treeCamera.Y < 2000 then
                    self.treeCamera.Y = self.treeCamera.Y + self.cameraSpeed
                    self:UpdateCamZoomOffset()
                end
            else
                menuScreensModule.menuScrollY = menuScreensModule.menuScrollY - math.floor(self.cameraSpeed * 1.5)
            end
        end
        -- LEFT
        if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT, true) and not PST:arrHasValue(self.disabledInputs, PSTKeybind.TREE_PAN_LEFT) then
            if currentMenu == PSTTreeScreenMenu.NONE then
                if self.treeCamera.X > -2000 then
                    self.treeCamera.X = self.treeCamera.X - self.cameraSpeed
                    self:UpdateCamZoomOffset()
                end
            end
        -- RIGHT
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT, true) and not PST:arrHasValue(self.disabledInputs, PSTKeybind.TREE_PAN_RIGHT) then
            if currentMenu == PSTTreeScreenMenu.NONE then
                if self.treeCamera.X < 2000 then
                    self.treeCamera.X = self.treeCamera.X + self.cameraSpeed
                    self:UpdateCamZoomOffset()
                end
            end
        end
    -- Backup popup selection
    else
        if PST:isKeybindActive(PSTKeybind.TREE_PAN_UP, false) then
            self.selectedBackup = self.selectedBackup - 1
            if self.selectedBackup <= 0 then
                self.selectedBackup = #self.saveBackups
            end
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_DOWN, false) then
            self.selectedBackup = self.selectedBackup + 1
            if self.selectedBackup > #self.saveBackups then
                self.selectedBackup = 1
            end
        end
    end

    -- Input: Switch tree
    if PST:isKeybindActive(PSTKeybind.SWITCH_TREE) and not PST:arrHasValue(self.disabledInputs, PSTKeybind.SWITCH_TREE) then
        local selectedCharName = PST.charNames[1 + PST.selectedMenuChar]
        if selectedCharName and PST.trees[selectedCharName] ~= nil then
            if self.currentTree == "global" then
                self.currentTree = selectedCharName
            elseif self.currentTree == "sidereal" then
                self.currentTree = "starTree"
            else
                self.currentTree = "global"
            end
            self.modules.submenusModule:CloseSubmenu()
            SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
        else
            SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
        end
    end

    -- Input: Toggle tree effects
    if PST:isKeybindActive(PSTKeybind.TOGGLE_TREE_MODS) and not PST:arrHasValue(self.disabledInputs, PSTKeybind.TOGGLE_TREE_MODS) then
        PST.modData.treeDisabled = not PST.modData.treeDisabled
        if PST.modData.treeDisabled then
            SFXManager():Play(SoundEffect.SOUND_BEEP, 0.6)
        end
        self.treeHasChanges = true
    end

    -- Menus
    if not self.backupsPopup then
        for tmpInput, tmpMenu in pairs(menuKeys) do
            if PST:isKeybindActive(tmpInput) and not PST:arrHasValue(self.disabledInputs, tmpInput) then
                if currentMenu == tmpMenu then
                    menuScreensModule:CloseMenu()
                else
                    menuScreensModule:SwitchToMenu(tmpMenu)
                end
                break
            end
        end
    end

    if Isaac.GetFrameCount() % 2 == 0 then
        -- Input: Zoom in
        if PST:isKeybindActive(PSTKeybind.ZOOM_IN, true) and self.zoomScale < 1 and not PST:arrHasValue(self.disabledInputs, PSTKeybind.ZOOM_IN) then
            self.zoomScale = self.zoomScale + 0.1
            self:UpdateCamZoomOffset()
        -- Input: Zoom out
        elseif PST:isKeybindActive(PSTKeybind.ZOOM_OUT, true) and self.zoomScale > 0.6 and not PST:arrHasValue(self.disabledInputs, PSTKeybind.ZOOM_OUT) then
            self.zoomScale = self.zoomScale - 0.1
            self:UpdateCamZoomOffset()
        end
    end

    -- Input: Center camera
    if PST:isKeybindActive(PSTKeybind.CENTER_CAMERA) and not PST:arrHasValue(self.disabledInputs, PSTKeybind.CENTER_CAMERA) then
        self:CenterCamera()
    end
end