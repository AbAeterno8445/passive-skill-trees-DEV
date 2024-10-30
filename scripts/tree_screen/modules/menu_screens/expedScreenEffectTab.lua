local drawLineHeight = 14
local boonCols = 5
local baseDrawX, baseDrawY = 0, 0

-- Text render helper
local function tmpRenderText(txt, color, offsetY)
    if string.len(txt) > 0 then
        PST.miniFont:DrawString(txt, baseDrawX, baseDrawY, color or PST.kcolors.WHITE)
    end
    offsetY = offsetY or drawLineHeight
    baseDrawY = baseDrawY + offsetY
end

---@param expData PSTExpedition
---@param expedScreen table
---@param tScreen PST.treeScreen
local function expedScreenEffectTab(expData, expedScreen, tScreen)
    baseDrawX = tScreen.screenW * 0.2 - expedScreen.camera.X
    baseDrawY = 20 + drawLineHeight - expedScreen.camera.Y

    tmpRenderText("Expedition depth " .. tostring(expData.depth), PST.kcolors.WHITE, drawLineHeight * 2)

    -- Requirement values are tables: {requirement description string, true/false whether req is met}
    local tmpRequirements = {}

    -- Node selection requirement
    table.insert(tmpRequirements, {"Selected expedition node.", expData.selectedNode ~= nil})

    -- Character level requirement
    local currentChar = PST:getCurrentCharData()
    local tmpStr = "Selected character level " .. tostring(PST.expedMinLevel) .. "+"
    if currentChar then
        tmpStr = tmpStr .. " (" .. PST:getCurrentCharName() .. " level: " .. tostring(currentChar.level) .. ")"
    end
    table.insert(tmpRequirements, {tmpStr, currentChar and currentChar.level >= PST.expedMinLevel})

    -- Starmight requirement
    if expData.implicits then
        local tmpReq = expData.implicits.starmightReq
        if tmpReq and tmpReq > 0 then
            tmpStr = "Starmight required: " .. tostring(tmpReq)
            local totalStarmight = 0
            if tScreen.starcursedTotalMods and tScreen.starcursedTotalMods.totalStarmight then
                totalStarmight = tScreen.starcursedTotalMods.totalStarmight
                tmpStr = tmpStr .. " (your total: " .. tostring(totalStarmight) .. ")"
            end
            table.insert(tmpRequirements, {tmpStr, totalStarmight >= tmpReq})
        end
    end

    local expCurses = PST:getExpedCurseMods(expData)
    -- Ancient starcursed jewel requirement
    if expCurses["curseAncientStars"] then
        local ancientSocketed = PST:SC_getSocketedJewel(PSTStarcursedType.ANCIENT, "1") or PST:SC_getSocketedJewel(PSTStarcursedType.ANCIENT, "2")
        table.insert(tmpRequirements, {"Socketed Ancient Starcursed Jewel.", ancientSocketed})
    end

    -- Requirements
    local requirementsMet = true
    if #tmpRequirements > 0 then
        tmpRenderText("Expedition requirements:", PST.kcolors.FORGE_ORANGE)
        for _, reqData in ipairs(tmpRequirements) do
            local tmpColor = PST.kcolors.GREEN2
            if not reqData[2] then
                requirementsMet = false
                tmpColor = PST.kcolors.RED1
            end
            tmpRenderText("    " .. reqData[1], tmpColor)
        end
        if not requirementsMet then
            tmpRenderText("Warning: requirements not met! Next run can't be an expedition run.", PST.kcolors.RED1)
        end
        tmpRenderText("")
    end

    -- Current objective
    if expData.selectedNode then
        local tmpNode = expData.nodes[expData.selectedNode.col][expData.selectedNode.row]
        if tmpNode then
            for _, tmpLine in ipairs(PST:getExpNodeObjectiveDesc(tmpNode, expData)) do
                tmpRenderText(tmpLine[1], tmpLine[2])
            end
            tmpRenderText("")
        end
    end

    -- Implicit modifiers
    if expData.implicits then
        local tmpColor = PST.kcolors.LIGHTRED1
        local firstDraw = false
        for impName, impVal in pairs(expData.implicits) do
            if impName ~= "starmightReq" then
                if not firstDraw then
                    tmpRenderText("Implicit modifiers:", tmpColor)
                    firstDraw = true
                end
                local tmpDescription = PST.expedDescriptions[impName]
                if tmpDescription then
                    local formatLines = {}
                    if type(tmpDescription) == "table" then
                        for _, tmpLine in ipairs(tmpDescription) do
                            table.insert(formatLines, string.format(tmpLine, impVal))
                        end
                    else
                        table.insert(formatLines, string.format(tmpDescription, impVal))
                    end
                    for _, tmpLine in ipairs(formatLines) do
                        tmpRenderText("    " .. tmpLine, tmpColor)
                    end
                end
            end
        end
        if firstDraw then
            tmpRenderText("")
        end
    end

    -- Items
    local tmpColor = PST.kcolors.EXPED_PURPLE
    tmpRenderText("Items:", tmpColor, drawLineHeight + 4)

    ---@type Sprite
    local tmpSprite = expedScreen.itemRewardSprite

    local tmpDrawn = 0
    expedScreen.hoveredItem = nil
    for _, itemID in ipairs(expData.items) do
        local itemCfg = Isaac.GetItemConfig():GetCollectible(itemID)
        if itemCfg then
            local drawX = baseDrawX + 20 + 48 * (tmpDrawn % boonCols)
            local drawY = baseDrawY + 20 + 48 * math.floor(tmpDrawn / boonCols)

            -- Hovered item
            local hovered = false
            local nodeHalf = 19
            if expedScreen.camCenterX >= drawX - nodeHalf and expedScreen.camCenterX <= drawX + nodeHalf and
            expedScreen.camCenterY >= drawY - nodeHalf and expedScreen.camCenterY <= drawY + nodeHalf then
                hovered = true
                expedScreen.hoveredItem = itemID
            end

            -- Draw item
            tmpSprite:ReplaceSpritesheet(1, itemCfg.GfxFileName, true)
            tmpSprite:Render(Vector(drawX + 1, drawY + 8))

            -- Bubble
            tmpSprite = expedScreen.boonSprite
            if hovered then tmpSprite.Color = Color(1, 1, 1, 1, 0.5, 0.5, 0.5) end
            tmpSprite:SetFrame("Bubbles", 2)
            tmpSprite:Render(Vector(drawX, drawY))
            if hovered then tmpSprite.Color = Color() end
            tmpSprite = expedScreen.itemRewardSprite

            tmpDrawn = tmpDrawn + 1
        end
    end
    if tmpDrawn == 0 then
        tmpRenderText("    None", tmpColor, drawLineHeight * 2)
    else
        -- Offset Y drawing pos by drawn bubble heights
        baseDrawY = baseDrawY + drawLineHeight + 40 * math.ceil(tmpDrawn / boonCols)
    end

    -- Boons
    tmpColor = PST.kcolors.GREEN1
    tmpRenderText("Boons:", tmpColor, drawLineHeight + 4)

    ---@type Sprite
    tmpSprite = expedScreen.boonSprite

    tmpDrawn = 0
    expedScreen.hoveredBoon = nil
    for _, boonID in ipairs(expData.boons) do
        local tmpBoon = PST.expeditionBoons[boonID]
        if tmpBoon then
            local isUpgraded = expData.upgradedBoons and PST:arrHasValue(expData.upgradedBoons, boonID)
            local drawX = baseDrawX + 20 + 48 * (tmpDrawn % boonCols)
            local drawY = baseDrawY + 20 + 48 * math.floor(tmpDrawn / boonCols)

            -- Hovered boon
            local hovered = false
            local nodeHalf = 19
            if expedScreen.camCenterX >= drawX - nodeHalf and expedScreen.camCenterX <= drawX + nodeHalf and
            expedScreen.camCenterY >= drawY - nodeHalf and expedScreen.camCenterY <= drawY + nodeHalf then
                hovered = true
                expedScreen.hoveredBoon = boonID
            end

            -- Boon icon
            tmpSprite:SetFrame("Boons", tmpBoon.spriteFrame)
            tmpSprite:Render(Vector(drawX, drawY))

            -- Bubble
            local tmpFrame = 0
            if isUpgraded then tmpFrame = 3 end
            if hovered then tmpSprite.Color = Color(1, 1, 1, 1, 0.5, 0.5, 0.5) end
            tmpSprite:SetFrame("Bubbles", tmpFrame)
            tmpSprite:Render(Vector(drawX, drawY))
            if hovered then tmpSprite.Color = Color() end

            tmpDrawn = tmpDrawn + 1
        end
    end
    if tmpDrawn == 0 then
        tmpRenderText("    None", tmpColor)
    else
        -- Offset Y drawing pos by drawn bubble heights
        baseDrawY = baseDrawY + drawLineHeight + 40 * math.ceil(tmpDrawn / boonCols)
    end

    -- Boon upgrade points
    tmpRenderText("Boon upgrade points: " .. tostring(expData.boonUpgradePoints), tmpColor)
    tmpRenderText("")

    -- Curses
    tmpColor = PST.kcolors.RED2
    tmpRenderText("Curses:", tmpColor, drawLineHeight + 4)

    tmpDrawn = 0
    expedScreen.hoveredCurse = nil
    for _, curseID in ipairs(expData.curses) do
        local tmpCurse = PST.expeditionCurses[curseID]
        if tmpCurse then
            local drawX = baseDrawX + 20 + 48 * (tmpDrawn % boonCols)
            local drawY = baseDrawY + 20 + 48 * math.floor(tmpDrawn / boonCols)

            -- Hovered curse
            local hovered = false
            local nodeHalf = 19
            if expedScreen.camCenterX >= drawX - nodeHalf and expedScreen.camCenterX <= drawX + nodeHalf and
            expedScreen.camCenterY >= drawY - nodeHalf and expedScreen.camCenterY <= drawY + nodeHalf then
                hovered = true
                expedScreen.hoveredCurse = curseID
            end

            -- Curse icon
            tmpSprite:SetFrame("Curses", tmpCurse.spriteFrame)
            tmpSprite:Render(Vector(drawX, drawY))

            -- Bubble
            if hovered then tmpSprite.Color = Color(1, 1, 1, 1, 0.5, 0.5, 0.5) end
            tmpSprite:SetFrame("Bubbles", 1)
            tmpSprite:Render(Vector(drawX, drawY))
            if hovered then tmpSprite.Color = Color() end

            tmpDrawn = tmpDrawn + 1
        end
    end
    if tmpDrawn == 0 then
        tmpRenderText("    None", tmpColor)
    else
        -- Offset Y drawing pos by drawn bubble heights
        baseDrawY = baseDrawY + drawLineHeight + 40 * math.ceil(tmpDrawn / boonCols)
    end
    --tmpRenderText("")
end

return expedScreenEffectTab