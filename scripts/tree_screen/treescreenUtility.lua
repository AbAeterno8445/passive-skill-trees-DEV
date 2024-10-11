-- Camera funcs
function PST.treeScreen:UpdateCamZoomOffset()
    local translateX = -Isaac.GetScreenWidth() / 2 - self.treeCamera.X
    local translateY = -Isaac.GetScreenHeight() / 2 - self.treeCamera.Y
    self.camZoomOffset.X = translateX - translateX * self.zoomScale
    self.camZoomOffset.Y = translateY - translateY * self.zoomScale

    local tmpModule = self.modules.nodeDrawingModule
    if tmpModule.nodesSprite.Scale.X ~= self.zoomScale then
        tmpModule.nodesSprite.Scale.X = self.zoomScale
        tmpModule.nodesSprite.Scale.Y = self.zoomScale
    end
    if tmpModule.nodesExtraSprite.Scale.X ~= self.zoomScale then
        tmpModule.nodesExtraSprite.Scale.X = self.zoomScale
        tmpModule.nodesExtraSprite.Scale.Y = self.zoomScale
    end
end
function PST.treeScreen:CenterCamera()
    self.treeCamera = Vector(-Isaac.GetScreenWidth() / 2, -Isaac.GetScreenHeight() / 2)
    self.camZoomOffset.X = 0
    self.camZoomOffset.Y = 0
end

-- Returns whether the given position + width/height is within the screen, considering sprite with centered pivot
function PST.treeScreen:IsSpriteVisibleAt(x, y, w, h)
    if x + w / 2 >= 0 and x - w / 2 <= Isaac.GetScreenWidth() and
    y + h / 2 >= 0 and y - h / 2 <= Isaac.GetScreenHeight() then
        return true
    end
    return false
end

-- Star tree update
function PST.treeScreen:UpdateStarTreeTotals()
    self.starcursedTotalMods = PST:SC_getTotalJewelMods()
end

-- Draw a 'node description box'
function PST.treeScreen:DrawNodeBox(name, description, paramX, paramY, absolute, bgAlpha)
    local tmpFont = PST.normalFont
    -- Base offset from center cursor
    local offX = 4
    local offY = 10
    local tmpScale = 1 / Isaac.GetScreenPointScale()

    -- Calculate longest description line, and offset accordingly
    local longestStr = name
    for i = 1, #description do
        local tmpStr = description[i]
        if type(tmpStr) == "table" then
            tmpStr = description[i][1]
        end
        if tmpStr and string.len(tmpStr) > string.len(longestStr) then
            longestStr = tmpStr
        end
    end
    local longestStrWidth = 8 + offX + tmpFont:GetStringWidth(longestStr)
    if longestStrWidth * tmpScale > paramX / 2 then
        offX = offX - (longestStrWidth * tmpScale - paramX / 2 + 8)
    end

    -- Draw description background
    local drawX = math.max(4, paramX / 2 + offX)
    local drawY = paramY / 2 + offY
    if absolute then
        drawX = paramX
        drawY = paramY
    end

    local descW = longestStrWidth * tmpScale + 4
    local descH = ((PST.miniFont:GetLineHeight() + 2) * (#description + 1)) * tmpScale + 4
    if not absolute and descH + offY > paramY / 2 - 8 then
        drawY = drawY - (descH + offY - paramY / 2 + 8)
    end

    -- Scale down if box overflows screen width
    --[[if not absolute and descW > paramX then
        tmpScale = PST:roundFloat(paramX / descW, -2)
    end]]

    self.descBGSprite.Scale.X = descW
    self.descBGSprite.Scale.Y = descH
    self.descBGSprite.Color.A = bgAlpha or 0.85
    self.descBGSprite:Render(Vector(drawX - 2, drawY - 2))

    tmpFont:DrawStringScaled(name, drawX, drawY, tmpScale, tmpScale, KColor(1, 1, 1, 1))
    for i = 1, #description do
        local tmpStr = description[i]
        local tmpColor = KColor(1, 1, 1, 0.9)
        if type(tmpStr) == "table" then
            tmpStr = description[i][1]
            tmpColor = description[i][2]
        else
            -- Harmonic mods color (Siren's tree)
            if PST:strStartsWith(tmpStr, "[Harmonic]") then
                if PST:songNodesAllocated(false) <= 2 then
                    tmpColor = KColor(0.6, 0.9, 1, 1)
                else
                    tmpColor = KColor(0.4, 0.4, 0.4, 1)
                end
            end
        end
        tmpFont:DrawStringScaled(tmpStr, drawX + 6 * tmpScale, drawY + 14 * tmpScale * i, tmpScale, tmpScale, tmpColor)
    end
end

-- Open tree
local changelogPopup = false
function PST:openTreeMenu()
    if not Isaac.IsInGame() then
        ---@diagnostic disable-next-line: param-type-mismatch
        MenuManager.SetInputMask(ButtonActionBitwise.ACTION_FULLSCREEN | ButtonActionBitwise.ACTION_MUTE)
        MenuManager.SetColorModifier(ColorModifier())
    elseif not Game():IsPauseMenuOpen() then
        return
    else
        local player = PST:getPlayer()
        PST.selectedMenuChar = player:GetPlayerType()
        Game():GetHUD():SetVisible(false)
    end
    SFXManager():Play(SoundEffect.SOUND_PAPER_IN)

    -- Sprinkle starfield sprites when opening tree
    local spaceModule = PST.treeScreen.modules.spaceBGModule
    spaceModule:ShuffleStarfield()
    spaceModule.targetSpaceColor = Color(1, 1, 1, 1)
    spaceModule.spaceOffPos = Vector.Zero
    spaceModule.spaceOffDir = Vector(-1 + 2 * math.random(), -1 + 2 * math.random())

    PST:updateNodes("global", true)
    PST.treeScreen.open = true

    -- New version changelog popup
    if PST.isNewVersion and not changelogPopup and PST.config.changelogPopup then
        changelogPopup = true
        PST.treeScreen.modules.menuScreensModule:SwitchToMenu(PSTTreeScreenMenu.CHANGELOG)
    end

    -- Backups popup
    if PST_BackupSave and PST.modData.level == 1 and PST_BackupExists(PST.saveSlot, 1) then
        local tmpBackups = {}
        for i=1,3 do
            if PST_BackupExists(PST.saveSlot, i) then
                local tmpBackupData = PST_BackupFetch(PST.saveSlot, i)
                if tmpBackupData ~= nil then
                    table.insert(tmpBackups, tmpBackupData)
                end
            end
        end
        PST.treeScreen.backupsPopup = true
        PST.treeScreen.saveBackups = tmpBackups
    end
end

-- Close tree
function PST:closeTreeMenu(mute, force)
    if PST.treeScreen.treeHasChanges then
        PST:save(true)
        PST.treeScreen.treeHasChanges = false
    end

    if not Isaac.IsInGame() then
        ---@diagnostic disable-next-line: param-type-mismatch
        MenuManager.SetInputMask(PST.menuInputMask)
    elseif not Game():IsPauseMenuOpen() and not force then
        return
    else
        Game():GetHUD():SetVisible(true)
    end
    if not mute then
        SFXManager():Play(SoundEffect.SOUND_PAPER_OUT)
    end
    PST.treeScreen.modules.submenusModule:CloseSubmenu()
    PST.treeScreen.modules.menuScreensModule:CloseMenu()
    PST.treeScreen.backupsPopup = false
    PST.treeScreen.currentTree = "global"
    PST.treeScreen.open = false

    if Isaac.IsInGame() then
        OptionsMenu.SetSelectedElement(0)
    end
end