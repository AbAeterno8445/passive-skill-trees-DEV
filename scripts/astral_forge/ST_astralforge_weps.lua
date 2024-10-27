include("scripts.astral_forge.ST_astralforge_init")

function PST:astralWepRoundRolls(modRolls)
    local newModRolls = {}
    for i=1,5 do
        local tmpRoll = modRolls["roll" .. tostring(i)]
        if tmpRoll then
            if math.type(tmpRoll) == "float" then
                table.insert(newModRolls, PST:roundFloat(tmpRoll, -2))
            else
                table.insert(newModRolls, tmpRoll)
            end
        else break end
    end
    return newModRolls
end

function PST:astralWepPickRandType(factorMods)
    local typeWeights = {}
    local totalWeight = 0
    for _, tmpType in pairs(PSTAstralWepType) do
        typeWeights[tmpType] = 100
        if factorMods then
            local tmpMod = PST:getTreeSnapshotMod("astralWepRate" .. PST.astralWepData[tmpType].name, 0)
            typeWeights[tmpType] = typeWeights[tmpType] + tmpMod
        end
        totalWeight = totalWeight + typeWeights[tmpType]
    end

    local randWeight = math.random(totalWeight)
    for tmpType, typeWeight in pairs(typeWeights) do
        randWeight = randWeight - typeWeight
        if randWeight <= 0 then
            return tmpType
        end
    end

    -- Shouldn't reach this point but just in case
    return PSTAstralWepType.LONGSWORD
end

