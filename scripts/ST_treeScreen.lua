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

local treeMenuOpen = false
local oldmask = nil

-- Init cosmic realignment data
local cosmicRData = {
    menuOpen = false,
    menuX = 0,
    menuY = 0,
    charSprite = Sprite("gfx/ui/skilltrees/cosmic_realignment_chars.anm2", true),
    hoveredCharID = nil,
    characters = {
        PlayerType.PLAYER_ISAAC, PlayerType.PLAYER_MAGDALENE, PlayerType.PLAYER_CAIN, PlayerType.PLAYER_JUDAS, PlayerType.PLAYER_BLUEBABY,
        PlayerType.PLAYER_EVE, PlayerType.PLAYER_SAMSON, PlayerType.PLAYER_AZAZEL, PlayerType.PLAYER_LAZARUS, PlayerType.PLAYER_EDEN,
        PlayerType.PLAYER_THELOST, PlayerType.PLAYER_LILITH, PlayerType.PLAYER_KEEPER, PlayerType.PLAYER_APOLLYON, PlayerType.PLAYER_THEFORGOTTEN,
        PlayerType.PLAYER_BETHANY, PlayerType.PLAYER_JACOB,
        PlayerType.PLAYER_ISAAC_B, PlayerType.PLAYER_MAGDALENE_B, PlayerType.PLAYER_CAIN_B, PlayerType.PLAYER_JUDAS_B, PlayerType.PLAYER_BLUEBABY_B,
        PlayerType.PLAYER_EVE_B, PlayerType.PLAYER_SAMSON_B, PlayerType.PLAYER_AZAZEL_B, PlayerType.PLAYER_LAZARUS_B, PlayerType.PLAYER_EDEN_B,
        PlayerType.PLAYER_THELOST_B, PlayerType.PLAYER_LILITH_B, PlayerType.PLAYER_KEEPER_B, PlayerType.PLAYER_APOLLYON_B, PlayerType.PLAYER_THEFORGOTTEN_B,
        PlayerType.PLAYER_BETHANY_B, PlayerType.PLAYER_JACOB_B
    },
}

function PST:openTreeMenu()
    oldmask = MenuManager.GetInputMask()
    ---@diagnostic disable-next-line: param-type-mismatch
    MenuManager.SetInputMask(0)
    sfx:Play(SoundEffect.SOUND_PAPER_IN)
    treeMenuOpen = true
end

function PST:closeTreeMenu()
    if oldmask ~= nil then
        MenuManager.SetInputMask(oldmask)
        oldmask = nil
    end
    sfx:Play(SoundEffect.SOUND_PAPER_OUT)
    cosmicRData.menuOpen = false
    treeMenuOpen = false
    currentTree = "global"
end

