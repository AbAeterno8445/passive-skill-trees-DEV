include("scripts.tree_screen.modules.siderealArtifact")

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
                    "Can now get unlocks as if playing as " .. tmpCharName .. ".", PST.kcolors.LIGHTBLUE1
                })
                table.insert(tmpDescription, "Press the Respec Node button to deselect this character.")
            elseif isAllocated then
                descName = descName .. " (E to pick character)"
            end
            return { name = descName, description = tmpDescription }
        end,

        -- Star Tree node
        ["Star Tree"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            if isAllocated then
                if tScreen.currentTree ~= "starTree" then
                    descName = descName .. " (E to view Star Tree)"
                elseif tScreen.starcursedTotalMods then
                    -- Append starmight description to Star Tree node
                    local tmpColor = PST.kcolors.STAR_ORANGE
                    tmpDescription = {table.unpack(tScreen.hoveredNode.description)}
                    table.insert(tmpDescription, {"Starmight: " .. tScreen.starcursedTotalMods.totalStarmight, tmpColor})
                    for modName, modVal in pairs(PST:SC_getStarmightImplicits(tScreen.starcursedTotalMods.totalStarmight)) do
                        local parsedModLines = PST:parseModifierLines(modName, modVal)
                        for _, tmpLine in ipairs(parsedModLines) do
                            table.insert(tmpDescription, {"   " .. tmpLine, tmpColor})
                        end
                    end
                end
            elseif not PST:SC_isStarTreeUnlocked() then
                tmpDescription = {
                    {"Reach level " .. tostring(PST.SCStarTreeUnlockLevel) .. " with at least one character to unlock.", PST.kcolors.RED2}
                }
            end
            return { name = descName, description = tmpDescription }
        end,

        -- Golden Trinket nodes, show whether golden trinkets are unlocked
        ["Golden Trinkets"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            tmpDescription = {table.unpack(tScreen.hoveredNode.description)}
            if Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_TRINKET) then
                table.insert(tmpDescription, {"Golden trinkets are unlocked.", PST.kcolors.GREEN1})
            else
                table.insert(tmpDescription, {"Golden trinkets are not unlocked.", PST.kcolors.RED2})
            end
            return { name = descName, description = tmpDescription }
        end,

        -- Grand Ingredient nodes, add warning if more than 2 are allocated
        ["Grand Ingredient"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            if PST:grandIngredientNodes(false) > 2 then
                tmpDescription = {table.unpack(tScreen.hoveredNode.description)}
                table.insert(tmpDescription, {"You have more than 2 Grand Ingredient nodes allocated!", PST.kcolors.RED2})
            end
            return { name = descName, description = tmpDescription }
        end,

        -- Soul Of The Siren node, track boss rush/hush completions
        ["Soul Of The Siren"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            tmpDescription = {table.unpack(tScreen.hoveredNode.description)}
            local bothDone = true
            -- Boss rush
            if Isaac.GetCompletionMark(Isaac.GetPlayerTypeByName("Siren", true), CompletionType.BOSS_RUSH) == 0 then
                table.insert(tmpDescription, {"Missing Boss Rush completion with T. Siren!", PST.kcolors.RED2})
                bothDone = false
            end
            -- Hush
            if Isaac.GetCompletionMark(Isaac.GetPlayerTypeByName("Siren", true), CompletionType.HUSH) == 0 then
                table.insert(tmpDescription, {"Missing Hush completion with T. Siren!", PST.kcolors.RED2})
                bothDone = false
            end
            if bothDone then
                table.insert(tmpDescription, {"Boss Rush and Hush completed.", PST.kcolors.GREEN1})
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
                    table.insert(tmpDescription, "Press the Respec Node button to unsocket the jewel.")
                    if socketedJewel.name then
                        descName = descName .. " - " .. socketedJewel.name
                        setName = true
                    end
                end
                if not setName then
                    descName = descName .. " (E to open/close inventory)"
                end
            else
                descName = descName .. " (E to open/close inventory)"
            end
            return { name = descName, description = tmpDescription }
        end,

        -- Astral Forge & equipped weapon
        ["Astral Forge"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            if isAllocated then
                local eqWeapon = PST:getEquippedAstralWep()
                if eqWeapon then
                    tmpDescription = PST:getAstralWepDesc(eqWeapon, PST:isKeybindActive(PSTKeybind.PAN_FASTER, true))
                    table.insert(tmpDescription, "Press Allocate to access the Astral Forge menu.")
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
                    table.insert(newDesc, 2, {"Purchased items:", PST.kcolors.LEVEL_PURPLE})
                    local gameCfg = Isaac.GetItemConfig()
                    for _, tmpItem in ipairs(charData.bazaarPurchased) do
                        local itemCfg = gameCfg:GetCollectible(tmpItem)
                        if itemCfg then
                            local itemName = Isaac.GetLocalizedString("Items", itemCfg.Name, "en")
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
                table.insert(newDesc, {"Current character: " .. charName, PST.kcolors.LEVEL_PURPLE})
                table.insert(newDesc, {charName .. " skill points: " .. tostring(charData.skillPoints), PST.kcolors.LEVEL_PURPLE})
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
                table.insert(nodeDesc, "Once allocated, press the Allocate button to convert some Arcane Obols into a Global Skill Point.")
                table.insert(nodeDesc, "Obol conversion cost increases the more you use this exchange with the current character.")
            else
                local charData = PST:getCurrentCharData()
                if charData then
                    if not charData.obolGSPtrades then charData.obolGSPtrades = 0 end
                    table.insert(nodeDesc, "Press the Allocate button to convert:")
                    table.insert(nodeDesc, {
                        tostring(PST:getExpedObolToGSPRate(charData.obolGSPtrades)) .. " obols into 1 Global Skill Point.",
                        PST.kcolors.PURPLE1
                    })
                else
                    table.insert(nodeDesc, {"Could not load current character data.", PST.kcolors.RED1})
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
                        table.insert(nodeDesc, "Selected Septentrional Artifacts:")
                        for _, tmpArtiName in ipairs(charData.northArtis) do
                            local tmpArtiData = PST.sideArtiData[tmpArtiName]
                            if tmpArtiData then
                                table.insert(nodeDesc, {tmpArtiData.name, PST.kcolors.BLUE1})
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
                        table.insert(nodeDesc, {"No Septentrional Artifacts Selected", PST.kcolors.BLUE1})
                    end

                    -- Chosen Meridional Artifact descriptions
                    if charData.southArtis and #charData.southArtis > 0 then
                        table.insert(nodeDesc, "Selected Meridional Artifacts:")
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
                        table.insert(nodeDesc, {"No Meridional Artifacts Selected", PST.kcolors.ANCIENT_ORANGE})
                    end
                end
                table.insert(nodeDesc, "Select Artifacts by allocating them, at no cost.")
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
                if artiData.objective then
                    local artiProg = 0
                    if PST.modData.sideArtiUnlockProg[extraData.artifact] ~= nil then
                        artiProg = PST.modData.sideArtiUnlockProg[extraData.artifact]
                    end
                    local tmpCol = PST.kcolors.RED1
                    if artiProg >= artiData.objective.req then
                        tmpCol = PST.kcolors.GREEN1
                    end
                    table.insert(nodeDesc, {"Unlock: " .. PST:formatString(artiData.objective.desc, { progress = artiProg }), tmpCol})
                end
                if not artiData.objective then
                    table.insert(nodeDesc, "Default unlock.")
                end

                local charData = PST:getCurrentCharData()
                if charData and not isAllocated then
                    if artiData.type == "septentrion" and #charData.northArtis >= charData.maxNorthArtis then
                        table.insert(nodeDesc, {"Max Septentrional artifacts selected! Respec a different artifact to select this one.", PST.kcolors.RED1})
                    elseif artiData.type == "meridion" and #charData.southArtis >= charData.maxSouthArtis then
                        table.insert(nodeDesc, {"Max Meridional artifacts selected! Respec a different artifact to select this one.", PST.kcolors.RED1})
                    end
                end
            end
            return { name = descName, description = nodeDesc }
        end
    }
}

local nonDynamicNodes = {
    "Boss Rush Door Timer Increase", "Beast-hunter's Rush", "Hush Door Timer Increase", "More Boss Rush Waves",
    "Less Boss Rush Waves"
}

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
                    nodeDescFunc = self.dynamicNodeDescriptions["Sidereal Artifact Individual"]
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
                            {"Selected node: " .. tgtNode.name, PST.kcolors.LIGHTRED1}
                        }
                        for _, tmpLine in ipairs(tgtNode.description) do
                            table.insert(tmpDescription, {tmpLine, PST.kcolors.LIGHTRED1})
                        end
                    end
                end
            end
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
                table.insert(tmpDescription, {"Requires " .. tostring(obolReq) .. " Arcane Obols to allocate.", PST.kcolors.PURPLE1})
            end

            -- Expedition depth requirement
            local expReq = hoveredNode.reqs.expeditionDepth
            if expReq then
                local tmpColor = PST.kcolors.LIGHTORANGE1
                if PST.modData.expeditionDepth > expReq then
                    tmpColor = PST.kcolors.GREEN1
                end
                table.insert(tmpDescription, {"Requires completing expedition depth " .. tostring(expReq) .. ".", tmpColor})
            end

            -- Character level requirement
            local currentChar = PST:getCurrentCharData()
            local charlvlReq = hoveredNode.reqs.charLevel
            if charlvlReq and currentChar and currentChar.level < charlvlReq then
                table.insert(tmpDescription, {"Requires the current character (" .. PST:getCurrentCharName() .. ") to reach level " .. tostring(charlvlReq) .. ".", PST.kcolors.LIGHTRED1})
            end

            -- Crimson starcores requirement
            local crimsonStarcoreReq = hoveredNode.reqs.crimsonStarcore
            if crimsonStarcoreReq then
                local tmpColor = PST.kcolors.RED1
                if currentChar and currentChar.crimsonStarcores and currentChar.crimsonStarcores >= crimsonStarcoreReq then
                    tmpColor = PST.kcolors.GREEN1
                end
                table.insert(tmpDescription, {"Requires 1 crimson starcore.", tmpColor})

                if currentChar then
                    table.insert(tmpDescription, {PST:getCurrentCharName() .. " crimson starcores: " .. tostring(currentChar.crimsonStarcores or 0), tmpColor})
                end
            end
        end
        if not isAllocated and not noSP and PST:arrHasValue(tScreen.globalTrees, tScreen.currentTree) and not PST:arrHasValue(PST.nodeSPExceptions, hoveredNode.name) then
            tmpDescription = {table.unpack(tmpDescription)}
            table.insert(tmpDescription, {"Requires 1 Global SP to allocate.", PST.kcolors.BLUE1})
        end
        if Isaac.IsInGame() and PST:getTreeSnapshotMod("dynamicMode", false) and PST:arrHasValue(nonDynamicNodes, hoveredNode.name) then
            tmpDescription = {table.unpack(tmpDescription)}
            table.insert(tmpDescription, {"This node does not support Dynamic Tree Mode, and is only applied on run start.", PST.kcolors.RED2})
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
                local tmpDescription = { "Unlock " .. PST.charNames[1 + charID] .. " to enable this option." }
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
                    table.insert(tmpDescription, "Press the Respec Node button to destroy this jewel.")
                elseif jewelData.status and jewelData.status == "converted" then
                    table.insert(tmpDescription, "Press the Respec Node button to remove the converted boss.")
                end
                local jewelTitle = jewelData.name or jewelData.type .. " Starcursed Jewel"
                if jewelData.mighty then
                    jewelTitle = jewelTitle .. " (Mighty)"
                end
                tScreen:DrawNodeBox(jewelTitle, tmpDescription)
            end
        -- Crimson node submenu, hovered node description
        elseif submenusModule.currentSubmenu == PSTSubmenu.CRIMSON_NODE then
            local crimsonNodeSubmenu = submenusModule.submenus[PSTSubmenu.CRIMSON_NODE]
            local nodeData = crimsonNodeSubmenu.hoveredNode
            if nodeData then
                local tmpDesc = {table.unpack(nodeData.description)}
                table.insert(tmpDesc, "Press Allocate to select this node.")
                tScreen:DrawNodeBox(nodeData.name, tmpDesc)
            end
        end
    end
end

return descriptionBoxesModule