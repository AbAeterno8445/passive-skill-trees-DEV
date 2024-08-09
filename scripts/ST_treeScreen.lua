include("scripts.tree_data.nodes")

local sfx = SFXManager()

local miniFont = Font()
miniFont:Load("font/cjk/lanapixel.fnt")

local treeBGSprite = Sprite("gfx/ui/skilltrees/tree_bg.anm2", true)
treeBGSprite:Play("Default", true)

local nodeBGSprite = Sprite("gfx/ui/skilltrees/tree_bg.anm2", true)
nodeBGSprite:Play("Pixel", true)
nodeBGSprite.Color.A = 0.7

local cursorSprite = Sprite("gfx/ui/cursor.anm2", true)
cursorSprite.Color.A = 0.7
cursorSprite:Play("Idle", true)

local defaultCamX = -Isaac.GetScreenWidth() / 2
local defaultCamY = -Isaac.GetScreenHeight() / 2
local treeCamera = Vector(defaultCamX, defaultCamY)
local camZoomOffset = Vector(0, 0)
local zoomScale = 1

local currentTree = "global"
local hoveredNode = nil

local totalModsMenuOpen = false
local totalModsMenuY = 0
local totalModsList = {}

local helpOpen = ""
local treeControlDesc = {
    "WASD / Arrow keys: pan camera",
    "Shift + V: re-center camera",
    "Z / Shift + Z: zoom in/out",
    "E: allocate hovered node",
    "R: respec hovered node",
    "Q: switch to selected character's tree",
    "Shift + Q: enable/disable tree effects next run",
    "Shift + H: display a list of all active modifiers"
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

local treeMenuOpen = false
local oldmask = nil

local function PST_updateCamZoomOffset()
    local translateX = -Isaac.GetScreenWidth() / 2 - treeCamera.X
    local translateY = -Isaac.GetScreenHeight() / 2 - treeCamera.Y
    camZoomOffset.X = translateX - translateX * zoomScale
    camZoomOffset.Y = translateY - translateY * zoomScale
end

function PST:openTreeMenu()
    oldmask = MenuManager.GetInputMask()
    ---@diagnostic disable-next-line: param-type-mismatch
    MenuManager.SetInputMask(0)
    sfx:Play(SoundEffect.SOUND_PAPER_IN)
    treeMenuOpen = true
end

function PST:closeTreeMenu(mute)
    if oldmask ~= nil then
        MenuManager.SetInputMask(oldmask)
        oldmask = nil
    end
    if not mute then 
        sfx:Play(SoundEffect.SOUND_PAPER_OUT)
    end
    PST.cosmicRData.menuOpen = false
    helpOpen = ""
    totalModsMenuOpen = false
    treeMenuOpen = false
    currentTree = "global"
end

-- Draw a 'node description box' next to screen center
local function drawNodeBox(name, description, paramX, paramY, absolute, bgAlpha)
    -- Base offset from center cursor
    local offX = 4
    local offY = 10

    -- Calculate longest description line, and offset accordingly
    local longestStr = name
    for i = 1, #description do
        local tmpStr = description[i]
        if type(tmpStr) == "table" then
            tmpStr = description[i][1]
        end
        if string.len(tmpStr) > string.len(longestStr) then
            longestStr = tmpStr
        end
    end
    local longestStrWidth = 8 + offX + miniFont:GetStringWidth(longestStr)
    if longestStrWidth > paramX / 2 then
        offX = offX - (longestStrWidth - paramX / 2)
    end

    -- Draw description background
    local drawX = paramX / 2 + offX
    local drawY = paramY / 2 + offY
    if absolute then
        drawX = paramX
        drawY = paramY
    end

    local descW = longestStrWidth + 4
    local descH = (miniFont:GetLineHeight() + 2) * (#description + 1) + 4
    nodeBGSprite.Scale.X = descW
    nodeBGSprite.Scale.Y = descH
    nodeBGSprite.Color.A = bgAlpha or 0.7
    nodeBGSprite:Render(Vector(drawX - 2, drawY - 2))

    miniFont:DrawString(name, drawX, drawY, KColor(1, 1, 1, 1))
    for i = 1, #description do
        local tmpStr = description[i]
        local tmpColor = KColor(1, 1, 1, 1)
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
        miniFont:DrawString(tmpStr, drawX + 6, drawY + 14 * i, tmpColor)
    end
end

function PST:treeMenuRendering()
    local isCharMenu = MenuManager.GetActiveMenu() == MainMenuType.CHARACTER

    -- Input: Open tree menu
    if PST:isKeybindActive(PSTKeybind.OPEN_TREE) then
        if isCharMenu then
            if treeMenuOpen then
                PST:closeTreeMenu()
            else
                PST:openTreeMenu()
            end
        end
    end

    if not treeMenuOpen and isCharMenu and PST.selectedMenuChar then
        local selCharName = PST.charNames[1 + PST.selectedMenuChar]
        local selCharData = PST.modData.charData[selCharName]
        if selCharData and PST.config.charSelectInfoText then
            local tmpStr = selCharName .. " LV " .. selCharData.level
            tmpStr = tmpStr .. " (V to open tree)"
            if PST.modData.treeDisabled then
                tmpStr = tmpStr .. " (tree disabled)"
            end
            miniFont:DrawString(
                tmpStr,
                Isaac.GetScreenWidth() / 2 - string.len(tmpStr) * 2,
                Isaac.GetScreenHeight() - 18,
                KColor(1, 0.8, 1, 1)
            )
        end
    end

    if treeMenuOpen then
        local screenW = Isaac.GetScreenWidth()
        local screenH = Isaac.GetScreenHeight()

        local skPoints = PST.modData.skillPoints
        local treeName = "Global Tree"
        if currentTree ~= "global" then
            skPoints = PST.modData.charData[currentTree].skillPoints
            treeName = currentTree .. "'s Tree"
        end

        -- Close with ESC
        if PST:isKeybindActive(PSTKeybind.CLOSE_TREE) then
            if totalModsMenuOpen then
                sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)
                totalModsMenuOpen = false
            else
                PST:closeTreeMenu()
            end
        end

        treeBGSprite.Scale = Vector(screenW / 480, screenH / 270)
        treeBGSprite:Render(Vector.Zero)

        -- Camera management & tree navigation
        local cameraSpeed = 3 * (1 + 1 - zoomScale)
        if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
            cameraSpeed = 8 * (1 + 1 - zoomScale)
        end
        if PST:isKeybindActive(PSTKeybind.TREE_PAN_UP, true) then
            if not totalModsMenuOpen then
                treeCamera.Y = treeCamera.Y - cameraSpeed
                PST_updateCamZoomOffset()
            else
                totalModsMenuY = math.min(0, totalModsMenuY + cameraSpeed)
            end
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_DOWN, true) then
            if not totalModsMenuOpen then
                treeCamera.Y = treeCamera.Y + cameraSpeed
                PST_updateCamZoomOffset()
            else
                totalModsMenuY = totalModsMenuY - cameraSpeed
            end
        end
        if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT, true) then
            if not totalModsMenuOpen then
                treeCamera.X = treeCamera.X - cameraSpeed
                PST_updateCamZoomOffset()
            end
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT, true) then
            if not totalModsMenuOpen then
                treeCamera.X = treeCamera.X + cameraSpeed
                PST_updateCamZoomOffset()
            end
        end

        local camCenterX = screenW / 2 + treeCamera.X + camZoomOffset.X
        local camCenterY = screenH / 2 + treeCamera.Y + camZoomOffset.Y

        -- Draw node links
        for _, nodeLink in ipairs(PST.nodeLinks[currentTree]) do
            local linkX = nodeLink.pos.X * 38 * zoomScale + nodeLink.dirX * 19 * zoomScale
            local linkY = nodeLink.pos.Y * 38 * zoomScale + nodeLink.dirY * 19 * zoomScale

            local hasNode1 = PST:isNodeAllocated(currentTree, nodeLink.node1)
            local hasNode2 = PST:isNodeAllocated(currentTree, nodeLink.node2)
            if hasNode1 and hasNode2 then
                nodeLink.sprite:Play(nodeLink.type .. " Allocated", true)
            elseif hasNode1 or hasNode2 then
                nodeLink.sprite:Play(nodeLink.type .. " Available", true)
            else
                nodeLink.sprite:Play(nodeLink.type .. " Unavailable", true)
            end
            nodeLink.sprite.Scale = nodeLink.origScale * zoomScale
            nodeLink.sprite:Render(Vector(linkX - treeCamera.X - camZoomOffset.X, linkY - treeCamera.Y - camZoomOffset.Y))
        end

        -- Draw nodes
        local cosmicRChar = PST:getTreeMod("cosmicRealignment", false)
        hoveredNode = nil
        for _, node in pairs(PST.trees[currentTree]) do
            local nodeX = node.pos.X * 38 * zoomScale
            local nodeY = node.pos.Y * 38 * zoomScale
            node.sprite.Scale.X = zoomScale
            node.sprite.Scale.Y = zoomScale
            node.sprite:Render(Vector(nodeX - treeCamera.X - camZoomOffset.X, nodeY - treeCamera.Y - camZoomOffset.Y))

            if PST:isNodeAllocated(currentTree, node.id) then
                node.allocatedSprite.Scale.X = zoomScale
                node.allocatedSprite.Scale.Y = zoomScale
                node.allocatedSprite:Render(Vector(nodeX - treeCamera.X - camZoomOffset.X, nodeY - treeCamera.Y - camZoomOffset.Y))
            end

            local nodeHalf = 15 * zoomScale
            if camCenterX >= nodeX - nodeHalf and camCenterX <= nodeX + nodeHalf and
            camCenterY >= nodeY - nodeHalf and camCenterY <= nodeY + nodeHalf then
                hoveredNode = node
            end

            -- Cosmic Realignment node, draw picked character
            if node.name == "Cosmic Realignment" and type(cosmicRChar) == "number" then
                local charName = PST.charNames[1 + cosmicRChar]
                PST.cosmicRData.charSprite.Color.A = 1
                PST.cosmicRData.charSprite.Scale.X = zoomScale
                PST.cosmicRData.charSprite.Scale.Y = zoomScale
                PST.cosmicRData.charSprite:Play(charName, true)
                PST.cosmicRData.charSprite:Render(Vector(nodeX - treeCamera.X - camZoomOffset.X, nodeY - treeCamera.Y - camZoomOffset.Y))
            end

            -- Debug: show node IDs
            if PST.debugOptions.drawNodeIDs then
                Isaac.RenderText(tostring(node.id), nodeX - treeCamera.X - camZoomOffset.X - 12, nodeY - treeCamera.Y - camZoomOffset.Y - 12, 1, 1, 1, 1)
            end
        end

        -- Draw Cosmic Realignment menu
        PST.cosmicRData.hoveredCharID = nil
        if PST.cosmicRData.menuOpen then
            -- Draw BG
            nodeBGSprite.Scale.X = 164
            nodeBGSprite.Scale.Y = 24 + 32 * math.ceil(#PST.cosmicRData.characters / 5)
            nodeBGSprite.Color.A = 0.9
            local tmpBGX = PST.cosmicRData.menuX * zoomScale - 84
            local tmpBGY = PST.cosmicRData.menuY * zoomScale + 14
            nodeBGSprite:Render(Vector(tmpBGX - treeCamera.X - camZoomOffset.X, tmpBGY - treeCamera.Y - camZoomOffset.Y))

            -- Stop node hovering while cursor is in this menu
            if camCenterX >= tmpBGX and camCenterX <= tmpBGX + nodeBGSprite.Scale.X and
            camCenterY >= tmpBGY and camCenterY <= tmpBGY + nodeBGSprite.Scale.Y then
                hoveredNode = nil
            end

            Isaac.RenderText(
                "Cosmic Realignment",
                PST.cosmicRData.menuX * zoomScale - 54 - treeCamera.X - camZoomOffset.X,
                PST.cosmicRData.menuY * zoomScale + 20 - treeCamera.Y - camZoomOffset.Y,
                1, 1, 1, 1
            )

            local i = 1
            for charID, _ in pairs(PST.cosmicRData.characters) do
                local charName = PST.charNames[1 + charID]
                local charX = PST.cosmicRData.menuX * zoomScale - 64 + ((i - 1) % 5) * 32
                local charY = PST.cosmicRData.menuY * zoomScale + 52 + math.floor((i - 1) / 5) * 32

                -- Hovered
                PST.cosmicRData.charSprite.Scale.X = 1
                PST.cosmicRData.charSprite.Scale.Y = 1
                if camCenterX > charX - 16 and camCenterX < charX + 16 and camCenterY > charY - 16 and camCenterY < charY + 16 then
                    PST.cosmicRData.hoveredCharID = charID
                    PST.cosmicRData.charSprite.Color.A = 1
                    PST.cosmicRData.charSprite:Play("Select", true)
                    PST.cosmicRData.charSprite:Render(Vector(charX - treeCamera.X - camZoomOffset.X, charY - treeCamera.Y - camZoomOffset.Y))
                else
                    PST.cosmicRData.charSprite.Color.A = 0.4
                end

                if not PST:cosmicRIsCharUnlocked(charID) then
                    PST.cosmicRData.lockedCharSprite:Play(charName, true)
                    PST.cosmicRData.lockedCharSprite:Render(Vector(charX - treeCamera.X - camZoomOffset.X, charY - treeCamera.Y - camZoomOffset.Y))

                    PST.cosmicRData.charSprite.Color.A = 1
                    PST.cosmicRData.charSprite:Play("Locked", true)
                    PST.cosmicRData.charSprite:Render(Vector(charX - treeCamera.X - camZoomOffset.X, charY - treeCamera.Y - camZoomOffset.Y))
                else
                    PST.cosmicRData.charSprite:Play(charName, true)
                    PST.cosmicRData.charSprite:Render(Vector(charX - treeCamera.X - camZoomOffset.X, charY - treeCamera.Y - camZoomOffset.Y))
                end

                i = i + 1
            end
        end

        -- Cursor and node description
        if hoveredNode ~= nil then
            cursorSprite:Play("Clicked")

            local descName = hoveredNode.name
            local tmpDescription = hoveredNode.description
            -- Cosmic Realignment node, show picked character name & curse description
            if hoveredNode.name == "Cosmic Realignment" then
                if type(cosmicRChar) == "number" then
                    local tmpCharName = PST.charNames[1 + cosmicRChar]
                    descName = descName .. " (" .. tmpCharName .. ")"
                    tmpDescription = {}
                    if PST.cosmicRData.characters[cosmicRChar].curseDesc then
                        for _, descLine in ipairs(PST.cosmicRData.characters[cosmicRChar].curseDesc) do
                            table.insert(tmpDescription, descLine)
                        end
                    end
                    table.insert(tmpDescription, {
                        "Can now get unlocks as if playing as " .. tmpCharName .. ".", KColor(0.85, 0.85, 1, 1)
                    })
                elseif PST:isNodeAllocated(currentTree, hoveredNode.id) then
                    descName = descName .. " (E to pick character)"
                end
            end
            drawNodeBox(descName, tmpDescription or hoveredNode.description, screenW, screenH)
        -- Cosmic Realignment node, hovered character name & curse description
        elseif PST.cosmicRData.hoveredCharID ~= nil then
            cursorSprite:Play("Clicked")

            local charID = PST.cosmicRData.hoveredCharID
            local tmpDescription = { "Unlock " .. PST.charNames[1 + charID] .. " to enable this option." }
            if PST:cosmicRIsCharUnlocked(charID) then
                tmpDescription = PST.cosmicRData.characters[charID].curseDesc
            end
            drawNodeBox(PST.charNames[1 + charID], tmpDescription, screenW, screenH)
        else
            cursorSprite:Play("Idle")
        end
        cursorSprite:Render(Vector(screenW / 2, screenH / 2))

        -- Input: Allocate node
        if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
            if hoveredNode ~= nil then
                if PST:isNodeAllocatable(currentTree, hoveredNode.id, true) then
                    if not PST.debugOptions.infSP then
                        if currentTree == "global" then
                            PST.modData.skillPoints = PST.modData.skillPoints - 1
                        else
                            PST.modData.charData[currentTree].skillPoints = PST.modData.charData[currentTree].skillPoints - 1
                        end
                    end
                    PST:allocateNodeID(currentTree, hoveredNode.id, true)
                    sfx:Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 0.5)

                    -- Lost tree, unlock holy mantle if allocating Sacred Aegis
                    if hoveredNode.name == "Sacred Aegis" and not Isaac.GetPersistentGameData():Unlocked(Achievement.LOST_HOLDS_HOLY_MANTLE) then
                        Isaac.GetPersistentGameData():TryUnlock(Achievement.LOST_HOLDS_HOLY_MANTLE)
                    end
                elseif not PST:isNodeAllocated(currentTree, hoveredNode.id) then
                    sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
                else
                    -- Cosmic Realignment node, open/close menu
                    if hoveredNode.name == "Cosmic Realignment" then
                        sfx:Play(SoundEffect.SOUND_BUTTON_PRESS, 1)
                        PST.cosmicRData.menuOpen = not PST.cosmicRData.menuOpen
                        PST.cosmicRData.menuX = hoveredNode.pos.X * 38
                        PST.cosmicRData.menuY = hoveredNode.pos.Y * 38
                    end
                end
            -- Cosmic Realignment node, pick hovered character
            elseif PST.cosmicRData.hoveredCharID ~= nil then
                if PST:cosmicRIsCharUnlocked(PST.cosmicRData.hoveredCharID) then
                    if not (cosmicRChar == PST.cosmicRData.hoveredCharID) then
                        PST:addModifiers({
                            cosmicRealignment = { value = PST.cosmicRData.hoveredCharID, set = true }
                        })
                    else
                        PST:addModifiers({
                            cosmicRealignment = { value = true, set = true }
                        })
                    end
                    sfx:Play(SoundEffect.SOUND_BUTTON_PRESS, 1)
                    PST.cosmicRData.menuOpen = false
                else
                    sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
                end
            end
        end

        -- Input: Respec node
        if PST:isKeybindActive(PSTKeybind.RESPEC_NODE) then
            if hoveredNode ~= nil then
                if PST:isNodeAllocatable(currentTree, hoveredNode.id, false) then
                    if not PST.debugOptions.infRespec then
                        PST.modData.respecPoints = PST.modData.respecPoints - 1
                    end
                    if not PST.debugOptions.infSP then
                        if currentTree == "global" then
                            PST.modData.skillPoints = PST.modData.skillPoints + 1
                        else
                            PST.modData.charData[currentTree].skillPoints = PST.modData.charData[currentTree].skillPoints + 1
                        end
                    end
                    PST:allocateNodeID(currentTree, hoveredNode.id, false)
                    sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.75)

                    -- Respec Cosmic Realignment node
                    if hoveredNode.name == "Cosmic Realignment" then
                        PST:addModifiers({ cosmicRealignment = false })
                        PST.cosmicRData.menuOpen = false
                    end
                elseif PST:isNodeAllocated(currentTree, hoveredNode.id) then
                    sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
                end
            end
        end

        -- Input: Switch tree
        if PST:isKeybindActive(PSTKeybind.SWITCH_TREE) then
            local selectedCharName = PST.charNames[1 + PST.selectedMenuChar]
            if PST.trees[selectedCharName] ~= nil then
                if currentTree == "global" then
                    currentTree = selectedCharName
                else
                    currentTree = "global"
                end
                sfx:Play(SoundEffect.SOUND_BUTTON_PRESS, 1)
            else
                sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
            end
        end

        -- Input: Toggle tree effects
        if PST:isKeybindActive(PSTKeybind.TOGGLE_TREE_MODS) then
            PST.modData.treeDisabled = not PST.modData.treeDisabled
            PST:save()
            if PST.modData.treeDisabled then
                sfx:Play(SoundEffect.SOUND_BEEP, 0.6)
            end
        end

        -- Input: Toggle help menu
        if PST:isKeybindActive(PSTKeybind.TOGGLE_HELP) then
            if helpOpen ~= "keyboard" then
                helpOpen = "keyboard"
            else
                helpOpen = ""
            end
            totalModsMenuOpen = false
        -- Input: Toggle help menu (controller)
        elseif PST:isKeybindActive(PSTKeybind.TOGGLE_HELP_CONTROLLER) then
            if helpOpen ~= "controller" then
                helpOpen = "controller"
            else
                helpOpen = ""
            end
            totalModsMenuOpen = false
        -- Input: Toggle total modifiers menu
        elseif PST:isKeybindActive(PSTKeybind.TOGGLE_TOTAL_MODS) then
            helpOpen = ""
            totalModsMenuY = 0
            totalModsMenuOpen = not totalModsMenuOpen
            sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)

            -- Compile list of active modifiers
            local sortedModNames = {}
            local tmpModsList = {}
            totalModsList = {}
            if totalModsMenuOpen then
                local function processTreeNodes(tmpTree)
                    for tmpNodeID, tmpNode in pairs(PST.trees[tmpTree]) do
                        if PST:isNodeAllocated(tmpTree, tmpNodeID) then
                            -- Create sorted table of modifier names
                            for tmpModName, _ in pairs(tmpNode.modifiers) do
                                if PST.treeModDescriptions[tmpModName] ~= nil and not PST:arrHasValue(sortedModNames, tmpModName) then
                                    table.insert(sortedModNames, tmpModName)
                                end
                            end

                            -- Create table with totals for each modifier
                            for tmpModName, tmpModVal in pairs(tmpNode.modifiers) do
                                if tmpModsList[tmpModName] == nil then
                                    tmpModsList[tmpModName] = tmpModVal
                                elseif type(tmpModsList[tmpModName]) == "number" then
                                    tmpModsList[tmpModName] = tmpModsList[tmpModName] + tmpModVal
                                end
                            end
                        end
                    end
                end
                processTreeNodes("global")
                if PST.trees[PST.charNames[1 + PST.selectedMenuChar]] then
                    processTreeNodes(PST.charNames[1 + PST.selectedMenuChar])
                end

                table.sort(sortedModNames, function(a, b)
                    if PST.treeModDescriptions[a] == nil or PST.treeModDescriptions[b] == nil then
                        return false
                    end
                    return PST.treeModDescriptions[a].sort < PST.treeModDescriptions[b].sort
                end)

                -- Create final description table
                local lastCategory = nil
                for _, tmpModName in ipairs(sortedModNames) do
                    local tmpModVal = tmpModsList[tmpModName]
                    local modStr = PST.treeModDescriptions[tmpModName].str

                    -- Category change
                    local categorySwitch = lastCategory == nil
                    if lastCategory ~= nil and lastCategory ~= PST.treeModDescriptions[tmpModName].category then
                        table.insert(totalModsList, "")
                        categorySwitch = true
                    end
                    lastCategory = PST.treeModDescriptions[tmpModName].category

                    local tmpColor = KColor(1, 1, 1, 1)
                    if PST.treeModDescriptionCategories[lastCategory] then
                        tmpColor = PST.treeModDescriptionCategories[lastCategory].color
                    end
                    -- Mom heart proc mods - show as disabled if mom's heart needs to be re-defeated
                    if PST.modData.momHeartProc[tmpModName] == false then
                        tmpColor = KColor(0.5, 0.5, 0.5, 1)
                    end

                    -- Category title
                    if categorySwitch then
                        local tmpName = PST.treeModDescriptionCategories[lastCategory].name
                        if lastCategory == "charTree" then
                            tmpName = PST.charNames[1 + PST.selectedMenuChar] .. "'s tree:"
                        end
                        table.insert(totalModsList, {"---- " .. tmpName .. " ----", PST.treeModDescriptionCategories[lastCategory].color})
                    end
                    if type(modStr) == "table" then
                        for _, tmpLine in ipairs(modStr) do
                            local tmpStr = ""
                            if PST.treeModDescriptions[tmpModName].addPlus then
                                tmpStr = string.format(tmpLine, tmpModVal >= 0 and "+" or "", tmpModVal)
                            else
                                tmpStr = string.format(tmpLine, tmpModVal, tmpModVal, tmpModVal)
                            end
                            -- Harmonic modifiers, check if disabled
                            if PST:strStartsWith(tmpLine, "   [Harmonic]") and PST:songNodesAllocated() > 2 then
                                tmpColor = KColor(0.5, 0.5, 0.5, 1)
                            end
                            table.insert(totalModsList, {tmpStr, tmpColor})
                        end
                    else
                        local tmpStr = ""
                        if PST.treeModDescriptions[tmpModName].addPlus then
                            tmpStr = string.format(modStr, tmpModVal >= 0 and "+" or "", tmpModVal)
                        else
                            tmpStr = string.format(modStr, tmpModVal, tmpModVal, tmpModVal)
                        end
                        table.insert(totalModsList, {tmpStr, tmpColor})
                    end

                    if PST.modData.momHeartProc[tmpModName] == false then
                        table.insert(totalModsList, {"   Inactive until Mom's Heart is defeated again.", KColor(1, 0.6, 0.6, 1)})
                    end
                end

                -- Add Cosmic Realignment mod to description table
                if type(cosmicRChar) == "number" then
                    local tmpCharName = PST.charNames[1 + cosmicRChar]
                    table.insert(totalModsList, "")
                    table.insert(totalModsList, {
                        "Cosmic Realignment (" .. tmpCharName .. ")",
                        KColor(0.85, 0.85, 1, 1)
                    })
                    table.insert(totalModsList, {
                        "Can now get unlocks as if playing as " .. tmpCharName,
                        KColor(0.85, 0.85, 1, 1)
                    })
                end
            end
        end

        if Isaac.GetFrameCount() % 2 == 0 then
            -- Input: Zoom in
            if PST:isKeybindActive(PSTKeybind.ZOOM_IN, true) and zoomScale < 1 then
                zoomScale = zoomScale + 0.1
                PST_updateCamZoomOffset()
            -- Input: Zoom out
            elseif PST:isKeybindActive(PSTKeybind.ZOOM_OUT, true) and zoomScale > 0.6 then
                zoomScale = zoomScale - 0.1
                PST_updateCamZoomOffset()
            end
        end

        -- Input: Center camera
        if PST:isKeybindActive(PSTKeybind.CENTER_CAMERA) then
            treeCamera = Vector(-Isaac.GetScreenWidth() / 2, -Isaac.GetScreenHeight() / 2)
            camZoomOffset.X = 0
            camZoomOffset.Y = 0
        end

        if not totalModsMenuOpen then
            -- HUD data
            Isaac.RenderText(
                "Skill points: " .. skPoints .. " / Respecs: " .. PST.modData.respecPoints,
                8, 8, 1, 1, 1, 1
            )
            Isaac.RenderText(treeName, 8, 24, 1, 1, 1, 1)
            if PST.modData.treeDisabled then
                Isaac.RenderText("Tree effects disabled", 8, 40, 1, 0.4, 0.4, 1)
            end
        end
        miniFont:DrawString("H / Select: toggle help", 16, screenH - 24, KColor(1, 1, 1, 1))

        -- Draw help menu
        if helpOpen == "keyboard" then
            drawNodeBox("Tree Controls", treeControlDesc, screenW / 2, screenH / 2)
        elseif helpOpen == "controller" then
            drawNodeBox("Tree Controls (Controller)", treeControlDescController, screenW / 2, screenH / 2)
        -- Draw total modifiers menu
        elseif totalModsMenuOpen then
            drawNodeBox("Active Modifiers", totalModsList, 16, 16 + totalModsMenuY, true, 1)
        end
    end
