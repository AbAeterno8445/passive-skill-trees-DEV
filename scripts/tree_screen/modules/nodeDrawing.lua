local nodeDrawingModule = {
    -- For 'available' node flashing effect
    alphaFlash = 0,
    alphaFlashFlip = false,
    flashStep = 0.02,

    -- Sprites
    nodesSprite = Sprite("gfx/ui/skilltrees/nodes/tree_nodes.anm2", true),
    nodeLinkSprite = Sprite("gfx/ui/skilltrees/nodes/node_links.anm2", true),
    nodesExtraSprite = Sprite("gfx/ui/skilltrees/nodes/nodes_extra.anm2", true),

    SCJewelSprite = Sprite("gfx/items/starcursed_jewels.anm2", true)
}

-- Init sprites
nodeDrawingModule.nodesSprite:Play("Default", true)

---@param tScreen PST.treeScreen
function nodeDrawingModule:Update(tScreen)
    if not self.alphaFlashFlip then
        if self.alphaFlash > 0.2 then
            self.alphaFlash = self.alphaFlash - self.flashStep
        else
            self.alphaFlashFlip = true
        end
    else
        if self.alphaFlash < 1 then
            self.alphaFlash = self.alphaFlash + self.flashStep
        else
            self.alphaFlashFlip = false
        end
    end
end

