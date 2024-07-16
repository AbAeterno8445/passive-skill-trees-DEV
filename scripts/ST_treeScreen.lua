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

local hoveredNode = nil

local treeKeyHeld = {
    [Keyboard.KEY_V] = false,
    [Keyboard.KEY_E] = false,
    [Keyboard.KEY_R] = false
}
local treeMenuOpen = false
local oldmask = nil

function SkillTrees:openTreeMenu()
    oldmask = MenuManager.GetInputMask()
    ---@diagnostic disable-next-line: param-type-mismatch
    MenuManager.SetInputMask(0)
    treeMenuOpen = true
end

function SkillTrees:closeTreeMenu()
    if oldmask ~= nil then
        MenuManager.SetInputMask(oldmask)
        oldmask = nil
    end
    treeMenuOpen = false
end

function SkillTrees:treeMenuRendering()
    local shiftHeld = Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, 0)

	if Input.IsButtonPressed(Keyboard.KEY_V, 0) and not treeKeyHeld[Keyboard.KEY_V] then
		treeKeyHeld[Keyboard.KEY_V] = true
		if MenuManager.GetActiveMenu() == MainMenuType.CHARACTER then
			if treeMenuOpen then
                -- Shift + V reset camera
                if shiftHeld then
                    treeCamera = Vector(defaultCamX, defaultCamY)
                else
                    SkillTrees:closeTreeMenu()
                end
			else
                SkillTrees:openTreeMenu()
			end
		end
	elseif not Input.IsButtonPressed(Keyboard.KEY_V, 0) then
		treeKeyHeld[Keyboard.KEY_V] = false
	end

    if treeMenuOpen then
        local screenW = Isaac.GetScreenWidth()
        local screenH = Isaac.GetScreenHeight()

        -- Close with ESC
        if Input.IsButtonPressed(Keyboard.KEY_ESCAPE, 0) then
            SkillTrees:closeTreeMenu()
        end

        treeBGSprite.Scale = Vector(screenW / 480, screenH / 270)
        treeBGSprite:Render(Vector(0, 0))

        -- Camera management & tree navigation
        local cameraSpeed = 2
        if shiftHeld then
            cameraSpeed = 6
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
        for _, nodeLink in ipairs(SkillTrees.nodeData.nodeLinks) do
            local linkX = nodeLink.pos.X * 38 + nodeLink.dirX * 19
            local linkY = nodeLink.pos.Y * 38 + nodeLink.dirY * 19

            local hasNode1 = SkillTrees:isNodeAllocated(nodeLink.node1)
            local hasNode2 = SkillTrees:isNodeAllocated(nodeLink.node2)
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
        hoveredNode = nil
        for _, node in pairs(SkillTrees.nodeData.global) do
            local nodeX = node.pos.X * 38
            local nodeY = node.pos.Y * 38
            node.sprite:Render(Vector(nodeX - treeCamera.X, nodeY - treeCamera.Y))

            if SkillTrees:isNodeAllocated(node.id) then
                node.allocatedSprite:Render(Vector(nodeX - treeCamera.X, nodeY - treeCamera.Y))
            end

            -- Debug, show ID
            Isaac.RenderText(tostring(node.id), nodeX - treeCamera.X + 14, nodeY - treeCamera.Y + 14, 1, 1, 1, 0.7)

            if camCenterX >= nodeX - 15 and camCenterX <= nodeX + 15 and
            camCenterY >= nodeY - 15 and camCenterY <= nodeY + 15 then
                hoveredNode = node
            end
        end

        -- Cursor and node description
        if hoveredNode ~= nil then
            cursorSprite:Play("Clicked")

            -- Base offset from center cursor
            local offX = 4
            local offY = 10

            -- Calculate longest description line, and offset accordingly
            local longestStr = hoveredNode.name
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
            nodeBGSprite:Render(Vector(screenW / 2 + offX - 2, screenH / 2 + offY - 2))

            miniFont:DrawString(hoveredNode.name, screenW / 2 + offX, screenH / 2 + offY, KColor(1, 1, 1, 1))
            for i = 1, #hoveredNode.description do
                miniFont:DrawString(hoveredNode.description[i], screenW / 2 + offX + 6, screenH / 2 + offY + 14 * i, KColor(1, 1, 1, 1))
            end
        else
            cursorSprite:Play("Idle")
        end
        cursorSprite:Render(Vector(screenW / 2, screenH / 2))

        -- Input: E key (allocate node)
        if Input.IsButtonPressed(Keyboard.KEY_E, 0) and not treeKeyHeld[Keyboard.KEY_E] then
            treeKeyHeld[Keyboard.KEY_E] = true

            if hoveredNode ~= nil then
                if SkillTrees:isNodeAllocatable(hoveredNode.id, true) then
                    if SkillTrees.modData.skillPoints > 0 then
                        SkillTrees.modData.skillPoints = SkillTrees.modData.skillPoints - 1
                        SkillTrees:allocateNodeID(hoveredNode.id, true)
                        sfx:Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 0.75)
                    else
                        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
                    end
                elseif not SkillTrees:isNodeAllocated(hoveredNode.id) then
                    sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
                end
            end
        elseif not Input.IsButtonPressed(Keyboard.KEY_E, 0) then
            treeKeyHeld[Keyboard.KEY_E] = false
        end

        -- Input: R key (respec node)
        if Input.IsButtonPressed(Keyboard.KEY_R, 0) and not treeKeyHeld[Keyboard.KEY_R] then
            treeKeyHeld[Keyboard.KEY_R] = true

            if hoveredNode ~= nil then
                if SkillTrees:isNodeAllocatable(hoveredNode.id, false) then
                    if SkillTrees.modData.respecPoints > 0 then
                        SkillTrees.modData.respecPoints = SkillTrees.modData.respecPoints - 1
                        SkillTrees.modData.skillPoints = SkillTrees.modData.skillPoints + 1
                        SkillTrees:allocateNodeID(hoveredNode.id, false)
                        sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.75)
                    else
                        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
                    end
                elseif SkillTrees:isNodeAllocated(hoveredNode.id) then
                    sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
                end
            end
        elseif not Input.IsButtonPressed(Keyboard.KEY_R, 0) then
            treeKeyHeld[Keyboard.KEY_R] = false
        end

        -- HUD data
        Isaac.RenderText(
            "Skill points: " .. SkillTrees.modData.skillPoints .. " / Respecs: " .. SkillTrees.modData.respecPoints,
            8, 8, 1, 1, 1, 1
        )
        Isaac.RenderText("Global Tree", 8, 24, 1, 1, 1, 1)
        Isaac.RenderText("WASD: pan, Shift+V: re-center, E: allocate, R: respec", 8, (screenH - 16), 1, 1, 1, 1)
    end
end

SkillTrees:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, SkillTrees.treeMenuRendering)