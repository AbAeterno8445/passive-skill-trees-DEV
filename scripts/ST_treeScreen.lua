include("scripts.tree_data.nodes")

local sfx = SFXManager()

-- Colors
local colorDarkGrey = Color(0.4, 0.4, 0.4, 1)
local colorWhite = Color(1, 1, 1, 1)
local targetSpaceColor = Color(1, 1, 1, 1)

-- Space movement
local spaceOffPos = Vector.Zero
local spaceOffDir = Vector(-1 + 2 * math.random(), -1 + 2 * math.random())
local spaceOffStep = 0
local spaceOffTotalSteps = 1000

-- Flashing effects
local alphaFlash = 1
local alphaFlashFlip = false
local flashStep = 0.02

local miniFont = Font()
miniFont:Load("font/cjk/lanapixel.fnt")

local treeBGSprite = Sprite("gfx/ui/skilltrees/tree_bg.anm2", true)
treeBGSprite:Play("Default", true)

local treeSpaceSprite = Sprite("gfx/ui/skilltrees/tree_space_bg.anm2", true)
treeSpaceSprite.Color.A = 0.5
treeSpaceSprite:Play("Default", true)

local treeStarfieldSprite = Sprite("gfx/ui/skilltrees/tree_starfield.anm2", true)
treeStarfieldSprite.Color.A = 0.6

local treeStarfieldList = {}

local nodesSprite = Sprite("gfx/ui/skilltrees/nodes/tree_nodes.anm2", true)
nodesSprite:Play("Default", true)

local nodeBGSprite = Sprite("gfx/ui/skilltrees/tree_bg.anm2", true)
nodeBGSprite:Play("Pixel", true)
nodeBGSprite.Color.A = 0.7

local cursorSprite = Sprite("gfx/ui/cursor.anm2", true)
cursorSprite.Color.A = 0.7
cursorSprite:Play("Idle", true)

local SCJewelSprite = Sprite("gfx/items/starcursed_jewels.anm2", true)

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

-- Starcursed menus
PST.starcursedInvData = {
    open = "",
    menuX = 0,
    menuY = 0,
    socket = nil,
    hoveredJewel = nil
}

local jewelsPerPage = 25
local subMenuPage = 0
local subMenuPageButtonHovered = ""

local debugAvailableUpdate = false

local treeMenuOpen = false

local function PST_updateCamZoomOffset()
    local translateX = -Isaac.GetScreenWidth() / 2 - treeCamera.X
    local translateY = -Isaac.GetScreenHeight() / 2 - treeCamera.Y
    camZoomOffset.X = translateX - translateX * zoomScale
    camZoomOffset.Y = translateY - translateY * zoomScale

    nodesSprite.Scale.X = zoomScale
    nodesSprite.Scale.Y = zoomScale
end

local function PST_centerCamera()
    treeCamera = Vector(-Isaac.GetScreenWidth() / 2, -Isaac.GetScreenHeight() / 2)
    camZoomOffset.X = 0
    camZoomOffset.Y = 0
end

function PST:openTreeMenu()
    if not Isaac.IsInGame() then
        ---@diagnostic disable-next-line: param-type-mismatch
        MenuManager.SetInputMask(0)
    elseif not Game():IsPauseMenuOpen() then
        return
    else
        PST.selectedMenuChar = Isaac.GetPlayer():GetPlayerType()
        Game():GetHUD():SetVisible(false)
    end
    sfx:Play(SoundEffect.SOUND_PAPER_IN)

    -- Sprinkle starfield sprites when opening tree
    treeStarfieldList = {}
    for _=1,9 do
        local tmpStarfields = {}
        for i=1,5 do
            if math.random() < 100 / (i ^ 2) then
                table.insert(tmpStarfields, {
                    sprite = "Starfield" .. tostring(i),
                    offsetMult = -0.2 - 0.2 * math.random()
                })
            end
        end
        table.insert(treeStarfieldList, tmpStarfields)
    end

    targetSpaceColor = Color(1, 1, 1, 1)
    spaceOffPos = Vector.Zero
    spaceOffDir = Vector(-1 + 2 * math.random(), -1 + 2 * math.random())
    treeMenuOpen = true
