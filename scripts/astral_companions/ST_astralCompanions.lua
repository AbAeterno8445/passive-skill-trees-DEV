include("scripts.astral_companions.ST_astralCompanions_init")

function PST:getCompScavengeMax()
    return 2000
end

-- Modify the given floor limit based on reached expedition depths
function PST:astralCompModFloorLimit(baseLimit)
    local depthFactor = math.max(0.1, (PST.modData.expeditionDepth + (PST.modData.uberExpedDepth - 1) * 2) / 30)
    local newLimit = math.floor(baseLimit * depthFactor)
    return math.max(1, newLimit)
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

-- Returns the slot the given companion is equipped in for the current character, or 0 if unequipped
function PST:getCompSlot(compName)
    local charData = PST:getCurrentCharData()
    if charData and charData.astralCompanions then
        for i=1,3 do
            if charData.astralCompanions[tostring(i)] == compName then
                return i
            end
        end
    end
    return 0
end

-- Returns whether the given companion slot is available considering the current floor in the run
function PST:isCompSlotAvailable(slot)
    if slot == 3 then return true end

    if Isaac.IsInGame() then
        local lvlStage = PST:getLevel():GetStage()
        for i, tmpSlot in ipairs(PST.astralCompSlotFloors) do
            if i == slot and lvlStage >= tmpSlot[1] and lvlStage <= tmpSlot[2] then
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

-- Returns all obtained companions above level 0 (hatched)
function PST:getHatchedCompanions()
    local hatchedComps = {}
    for _, tmpComp in ipairs(PST.astralCompanionsOrdered) do
        local compData = PST.modData.astralcomps[tmpComp]
        if compData and compData.level > 0 then
            table.insert(hatchedComps, tmpComp)
        end
    end
    return hatchedComps
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

                local scavengeLevelOdds = 0
                if compData.scavengeOdds and compData.scavengeOdds[playerCompData.level] then
                    scavengeLevelOdds = compData.scavengeOdds[playerCompData.level]
                end

                local scavengeFullStr = PST:getLocalizedFormatStr(compData.identifier .. "_scavenge", {
                    scavChance = scavengeLevelOdds,
                    obolCount = scavengedObolsStr,
                    floorLimit = PST:astralCompModFloorLimit(compData.scavengeMax and compData.scavengeMax[playerCompData.level] or 0)
                })
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
                table.insert(compDesc, {"Hmm... this is not quite right, this is supposed to be an egg.", PST.kcolors.ANCIENT_ORANGE})
            end
        end
    end
    return compDesc
end

-- Add some progress to the given companion if it is equipped
function PST:astralCompAddProgress(eggName, prog)
    if not PST:isRunSidereal() then return end

    if PST:isCompEquipped(eggName) or PST:isCompEquipped(eggName, true) then
        local compData = PST.astralCompanions[eggName]
        local eggData = PST.modData.astralcomps[eggName]
        if compData and eggData and eggData.level < 3 then
            eggData.objProg = math.min(compData.objReqs[eggData.level + 1], eggData.objProg + prog)
        end
    end
end

function PST:astralCompLevelUp(eggName)
    local compData = PST.modData.astralcomps[eggName]
    if compData and compData.level < 3 then
        compData.objProg = 0
        compData.level = compData.level + 1
    end
end

-- Scavenge obols in the given slot for the current character
function PST:astralCompScavengeObolsInSlot(compSlot, obols, checkSlot)
    local scavengedSlot = tostring(compSlot)
    local charData = PST:getCurrentCharData()
    if charData then
        if not charData.scavengedObols then charData.scavengedObols = {} end
        if not charData.scavengedObols[scavengedSlot] then
            charData.scavengedObols[scavengedSlot] = 0
        end
        local curStage = PST:getLevel():GetStage()
        if not checkSlot or compSlot < 3 or (checkSlot and PST.astralCompSlotFloors[compSlot] and
        curStage >= PST.astralCompSlotFloors[compSlot][1] and curStage <= PST.astralCompSlotFloors[compSlot][2]) then
            charData.scavengedObols[scavengedSlot] = math.min(PST:getCompScavengeMax(), charData.scavengedObols[scavengedSlot] + obols)
        end
    end
end

