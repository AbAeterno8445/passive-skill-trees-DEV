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
    { weaponType = PSTAstralWepType.GAUNTLET },
    { weaponType = PSTAstralWepType.GREATMACE },
    { weaponType = PSTAstralWepType.WHIP },
    { weaponRarity = PSTAstralWepRarity.NORMAL },
    { weaponRarity = PSTAstralWepRarity.MAGIC },
    { weaponRarity = PSTAstralWepRarity.ANCIENT },
    { honing = 1 },
    { honing = 2 },
    { honing = 3 },
    { favorite = true }
}
local wepRarityStr = {"Normal", "Magic", "Ancient"}
local matsData = {
    mundaneEssence = {PST:getLocalized("ui_mundaneEssence"), PST.kcolors.WHITE},
    sparkEssence = {PST:getLocalized("ui_sparklingEssence"), PST.kcolors.LIGHTBLUE1},
    ancientEssence = {PST:getLocalized("ui_ancientEssence"), PST.kcolors.ANCIENT_ORANGE},
    sparkStardust = {PST:getLocalized("ui_sparklingStardust"), PST.kcolors.LIGHTBLUE1},
    ancientStardust = {PST:getLocalized("ui_ancientStardust"), PST.kcolors.ANCIENT_ORANGE},
    starblessPrism = {PST:getLocalized("ui_starblessedPrism"), PST.kcolors.TEAL1}
}
local matsOrder = {"mundaneEssence", "sparkEssence", "sparkStardust", "ancientEssence", "ancientStardust", "starblessPrism"}
local UIMats = {
    {
        -- Mundane Essence
        {name = PST:getLocalized("ui_mundaneEssence"), frame = 3, targetVal = "mundaneEssence", color = PST.kcolors.LIGHTGRAY1,
        source = {"    " .. PST:getLocalized("ui_mundaneEssence_src") }},
        -- Sparkling Essence
        {name = PST:getLocalized("ui_sparklingEssence"), frame = 4, targetVal = "sparkEssence", color = PST.kcolors.LIGHTBLUE1,
        source = {"    " .. PST:getLocalized("ui_sparklingEssence_src")}},
        -- Ancient Essence
        {name = PST:getLocalized("ui_ancientEssence"), frame = 5, targetVal = "ancientEssence", color = PST.kcolors.ANCIENT_ORANGE,
        source = {"    " .. PST:getLocalized("ui_ancientEssence_src")}},
    },
    {
        -- Sparkling Stardust
        {name = PST:getLocalized("ui_sparklingStardust"), frame = 1, targetVal = "sparkStardust", color = PST.kcolors.LIGHTBLUE1,
        source = {"    " .. PST:getLocalized("ui_sparklingStardust_src")}},
        -- Ancient Stardust
        {name = PST:getLocalized("ui_ancientStardust"), frame = 2, targetVal = "ancientStardust", color = PST.kcolors.ANCIENT_ORANGE,
        source = {"    " .. PST:getLocalized("ui_ancientStardust_src")}},
        -- Starblessed Prisms
        {name = PST:getLocalized("ui_starblessedPrism"), frame = 6, targetVal = "starblessPrism", color = PST.kcolors.TEAL1,
        source = {"    " .. PST:getLocalized("ui_starblessedPrism_src")}},
    }
}
local forgingButtons = {
    {
        name = PST:getLocalized("ui_Honing"),
        description = PST:getLocalized("ui_Honing_desc"),
        targetAction = "honing",
        actionFunc = PST.astralWepForgeHone,
        soundFunc = function() SFXManager():Play(SoundEffect.SOUND_BISHOP_HIT, 0.8) end,
        frame = 2
    },
    {
        name = PST:getLocalized("ui_Transmutation"),
        description = PST:getLocalized("ui_Transmutation_desc"),
        targetAction = "transmutation",
        actionFunc = PST.astralWepForgeTransmute,
        soundFunc = function() SFXManager():Play(SoundEffect.SOUND_FLASHBACK, 0.8, 2, false, 1.3) end,
        frame = 9,
        reqRarity = PSTAstralWepRarity.NORMAL
    },
    {
        name = PST:getLocalized("ui_rerollMods"),
        description = PST:getLocalized("ui_rerollMods_desc"),
        targetAction = "reroll",
        actionFunc = PST.astralWepForgeReroll,
        soundFunc = function() SFXManager():Play(SoundEffect.SOUND_BISHOP_HIT, 0.8, 2, false, 0.7) end,
        frame = 3,
        reqRarity = PSTAstralWepRarity.MAGIC
    },
    {
        name = PST:getLocalized("ui_addMod"),
        description = PST:getLocalized("ui_addMod_desc"),
        targetAction = "addition",
        actionFunc = PST.astralWepForgeAdd,
        soundFunc = function() SFXManager():Play(SoundEffect.SOUND_BULB_FLASH, 0.8) end,
        frame = 4,
        reqRarity = PSTAstralWepRarity.MAGIC
    },
    {
        name = PST:getLocalized("ui_removeMod"),
        description = PST:getLocalized("ui_removeMod_desc"),
        targetAction = "removal",
        actionFunc = PST.astralWepForgeRemove,
        soundFunc = function() SFXManager():Play(SoundEffect.SOUND_BULB_FLASH, 0.8, 2, false, 0.5) end,
        frame = 8,
        reqRarity = PSTAstralWepRarity.MAGIC
    },
    {
        name = PST:getLocalized("ui_alterMods"),
        description = PST:getLocalized("ui_alterMods_desc"),
        targetAction = "alteration",
        actionFunc = PST.astralWepForgeAlter,
        soundFunc = function() SFXManager():Play(SoundEffect.SOUND_LAZARUS_FLIP_DEAD, 0.8, 2, false, 0.9 + 0.2 * math.random()) end,
        frame = 7,
        reqRarity = PSTAstralWepRarity.MAGIC
    },
    {
        name = PST:getLocalized("ui_ancImprint"),
        description = PST:getLocalized("ui_ancImprint_desc"),
        imprintDescription = PST:getLocalized("ui_ancImprint_desc_imp"),
        targetAction = "imprinting",
        frame = 5,
        reqRarity = PSTAstralWepRarity.ANCIENT
    },
    {
        name = PST:getLocalized("ui_ancUpgrade"),
        description = PST:getLocalized("ui_ancUpgrade_desc"),
        targetAction = "ancUpgrade",
        actionFunc = PST.astralWepForgeAncUpg,
        soundFunc = function() SFXManager():Play(SoundEffect.SOUND_LAZARUS_FLIP_ALIVE, 0.8, 2, false, 0.9 + 0.2 * math.random()) end,
        frame = 6,
        reqRarity = PSTAstralWepRarity.ANCIENT
    },
    {
        name = PST:getLocalized("ui_starblessing"),
        description = PST:getLocalized("ui_starblessing_desc"),
        targetAction = "starbless",
        actionFunc = PST.astralWepForgeStarbless,
        soundFunc = function() SFXManager():Play(SoundEffect.SOUND_POWERUP3, 0.6, 2, false, 1 + 0.2 * math.random()) end,
        frame = 11,
        reqRarity = PSTAstralWepRarity.ANCIENT
    }
    --[[{
        name = "Ascension",
        description = {
            "Upgrade the weapon's tier by 1 level, up to tier 5.",
            "Higher tier weapon modifiers roll higher values."
        },
        targetAction = "ascension",
        actionFunc = PST.astralWepForgeAscend,
        soundFunc = function()
            SFXManager():Play(SoundEffect.SOUND_CHOIR_UNLOCK, 0.8)
            SFXManager():Play(SoundEffect.SOUND_LAZARUS_FLIP_ALIVE, 0.8, 2, false, 0.9 + 0.2 * math.random())
        end,
        frame = 10
    }]]
}

