include("scripts.tree_screen.modules.input.treeInputs")

function PST.treeScreen:Update()
    self.resized = false
    if self.screenW ~= Isaac.GetScreenWidth() or self.screenH ~= Isaac.GetScreenHeight() then
        self.screenW = Isaac.GetScreenWidth()
        self.screenH = Isaac.GetScreenHeight()
        self.resized = true
    end
    self.camCenterX = self.screenW / 2 + self.treeCamera.X + self.camZoomOffset.X
    self.camCenterY = self.screenH / 2 + self.treeCamera.Y + self.camZoomOffset.Y

    self.cameraSpeed = 3 * (1 + 1 - self.zoomScale)

    -- Space BG
    self.modules.spaceBGModule:Update(self)

    -- Process inputs
    self:Inputs()

    -- Nodes
    self.modules.nodeDrawingModule:Update(self)

    -- Submenus
    self.modules.submenusModule:Update(self)

    -- Update tree visibility if debug mode allAvailable changes
    if self.debugAvailableUpdate ~= PST.debugOptions.allAvailable then
        PST:updateNodes("global", true)
        PST:updateNodes("starTree", true)
        if self.currentTree ~= "global" and self.currentTree ~= "starTree" then
            PST:updateNodes(self.currentTree, true)
        end
        self.debugAvailableUpdate = PST.debugOptions.allAvailable
    end
end