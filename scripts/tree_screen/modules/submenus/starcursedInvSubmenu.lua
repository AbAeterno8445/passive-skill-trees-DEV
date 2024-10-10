local jewelsPerPage = 25

local starcursedInvSubmenu = {
    jewelType = "",
    menuX = 0,
    menuY = 0,
    socket = nil,
    ---@type any
    hoveredJewel = nil,
    hoveredJewelID = nil,
    invPage = 0
}

---@param openData? table
function starcursedInvSubmenu:OnOpen(openData)
    if not openData then return end
    for k, v in pairs(openData) do
        self[k] = v
    end
end

---@param tScreen PST.treeScreen
function starcursedInvSubmenu:Render(tScreen, submenusModule)
    local tmpJewelType = self.jewelType
    local tmpJewelPages = math.ceil(#PST.modData.starTreeInventory[tmpJewelType] / jewelsPerPage)
    local tmpTitle = tmpJewelType .. " Inventory"
    if self.socket then
        tmpTitle = tmpJewelType .. " Socket " .. tostring(self.socket)
    end

    self.hoveredJewel = nil
    self.hoveredJewelID = nil
    submenusModule:DrawNodeSubMenu(
        tScreen,
        jewelsPerPage, tScreen.camCenterX, tScreen.camCenterY,
        self.menuX, self.menuY,
        tmpTitle,
        function()
            -- Draw Starcursed Jewels
            local jewelSprite = tScreen.modules.nodeDrawingModule.SCJewelSprite
            for i=1,jewelsPerPage do
                local jewelID = i + self.invPage * jewelsPerPage
                local jewelData = PST.modData.starTreeInventory[tmpJewelType][jewelID]
                if jewelData then
                    local jewelX = self.menuX * tScreen.zoomScale - 64 + ((i - 1) % 5) * 32
                    local jewelY = self.menuY * tScreen.zoomScale + 52 + math.floor((i - 1) / 5) * 32

                    -- Hovered
                    if tScreen.camCenterX > jewelX - 16 and tScreen.camCenterX < jewelX + 16 and
                    tScreen.camCenterY > jewelY - 16 and tScreen.camCenterY < jewelY + 16 then
                        self.hoveredJewel = jewelData
                        self.hoveredJewelID = jewelID
                        jewelSprite.Color.A = 1
                        PST.cosmicRData.charSprite.Color.A = 1
                        PST.cosmicRData.charSprite:Play("Select", true)
                        PST.cosmicRData.charSprite:Render(Vector(
                            jewelX - tScreen.treeCamera.X - tScreen.camZoomOffset.X,
                            jewelY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                        ))
                        tScreen.cursorHighlight = true
                    else
                        jewelSprite.Color.A = 0.7
                    end

                    PST:SC_setSpriteToJewel(jewelSprite, jewelData)
                    jewelSprite:Render(Vector(
                        jewelX - tScreen.treeCamera.X - tScreen.camZoomOffset.X,
                        jewelY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                    ))

                    if jewelData.unidentified then
                        jewelSprite:Play("Unidentified", true)
                        jewelSprite:Render(Vector(
                            jewelX - tScreen.treeCamera.X - tScreen.camZoomOffset.X,
                            jewelY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                        ))
                    else
                        if jewelData.equipped then
                            PST.miniFont:DrawString(
                                "E",
                                jewelX - tScreen.treeCamera.X - tScreen.camZoomOffset.X + 8,
                                jewelY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y,
                                KColor(1, 1, 0.6, 1)
                            )
                        end
                        if jewelData.mighty then
                            PST.miniFont:DrawString(
                                "*",
                                jewelX - tScreen.treeCamera.X - tScreen.camZoomOffset.X + 8,
                                jewelY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y - 16,
                                KColor(0.6, 1, 1, 1)
                            )
                        end
                    end
                end
            end
        end,
        {
            prevFunc = function()
                if self.invPage > 0 then
                    self.invPage = self.invPage - 1
                end
            end,
            prevDisabled = self.invPage == 0,
            nextFunc = function()
                if self.invPage < tmpJewelPages - 1 then
                    self.invPage = self.invPage + 1
                end
            end,
            nextDisabled = self.invPage >= tmpJewelPages - 1,
            itemNum = tmpJewelType ~= PSTStarcursedType.ANCIENT and #PST.modData.starTreeInventory[tmpJewelType] or nil,
            maxItems = PST.SCMaxInv
        }
    )
end

return starcursedInvSubmenu