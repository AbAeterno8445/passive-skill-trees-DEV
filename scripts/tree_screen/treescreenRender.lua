local backupsMsg = {
    {PST:getLocalized("ui_backupWarn1"), PST.kcolors.LIGHTRED1},
    {PST:getLocalized("ui_backupWarn2"), PST.kcolors.LIGHTRED1},
    {PST:getLocalized("ui_backupWarn3"), PST.kcolors.LIGHTRED1},
    {PST:getLocalized("ui_backupWarn4"), PST.kcolors.LIGHTRED1},
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
    if not self.hideNodes then
        self.modules.nodeDrawingModule:Render(self)
    end

    -- Submenus
    self.modules.submenusModule:Render(self)

    -- Cursor
    if not self.disableCursor then
        if self.hoveredNode or self.cursorHighlight then
            self.cursorSprite:Play("Clicked")
        else
            self.cursorSprite:Play("Idle")
        end
        self.cursorSprite:Render(Vector(self.screenW / 2, self.screenH / 2))
    end

    -- Description boxes
    self.modules.descriptionBoxes:Render(self)

    -- Tree name display
    local skPoints = PST.modData.skillPoints
    local treeName = PST:getLocalized("ui_globalTree") .. " - LV " .. PST.modData.level
    if self.currentTree ~= "global" then
        local charAlias = self.currentTree
        if self.treeAliases[self.currentTree] then
            charAlias = self.treeAliases[self.currentTree]
        end
        if self.currentTree == "starTree" then
            local tmpStarmight = 0
            if self.starcursedTotalMods then
                tmpStarmight = self.starcursedTotalMods.totalStarmight
            end
            treeName = PST:getLocalized("ui_starTree") .. " (" .. PST:getLocalizedFormatStr("ui_totalStarmight", {starmight = tmpStarmight}) .. ")"
        elseif self.currentTree == "sidereal" then
            treeName = PST:getLocalized("ui_siderealTree")
            local curName = PST:getCurrentCharName()
            if curName then treeName = treeName .. " (" .. curName .. ")" end
        elseif PST.modData.charData[charAlias] then
            skPoints = PST.modData.charData[charAlias].skillPoints
            local tmpPossessive = "'s"
            if string.sub(charAlias, -1) == "s" then
                tmpPossessive = "'"
            end
            treeName = PST:getLocalizedFormatStr("ui_charTreeName", {charName = charAlias, possessive = tmpPossessive})
        else
            treeName = self.currentTree
        end
        if self.treeNameAliases[self.currentTree] then
            treeName = self.treeNameAliases[self.currentTree]
        end
    end

    -- HUD
    if not self.hideHUD then
        local tmpX, tmpY = 8, 8

        -- Global SP / Respecs
        Isaac.RenderText(
            PST:getLocalized("ui_SkillPoints") .. ": " .. skPoints .. " / " .. PST:getLocalized("ui_Respecs") .. ": " .. PST.modData.respecPoints,
            tmpX, tmpY, 1, 1, 1, 1
        )
        -- Mod version top right
        PST.miniFont:DrawString(PST.modVersion, self.screenW - 4 - PST.miniFont:GetStringWidth(PST.modVersion), tmpY, PST.kcolors.WHITE)
        tmpY = tmpY + 16

        -- Tree name
        Isaac.RenderText(treeName, tmpX, tmpY, 1, 1, 1, 1)
        tmpY = tmpY + 12
        local tmpCharName = PST:getCurrentCharName()
        if self.currentTree == "global" and tmpCharName and PST.trees[tmpCharName] then
            local tmpPossessive = "'s"
            if string.sub(tmpCharName, -1) == "s" then
                tmpPossessive = "'"
            end
            PST.miniFont:DrawStringScaled(PST:getLocalizedFormatStr("ui_charTreeAccessHint", {charName = tmpCharName, possessive = tmpPossessive}), tmpX, tmpY, 1, 1, PST.kcolors.WHITE)
            tmpY = tmpY + 16
        else
            tmpY = tmpY + 4
        end

        -- Tree disabled warning
        if PST.modData.treeDisabled then
            Isaac.RenderText(PST:getLocalized("ui_treeEffectsDisabled"), tmpX, tmpY, 1, 0.4, 0.4, 1)
            tmpY = tmpY + 14
            PST.miniFont:DrawString("(" .. PST:getLocalized("ui_treeReenableHint") .. ")", tmpX, tmpY, PST.kcolors.RED1)
            tmpY = tmpY + 16
        elseif PST.modData.expedEnabled and ((not PST.modData.expedUberMode and PST:expedMeetsRequirements(PST.modData.expedSelDepth)) or
        (PST.modData.expedUberMode and PST:expedMeetsRequirements(PST.modData.uberExpedSelDepth, true))) then
            local uberExtra = ""
            if PST.modData.expedUberMode then
                uberExtra = " (Uber)"
            end
            Isaac.RenderText("Exp. run ON" .. uberExtra, tmpX, tmpY, 0.5, 1, 0.5, 1)
            tmpY = tmpY + 16
        end

        -- Help toggle indicator
        local tmpStr = PST:getLocalized("ui_helpToggleHint1") .. "  |  " .. PST:getLocalized("ui_helpToggleHint2")
        PST.miniFont:DrawString(tmpStr, 12, self.screenH - 30, PST.kcolors.WHITE)

        -- In-run warning
        if Isaac.IsInGame() and not PST:getTreeSnapshotMod("dynamicMode", false) then
            PST.miniFont:DrawString("(" .. PST:getLocalized("ui_inRunNonDynamic") .. ")", 12, self.screenH - 16, PST.kcolors.RED1)
        end

        -- Sidereal tree extra
        if self.currentTree == "sidereal" then
            local currentChar = PST:getCurrentCharData()
            if currentChar then
                tmpY = tmpY + 14
                PST.miniFont:DrawString("Char: " .. PST:getCurrentCharName(), tmpX, tmpY, PST.kcolors.PURPLE1)
                tmpY = tmpY + 14
                PST.miniFont:DrawString(PST:getLocalized("ui_arcaneObols") .. ": " .. tostring(currentChar.arcaneObols), tmpX, tmpY, PST.kcolors.PURPLE1)
                tmpY = tmpY + 28
            end
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
                local tmpColor = PST.kcolors.WHITE
                local backupLine = tostring(i) .. ". Level: " .. tostring(tmpBackup[2])
                if self.selectedBackup == i then
                    tmpColor = PST.kcolors.BLUE1
                    backupLine = backupLine .. " (" .. PST:getLocalized("ui_loadBackupHint") .. ")"
                end
                table.insert(tmpBackupsMsg, {backupLine, tmpColor})
            end
        end
        self:DrawNodeBox(PST:getLocalized("ui_dataLossDetected"), tmpBackupsMsg, 32, 32, true, 1)
    end
end