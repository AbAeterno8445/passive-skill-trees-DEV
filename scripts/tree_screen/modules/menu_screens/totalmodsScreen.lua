local totalmodsScreen = {
    totalModsList = {}
}

function totalmodsScreen:OnOpen(openData)
    -- Compile list of active modifiers
    local categorizedMods = {}
    local tmpModsList = {}
    local modDescriptions = {}
    self.totalModsList = {}
    local function PST_processTreeNodes(tmpTree)
        for tmpNodeID, tmpNode in pairs(PST.trees[tmpTree]) do
            if PST:isNodeAllocated(tmpTree, tmpNodeID) then
                -- Creates table of present modifier names
                for tmpModName, _ in pairs(tmpNode.modifiers) do
                    for modCategory, categoryList in pairs(PST.treeModCategories) do
                        if PST:arrHasValue(categoryList, tmpModName) then
                            if not categorizedMods[modCategory] then
                                categorizedMods[modCategory] = {}
                            end
                            if not PST:arrHasValue(categorizedMods[modCategory], tmpModName) then
                                table.insert(categorizedMods[modCategory], tmpModName)
                            end
                            if not modDescriptions[tmpModName] then
                                modDescriptions[tmpModName] = tmpNode.description
                            end
                            break
                        end
                    end
                end

                -- Create table with totals for each modifier
                for tmpModName, tmpModVal in pairs(tmpNode.modifiers) do
                    if tmpModsList[tmpModName] == nil then
                        tmpModsList[tmpModName] = tmpModVal
                    elseif type(tmpModsList[tmpModName]) == "number" then
                        tmpModsList[tmpModName] = tmpModsList[tmpModName] + tmpModVal
                    end
                end
            end
        end
    end
    PST_processTreeNodes("global")
    local tmpCharName = PST.charNames[1 + PST.selectedMenuChar]
    if tmpCharName and PST.trees[tmpCharName] ~= nil then
        PST_processTreeNodes(tmpCharName)
    end

    -- Create final description table
    local lastCategory = nil
    for _, modCategory in ipairs(PST.treeModCategoryOrder) do
        local categoryList = categorizedMods[modCategory]
        if categoryList then
            local categoryData = PST.treeModDescriptionCategories[modCategory]
            if categoryData then
                -- Category title
                local categoryName = categoryData.name
                if modCategory == "charTree" then
                    local charAlias = PST:getCurrentCharName()
                    if PST.treeScreen.treeAliases[PST:getCurrentCharName()] then
                        charAlias = PST.treeScreen.treeAliases[PST:getCurrentCharName()]
                    end
                    if charAlias then
                        local tmpPossessive = "'s"
                        if string.sub(charAlias, -1) == "s" then
                            tmpPossessive = "'"
                        end
                        categoryName = PST:getLocalizedFormatStr("ui_charTreeName", {charName = charAlias, possessive = tmpPossessive})
                    end
                end
                table.insert(self.totalModsList, "")
                table.insert(self.totalModsList, {"---- " .. categoryName .. " ----", categoryData.color})
                lastCategory = categoryData
            end

            for _, tmpModName in ipairs(categoryList) do
                local origNodeDesc = modDescriptions[tmpModName]
                if origNodeDesc and origNodeDesc[1] then
                    local tmpModVal = tmpModsList[tmpModName]

                    local tmpColor = PST.kcolors.WHITE
                    if lastCategory then
                        tmpColor = lastCategory.color
                    end
                    -- Mom heart proc mods - show as disabled if mom's heart needs to be re-defeated
                    if PST.modData.momHeartProc[tmpModName] == false then
                        tmpColor = PST.kcolors.GRAY1
                    end

                    local parsedModLines = PST:getLocalizedFormat(origNodeDesc[1], {[tmpModName] = tmpModVal})
                    if type(parsedModLines) ~= "table" then
                        parsedModLines = {parsedModLines}
                    end
                    for _, tmpLine in ipairs(parsedModLines) do
                        -- Harmonic modifiers, check if disabled
                        if PST:strStartsWith(tmpLine, "    " .. PST:getLocalized("harmonic_prefix")) and PST:songNodesAllocated() > 2 then
                            tmpColor = PST.kcolors.GRAY1
                        end
                        table.insert(self.totalModsList, {tmpLine, tmpColor})
                    end

                    if PST.modData.momHeartProc[tmpModName] == false then
                        table.insert(self.totalModsList, {"   " .. PST:getLocalized("ui_momheartproc_inactive") .. ".", PST.kcolors.RED2})
                    end
                end
            end
        end
    end

    -- Star tree mods for description table
    local tScreen = PST.treeScreen
    if tScreen.starcursedTotalMods and (next(tScreen.starcursedTotalMods.totalMods) ~= nil or tScreen.starcursedTotalMods.totalStarmight > 0) then
        local starTreeModsColor = PST.kcolors.STAR_ORANGE
        local starTreeMods = {}
        table.insert(self.totalModsList, "")
        table.insert(self.totalModsList, {"---- Star Tree Mods ----", starTreeModsColor})
        for _, modData in pairs(tScreen.starcursedTotalMods.totalMods) do
            if type(modData) == "table" then
                table.insert(starTreeMods, {modData.description, starTreeModsColor})
            end
        end
        table.sort(starTreeMods, function(a, b)
            if not a[1] or not b[1] then return false end
            return a[1] < b[1]
        end)
        -- Starmight
        table.insert(starTreeMods, {PST:getLocalizedFormatStr("ui_totalStarmight", {starmight = tScreen.starcursedTotalMods.totalStarmight}), starTreeModsColor})
        table.insert(starTreeMods, {PST:getLocalized("ui_starmightBonuses") .. ":", starTreeModsColor})
        for modName, modVal in pairs(PST:SC_getStarmightImplicits(tScreen.starcursedTotalMods.totalStarmight)) do
            local modDesc = PST:getLocalizedFormatStr("ui_" .. modName, {val = PST:roundFloat(modVal, -2)})
            if modName == "xpgain" then
                modDesc = PST:getLocalizedFormatStr("node_xp", {xpgain = PST:roundFloat(modVal, -2)})
            end
            if modDesc then
                table.insert(starTreeMods, {"   " .. modDesc, starTreeModsColor})
            end
        end
        for _, item in ipairs(starTreeMods) do
            table.insert(self.totalModsList, item)
        end
    end

    -- Add Cosmic Realignment mod to description table
    local cosmicRChar = PST.modData.cosmicRealignment
    if type(cosmicRChar) == "number" then
        tmpCharName = PST.charNames[1 + cosmicRChar]
        table.insert(self.totalModsList, "")
        table.insert(self.totalModsList, {
            PST:getLocalized("ui_cosmicRealignment") .. " (" .. tmpCharName .. ")",
            PST.kcolors.LIGHTBLUE1
        })
        table.insert(self.totalModsList, {
            PST:getLocalizedFormatStr("ui_cosmicR_unlocksPlayingAs", {tmpCharName = tmpCharName}),
            PST.kcolors.LIGHTBLUE1
        })
    end
end

---@param tScreen PST.treeScreen
function totalmodsScreen:Render(tScreen, menuModule)
    tScreen:DrawNodeBox(PST:getLocalized("ui_activemods"), self.totalModsList, 16, 16 + menuModule.menuScrollY, true, 1)
end

return totalmodsScreen