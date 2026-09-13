include("scripts.astral_companions.ST_astralCompanions_init")

-- Returns whether the given egg is equipped anywhere
function PST:isCompEggEquipped(eggName)
    local charData = PST:getCurrentCharData()
    if charData and charData.astralIncubators then
        for _, equippedEgg in pairs(charData.astralIncubators) do
            if equippedEgg == eggName then
                return true
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

-- Returns the given egg's total description based on its status
function PST:getCompanionEggDesc(eggName)
    local eggDesc = {}
    local eggData = PST.astralCompanions[eggName]
    if eggData then
        local playerCompData = PST.modData.astralcomps[eggName]
        if playerCompData then
            if not playerCompData.level or playerCompData.level == 0 then
                local eggEquipped = PST:isCompEggEquipped(eggName)
                local objProg = math.min(eggData.objReqs[1], playerCompData.objProg)
                local tmpObjColor = PST.kcolors.LIGHTRED1
                if objProg >= eggData.objReqs[1] then
                    tmpObjColor = PST.kcolors.GREEN1
                elseif eggEquipped then
                    tmpObjColor = PST.kcolors.LIGHTBLUE1
                end
                -- Hatching egg
                table.insert(eggDesc, "Egg hatching objective:")
                table.insert(eggDesc, {PST:getLocalized(eggData.identifier .. "_obj"), tmpObjColor})
                table.insert(eggDesc, {"Progress: " .. objProg .. "/" .. eggData.objReqs[1], tmpObjColor})
                -- Hatching status hint
                if not eggEquipped then
                    table.insert(eggDesc, {"Hatching paused. Equip the egg to progress its hatching.", PST.kcolors.LIGHTRED1})
                elseif objProg < eggData.objReqs[1] then
                    table.insert(eggDesc, {"Currently hatching.", PST.kcolors.LIGHTBLUE1})
                end
            else
                -- Egg already hatched
                table.insert(eggDesc, {"Hatching completed!", PST.kcolors.GREEN1})
                table.insert(eggDesc, {"Egg hatched into: " .. PST:getLocalized(eggData.identifier .. "_name"), PST.kcolors.GREEN1})
                table.insert(eggDesc, "You may now equip the hatched companion in one of the Companion Slot nodes to the right.")
            end
        else
            -- Egg not found yet
            table.insert(eggDesc, "Egg not found yet.")
            table.insert(eggDesc, {"Location hint:", PST.kcolors.EXPED_BLUE})
            table.insert(eggDesc, {PST:getLocalized(eggData.identifier .. "_eggHint"), PST.kcolors.EXPED_BLUE})
        end
    end
    return eggDesc
end

-- Add some progress to the given egg if it is equipped
function PST:astralEggAddProgress(eggName, prog)
    if PST:isCompEggEquipped(eggName) then
        local compData = PST.astralCompanions[eggName]
        local eggData = PST.modData.astralcomps[eggName]
        if compData and eggData and eggData.level < 3 then
            eggData.objProg = math.min(compData.objReqs[eggData.level + 1], eggData.objProg + prog)
        end
    end
end

function PST:astralCompLevelUp(eggName)
    if PST:isCompEggEquipped(eggName) then
        local eggData = PST.modData.astralcomps[eggName]
        if eggData and eggData.level < 3 then
            eggData.objProg = 0
            eggData.level = eggData.level + 1
        end
    end
end