---@param tScreen PST.treeScreen
function nodeDrawingModule:Render(tScreen)
    -- Draw node links
    for _, nodeLink in ipairs(PST.nodeLinks[tScreen.currentTree]) do
        local linkX = nodeLink.pos.X * 38 * tScreen.zoomScale + nodeLink.dirX * 19 * tScreen.zoomScale
        local linkY = nodeLink.pos.Y * 38 * tScreen.zoomScale + nodeLink.dirY * 19 * tScreen.zoomScale

        local hasNode1 = PST:isNodeAllocated(tScreen.currentTree, nodeLink.node1)
        local hasNode2 = PST:isNodeAllocated(tScreen.currentTree, nodeLink.node2)
        if hasNode1 and hasNode2 then
            self.nodeLinkSprite:Play(nodeLink.type .. " Allocated", true)
        elseif hasNode1 or hasNode2 then
            self.nodeLinkSprite:Play(nodeLink.type .. " Available", true)
        else
            self.nodeLinkSprite:Play(nodeLink.type .. " Unavailable", true)
        end

        local finalDrawX = linkX - tScreen.treeCamera.X - tScreen.camZoomOffset.X
        local finalDrawY = linkY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
        if tScreen:IsSpriteVisibleAt(finalDrawX, finalDrawY, 76, 76) then
            self.nodeLinkSprite.Scale = nodeLink.origScale * tScreen.zoomScale
            self.nodeLinkSprite:Render(Vector(finalDrawX, finalDrawY))
        end
    end

    -- Draw nodes
    local cosmicRChar = PST.modData.cosmicRealignment
    for _, node in pairs(PST.trees[tScreen.currentTree]) do
        local nodeX = node.pos.X * 38 * tScreen.zoomScale
        local nodeY = node.pos.Y * 38 * tScreen.zoomScale

        local tmpSprite = self.nodesSprite
        if node.customID and PST.customNodeImages[node.customID] then
            tmpSprite = PST.customNodeImages[node.customID]
        end

        local finalDrawX = nodeX - tScreen.treeCamera.X - tScreen.camZoomOffset.X
        local finalDrawY = nodeY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y

        if tScreen:IsSpriteVisibleAt(finalDrawX, finalDrawY, 38, 38) then
            local nodeAllocated = PST:isNodeAllocated(tScreen.currentTree, node.id)
            if node.available and not nodeAllocated then
                if not PST.debugOptions.infSP and PST:isNodeAllocatable(tScreen.currentTree, node.id, true) then
                    self.nodesExtraSprite:SetFrame("Available " .. node.size, 0)
                    self.nodesExtraSprite.Color = PST.colors.GRAY3
                    self.nodesExtraSprite.Color.A = self.alphaFlash
                    self.nodesExtraSprite:Render(Vector(finalDrawX, finalDrawY))
                end
            end

            local isAllocated = PST:isNodeAllocated(tScreen.currentTree, node.id)
            local isAstralForge = node.name == "Astral Forge"

            if isAstralForge and isAllocated then
                tmpSprite.Color.RO = 0.15
                tmpSprite.Color.GO = 0.1
            end

            tmpSprite:SetFrame("Default", node.sprite)
            if not nodeAllocated and not node.available then
                tmpSprite.Color = PST.colors.GRAY3
            end
            tmpSprite:Render(Vector(finalDrawX, finalDrawY))
            tmpSprite.Color = PST.colors.WHITE

            tmpSprite.Color.RO = 0
            tmpSprite.Color.GO = 0

            -- Astral Forge node, draw sword icon or equipped weapon
            if isAstralForge then
                local eqWeapon = PST:getEquippedAstralWep()
                if eqWeapon and isAllocated then
                    local forgeMenu = tScreen.modules.menuScreensModule.menus[PSTTreeScreenMenu.ASTRAL_FORGE]
                    PST:renderAstralWepAt(eqWeapon, forgeMenu.weaponSprite, finalDrawX, finalDrawY, tScreen.zoomScale)
                else
                    tmpSprite:SetFrame("Default", 761)
                    tmpSprite:Render(Vector(finalDrawX, finalDrawY))
                end
            end

            if not isAstralForge and isAllocated then
                self.nodesExtraSprite.Color = Color(1, 1, 1, 1)
                self.nodesExtraSprite.Color.A = 1
                self.nodesExtraSprite:SetFrame("Allocated " .. node.size, 0)
                self.nodesExtraSprite:Render(Vector(finalDrawX, finalDrawY))
            end

            local nodeHalf = 15 * tScreen.zoomScale
            if tScreen.camCenterX >= nodeX - nodeHalf and tScreen.camCenterX <= nodeX + nodeHalf and
            tScreen.camCenterY >= nodeY - nodeHalf and tScreen.camCenterY <= nodeY + nodeHalf then
                tScreen.hoveredNode = node
            end

            -- Cosmic Realignment node, draw picked character
            if node.name == "Cosmic Realignment" and type(cosmicRChar) == "number" then
                local charName = PST.charNames[1 + cosmicRChar]
                PST.cosmicRData.charSprite.Color.A = 1
                PST.cosmicRData.charSprite.Scale.X = tScreen.zoomScale
                PST.cosmicRData.charSprite.Scale.Y = tScreen.zoomScale
                PST.cosmicRData.charSprite:Play(charName, true)
                PST.cosmicRData.charSprite:Render(Vector(finalDrawX, finalDrawY))
            else
                -- Starcursed jewel sockets, draw socketed jewel
                for _, tmpType in pairs(PSTStarcursedType) do
                    if PST:strStartsWith(node.name, tmpType .. " Socket") then
                        local socketID = string.sub(node.name, -1)
                        local socketedJewel = PST:SC_getSocketedJewel(tmpType, socketID)
                        if socketedJewel and socketedJewel.equipped == socketID then
                            self.SCJewelSprite.Scale.X = tScreen.zoomScale
                            self.SCJewelSprite.Scale.Y = tScreen.zoomScale
                            PST:SC_setSpriteToJewel(self.SCJewelSprite, socketedJewel)
                            self.SCJewelSprite:Render(Vector(finalDrawX, finalDrawY))
                        end
                    end
                end
            end

            -- Debug: show node IDs
            if PST.debugOptions.drawNodeIDs then
                Isaac.RenderText(tostring(node.id), finalDrawX - 12, finalDrawY - 12, 1, 1, 1, 1)
            end
        end
    end
    -- Update custom images scale
    for _, imgSprite in pairs(PST.customNodeImages) do
        if imgSprite.Scale.X ~= tScreen.zoomScale then
            imgSprite.Scale.X = tScreen.zoomScale
            imgSprite.Scale.Y = tScreen.zoomScale
        end
    end
end

return nodeDrawingModule