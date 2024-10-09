include("scripts.starcursed_data.ST_starcursed_init")

---@enum PSTStarcursedType
PSTStarcursedType = {
    AZURE = "Azure",
    CRIMSON = "Crimson",
    VIRIDIAN = "Viridian",
    ANCIENT = "Ancient"
}

-- Adds an unidentified starcursed jewel with the given properties to the Star Tree inventory
---@param jewelType PSTStarcursedType Jewel type
function PST:SC_addJewel(jewelType, isMighty, fading)
    local newJewel = {
        type = jewelType,
        unidentified = true,
        mods = {},
        fading = fading or nil,
        mighty = isMighty or nil,
        starmight = 0
    }
    table.insert(PST.modData.starTreeInventory[jewelType], newJewel)
    return newJewel
end

-- Return whether the given jewel type's inventory is full
---@param jewelType PSTStarcursedType
function PST:SC_isInvFull(jewelType)
    if not PST.modData.starTreeInventory[jewelType] then return true end
    return #PST.modData.starTreeInventory[jewelType] >= PST.SCMaxInv
end

function PST:SC_identifiedAllAncients()
    for ancientID, _ in pairs(PST.SCAncients) do
        if not PST.modData.identifiedAncients[ancientID] then
            return false
        end
    end
    return true
end

