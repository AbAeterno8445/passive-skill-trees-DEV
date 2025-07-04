local totalmodsScreen = {
    totalModsList = {}
}

function totalmodsScreen:OnOpen(openData)
    -- Compile list of active modifiers
    local sortedModNames = {}
    local tmpModsList = {}
    self.totalModsList = {}
    local function PST_processTreeNodes(tmpTree)
        for tmpNodeID, tmpNode in pairs(PST.trees[tmpTree]) do
            if PST:isNodeAllocated(tmpTree, tmpNodeID) then
                -- Create sorted table of modifier names
                for tmpModName, _ in pairs(tmpNode.modifiers) do
                    if PST.treeModDescriptions[tmpModName] ~= nil and not PST:arrHasValue(sortedModNames, tmpModName) then
                        table.insert(sortedModNames, tmpModName)
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

    table.sort(sortedModNames, function(a, b)
        if PST.treeModDescriptions[a] == nil or PST.treeModDescriptions[b] == nil then
            return false
        end
        return PST.treeModDescriptions[a].sort < PST.treeModDescriptions[b].sort
    end)

    -- Create final description table
    local lastCategory = nil
    for _, tmpModName in ipairs(sortedModNames) do
        local tmpModVal = tmpModsList[tmpModName]

        -- Category change
        local categorySwitch = lastCategory == nil
        if lastCategory ~= nil and lastCategory ~= PST.treeModDescriptions[tmpModName].category then
            table.insert(self.totalModsList, "")
            categorySwitch = true
        end
        lastCategory = PST.treeModDescriptions[tmpModName].category

        local tmpColor = PST.kcolors.WHITE
        if PST.treeModDescriptionCategories[lastCategory] then
            tmpColor = PST.treeModDescriptionCategories[lastCategory].color
        end
        -- Mom heart proc mods - show as disabled if mom's heart needs to be re-defeated
        if PST.modData.momHeartProc[tmpModName] == false then
            tmpColor = PST.kcolors.GRAY1
        end

        -- Category title
        if categorySwitch and tmpCharName and PST.trees[tmpCharName] ~= nil then
            local tmpName = PST.treeModDescriptionCategories[lastCategory].name
            if lastCategory == "charTree" then
                local charAlias = PST.treeScreen.currentTree
                if PST.treeScreen.treeAliases[PST.treeScreen.currentTree] then
                    charAlias = PST.treeScreen.treeAliases[PST.treeScreen.currentTree]
                end
                local tmpPossessive = "'s"
                if string.sub(charAlias, -1) == "s" then
                    tmpPossessive = "'"
                end
                tmpName = tmpCharName .. tmpPossessive .. " tree:"
            end
            table.insert(self.totalModsList, {"---- " .. tmpName .. " ----", PST.treeModDescriptionCategories[lastCategory].color})
        end

        local parsedModLines = PST:parseModifierLines(tmpModName, tmpModVal)
        for _, tmpLine in ipairs(parsedModLines) do
            -- Harmonic modifiers, check if disabled
            if PST:strStartsWith(tmpLine, "    " .. PST:getLocalized("harmonic_prefix")) and PST:songNodesAllocated() > 2 then
                tmpColor = PST.kcolors.GRAY1
            end
            table.insert(self.totalModsList, {tmpLine, tmpColor})
        end

        if PST.modData.momHeartProc[tmpModName] == false then
            table.insert(self.totalModsList, {"   Inactive until Mom's Heart is defeated again.", PST.kcolors.RED2})
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
        table.insert(starTreeMods, {tostring(tScreen.starcursedTotalMods.totalStarmight) .. " total Starmight.", starTreeModsColor})
        table.insert(starTreeMods, {"Starmight bonuses:", starTreeModsColor})
        for modName, modVal in pairs(PST:SC_getStarmightImplicits(tScreen.starcursedTotalMods.totalStarmight)) do
            local parsedModLines = PST:parseModifierLines(modName, modVal)
            for _, tmpLine in ipairs(parsedModLines) do
                table.insert(starTreeMods, {"   " .. tmpLine, starTreeModsColor})
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
            "Cosmic Realignment (" .. tmpCharName .. ")",
            PST.kcolors.LIGHTBLUE1
        })
        table.insert(self.totalModsList, {
            "Can now get unlocks as if playing as " .. tmpCharName,
            PST.kcolors.LIGHTBLUE1
        })
    end
end

---@param tScreen PST.treeScreen
function totalmodsScreen:Render(tScreen, menuModule)
    tScreen:DrawNodeBox("Active Modifiers", self.totalModsList, 16, 16 + menuModule.menuScrollY, true, 1)
end

return totalmodsScreen