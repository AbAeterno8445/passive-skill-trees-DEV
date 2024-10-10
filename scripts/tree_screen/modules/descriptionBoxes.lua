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
                    "Can now get unlocks as if playing as " .. tmpCharName .. ".", KColor(0.85, 0.85, 1, 1)
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
                    local tmpColor = KColor(1, 0.8, 0.2, 1)
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
                    {"Reach level " .. tostring(PST.SCStarTreeUnlockLevel) .. " with at least one character to unlock.", KColor(1, 0.6, 0.6, 1)}
                }
            end
            return { name = descName, description = tmpDescription }
        end,

        -- Golden Trinket nodes, show whether golden trinkets are unlocked
        ["Golden Trinkets"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            tmpDescription = {table.unpack(tScreen.hoveredNode.description)}
            if Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_TRINKET) then
                table.insert(tmpDescription, {"Golden trinkets are unlocked.", KColor(0.6, 1, 0.6, 1)})
            else
                table.insert(tmpDescription, {"Golden trinkets are not unlocked.", KColor(1, 0.6, 0.6, 1)})
            end
            return { name = descName, description = tmpDescription }
        end,

        -- Grand Ingredient nodes, add warning if more than 2 are allocated
        ["Grand Ingredient"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            if PST:grandIngredientNodes(false) > 2 then
                tmpDescription = {table.unpack(tScreen.hoveredNode.description)}
                table.insert(tmpDescription, {"You have more than 2 Grand Ingredient nodes allocated!", KColor(1, 0.6, 0.6, 1)})
            end
            return { name = descName, description = tmpDescription }
        end,

        -- Soul Of The Siren node, track boss rush/hush completions
        ["Soul Of The Siren"] = function(descName, tmpDescription, isAllocated, tScreen, extraData)
            tmpDescription = {table.unpack(tScreen.hoveredNode.description)}
            local bothDone = true
            -- Boss rush
            if Isaac.GetCompletionMark(Isaac.GetPlayerTypeByName("Siren", true), CompletionType.BOSS_RUSH) == 0 then
                table.insert(tmpDescription, {"Missing Boss Rush completion with T. Siren!", KColor(1, 0.6, 0.6, 1)})
                bothDone = false
            end
            -- Hush
            if Isaac.GetCompletionMark(Isaac.GetPlayerTypeByName("Siren", true), CompletionType.HUSH) == 0 then
                table.insert(tmpDescription, {"Missing Hush completion with T. Siren!", KColor(1, 0.6, 0.6, 1)})
                bothDone = false
            end
            if bothDone then
                table.insert(tmpDescription, {"Boss Rush and Hush completed.", KColor(0.7, 1, 0.7, 1)})
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
    }
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
        if nodeDescFunc then
            local newDescData = nodeDescFunc(descName, tmpDescription, isAllocated, tScreen, extraData)
            descName = newDescData.name
            tmpDescription = newDescData.description
        end

        tScreen:DrawNodeBox(descName, tmpDescription or hoveredNode.description, tScreen.screenW, tScreen.screenH)
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
                tScreen:DrawNodeBox(PST.charNames[1 + charID], tmpDescription, tScreen.screenW, tScreen.screenH)
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
                tScreen:DrawNodeBox(jewelTitle, tmpDescription, tScreen.screenW, tScreen.screenH)
            end
        end
    end
end

return descriptionBoxesModule