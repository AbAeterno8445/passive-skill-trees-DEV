local bubbleCols = 5

local function expedScreenDepthTab(expData, expedScreen, tScreen)
    local baseDrawX = expedScreen.camCenterX - expedScreen.camera.X
    local baseDrawY = expedScreen.camCenterY - expedScreen.camera.Y

    local flip = false
    local flipC = 0
    for i=1,PST.modData.expeditionDepth + 1 do
        local drawX = baseDrawX + flipC * 40
        local drawY = baseDrawY + math.floor((i - 1) / bubbleCols) * 40

        -- Depth num
        local tmpColor = KColor(1, 1, 1, 1)
        if i == expedScreen.currentDepth then
            tmpColor = KColor(0.5, 1, 0.5, 1)
        elseif i > PST.modData.expeditionDepth then
            tmpColor = KColor(0.6, 0.6, 0.6, 1)
        elseif PST.expeditionsData[i] then
            tmpColor = KColor(0.3, 0.6, 1, 1)
        end
        PST.miniFont:DrawString(tostring(i), drawX - PST.miniFont:GetStringWidth(tostring(i)) / 2, drawY - 7, tmpColor)

        -- Hovered depth
        local hovered = false
        local nodeHalf = 15
        if expedScreen.camCenterX >= drawX - nodeHalf and expedScreen.camCenterX <= drawX + nodeHalf and
        expedScreen.camCenterY >= drawY - nodeHalf and expedScreen.camCenterY <= drawY + nodeHalf then
            hovered = true
            expedScreen.hoveredDepth = i
        end

        -- Bubble
        local tmpFrame = 4
        if expedScreen.currentDepth == i then tmpFrame = 0 end
        expedScreen.boonSprite.Scale = Vector(0.8, 0.8)
        if hovered then expedScreen.boonSprite.Color = Color(1, 1, 1, 1, 0.5, 0.5, 0.5) end

        expedScreen.boonSprite:SetFrame("Bubbles", tmpFrame)
        expedScreen.boonSprite:Render(Vector(drawX, drawY))

        if hovered then expedScreen.boonSprite.Color = Color(1, 1, 1, 1) end
        expedScreen.boonSprite.Scale = Vector.One

        -- Locked icon
        if i > PST.modData.expeditionDepth then
            PST.cosmicRData.charSprite:Play("Locked", true)
            PST.cosmicRData.charSprite:Render(Vector(drawX + 3, drawY + 3))
        end

        if not flip then
            if flipC == bubbleCols - 1 then
                flip = true
            else
                flipC = flipC + 1
            end
        else
            if flipC == 0 then
                flip = false
            else
                flipC = flipC - 1
            end
        end
    end
end

return expedScreenDepthTab