-- Attempt to scavenge obols for the given companion, checking if it is equipped, its level, floor limits and proc odds
function PST:astralCompProcScavenge(compName, chanceMult, obolMod, obolMult)
    if not PST:isRunSidereal() then return end

    local charData = PST:getCurrentCharData()
    local baseCompData = PST.astralCompanions[compName]
    local compData = PST.modData.astralcomps[compName]
    if charData and charData.astralCompanions and PST:isCompSlotAvailable(PST:getCompSlot(compName)) and baseCompData and
    compData and compData.level > 0 then
        local floorLimit = PST:astralCompModFloorLimit(baseCompData.scavengeMax and baseCompData.scavengeMax[compData.level] or 0)
        if floorLimit == 0 or (floorLimit > 0 and PST:getTreeSnapshotMod("astralCompFloorProcs_" .. compName, 0) < floorLimit) then
            local procOdds = baseCompData.scavengeOdds and baseCompData.scavengeOdds[compData.level] or nil
            if not procOdds or (procOdds and 100 * math.random() < procOdds * (chanceMult or 1)) then
                local scavengedObolsBase = baseCompData.scavengeRanges[compData.level]
                local scavengedObols = 0
                if type(scavengedObolsBase) == "table" then
                    scavengedObols = math.random(scavengedObolsBase[1], scavengedObolsBase[2])
                else
                    scavengedObols = scavengedObolsBase
                end
                if obolMult then scavengedObols = math.floor(scavengedObols * obolMult) end
                if obolMod then scavengedObols = scavengedObols + obolMod end
                for i=1,3 do
                    if charData.astralCompanions[tostring(i)] == compName then
                        -- Special scavenge case: Gilded Golem
                        if compName == "gildedGolem" then
                            local tmpDiff = math.min(obolMod, floorLimit - PST:getTreeSnapshotMod("astralCompFloorProcs_" .. compName, 0))
                            PST:astralCompScavengeObolsInSlot(i, tmpDiff, true)
                            PST:addModifiers({ ["astralCompFloorProcs_" .. compName] = tmpDiff }, true)
                        else
                            PST:astralCompScavengeObolsInSlot(i, scavengedObols, true)
                            PST:addModifiers({ ["astralCompFloorProcs_" .. compName] = 1 }, true)
                        end
                        break
                    end
                end

                -- Companion icon flash
                if PST:getTreeSnapshotMod("astralCompanionShowProc", false) then
                    local tmpSprite = PST.treeScreen.modules.submenusModule.submenus[PSTSubmenu.ASTRAL_COMPANION_SLOT].compSprite
                    tmpSprite:SetFrame("Default", baseCompData.compSprite)
                    PST:createFloatIconFX(tmpSprite, Vector(0, -8), 0.05, 30, true)
                end
            end
        end
    end
end

-- Attempts to unlock the given egg, considering the run's total egg find chance and the egg's rate
function PST:astralCompEggUnlockProc(eggName)
    if not PST:isRunSidereal() or not PST:getTreeSnapshotMod("astralCompanions", false) then return end

    local eggChance = PST:getTreeSnapshotMod("astralCompEggChance", 0)
    local eggData = PST.astralCompanions[eggName]
    if not PST.modData.astralcomps[eggName] and eggData and 100 * math.random() < eggChance * ((eggData.eggRate or 100) / 100) then
        PST.modData.astralcomps[eggName] = { level = 0, objProg = 0 }
        PST:createFloatTextFX(PST:getLocalized("astralcomp_foundEgg") .. ": " .. PST:getLocalized(eggData.identifier .. "_eggname"), Vector.Zero, Color(0.35, 0.9, 0.35), 0.12, 120, true)
        SFXManager():Play(SoundEffect.SOUND_THUMBSUP, 0.9)
        PST:addModifiers({ astralCompEggChance = eggChance / -2 }, true)

        -- Egg icon
        local tmpSprite = PST.treeScreen.modules.submenusModule.submenus[PSTSubmenu.ASTRAL_INCUBATOR].eggSprite
        tmpSprite:SetFrame("Eggs", eggData.compSprite)
        PST:createFloatIconFX(tmpSprite, Vector(0, -24), 0.12, 120, true, true)
    end
end