local boxLineHeight = 14

-- Indexes for these correspond to the frame # in the UI sprite's Filters anim
local invFilters = {
    { weaponType = PSTAstralWepType.LONGSWORD },
    { weaponType = PSTAstralWepType.ESTOC },
    { weaponType = PSTAstralWepType.DAGGER },
    { weaponType = PSTAstralWepType.QUICKBLADE },
    { weaponType = PSTAstralWepType.SPEAR },
    { weaponType = PSTAstralWepType.TRIDENT },
    { weaponType = PSTAstralWepType.SCYTHE },
    { weaponType = PSTAstralWepType.AXE },
    { weaponType = PSTAstralWepType.GREATAXE },
    { weaponType = PSTAstralWepType.SHORTBOW },
    { weaponType = PSTAstralWepType.BOW },
    { weaponType = PSTAstralWepType.CROSSBOW },
    { weaponRarity = PSTAstralWepRarity.NORMAL },
    { weaponRarity = PSTAstralWepRarity.MAGIC },
    { weaponRarity = PSTAstralWepRarity.ANCIENT }
}
local wepRarityStr = {"Normal", "Magic", "Ancient"}
local UIMats = {
    {
        -- Mundane Essence
        {name = "Mundane Essence", frame = 3, targetVal = "mundaneEssence", color = KColor(0.85, 0.85, 0.85, 1),
        source = {"    Deconstructing normal weapons." }},
        -- Sparkling Essence
        {name = "Sparkling Essence", frame = 4, targetVal = "sparkEssence", color = KColor(0.8, 0.8, 1, 1),
        source = {"    Deconstructing weapons with modifiers (magic/ancient)."}},
        -- Ancient Essence
        {name = "Ancient Essence", frame = 5, targetVal = "ancientEssence", color = PST:RGBKColor(255, 172, 28),
        source = {"    Deconstructing ancient weapons."}},
    },
    {
        -- Sparkling Stardust
        {name = "Sparkling Stardust", frame = 1, targetVal = "sparkStardust", color = KColor(0.8, 0.8, 1, 1),
        source = {"    Killing bosses & clearing challenge rooms."}},
        -- Ancient Stardust
        {name = "Ancient Stardust", frame = 2, targetVal = "ancientStardust", color = PST:RGBKColor(255, 172, 28),
        source = {"    Killing final bosses."}},
    }
}