function PST:treeMenuRendering()
    local shiftHeld = Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, 0)

    -- Input: V key
	if Input.IsButtonTriggered(Keyboard.KEY_V, 0) then
		if MenuManager.GetActiveMenu() == MainMenuType.CHARACTER then
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
                cosmicRData.charSprite.Color.A = 1
                cosmicRData.charSprite:Play(charName, true)
                cosmicRData.charSprite:Render(Vector(nodeX - treeCamera.X, nodeY - treeCamera.Y))
            end
        end

        -- Draw Cosmic Realignment menu
        cosmicRData.hoveredCharID = nil
        if cosmicRData.menuOpen then
            -- Draw BG
            nodeBGSprite.Scale.X = 164
            nodeBGSprite.Scale.Y = 24 + 32 * math.ceil(#cosmicRData.characters / 5)
            nodeBGSprite.Color.A = 0.9
            local tmpBGX = cosmicRData.menuX - 84
            local tmpBGY = cosmicRData.menuY + 14
            nodeBGSprite:Render(Vector(tmpBGX - treeCamera.X, tmpBGY - treeCamera.Y))

            -- Stop node hovering while cursor is in this menu
            if camCenterX >= tmpBGX and camCenterX <= tmpBGX + nodeBGSprite.Scale.X and
            camCenterY >= tmpBGY and camCenterY <= tmpBGY + nodeBGSprite.Scale.Y then
                hoveredNode = nil
            end

            Isaac.RenderText("Cosmic Realignment", cosmicRData.menuX - 54 - treeCamera.X, cosmicRData.menuY + 20 - treeCamera.Y, 1, 1, 1, 1)

            for i, charID in ipairs(cosmicRData.characters) do
                local charName = PST.charNames[1 + charID]
                local charX = cosmicRData.menuX - 64 + ((i - 1) % 5) * 32
                local charY = cosmicRData.menuY + 52 + math.floor((i - 1) / 5) * 32

                -- Hovered
                if camCenterX > charX - 16 and camCenterX < charX + 16 and camCenterY > charY - 16 and camCenterY < charY + 16 then
                    cosmicRData.hoveredCharID = charID
                    cosmicRData.charSprite.Color.A = 1
                    cosmicRData.charSprite:Play("Select", true)
                    cosmicRData.charSprite:Render(Vector(charX - treeCamera.X, charY - treeCamera.Y))
                else
                    cosmicRData.charSprite.Color.A = 0.4
                end

                cosmicRData.charSprite:Play(charName, true)
                cosmicRData.charSprite:Render(Vector(charX - treeCamera.X, charY - treeCamera.Y))
            end
        end

        -- Cursor and node description
        if hoveredNode ~= nil then
            cursorSprite:Play("Clicked")

            -- Base offset from center cursor
            local offX = 4
            local offY = 10

            local descName = hoveredNode.name
            -- Cosmic Realignment node, show picked character name
            if hoveredNode.name == "Cosmic Realignment" and type(cosmicRChar) == "number" then
                descName = descName .. " (" .. PST.charNames[1 + cosmicRChar] .. ")"
            end

            -- Calculate longest description line, and offset accordingly
            local longestStr = descName
            for i = 1, #hoveredNode.description do
                if string.len(hoveredNode.description[i]) > string.len(longestStr) then
                    longestStr = hoveredNode.description[i]
                end
            end
            local longestStrWidth = 8 + offX + miniFont:GetStringWidth(longestStr)
            if longestStrWidth > screenW / 2 then
                offX = offX - (longestStrWidth - screenW / 2)
            end

            -- Draw description background
            local descW = longestStrWidth + 4
            local descH = miniFont:GetLineHeight() * (#hoveredNode.description + 1) + 4
            nodeBGSprite.Scale.X = descW
            nodeBGSprite.Scale.Y = descH
            nodeBGSprite.Color.A = 0.7
            nodeBGSprite:Render(Vector(screenW / 2 + offX - 2, screenH / 2 + offY - 2))

            miniFont:DrawString(descName, screenW / 2 + offX, screenH / 2 + offY, KColor(1, 1, 1, 1))
            for i = 1, #hoveredNode.description do
                miniFont:DrawString(hoveredNode.description[i], screenW / 2 + offX + 6, screenH / 2 + offY + 14 * i, KColor(1, 1, 1, 1))
            end
        -- Cosmic Realignment node, hovered character name
        elseif cosmicRData.hoveredCharID ~= nil then
            cursorSprite:Play("Clicked")
            miniFont:DrawString(PST.charNames[1 + cosmicRData.hoveredCharID], screenW / 2 + 20, screenH / 2 - 4, KColor(1, 1, 1, 1))
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
                    sfx:Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 0.75)
                elseif not PST:isNodeAllocated(currentTree, hoveredNode.id) then
                    sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
                else
                    -- Cosmic Realignment node, open/close menu
                    if hoveredNode.name == "Cosmic Realignment" then
                        sfx:Play(SoundEffect.SOUND_BUTTON_PRESS, 1)
                        cosmicRData.menuOpen = not cosmicRData.menuOpen
                        cosmicRData.menuX = hoveredNode.pos.X * 38
                        cosmicRData.menuY = hoveredNode.pos.Y * 38
                    end
                end
            -- Cosmic Realignment node, pick hovered character
            elseif cosmicRData.hoveredCharID ~= nil then
                PST:addModifiers({
                    cosmicRealignment = { value = cosmicRData.hoveredCharID, set = true }
                })
                sfx:Play(SoundEffect.SOUND_BUTTON_PRESS, 1)
                cosmicRData.menuOpen = false
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
                        cosmicRData.menuOpen = false
                    end
                elseif PST:isNodeAllocated(currentTree, hoveredNode.id) then
                    sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
                end
            end
        end

        -- Input: Q key (switch tree)
        if Input.IsButtonTriggered(Keyboard.KEY_Q, 0) then
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

        -- HUD data
        Isaac.RenderText(
            "Skill points: " .. skPoints .. " / Respecs: " .. PST.modData.respecPoints,
            8, 8, 1, 1, 1, 1
        )
        Isaac.RenderText(treeName, 8, 24, 1, 1, 1, 1)
        miniFont:DrawString("WASD: pan, Shift+V: re-center, E: allocate, R: respec, Q: switch tree", 8, (screenH - 16), KColor(1, 1, 1, 1))
    end
end

PST:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, PST.treeMenuRendering)