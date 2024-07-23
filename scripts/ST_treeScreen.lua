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

local currentTree = "global"
local hoveredNode = nil

local helpOpen = false
local treeControlDesc = {
    "WASD: pan camera",
    "Shift + V: re-center camera",
    "E: allocate hovered node",
    "R: respec hovered node",
    "Q: switch to selected character's tree",
    "Shift + Q: enable/disable tree effects next run"
}

local treeMenuOpen = false
local oldmask = nil

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
    helpOpen = false
    treeMenuOpen = false
    currentTree = "global"
end

-- Draw a 'node description box' next to screen center
local function drawNodeBox(name, description, screenW, screenH)
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
    if longestStrWidth > screenW / 2 then
        offX = offX - (longestStrWidth - screenW / 2)
    end

    -- Draw description background
    local descW = longestStrWidth + 4
    local descH = miniFont:GetLineHeight() * (#description + 1) + 4
    nodeBGSprite.Scale.X = descW
    nodeBGSprite.Scale.Y = descH
    nodeBGSprite.Color.A = 0.7
    nodeBGSprite:Render(Vector(screenW / 2 + offX - 2, screenH / 2 + offY - 2))

    miniFont:DrawString(name, screenW / 2 + offX, screenH / 2 + offY, KColor(1, 1, 1, 1))
    for i = 1, #description do
        local tmpStr = description[i]
        local tmpColor = KColor(1, 1, 1, 1)
        if type(tmpStr) == "table" then
            tmpStr = description[i][1]
            tmpColor = description[i][2]
        end
        miniFont:DrawString(tmpStr, screenW / 2 + offX + 6, screenH / 2 + offY + 14 * i, tmpColor)
    end
end

function PST:treeMenuRendering()
    local shiftHeld = Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, 0)
    local isCharMenu = MenuManager.GetActiveMenu() == MainMenuType.CHARACTER

    -- Input: V key
	if Input.IsButtonTriggered(Keyboard.KEY_V, 0) then
		if isCharMenu then
			if treeMenuOpen then
                -- Shift + V reset camera
                if shiftHeld then
                    treeCamera = Vector(defaultCamX, defaultCamY)
                else
                    PST:closeTreeMenu()
                end
			else
                PST:openTreeMenu()
			end
		end
	end

    if not treeMenuOpen and isCharMenu and PST.selectedMenuChar then
        local selCharName = PST.charNames[1 + PST.selectedMenuChar]
        local selCharData = PST.modData.charData[selCharName]
        if selCharData then
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
        if Input.IsButtonTriggered(Keyboard.KEY_ESCAPE, 0) then
            PST:closeTreeMenu()
        end

        treeBGSprite.Scale = Vector(screenW / 480, screenH / 270)
        treeBGSprite:Render(Vector(0, 0))

        -- Camera management & tree navigation
        local cameraSpeed = 3
        if shiftHeld then
            cameraSpeed = 8
        end
        if Input.IsButtonPressed(Keyboard.KEY_W, 0) then
            treeCamera.Y = treeCamera.Y - cameraSpeed
        elseif Input.IsButtonPressed(Keyboard.KEY_S, 0) then
            treeCamera.Y = treeCamera.Y + cameraSpeed
        end
        if Input.IsButtonPressed(Keyboard.KEY_A, 0) then
            treeCamera.X = treeCamera.X - cameraSpeed
        elseif Input.IsButtonPressed(Keyboard.KEY_D, 0) then
            treeCamera.X = treeCamera.X + cameraSpeed
        end

        local camCenterX = screenW / 2 + treeCamera.X
        local camCenterY = screenH / 2 + treeCamera.Y

        -- Draw node links
        for _, nodeLink in ipairs(PST.nodeLinks[currentTree]) do
            local linkX = nodeLink.pos.X * 38 + nodeLink.dirX * 19
            local linkY = nodeLink.pos.Y * 38 + nodeLink.dirY * 19

            local hasNode1 = PST:isNodeAllocated(currentTree, nodeLink.node1)
            local hasNode2 = PST:isNodeAllocated(currentTree, nodeLink.node2)
            if hasNode1 and hasNode2 then
                nodeLink.sprite:Play(nodeLink.type .. " Allocated", true)
            elseif hasNode1 or hasNode2 then
                nodeLink.sprite:Play(nodeLink.type .. " Available", true)
            else
                nodeLink.sprite:Play(nodeLink.type .. " Unavailable", true)
            end
            nodeLink.sprite:Render(Vector(linkX - treeCamera.X, linkY - treeCamera.Y))
        end

        -- Draw nodes
        local cosmicRChar = PST:getTreeMod("cosmicRealignment", false)
        hoveredNode = nil
        for _, node in pairs(PST.trees[currentTree]) do
            local nodeX = node.pos.X * 38
            local nodeY = node.pos.Y * 38
            node.sprite:Render(Vector(nodeX - treeCamera.X, nodeY - treeCamera.Y))

            if PST:isNodeAllocated(currentTree, node.id) then
                node.allocatedSprite:Render(Vector(nodeX - treeCamera.X, nodeY - treeCamera.Y))
            end

            if camCenterX >= nodeX - 15 and camCenterX <= nodeX + 15 and
            camCenterY >= nodeY - 15 and camCenterY <= nodeY + 15 then
                hoveredNode = node
            end

            -- Cosmic Realignment node, draw picked character
            if node.name == "Cosmic Realignment" and type(cosmicRChar) == "number" then
                local charName = PST.charNames[1 + cosmicRChar]
                PST.cosmicRData.charSprite.Color.A = 1
                PST.cosmicRData.charSprite:Play(charName, true)
                PST.cosmicRData.charSprite:Render(Vector(nodeX - treeCamera.X, nodeY - treeCamera.Y))
            end
        end

        -- Draw Cosmic Realignment menu
        PST.cosmicRData.hoveredCharID = nil
        if PST.cosmicRData.menuOpen then
            -- Draw BG
            nodeBGSprite.Scale.X = 164
            nodeBGSprite.Scale.Y = 24 + 32 * math.ceil(#PST.cosmicRData.characters / 5)
            nodeBGSprite.Color.A = 0.9
            local tmpBGX = PST.cosmicRData.menuX - 84
            local tmpBGY = PST.cosmicRData.menuY + 14
            nodeBGSprite:Render(Vector(tmpBGX - treeCamera.X, tmpBGY - treeCamera.Y))

            -- Stop node hovering while cursor is in this menu
            if camCenterX >= tmpBGX and camCenterX <= tmpBGX + nodeBGSprite.Scale.X and
            camCenterY >= tmpBGY and camCenterY <= tmpBGY + nodeBGSprite.Scale.Y then
                hoveredNode = nil
            end

            Isaac.RenderText("Cosmic Realignment", PST.cosmicRData.menuX - 54 - treeCamera.X, PST.cosmicRData.menuY + 20 - treeCamera.Y, 1, 1, 1, 1)

            local i = 1
            for charID, _ in pairs(PST.cosmicRData.characters) do
                local charName = PST.charNames[1 + charID]
                local charX = PST.cosmicRData.menuX - 64 + ((i - 1) % 5) * 32
                local charY = PST.cosmicRData.menuY + 52 + math.floor((i - 1) / 5) * 32

                -- Hovered
                if camCenterX > charX - 16 and camCenterX < charX + 16 and camCenterY > charY - 16 and camCenterY < charY + 16 then
                    PST.cosmicRData.hoveredCharID = charID
                    PST.cosmicRData.charSprite.Color.A = 1
                    PST.cosmicRData.charSprite:Play("Select", true)
                    PST.cosmicRData.charSprite:Render(Vector(charX - treeCamera.X, charY - treeCamera.Y))
                else
                    PST.cosmicRData.charSprite.Color.A = 0.4
                end

                if not PST:cosmicRIsCharUnlocked(charID) then
                    PST.cosmicRData.lockedCharSprite:Play(charName, true)
                    PST.cosmicRData.lockedCharSprite:Render(Vector(charX - treeCamera.X, charY - treeCamera.Y))

                    PST.cosmicRData.charSprite.Color.A = 1
                    PST.cosmicRData.charSprite:Play("Locked", true)
                    PST.cosmicRData.charSprite:Render(Vector(charX - treeCamera.X, charY - treeCamera.Y))
                else
                    PST.cosmicRData.charSprite:Play(charName, true)
                    PST.cosmicRData.charSprite:Render(Vector(charX - treeCamera.X, charY - treeCamera.Y))
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
                        "Can now unlock items as if playing as " .. tmpCharName .. ".", KColor(0.85, 0.85, 1, 1)
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

        -- Input: E key (allocate node)
        if Input.IsButtonTriggered(Keyboard.KEY_E, 0) then
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

        -- Input: R key (respec node)
        if Input.IsButtonTriggered(Keyboard.KEY_R, 0) then
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

        -- Input: Q key (switch tree)
        if Input.IsButtonTriggered(Keyboard.KEY_Q, 0) then
            if not shiftHeld then
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
            else
                -- Shift + Q, toggle tree
                PST.modData.treeDisabled = not PST.modData.treeDisabled
                PST:save()
                if PST.modData.treeDisabled then
                    sfx:Play(SoundEffect.SOUND_BEEP, 0.6)
                end
            end
        end

        -- Input: H key (toggle help menu)
        if Input.IsButtonTriggered(Keyboard.KEY_H, 0) then
            helpOpen = not helpOpen
        end

        -- Draw help menu
        if helpOpen then
            drawNodeBox("Tree Controls", treeControlDesc, screenW / 2, screenH / 2)
        end

        -- HUD data
        Isaac.RenderText(
            "Skill points: " .. skPoints .. " / Respecs: " .. PST.modData.respecPoints,
            8, 8, 1, 1, 1, 1
        )
        Isaac.RenderText(treeName, 8, 24, 1, 1, 1, 1)
        if PST.modData.treeDisabled then
            Isaac.RenderText("Tree effects disabled", 8, 40, 1, 0.4, 0.4, 1)
        end
        miniFont:DrawString("H: toggle help", 16, screenH - 24, KColor(1, 1, 1, 1))
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