end

function PST:closeTreeMenu(mute, force)
    if not Isaac.IsInGame() then
        ---@diagnostic disable-next-line: param-type-mismatch
        MenuManager.SetInputMask(4294967295)
    elseif not Game():IsPauseMenuOpen() and not force then
        return
    else
        Game():GetHUD():SetVisible(true)
    end
    if not mute then
        sfx:Play(SoundEffect.SOUND_PAPER_OUT)
    end
    PST.cosmicRData.menuOpen = false
    PST.starcursedInvData.open = ""
    helpOpen = ""
    totalModsMenuOpen = false
    treeMenuOpen = false
    currentTree = "global"

    if Isaac.IsInGame() then
        OptionsMenu.SetSelectedElement(0)
    end
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

-- Draw a sub-menu for certain nodes such as Cosmic Realignment and Starcursed inventories
---@param menuRows number
---@param centerX number
---@param centerY number
---@param menuX number
---@param menuY number
---@param title string
---@param itemDrawFunc function
---@param pagination? table -- If provided, "prev" and "next" buttons will be drawn. Table can contain prevFunc and nextFunc which will run when clicking the corresponding button.
function PST:drawNodeSubMenu(menuRows, centerX, centerY, menuX, menuY, title, itemDrawFunc, pagination)
    -- Draw BG
    nodeBGSprite.Scale.X = 164
    nodeBGSprite.Scale.Y = 24 + 32 * math.ceil(menuRows / 5)
    nodeBGSprite.Color.A = 0.9
    local tmpBGX = menuX * zoomScale - 84
    local tmpBGY = menuY * zoomScale + 14
    nodeBGSprite:Render(Vector(tmpBGX - treeCamera.X - camZoomOffset.X, tmpBGY - treeCamera.Y - camZoomOffset.Y))

    -- Stop node hovering while cursor is in this menu
    if centerX >= tmpBGX and centerX <= tmpBGX + nodeBGSprite.Scale.X and
    centerY >= tmpBGY and centerY <= tmpBGY + nodeBGSprite.Scale.Y then
        hoveredNode = nil
    end

    Isaac.RenderText(
        title,
        menuX * zoomScale - 54 - treeCamera.X - camZoomOffset.X,
        menuY * zoomScale + 20 - treeCamera.Y - camZoomOffset.Y,
        1, 1, 1, 1
    )

    if pagination then
        local tmpColor = {1, 1, 1, 1}
        subMenuPageButtonHovered = ""

        -- Prev page button
        tmpBGX = menuX * zoomScale - 48
        tmpBGY = tmpBGY + nodeBGSprite.Scale.Y + 1
        nodeBGSprite.Scale.X = 40
        nodeBGSprite.Scale.Y = 18
        if pagination.prevDisabled then
            tmpColor = {0.5, 0.5, 0.5, 1}
        end
        if centerX >= tmpBGX and centerX <= tmpBGX + nodeBGSprite.Scale.X and
        centerY >= tmpBGY and centerY <= tmpBGY + nodeBGSprite.Scale.Y then
            hoveredNode = nil
            subMenuPageButtonHovered = "prev"
            if not pagination.prevDisabled then
                tmpColor = {0.8, 0.8, 1, 1}
                if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) and pagination.prevFunc then
                    sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)
                    pagination.prevFunc()
                end
            end
        end

        nodeBGSprite:Render(Vector(tmpBGX - treeCamera.X - camZoomOffset.X, tmpBGY - treeCamera.Y - camZoomOffset.Y))
        Isaac.RenderText(
            "Prev",
            tmpBGX - treeCamera.X - camZoomOffset.X + 8,
            tmpBGY - treeCamera.Y - camZoomOffset.Y + 3,
            table.unpack(tmpColor)
        )

        -- Next page button
        tmpColor = {1, 1, 1, 1}
        tmpBGX = menuX * zoomScale
        if pagination.nextDisabled then
            tmpColor = {0.5, 0.5, 0.5, 1}
        end
        if centerX >= tmpBGX and centerX <= tmpBGX + nodeBGSprite.Scale.X and
        centerY >= tmpBGY and centerY <= tmpBGY + nodeBGSprite.Scale.Y then
            hoveredNode = nil
            subMenuPageButtonHovered = "next"
            if not pagination.nextDisabled then
                tmpColor = {0.8, 1, 1, 1}
                if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) and pagination.nextFunc then
                    sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)
                    pagination.nextFunc()
                end
            end
        end

        nodeBGSprite:Render(Vector(tmpBGX - treeCamera.X - camZoomOffset.X, tmpBGY - treeCamera.Y - camZoomOffset.Y))
        Isaac.RenderText(
            "Next",
            tmpBGX - treeCamera.X - camZoomOffset.X + 9,
            tmpBGY - treeCamera.Y - camZoomOffset.Y + 3,
            table.unpack(tmpColor)
        )
    end

    if itemDrawFunc then itemDrawFunc() end