end

-- Render Cosmic Realignment completion marks on relevant characters (original marks take priority)
local markLayerOverrides = {
    [CompletionType.ULTRA_GREEDIER] = 8,
    [CompletionType.DELIRIUM] = 0,
    [CompletionType.MOTHER] = 10,
    [CompletionType.BEAST] = 11
}
function PST:cosmicRMarksRender(markSprite, markPos, markScale, playerType)
    local pTypeStr = tostring(playerType)
    local markPathNormal = "gfx/ui/completion_widget.png"
    local markPathCosmic = "gfx/ui/skilltrees/completion_widget_cosmic.png"
    if Game():IsPauseMenuOpen() then
        markPathNormal = "gfx/ui/completion_widget_pause.png"
        markPathCosmic = "gfx/ui/skilltrees/completion_widget_pause_cosmic.png"
    end

    for i=0,14 do
        local layerID = i + 1
        if markLayerOverrides[i] ~= nil then
            layerID = markLayerOverrides[i]
        end

        if PST.modData.cosmicRCompletions[pTypeStr] ~= nil then
            local hasMark = Isaac.GetCompletionMark(playerType, i)
            if PST.modData.cosmicRCompletions[pTypeStr][i .. "hard"] and hasMark < 2 then
                markSprite:ReplaceSpritesheet(layerID, markPathCosmic, true)
                markSprite:SetLayerFrame(layerID, 2)
            elseif PST.modData.cosmicRCompletions[pTypeStr][tostring(i)] and hasMark == 0 then
                markSprite:ReplaceSpritesheet(layerID, markPathCosmic, true)
                markSprite:SetLayerFrame(layerID, 1)
            else
                markSprite:ReplaceSpritesheet(layerID, markPathNormal, true)
            end
        else
            markSprite:ReplaceSpritesheet(layerID, markPathNormal, true)
        end
    end
end

PST:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, PST.treeMenuRendering)
PST:AddCallback(ModCallbacks.MC_PRE_COMPLETION_MARKS_RENDER, PST.cosmicRMarksRender)