---@param weaponData PSTAstralWeapon
function PST:astralWepAddMod(weaponData)
    local existingMods = {}
    if not weaponData.mods then
        weaponData.mods = {}
    else
        for _, tmpMod in ipairs(weaponData.mods) do
            table.insert(existingMods, tmpMod.name)
        end
    end

    local tmpModList = {}
    for tmpModName, tmpMod in pairs(PST.astralWepMods) do
        if not PST:arrHasValue(existingMods, tmpModName) and not tmpMod.ancient then
            table.insert(tmpModList, tmpModName)
        end
    end

    local newModName = tmpModList[math.random(#tmpModList)]

    -- Percentages for every potential roll in the mod
    local rollPercs = {math.random(), math.random(), math.random(), math.random(), math.random()}
    local modRolls = PST.astralWepMods[newModName].rollsFunc(weaponData.tier, rollPercs)
    local newModRolls = PST:astralWepRoundRolls(modRolls)

    table.insert(weaponData.mods, {
        name = newModName,
        rolls = newModRolls
    })
end

---@param wepType PSTAstralWepType
function PST:createAstralWep(wepType, wepRarity, wepTier, ancientID)
    ---@type PSTAstralWeapon
    local newWep = {type = wepType, rarity = wepRarity, tier = wepTier or 1}

    local wepTypeData = PST.astralWepData[wepType]
    -- Assign implicit modifier
    local impRolls = wepTypeData.implicitMod.rollsFunc(0)
    local newImpRolls = {}
    for i=1,5 do
        local tmpRoll = impRolls["roll" .. tostring(i)]
        if tmpRoll then
            table.insert(newImpRolls, tmpRoll)
        end
    end
    newWep.implicitMod = newImpRolls

    -- Magic weapon, generate modifiers
    if wepRarity == PSTAstralWepRarity.MAGIC then
        PST:astralWepAddMod(newWep)

        local extraModChance = 0.4 + 0.02 * newWep.tier
        if math.random() < extraModChance then
            PST:astralWepAddMod(newWep)
        end
    -- Ancient weapon, pick random one from type if not provided
    elseif wepRarity == PSTAstralWepRarity.ANCIENT and not ancientID then
        local totalWeight = 0
        for _, tmpAncient in ipairs(wepTypeData.ancients) do
            totalWeight = totalWeight + tmpAncient.weight
        end
        local randWeight = math.random(totalWeight)
        for i, tmpAncient in ipairs(wepTypeData.ancients) do
            randWeight = randWeight - tmpAncient.weight
            if randWeight <= 0 then
                newWep.ancientID = i
                break
            end
        end
    end

    return newWep
end

---@param factorMods boolean Whether to factor in tree modifiers that affect chances for weapon rarity and such
function PST:generateAstralWep(wepTier, factorMods)
    local wepType = PST:astralWepPickRandType(factorMods)
    local wepData = PST.astralWepData[wepType]
    local wepRarity = PSTAstralWepRarity.NORMAL

    -- Roll for ancient/magic weapon
    local magicChance = 0.12
    local ancientChance = 0.01
    if factorMods then
        magicChance = magicChance + PST:getTreeSnapshotMod("astralWepMagicRate", 0) / 100
        ancientChance = ancientChance + PST:getTreeSnapshotMod("astralWepAncientRate", 0) / 100
    end
    if math.random() < ancientChance and #wepData.ancients > 0 then
        wepRarity = PSTAstralWepRarity.ANCIENT
    elseif math.random() < magicChance then
        wepRarity = PSTAstralWepRarity.MAGIC
    end

    return PST:createAstralWep(wepType, wepRarity, wepTier)
end

function PST:dropRandAstralWepAt(position, wepTier, factorMods)
    local newWep = PST:generateAstralWep(wepTier, factorMods)
    local wepData = PST.astralWepData[newWep.type]

    -- Form trinket name for new weapon
    local tmpTrinketName = "Astral weapon: "
    if newWep.rarity ~= PSTAstralWepRarity.ANCIENT then
        tmpTrinketName = tmpTrinketName .. wepData.name
        if newWep.rarity == PSTAstralWepRarity.MAGIC then
            tmpTrinketName = tmpTrinketName .. " (magic)"
        end
    elseif newWep.ancientID then
        tmpTrinketName = tmpTrinketName .. wepData.ancients[newWep.ancientID].name
    end

    local tmpTrinketID = Isaac.GetTrinketIdByName(tmpTrinketName)
    if tmpTrinketID ~= -1 then
        local tmpPos = PST:getRoom():FindFreePickupSpawnPosition(position, 40)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpTrinketID, tmpPos, Vector.Zero, nil)
    end
end

-- Astral weapon trinket picked up - add corresponding weapon to player inventory
function PST:astralWepTrinketPickup(trinketName)
    local wepType = nil
    local wepRarity = PSTAstralWepRarity.NORMAL
    local wepTier = PST:getTreeSnapshotMod("astralWepTierDrops", 1)
    local ancientID = nil

    local preStr = "Astral weapon: "
    for tmpType, wepData in pairs(PST.astralWepData) do
        local wepName = preStr .. wepData.name
        if trinketName == wepName then
            wepType = tmpType
            break
        elseif trinketName == wepName .. " (magic)" then
            wepType = tmpType
            wepRarity = PSTAstralWepRarity.MAGIC
            break
        else
            -- Check for ancients
            for i, tmpAncient in ipairs(wepData.ancients) do
                if trinketName == preStr .. tmpAncient.name then
                    wepType = tmpType
                    wepRarity = PSTAstralWepRarity.ANCIENT
                    ancientID = i
                    break
                end
            end
        end
    end

    if wepType then
        local newWep = PST:createAstralWep(wepType, wepRarity, wepTier, ancientID)
        table.insert(PST.modData.astralWepInventory, newWep)
    end
end

local wepTierTxt = {"I", "II", "III", "IV", "V"}
---@param weaponData PSTAstralWeapon
---@param showModRanges? boolean
function PST:getAstralWepDesc(weaponData, showModRanges)
    local wepTypeData = PST.astralWepData[weaponData.type]
    local tmpDescription = {}

    -- Ancient name
    if weaponData.ancientID ~= nil and wepTypeData.ancients[weaponData.ancientID] then
        table.insert(tmpDescription, {wepTypeData.ancients[weaponData.ancientID].name, PST:RGBKColor(255, 172, 28)})
    end

    -- Rarity + type
    local tmpColor = KColor(1, 1, 1, 1)
    local tmpRarity = "Normal"
    if weaponData.rarity == PSTAstralWepRarity.MAGIC then
        tmpColor = KColor(0.7, 0.7, 1, 1)
        tmpRarity = "Magic"
    elseif weaponData.rarity == PSTAstralWepRarity.ANCIENT then
        tmpColor = PST:RGBKColor(255, 172, 28)
        tmpRarity = "Ancient"
    end
    local tmpType = wepTypeData.name
    table.insert(tmpDescription, {tmpRarity .. " " .. tmpType, tmpColor})

    local modDisplayed = false
    -- Implicit modifier
    if weaponData.implicitMod then
        table.insert(tmpDescription, {"---- Implicit ----", KColor(0.5, 0.5, 0.5, 1)})

        local impRolls = {}
        for i, tmpRoll in ipairs(weaponData.implicitMod) do
            impRolls["roll" .. tostring(i)] = tmpRoll
        end

        local targetDesc = wepTypeData.implicitMod.description
        if type(targetDesc) == "table" then
            for _, tmpLine in ipairs(targetDesc) do
                table.insert(tmpDescription, PST:formatString(tmpLine, impRolls))
            end
        else
            table.insert(tmpDescription, PST:formatString(targetDesc, impRolls))
        end
        modDisplayed = true
    end

    -- Modifiers
    if weaponData.mods and #weaponData.mods > 0 then
        table.insert(tmpDescription, {"---- Mods ----", KColor(0.5, 0.5, 0.5, 1)})

        for _, tmpMod in ipairs(weaponData.mods) do
            local tmpModData = PST.astralWepMods[tmpMod.name]
            tmpColor = KColor(0.8, 0.8, 1, 1)
            if tmpModData and tmpModData.description then
                local modDesc = tmpModData.description

                local tmpRollList = {}
                if not tmpModData.ancient then
                    for i, tmpRoll in ipairs(tmpMod.rolls) do
                        tmpRollList["roll" .. tostring(i)] = tostring(tmpRoll)
                    end

                    -- Show mod ranges
                    if showModRanges then
                        local minRolls = PST:astralWepRoundRolls(tmpModData.rollsFunc(weaponData.tier, 0))
                        local maxRolls = PST:astralWepRoundRolls(tmpModData.rollsFunc(weaponData.tier, 1))
                        for i, tmpRoll in ipairs(tmpMod.rolls) do
                            local tgtRoll = "roll" .. tostring(i)
                            tmpRollList[tgtRoll] = tostring(tmpRoll) .. " (" .. tostring(minRolls[tgtRoll]) .. "~" .. tostring(maxRolls[tgtRoll]) .. ")"
                        end
                    end
                else
                    -- Ancient modifiers
                    tmpColor = PST:RGBKColor(255, 172, 28)
                    local ancientUpgrades = weaponData.ancientUpg or 0
                    for i, tmpRoll in ipairs(tmpModData.minRolls) do
                        local tgtRoll = "roll" .. tostring(i)
                        tmpRollList[tgtRoll] = tostring(tmpRoll + tmpModData.upgIncrements[i] * ancientUpgrades)
                    end
                end

                if type(modDesc) == "table" then
                    for _, tmpLine in ipairs(modDesc) do
                        table.insert(tmpDescription, {PST:formatString(tmpLine, tmpRollList), tmpColor})
                    end
                else
                    table.insert(tmpDescription, {PST:formatString(modDesc, tmpRollList), tmpColor})
                end
            end
        end
        modDisplayed = true
    end

    if modDisplayed then
        table.insert(tmpDescription, "")
    end

    -- Honing level
    if weaponData.honing and weaponData.honing > 0 then
        table.insert(tmpDescription, "Honing: " .. tostring(weaponData.honing) .. "/50")
    end

    -- Weapon tier
    table.insert(tmpDescription, {"Tier " .. wepTierTxt(weaponData.tier), PST:RGBKColor(250, 250, 210)})

    return tmpDescription
end