---@param tScreen PST.treeScreen
local function astralForgeScreenRender(self, tScreen)
    local baseDrawX = self.camCenterX - self.camera.X
    local baseDrawY = self.camCenterY - self.camera.Y

    local startX = baseDrawX - 200
    local startY = baseDrawY - 80
    -- Draw inventory
    local tmpX, tmpY = startX, startY
    self:DrawUIBox(tmpX, tmpY, 170, 182)
    PST.miniFont:DrawString("Weapon Inventory", tmpX + 3, tmpY, KColor(1, 0.7, 0.3, 1))
    tmpY = tmpY + 17

    -- Draw material counts UI box
    local matsX = startX
    local matsY = startY - 60
    self:DrawUIBox(matsX, matsY, 170, 54)
    PST.miniFont:DrawString("Materials", matsX + 3, matsY, KColor(1, 0.7, 0.3, 1))
    matsX = matsX + 3
    matsY = matsY + 17
    local hoveredMat = nil
    for _, tmpCol in ipairs(UIMats) do
        for i, tmpMat in ipairs(tmpCol) do
            local tmpMatX = matsX + 48 * (i - 1)
            self.forgeUISprite:SetFrame("Resources", tmpMat.frame)
            self.forgeUISprite:Render(Vector(tmpMatX, matsY))
            PST.miniFont:DrawString("x" .. tostring(PST.modData[tmpMat.targetVal]), tmpMatX + 17, matsY, tmpMat.color)

            -- Hovered material
            if self.camCenterX >= tmpMatX and self.camCenterX <= tmpMatX + 55 and
            self.camCenterY >= matsY and self.camCenterY <= matsY + 15 then
                hoveredMat = tmpMat
            end
        end
        matsY = matsY + 17
    end

    -- Inventory filter buttons
    for i, tmpFilter in ipairs(invFilters) do
        local filterX = tmpX + 3 + 18 * ((i - 1) % 8)
        local filterY = tmpY + 18 * math.floor((i - 1) / 8)

        if tmpFilter.weaponType ~= nil and PST:arrHasValue(self.appliedFilters.weaponType, tmpFilter.weaponType) or
        tmpFilter.weaponRarity ~= nil and PST:arrHasValue(self.appliedFilters.weaponRarity, tmpFilter.weaponRarity) then
            self.forgeUISprite.Color.RO = 0.4
            self.forgeUISprite.Color.GO = 0.4
            self.forgeUISprite.Color.BO = 0.4
        end

        self.forgeUISprite:SetFrame("Filters", i - 1)
        self.forgeUISprite:Render(Vector(filterX, filterY))

        -- Hovered filter
        if self.camCenterX >= filterX and self.camCenterX <= filterX + 16 and
        self.camCenterY >= filterY and self.camCenterY <= filterY + 16 then
            self.hoveredFilter = tmpFilter
        end

        self.forgeUISprite.Color.RO = 0
        self.forgeUISprite.Color.GO = 0
        self.forgeUISprite.Color.BO = 0
    end

    -- Deconstruction button
    local deconX = startX - 18
    local deconY = startY + 16
    self.forgeUISprite:SetFrame("UI", 1)
    self.forgeUISprite:Render(Vector(deconX, deconY))
    self.deconHovered = self.camCenterX >= deconX - 16 and self.camCenterX <= deconX + 16 and
                        self.camCenterY >= deconY - 16 and self.camCenterY <= deconY + 16
    if self.deconMode then
        tScreen.modules.nodeDrawingModule.nodesExtraSprite:SetFrame("Allocated Small", 0)
        tScreen.modules.nodeDrawingModule.nodesExtraSprite:Render(Vector(deconX, deconY))
    end

    tmpY = tmpY + math.ceil(#invFilters / 8) * 18 + 3

    -- Weapons
    local drawnWeps = {}
    local hasTypeFilter = #self.appliedFilters.weaponType > 0
    local hasRarityFilter = #self.appliedFilters.weaponRarity > 0
    -- Create filtered list
    if hasTypeFilter or hasRarityFilter then
        for _, tmpWeapon in ipairs(PST.modData.astralWepInventory) do
            if (not hasTypeFilter or (hasTypeFilter and PST:arrHasValue(self.appliedFilters.weaponType, tmpWeapon.type))) and
            (not hasRarityFilter or (hasRarityFilter and PST:arrHasValue(self.appliedFilters.weaponRarity, tmpWeapon.rarity))) then
                table.insert(drawnWeps, tmpWeapon)
            end
        end
    else
        drawnWeps = PST.modData.astralWepInventory
    end
    -- Draw weapons
    for i, tmpWeapon in ipairs(drawnWeps) do
        local wepX = tmpX + 18 + 34 * ((i - 1) % 5)
        local wepY = tmpY + 16 + 34 * math.floor((i - 1) / 5)

        -- Hovered weapon
        if self.camCenterX >= wepX - 16 and self.camCenterX <= wepX + 16 and
        self.camCenterY >= wepY - 16 and self.camCenterY <= wepY + 16 then
            self.hoveredWeapon = tmpWeapon
            self.weaponSprite.Color.RO = 0.4
            self.weaponSprite.Color.GO = 0.4
            self.weaponSprite.Color.BO = 0.4
        end
        PST:renderAstralWepAt(tmpWeapon, self.weaponSprite, wepX, wepY)

        -- Equipped
        if tmpWeapon.equipped then
            PST.miniFont:DrawString("E", wepX + 8, wepY + 4, KColor(1, 1, 0.7, 1))
        end

        self.weaponSprite.Color.RO = 0
        self.weaponSprite.Color.GO = 0
        self.weaponSprite.Color.BO = 0
    end

    -- Weapon forging UI box
    tmpX = startX + 176
    tmpY = startY
    -- Determine box width/height based on selected weapon info
    local tmpBoxW, tmpBoxH = 320, 182
    local selectedWepDesc = {}
    if self.selectedWeapon then
        selectedWepDesc = PST:getAstralWepDesc(self.selectedWeapon, true)
        for _, tmpLine in ipairs(selectedWepDesc) do
            local tmpStr = tmpLine
            if type(tmpLine) == "table" then tmpStr = tmpLine[1] end
            tmpBoxW = math.max(PST.miniFont:GetStringWidth(tmpStr) + 12, tmpBoxW)
        end
        tmpBoxH = math.max(#selectedWepDesc * boxLineHeight + 60, tmpBoxH)
    end
    self:DrawUIBox(tmpX, tmpY, tmpBoxW, tmpBoxH)

    PST.miniFont:DrawString("Weapon Forging", tmpX + 3, tmpY, KColor(1, 0.7, 0.3, 1))
    tmpY = tmpY + 17

    -- Selected weapon slot
    local selWepX = tmpX + 19
    local selWepY = tmpY + 16
    self.forgeUISprite:SetFrame("UI", 0)
    self.forgeUISprite:Render(Vector(selWepX, selWepY))

    if not self.selectedWeapon then
        PST.miniFont:DrawString("Select a weapon from your inventory to begin forging.", selWepX + 18, tmpY, KColor(1, 1, 1, 1))
    else
        -- Selected weapon data
        PST:renderAstralWepAt(self.selectedWeapon, self.weaponSprite, selWepX, selWepY)
        selWepX = selWepX - 15
        selWepY = selWepY + 18
        for _, tmpLine in ipairs(selectedWepDesc) do
            if type(tmpLine) == "table" then
                PST.miniFont:DrawString(tmpLine[1], selWepX, selWepY, tmpLine[2])
            else
                PST.miniFont:DrawString(tmpLine, selWepX, selWepY, KColor(1, 1, 1, 1))
            end
            selWepY = selWepY + boxLineHeight
        end
    end

    -- Cursor
    if hoveredMat or self.hoveredWeapon or self.hoveredFilter or self.deconHovered then
        tScreen.cursorSprite:Play("Clicked", true)
    else
        tScreen.cursorSprite:Play("Idle", true)
    end
    tScreen.cursorSprite:Render(Vector(tScreen.screenW / 2, tScreen.screenH / 2))

    -- Control hints
    if not self.selectedWeapon then
        tmpY = startY + 180
        PST.luaminiFont:DrawString("Press Allocate to equip hovered weapon.", startX, tmpY, KColor(1, 1, 1, 1))
        tmpY = tmpY + 12
        PST.luaminiFont:DrawString("Shift + Allocate to select hovered weapon for forging.", startX, tmpY, KColor(1, 1, 1, 1))
    end

    -- Hovered filter description
    if self.hoveredFilter then
        local hoverStr = "Filter: "
        if self.hoveredFilter.weaponType then
            hoverStr = hoverStr .. PST.astralWepData[self.hoveredFilter.weaponType].name .. "s"
        elseif self.hoveredFilter.weaponRarity then
            hoverStr = hoverStr .. wepRarityStr[self.hoveredFilter.weaponRarity + 1]
        end
        tScreen:DrawNodeBox(hoverStr, {"Press the Allocate button to apply this filter."})
    -- Hovered material description
    elseif hoveredMat then
        local tmpMatDesc = {
            {hoveredMat.name, hoveredMat.color},
            "Source:", table.unpack(hoveredMat.source)
        }
        tScreen:DrawNodeBox("Forge Material", tmpMatDesc)
    -- Hovered weapon description
    elseif self.hoveredWeapon then
        local tmpTitle = "Astral Weapon"
        if self.hoveredWeapon.equipped then
            tmpTitle = tmpTitle .. " (Equipped)"
        end

        local wepDesc = {}
        if not self.deconMode then
            wepDesc = PST:getAstralWepDesc(self.hoveredWeapon, PST:isKeybindActive(PSTKeybind.PAN_FASTER, true))
        -- Deconstruction mode weapon description
        else
            table.insert(wepDesc, {"* Deconstructing Weapon *", KColor(1, 0.5, 0.5, 1)})
            -- Get deconstruction materials
            local wepMats = PST:getAstralWepDeconMats(self.hoveredWeapon)
            if wepMats.mundane > 0 then
                table.insert(wepDesc, tostring(wepMats.mundane) .. "x Mundane Essence.")
            end
            if wepMats.spark > 0 then
                table.insert(wepDesc, {tostring(wepMats.spark) .. "x Sparkling Essence.", KColor(0.8, 0.8, 1, 1)})
            end
            if wepMats.ancient > 0 then
                table.insert(wepDesc, {tostring(wepMats.spark) .. "x Ancient Essence.", PST:RGBKColor(255, 172, 28)})
            end
            if self.hoveredWeapon.rarity ~= PSTAstralWepRarity.ANCIENT then
                table.insert(wepDesc, "Press the Respec button to deconstruct this weapon and gain these materials.")
            else
                table.insert(wepDesc, "Hold the Respec button for 1 second to deconstruct this weapon and gain these materials.")
            end
        end

        tScreen:DrawNodeBox(tmpTitle, wepDesc)
    -- Hovered deconstruction button description
    elseif self.deconHovered then
        local deconDesc = {
            "Press the Allocate button to toggle Deconstruction Mode.",
            "While in deconstruction mode, hover over a weapon and press Respec to deconstruct it into",
            "forging materials, destroying it in the process."
        }
        tScreen:DrawNodeBox("Toggle Deconstruction Mode", deconDesc)
    end
end

return astralForgeScreenRender