local tmpColWhite = Color(1, 1, 1, 1)
local tmpColRed = Color(1, 1, 1, 1, 0.25, 0, 0)

---@param tScreen PST.treeScreen
local function astralForgeScreenRender(self, tScreen)
    local baseDrawX = self.camCenterX - self.camera.X
    local baseDrawY = self.camCenterY - self.camera.Y

    local startX = baseDrawX - 200
    local startY = baseDrawY - 80
    -- Draw inventory
    local tmpX, tmpY = startX, startY
    self:DrawUIBox(tmpX, tmpY, 170, 268)
    -- Inventory title
    local tmpTitle = PST:getLocalized("ui_wepInv")
    if self.deconMode then tmpTitle = tmpTitle .. " (" .. PST:getLocalized("ui_decon") .. ")"
    elseif self.imprintMode then tmpTitle = tmpTitle .. " (" .. PST:getLocalized("ui_Imprint") .. ")" end
    PST.miniFont:DrawStringUTF8(tmpTitle, tmpX + 3, tmpY, PST.kcolors.FORGE_ORANGE)
    tmpY = tmpY + 17

    -- Draw material counts UI box
    local matsX = startX
    local matsY = startY - 60
    self:DrawUIBox(matsX, matsY, 170, 54)
    PST.miniFont:DrawStringUTF8(PST:getLocalized("ui_Materials"), matsX + 3, matsY, PST.kcolors.FORGE_ORANGE)
    matsX = matsX + 3
    matsY = matsY + 17
    local hoveredMat = nil
    for _, tmpCol in ipairs(UIMats) do
        for i, tmpMat in ipairs(tmpCol) do
            local tmpMatX = matsX + 48 * (i - 1)
            self.forgeUISprite:SetFrame("Resources", tmpMat.frame)
            self.forgeUISprite:Render(Vector(tmpMatX, matsY))
            PST.miniFont:DrawStringUTF8("x" .. tostring(PST.modData[tmpMat.targetVal]), tmpMatX + 17, matsY, tmpMat.color)

            -- Hovered material
            if self.camCenterX >= tmpMatX and self.camCenterX <= tmpMatX + 55 and
            self.camCenterY >= matsY and self.camCenterY <= matsY + 15 then
                hoveredMat = tmpMat
            end
        end
        matsY = matsY + 17
    end

    -- Equipped weapon UI box
    local eqWepX = startX + 176
    local eqWepY = startY - 60
    self:DrawUIBox(eqWepX, eqWepY, 170, 54)
    tmpTitle = PST:getLocalized("ui_equippedWeapon") .. " (" .. PST:getCurrentCharName() .. ")"
    PST.miniFont:DrawStringUTF8(tmpTitle, eqWepX + 3, eqWepY, PST.kcolors.FORGE_ORANGE)

    eqWepX = eqWepX + 19
    eqWepY = eqWepY + 33
    self.forgeUISprite:SetFrame("UI", 0)
    self.forgeUISprite.Color.RO = 0.25
    self.forgeUISprite.Color.BO = 0.25
    self.forgeUISprite:Render(Vector(eqWepX, eqWepY))
    self.forgeUISprite.Color.RO = 0
    self.forgeUISprite.Color.BO = 0

    local eqWeapon = PST:getEquippedAstralWep()
    if eqWeapon then
        PST:renderAstralWepAt(eqWeapon, self.weaponSprite, eqWepX, eqWepY)

        if self.camCenterX >= eqWepX - 14 and self.camCenterX <= eqWepX + 14 and
        self.camCenterY >= eqWepY - 14 and self.camCenterY <= eqWepY + 14 then
            self.hoveredWeapon = eqWeapon
        end

        eqWepX = eqWepX + 18
        eqWepY = eqWepY - 18
        PST.luaminiFont:DrawStringUTF8(PST:getLocalized("ui_hoverMoreInfo"), eqWepX, eqWepY, PST.kcolors.WHITE)
        eqWepY = eqWepY + 10
        PST.luaminiFont:DrawStringUTF8(PST:getLocalized("ui_allocToSelect"), eqWepX, eqWepY, PST.kcolors.WHITE)
        eqWepY = eqWepY + 10
        PST.luaminiFont:DrawStringUTF8(PST:getLocalized("ui_shiftAllocUnequip"), eqWepX, eqWepY, PST.kcolors.WHITE)
    end

    -- Inventory filter buttons
    for i, tmpFilter in ipairs(invFilters) do
        local filterX = tmpX + 3 + 18 * ((i - 1) % 9)
        local filterY = tmpY + 18 * math.floor((i - 1) / 9)

        if (tmpFilter.weaponType ~= nil and PST:arrHasValue(self.appliedFilters.weaponType, tmpFilter.weaponType)) or
        (tmpFilter.weaponRarity ~= nil and PST:arrHasValue(self.appliedFilters.weaponRarity, tmpFilter.weaponRarity)) or
        (tmpFilter.honing and self.appliedFilters.honing == tmpFilter.honing) or
        (tmpFilter.favorite and self.appliedFilters.favorite) then
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
        local tmpSprite = tScreen.modules.nodeDrawingModule.nodesExtraSprite
        local oldScaleX, oldScaleY = tmpSprite.Scale.X, tmpSprite.Scale.Y
        tmpSprite.Scale = Vector.One
        tmpSprite.Color = tmpColWhite
        tmpSprite:SetFrame("Allocated Small", 0)
        tmpSprite:Render(Vector(deconX, deconY))
        tmpSprite.Scale.X = oldScaleX
        tmpSprite.Scale.Y = oldScaleY
    end

    -- Multi-deconstruction button
    deconY = deconY + 36
    self.forgeUISprite.Color = tmpColRed
    self.forgeUISprite:Render(Vector(deconX, deconY))
    self.forgeUISprite.Color = tmpColWhite
    self.multiDeconHovered = self.camCenterX >= deconX - 16 and self.camCenterX <= deconX + 16 and
                             self.camCenterY >= deconY - 16 and self.camCenterY <= deconY + 16
    if self.multiDecon then
        local tmpSprite = tScreen.modules.nodeDrawingModule.nodesExtraSprite
        local oldScaleX, oldScaleY = tmpSprite.Scale.X, tmpSprite.Scale.Y
        tmpSprite.Scale = Vector.One
        tmpSprite.Color = tmpColWhite
        tmpSprite:SetFrame("Allocated Small", 0)
        tmpSprite:Render(Vector(deconX, deconY))
        tmpSprite.Scale.X = oldScaleX
        tmpSprite.Scale.Y = oldScaleY
    end

    tmpY = tmpY + math.ceil(#invFilters / 9) * 18 + 3

    -- Weapons
    local drawnWeps = {}
    if #PST.modData.astralWepInventory == 0 then
        PST.miniFont:DrawStringUTF8(PST:getLocalized("ui_invEmpty") .. ".", tmpX, tmpY, PST.kcolors.WHITE)
    else
        local hasTypeFilter = #self.appliedFilters.weaponType > 0
        local hasRarityFilter = #self.appliedFilters.weaponRarity > 0
        local hasHoningFilter = self.appliedFilters.honing > 0
        local hasFavFilter = self.appliedFilters.favorite
        -- Create filtered list
        if hasTypeFilter or hasRarityFilter or hasHoningFilter or hasFavFilter then
            for _, tmpWeapon in ipairs(PST.modData.astralWepInventory) do
                if (not hasTypeFilter or (hasTypeFilter and PST:arrHasValue(self.appliedFilters.weaponType, tmpWeapon.type))) and
                (not hasRarityFilter or (hasRarityFilter and PST:arrHasValue(self.appliedFilters.weaponRarity, tmpWeapon.rarity))) and
                (not hasHoningFilter or (hasHoningFilter and (self.appliedFilters.honing == 1 and not tmpWeapon.honing) or
                (self.appliedFilters.honing == 2 and tmpWeapon.honing and tmpWeapon.honing > 1 and tmpWeapon.honing < 49) or
                (self.appliedFilters.honing == 3 and tmpWeapon.honing and tmpWeapon.honing >= 50))) and
                (not hasFavFilter or (hasFavFilter and tmpWeapon.favorite)) then
                    table.insert(drawnWeps, tmpWeapon)
                end
            end
        else
            drawnWeps = PST.modData.astralWepInventory
        end
        self.filteredWeps = drawnWeps
        -- Draw weapons
        local startVal = 1 + 5 * self.rowsPerPage * (self.invPage - 1)
        local endVal = startVal + 5 * self.rowsPerPage - 1
        local j = 1
        for i=startVal,endVal do
            local tmpWeapon = drawnWeps[i]
            if tmpWeapon then
                local wepX = tmpX + 18 + 34 * ((j - 1) % 5)
                local wepY = tmpY + 16 + 34 * math.floor((j - 1) / 5)

                -- Hovered weapon
                if self.camCenterX >= wepX - 16 and self.camCenterX <= wepX + 16 and
                self.camCenterY >= wepY - 16 and self.camCenterY <= wepY + 16 then
                    self.hoveredWeapon = tmpWeapon
                    self.weaponSprite.Color.RO = 0.4
                    self.weaponSprite.Color.GO = 0.4
                    self.weaponSprite.Color.BO = 0.4
                end
                -- Selected weapon
                if self.selectedWeapon == tmpWeapon then
                    self:DrawUIBox(wepX - 16, wepY - 16, 32, 32)
                end
                -- Multi-decon selection
                if self.multiDecon and PST:arrHasValue(self.deconSelected, tmpWeapon) then
                    self.weaponSprite.Color.RO = self.weaponSprite.Color.RO + 0.4
                end
                PST:renderAstralWepAt(tmpWeapon, self.weaponSprite, wepX, wepY)

                -- Equipped
                if tmpWeapon.equipped then
                    PST.miniFont:DrawStringUTF8("E", wepX + 8, wepY + 4, PST.kcolors.LIGHTYELLOW1)
                end

                self.weaponSprite.Color.RO = 0
                self.weaponSprite.Color.GO = 0
                self.weaponSprite.Color.BO = 0
                j = j + 1
            else break end
        end
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

    PST.miniFont:DrawStringUTF8(PST:getLocalized("ui_wepForging"), tmpX + 3, tmpY, PST.kcolors.FORGE_ORANGE)
    tmpY = tmpY + 17

    -- Selected weapon slot
    local selWepX = tmpX + 19
    local selWepY = tmpY + 16
    self.forgeUISprite:SetFrame("UI", 0)
    self.forgeUISprite:Render(Vector(selWepX, selWepY))

    if not self.selectedWeapon then
        PST.miniFont:DrawStringUTF8(PST:getLocalized("ui_selWepToForge"), selWepX + 18, tmpY, PST.kcolors.WHITE)
    else
        PST:renderAstralWepAt(self.selectedWeapon, self.weaponSprite, selWepX, selWepY)
        -- Forge action buttons
        local drawnButtons = 0
        for _, tmpButton in ipairs(forgingButtons) do
            if (not tmpButton.reqRarity or (tmpButton.reqRarity and self.selectedWeapon.rarity == tmpButton.reqRarity)) and not
            (tmpButton.targetAction == "starbless" and self.selectedWeapon.starblessed) then
                local tmpButtonX = selWepX + 34 + 30 * drawnButtons
                self.forgeUISprite:SetFrame("UI", tmpButton.frame)

                -- Hovered button
                if self.camCenterX >= tmpButtonX - 14 and self.camCenterX <= tmpButtonX + 14 and
                self.camCenterY >= selWepY - 14 and self.camCenterY <= selWepY + 14 then
                    self.hoveredForgeButton = tmpButton
                    self.forgeUISprite.Color.RO = 0.25
                    self.forgeUISprite.Color.GO = 0.25
                    self.forgeUISprite.Color.BO = 0.25
                end
                self.forgeUISprite:Render(Vector(tmpButtonX, selWepY))
                self.forgeUISprite.Color.RO = 0
                self.forgeUISprite.Color.GO = 0
                self.forgeUISprite.Color.BO = 0

                if tmpButton.targetAction == "imprinting" and self.imprintMode then
                    local tmpSprite = tScreen.modules.nodeDrawingModule.nodesExtraSprite
                    local oldScaleX, oldScaleY = tmpSprite.Scale.X, tmpSprite.Scale.Y
                    tmpSprite.Scale = Vector.One
                    tmpSprite.Color = tmpColWhite
                    tmpSprite:SetFrame("Allocated Small", 0)
                    tmpSprite:Render(Vector(tmpButtonX, selWepY))
                    tmpSprite.Scale.X = oldScaleX
                    tmpSprite.Scale.Y = oldScaleY
                end

                drawnButtons = drawnButtons + 1
            end
        end

        -- Selected weapon data
        selWepX = selWepX - 15
        selWepY = selWepY + 18
        for _, tmpLine in ipairs(selectedWepDesc) do
            if type(tmpLine) == "table" then
                PST.miniFont:DrawStringUTF8(tmpLine[1], selWepX, selWepY, tmpLine[2])
            else
                PST.miniFont:DrawStringUTF8(tmpLine, selWepX, selWepY, PST.kcolors.WHITE)
            end
            selWepY = selWepY + boxLineHeight
        end
    end

    -- Inventory pagination
    local invPageAmt = math.ceil(#drawnWeps / (self.rowsPerPage * 5))
    tmpX = startX + 24
    tmpY = startY + 247
    local tmpColor = PST.kcolors.WHITE
    -- Prev button
    if self.invPage == 1 then
        tmpColor = PST.kcolors.GRAY1
    else
        -- Hovered
        if self.camCenterX >= tmpX - 20 and self.camCenterX <= tmpX + 20 and
        self.camCenterY >= tmpY and self.camCenterY <= tmpY + 24 then
            self.hoveredPageButton = "prev"
            tmpColor = PST.kcolors.TEAL1
        end
    end
    PST.miniFont:DrawStringUTF8(PST:getLocalized("ui_prev"), tmpX, tmpY, tmpColor)

    tmpX = tmpX + 100
    tmpColor = PST.kcolors.WHITE
    -- Next button
    if self.invPage >= invPageAmt then
        tmpColor = PST.kcolors.GRAY1
    else
        -- Hovered
        if self.camCenterX >= tmpX - 20 and self.camCenterX <= tmpX + 20 and
        self.camCenterY >= tmpY and self.camCenterY <= tmpY + 24 then
            self.hoveredPageButton = "next"
            tmpColor = PST.kcolors.TEAL1
        end
    end
    PST.miniFont:DrawStringUTF8(PST:getLocalized("ui_next"), tmpX, tmpY, tmpColor)

    -- Current page text
    tmpX = tmpX - 50
    local tmpStr = tostring(self.invPage) .. "/" .. invPageAmt
    PST.miniFont:DrawStringUTF8(tmpStr, tmpX, tmpY, PST.kcolors.WHITE)

    -- Control hints
    if not self.selectedWeapon then
        tmpY = startY + 270
        PST.luaminiFont:DrawStringUTF8(PST:getLocalized("ui_allocToSelHoverWepForge"), startX, tmpY, PST.kcolors.WHITE)
        tmpY = tmpY + 12
        PST.luaminiFont:DrawStringUTF8(PST:getLocalized("ui_shiftAllocEquipHoverWep"), startX, tmpY, PST.kcolors.WHITE)
        tmpY = tmpY + 12
        PST.luaminiFont:DrawStringUTF8(PST:getLocalized("ui_shiftHFavWep"), startX, tmpY, PST.kcolors.WHITE)
    end

    -- Cursor
    if hoveredMat or self.hoveredWeapon or self.hoveredFilter or self.deconHovered or self.multiDeconHovered or self.hoveredForgeButton or
    self.hoveredPageButton ~= "" then
        tScreen.cursorSprite:Play("Clicked", true)
    else
        tScreen.cursorSprite:Play("Idle", true)
    end
    tScreen.cursorSprite:Render(Vector(tScreen.screenW / 2, tScreen.screenH / 2))

    Isaac.RenderText(PST:getLocalized("ui_astralForge"), 8, 8, 1, 1, 1, 1)

    -- Hovered filter description
    if self.hoveredFilter then
        local hoverStr = PST:getLocalized("ui_filter") .. ": "
        if self.hoveredFilter.weaponType then
            hoverStr = hoverStr .. PST:getLocalized("aforge_wepname_" .. PST.astralWepData[self.hoveredFilter.weaponType].name .. "s")
        elseif self.hoveredFilter.weaponRarity then
            hoverStr = hoverStr .. PST:getLocalized("ui_" .. wepRarityStr[self.hoveredFilter.weaponRarity + 1])
        elseif self.hoveredFilter.honing == 1 then
            hoverStr = hoverStr .. PST:getLocalized("ui_noHoning")
        elseif self.hoveredFilter.honing == 2 then
            hoverStr = hoverStr .. PST:getLocalized("ui_someHoning")
        elseif self.hoveredFilter.honing == 3 then
            hoverStr = hoverStr .. PST:getLocalized("ui_maxHoning")
        elseif self.hoveredFilter.favorite then
            hoverStr = hoverStr .. PST:getLocalized("ui_favorited")
        end
        tScreen:DrawNodeBox(hoverStr, {PST:getLocalized("ui_allocApplyFilter")})
    -- Hovered material description
    elseif hoveredMat then
        local tmpMatDesc = {
            {hoveredMat.name, hoveredMat.color},
            PST:getLocalized("ui_source") .. ":", table.unpack(hoveredMat.source)
        }
        tScreen:DrawNodeBox(PST:getLocalized("ui_forgeMaterial"), tmpMatDesc)
    -- Hovered weapon description
    elseif self.hoveredWeapon then
        tmpTitle = PST:getLocalized("ui_astralwep")
        if self.hoveredWeapon.equipped then
            tmpTitle = tmpTitle .. " (" .. PST:getLocalized("ui_equippedBy") .. " " .. self.hoveredWeapon.equipped .. ")"
        end

        local wepDesc = {}
        -- Decon mode extras
        if self.deconMode then
            -- Deconstruction mode description
            table.insert(wepDesc, {"* " .. PST:getLocalized("ui_deconstructingWep") .. " *", PST.kcolors.RED1})
            -- Get deconstruction materials
            local wepMats = PST:getAstralWepDeconMats(self.hoveredWeapon)
            if wepMats.mundane > 0 then
                table.insert(wepDesc, {tostring(wepMats.mundane) .. "x " .. matsData.mundaneEssence[1] .. ".", matsData.mundaneEssence[2]})
            end
            if wepMats.spark > 0 then
                table.insert(wepDesc, {tostring(wepMats.spark) .. "x " .. matsData.sparkEssence[1] .. ".", matsData.sparkEssence[2]})
            end
            if wepMats.ancient > 0 then
                table.insert(wepDesc, {tostring(wepMats.ancient) .. "x " .. matsData.ancientEssence[1] .. ".", matsData.ancientEssence[2]})
            end
            if self.hoveredWeapon.rarity ~= PSTAstralWepRarity.ANCIENT then
                table.insert(wepDesc, PST:getLocalized("ui_respecDecon"))
            else
                table.insert(wepDesc, PST:getLocalized("ui_holdRespecDecon"))
            end
            table.insert(wepDesc, "")
        end
        for _, tmpLine in ipairs(PST:getAstralWepDesc(self.hoveredWeapon, PST:isKeybindActive(PSTKeybind.PAN_FASTER, true))) do
            table.insert(wepDesc, tmpLine)
        end

        if not self.deconMode then
            -- Imprinting mode description extras
            if self.imprintMode and self.hoveredWeapon.rarity == PSTAstralWepRarity.MAGIC then
                table.insert(wepDesc, 1, {PST:getLocalized("ui_imprintNote1"), PST.kcolors.DARKORANGE1})
                table.insert(wepDesc, 1, {PST:getLocalized("ui_imprintNote2"), PST.kcolors.FORGE_ORANGE})
                table.insert(wepDesc, 1, {"* " .. PST:getLocalized("ui_imprintingWep") .. " *", PST.kcolors.FORGE_ORANGE})
            end

            if not self.hoveredWeapon.equipped then
                table.insert(wepDesc, PST:getLocalizedFormat("ui_shiftAllocEquipWith", {charName = PST:getCurrentCharName()}))
            end
            if not self.hoveredWeapon.favorite then
                table.insert(wepDesc, PST:getLocalized("ui_shiftHFavThisWep"))
            end
        end

        tScreen:DrawNodeBox(tmpTitle, wepDesc)
    -- Hovered deconstruction button description
    elseif self.deconHovered then
        tScreen:DrawNodeBox(PST:getLocalized("ui_toggleDeconMode"), PST:getLocalized("ui_forgeDeconDesc"))
    -- Hovered multi-deconstruction button description
    elseif self.multiDeconHovered then
        tScreen:DrawNodeBox(PST:getLocalized("ui_toggleMultiDecon"), PST:getLocalized("ui_multiDeconDesc"))
    -- Hovered forge action button description
    elseif self.hoveredForgeButton then
        local tmpButtonDesc = self.hoveredForgeButton.description
        local forgeDesc = {}

        if type(tmpButtonDesc) == "table" then
            forgeDesc = {table.unpack(tmpButtonDesc)}
        end

        -- Imprint mode description
        local isImprintToggled = self.hoveredForgeButton.targetAction == "imprinting" and self.imprintMode
        if isImprintToggled then
            forgeDesc = {table.unpack(self.hoveredForgeButton.imprintDescription)}
        end

        -- Forge action costs
        local wepCosts = PST:getAstralWepCraftCosts(self.selectedWeapon)[self.hoveredForgeButton.targetAction]
        if wepCosts and not PST.debugOptions.freeForging then
            table.insert(forgeDesc, PST:getLocalized("ui_costs") .. ":")
            for _, tmpMat in ipairs(matsOrder) do
                local tmpCost = wepCosts[tmpMat]
                if tmpCost and matsData[tmpMat] then
                    tmpStr = "    x " .. tostring(tmpCost) .. " " .. matsData[tmpMat][1] .. "."
                    local canAfford = PST.modData[tmpMat] and PST.modData[tmpMat] >= tmpCost
                    if not canAfford then
                        tmpStr = tmpStr .. " (" .. PST:getLocalized("ui_missingYouHave") .. " " .. tostring(PST.modData[tmpMat]) .. ")"
                    end
                    table.insert(forgeDesc, {tmpStr, matsData[tmpMat][2]})
                end
            end
        end
        tScreen:DrawNodeBox(self.hoveredForgeButton.name, forgeDesc)
    end
end

return astralForgeScreenRender