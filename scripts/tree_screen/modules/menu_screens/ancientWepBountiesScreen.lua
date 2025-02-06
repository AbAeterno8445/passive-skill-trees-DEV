local ancientWepBountiesScreen = {
    BGSprite = Sprite("gfx/ui/skilltrees/tree_bg.anm2", true),
    UILinkSprite = Sprite("gfx/ui/skilltrees/nodes/expedition_node_link.anm2", true),
    bazaarUISprite = Sprite("gfx/ui/skilltrees/bazaar_ui.anm2", true),
    forgeUISprite = Sprite("gfx/ui/skilltrees/astral_forge_ui.anm2", true),
    weaponSprite = Sprite("gfx/ui/skilltrees/nodes/astral_weapons.anm2", true),

    inputOverrides = {
        PSTKeybind.TREE_PAN_DOWN, PSTKeybind.TREE_PAN_LEFT, PSTKeybind.TREE_PAN_RIGHT, PSTKeybind.TREE_PAN_UP,
        PSTKeybind.CENTER_CAMERA, PSTKeybind.PAN_FASTER, PSTKeybind.TREE_TAB,
        PSTKeybind.ALLOCATE_NODE, PSTKeybind.RESPEC_NODE, PSTKeybind.SWITCH_TREE
    },

    selectedType = 0,
    selectTimer = 0,
    selectPause = false,

    resetTimer = 0,
    resetPause = false,

    weaponDescMode = false,
}

-- Init
ancientWepBountiesScreen.BGSprite:Play("Pixel", true)
ancientWepBountiesScreen.UILinkSprite:SetFrame("AstralForgeUI", 1)

local weaponTypeSpriteIDs = {
    [PSTAstralWepType.LONGSWORD] = 766,
    [PSTAstralWepType.ESTOC] = 767,
    [PSTAstralWepType.DAGGER] = 768,
    [PSTAstralWepType.QUICKBLADE] = 769,
    [PSTAstralWepType.SPEAR] = 770,
    [PSTAstralWepType.TRIDENT] = 771,
    [PSTAstralWepType.SCYTHE] = 772,
    [PSTAstralWepType.AXE] = 773,
    [PSTAstralWepType.GREATAXE] = 774,
    [PSTAstralWepType.SHORTBOW] = 775,
    [PSTAstralWepType.BOW] = 776,
    [PSTAstralWepType.CROSSBOW] = 777,
    [PSTAstralWepType.GAUNTLET] = 850,
    [PSTAstralWepType.GREATMACE] = 851
}

function ancientWepBountiesScreen:OnOpen()
    local charData = PST:getCurrentCharData()
    if charData and charData.ancWepBounty and charData.ancWepBounty.rewardWepType ~= -1 then
        self.selectedType = charData.ancWepBounty.rewardWepType
    end
end

function ancientWepBountiesScreen:DrawUIBox(x, y, w, h)
    self.BGSprite.Scale.X = w
    self.BGSprite.Scale.Y = h
    self.BGSprite:Render(Vector(x, y))

    -- Top decor beam
    local linkBeam = Beam(self.UILinkSprite, 0, false, false)
    local startPos = Vector(x, y)
    local endPos = Vector(x + w, y)
    linkBeam:Add(startPos, 0)
    linkBeam:Add(endPos, 129)
    linkBeam:Render()

    -- Left decor beam
    startPos = Vector(x, y)
    endPos = Vector(x, y + h)
    linkBeam:Add(startPos, 0)
    linkBeam:Add(endPos, 129)
    linkBeam:Render()

    -- Right decor beam
    startPos = Vector(x + w, y + h)
    endPos = Vector(x + w, y)
    linkBeam:Add(startPos, 0)
    linkBeam:Add(endPos, 129)
    linkBeam:Render()

    -- Bottom decor beam
    startPos = Vector(x + w, y + h)
    endPos = Vector(x, y + h)
    linkBeam:Add(startPos, 0)
    linkBeam:Add(endPos, 129)
    linkBeam:Render()
end

