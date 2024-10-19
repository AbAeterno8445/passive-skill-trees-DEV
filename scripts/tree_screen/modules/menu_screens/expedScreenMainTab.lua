local expNodeRewardFrame = {
    [PSTExpNodeRewardType.EXP] = 0,
    [PSTExpNodeRewardType.OBOLS] = 1,
    [PSTExpNodeRewardType.BOON] = 2,
    [PSTExpNodeRewardType.ATTEMPTS] = 3
}
local nodeSpacing = Vector(80, 60)

local colGray = Color(0.4, 0.4, 0.4, 1)
local colWhite = Color(1, 1, 1, 1)

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
    for col, tmpColumn in ipairs(expData.nodes) do
        local nextColumn = expData.nodes[col + 1]
        if nextColumn then
            for row, tmpNode in ipairs(tmpColumn) do
                if #tmpNode.connections > 0 then
                    for _, targetNodeRow in ipairs(tmpNode.connections) do
                        local targetNode = nextColumn[targetNodeRow]
                        if targetNode then
                            -- Inaccessible, gray link
                            if tmpNode.accessible == false or targetNode.accessible == false then
                                expedScreen.expLinkSprite:SetFrame("Idle", 1)
                            -- Completed/Astrolabe node
                            elseif tmpNode.nodeType == PSTExpNodeType.COMPLETED or tmpNode.nodeType == PSTExpNodeType.ASTROLABE then
                                expedScreen.expLinkSprite:SetFrame("Idle", 2)
                            else
                                expedScreen.expLinkSprite:SetFrame("Idle", 0)
                            end

                            local linkBeam = Beam(expedScreen.expLinkSprite, 0, false, false)
                            local startPos = PST_getNodePos(col, #tmpColumn, row)
                            local endPos = PST_getNodePos(col + 1, #nextColumn, targetNodeRow)
                            local dist = math.ceil(startPos:Distance(endPos))
                            linkBeam:Add(startPos, 0)
                            linkBeam:Add(endPos, math.min(129, dist))
                            linkBeam:Render()
                        end
                    end
                end
            end
        end
    end

    -- Draw nodes
    for i, tmpColumn in ipairs(expData.nodes) do
        for j, tmpNode in ipairs(tmpColumn) do
            local drawPos = PST_getNodePos(i, #tmpColumn, j)

            if tmpNode.accessible == false and tmpNode.nodeType ~= PSTExpNodeType.COMPLETED then
                expedScreen.expNodeSprite.Color = colGray
                expedScreen.itemRewardSprite.Color = colGray
            else
                expedScreen.expNodeSprite.Color = colWhite
                expedScreen.itemRewardSprite.Color = colWhite
            end

            expedScreen.expNodeSprite:SetFrame("Nodes", tmpNode.nodeType)
            expedScreen.expNodeSprite:Render(drawPos)

            if tmpNode.nodeType ~= PSTExpNodeType.COMPLETED then
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
            end

            -- Hovered node
            local nodeHalf = 16 * expedScreen.zoomScale
            if expedScreen.camCenterX >= drawPos.X - nodeHalf and expedScreen.camCenterX <= drawPos.X + nodeHalf and
            expedScreen.camCenterY >= drawPos.Y - nodeHalf and expedScreen.camCenterY <= drawPos.Y + nodeHalf then
                expedScreen.hoveredNode = tmpNode
            end
        end
    end
end

return expedScreenMainTab