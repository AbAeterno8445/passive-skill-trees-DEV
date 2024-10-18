local tmpLineHeight = 15
local baseDrawX, baseDrawY = 0, 0

-- Text render helper
local function tmpRenderText(txt, color, offsetY)
    PST.miniFont:DrawString(txt, baseDrawX, baseDrawY, color)
    offsetY = offsetY or tmpLineHeight
    baseDrawY = baseDrawY + offsetY
end

---@param expData PSTExpedition
---@param expedScreen table
---@param tScreen PST.treeScreen
local function expedScreenEffectTab(expData, expedScreen, tScreen)
    baseDrawX = tScreen.screenW * 0.2 - expedScreen.camera.X
    baseDrawY = 20 + tmpLineHeight - expedScreen.camera.Y

    -- Values are tables, {requirement description string, true/false whether req is met}
    local tmpRequirements = {}

    if expData.implicits then
        -- Starmight requirement
        local tmpReq = expData.implicits.starmightReq
        if tmpReq and tmpReq > 0 then
            local tmpStr = "Starmight required: " .. tostring(tmpReq)
            local totalStarmight = 0
            if tScreen.starcursedTotalMods and tScreen.starcursedTotalMods.totalStarmight then
                totalStarmight = tScreen.starcursedTotalMods.totalStarmight
                tmpStr = tmpStr .. " (your total: " .. tostring(totalStarmight) .. ")"
            end
            table.insert(tmpRequirements, {tmpStr, totalStarmight >= tmpReq})
        end
    end

    local requirementsMet = true
    if #tmpRequirements > 0 then
        tmpRenderText("Expedition requirements:", KColor(1, 0.8, 0.2, 1))
        for _, reqData in ipairs(tmpRequirements) do
            local tmpColor = KColor(0.7, 1, 0.7, 1)
            if not reqData[2] then
                requirementsMet = false
                tmpColor = KColor(1, 0.5, 0.5, 1)
            end
            tmpRenderText("    " .. reqData[1], tmpColor)
        end
    end
    if not requirementsMet then
        tmpRenderText("Warning: missing requirements! Next run can't be an expedition run.", KColor(1, 0.5, 0.5, 1))
    end
end

return expedScreenEffectTab