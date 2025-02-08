-- Nodes that are just informative, pressing Allocate won't do anything on these
local passiveNodes = {"Save Backups Addon"}

function PST.treeScreen:InputAllocate()
    -- Input: Allocate node
    if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
        local submenusModule = self.modules.submenusModule
        local cosmicRSubmenu = submenusModule.submenus[PSTSubmenu.COSMICREALIGNMENT]
        local starInvSubmenu = submenusModule.submenus[PSTSubmenu.STARJEWELINV]
        local crimsonNodeSubmenu = submenusModule.submenus[PSTSubmenu.CRIMSON_NODE]

        if self.backupsPopup and self.saveBackups[self.selectedBackup] ~= nil then
            -- Load selected backup if popup
            if PST_BackupReplace and PST_BackupReplace(PST.saveSlot, self.selectedBackup) then
                SFXManager():Play(SoundEffect.SOUND_1UP)
                PST.saveManager.Load(false)
                PST:closeTreeMenu()
            else
                SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.7)
            end
        elseif self.hoveredNode ~= nil and not PST:arrHasValue(passiveNodes, self.hoveredNode.name) then
            -- Hovered node
            self.treeHasChanges = true
            if self.hoveredNode.name == "Description Box Style" then
                -- Description box style switch
                if PST.config.descriptionBoxStyle == 0 then
                    PST.config.descriptionBoxStyle = 1
                else
                    PST.config.descriptionBoxStyle = 0
                end
                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
            elseif PST:isNodeAllocatable(self.currentTree, self.hoveredNode.id, true) then
                local reqs = self.hoveredNode.reqs
                local noSP = (reqs and reqs.noSP)
                if not PST.debugOptions.infSP and not noSP and not PST:arrHasValue(PST.nodeSPExceptions, self.hoveredNode.name) then
                    if PST:arrHasValue(self.globalTrees, self.currentTree) then
                        PST.modData.skillPoints = math.max(0, PST.modData.skillPoints - 1)
                    elseif PST.modData.charData[self.currentTree] then
                        PST.modData.charData[self.currentTree].skillPoints = math.max(0, PST.modData.charData[self.currentTree].skillPoints - 1)
                    end
                end

                PST:allocateNodeID(self.currentTree, self.hoveredNode.id, 1)
                SFXManager():Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 0.4)
                self:UpdateStarTreeTotals()

                -- Lost tree, unlock holy mantle if allocating Sacred Aegis
                if self.hoveredNode.name == "Sacred Aegis" and not Isaac.GetPersistentGameData():Unlocked(Achievement.LOST_HOLDS_HOLY_MANTLE) then
                    Isaac.GetPersistentGameData():TryUnlock(Achievement.LOST_HOLDS_HOLY_MANTLE)
                end

                -- Sidereal Artifacts
                local charData = PST:getCurrentCharData()
                if self.hoveredNode.reqs and self.hoveredNode.reqs.sideArti and charData then
                    local sideArtiName
                    for tmpMod, _ in pairs(self.hoveredNode.modifiers) do
                        if PST.sideArtiData[tmpMod] then
                            sideArtiName = tmpMod
                            break
                        end
                    end
                    if sideArtiName then
                        local targetTable
                        if PST.sideArtiData[sideArtiName].type == "septentrion" then
                            targetTable = charData.northArtis
                        elseif PST.sideArtiData[sideArtiName].type == "meridion" then
                            targetTable = charData.southArtis
                        end
                        if targetTable then
                            local alloc = true
                            for _, tmpArti in ipairs(targetTable) do
                                if tmpArti == sideArtiName then alloc = false end
                            end
                            if alloc then
                                table.insert(targetTable, sideArtiName)
                            end
                        end
                    end
                end
                if self.hoveredNode.name == "Additional Septentrional Choice" then
                    if charData then
                        charData.maxNorthArtis = charData.maxNorthArtis + 1
                    end
                end

                -- Special node requirement subtractions
                if reqs then
                    local currentChar = PST:getCurrentCharData()
                    -- Arcane obols requirement
                    local obolReq = reqs.obols
                    if type(obolReq) == "table" and obolReq.var and PST[obolReq.var] then
                        obolReq = PST[obolReq.var]
                    end
                    if obolReq and currentChar and not PST.debugOptions.infSP then
                        currentChar.arcaneObols = math.max(0, currentChar.arcaneObols - obolReq)
                    end

                    -- Crimson starcore requirement
                    local crimsonStarcoreReq = reqs.crimsonStarcore
                    if crimsonStarcoreReq and currentChar and currentChar.crimsonStarcores and not PST.debugOptions.infSP then
                        currentChar.crimsonStarcores = math.max(0, currentChar.crimsonStarcores - crimsonStarcoreReq)
                    end
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
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                    self:switchCurrentTree("starTree")

                -- Arcane Astrolabe node, open Astral Expedition menu
                elseif self.hoveredNode.name == "Arcane Astrolabe" then
                    self.modules.menuScreensModule:SwitchToMenu(PSTTreeScreenMenu.EXPEDITION)
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)

                -- Sidereal Tree node, switch to sidereal tree
                elseif self.hoveredNode.name == "Sidereal Tree" and self.currentTree ~= "sidereal" then
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                    self:switchCurrentTree("sidereal")
                    PST:updateNodes("sidereal")

                -- Astral Forge node, switch to Astral Forge menu
                elseif self.hoveredNode.name == "Astral Forge" then
                    self.modules.menuScreensModule:SwitchToMenu(PSTTreeScreenMenu.ASTRAL_FORGE)
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)

                -- Ancient Weapon Bounties node, switch to Ancient Weapon Bounties menu
                elseif self.hoveredNode.name == "Ancient Weapon Bounties" then
                    self.modules.menuScreensModule:SwitchToMenu(PSTTreeScreenMenu.ANCIENT_WEAPON_BOUNTIES)
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)

                -- Obol Exchange node, convert global SP into arcane obols
                elseif self.hoveredNode.name == "Obol Exchange" then
                    if PST.modData.skillPoints > 0 then
                        local charData = PST:getCurrentCharData()
                        if charData then
                            PST.modData.skillPoints = PST.modData.skillPoints - 1
                            charData.arcaneObols = charData.arcaneObols + 10
                            self.treeHasChanges = true
                            SFXManager():Play(SoundEffect.SOUND_LUCKYPICKUP, 0.35, 2, false, 0.8)
                        else
                            SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.8)
                        end
                    else
                        SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.8)
                    end

                -- Global Skill Point Exchange node, convert obols to global SP
                elseif self.hoveredNode.name == "Global Skill Point Exchange" then
                    local charData = PST:getCurrentCharData()
                    if charData then
                        local obolCost = PST:getExpedObolToGSPRate(charData.obolGSPtrades)
                        if charData.arcaneObols and charData.arcaneObols >= obolCost then
                            charData.arcaneObols = charData.arcaneObols - obolCost
                            PST.modData.skillPoints = PST.modData.skillPoints + 1
                            charData.obolGSPtrades = charData.obolGSPtrades + 1
                            self.treeHasChanges = true
                            SFXManager():Play(SoundEffect.SOUND_LUCKYPICKUP, 0.35, 2, false, 0.9)
                        else
                            SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.8)
                        end
                    else
                        SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.8)
                    end

                -- Character SP Conversion node, convert character SP into global SP
                elseif self.hoveredNode.name == "Character SP Conversion" then
                    local charData = PST:getCurrentCharData()
                    if charData then
                        if charData.skillPoints > 0 then
                            charData.skillPoints = charData.skillPoints - 1
                            PST.modData.skillPoints = PST.modData.skillPoints + 1
                            self.treeHasChanges = true
                            SFXManager():Play(SoundEffect.SOUND_LUCKYPICKUP, 0.35, 2, false, 0.8)
                        else
                            SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.8)
                        end
                    end

                -- Timeless Bazaar node, switch to bazaar menu
                elseif self.hoveredNode.name == "Timeless Bazaar" then
                    self.modules.menuScreensModule:SwitchToMenu(PSTTreeScreenMenu.BAZAAR)
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
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

                    -- Crimson nodes
                    if PST:arrHasValue(PST.crimsonNodeNames, self.hoveredNode.name) then
                        local tmpCrimsonType = PSTCrimsonNodeType.UNIVERSAL
                        if PST:strStartsWith(self.hoveredNode.name, "Core") then
                            tmpCrimsonType = PSTCrimsonNodeType.CORE
                        elseif PST:strStartsWith(self.hoveredNode.name, "Divergent") then
                            tmpCrimsonType = PSTCrimsonNodeType.DIVERGENT
                        end
                        if crimsonNodeSubmenu.crimsonType ~= tmpCrimsonType then
                            submenusModule:SwitchSubmenu(PSTSubmenu.CRIMSON_NODE, {
                                menuX = self.hoveredNode.pos.X * 38,
                                menuY = self.hoveredNode.pos.Y * 38,
                                invPage = 0,
                                crimsonType = tmpCrimsonType,
                                crimsonNodeID = self.hoveredNode.id
                            })
                        else
                            crimsonNodeSubmenu.crimsonType = nil
                            submenusModule:CloseSubmenu()
                        end
                        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
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
            local jewelData = starInvSubmenu.hoveredJewel
            if jewelData ~= nil then
                self.treeHasChanges = true
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
        -- Crimson node submenu
        elseif submenusModule.currentSubmenu == PSTSubmenu.CRIMSON_NODE then
            -- Select node
            local nodeData = crimsonNodeSubmenu.hoveredNode
            if nodeData ~= nil then
                self.treeHasChanges = true
                local charData = PST:getCurrentCharData()
                if charData and crimsonNodeSubmenu.crimsonNodeID then
                    if not charData.crimsonNodes then
                        charData.crimsonNodes = {}
                    end
                    local crimsonNodeData = charData.crimsonNodes[tostring(crimsonNodeSubmenu.crimsonNodeID)]
                    if crimsonNodeData and crimsonNodeData.name == nodeData.name then
                        charData.crimsonNodes[tostring(crimsonNodeSubmenu.crimsonNodeID)] = nil
                    else
                        charData.crimsonNodes[tostring(crimsonNodeSubmenu.crimsonNodeID)] = {
                            name = nodeData.name,
                            sprite = nodeData.sprite
                        }
                    end
                    submenusModule:CloseSubmenu()
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                else
                    SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.8)
                end
            end
        end
    end
end