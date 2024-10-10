local fullDataResetHeld = 0

function PST.treeScreen:InputRespec()
    -- Input: Respec node
    if PST:isKeybindActive(PSTKeybind.RESPEC_NODE) then
        local submenusModule = self.modules.submenusModule
        local starInvSubmenu = submenusModule.submenus[PSTSubmenu.STARJEWELINV]

        if self.hoveredNode ~= nil then
            self.treeHasChanges = true
            -- Check if node is socketed starcursed jewel
            local isSocketedJewel = false
            for _, tmpType in pairs(PSTStarcursedType) do
                if PST:strStartsWith(self.hoveredNode.name, tmpType .. " Socket") then
                    local socketID = string.sub(self.hoveredNode.name, -1)
                    local socketedJewel = PST:SC_getSocketedJewel(tmpType, socketID)
                    if socketedJewel and socketedJewel.equipped == socketID then
                        -- Socketed jewel - unsocket
                        socketedJewel.equipped = nil
                        SFXManager():Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 0.65, 2, false, 1.6 + 0.1 * math.random())
                        self:UpdateStarTreeTotals()
                        isSocketedJewel = true
                        break
                    end
                end
            end
            if not isSocketedJewel then
                if PST:isNodeAllocatable(self.currentTree, self.hoveredNode.id, false) then
                    -- Respec Cosmic Realignment node
                    local cosmicRChar = PST.modData.cosmicRealignment
                    if self.hoveredNode.name == "Cosmic Realignment" and type(cosmicRChar) == "number" then
                        PST.modData.cosmicRealignment = false
                        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                    else
                        if not PST.debugOptions.infRespec then
                            PST.modData.respecPoints = PST.modData.respecPoints - 1
                        end
                        if not PST.debugOptions.infSP then
                            if self.currentTree == "global" or self.currentTree == "starTree" then
                                PST.modData.skillPoints = PST.modData.skillPoints + 1
                            else
                                PST.modData.charData[self.currentTree].skillPoints = PST.modData.charData[self.currentTree].skillPoints + 1
                            end
                        end
                        PST:allocateNodeID(self.currentTree, self.hoveredNode.id, 0)
                        SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.75)
                        self:UpdateStarTreeTotals()
                        submenusModule:CloseSubmenu()
                    end
                elseif PST:isNodeAllocated(self.currentTree, self.hoveredNode.id) then
                    SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
                end
            end
        -- Starcursed inventory
        elseif submenusModule.currentSubmenu == PSTSubmenu.STARJEWELINV then
            -- Attempt to destroy hovered jewel
            if starInvSubmenu.hoveredJewel ~= nil then
                self.treeHasChanges = true
                if not starInvSubmenu.hoveredJewel.equipped then
                    if starInvSubmenu.hoveredJewel.converted ~= nil then
                        -- Cause Converter, remove boss and switch jewel back to seeking mode
                        starInvSubmenu.hoveredJewel.converted = nil
                        starInvSubmenu.hoveredJewel.status = "seeking"
                        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                    elseif starInvSubmenu.hoveredJewelID and PST:SC_canDestroyJewel(starInvSubmenu.hoveredJewel) then
                        if not starInvSubmenu.hoveredJewel.equipped then
                            table.remove(PST.modData.starTreeInventory[starInvSubmenu.hoveredJewel.type], starInvSubmenu.hoveredJewelID)
                            starInvSubmenu.hoveredJewel = nil
                            starInvSubmenu.hoveredJewelID = nil
                            SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.75, 2, false, 1.5 + 1 * math.random())
                        end
                    end
                else
                    starInvSubmenu.hoveredJewel.equipped = nil
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                end
            end
        end
    end

    -- Mod data reset: hold Respec input on "Leveling Of Isaac" node for 7 seconds
    if self.hoveredNode and PST:isKeybindActive(PSTKeybind.RESPEC_NODE, true) and self.hoveredNode.name == "Leveling Of Isaac" then
        fullDataResetHeld = fullDataResetHeld + 1
        if fullDataResetHeld % 60 == 0 then
            SFXManager():Play(SoundEffect.SOUND_1UP, 0.5, 2, false, 1 - 0.1 * fullDataResetHeld / 60)
        end
        if fullDataResetHeld == 420 then
            PST:closeTreeMenu()
            SFXManager():Play(SoundEffect.SOUND_DEATH_CARD, 0.8)
            PST:resetSaveData()
            fullDataResetHeld = 0
        end
    else
        fullDataResetHeld = 0
    end
end