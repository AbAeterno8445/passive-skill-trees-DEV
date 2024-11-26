local nodesPerPage = 25

---@enum PSTCrimsonNodeType
PSTCrimsonNodeType = {
    UNIVERSAL = 1,
    CORE = 2,
    DIVERGENT = 3
}

local crimsonNodeSubmenu = {
    ---@type PSTCrimsonNodeType|nil
    crimsonType = nil,
    crimsonNodeID = nil,

    menuX = 0,
    menuY = 0,
    ---@type any
    hoveredNode = nil,
    invPage = 0
}

---@param openData? table
function crimsonNodeSubmenu:OnOpen(openData)
    if not openData then return end
    for k, v in pairs(openData) do
        self[k] = v
    end
end

function crimsonNodeSubmenu:OnClose()
    self.crimsonType = nil
end

local crimsonNodeName = {
    [PSTCrimsonNodeType.UNIVERSAL] = "Universal",
    [PSTCrimsonNodeType.CORE] = "Core",
    [PSTCrimsonNodeType.DIVERGENT] = "Divergent"
}

---@param tScreen PST.treeScreen
function crimsonNodeSubmenu:Render(tScreen, submenusModule)
    local tmpCrimsonType = self.crimsonType
    if not tmpCrimsonType then return end

    local tgtNodeTable = PST.globalMedNodes

    if tmpCrimsonType ~= PSTCrimsonNodeType.UNIVERSAL then
        tgtNodeTable = {}
        for tmpTree, _ in pairs(PST.charMedNodes) do
            local isThisCharTree = (tmpTree == PST:getCurrentCharName())
            if (tmpCrimsonType == PSTCrimsonNodeType.CORE and isThisCharTree) or (tmpCrimsonType == PSTCrimsonNodeType.DIVERGENT and not isThisCharTree) then
                for nodeName, node in pairs(PST.charMedNodes[tmpTree]) do
                    tgtNodeTable[nodeName] = node
                end
            end
        end
    end

    local medNodeTable = {}
    for _, node in pairs(tgtNodeTable) do
        table.insert(medNodeTable, node)
    end

    local tmpPages = math.ceil(#medNodeTable / nodesPerPage)

    self.hoveredNode = nil
    submenusModule:DrawNodeSubMenu(
        tScreen,
        nodesPerPage, tScreen.camCenterX, tScreen.camCenterY,
        self.menuX, self.menuY,
        crimsonNodeName[tmpCrimsonType] .. " Crimson Node",
        function()
            local nodeSprite = tScreen.modules.nodeDrawingModule.nodesSprite
            local oldScaleX, oldScaleY, oldAlpha = nodeSprite.Scale.X, nodeSprite.Scale.Y, nodeSprite.Color.A
            nodeSprite.Scale.X = 1
            nodeSprite.Scale.Y = 1
            nodeSprite.Color.A = 1

            -- Draw available medium nodes
            for i=1,nodesPerPage do
                local nodeID = i + self.invPage * nodesPerPage
                local nodeData = medNodeTable[nodeID]
                if nodeData then
                    local nodeX = self.menuX * tScreen.zoomScale - 64 + ((i - 1) % 5) * 32
                    local nodeY = self.menuY * tScreen.zoomScale + 52 + math.floor((i - 1) / 5) * 32

                    -- Hovered
                    if tScreen.camCenterX > nodeX - 16 and tScreen.camCenterX < nodeX + 16 and
                    tScreen.camCenterY > nodeY - 16 and tScreen.camCenterY < nodeY + 16 then
                        self.hoveredNode = nodeData
                        nodeSprite.Color.A = 1
                        tScreen.cursorHighlight = true
                    else
                        nodeSprite.Color.A = 0.6
                    end

                    nodeSprite:SetFrame("Default", nodeData.sprite)
                    nodeSprite:Render(Vector(
                        nodeX - tScreen.treeCamera.X - tScreen.camZoomOffset.X,
                        nodeY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                    ))
                end
            end

            -- Reset node sprite
            nodeSprite.Scale.X = oldScaleX
            nodeSprite.Scale.Y = oldScaleY
            nodeSprite.Color.A = oldAlpha
        end,
        {
            prevFunc = function()
                if self.invPage > 0 then
                    self.invPage = self.invPage - 1
                end
            end,
            prevDisabled = self.invPage == 0,
            nextFunc = function()
                if self.invPage < tmpPages - 1 then
                    self.invPage = self.invPage + 1
                end
            end,
            nextDisabled = self.invPage >= tmpPages - 1,
            itemNum = #medNodeTable
        }
    )
end

return crimsonNodeSubmenu