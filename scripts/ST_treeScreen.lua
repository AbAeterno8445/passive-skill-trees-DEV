include("scripts.tree_data.nodes")

local sfx = SFXManager()

local treeBGSprite = Sprite("gfx/ui/skilltrees/tree_bg.anm2")
treeBGSprite:Play("Default", true)

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

function SkillTrees:treeMenuInput()

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

        -- Camera management
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

        -- Draw nodes
        local camCenterX = screenW / 2 + treeCamera.X
        local camCenterY = screenH / 2 + treeCamera.Y
        hoveredNode = nil
        for _, node in pairs(SkillTrees.nodeData.global) do
            node.sprite:Render(Vector(node.pos.X - treeCamera.X, node.pos.Y - treeCamera.Y))

            if SkillTrees.modData.treeNodes[node.id] then
                node.allocatedSprite:Render(Vector(node.pos.X - treeCamera.X, node.pos.Y - treeCamera.Y))
            end
            
            if camCenterX >= node.pos.X - 15 and camCenterX <= node.pos.X + 15 and
            camCenterY >= node.pos.Y - 15 and camCenterY <= node.pos.Y + 15 then
                hoveredNode = node
            end
        end

        -- Cursor
        cursorSprite:Render(Vector(screenW / 2, screenH / 2))
        if hoveredNode ~= nil then
            cursorSprite:Play("Clicked")
            Isaac.RenderText(hoveredNode.name, screenW / 2 + 16, screenH / 2 - 5, 1, 1, 1, 0.8)
            for i = 1, #hoveredNode.description do
                Isaac.RenderText(hoveredNode.description[i], screenW / 2 + 22, screenH / 2 - 5 + 14 * i, 1, 1, 1, 0.8)
            end
        else
            cursorSprite:Play("Idle")
        end

        -- Input: E key (allocate node)
        if Input.IsButtonPressed(Keyboard.KEY_E, 0) and not treeKeyHeld[Keyboard.KEY_E] then
            treeKeyHeld[Keyboard.KEY_E] = true

            if hoveredNode ~= nil then
                if hoveredNode.available and not SkillTrees.modData.treeNodes[hoveredNode.id] then
                    if SkillTrees.modData.skillPoints > 0 then
                        SkillTrees.modData.skillPoints = SkillTrees.modData.skillPoints - 1
                        SkillTrees:allocateNodeID(hoveredNode.id, true)
                        sfx:Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 0.75)
                    else
                        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
                    end
                elseif not hoveredNode.available then
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
                if SkillTrees.modData.treeNodes[hoveredNode.id] then
                    if SkillTrees.modData.respecPoints > 0 then
                        SkillTrees.modData.respecPoints = SkillTrees.modData.respecPoints - 1
                        SkillTrees.modData.skillPoints = SkillTrees.modData.skillPoints + 1
                        SkillTrees:allocateNodeID(hoveredNode.id, false)
                        sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.75)
                    else
                        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
                    end
                end
            end
        else
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