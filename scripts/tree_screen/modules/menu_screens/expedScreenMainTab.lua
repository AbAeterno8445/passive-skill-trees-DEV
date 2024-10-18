local expNodeRewardFrame = {
    [PSTExpNodeRewardType.EXP] = 0,
    [PSTExpNodeRewardType.OBOLS] = 1,
    [PSTExpNodeRewardType.BOON] = 2,
    [PSTExpNodeRewardType.ATTEMPTS] = 3
}
local nodeSpacing = Vector(80, 60)

---@param expData PSTExpedition
---@param expedScreen table
---@param tScreen PST.treeScreen
local function expedScreenMainTab(expData, expedScreen, tScreen)
    -- Drawing position func
    local function PST_getNodePos(col, colTotal, row)
        local xPos = expedScreen.camCenterX + (col - 1) * nodeSpacing.X - expedScreen.camera.X - expedScreen.camZoomOffset.X
        local yPos = expedScreen.camCenterY - expedScreen.camera.Y - (colTotal + 1) * (nodeSpacing.Y / 2) + row * nodeSpacing.Y - expedScreen.camZoomOffset.Y
        return Vector(xPos, yPos) * expedScreen.zoomScale
    end

    -- Draw links
    for i, tmpColumn in ipairs(expData.nodes) do
        local nextColumn = expData.nodes[i + 1]
        if nextColumn then
            for j, tmpNode in ipairs(tmpColumn) do
                if #tmpNode.connections > 0 then
                    for _, targetNode in ipairs(tmpNode.connections) do
                        local linkBeam = Beam(expedScreen.expLinkSprite, 0, false, false)
                        local startPos = PST_getNodePos(i, #tmpColumn, j)
                        local endPos = PST_getNodePos(i + 1, #nextColumn, targetNode)
                        local dist = math.ceil(startPos:Distance(endPos))
                        linkBeam:Add(startPos, 0)
                        linkBeam:Add(endPos, math.min(129, dist))
                        linkBeam:Render()
                    end
                end
            end
        end
    end

    -- Draw nodes
    for i, tmpColumn in ipairs(expData.nodes) do
        for j, tmpNode in ipairs(tmpColumn) do
            local drawPos = PST_getNodePos(i, #tmpColumn, j)
            expedScreen.expNodeSprite:SetFrame("Nodes", tmpNode.nodeType)
            expedScreen.expNodeSprite:Render(drawPos)

            if tmpNode.rewardType ~= PSTExpNodeRewardType.ITEM then
                if expNodeRewardFrame[tmpNode.rewardType] ~= nil then
                    expedScreen.expNodeSprite:SetFrame("Icons", expNodeRewardFrame[tmpNode.rewardType])
                    expedScreen.expNodeSprite:Render(drawPos - Vector.One)
                end
            elseif tmpNode.rewardData then
                local itemCfg = Isaac.GetItemConfig():GetCollectible(tmpNode.rewardData)
                if itemCfg then
                    expedScreen.itemRewardSprite:ReplaceSpritesheet(1, itemCfg.GfxFileName, true)
                    expedScreen.itemRewardSprite:Render(drawPos - Vector(1, -8))
                end
            end

            -- Hovered node
            local nodeHalf = 16 * expedScreen.zoomScale
            if expedScreen.camCenterX >= drawPos.X - nodeHalf and expedScreen.camCenterX <= drawPos.X + nodeHalf and
            expedScreen.camCenterY >= drawPos.Y - nodeHalf and expedScreen.camCenterY <= drawPos.Y + nodeHalf then
                expedScreen.hoveredNode = tmpNode
            end
        end
    end

    -- Cursor
    if expedScreen.hoveredNode ~= nil then
        tScreen.cursorSprite:Play("Clicked", true)
    else
        tScreen.cursorSprite:Play("Idle", true)
    end
    tScreen.cursorSprite:Render(Vector(tScreen.screenW / 2, tScreen.screenH / 2))

    -- Hovered node description
    if expedScreen.hoveredNode ~= nil then
        local nodeName = "Expedition Node"
        local nodeDesc = {}
        if expedScreen.hoveredNode.nodeType == PSTExpNodeType.ASTROLABE then
            nodeName = "Arcane Astrolabe"
            nodeDesc = {"Expedition Depth: " .. tostring(expedScreen.currentDepth)}
        else
            nodeDesc = PST:getExpNodeDescription(expedScreen.hoveredNode, expedScreen.currentDepth)
        end
        tScreen:DrawNodeBox(nodeName, nodeDesc, tScreen.screenW, tScreen.screenH)
    end
end

return expedScreenMainTab