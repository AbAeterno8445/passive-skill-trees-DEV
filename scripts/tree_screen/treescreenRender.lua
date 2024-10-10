local treeControlDesc = {
    "WASD / Arrow keys: pan camera",
    "Shift + V: re-center camera",
    "Z / Shift + Z: zoom in/out",
    "E: allocate hovered node",
    "R: respec hovered node",
    "Q: switch to selected character's tree",
    "Shift + Q: enable/disable tree effects next run",
    "Shift + H: display a list of all active modifiers",
    "Shift + C: show mod changelog"
}
local treeControlDescController = {
    "Joystick / Dpad: pan camera",
    "RT: re-center camera",
    "Item + Shoot down/up: zoom in/out",
    "Menu action: allocate hovered node",
    "Item + Menu action: respec hovered node",
    "Menu tab: switch to selected character's tree",
    "Item + Menu tab: enable/disable tree effects next run",
    "Item + Select: display a list of all active modifiers"
}
local backupsMsg = {
    {"Potential data loss has been detected, and backup files are present.", KColor(1, 0.8, 0.8, 1)},
    {"Press up/down to select one of these available backups, and E to attempt loading it.", KColor(1, 0.8, 0.8, 1)},
    {"Press ESC / Back to dismiss popup.", KColor(1, 0.8, 0.8, 1)},
    {"(This popup will stop showing up once your global level is higher than 1)", KColor(1, 0.8, 0.8, 1)},
    ""
}

function PST.treeScreen:Render()
    self.cursorHighlight = false

    -- Black BG
    if self.resized then
        self.treeBGSprite.Scale = Vector(self.screenW / 480, self.screenH / 270)
    end
    self.treeBGSprite:Render(Vector.Zero)

    -- Space BG
    self.modules.spaceBGModule:Render(self)

    -- Nodes
    self.hoveredNode = nil
    self.modules.nodeDrawingModule:Render(self)

    -- Submenus
    self.modules.submenusModule:Render(self)

    -- Cursor
    if self.hoveredNode or self.cursorHighlight then
        self.cursorSprite:Play("Clicked")
    else
        self.cursorSprite:Play("Idle")
    end
    self.cursorSprite:Render(Vector(self.screenW / 2, self.screenH / 2))

    -- Description boxes
    self.modules.descriptionBoxes:Render(self)

    local skPoints = PST.modData.skillPoints
    local treeName = "Global Tree - LV " .. PST.modData.level
    if self.currentTree ~= "global" then
        if self.currentTree == "starTree" then
            local tmpStarmight = 0
            if self.starcursedTotalMods then
                tmpStarmight = self.starcursedTotalMods.totalStarmight
            end
            treeName = "Star Tree (" .. tmpStarmight .. " total starmight)"
        else
            skPoints = PST.modData.charData[self.currentTree].skillPoints
            local tmpPossessive = "s"
            if string.sub(self.currentTree, -1) == "s" then
                tmpPossessive = ""
            end
            treeName = self.currentTree .. "'" .. tmpPossessive .. " Tree"
        end
    end

    -- HUD
    if not self.hideHUD then
        -- HUD data
        Isaac.RenderText(
            "Skill points: " .. skPoints .. " / Respecs: " .. PST.modData.respecPoints,
            8, 8, 1, 1, 1, 1
        )
        PST.miniFont:DrawString(PST.modVersion, self.screenW - 4 - PST.miniFont:GetStringWidth(PST.modVersion), 4, KColor(1, 1, 1, 0.9))
        Isaac.RenderText(treeName, 8, 24, 1, 1, 1, 1)
        if PST.modData.treeDisabled then
            Isaac.RenderText("Tree effects disabled", 8, 40, 1, 0.4, 0.4, 1)
        end
        local tmpStr = "H / Select: toggle help"
        PST.miniFont:DrawString(tmpStr, 16, self.screenH - 24, KColor(1, 1, 1, 1))
        if Isaac.IsInGame() then
            PST.miniFont:DrawString("(IN RUN - Changes to the tree will be reflected on the next run you start)", 32 + string.len(tmpStr) * 4, self.screenH - 24, KColor(1, 0.7, 0.7, 1))
        end

        -- Help popups
        if self.helpPopup == "helpkeyboard" then
            self:DrawNodeBox("Tree Controls", treeControlDesc, 16, 40, true, 1)
        elseif self.helpPopup == "helpcontroller" then
            self:DrawNodeBox("Tree Controls (Controller)", treeControlDescController, 16, 40, true, 1)
        end
    end

    -- Menus
    self.modules.menuScreensModule:Render(self)

    -- Backups popup
    if self.backupsPopup then
        local tmpBackupsMsg = {table.unpack(backupsMsg)}
        for i, tmpBackup in ipairs(self.saveBackups) do
            local backupData = tmpBackup[1]
            if backupData then
                local tmpColor = KColor(1, 1, 1, 1)
                local backupLine = tostring(i) .. ". Level: " .. tostring(tmpBackup[2])
                if self.selectedBackup == i then
                    tmpColor = KColor(0.6, 0.75, 1, 1)
                    backupLine = backupLine .. " (E / Action Button to load this backup)"
                end
                table.insert(tmpBackupsMsg, {backupLine, tmpColor})
            end
        end
        self:DrawNodeBox("Data Loss Detected", tmpBackupsMsg, 32, 32, true, 1)
    end
end