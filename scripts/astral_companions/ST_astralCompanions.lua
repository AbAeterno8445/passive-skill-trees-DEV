include("scripts.astral_companions.ST_astralCompanions_init")

function PST:getCompScavengeMax()
    return 2000
end

-- Returns whether the given companion is equipped anywhere
function PST:isCompEquipped(compName, isEgg)
    local charData = PST:getCurrentCharData()
    if charData then
        local targetCompTable = charData.astralCompanions
        if isEgg then
            targetCompTable = charData.astralIncubators
        end
        if targetCompTable then
            for _, equippedComp in pairs(targetCompTable) do
                if equippedComp == compName then
                    return true
                end
            end
        end
    end
    return false
end

-- Returns the name of the egg equipped in the given slot.
---@param incubatorSlot number|string Incubator slot ID. Falls back to PST.selectedAstralIncubator if not provided
function PST:getEquippedIncubatorEgg(incubatorSlot)
    local charData = PST:getCurrentCharData()
    if charData and charData.astralIncubators then
        return charData.astralIncubators[tostring(incubatorSlot or PST.selectedAstralIncubator)]
    end
    return nil
end

-- Equips the given egg into the provided incubator slot, if the former has been found
function PST:equipIncubatorEgg(eggName, incubatorSlot, unequipCheck)
    local charData = PST:getCurrentCharData()
    if charData and PST.modData.astralcomps[eggName] then
        if not charData.astralIncubators then charData.astralIncubators = {} end

        -- Unequip if egg is present in other slots
        for slotID, slotEgg in pairs(charData.astralIncubators) do
            if slotEgg == eggName and slotID ~= tostring(incubatorSlot) then
                charData.astralIncubators[slotID] = nil
            end
        end
        if charData.astralIncubators[tostring(incubatorSlot)] ~= eggName then
            charData.astralIncubators[tostring(incubatorSlot)] = eggName
        elseif unequipCheck then
            charData.astralIncubators[tostring(incubatorSlot)] = nil
        end
    end
end

-- Unequip the given egg wherever it is
function PST:unequipIncubatorEgg(eggName)
    local charData = PST:getCurrentCharData()
    if charData and charData.astralIncubators then
        for slotID, slotEgg in pairs(charData.astralIncubators) do
            if slotEgg == eggName then
                charData.astralIncubators[slotID] = nil
            end
        end
    end
end

-- Returns the name of the companion equipped in the given companion slot.
---@param compSlot number|string Incubator slot ID. Falls back to PST.selectedAstralIncubator if not provided
function PST:getEquippedAstralComp(compSlot)
    local charData = PST:getCurrentCharData()
    if charData and charData.astralCompanions then
        return charData.astralCompanions[tostring(compSlot or PST.selectedAstralCompanionSlot)]
    end
    return nil
end

-- Equips the given companion into the provided companion slot
function PST:equipAstralComp(compName, companionSlot, unequipCheck)
    local charData = PST:getCurrentCharData()
    if charData and PST.modData.astralcomps[compName] then
        if not charData.astralCompanions then charData.astralCompanions = {} end

        -- Unequip if companion is present in other slots
        for slotID, slotComp in pairs(charData.astralCompanions) do
            if slotComp == compName and slotID ~= tostring(companionSlot) then
                charData.astralCompanions[slotID] = nil
            end
        end
        if charData.astralCompanions[tostring(companionSlot)] ~= compName then
            charData.astralCompanions[tostring(companionSlot)] = compName
        elseif unequipCheck then
            charData.astralCompanions[tostring(companionSlot)] = nil
        end
    end
end

-- Returns the given egg's total description based on its status
function PST:getCompanionEggDesc(eggName)
    local eggDesc = {}
    local eggData = PST.astralCompanions[eggName]
    if eggData then
        local playerCompData = PST.modData.astralcomps[eggName]
        if playerCompData then
            if not playerCompData.level or playerCompData.level == 0 then
                local eggEquipped = PST:isCompEquipped(eggName, true)
                local objProg = math.min(eggData.objReqs[1], playerCompData.objProg)
                local tmpObjColor = PST.kcolors.LIGHTRED1
                if objProg >= eggData.objReqs[1] then
                    tmpObjColor = PST.kcolors.GREEN1
                elseif eggEquipped then
                    tmpObjColor = PST.kcolors.LIGHTBLUE1
                end
                -- Hatching egg
                table.insert(eggDesc, PST:getLocalized("astralcomp_ui_eggHatchObj") .. ":")
                table.insert(eggDesc, {PST:getLocalized(eggData.identifier .. "_obj"), tmpObjColor})
                table.insert(eggDesc, {PST:getLocalized("ui_Progress") .. ": " .. objProg .. "/" .. eggData.objReqs[1], tmpObjColor})
                -- Hatching status hint
                if not eggEquipped then
                    table.insert(eggDesc, {PST:getLocalized("astralcomp_ui_hatchingPaused"), PST.kcolors.LIGHTRED1})
                elseif objProg < eggData.objReqs[1] then
                    table.insert(eggDesc, {PST:getLocalized("astralcomp_ui_currentlyHatching"), PST.kcolors.LIGHTBLUE1})
                end
            else
                -- Egg already hatched
                table.insert(eggDesc, {PST:getLocalized("astralcomp_ui_hatchComplete"), PST.kcolors.GREEN1})
                table.insert(eggDesc, {PST:getLocalized("astralcomp_ui_eggHatchInto") .. ": " .. PST:getLocalized(eggData.identifier .. "_name"), PST.kcolors.GREEN1})
                table.insert(eggDesc, PST:getLocalized("astralcomp_ui_hatchCompHint"))
            end
        else
            -- Egg not found yet
            table.insert(eggDesc, PST:getLocalized("astralcomp_ui_eggNotFound"))
            table.insert(eggDesc, {PST:getLocalized("astralcomp_ui_locHint") .. ":", PST.kcolors.EXPED_BLUE})
            table.insert(eggDesc, {PST:getLocalized(eggData.identifier .. "_eggHint"), PST.kcolors.EXPED_BLUE})
        end
    end
    return eggDesc
