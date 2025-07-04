local drawLineHeight = 14
local boonCols = 5
local baseDrawX, baseDrawY = 0, 0

-- Text render helper
local function tmpRenderText(txt, color, offsetY)
    if string.len(txt) > 0 then
        PST.miniFont:DrawStringUTF8(txt, baseDrawX, baseDrawY, color or PST.kcolors.WHITE)
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

    local uberExtra = ""
    if expData.uber then
        uberExtra = " (" .. PST:getLocalized("ui_uber") .. ")"
    end
    tmpRenderText(PST:getLocalizedFormatStr("ui_expedDepthNum", {depth = expData.depth}) .. uberExtra, PST.kcolors.WHITE, drawLineHeight * 2)

    -- Requirement values are tables: {requirement description string, true/false whether req is met}
    local tmpRequirements = {}

    -- Node selection requirement
    table.insert(tmpRequirements, {PST:getLocalized("ui_expedSelNode"), expData.selectedNode ~= nil})

    -- Character level requirement
    local currentChar = PST:getCurrentCharData()
    local reqLvl = PST.expedMinLevel
    if expData.uber then reqLvl = PST.uberExpedMinLevel end
    local tmpStr = PST:getLocalizedFormatStr("ui_expReqCharSelLvl", {reqLvl = reqLvl})
    if currentChar then
        tmpStr = tmpStr .. " (" .. PST:getLocalizedFormatStr("ui_expReqCharSelLvlExtra", {charName = PST:getCurrentCharName(), level = currentChar.level}) .. ")"
    end
    table.insert(tmpRequirements, {tmpStr, currentChar and currentChar.level >= reqLvl})

    -- Starmight requirement
    if expData.implicits then
        local tmpReq = expData.implicits.starmightReq
        if tmpReq and tmpReq > 0 then
            tmpStr = PST:getLocalized("ui_expReqStarmight") .. ": " .. tmpReq
            local totalStarmight = 0
            if tScreen.starcursedTotalMods and tScreen.starcursedTotalMods.totalStarmight then
                totalStarmight = tScreen.starcursedTotalMods.totalStarmight
                tmpStr = tmpStr .. " (" .. PST:getLocalized("ui_expReqStarmightYourTotal") .. ": " .. totalStarmight .. ")"
            end
            table.insert(tmpRequirements, {tmpStr, totalStarmight >= tmpReq})
        end
    end

    local expCurses = PST:getExpedCurseMods(expData)
    -- Ancient starcursed jewel requirement
    if expCurses["curseAncientStars"] then
        local ancientSocketed = PST:SC_getSocketedJewel(PSTStarcursedType.ANCIENT, "1") or PST:SC_getSocketedJewel(PSTStarcursedType.ANCIENT, "2")
        table.insert(tmpRequirements, {PST:getLocalized("ui_expReqSocketAncJewel"), ancientSocketed})
    end

    -- Requirements
    local requirementsMet = true
    if #tmpRequirements > 0 then
        tmpRenderText(PST:getLocalized("ui_expReqs"), PST.kcolors.FORGE_ORANGE)
        for _, reqData in ipairs(tmpRequirements) do
            local tmpColor = PST.kcolors.GREEN2
            if not reqData[2] then
                requirementsMet = false
                tmpColor = PST.kcolors.RED1
            end
            tmpRenderText("    " .. reqData[1], tmpColor)
        end
        if not requirementsMet then
            tmpRenderText(PST:getLocalized("ui_expReqNotMetWarn"), PST.kcolors.RED1)
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
                    tmpRenderText(PST:getLocalized("ui_impMods"), tmpColor)
                    firstDraw = true
                end
                local tmpDescription = PST:getLocalized(impName)
                if tmpDescription then
                    local formatLines = {}
                    if type(tmpDescription) == "table" then
                        for _, tmpLine in ipairs(tmpDescription) do
                            table.insert(formatLines, PST:formatString(tmpLine, {impVal = impVal}))
                        end
                    else
                        table.insert(formatLines, PST:formatString(tmpDescription, {impVal = impVal}))
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

    -- Uber effects
    if expData.uber then
        tmpRenderText(PST:getLocalized("ui_Order") .. ": " .. (expData.order or 0), PST.kcolors.TEAL1, drawLineHeight + 4)
        tmpRenderText(PST:getLocalized("ui_Entropy") .. ": " .. (expData.entropy or 0), PST.kcolors.RED1, drawLineHeight + 4)

        tmpRenderText(PST:getLocalized("ui_dsdMods"), PST.kcolors.RED2, drawLineHeight + 4)
        if expData.dsMods and #expData.dsMods > 0 then
            for _, dsModID in ipairs(expData.dsMods) do
                local dsModName = PST.expedDeepSpaceMods[dsModID]
                local dsModDesc = PST:getLocalized(dsModName)
                if dsModDesc then
                    tmpRenderText("    " .. dsModDesc, PST.kcolors.RED2, drawLineHeight + 4)
                end
            end
        else
            tmpRenderText("    " .. PST:getLocalized("ui_none"), PST.kcolors.RED2)
        end
        tmpRenderText("")
    end

    -- Items
    local tmpColor = PST.kcolors.EXPED_PURPLE
    tmpRenderText(PST:getLocalized("ui_items") .. ":", tmpColor, drawLineHeight + 4)

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
        tmpRenderText("    " .. PST:getLocalized("ui_none"), tmpColor, drawLineHeight * 2)
    else
        -- Offset Y drawing pos by drawn bubble heights
        baseDrawY = baseDrawY + drawLineHeight + 40 * math.ceil(tmpDrawn / boonCols)
    end

    -- Boons
    tmpColor = PST.kcolors.GREEN1
    tmpRenderText(PST:getLocalized("ui_boons") .. ":", tmpColor, drawLineHeight + 4)

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
        tmpRenderText("    " .. PST:getLocalized("ui_none"), tmpColor)
    else
        -- Offset Y drawing pos by drawn bubble heights
        baseDrawY = baseDrawY + drawLineHeight + 40 * math.ceil(tmpDrawn / boonCols)
    end

    -- Boon upgrade points
    tmpRenderText(PST:getLocalized("ui_boonUpgPoints") .. ": " .. tostring(expData.boonUpgradePoints), tmpColor)
    tmpRenderText("")

    -- Curses
    tmpColor = PST.kcolors.RED2
    tmpRenderText(PST:getLocalized("ui_curses") .. ":", tmpColor, drawLineHeight + 4)

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
        tmpRenderText("    " .. PST:getLocalized("ui_none"), tmpColor)
    else
        -- Offset Y drawing pos by drawn bubble heights
        baseDrawY = baseDrawY + drawLineHeight + 40 * math.ceil(tmpDrawn / boonCols)
    end
    --tmpRenderText("")
end

return expedScreenEffectTab