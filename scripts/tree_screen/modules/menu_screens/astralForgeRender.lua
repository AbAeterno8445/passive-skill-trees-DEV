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
local matsData = {
    mundaneEssence = {"Mundane Essence", PST.kcolors.WHITE},
    sparkEssence = {"Sparkling Essence", PST.kcolors.LIGHTBLUE1},
    ancientEssence = {"Ancient Essence", PST.kcolors.ANCIENT_ORANGE},
    sparkStardust = {"Sparkling Stardust", PST.kcolors.LIGHTBLUE1},
    ancientStardust = {"Ancient Stardust", PST.kcolors.ANCIENT_ORANGE}
}
local matsOrder = {"mundaneEssence", "sparkEssence", "sparkStardust", "ancientEssence", "ancientStardust"}
local UIMats = {
    {
        -- Mundane Essence
        {name = "Mundane Essence", frame = 3, targetVal = "mundaneEssence", color = PST.kcolors.LIGHTGRAY1,
        source = {"    Deconstructing normal weapons." }},
        -- Sparkling Essence
        {name = "Sparkling Essence", frame = 4, targetVal = "sparkEssence", color = PST.kcolors.LIGHTBLUE1,
        source = {"    Deconstructing weapons with modifiers (magic/ancient)."}},
        -- Ancient Essence
        {name = "Ancient Essence", frame = 5, targetVal = "ancientEssence", color = PST.kcolors.ANCIENT_ORANGE,
        source = {"    Deconstructing ancient weapons."}},
    },
    {
        -- Sparkling Stardust
        {name = "Sparkling Stardust", frame = 1, targetVal = "sparkStardust", color = PST.kcolors.LIGHTBLUE1,
        source = {"    Killing bosses & clearing challenge rooms."}},
        -- Ancient Stardust
        {name = "Ancient Stardust", frame = 2, targetVal = "ancientStardust", color = PST.kcolors.ANCIENT_ORANGE,
        source = {"    Killing final bosses."}},
    }
}
local forgingButtons = {
    {
        name = "Honing",
        description = {"Hone the weapon, improving its implicit modifier. Each weapon can be honed up to 50 times."},
        targetAction = "honing",
        actionFunc = PST.astralWepForgeHone,
        soundFunc = function() SFXManager():Play(SoundEffect.SOUND_BISHOP_HIT, 0.8) end,
        frame = 2
    },
    {
        name = "Transmutation",
        description = {"Transform this normal weapon into a magic weapon, adding 1 random modifier."},
        targetAction = "transmutation",
        actionFunc = PST.astralWepForgeTransmute,
        soundFunc = function() SFXManager():Play(SoundEffect.SOUND_FLASHBACK, 0.8, 2, false, 1.3) end,
        frame = 9,
        reqRarity = PSTAstralWepRarity.NORMAL
    },
    {
        name = "Reroll Modifiers",
        description = {"Reroll the weapon's modifiers. Can result in 1 or 2 modifiers."},
        targetAction = "reroll",
        actionFunc = PST.astralWepForgeReroll,
        soundFunc = function() SFXManager():Play(SoundEffect.SOUND_BISHOP_HIT, 0.8, 2, false, 0.7) end,
        frame = 3,
        reqRarity = PSTAstralWepRarity.MAGIC
    },
    {
        name = "Add Modifier",
        description = {"Add a random modifier if the weapon only has 1."},
        targetAction = "addition",
        actionFunc = PST.astralWepForgeAdd,
        soundFunc = function() SFXManager():Play(SoundEffect.SOUND_BULB_FLASH, 0.8) end,
        frame = 4,
        reqRarity = PSTAstralWepRarity.MAGIC
    },
    {
        name = "Remove Modifier",
        description = {"Remove a random modifier if the weapon has 2."},
        targetAction = "removal",
        actionFunc = PST.astralWepForgeRemove,
        soundFunc = function() SFXManager():Play(SoundEffect.SOUND_BULB_FLASH, 0.8, 2, false, 0.5) end,
        frame = 8,
        reqRarity = PSTAstralWepRarity.MAGIC
    },
    {
        name = "Alter Modifiers",
        description = {"Randomise the values of the random, non-implicit modifiers on this weapon."},
        targetAction = "alteration",
        actionFunc = PST.astralWepForgeAlter,
        soundFunc = function() SFXManager():Play(SoundEffect.SOUND_LAZARUS_FLIP_DEAD, 0.8, 2, false, 0.9 + 0.2 * math.random()) end,
        frame = 7,
        reqRarity = PSTAstralWepRarity.MAGIC
    },
    {
        name = "Ancient Imprinting",
        description = {
            "Imprint a random modifier from another magic weapon into this Ancient weapon.",
            "Target magic weapon must have 2 modifiers.",
            "Can only imprint 1 modifier per Ancient weapon.",
            "Imprinted modifiers can no longer be altered once applied."
        },
        imprintDescription = {
            "Hover over the magic weapon you wish to imprint from in the inventory, then press Allocate to imprint.",
            "Press Allocate on this button again to deactivate imprinting mode."
        },
        targetAction = "imprinting",
        frame = 5,
        reqRarity = PSTAstralWepRarity.ANCIENT
    },
    {
        name = "Ancient Upgrade",
        description = {"Improve this Ancient weapon's unique modifier."},
        targetAction = "ancUpgrade",
        actionFunc = PST.astralWepForgeAncUpg,
        soundFunc = function() SFXManager():Play(SoundEffect.SOUND_LAZARUS_FLIP_ALIVE, 0.8, 2, false, 0.9 + 0.2 * math.random()) end,
        frame = 6,
        reqRarity = PSTAstralWepRarity.ANCIENT
    },
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

---@param tScreen PST.treeScreen
local function astralForgeScreenRender(self, tScreen)
    local baseDrawX = self.camCenterX - self.camera.X
    local baseDrawY = self.camCenterY - self.camera.Y

    local startX = baseDrawX - 200
    local startY = baseDrawY - 80
    -- Draw inventory
    local tmpX, tmpY = startX, startY
    self:DrawUIBox(tmpX, tmpY, 170, 250)
    -- Inventory title
    local tmpTitle = "Weapon Inventory"
    if self.deconMode then tmpTitle = tmpTitle .. " (Decon)"
    elseif self.imprintMode then tmpTitle = tmpTitle .. " (Imprint)" end
    PST.miniFont:DrawString(tmpTitle, tmpX + 3, tmpY, PST.kcolors.FORGE_ORANGE)
    tmpY = tmpY + 17

    -- Draw material counts UI box
    local matsX = startX
    local matsY = startY - 60
    self:DrawUIBox(matsX, matsY, 170, 54)
    PST.miniFont:DrawString("Materials", matsX + 3, matsY, PST.kcolors.FORGE_ORANGE)
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

    -- Equipped weapon UI box
    local eqWepX = startX + 176
    local eqWepY = startY - 60
    self:DrawUIBox(eqWepX, eqWepY, 170, 54)
    tmpTitle = "Equipped Weapon (" .. PST:getCurrentCharName() .. ")"
    PST.miniFont:DrawString(tmpTitle, eqWepX + 3, eqWepY, PST.kcolors.FORGE_ORANGE)

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
        PST.luaminiFont:DrawString("Hover for more info.", eqWepX, eqWepY, PST.kcolors.WHITE)
        eqWepY = eqWepY + 10
        PST.luaminiFont:DrawString("Allocate to select.", eqWepX, eqWepY, PST.kcolors.WHITE)
        eqWepY = eqWepY + 10
        PST.luaminiFont:DrawString("Shift + Allocate to unequip.", eqWepX, eqWepY, PST.kcolors.WHITE)
    end

    -- Inventory filter buttons
    for i, tmpFilter in ipairs(invFilters) do
        local filterX = tmpX + 3 + 18 * ((i - 1) % 9)
        local filterY = tmpY + 18 * math.floor((i - 1) / 9)

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
        local tmpSprite = tScreen.modules.nodeDrawingModule.nodesExtraSprite
        local oldScaleX, oldScaleY = tmpSprite.Scale.X, tmpSprite.Scale.Y
        tmpSprite.Scale = Vector.One
        tmpSprite.Color = Color(1, 1, 1, 1)
        tmpSprite:SetFrame("Allocated Small", 0)
        tmpSprite:Render(Vector(deconX, deconY))
        tmpSprite.Scale.X = oldScaleX
        tmpSprite.Scale.Y = oldScaleY
    end

    tmpY = tmpY + math.ceil(#invFilters / 8) * 18 + 3

    -- Weapons
    local drawnWeps = {}
    if #PST.modData.astralWepInventory == 0 then
        PST.miniFont:DrawString("Inventory Empty.", tmpX, tmpY, PST.kcolors.WHITE)
    else
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
                PST:renderAstralWepAt(tmpWeapon, self.weaponSprite, wepX, wepY)

                -- Equipped
                if tmpWeapon.equipped then
                    PST.miniFont:DrawString("E", wepX + 8, wepY + 4, PST.kcolors.LIGHTYELLOW1)
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

    PST.miniFont:DrawString("Weapon Forging", tmpX + 3, tmpY, PST.kcolors.FORGE_ORANGE)
    tmpY = tmpY + 17

    -- Selected weapon slot
    local selWepX = tmpX + 19
    local selWepY = tmpY + 16
    self.forgeUISprite:SetFrame("UI", 0)
    self.forgeUISprite:Render(Vector(selWepX, selWepY))

    if not self.selectedWeapon then
        PST.miniFont:DrawString("Select a weapon from your inventory to begin forging.", selWepX + 18, tmpY, PST.kcolors.WHITE)
    else
        PST:renderAstralWepAt(self.selectedWeapon, self.weaponSprite, selWepX, selWepY)
        -- Forge action buttons
        local drawnButtons = 0
        for _, tmpButton in ipairs(forgingButtons) do
            if not tmpButton.reqRarity or (tmpButton.reqRarity and self.selectedWeapon.rarity == tmpButton.reqRarity) then
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
                    tmpSprite.Color = Color(1, 1, 1, 1)
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
                PST.miniFont:DrawString(tmpLine[1], selWepX, selWepY, tmpLine[2])
            else
                PST.miniFont:DrawString(tmpLine, selWepX, selWepY, PST.kcolors.WHITE)
            end
            selWepY = selWepY + boxLineHeight
        end
    end

    -- Inventory pagination
    local invPageAmt = math.ceil(#drawnWeps / (self.rowsPerPage * 5))
    tmpX = startX + 24
    tmpY = startY + 227
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
    PST.miniFont:DrawString("Prev", tmpX, tmpY, tmpColor)

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
    PST.miniFont:DrawString("Next", tmpX, tmpY, tmpColor)

    -- Current page text
    tmpX = tmpX - 50
    local tmpStr = tostring(self.invPage) .. "/" .. invPageAmt
    PST.miniFont:DrawString(tmpStr, tmpX, tmpY, PST.kcolors.WHITE)

    -- Control hints
    if not self.selectedWeapon then
        tmpY = startY + 250
        PST.luaminiFont:DrawString("Press Allocate to select hovered weapon for forging.", startX, tmpY, PST.kcolors.WHITE)
        tmpY = tmpY + 12
        PST.luaminiFont:DrawString("Shift + Allocate to equip hovered weapon.", startX, tmpY, PST.kcolors.WHITE)
    end

    -- Cursor
    if hoveredMat or self.hoveredWeapon or self.hoveredFilter or self.deconHovered or self.hoveredForgeButton or self.hoveredPageButton ~= "" then
        tScreen.cursorSprite:Play("Clicked", true)
    else
        tScreen.cursorSprite:Play("Idle", true)
    end
    tScreen.cursorSprite:Render(Vector(tScreen.screenW / 2, tScreen.screenH / 2))

    Isaac.RenderText("Astral Forge", 8, 8, 1, 1, 1, 1)

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
        tmpTitle = "Astral Weapon"
        if self.hoveredWeapon.equipped then
            tmpTitle = tmpTitle .. " (Equipped by " .. self.hoveredWeapon.equipped .. ")"
        end

        local wepDesc = {}
        if not self.deconMode then
            wepDesc = PST:getAstralWepDesc(self.hoveredWeapon, PST:isKeybindActive(PSTKeybind.PAN_FASTER, true))

            -- Imprinting mode description extras
            if self.imprintMode and self.hoveredWeapon.rarity == PSTAstralWepRarity.MAGIC then
                table.insert(wepDesc, 1, {"NOTE: Imprinting will destroy this weapon!", PST.kcolors.DARKORANGE1})
                table.insert(wepDesc, 1, {"Press Allocate to imprint this weapon into the currently selected Ancient weapon.", PST.kcolors.FORGE_ORANGE})
                table.insert(wepDesc, 1, {"* Imprinting Weapon *", PST.kcolors.FORGE_ORANGE})
            end
        else
            -- Deconstruction mode description
            table.insert(wepDesc, {"* Deconstructing Weapon *", PST.kcolors.RED1})
            -- Get deconstruction materials
            local wepMats = PST:getAstralWepDeconMats(self.hoveredWeapon)
            if wepMats.mundane > 0 then
                table.insert(wepDesc, {tostring(wepMats.mundane) .. "x " .. matsData.mundaneEssence[1] .. ".", matsData.mundaneEssence[2]})
            end
            if wepMats.spark > 0 then
                table.insert(wepDesc, {tostring(wepMats.spark) .. "x " .. matsData.sparkEssence[1] .. ".", matsData.sparkEssence[2]})
            end
            if wepMats.ancient > 0 then
                table.insert(wepDesc, {tostring(wepMats.spark) .. "x " .. matsData.ancientEssence[1] .. ".", matsData.ancientEssence[2]})
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
    -- Hovered forge action button description
    elseif self.hoveredForgeButton then
        local forgeDesc = {table.unpack(self.hoveredForgeButton.description)}

        -- Imprint mode description
        local isImprintToggled = self.hoveredForgeButton.targetAction == "imprinting" and self.imprintMode
        if isImprintToggled then
            forgeDesc = {table.unpack(self.hoveredForgeButton.imprintDescription)}
        end

        -- Forge action costs
        local wepCosts = PST:getAstralWepCraftCosts(self.selectedWeapon)[self.hoveredForgeButton.targetAction]
        if wepCosts and not PST.debugOptions.freeForging then
            table.insert(forgeDesc, "Costs:")
            for _, tmpMat in ipairs(matsOrder) do
                local tmpCost = wepCosts[tmpMat]
                if tmpCost and matsData[tmpMat] then
                    local tmpStr = "    x " .. tostring(tmpCost) .. " " .. matsData[tmpMat][1] .. "."
                    local canAfford = PST.modData[tmpMat] and PST.modData[tmpMat] >= tmpCost
                    if not canAfford then
                        tmpStr = tmpStr .. " (missing, you have " .. tostring(PST.modData[tmpMat]) .. ")"
                    end
                    table.insert(forgeDesc, {tmpStr, matsData[tmpMat][2]})
                end
            end
        end
        tScreen:DrawNodeBox(self.hoveredForgeButton.name, forgeDesc)
    end
end

return astralForgeScreenRender