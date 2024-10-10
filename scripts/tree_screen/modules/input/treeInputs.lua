include("scripts.tree_screen.modules.input.inputAllocate")
include("scripts.tree_screen.modules.input.inputRespec")

local menuKeys = {
    [PSTKeybind.TOGGLE_CHANGELOG] = PSTTreeScreenMenu.CHANGELOG,
    [PSTKeybind.TOGGLE_TOTAL_MODS] = PSTTreeScreenMenu.TOTALMODS
}

function PST.treeScreen:Inputs()
    local menuScreensModule = self.modules.menuScreensModule
    local currentMenu = menuScreensModule.currentMenu

    -- Input: Close tree
    if PST:isKeybindActive(PSTKeybind.CLOSE_TREE) then
        if self.backupsPopup then
            self.backupsPopup = false
        elseif currentMenu ~= PSTTreeScreenMenu.NONE then
            SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
            menuScreensModule:CloseMenu()
        else
            PST:closeTreeMenu()
        end
    end

    -- Input: Allocate node
    self:InputAllocate()

    -- Input: Respec node
    self:InputRespec()

    -- Input: Faster panning
    if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
        self.cameraSpeed = 8 * (1 + 1 - self.zoomScale)
    end
    -- Input: Directional keys/buttons
    if not self.backupsPopup then
        -- UP
        if PST:isKeybindActive(PSTKeybind.TREE_PAN_UP, true) then
            if currentMenu == PSTTreeScreenMenu.NONE then
                if self.treeCamera.Y > -2000 then
                    self.treeCamera.Y = self.treeCamera.Y - self.cameraSpeed
                    self:UpdateCamZoomOffset()
                end
            else
                menuScreensModule.menuScrollY = math.min(0, menuScreensModule.menuScrollY + math.floor(self.cameraSpeed * 1.5))
            end
        -- DOWN
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_DOWN, true) then
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
        if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT, true) then
            if currentMenu == PSTTreeScreenMenu.NONE then
                if self.treeCamera.X > -2000 then
                    self.treeCamera.X = self.treeCamera.X - self.cameraSpeed
                    self:UpdateCamZoomOffset()
                end
            end
        -- RIGHT
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT, true) then
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
    if PST:isKeybindActive(PSTKeybind.SWITCH_TREE) then
        local selectedCharName = PST.charNames[1 + PST.selectedMenuChar]
        if selectedCharName and PST.trees[selectedCharName] ~= nil then
            if self.currentTree == "global" then
                self.currentTree = selectedCharName
                self.modules.spaceBGModule.targetSpaceColor = Color(1, 0.5, 1, 1)
            else
                self.currentTree = "global"
                self.modules.spaceBGModule.targetSpaceColor = Color(1, 1, 1, 1)
            end
            self.modules.submenusModule:CloseSubmenu()
            SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
        else
            SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
        end
    end

    -- Input: Toggle tree effects
    if PST:isKeybindActive(PSTKeybind.TOGGLE_TREE_MODS) then
        PST.modData.treeDisabled = not PST.modData.treeDisabled
        if PST.modData.treeDisabled then
            SFXManager():Play(SoundEffect.SOUND_BEEP, 0.6)
        end
        self.treeHasChanges = true
    end

    -- Menus
    if not self.backupsPopup then
        for tmpInput, tmpMenu in pairs(menuKeys) do
            if PST:isKeybindActive(tmpInput) then
                if currentMenu == tmpMenu then
                    menuScreensModule:CloseMenu()
                else
                    menuScreensModule:SwitchToMenu(tmpMenu)
                end
                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                break
            end
        end
    end

    -- Help popups
    if PST:isKeybindActive(PSTKeybind.TOGGLE_HELP) then
        if self.helpPopup ~= "helpkeyboard" then
            self.helpPopup = "helpkeyboard"
        else
            self.helpPopup = ""
        end
    elseif PST:isKeybindActive(PSTKeybind.TOGGLE_HELP_CONTROLLER) then
        if self.helpPopup ~= "helpcontroller" then
            self.helpPopup = "helpcontroller"
        else
            self.helpPopup = ""
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