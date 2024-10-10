function PST.treeScreen:InputAllocate()
    -- Input: Allocate node
    if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
        local submenusModule = self.modules.submenusModule
        local cosmicRSubmenu = submenusModule.submenus[PSTSubmenu.COSMICREALIGNMENT]
        local starInvSubmenu = submenusModule.submenus[PSTSubmenu.STARJEWELINV]

        if self.backupsPopup and self.saveBackups[self.selectedBackup] ~= nil then
            -- Load selected backup if popup
            if PST_BackupReplace and PST_BackupReplace(PST.saveSlot, self.selectedBackup) then
                SFXManager():Play(SoundEffect.SOUND_1UP)
                PST.saveManager.Load(false)
                PST:closeTreeMenu()
            else
                SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.7)
            end
        elseif self.hoveredNode ~= nil then
            -- Hovered node
            self.treeHasChanges = true
            if PST:isNodeAllocatable(self.currentTree, self.hoveredNode.id, true) then
                if not PST.debugOptions.infSP then
                    if self.currentTree == "global" or self.currentTree == "starTree" then
                        PST.modData.skillPoints = PST.modData.skillPoints - 1
                    else
                        PST.modData.charData[self.currentTree].skillPoints = PST.modData.charData[self.currentTree].skillPoints - 1
                    end
                end

                PST:allocateNodeID(self.currentTree, self.hoveredNode.id, 1)
                SFXManager():Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 0.4)
                self:UpdateStarTreeTotals()

                -- Lost tree, unlock holy mantle if allocating Sacred Aegis
                if self.hoveredNode.name == "Sacred Aegis" and not Isaac.GetPersistentGameData():Unlocked(Achievement.LOST_HOLDS_HOLY_MANTLE) then
                    Isaac.GetPersistentGameData():TryUnlock(Achievement.LOST_HOLDS_HOLY_MANTLE)
                end

            elseif not PST:isNodeAllocated(self.currentTree, self.hoveredNode.id) then
                SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
            else
                -- Cosmic Realignment node, open/close menu
                if self.hoveredNode.name == "Cosmic Realignment" then
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)

                    submenusModule:SwitchSubmenu(PSTSubmenu.COSMICREALIGNMENT, {
                        menuX = self.hoveredNode.pos.X * 38,
                        menuY = self.hoveredNode.pos.Y * 38
                    })
                -- Star Tree node, switch to star tree view
                elseif self.hoveredNode.name == "Star Tree" and self.currentTree ~= "starTree" then
                    self.modules.spaceBGModule.targetSpaceColor = Color(0, 1, 1, 1)
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                    self.currentTree = "starTree"
                    self:CenterCamera()
                else
                    -- Star Tree: Open Inventories
                    for _, tmpType in pairs(PSTStarcursedType) do
                        if PST:strStartsWith(self.hoveredNode.name, tmpType) then
                            -- Is socket/inventory node
                            local isSocket = string.find(self.hoveredNode.name, "Socket")
                            if (isSocket or string.find(self.hoveredNode.name, "Inventory") ~= nil) then
                                if starInvSubmenu.jewelType ~= tmpType then
                                    if tmpType ~= PSTStarcursedType.ANCIENT then
                                        PST:SC_sortInventory(tmpType)
                                    end
                                    local tmpSocket = nil
                                    if isSocket then
                                        tmpSocket = string.sub(self.hoveredNode.name, -1)
                                    end
                                    submenusModule:SwitchSubmenu(PSTSubmenu.STARJEWELINV, {
                                        menuX = self.hoveredNode.pos.X * 38,
                                        menuY = self.hoveredNode.pos.Y * 38,
                                        invPage = 0,
                                        jewelType = tmpType,
                                        socket = tmpSocket
                                    }, true)
                                else
                                    starInvSubmenu.jewelType = ""
                                    submenusModule:CloseSubmenu()
                                end
                                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                                break
                            end
                        end
                    end
                end
            end
        -- Cosmic Realignment submenu
        elseif submenusModule.currentSubmenu == PSTSubmenu.COSMICREALIGNMENT then
            -- Pick hovered character
            if cosmicRSubmenu.hoveredCharID ~= nil then
                self.treeHasChanges = true
                if PST:cosmicRIsCharUnlocked(cosmicRSubmenu.hoveredCharID) then
                    local cosmicRChar = PST.modData.cosmicRealignment
                    if cosmicRChar ~= cosmicRSubmenu.hoveredCharID then
                        PST.modData.cosmicRealignment = cosmicRSubmenu.hoveredCharID
                    else
                        PST.modData.cosmicRealignment = true
                    end
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                    self.modules.submenusModule:CloseSubmenu()
                else
                    SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.4)
                end
            end
        -- Starcursed inventory
        elseif submenusModule.currentSubmenu == PSTSubmenu.STARJEWELINV then
            -- Identify/equip hovered jewel
            if starInvSubmenu.hoveredJewel ~= nil then
                self.treeHasChanges = true
                local jewelData = starInvSubmenu.hoveredJewel
                if jewelData then
                    if jewelData.unidentified then
                        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                        SFXManager():Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 0.65, 2, false, 1.6 + 0.1 * math.random())
                        PST:SC_identifyJewel(starInvSubmenu.hoveredJewel)
                    elseif starInvSubmenu.socket then
                        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                        PST:SC_equipJewel(jewelData, starInvSubmenu.socket)
                        self:UpdateStarTreeTotals()
                        starInvSubmenu.jewelType = ""
                        submenusModule:CloseSubmenu()
                    end
                end
            end
        end
    end
end