end

function PST:treeMenuRenderer()
    local screenW = Isaac.GetScreenWidth()
    local screenH = Isaac.GetScreenHeight()

    local skPoints = PST.modData.skillPoints
    local treeName = "Global Tree"
    if currentTree ~= "global" then
        if currentTree == "starTree" then
            treeName = "Star Tree (" .. PST:getTreeMod("starmight", 0) .. " total starmight)"
        else
            skPoints = PST.modData.charData[currentTree].skillPoints
            treeName = currentTree .. "'s Tree"
        end
    end

    -- Input: Close tree
    if PST:isKeybindActive(PSTKeybind.CLOSE_TREE) then
        if totalModsMenuOpen then
            sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)
            totalModsMenuOpen = false
        else
            PST:closeTreeMenu()
        end
    end

    -- For flashing colors
    if not alphaFlashFlip then
        if alphaFlash > 0.2 then alphaFlash = alphaFlash - flashStep else alphaFlashFlip = true end
    else
        if alphaFlash < 1 then alphaFlash = alphaFlash + flashStep else alphaFlashFlip = false end
    end

    -- Space background color shifting
    if treeSpaceSprite.Color.R < targetSpaceColor.R then
        treeSpaceSprite.Color.R = treeSpaceSprite.Color.R + flashStep
        treeStarfieldSprite.Color.R = treeStarfieldSprite.Color.R + flashStep
    elseif treeSpaceSprite.Color.R > targetSpaceColor.R then
        treeSpaceSprite.Color.R = treeSpaceSprite.Color.R - flashStep
        treeStarfieldSprite.Color.R = treeStarfieldSprite.Color.R - flashStep
    end
    if treeSpaceSprite.Color.G < targetSpaceColor.G then
        treeSpaceSprite.Color.G = treeSpaceSprite.Color.G + flashStep
        treeStarfieldSprite.Color.G = treeStarfieldSprite.Color.G + flashStep
    elseif treeSpaceSprite.Color.G > targetSpaceColor.G then
        treeSpaceSprite.Color.G = treeSpaceSprite.Color.G - flashStep
        treeStarfieldSprite.Color.G = treeStarfieldSprite.Color.G - flashStep
    end
    if treeSpaceSprite.Color.B < targetSpaceColor.B then
        treeSpaceSprite.Color.B = treeSpaceSprite.Color.B + flashStep
        treeStarfieldSprite.Color.B = treeStarfieldSprite.Color.B + flashStep
    elseif treeSpaceSprite.Color.B > targetSpaceColor.B then
        treeSpaceSprite.Color.B = treeSpaceSprite.Color.B - flashStep
        treeStarfieldSprite.Color.B = treeStarfieldSprite.Color.B - flashStep
    end

    -- Space background movement
    if spaceOffStep < spaceOffTotalSteps / 2 then
        spaceOffPos = spaceOffPos + spaceOffDir * PST:ParametricBlend(spaceOffStep / spaceOffTotalSteps)
    elseif spaceOffStep < spaceOffTotalSteps then
        spaceOffPos = spaceOffPos + spaceOffDir * PST:ParametricBlend((spaceOffTotalSteps - spaceOffStep) / spaceOffTotalSteps)
    else
        spaceOffStep = 0
        spaceOffDir = spaceOffDir * -1
    end
    spaceOffStep = spaceOffStep + 1

    treeBGSprite.Scale = Vector(screenW / 480, screenH / 270)
    treeBGSprite:Render(Vector.Zero)

    -- Camera management & tree navigation
    local cameraSpeed = 3 * (1 + 1 - zoomScale)
    if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
        cameraSpeed = 8 * (1 + 1 - zoomScale)
    end
    if PST:isKeybindActive(PSTKeybind.TREE_PAN_UP, true) then
        if not totalModsMenuOpen then
            if treeCamera.Y > -2000 then
                treeCamera.Y = treeCamera.Y - cameraSpeed
                PST_updateCamZoomOffset()
            end
        else
            totalModsMenuY = math.min(0, totalModsMenuY + cameraSpeed)
        end
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_DOWN, true) then
        if not totalModsMenuOpen then
            if treeCamera.Y < 2000 then
                treeCamera.Y = treeCamera.Y + cameraSpeed
                PST_updateCamZoomOffset()
            end
        else
            totalModsMenuY = totalModsMenuY - cameraSpeed
        end
    end
    if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT, true) then
        if not totalModsMenuOpen then
            if treeCamera.X > -2000 then
                treeCamera.X = treeCamera.X - cameraSpeed
                PST_updateCamZoomOffset()
            end
        end
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT, true) then
        if not totalModsMenuOpen then
            if treeCamera.X < 2000 then
                treeCamera.X = treeCamera.X + cameraSpeed
                PST_updateCamZoomOffset()
            end
        end
    end

    local camCenterX = screenW / 2 + treeCamera.X + camZoomOffset.X
    local camCenterY = screenH / 2 + treeCamera.Y + camZoomOffset.Y

    -- Draw space BG
    treeSpaceSprite.Scale = Vector(screenW / 600, screenH / 400)
    local starfieldID = 1
    for i=-1,1 do
        for j=-1,1 do
            local xOff = 600 * j * treeSpaceSprite.Scale.X
            local yOff = 400 * i * treeSpaceSprite.Scale.Y
            local startX = camCenterX - screenW / 2
            local startY = camCenterY - screenH / 2
            treeSpaceSprite:Render(Vector(startX * -0.1 + xOff + spaceOffPos.X * 0.1, startY * -0.1 + yOff + spaceOffPos.Y * 0.1))

            if treeStarfieldList[starfieldID] then
                for _, tmpStarfield in ipairs(treeStarfieldList[starfieldID]) do
                    treeStarfieldSprite:Play(tmpStarfield.sprite)
                    treeStarfieldSprite:Render(Vector(
                        startX * tmpStarfield.offsetMult + xOff + spaceOffPos.X * tmpStarfield.offsetMult,
                        startY * tmpStarfield.offsetMult + yOff + spaceOffPos.Y * tmpStarfield.offsetMult
                    ))
                end
            end
            starfieldID = starfieldID + 1
        end
    end

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

        if node.available then
            nodesSprite:SetFrame("Available " .. node.size, 0)
            nodesSprite.Color = colorDarkGrey
            nodesSprite.Color.A = alphaFlash
            nodesSprite:Render(Vector(nodeX - treeCamera.X - camZoomOffset.X, nodeY - treeCamera.Y - camZoomOffset.Y))
        end

        nodesSprite:SetFrame("Default", node.sprite)
        if not PST:isNodeAllocated(currentTree, node.id) and not node.available then
            nodesSprite.Color = colorDarkGrey
        else
            nodesSprite.Color = colorWhite
        end
        nodesSprite:Render(Vector(nodeX - treeCamera.X - camZoomOffset.X, nodeY - treeCamera.Y - camZoomOffset.Y))

        if PST:isNodeAllocated(currentTree, node.id) then
            nodesSprite:SetFrame("Allocated " .. node.size, 0)
            nodesSprite:Render(Vector(nodeX - treeCamera.X - camZoomOffset.X, nodeY - treeCamera.Y - camZoomOffset.Y))
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
        else
            -- Starcursed jewel sockets, draw socketed jewel
            for _, tmpType in pairs(PSTStarcursedType) do
                if PST:strStartsWith(node.name, tmpType .. " Socket") then
                    local socketID = string.sub(node.name, -1)
                    local socketedJewel = PST:SC_getSocketedJewel(tmpType, socketID)
                    if socketedJewel and socketedJewel.equipped == socketID then
                        SCJewelSprite.Scale.X = zoomScale
                        SCJewelSprite.Scale.Y = zoomScale
                        SCJewelSprite:Play(tmpType)
                        SCJewelSprite:Render(Vector(nodeX - treeCamera.X - camZoomOffset.X, nodeY - treeCamera.Y - camZoomOffset.Y))
                    end
                end
            end
        end

        -- Debug: show node IDs
        if PST.debugOptions.drawNodeIDs then
            Isaac.RenderText(tostring(node.id), nodeX - treeCamera.X - camZoomOffset.X - 12, nodeY - treeCamera.Y - camZoomOffset.Y - 12, 1, 1, 1, 1)
        end
    end

    -- Draw Cosmic Realignment menu
    PST.cosmicRData.hoveredCharID = nil
    PST.starcursedInvData.hoveredJewel = nil
    if PST.cosmicRData.menuOpen then
        PST:drawNodeSubMenu(
            #PST.cosmicRData.characters,
            camCenterX, camCenterY,
            PST.cosmicRData.menuX, PST.cosmicRData.menuY,
            "Cosmic Realignment",
            function()
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
        )
    -- Draw Starcursed inventory menus
    elseif PST.starcursedInvData.open ~= "" then
        local tmpJewelType = PST.starcursedInvData.open
        local tmpJewelPages = math.ceil(#PST.modData.starTreeInventory[tmpJewelType] / jewelsPerPage)
        local tmpTitle = tmpJewelType .. " Inventory"
        if PST.starcursedInvData.socket then
            tmpTitle = tmpJewelType .. " Socket " .. tostring(PST.starcursedInvData.socket)
        end
        PST:drawNodeSubMenu(
            jewelsPerPage, camCenterX, camCenterY,
            PST.starcursedInvData.menuX, PST.starcursedInvData.menuY,
            tmpTitle,
            function()
                -- Draw Starcursed Jewels
                for i=1,jewelsPerPage do
                    local jewelID = i + subMenuPage * jewelsPerPage
                    local jewelData = PST.modData.starTreeInventory[tmpJewelType][jewelID]
                    if jewelData then
                        local jewelX = PST.starcursedInvData.menuX * zoomScale - 64 + ((i - 1) % 5) * 32
                        local jewelY = PST.starcursedInvData.menuY * zoomScale + 52 + math.floor((i - 1) / 5) * 32

                        -- Hovered
                        if camCenterX > jewelX - 16 and camCenterX < jewelX + 16 and camCenterY > jewelY - 16 and camCenterY < jewelY + 16 then
                            PST.starcursedInvData.hoveredJewel = jewelData
                            SCJewelSprite.Color.A = 1
                            PST.cosmicRData.charSprite.Color.A = 1
                            PST.cosmicRData.charSprite:Play("Select", true)
                            PST.cosmicRData.charSprite:Render(Vector(jewelX - treeCamera.X - camZoomOffset.X, jewelY - treeCamera.Y - camZoomOffset.Y))
                        else
                            SCJewelSprite.Color.A = 0.7
                        end

                        SCJewelSprite.Scale.X = 1
                        SCJewelSprite.Scale.Y = 1
                        SCJewelSprite:Play(tmpJewelType, true)
                        SCJewelSprite:Render(Vector(jewelX - treeCamera.X - camZoomOffset.X, jewelY - treeCamera.Y - camZoomOffset.Y))

                        if jewelData.unidentified then
                            SCJewelSprite:Play("Unidentified", true)
                            SCJewelSprite:Render(Vector(jewelX - treeCamera.X - camZoomOffset.X, jewelY - treeCamera.Y - camZoomOffset.Y))
                        elseif jewelData.equipped then
                            miniFont:DrawString("E", jewelX - treeCamera.X - camZoomOffset.X + 8, jewelY - treeCamera.Y - camZoomOffset.Y, KColor(1, 1, 0.6, 1))
                        end
                    end
                end
            end,
            {
                prevFunc = function()
                    if subMenuPage > 0 then subMenuPage = subMenuPage - 1 end
                end,
                prevDisabled = subMenuPage == 0,
                nextFunc = function()
                    if subMenuPage < tmpJewelPages - 1 then
                        subMenuPage = subMenuPage + 1
                    end
                end,
                nextDisabled = subMenuPage >= tmpJewelPages - 1
            }
        )
    else
        subMenuPageButtonHovered = ""
    end

    -- Cursor and node description
    if hoveredNode ~= nil then
        cursorSprite:Play("Clicked")

        local descName = hoveredNode.name
        local tmpDescription = hoveredNode.description
        local isAllocated = PST:isNodeAllocated(currentTree, hoveredNode.id)
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
            elseif isAllocated then
                descName = descName .. " (E to pick character)"
            end
        -- Star Tree node
        elseif hoveredNode.name == "Star Tree" then
            if isAllocated then
                if currentTree ~= "starTree" then
                    descName = descName .. " (E to view Star Tree)"
                end
            elseif not PST:SC_isStarTreeUnlocked() then
                tmpDescription = {
                    {"Reach level 40 with at least one character to unlock.", KColor(1, 0.6, 0.6, 1)}
                }
            end
        elseif isAllocated then
            -- Starcursed inventory/socket nodes
            for _, tmpType in pairs(PSTStarcursedType) do
                if PST:strStartsWith(hoveredNode.name, tmpType) then
                    local isSocket = string.match(hoveredNode.name, "Socket") ~= nil
                    if isSocket or string.match(hoveredNode.name, "Inventory") ~= nil then
                        descName = descName .. " (E to open/close inventory)"
                        if isSocket then
                            local socketID = string.sub(hoveredNode.name, -1)
                            local socketedJewel = PST:SC_getSocketedJewel(tmpType, socketID)
                            if socketedJewel and socketedJewel.equipped == socketID then
                                tmpDescription = PST:SC_getJewelDescription(socketedJewel)
                                table.insert(tmpDescription, "Press the Respec Node button to unequip the jewel.")
                            end
                        end
                    end
                    break
                end
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
    -- Starcursed inventory, hovered jewel data
    elseif PST.starcursedInvData.hoveredJewel ~= nil then
        cursorSprite:Play("Clicked")

        local jewelData = PST.starcursedInvData.hoveredJewel
        if jewelData then
            local tmpDescription = PST:SC_getJewelDescription(jewelData)
            drawNodeBox(jewelData.type .. " Starcursed Jewel", tmpDescription, screenW, screenH)
        end
    elseif subMenuPageButtonHovered ~= "" then
        cursorSprite:Play("Clicked")
    else
        cursorSprite:Play("Idle")
    end
    cursorSprite:Render(Vector(screenW / 2, screenH / 2))

    -- Input: Allocate node
    if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
        if hoveredNode ~= nil then
            if PST:isNodeAllocatable(currentTree, hoveredNode.id, true) then
                if not PST.debugOptions.infSP then
                    if currentTree == "global" or currentTree == "starTree" then
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
                -- Star Tree node, switch to star tree view
                elseif hoveredNode.name == "Star Tree" and currentTree ~= "starTree" then
                    targetSpaceColor = Color(0, 1, 1, 1)
                    sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)
                    currentTree = "starTree"
                    PST_centerCamera()
                else
                    -- Star Tree: Open Inventories
                    for _, tmpType in pairs(PSTStarcursedType) do
                        if PST:strStartsWith(hoveredNode.name, tmpType) then
                            local isSocket = string.match(hoveredNode.name, "Socket")
                            if (isSocket or string.match(hoveredNode.name, "Inventory") ~= nil) then
                                if PST.starcursedInvData.open ~= tmpType then
                                    PST:SC_sortInventory(tmpType)
                                    subMenuPage = 0
                                    PST.starcursedInvData.open = tmpType
                                    if isSocket then
                                        PST.starcursedInvData.socket = string.sub(hoveredNode.name, -1)
                                    else
                                        PST.starcursedInvData.socket = nil
                                    end
                                    PST.starcursedInvData.menuX = hoveredNode.pos.X * 38
                                    PST.starcursedInvData.menuY = hoveredNode.pos.Y * 38
                                    PST.cosmicRData.menuOpen = false
                                else
                                    PST.starcursedInvData.open = ""
                                end
                                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                                break
                            end
                        end
                    end
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
        -- Starcursed inventory, identify/equip hovered jewel
        elseif PST.starcursedInvData.hoveredJewel ~= nil then
            local jewelData = PST.starcursedInvData.hoveredJewel
            if jewelData then
                if jewelData.unidentified then
                    sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)
                    sfx:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 0.9, 2, false, 1.6 + 0.1 * math.random())
                    PST:SC_identifyJewel(PST.starcursedInvData.hoveredJewel)
                elseif PST.starcursedInvData.socket then
                    sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)
                    PST:SC_equipJewel(jewelData, PST.starcursedInvData.socket)
                    PST.starcursedInvData.open = ""
                end
            end
        end
    end

    -- Input: Respec node
    if PST:isKeybindActive(PSTKeybind.RESPEC_NODE) then
        if hoveredNode ~= nil then
            -- Check if node is socketed starcursed jewel
            local isSocketedJewel = false
            for _, tmpType in pairs(PSTStarcursedType) do
                if PST:strStartsWith(hoveredNode.name, tmpType .. " Socket") then
                    local socketID = string.sub(hoveredNode.name, -1)
                    local socketedJewel = PST:SC_getSocketedJewel(tmpType, socketID)
                    if socketedJewel and socketedJewel.equipped == socketID then
                        -- Socketed jewel - unsocket
                        socketedJewel.equipped = nil
                        sfx:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 0.9, 2, false, 1.6 + 0.1 * math.random())
                        isSocketedJewel = true
                        break
                    end
                end
            end
            if not isSocketedJewel then
                if PST:isNodeAllocatable(currentTree, hoveredNode.id, false) then
                    if not PST.debugOptions.infRespec then
                        PST.modData.respecPoints = PST.modData.respecPoints - 1
                    end
                    if not PST.debugOptions.infSP then
                        if currentTree == "global" or currentTree == "starTree" then
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
    end

    -- Input: Switch tree
    if PST:isKeybindActive(PSTKeybind.SWITCH_TREE) then
        local selectedCharName = PST.charNames[1 + PST.selectedMenuChar]
        if selectedCharName and PST.trees[selectedCharName] ~= nil then
            if currentTree == "global" then
                currentTree = selectedCharName
                targetSpaceColor = Color(1, 0.5, 1, 1)
            else
                currentTree = "global"
                targetSpaceColor = Color(1, 1, 1, 1)
            end
            PST.cosmicRData.menuOpen = false
            PST.starcursedInvData.open = ""
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
            local tmpCharName = PST.charNames[1 + PST.selectedMenuChar]
            if tmpCharName and PST.trees[tmpCharName] ~= nil then
                processTreeNodes(tmpCharName)
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
                if categorySwitch and tmpCharName and PST.trees[tmpCharName] ~= nil then
                    local tmpName = PST.treeModDescriptionCategories[lastCategory].name
                    if lastCategory == "charTree" then
                        tmpName = tmpCharName .. "'s tree:"
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
        PST_centerCamera()
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
    local tmpStr = "H / Select: toggle help"
    miniFont:DrawString(tmpStr, 16, screenH - 24, KColor(1, 1, 1, 1))
    if Isaac.IsInGame() then
        miniFont:DrawString("(IN RUN - Changes to the tree will be reflected on the next run you start)", 32 + string.len(tmpStr) * 4, screenH - 24, KColor(1, 0.7, 0.7, 1))
    end

    -- Draw help menu
    if helpOpen == "keyboard" then
        drawNodeBox("Tree Controls", treeControlDesc, screenW / 2, screenH / 2)
    elseif helpOpen == "controller" then
        drawNodeBox("Tree Controls (Controller)", treeControlDescController, screenW / 2, screenH / 2)
    -- Draw total modifiers menu
    elseif totalModsMenuOpen then
        drawNodeBox("Active Modifiers", totalModsList, 16, 16 + totalModsMenuY, true, 1)
    end

    -- Update tree visibility if debug mode allAvailable changes
    if debugAvailableUpdate ~= PST.debugOptions.allAvailable then
        PST:updateNodes(currentTree, true)
        debugAvailableUpdate = PST.debugOptions.allAvailable
    end