function ancientWepBountiesScreen:OnInput()
    -- Input: Directional keys/buttons
    if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT) then
        -- LEFT
        self.selectedType = self.selectedType - 1
        if self.selectedType < 0 then
            self.selectedType = #weaponTypeSpriteIDs
        end
        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.6, 2, false, 1.2)
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT) then
        -- RIGHT
        self.selectedType = self.selectedType + 1
        if self.selectedType > #weaponTypeSpriteIDs then
            self.selectedType = 0
        end
        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.6, 2, false, 1.2)
    end

    -- Input: Allocate (hold)
    if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE, true) then
        local charData = PST:getCurrentCharData()
        if charData and not self.selectPause then
            self.selectTimer = self.selectTimer + 1
            if self.selectTimer >= 30 then
                local curBounty = charData.ancWepBounty
                if not curBounty then
                    -- Generate a new bounty
                    local result = PST:ancWepBountyCharGenerate(true, self.selectedType)
                    if result then SFXManager():Play(SoundEffect.SOUND_LAZARUS_FLIP_ALIVE, 0.5)
                    else SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.65) end
                elseif PST:ancWepBountyCharCanComplete() then
                    local result = PST:ancWepBountyCharComplete()
                    if result then SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
                    else SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.65) end
                else
                    SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.65)
                end
                self.selectPause = true
            end
        end
    else
        self.selectTimer = 0
        self.selectPause = false
    end

    -- Input: Respec (hold)
    if PST:isKeybindActive(PSTKeybind.RESPEC_NODE, true) then
        if not self.resetPause then
            self.resetTimer = self.resetTimer + 1
            if self.resetTimer >= 30 then
                local charData = PST:getCurrentCharData()
                if charData then
                    charData.ancWepBounty = nil
                    SFXManager():Play(SoundEffect.SOUND_LAZARUS_FLIP_DEAD, 0.5)
                end
                self.resetPause = true
            end
        end
    else
        self.resetTimer = 0
        self.resetPause = false
    end

    -- Input: Tab
    if PST:isKeybindActive(PSTKeybind.TREE_TAB) then
        self.weaponDescMode = not self.weaponDescMode
    end
end