end

-- Returns the given companion's total description
function PST:getAstralCompDesc(compName)
    local compDesc = {}
    local compData = PST.astralCompanions[compName]
    if compData then
        local playerCompData = PST.modData.astralcomps[compName]
        if playerCompData then
            if playerCompData.level > 0 then
                local compEquipped = PST:isCompEquipped(compName)
                -- Level
                table.insert(compDesc, PST:getLocalized("ui_Level") .. " " .. playerCompData.level)

                -- Scavenging info
                local scavengedObols = compData.scavengeRanges[playerCompData.level]
                local scavengedObolsStr = ""
                if type(scavengedObols) == "table" then
                    scavengedObolsStr = scavengedObols[1] .. " - " .. scavengedObols[2]
                else
                    scavengedObolsStr = scavengedObols
                end

                local scavengeFullStr = PST:getLocalizedFormatStr(compData.identifier .. "_scavenge", {
                    obolCount = scavengedObolsStr,
                    floorLimit = compData.scavengeMax and compData.scavengeMax[playerCompData.level] or 0
                })
                if compData.scavengeOdds then
                    scavengeFullStr = scavengeFullStr .. " (" .. compData.scavengeOdds[playerCompData.level] .. "% chance)"
                end
                table.insert(compDesc, {scavengeFullStr, PST.kcolors.EXPED_PURPLE})

                if playerCompData.level < 3 then
                    -- Objective and progress
                    local objProg = math.min(compData.objReqs[playerCompData.level + 1], playerCompData.objProg)
                    local tmpObjColor = PST.kcolors.LIGHTRED1
                    if objProg >= compData.objReqs[playerCompData.level + 1] then
                        tmpObjColor = PST.kcolors.GREEN1
                    elseif compEquipped then
                        tmpObjColor = PST.kcolors.LIGHTBLUE1
                    end
                    table.insert(compDesc, {PST:getLocalized(compData.identifier .. "_obj"), tmpObjColor})
                    table.insert(compDesc, {PST:getLocalized("ui_Progress") .. ": " .. objProg .. "/" .. compData.objReqs[playerCompData.level + 1], tmpObjColor})

                    -- Level 3 effect
                    table.insert(compDesc, "")
                    table.insert(compDesc, {PST:getLocalized("astralcomp_ui_lv3effect") .. ":", PST.kcolors.GRAY1})
                    local effectLines = PST:getLocalized(compData.identifier .. "_maxeffects")
                    if type(effectLines) == "table" then
                        for _, tmpLine in ipairs(effectLines) do
                            table.insert(compDesc, {"  " .. tmpLine, PST.kcolors.GRAY1})
                        end
                    end
                else
                    -- Level 3 effect
                    local effectLines = PST:getLocalized(compData.identifier .. "_maxeffects")
                    if type(effectLines) == "table" then
                        for _, tmpLine in ipairs(effectLines) do
                            table.insert(compDesc, {tmpLine, PST.kcolors.EXPED_BLUE})
                        end
                    end
                end
            else
                table.insert(compDesc, "Hmm... this is not quite right, this is supposed to be an egg.")
            end
        end
    end
    return compDesc
end

-- Add some progress to the given companion if it is equipped
function PST:astralCompAddProgress(eggName, prog)
    if PST:isCompEquipped(eggName) or PST:isCompEquipped(eggName, true) then
        local compData = PST.astralCompanions[eggName]
        local eggData = PST.modData.astralcomps[eggName]
        if compData and eggData and eggData.level < 3 then
            eggData.objProg = math.min(compData.objReqs[eggData.level + 1], eggData.objProg + prog)
        end
    end
end

function PST:astralCompLevelUp(eggName)
    if PST:isCompEquipped(eggName) or PST:isCompEquipped(eggName, true) then
        local compData = PST.modData.astralcomps[eggName]
        if compData and compData.level < 3 then
            compData.objProg = 0
            compData.level = compData.level + 1
        end
    end
end