end

local firstRender = false
function PST:treeMenuRendering()
    local isCharMenu = false
    if not Isaac.IsInGame() then
        isCharMenu = MenuManager.GetActiveMenu() == MainMenuType.CHARACTER
    end

    -- First MC_MAIN_MENU_RENDER call
    if not firstRender then
        firstRender = true
        PST:firstRenderInit()

        if not Isaac.IsInGame() then
            -- Reset input mask if restarting
            if MenuManager.GetInputMask() == 0 then
                ---@diagnostic disable-next-line: param-type-mismatch
                MenuManager.SetInputMask(4294967295)
            end
        end
    end

    if treeMenuOpen and ((not Isaac.IsInGame() and not isCharMenu) or (Isaac.IsInGame() and not Game():IsPauseMenuOpen())) then
        PST:closeTreeMenu(true, true)
    -- Input: Open tree menu
    elseif PST:isKeybindActive(PSTKeybind.OPEN_TREE) or (not treeMenuOpen and Input.IsActionTriggered(ButtonAction.ACTION_ITEM, 1)) then
        if isCharMenu or Game():IsPauseMenuOpen() then
            if treeMenuOpen then
                PST:closeTreeMenu()
            else
                PST:openTreeMenu()
            end
        end
    end

    if not treeMenuOpen and isCharMenu and PST.selectedMenuChar ~= -1 then
        local selCharName = PST.charNames[1 + PST.selectedMenuChar]
        if selCharName then
            local selCharData = PST.modData.charData[selCharName]
            if selCharData and PST.config.charSelectInfoText then
                local tmpStr = selCharName .. " LV " .. selCharData.level
                tmpStr = tmpStr .. " (V / LT or LB to open tree)"
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
    elseif Game():IsPauseMenuOpen() and not treeMenuOpen then
        local tmpStr = "V / LT or LB to open tree"
        miniFont:DrawString(
            tmpStr,
            Isaac.GetScreenWidth() / 2 - string.len(tmpStr) * 2.5,
            Isaac.GetScreenHeight() - 40,
            KColor(1, 0.8, 1, 1)
        )
    end

    if treeMenuOpen then
        PST:treeMenuRenderer()
    end
end

function PST:treePauseMenu()
    if treeMenuOpen then
        -- Force pause menu to loop between options and open in the background, while tree is open
        PauseMenu.SetState(PauseMenuStates.OPTIONS)
        OptionsMenu.SetSelectedElement(999)
        return false
    end
end

function PST:ParametricBlend(t)
    local sqr = t ^ 2
    return sqr / (2 * (sqr - t) + 1)
end

PST:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, PST.treeMenuRendering)
PST:AddCallback(ModCallbacks.MC_POST_RENDER, PST.treeMenuRendering)
PST:AddCallback(ModCallbacks.MC_PRE_PAUSE_SCREEN_RENDER, PST.treePauseMenu)