---@param tScreen PST.treeScreen
function ancientWepBountiesScreen:Render(tScreen)
    local boxW, boxH = 360, 240
    local startX = tScreen.screenW / 2 - boxW / 2
    local startY = tScreen.screenH / 2 - boxH / 2
    self:DrawUIBox(startX, startY, boxW, boxH)
    PST.miniFont:DrawString("Ancient Weapon Bounties", startX + 3, startY, PST.kcolors.ANCIENT_ORANGE)

    -- Decor ancient weapon bounties icon at the top
    local nodeSprite = tScreen.modules.nodeDrawingModule.nodesSprite
    local oldScaleX, oldScaleY, oldAlpha = nodeSprite.Scale.X, nodeSprite.Scale.Y, nodeSprite.Color.A
    nodeSprite.Scale.X = 1
    nodeSprite.Scale.Y = 1

    nodeSprite:SetFrame("Default", 844)
    nodeSprite:Render(Vector(startX + boxW / 2, startY))
    nodeSprite:SetFrame("Default", 845)
    nodeSprite:Render(Vector(startX + boxW / 2, startY))

    local charData = PST:getCurrentCharData()
    if charData then
        -- Draw obols
        self.bazaarUISprite:SetFrame("Default", 1)
        self.bazaarUISprite:Render(Vector(startX + 3, startY + 20))
        PST.miniFont:DrawString("Obols: " .. tostring(charData.arcaneObols or 0), startX + 20, startY + 20, PST.kcolors.PURPLE1)

        local curBounty = charData.ancWepBounty
        -- No current bounty
        if not curBounty then
            local wepTypeData = PST.astralWepData[self.selectedType]

            -- Draw selected weapon type
            local drawX = startX + boxW / 2
            local drawY = startY + 38
            nodeSprite.Color.A = nodeSprite.Color.A + self.selectTimer / 10
            nodeSprite:SetFrame("Default", weaponTypeSpriteIDs[self.selectedType])
            nodeSprite:Render(Vector(drawX, drawY))
            nodeSprite.Color.A = 1
            drawY = drawY + 17

            local tmpStr = "Selected type: " .. wepTypeData.name
            PST.miniFont:DrawString(tmpStr, drawX - PST.miniFont:GetStringWidth(tmpStr) / 2, drawY, PST.kcolors.WHITE)
            drawY = drawY + 16

            tmpStr = "Left/Right to select"
            PST.miniFont:DrawString(tmpStr, drawX - PST.miniFont:GetStringWidth(tmpStr) / 2, drawY, PST.kcolors.WHITE)
            drawY = drawY + 20

            drawX = startX + 3
            PST.miniFont:DrawString("No current bounty", drawX, drawY, PST.kcolors.ANCIENT_ORANGE)
            drawY = drawY + 15
            PST.luaminiFont:DrawString("Select a weapon type then hold Allocate for 1 second to generate", drawX, drawY, PST.kcolors.WHITE)
            drawY = drawY + 15
            PST.luaminiFont:DrawString("a bounty. Generated bounty will pick a random ancient weapon of", drawX, drawY, PST.kcolors.WHITE)
            drawY = drawY + 15
            PST.luaminiFont:DrawString("the selected type as a reward.", drawX, drawY, PST.kcolors.WHITE)
            drawY = drawY + 15
            PST.luaminiFont:DrawString("Generating/rerolling a bounty costs " .. tostring(PST.ancWepBountyObolCost) .. " arcane obols.", drawX, drawY, PST.kcolors.PURPLE1)
            drawY = drawY + 15

        -- Current bounty info
        else
            local wepTypeData = PST.astralWepData[charData.ancWepBounty.rewardWepType]
            local ancientData = wepTypeData.ancients[charData.ancWepBounty.rewardWepAncient]

            -- Draw reward weapon
            local drawX = startX + boxW / 2
            local drawY = startY + 38
            if self.resetTimer > 0 and not self.resetPause then
                self.forgeUISprite.Color.RO = self.forgeUISprite.Color.RO + self.resetTimer / 30
            elseif self.selectTimer > 0 and not self.selectPause then
                self.forgeUISprite.Color.A = self.forgeUISprite.Color.A + self.selectTimer / 10
            end
            self.forgeUISprite:SetFrame("UI", 0)
            self.forgeUISprite:Render(Vector(drawX, drawY))
            self.forgeUISprite.Color.RO = 0
            self.forgeUISprite.Color.A = 1

            local renderWepData = {
                type = charData.ancWepBounty.rewardWepType,
                rarity = PSTAstralWepRarity.ANCIENT,
                ancientID = charData.ancWepBounty.rewardWepAncient
            }
            PST:renderAstralWepAt(renderWepData, self.weaponSprite, drawX, drawY)
            drawY = drawY + 17

            -- Bounty reward title
            local tmpStr = "Bounty: " .. ancientData.name
            PST.miniFont:DrawString(tmpStr, drawX - PST.miniFont:GetStringWidth(tmpStr) / 2, drawY, PST.kcolors.ANCIENT_ORANGE)
            drawY = drawY + 15

            tmpStr = "Ancient " .. wepTypeData.name
            PST.miniFont:DrawString(tmpStr, drawX - PST.miniFont:GetStringWidth(tmpStr) / 2, drawY, PST.kcolors.ANCIENT_ORANGE)
            drawY = drawY + 20

            drawX = startX + 3
            if not self.weaponDescMode then
                -- Draw bounty objectives
                PST.miniFont:DrawString("Bounty objectives (press TAB to view ancient weapon modifier)", drawX, drawY, PST.kcolors.ANCIENT_ORANGE)
                drawY = drawY + 16

                local drawnObj = 0
                for _, tmpObjective in ipairs(charData.ancWepBounty.objectives) do
                    local objectiveData = PST.expeditionObjectives[tmpObjective.name]
                    if not objectiveData then
                        objectiveData = PST.expeditionObjectivesFinal[tmpObjective.name]
                    end
                    if objectiveData then
                        local objDesc = objectiveData.description
                        local descFormatVal = {
                            progress = tostring(tmpObjective.prog) .. "/" .. tostring(tmpObjective.req)
                        }
                        local tmpColor = PST.kcolors.EXPED_BLUE
                        if tmpObjective.prog >= tmpObjective.req then
                            tmpColor = PST.kcolors.TEAL1
                        end

                        if type(objDesc) == "table" then
                            for _, tmpLine in ipairs(objDesc) do
                                local descStr = PST:formatString(tmpLine, descFormatVal)
                                local descLen = PST.miniFont:GetStringWidth(descStr)
                                local tmpScale = 1
                                if descLen > boxW - 4 then
                                    tmpScale = (boxW - 4) / descLen
                                end
                                PST.miniFont:DrawStringScaled(descStr, drawX, drawY + drawnObj * 15, tmpScale, 1, tmpColor)
                                drawnObj = drawnObj + 1
                            end
                        else
                            local descStr = PST:formatString(objDesc, descFormatVal)
                            local descLen = PST.miniFont:GetStringWidth(descStr)
                            local tmpScale = 1
                            if descLen > boxW - 4 then
                                tmpScale = (boxW - 4) / descLen
                            end
                            PST.miniFont:DrawStringScaled(descStr, drawX, drawY + drawnObj * 15, tmpScale, 1, tmpColor)
                            drawnObj = drawnObj + 1
                        end
                    end
                end
                drawY = drawY + (drawnObj - 1) * 15 + 2

                drawY = drawY + 14
                PST.luaminiFont:DrawString("Hold Allocate for 1 second when finished to complete.", drawX, drawY, PST.kcolors.WHITE)
                drawY = drawY + 14
                PST.luaminiFont:DrawString("Hold Respec for 1 second to abandon this bounty.", drawX, drawY, PST.kcolors.LIGHTRED1)
                if Isaac.IsInGame() and not PST:isRunSidereal() then
                    drawY = drawY + 14
                    PST.luaminiFont:DrawString("Current run cannot progress this bounty (not an expedition).", drawX, drawY, PST.kcolors.RED2)
                end
            else
                -- Draw ancient weapon reward's modifier
                PST.miniFont:DrawString("Weapon Modifier (press TAB to view bounty objectives)", drawX, drawY, PST.kcolors.ANCIENT_ORANGE)
                drawY = drawY + 16

                if #ancientData.ancientMods > 0 then
                    -- Ancient weapon mod
                    local tmpMod = ancientData.ancientMods[1]
                    local targetMod = PST.astralWepMods[tmpMod]
                    if targetMod and targetMod.description then
                        local formatVals = {}
                        for i, tmpRoll in ipairs(targetMod.minRolls) do
                            formatVals["roll" .. tostring(i)] = tmpRoll
                        end
                        local drawnLines = 0
                        if type(targetMod.description) == "table" then
                            for _, tmpLine in ipairs(targetMod.description) do
                                local descStr = PST:formatString(tmpLine, formatVals)
                                local descLen = PST.miniFont:GetStringWidth(descStr)
                                local tmpScale = 1
                                if descLen > boxW - 4 then
                                    tmpScale = (boxW - 4) / descLen
                                end
                                PST.miniFont:DrawStringScaled(descStr, drawX, drawY + drawnLines * 15, tmpScale, 1, PST.kcolors.ANCIENT_ORANGE)
                                drawnLines = drawnLines + 1
                            end
                        else
                            local descStr = PST:formatString(targetMod.description, formatVals)
                            local descLen = PST.miniFont:GetStringWidth(descStr)
                            local tmpScale = 1
                            if descLen > boxW - 4 then
                                tmpScale = (boxW - 4) / descLen
                            end
                            PST.miniFont:DrawStringScaled(descStr, drawX, drawY + drawnLines * 15, tmpScale, 1, PST.kcolors.ANCIENT_ORANGE)
                            drawnLines = drawnLines + 1
                        end
                    end
                end
            end
        end
    end

    -- Reset tree nodes sprite
    nodeSprite.Scale.X = oldScaleX
    nodeSprite.Scale.Y = oldScaleY
    nodeSprite.Color.A = oldAlpha
end

return ancientWepBountiesScreen