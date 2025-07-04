local descriptionBoxesModule = {
    -- Extra description pieces added to specific nodes based on other data/states. Key is node name
    dynamicNodeDescriptions = {
        -- Cosmic Realignment node, show picked character name & curse description
        ["Cosmic Realignment"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            local cosmicRChar = PST.modData.cosmicRealignment
            if type(cosmicRChar) == "number" then
                local tmpCharName = PST.charNames[1 + cosmicRChar]
                descName = descName .. " (" .. tmpCharName .. ")"
                tmpDescription = {}
                if PST.cosmicRData.characters[cosmicRChar].curseDesc then
                    for _, descLine in ipairs(PST.cosmicRData.characters[cosmicRChar].curseDesc) do
                        table.insert(tmpDescription, descLine)
                    end
                end
                table.insert(tmpDescription, {
                    PST:getLocalizedFormat("ui_cosmicR_unlocksPlayingAs", {tmpCharName = tmpCharName}), PST.kcolors.LIGHTBLUE1
                })
                table.insert(tmpDescription, PST:getLocalized("ui_cosmicR_respecDeselect"))
            elseif isAllocated then
                descName = descName .. " " .. PST:getLocalized("ui_cosmicR_EtoPick")
            end
            return { name = descName, description = tmpDescription }
        end,

        -- Star Tree node
        ["Star Tree"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            if isAllocated then
                if tScreen.currentTree ~= "starTree" then
                    descName = descName .. " " .. PST:getLocalized("ui_starTree_EtoView")
                elseif tScreen.starcursedTotalMods then
                    -- Append starmight description to Star Tree node
                    local tmpColor = PST.kcolors.STAR_ORANGE
                    tmpDescription = {table.unpack(tScreen.hoveredNode.description)}
                    table.insert(tmpDescription, {PST:getLocalized("ui_starmight") .. ": " .. tScreen.starcursedTotalMods.totalStarmight, tmpColor})
                    for modName, modVal in pairs(PST:SC_getStarmightImplicits(tScreen.starcursedTotalMods.totalStarmight)) do
                        local parsedModLines = PST:parseModifierLines(modName, modVal)
                        for _, tmpLine in ipairs(parsedModLines) do
                            table.insert(tmpDescription, {"   " .. tmpLine, tmpColor})
                        end
                    end
                end
            elseif not PST:SC_isStarTreeUnlocked() then
                tmpDescription = {
                    {PST:getLocalizedFormat("ui_starTree_levelReqWarn", {levelReq = PST.SCStarTreeUnlockLevel}), PST.kcolors.RED1}
                }
            end
            return { name = descName, description = tmpDescription }
        end,

        -- Golden Trinket nodes, show whether golden trinkets are unlocked
        ["Golden Trinkets"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            tmpDescription = {table.unpack(tScreen.hoveredNode.description)}
            if not Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_TRINKET) then
                table.insert(tmpDescription, {PST:getLocalized("ui_goldenTrinketsUnlocked"), PST.kcolors.GREEN1})
            else
                table.insert(tmpDescription, {PST:getLocalized("ui_goldenTrinketsNotUnlocked"), PST.kcolors.RED2})
            end
            return { name = descName, description = tmpDescription }
        end,

        -- Grand Ingredient nodes, add warning if more than 2 are allocated
        ["Grand Ingredient"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            if PST:grandIngredientNodes(false) > 2 then
                tmpDescription = {table.unpack(tScreen.hoveredNode.description)}
                table.insert(tmpDescription, {PST:getLocalized("ui_grandIngredientWarn"), PST.kcolors.RED2})
            end
            return { name = descName, description = tmpDescription }
        end,

        -- Soul Of The Siren node, track boss rush/hush completions
        ["Soul Of The Siren"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            tmpDescription = {table.unpack(tScreen.hoveredNode.description)}
            local bothDone = true
            -- Boss rush
            if Isaac.GetCompletionMark(Isaac.GetPlayerTypeByName("Siren", true), CompletionType.BOSS_RUSH) == 0 then
                table.insert(tmpDescription, {PST:getLocalized("ui_tSirenBossRushWarn"), PST.kcolors.RED2})
                bothDone = false
            end
            -- Hush
            if Isaac.GetCompletionMark(Isaac.GetPlayerTypeByName("Siren", true), CompletionType.HUSH) == 0 then
                table.insert(tmpDescription, {PST:getLocalized("ui_tSirenHushWarn"), PST.kcolors.RED2})
                bothDone = false
            end
            if bothDone then
                table.insert(tmpDescription, {PST:getLocalized("ui_tSirenSoulComp"), PST.kcolors.GREEN1})
            end
            return { name = descName, description = tmpDescription }
        end,

        -- Starcursed inventory/socket nodes
        ["Star Jewel Node"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            if extraData.isSocket then
                local setName = false
                local socketID = string.sub(tScreen.hoveredNode.name, -1)
                local socketedJewel = PST:SC_getSocketedJewel(extraData.jewelType, socketID)
                if socketedJewel and socketedJewel.equipped == socketID then
                    tmpDescription = PST:SC_getJewelDescription(socketedJewel)
                    table.insert(tmpDescription, PST:getLocalized("ui_jewels_respecUnsocket"))
                    if socketedJewel.name then
                        local tmpName = PST:getLocalized("jewel_" .. socketedJewel.name)
                        descName = descName .. " - " .. tmpName
                        setName = true
                    end
                end
                if not setName then
                    descName = descName .. " " .. PST:getLocalized("ui_jewels_invKey")
                end
            else
                descName = descName .. " " .. PST:getLocalized("ui_jewels_invKey")
            end
            return { name = descName, description = tmpDescription }
        end,

        -- Astral Forge & equipped weapon
        ["Astral Forge"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            if isAllocated then
                local eqWeapon = PST:getEquippedAstralWep()
                if eqWeapon then
                    tmpDescription = PST:getAstralWepDesc(eqWeapon, PST:isKeybindActive(PSTKeybind.PAN_FASTER, true))
                    table.insert(tmpDescription, PST:getLocalized("ui_astralForgeKey"))
                end
            end
            return { name = descName, description = tmpDescription }
        end,

        -- Timeless Bazaar & purchased items
        ["Timeless Bazaar"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            if isAllocated then
                local charData = PST:getCurrentCharData()
                if charData and charData.bazaarPurchased and #charData.bazaarPurchased > 0 then
                    local newDesc = {table.unpack(tmpDescription)}
                    table.insert(newDesc, 2, {PST:getLocalized("ui_purchItems"), PST.kcolors.LEVEL_PURPLE})
                    local gameCfg = Isaac.GetItemConfig()
                    for _, tmpItem in ipairs(charData.bazaarPurchased) do
                        local itemCfg = gameCfg:GetCollectible(tmpItem)
                        if itemCfg then
                            local itemName = Isaac.GetLocalizedString("Items", itemCfg.Name, Options.Language)
                            if itemName ~= "StringTable::InvalidKey" then
                                table.insert(newDesc, 3, {"    " .. itemName, PST.kcolors.LEVEL_PURPLE})
                            end
                        end
                    end
                    return { name = descName, description = newDesc }
                end
            end
            return { name = descName, description = tmpDescription }
        end,

        -- Character SP Conversion extra info
        ["Character SP Conversion"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            local newDesc = {table.unpack(tmpDescription)}
            local charData = PST:getCurrentCharData()
            if charData then
                local charName = PST:getCurrentCharName()
                table.insert(newDesc, {PST:getLocalized("ui_currentChar") .. ": " .. charName, PST.kcolors.LEVEL_PURPLE})
                table.insert(newDesc, {charName .. " " .. PST:getLocalized("ui_skillPoints") .. ": " .. charData.skillPoints, PST.kcolors.LEVEL_PURPLE})
            end
            return { name = descName, description = newDesc }
        end,

        -- Save Backups Addon warning node
        ["Save Backups Addon"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            local newDesc = {}
            for _, tmpLine in ipairs(tmpDescription) do
                table.insert(newDesc, {tmpLine, PST.kcolors.LIGHTRED1})
            end
            return { name = descName, description = newDesc }
        end,

        -- Global Skill Point exchange node, show exchange rate
        ["Global Skill Point Exchange"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            local nodeDesc = {}
            if not isAllocated then
                table.insert(nodeDesc, PST:getLocalized("ui_globalSPConvDesc1"))
                table.insert(nodeDesc, PST:getLocalized("ui_globalSPConvDesc2"))
            else
                local charData = PST:getCurrentCharData()
                if charData then
                    if not charData.obolGSPtrades then charData.obolGSPtrades = 0 end
                    table.insert(nodeDesc, PST:getLocalized("ui_globalSPConvKey"))
                    table.insert(nodeDesc, {
                        PST:getLocalizedFormat("ui_globalSPConvRate", {obols = PST:getExpedObolToGSPRate(charData.obolGSPtrades)}),
                        PST.kcolors.PURPLE1
                    })
                else
                    table.insert(nodeDesc, {PST:getLocalized("ui_charLoadError"), PST.kcolors.RED1})
                end
            end
            return { name = descName, description = nodeDesc }
        end,

        -- Sidereal Artifact node description
        ["Sidereal Artifact"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            local nodeDesc = {}
            if not isAllocated then
                nodeDesc = tmpDescription
            else
                local charData = PST:getCurrentCharData()
                if charData then
                    -- Chosen Septentrional Artifact descriptions
                    if charData.northArtis and #charData.northArtis > 0 then
                        table.insert(nodeDesc, PST:getLocalized("ui_selSeptentrions"))
                        for _, tmpArtiName in ipairs(charData.northArtis) do
                            local tmpArtiData = PST.sideArtiData[tmpArtiName]
                            if tmpArtiData then
                                table.insert(nodeDesc, {tmpArtiData.name, PST.kcolors.BLUE2})
                                for _, tmpLine in ipairs(tmpArtiData.desc) do
                                    local newTmpLine
                                    if type(tmpLine) == "table" then
                                        newTmpLine = {tmpLine[1], PST.kcolors.BLUE1}
                                    else
                                        newTmpLine = {tmpLine, PST.kcolors.BLUE1}
                                    end
                                    table.insert(nodeDesc, newTmpLine)
                                end
                            end
                        end
                    else
                        table.insert(nodeDesc, {PST:getLocalized("ui_noSelSeptentrions"), PST.kcolors.BLUE1})
                    end

                    -- Chosen Meridional Artifact descriptions
                    if charData.southArtis and #charData.southArtis > 0 then
                        table.insert(nodeDesc, PST:getLocalized("ui_selMeridions"))
                        for _, tmpArtiName in ipairs(charData.southArtis) do
                            local tmpArtiData = PST.sideArtiData[tmpArtiName]
                            if tmpArtiData then
                                table.insert(nodeDesc, {tmpArtiData.name, PST.kcolors.ANCIENT_ORANGE})
                                for _, tmpLine in ipairs(tmpArtiData.desc) do
                                    local newTmpLine
                                    if type(tmpLine) == "table" then
                                        newTmpLine = {tmpLine[1], PST.kcolors.ANCIENT_ORANGE}
                                    else
                                        newTmpLine = {tmpLine, PST.kcolors.ANCIENT_ORANGE}
                                    end
                                    table.insert(nodeDesc, newTmpLine)
                                end
                            end
                        end
                    else
                        table.insert(nodeDesc, {PST:getLocalized("ui_noSelMeridions"), PST.kcolors.ANCIENT_ORANGE})
                    end
                end
                table.insert(nodeDesc, PST:getLocalized("ui_selArtifacts"))
            end
            return { name = descName, description = nodeDesc }
        end,

        -- Individual Artifact node description
        ["Sidereal Artifact Individual"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            local nodeDesc = {}
            local artiData = PST.sideArtiData[extraData.artifact]
            if artiData then
                for _, tmpLine in ipairs(artiData.desc) do
                    table.insert(nodeDesc, tmpLine)
                end

                -- Infectious Meridion extra
                if extraData.artifact == "infectiousMeridion" then
                    table.insert(nodeDesc, PST:getLocalized("ui_infMeridionDesc"))
                end

                -- Unlock objective
                if artiData.objective then
                    local artiProg = 0
                    if PST.modData.sideArtiUnlockProg[extraData.artifact] ~= nil then
                        artiProg = PST.modData.sideArtiUnlockProg[extraData.artifact]
                    end
                    local tmpCol = PST.kcolors.RED1
                    if artiProg >= artiData.objective.req then
                        tmpCol = PST.kcolors.GREEN1
                    end
                    table.insert(nodeDesc, {PST:getLocalized("ui_unlock") .. ": " .. PST:formatString(artiData.objective.desc, { progress = artiProg }), tmpCol})
                end
                if not artiData.objective then
                    table.insert(nodeDesc, PST:getLocalized("ui_defUnlock") .. ".")
                end

                -- Max selected
                local charData = PST:getCurrentCharData()
                if charData and not isAllocated and PST:isSideArtiUnlocked(extraData.artifact) and extraData.available then
                    if artiData.type == "septentrion" and #charData.northArtis >= charData.maxNorthArtis then
                        table.insert(nodeDesc, {PST:getLocalized("ui_maxSeptentrionsWarn"), PST.kcolors.RED1})
                    elseif artiData.type == "meridion" and #charData.southArtis >= charData.maxSouthArtis then
                        table.insert(nodeDesc, {PST:getLocalized("ui_maxMeridionsWarn"), PST.kcolors.RED1})
                    end
                end
            end
            return { name = descName, description = nodeDesc }
        end,

        -- Crimson Convergence node starcore display
        ["Crimson Convergence"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            local nodeDesc = {table.unpack(tmpDescription)}
            if isAllocated then
                local charData = PST:getCurrentCharData()
                if charData then
                    table.insert(nodeDesc, {PST:getLocalizedFormatStr("ui_charCrimsonCores", {charName = PST:getCurrentCharName(), cores = charData.crimsonStarcores}), PST.kcolors.RED3})

                    if charData.crimConvBuff and PST.crimConvergenceBuffs[charData.crimConvBuff] then
                        local buffData = PST.crimConvergenceBuffs[charData.crimConvBuff]
                        table.insert(nodeDesc, {PST:getLocalized("ui_selected") .. ": " .. buffData.name, PST.kcolors.ANCIENT_ORANGE})
                        for _, tmpLine in ipairs(buffData.desc) do
                            table.insert(nodeDesc, {tmpLine, PST.kcolors.ANCIENT_ORANGE})
                        end
                    end
                end
            end
            return { name = descName, description = nodeDesc }
        end,

        -- Deep-Space Astrolabe, Deep-Space SP display
        ["Deep-Space Astrolabe"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            local nodeDesc = {table.unpack(tmpDescription)}
            table.insert(nodeDesc, {PST:getLocalized("ui_deepSpaceSP") .. ": " .. (PST.modData.deepSpaceSP or 0), PST.kcolors.STAR_ORANGE})
            return { name = descName, description = nodeDesc }
        end,

        -- Obscure Bazaar, display arcane obols
        ["Obscure Bazaar"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            local nodeDesc = {table.unpack(tmpDescription)}
            local charData = PST:getCurrentCharData()
            if charData then
                table.insert(nodeDesc, {PST:getCurrentCharName() .. " " .. PST:getLocalized("ui_obols") .. ": " .. charData.arcaneObols, PST.kcolors.PURPLE1})
            end
            return { name = descName, description = nodeDesc }
        end
    }
}

local nonDynamicNodes = {
    "Boss Rush Door Timer Increase", "Beast-hunter's Rush", "Hush Door Timer Increase", "More Boss Rush Waves",
    "Less Boss Rush Waves", "Sidereal Artifact", "Crimson Convergence"
}

-- Additional functions that provide special/dynamic node descriptions
-- Functions are run with the same parameters as above: (descName, tmpDescription, isAllocated, tScreen, extraData)
-- extraData.node also contains node data
local extraNodeDescFuncs = {}
---@param funcName string
---@param func function
function PST:addExtraNodeDescFunc(funcName, func)
    extraNodeDescFuncs[funcName] = func
end

---@param tScreen PST.treeScreen
function descriptionBoxesModule:Render(tScreen)
    local hoveredNode = tScreen.hoveredNode
    if hoveredNode ~= nil then
        local descName = hoveredNode.name
        local tmpDescription = hoveredNode.description
        local isAllocated = PST:isNodeAllocated(tScreen.currentTree, hoveredNode.id)

        -- Check for node description additions
        local extraData = {}
        local nodeDescFunc = self.dynamicNodeDescriptions[hoveredNode.name]
        -- Grand Ingredient nodes
        if not nodeDescFunc and PST:strStartsWith(hoveredNode.name, "Grand Ingredient") then
            nodeDescFunc = self.dynamicNodeDescriptions["Grand Ingredient"]
        end
        -- Starcursed inventory/socket nodes
        if not nodeDescFunc and isAllocated then
            for _, tmpType in pairs(PSTStarcursedType) do
                if PST:strStartsWith(hoveredNode.name, tmpType) then
                    local isSocket = string.find(hoveredNode.name, "Socket") ~= nil
                    if isSocket or string.find(hoveredNode.name, "Inventory") ~= nil then
                        nodeDescFunc = self.dynamicNodeDescriptions["Star Jewel Node"]
                        extraData.isSocket = isSocket
                        extraData.jewelType = tmpType
                    end
                    break
                end
            end
        end
        -- Sidereal Artifact nodes
        if not nodeDescFunc then
            for tmpMod, _ in pairs(hoveredNode.modifiers) do
                if PST.sideArtiData[tmpMod] then
                    extraData.artifact = tmpMod
                    extraData.available = hoveredNode.available
                    nodeDescFunc = self.dynamicNodeDescriptions["Sidereal Artifact Individual"]
                    break
                end
            end
        end
        -- Extra funcs
        if not nodeDescFunc then
            for _, tmpFunc in pairs(extraNodeDescFuncs) do
                if not extraData.node then extraData.node = hoveredNode end

                local newData = tmpFunc(descName, tmpDescription, isAllocated, tScreen, extraData)
                if newData and newData.name and newData.description then
                    descName = newData.name
                    tmpDescription = newData.description
                    break
                end
            end
        end
        if nodeDescFunc then
            local newDescData = nodeDescFunc(descName, tmpDescription, isAllocated, tScreen, extraData)
            descName = newDescData.name
            tmpDescription = newDescData.description
        end

        -- Crimson nodes
        if PST:arrHasValue(PST.crimsonNodeNames, hoveredNode.name) then
            local charData = PST:getCurrentCharData()
            if charData and charData.crimsonNodes then
                local tmpCrimsonNode = charData.crimsonNodes[tostring(hoveredNode.id)]
                if tmpCrimsonNode then
                    local tgtNode = nil
                    -- Fetch selected node's original description
                    if PST:strStartsWith(hoveredNode.name, "Universal") and PST.globalMedNodes[tmpCrimsonNode.name] then
                        tgtNode = PST.globalMedNodes[tmpCrimsonNode.name]
                    elseif PST:strStartsWith(hoveredNode.name, "Core") then
                        local tmpTree = PST:getCurrentCharName()
                        if tmpTree and PST.charMedNodes[tmpTree][tmpCrimsonNode.name] then
                            tgtNode = PST.charMedNodes[tmpTree][tmpCrimsonNode.name]
                        end
                    else
                        for tmpTree, _ in pairs(PST.charMedNodes) do
                            if tmpTree ~= PST:getCurrentCharName() and PST.charMedNodes[tmpTree][tmpCrimsonNode.name] then
                                tgtNode = PST.charMedNodes[tmpTree][tmpCrimsonNode.name]
                                break
                            end
                        end
                    end
                    if tgtNode then
                        tmpDescription = {
                            table.unpack(hoveredNode.description),
                            {PST:getLocalized("ui_selNode") .. ": " .. tgtNode.name, PST.kcolors.LIGHTRED1}
                        }
                        for _, tmpLine in ipairs(tgtNode.description) do
                            table.insert(tmpDescription, {tmpLine, PST.kcolors.LIGHTRED1})
                        end
                    end
                end
            end
        end

        -- Sidereal tree node warning
        if PST.treeScreen.currentTree == "sidereal" and hoveredNode.name ~= "Sidereal Vicinity" and hoveredNode.name ~= "Sidereal Region" and hoveredNode.name ~= "Sidereal Expanse" then
            table.insert(tmpDescription, {PST:getLocalized("ui_siderealNodeWarning"), PST.kcolors.STAR_ORANGE})
        end

        -- Special node requirements
        local noSP = (hoveredNode.reqs and hoveredNode.reqs.noSP)
        if hoveredNode.reqs and not isAllocated then
            tmpDescription = {table.unpack(tmpDescription)}

            -- Arcane obols requirement
            local obolReq = hoveredNode.reqs.obols
            if type(obolReq) == "table" and obolReq.var and PST[obolReq.var] then
                obolReq = PST[obolReq.var]
            end
            if obolReq then
                table.insert(tmpDescription, {PST:getLocalizedFormat("ui_obolReq", {obolReq = obolReq}), PST.kcolors.PURPLE1})
            end

            -- Expedition depth requirement
            local expReq = hoveredNode.reqs.expeditionDepth
            if expReq then
                local tmpColor = PST.kcolors.LIGHTORANGE1
                if PST.modData.expeditionDepth > expReq then
                    tmpColor = PST.kcolors.GREEN1
                end
                table.insert(tmpDescription, {PST:getLocalizedFormat("ui_expDepthReq", {depthReq = expReq}), tmpColor})
            end

            -- Uber expedition depth requirement
            local uberReq = hoveredNode.reqs.uberDepth
            if uberReq then
                local tmpColor = PST.kcolors.RED2
                if PST.modData.uberExpedDepth > uberReq then
                    tmpColor = PST.kcolors.GREEN1
                end
                table.insert(tmpDescription, {PST:getLocalizedFormat("ui_uberExpDepthReq", {depthReq = uberReq}), tmpColor})
            end

            -- Character level requirement
            local currentChar = PST:getCurrentCharData()
            local charlvlReq = hoveredNode.reqs.charLevel
            if charlvlReq and currentChar and currentChar.level < charlvlReq then
                table.insert(tmpDescription, {PST:getLocalizedFormat("ui_charlvlReq", {charName = PST:getCurrentCharName(), lvlReq = charlvlReq}), PST.kcolors.LIGHTRED1})
            end

            -- Crimson starcores requirement
            local crimsonStarcoreReq = hoveredNode.reqs.crimsonStarcore
            if crimsonStarcoreReq then
                local tmpColor = PST.kcolors.RED1
                if currentChar and currentChar.crimsonStarcores and currentChar.crimsonStarcores >= crimsonStarcoreReq then
                    tmpColor = PST.kcolors.GREEN1
                end
                table.insert(tmpDescription, {PST:getLocalized("ui_crimsonCoreReq"), tmpColor})

                if currentChar then
                    table.insert(tmpDescription, {
                        PST:getLocalizedFormat("ui_charCrimsonCores", {charName = PST:getCurrentCharName(), cores = (currentChar.crimsonStarcores or 0)}),
                        tmpColor
                    })
                end
            end

            -- Deep-Space SP requirement
            if hoveredNode.reqs.deepSpaceNode then
                table.insert(tmpDescription, {PST:getLocalizedFormat("ui_deepSPReq", {deepSP = (PST.modData.deepSpaceSP or 0)}), PST.kcolors.STAR_ORANGE})
            end
        end
        if not isAllocated and not noSP and PST:arrHasValue(PST.globalTrees, tScreen.currentTree) and not PST:arrHasValue(PST.nodeSPExceptions, hoveredNode.name) then
            tmpDescription = {table.unpack(tmpDescription)}
            table.insert(tmpDescription, {PST:getLocalized("ui_globalSPReq"), PST.kcolors.BLUE1})
        end
        if Isaac.IsInGame() and PST:getTreeSnapshotMod("dynamicMode", false) and (PST:arrHasValue(nonDynamicNodes, hoveredNode.name) or (hoveredNode.reqs and hoveredNode.reqs.nonDynamic)) then
            tmpDescription = {table.unpack(tmpDescription)}
            table.insert(tmpDescription, {PST:getLocalized("ui_nonDynamicWarn"), PST.kcolors.RED2})
        end

        ---- Localization ----
        -- Node name
        if hoveredNode.nameLocale then
            descName = PST:getLocalized(hoveredNode.nameLocale, Options.Language)
        end

        -- Node description
        if tmpDescription[1] then
            local tmpDescKey
            if type(tmpDescription[1]) == "table" and tmpDescription[1][1]:sub(1, 1) == '#' then
                tmpDescKey = tmpDescription[1][1]:sub(2)
            elseif tmpDescription[1]:sub(1, 1) == '#' then
                tmpDescKey = tmpDescription[1]:sub(2)
            end
            if tmpDescKey then
                local localizedDesc = PST:getLocalizedFormat(tmpDescKey, hoveredNode.modifiers)
                if localizedDesc then
                    if type(localizedDesc) == "string" then tmpDescription = {localizedDesc}
                    else tmpDescription = localizedDesc end
                end
            end
        end

        tScreen:DrawNodeBox(descName, tmpDescription or hoveredNode.description)
    else
        -- Submenu-related description boxes
        local submenusModule = tScreen.modules.submenusModule

        -- Cosmic Realignment node, hovered character name & curse description
        if submenusModule.currentSubmenu == PSTSubmenu.COSMICREALIGNMENT then
            local cosmicRSubmenu = submenusModule.submenus[PSTSubmenu.COSMICREALIGNMENT]
            if cosmicRSubmenu.hoveredCharID ~= nil then
                local charID = cosmicRSubmenu.hoveredCharID
                local tmpDescription = { PST:getLocalizedFormat("ui_cosmicR_unlockChar", {charName = PST.charNames[1 + charID]}) }
                if PST:cosmicRIsCharUnlocked(charID) then
                    tmpDescription = PST.cosmicRData.characters[charID].curseDesc
                end
                tScreen:DrawNodeBox(PST.charNames[1 + charID], tmpDescription)
            end
        -- Starcursed inventory, hovered jewel data
        elseif submenusModule.currentSubmenu == PSTSubmenu.STARJEWELINV then
            local starInvSubmenu = submenusModule.submenus[PSTSubmenu.STARJEWELINV]
            local jewelData = starInvSubmenu.hoveredJewel
            if jewelData then
                local tmpDescription = PST:SC_getJewelDescription(jewelData)
                if PST:SC_canDestroyJewel(jewelData) then
                    table.insert(tmpDescription, PST:getLocalized("ui_jewels_respecDestroy"))
                elseif jewelData.status and jewelData.status == "converted" then
                    table.insert(tmpDescription, PST:getLocalized("ui_jewels_respecRemBoss"))
                end
                local jewelTitle = jewelData.name or jewelData.type .. " " .. PST:getLocalized("ui_starcursedJewel")
                if jewelData.mighty then
                    jewelTitle = jewelTitle .. " (" .. PST:getLocalized("ui_mighty") .. ")"
                end
                tScreen:DrawNodeBox(jewelTitle, tmpDescription)
            end
        -- Crimson node submenu, hovered node description
        elseif submenusModule.currentSubmenu == PSTSubmenu.CRIMSON_NODE then
            local crimsonNodeSubmenu = submenusModule.submenus[PSTSubmenu.CRIMSON_NODE]
            local nodeData = crimsonNodeSubmenu.hoveredNode
            if nodeData then
                local tmpDesc = {table.unpack(nodeData.description)}
                table.insert(tmpDesc, PST:getLocalized("ui_allocToSelNode"))
                tScreen:DrawNodeBox(nodeData.name, tmpDesc)
            end
        -- Infectious Meridion submenu, hovered status
        elseif submenusModule.currentSubmenu == PSTSubmenu.INFECTIOUS_MERIDION then
            local infMeridionSubmenu = submenusModule.submenus[PSTSubmenu.INFECTIOUS_MERIDION]
            local tmpStatus = infMeridionSubmenu.hoveredItem
            if tmpStatus then
                local tmpName = tmpStatus:gsub("^[a-z]", string.upper)
                local tmpDesc = {PST:getLocalized("ui_pulseInflict") .. " " .. tmpStatus .. "."}
                tScreen:DrawNodeBox(tmpName, tmpDesc)
            end
        -- Crimson Convergence submenu, hovered buff
        elseif submenusModule.currentSubmenu == PSTSubmenu.CRIMSON_CONVERGENCE then
            local crimConvSubmenu = submenusModule.submenus[PSTSubmenu.CRIMSON_CONVERGENCE]
            local tmpBuff = crimConvSubmenu.hoveredBuff
            if tmpBuff and PST.crimConvergenceBuffs[tmpBuff] then
                local buffData = PST.crimConvergenceBuffs[tmpBuff]
                tScreen:DrawNodeBox(buffData.name, buffData.desc)
            end
        -- Obscure Bazaar submenu, hovered item
        elseif submenusModule.currentSubmenu == PSTSubmenu.OBSCURE_BAZAAR then
            local obsBazaarSubmenu = submenusModule.submenus[PSTSubmenu.OBSCURE_BAZAAR]
            local tmpItem = obsBazaarSubmenu.hoveredItem
            if tmpItem then
                local itemPrice = tostring(PST:getObsBazaarPrice(tmpItem.price))
                local itemDesc = {}
                if tmpItem.type == PSTExpNodeRewardType.C_STARCORE or tmpItem.type == PSTExpNodeRewardType.GLOBAL_SP then
                    table.insert(
                        itemDesc,
                        PST:getLocalizedFormat("ui_obsBazaarHoverDesc", {
                            itemName = tmpItem.name,
                            charName = PST:getCurrentCharName() or PST:getLocalized("ui_theCurrentChar")
                        })
                    )
                end
                local charData = PST:getCurrentCharData()
                if charData then
                    table.insert(itemDesc, {
                        PST:getLocalizedFormat("ui_charObols", {charName = PST:getCurrentCharName(), obols = charData.arcaneObols}),
                        PST.kcolors.PURPLE1
                    })
                end
                table.insert(itemDesc, {PST:getLocalizedFormat("ui_costsObols", {price = itemPrice}), PST.kcolors.LEVEL_PURPLE})
                table.insert(itemDesc, PST:getLocalized("ui_allocPurchase"))
                tScreen:DrawNodeBox(tmpItem.name, itemDesc)
            end
        -- Weapon Compendium submenu, hovered weapon
        elseif submenusModule.currentSubmenu == PSTSubmenu.WEAPON_COMPENDIUM then
            local wepCompendiumSubmenu = submenusModule.submenus[PSTSubmenu.WEAPON_COMPENDIUM]
            local tmpItem = wepCompendiumSubmenu.hoveredID
            if tmpItem then
                if not wepCompendiumSubmenu.selectedType then
                    local itemDesc = {PST:getLocalized("ui_wepCompendiumKey")}
                    tScreen:DrawNodeBox(PST:getLocalized("ui_wepType") ": " .. PST.astralWepData[tmpItem].name, itemDesc)
                else
                    local itemDesc = PST:getAstralWepDesc(tmpItem, true)
                    tScreen:DrawNodeBox(PST:getLocalized("ui_ancWep") .. ": " .. tmpItem.name, itemDesc)
                end
            end
        end
    end
end

return descriptionBoxesModule