local nonAncient = {PSTStarcursedType.AZURE, PSTStarcursedType.CRIMSON, PSTStarcursedType.VIRIDIAN}
function PST:SC_getRandomJewelType()
    return nonAncient[math.random(#nonAncient)]
end

function PST:SC_dropRandomJewelAt(position, ancientChance)
    if not PST:getTreeSnapshotMod("enableSCJewels", false) then return end

    local ancientChanceModded = ancientChance + PST:getTreeSnapshotMod("SC_SMAncientChance", 0)
    if PST:SC_identifiedAllAncients() then
        ancientChanceModded = ancientChanceModded / 5
    end

    local newJewelType = Isaac.GetTrinketIdByName(PST:SC_getRandomJewelType() .. " Starcursed Jewel")
    if ancientChanceModded > 0 and 100 * math.random() < ancientChanceModded then
        newJewelType = Isaac.GetTrinketIdByName(PSTStarcursedType.ANCIENT .. " Starcursed Jewel")
    end
    if newJewelType ~= -1 then
        local tmpPos = Isaac.GetFreeNearPosition(position, 40)
        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, newJewelType, Random() + 1)
    end
end

-- Generate a table with description lines for the given jewel, based on its type and mods
function PST:SC_getJewelDescription(jewel)
    local tmpDescription = {}
    if not jewel.unidentified then
        if jewel.type ~= PSTStarcursedType.ANCIENT then
            for modName, modData in pairs(jewel.mods) do
                if PST.SCMods[jewel.type] and PST.SCMods[jewel.type][modName] then
                    local modDescription = PST.SCMods[jewel.type][modName].description
                    if modDescription then
                        table.insert(tmpDescription, {
                            string.format(modDescription, table.unpack(modData.rolls)), KColor(0.88, 1, 1, 1)
                        })
                    end
                end
            end
        else
            local tmpAncient = nil
            -- Try to fetch original ancient data first, else use gem's
            if jewel.name then
                for _, ancient in pairs(PST.SCAncients) do
                    if ancient.name == jewel.name then
                        tmpAncient = ancient
                        break
                    end
                end
            end
            if not tmpAncient then
                tmpAncient = jewel
            end
            if tmpAncient.description then
                local targetDesc = tmpAncient.description
                if jewel.name == "Cause Converter" and jewel.status == "converted" then
                    targetDesc = tmpAncient.descriptionConverted
                end
                for _, tmpLine in ipairs(targetDesc) do
                    table.insert(tmpDescription, {tmpLine, KColor(1, 0.7, 0.3, 1)})
                end
            end
            if jewel.converted ~= nil then
                local bossEnt = EntityConfig.GetEntity(jewel.converted, jewel.convertedVariant or 0, 0)
                if bossEnt then
                    local bossName = Isaac.GetLocalizedString("Entities", bossEnt:GetName(), "en")
                    if bossName == "StringTable::InvalidKey" then
                        bossName = bossEnt:GetName()
                    end
                    table.insert(tmpDescription, {"Converted boss: " .. bossName, KColor(1, 1, 0.7, 1)})
                end
            end
            if tmpAncient.rewards then
                if not (jewel.name == "Cause Converter" and jewel.status == "seeking") then
                    for _, tmpRewardMod in ipairs(PST.SCAncientRewardsSorted) do
                        local tmpRewardModVal = tmpAncient.rewards[tmpRewardMod]
                        if PST.SCMods[tmpRewardMod] ~= nil and tmpRewardModVal then
                            local tmpColor = KColor(0.5, 0.9, 1, 1)
                            local descStr
                            if type(tmpRewardModVal) == "table" then
                                ---@diagnostic disable-next-line: param-type-mismatch
                                descStr = string.format(PST.SCMods[tmpRewardMod], table.unpack(tmpRewardModVal))
                            else
                                ---@diagnostic disable-next-line: param-type-mismatch
                                descStr = string.format(PST.SCMods[tmpRewardMod], tmpRewardModVal)
                            end
                            if tmpAncient.name then
                                if PST.modData.ancientRewards[tmpAncient.name] and PST.modData.ancientRewards[tmpAncient.name][tmpRewardMod] then
                                    descStr = descStr .. " (Done)"
                                    tmpColor = KColor(1, 0.9, 0.5, 1)
                                end
                            end
                            table.insert(tmpDescription, {descStr, tmpColor})
                        end
                    end
                end
            end
        end
        if jewel.starmight ~= 0 then
            table.insert(tmpDescription, {"Starmight: " .. tostring(jewel.starmight), KColor(1, 0.75, 0, 1)})
        end
    else
        table.insert(tmpDescription, {"Unidentified. Press E to identify and reveal modifiers.", KColor(1, 0.7, 0.7, 1)})
    end
    return tmpDescription
end

-- Get the socketed jewel of the given type at the given socket
---@param jewelType PSTStarcursedType
---@param socketID string
function PST:SC_getSocketedJewel(jewelType, socketID)
    if not PST.modData.starTreeInventory[jewelType] then return nil end

    for _, jewel in ipairs(PST.modData.starTreeInventory[jewelType]) do
        if jewel.equipped == socketID then
            return jewel
        end
    end
    return nil
end

function PST:SC_getSocketedAncient(ancientName)
    for i=1,2 do
        local tmpJewel = PST:SC_getSocketedJewel(PSTStarcursedType.ANCIENT, tostring(i))
        if tmpJewel and tmpJewel.name == ancientName then
            return tmpJewel
        end
    end
    return nil
end

-- Add a single random modifier to a jewel, based on rollable modifiers for its type
---@param jewel any Jewel originally created with PST:SC_addJewel.
---@param exclusive? boolean Whether to check if rolled mod is already on the jewel.
function PST:SC_addRandModToJewel(jewel, exclusive)
    if not PST.SCMods[jewel.type] then return end

    local totalWeight = 0
    local availableMods = 0
    for mod, modData in pairs(PST.SCMods[jewel.type]) do
        if (jewel.mods[mod] == nil or not exclusive) and not modData.disabled and (not modData.mightyOnly or (modData.mightyOnly and jewel.mighty)) then
            totalWeight = totalWeight + modData.weight
            availableMods = availableMods + 1
        end
    end
    -- No more rollable mods
    if availableMods == 0 and not exclusive then
        return
    end

    local tmpWeight = math.random(totalWeight)
    local failsafe = 0
    while tmpWeight > 0 and failsafe < 1000 do
        for mod, modData in pairs(PST.SCMods[jewel.type]) do
            if not modData.disabled and not modData.mightyOnly or (modData.mightyOnly and jewel.mighty) then
                tmpWeight = tmpWeight - modData.weight
            end
            if tmpWeight <= 0 then
                -- Check if rolled mod is already in jewel, restart rolling if so
                if exclusive then
                    for oldMod, _ in pairs(jewel.mods) do
                        if mod == oldMod then
                            tmpWeight = math.random(totalWeight)
                            break
                        end
                    end
                    if tmpWeight > 0 then break end
                end
                local jewelData = PST.SCMods[jewel.type][mod]

                jewel.mods[mod] = {}
                local tmpRolls = {}
                local rollTable = jewelData.rolls
                if jewel.mighty and not modData.mightyOnly then
                    rollTable = jewelData.mightyRolls
                end
                for _, rollRange in ipairs(rollTable) do
                    if type(rollRange) == "table" then
                        local roll
                        if math.type(rollRange[1]) == "integer" and math.type(rollRange[2]) == "integer" then
                            roll = rollRange[1] + math.random(math.max(0, math.abs(rollRange[2] - rollRange[1] + 1) - 1))
                        else
                            roll = PST:roundFloat(rollRange[1] + math.abs(rollRange[2] - rollRange[1]) * math.random(), -2)
                        end
                        table.insert(tmpRolls, roll)
                    else
                        table.insert(tmpRolls, rollRange)
                    end
                end

                jewel.starmight = jewel.starmight + math.ceil(jewelData.starmightCalc(table.unpack(tmpRolls)))
                jewel.mods[mod].rolls = tmpRolls
                break
            else
                failsafe = failsafe + 1
            end
        end
    end
    if failsafe >= 1000 then
        Console.PrintWarning("Passive Skill Trees: warning, reached failsafe while identifying jewel!")
    end
end

function PST:SC_getNewAncient()
    local totalWeight = 0
    local availableAncients = 0
    for ancientID, ancientData in pairs(PST.SCAncients) do
        local identifiedVer = PST.modData.identifiedAncients[ancientID]
        if not identifiedVer then
            totalWeight = totalWeight + ancientData.weight
            availableAncients = availableAncients + 1
        end
    end
    if availableAncients == 0 then return nil end

    local tmpWeight = math.random(totalWeight)
    for ancientID, ancientData in pairs(PST.SCAncients) do
        local identifiedVer = PST.modData.identifiedAncients[ancientID]
        if not identifiedVer then
            tmpWeight = tmpWeight - ancientData.weight
            if tmpWeight <= 0 then
                PST.modData.identifiedAncients[ancientID] = true
                return ancientData
            end
        end
    end
end

function PST:SC_getAncientByName(ancientName)
    for _, tmpAncientData in pairs(PST.SCAncients) do
        if tmpAncientData.name == ancientName then
            return tmpAncientData
        end
    end
    return nil
end

function PST:SC_setSpriteToJewel(sprite, jewel)
    if jewel.type ~= PSTStarcursedType.ANCIENT then
        sprite:Play(jewel.type)
    elseif not jewel.unidentified then
        local found = false
        for _, tmpAncient in pairs(PST.SCAncients) do
            if tmpAncient.name == jewel.name then
                sprite:SetFrame("Ancients", tmpAncient.spriteFrame)
                found = true
            end
        end
        if not found and jewel.spriteFrame then
            sprite:SetFrame("Ancients", jewel.spriteFrame)
        end
    else
        sprite:Play("AncientUnid")
    end
end

function PST:SC_identifyJewel(jewel)
    if not jewel.unidentified then
        return false
    end

    if jewel.type ~= PSTStarcursedType.ANCIENT then
        local maxMods = 2
        if 100 * math.random() < 10 then
            maxMods = 3
        end
        for _=1,maxMods do
            PST:SC_addRandModToJewel(jewel, true)
        end
    else
        local newAncient = PST:SC_getNewAncient()
        if newAncient then
            jewel.name = newAncient.name
            if newAncient.name == "Cause Converter" then
                jewel.status = "seeking"
            end
        else
            jewel.name = "Faded Starpiece"
            jewel.description = {"This jewel's energy has almost faded out..."}
            jewel.fading = 3
            jewel.starmight = 20 + math.random(41) - 1
            jewel.spriteFrame = 10
        end
    end

    jewel.unidentified = nil
    return true
end

-- Generate a list of total modifiers from all equipped jewels
-- Returns a table { totalMods, totalStarmight }
function PST:SC_getTotalJewelMods()
    local tmpMods = {}
    local tmpStarmight = 0
    for _, tmpType in pairs(PSTStarcursedType) do
        local typeSocketedTotal = 0
        for _, jewel in ipairs(PST.modData.starTreeInventory[tmpType]) do
            -- Equipped jewel
            if jewel.equipped ~= nil then
                typeSocketedTotal = typeSocketedTotal + 1

                if jewel.type ~= PSTStarcursedType.ANCIENT then
                    -- Get mods and handle mod conflicts (identical mods)
                    for mod, modData in pairs(jewel.mods) do
                        if tmpMods[mod] == nil then
                            tmpMods[mod] = { rolls = {} }
                            for _, tmpRoll in ipairs(modData.rolls) do
                                table.insert(tmpMods[mod].rolls, tmpRoll)
                            end
                        else
                            for i, tmpRoll in ipairs(modData.rolls) do
                                local conflictFunc = PST.SCMods[tmpType][mod].onConflict[i]
                                if conflictFunc then
                                    tmpMods[mod].rolls[i] = conflictFunc(tmpRoll, tmpMods[mod].rolls[i])
                                end
                            end
                        end
                        tmpMods[mod].description = string.format(PST.SCMods[tmpType][mod].description, table.unpack(tmpMods[mod].rolls))
                    end
                -- Add ancient jewels as mods, using their keys from PST.SCAncients, set to true
                elseif jewel.name then
                    for ancientModName, ancientData in pairs(PST.SCAncients) do
                        if jewel.name == ancientData.name then
                            tmpMods[ancientModName] = true
                            break
                        end
                    end
                end
                tmpStarmight = tmpStarmight + jewel.starmight
            end
        end

        -- Mod: +starmight per socketed jewel for each type
        local tmpStarmightMods = {}
        for nodeID, _ in pairs(PST.modData.treeNodes["starTree"]) do
            if PST:isNodeAllocated("starTree", nodeID) then
                for modName, modVal in pairs(PST.trees["starTree"][nodeID].modifiers) do
                    if modName == "azureStarmight" or modName == "crimsonStarmight" or modName == "viridianStarmight" or modName == "ancientStarmight" then
                        if tmpStarmightMods[modName] == nil then
                            tmpStarmightMods[modName] = modVal
                        else
                            tmpStarmightMods[modName] = tmpStarmightMods[modName] + modVal
                        end
                    end
                end
            end
        end

        if tmpType == PSTStarcursedType.AZURE then
            tmpStarmight = tmpStarmight + typeSocketedTotal * (tmpStarmightMods.azureStarmight or 0)
        elseif tmpType == PSTStarcursedType.CRIMSON then
            tmpStarmight = tmpStarmight + typeSocketedTotal * (tmpStarmightMods.crimsonStarmight or 0)
        elseif tmpType == PSTStarcursedType.VIRIDIAN then
            tmpStarmight = tmpStarmight + typeSocketedTotal * (tmpStarmightMods.viridianStarmight or 0)
        elseif tmpType == PSTStarcursedType.ANCIENT then
            tmpStarmight = tmpStarmight + typeSocketedTotal * (tmpStarmightMods.ancientStarmight or 0)
        end
    end
    return { totalMods = tmpMods, totalStarmight = tmpStarmight }
end

function PST:SC_equipJewel(jewel, socketID)
    local oldJewel = PST:SC_getSocketedJewel(jewel.type, socketID)
    if oldJewel then
        oldJewel.equipped = nil
    end
    jewel.equipped = socketID
end

function PST:SC_canDestroyJewel(jewel)
    if not jewel.type then return true end
    if jewel.unidentified or jewel.equipped then return false end

    if jewel.type == PSTStarcursedType.ANCIENT then
        if jewel.name == "Faded Starpiece" then
            return true
        else
            -- Allow destruction of old ancients no longer in use
            local inUse = false
            for _, tmpAncient in pairs(PST.SCAncients) do
                if jewel.name == tmpAncient.name then
                    inUse = true
                    break
                end
            end
            return not inUse
        end
    end
    return true
end

function PST:SC_sortInventory(jewelType)
    if not PST.modData.starTreeInventory[jewelType] then return end

    table.sort(PST.modData.starTreeInventory[jewelType], function(a, b)
        if a.equipped ~= nil and b.equipped == nil then return true
        elseif not a.unidentified and b.unidentified then return true end
        if not a.unidentified and not a.equipped and not b.unidentified and not b.equipped then
            return a.starmight > b.starmight and b.starmight <= a.starmight
        end
        return false
    end)
end

-- Implicit modifiers granted by having starmight
function PST:SC_getStarmightImplicits(starmight)
    local diminishedSM = 0
    local diminishKickoff = 300
    if starmight >= diminishKickoff then
        diminishedSM = (starmight - diminishKickoff) ^ 0.67
    end
    local tmpImplicits = {
        xpgain = math.ceil(math.min(diminishKickoff, starmight) / 2.7) + diminishedSM
    }
    if starmight >= 50 then
        tmpImplicits["SC_SMMightyChance"] = math.min(15, 2 + starmight / 20)
    end
    if starmight >= 100 then
        tmpImplicits["SC_SMAncientChance"] = starmight / 90
    end
    return tmpImplicits
end

function PST:SC_isStarTreeUnlocked()
    if PST.debugOptions.allAvailable then return true end

    -- Character level requirement to unlock star tree
    for _, charData in pairs(PST.modData.charData) do
        if charData.level >= PST.SCStarTreeUnlockLevel then
            return true
        end
    end
    return false
end

-- Get starcursed mod from current run snapshot.
-- Mods with a single roll return it directly. Mods that feature multiple rolls return a table {roll1, roll2, ...}
function PST:SC_getSnapshotMod(modName, default)
    local starcursedMods = PST:getTreeSnapshotMod("starcursedMods", nil)
    -- Disable starcursed modifiers in mineshaft puzzle
    if PST:inMineshaftPuzzle() then
        -- Exceptions
        if modName ~= "chroniclerStone" then
            return default
        end
    end
    if starcursedMods then
        if starcursedMods[modName] == nil then return default end
        if type(starcursedMods[modName]) == "table" then
            if #starcursedMods[modName].rolls == 1 then
                return starcursedMods[modName].rolls[1]
            end
            return starcursedMods[modName].rolls
        else
            return starcursedMods[modName]
        end
    end
    return default
end

function PST:SC_debugAddMod(modName, value)
    if not PST.modData.treeModSnapshot.starcursedMods then
        PST.modData.treeModSnapshot.starcursedMods = {}
    end
    PST.modData.treeModSnapshot.starcursedMods[modName] = value
end

-- Replace all instances of an old modifier in all inventory jewels to a new one.
---@param oldMod string Old modifier key
---@param newMod? string | nil New modifier key, leave as nil to remove old modifiers
function PST:replaceAllJewelMods(oldMod, newMod)
    for _, invJewels in pairs(PST.modData.starTreeInventory) do
        for _, tmpJewel in ipairs(invJewels) do
            if tmpJewel.mods and tmpJewel.mods[oldMod] then
                if newMod ~= nil then
                    tmpJewel.mods[newMod] = tmpJewel.mods[oldMod]
                end
                tmpJewel.mods[oldMod] = nil
            end
        end
    end
end

-- Replace old unwanted mods from all jewels with new versions
function PST:oldJewelReplacements()
    PST:replaceAllJewelMods("pickupsVanish", "pickupScarcity")
    PST:replaceAllJewelMods("heartsVanish", "heartScarcity")

    -- Remove old data from all jewels
    for jewelType, jewelInv in pairs(PST.modData.starTreeInventory) do
        for _, tmpJewel in ipairs(jewelInv) do
            tmpJewel.fading = nil
            if tmpJewel.mighty == false then
                tmpJewel.mighty = nil
            end
            if tmpJewel.unidentified == false then
                tmpJewel.unidentified = nil
            end
            if tmpJewel.mods then
                for _, tmpMod in pairs(tmpJewel.mods) do
                    tmpMod.description = nil
                end
            end

            -- Remove old data from Ancient jewels
            if jewelType == PSTStarcursedType.ANCIENT then
                tmpJewel.description = nil
                tmpJewel.rewards = nil
                if tmpJewel.name ~= "Faded Starpiece" then
                    tmpJewel.spriteFrame = nil
                else
                    tmpJewel.spriteFrame = 10
                end
                if tmpJewel.mods and #tmpJewel.mods == 0 then
                    tmpJewel.mods = nil
                end
            end
        end
    end
end

function PST:SC_wipeInventories()
    PST.modData.starTreeInventory = {
        Crimson = {},
        Azure = {},
        Viridian = {},
        Ancient = {}
    }
    for ancientID, _ in pairs(PST.modData.identifiedAncients) do
        PST.modData.identifiedAncients[ancientID] = nil
    end
    PST:save()
end