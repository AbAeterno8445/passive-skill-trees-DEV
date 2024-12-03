include("scripts.astral_forge.ST_astralforge_init")
include("scripts.astral_forge.ST_astralwep_bounties")

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

---@return PSTAstralWepType
function PST:astralWepPickRandType(factorMods)
    local typeWeights = {}
    local totalWeight = 0
    for _, tmpType in pairs(PSTAstralWepType) do
        typeWeights[tmpType] = 100
        totalWeight = totalWeight + typeWeights[tmpType]
    end
    PST:shuffleList(typeWeights)

    local randWeight = math.random(totalWeight)
    for tmpType, typeWeight in pairs(typeWeights) do
        if factorMods then
            -- Mod: Specific weapon type chances
            local wepTypeName = PST.astralWepData[tmpType].internalName or PST.astralWepData[tmpType].name
            local tmpMod = PST:getTreeSnapshotMod("astralWepRate" .. wepTypeName, 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                return tmpType
            end
        end

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
    local tmpWepTier = weaponData.tier
    if weaponData.type == PSTAstralWepType.GAUNTLET then
        tmpWepTier = tmpWepTier + 3
    end
    local modRolls = PST.astralWepMods[newModName].rollsFunc(tmpWepTier, rollPercs)
    local newModRolls = PST:astralWepRoundRolls(modRolls)

    table.insert(weaponData.mods, {
        name = newModName,
        rolls = newModRolls
    })
end

---@param weaponData PSTAstralWeapon
function PST:astralWepGenerateMagicMods(weaponData)
    PST:astralWepAddMod(weaponData)
    local extraModChance = 0.4 + 0.02 * weaponData.tier
    if math.random() < extraModChance then
        PST:astralWepAddMod(weaponData)
    end
end

---@param weaponData PSTAstralWeapon
function PST:astralWepUpdateImplicit(weaponData, honing)
    local wepTypeData = PST.astralWepData[weaponData.type]

    honing = honing or weaponData.honing or 0
    local function PST_tmpRollImplicit(targetImplicit)
        local impRolls = targetImplicit.rollsFunc(honing)
        local newImpRolls = {}
        for i=1,5 do
            local tmpRoll = impRolls["roll" .. tostring(i)]
            if tmpRoll then
                table.insert(newImpRolls, tmpRoll)
            end
        end
        return newImpRolls
    end

    if weaponData.multiImplicits then
        -- Check for multiple implicit weapons (e.g. Ironhand gauntlet)
        for _, tmpImplicit in ipairs(weaponData.multiImplicits) do
            local tgtWepType = PST.astralWepData[tmpImplicit.type]
            if tgtWepType and tgtWepType.implicitMod then
                tmpImplicit.rolls = PST_tmpRollImplicit(tgtWepType.implicitMod)
            end
        end
    else
        weaponData.implicitMod = PST_tmpRollImplicit(wepTypeData.implicitMod)
    end
end

---@param wepType PSTAstralWepType
function PST:createAstralWep(wepType, wepRarity, wepTier, ancientID)
    ---@type PSTAstralWeapon
    local newWep = {type = wepType, rarity = wepRarity, tier = math.min(5, wepTier) or 1}

    local wepTypeData = PST.astralWepData[wepType]

    -- Ironhand, multiple implicits
    if wepType == PSTAstralWepType.GAUNTLET and wepRarity == PSTAstralWepRarity.ANCIENT and ancientID == 2 then
        newWep.multiImplicits = {}

        local tmpImplicits = {}
        for tmpType, _ in pairs(PST.astralWepData) do
            if tmpType ~= PSTAstralWepType.GAUNTLET then
                table.insert(tmpImplicits, tmpType)
            end
        end

        -- Roll Ironhand implicits
        for _=1,3 do
            local newImplicitID = math.random(#tmpImplicits)
            table.insert(newWep.multiImplicits, {
                type = tmpImplicits[newImplicitID],
                rolls = {}
            })
            table.remove(tmpImplicits, newImplicitID)
        end
    end

    -- Assign implicit modifier
    PST:astralWepUpdateImplicit(newWep, 0)

    -- Magic weapon, generate modifiers
    if wepRarity == PSTAstralWepRarity.MAGIC then
        PST:astralWepGenerateMagicMods(newWep)
    -- Ancient weapon
    elseif wepRarity == PSTAstralWepRarity.ANCIENT then
        -- Pick random one from type if not provided
        if not ancientID then
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
        else
            newWep.ancientID = ancientID
        end

        -- Assign ancient mods
        for _, tmpMod in ipairs(wepTypeData.ancients[newWep.ancientID].ancientMods) do
            if not newWep.mods then newWep.mods = {} end
            table.insert(newWep.mods, {name = tmpMod})
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
    local magicChance = 0.26
    local ancientChance = 0.032
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

function PST:dropRandAstralWepAt(position, wepTier, factorMods, velocity)
    if not PST.config.astralWepDrops then return end

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
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpTrinketID, position, velocity or Vector.Zero, nil)
    end
end

-- Astral weapon trinket picked up - add corresponding weapon to player inventory
function PST:astralWepTrinketPickup(trinketName, wepTierParam)
    local wepType = nil
    local wepRarity = PSTAstralWepRarity.NORMAL
    local wepTier = wepTierParam or PST:getTreeSnapshotMod("astralWepTierDrops", 1)
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

        -- Mod: pre-honed astral weapon drops
        if Isaac.IsInGame() then
            local tmpMod = PST:getTreeSnapshotMod("preHonedWeps", 0)
            if tmpMod > 0 then
                for _=1,tmpMod do
                    if math.random() < 0.1 then
                        local res = PST:astralWepForgeHone(newWep)
                        if not res then break end
                    end
                end
            end
        end

        table.insert(PST.modData.astralWepInventory, newWep)
    end
end

---@param wepData PSTAstralWeapon
---@param wepSprite Sprite
function PST:renderAstralWepAt(wepData, wepSprite, x, y, scale)
    local wepTypeData = PST.astralWepData[wepData.type]
    local anim = "Normal"
    local frame = wepTypeData.spriteFrames[wepData.rarity]

    -- Ancient weapons
    if wepData.rarity == PSTAstralWepRarity.ANCIENT then
        anim = "Ancients"
        frame = wepTypeData.ancients[wepData.ancientID].spriteFrame
    end
    local oldScaleX, oldScaleY = wepSprite.Scale.X, wepSprite.Scale.Y
    if scale then
        wepSprite.Scale = Vector(scale, scale)
    end
    wepSprite:SetFrame(anim, frame)
    wepSprite:Render(Vector(x, y))
    wepSprite.Scale = Vector(oldScaleX, oldScaleY)

    -- Magic weapons overlay
    if wepData.rarity == PSTAstralWepRarity.MAGIC and wepData.mods then
        wepSprite:SetFrame("Overlays", wepTypeData.spriteFrames.overlay)
        local tmpColors = {}
        for _, tmpMod in ipairs(wepData.mods) do
            local tmpModData = PST.astralWepMods[tmpMod.name]
            if tmpModData and tmpModData.color then
                table.insert(tmpColors, PST:RGBColor(table.unpack(tmpModData.color)))
            end
        end
        if scale then
            wepSprite.Scale = Vector(scale, scale)
        end
        wepSprite.Color = PST:mixColors(tmpColors[1], tmpColors[2])
        wepSprite:Render(Vector(x, y))
        wepSprite.Color = Color()
        wepSprite.Scale = Vector(oldScaleX, oldScaleY)
    end
end

function PST:getEquippedAstralWep()
    for _, tmpWeapon in ipairs(PST.modData.astralWepInventory) do
        if tmpWeapon.equipped == PST:getCurrentCharName() then return tmpWeapon end
    end
    return nil
end

---@param weapon PSTAstralWeapon
function PST:equipAstralWep(weapon)
    if not weapon.equipped then
        local tmpEqWeapon = PST:getEquippedAstralWep()
        if tmpEqWeapon then tmpEqWeapon.equipped = nil end
        weapon.equipped = PST:getCurrentCharName()
    else
        weapon.equipped = nil
    end
    PST:save()
end

-- Determine how many forging materials a weapon is worth
---@param weaponData PSTAstralWeapon
function PST:getAstralWepDeconMats(weaponData)
    local mats = {
        mundane = 5,
        spark = 0,
        ancient = 0
    }
    mats.mundane = mats.mundane + (weaponData.tier - 1) * 5 + (weaponData.honing or 0)
    if weaponData.rarity ~= PSTAstralWepRarity.NORMAL then
        mats.mundane = math.max(2, math.floor(mats.mundane / 4))
    end
    if weaponData.mods and #weaponData.mods > 0 then
        mats.spark = math.floor(#weaponData.mods * 1.5 * weaponData.tier)
    end
    if weaponData.rarity == PSTAstralWepRarity.ANCIENT then
        mats.ancient = 1 + math.floor(((weaponData.ancientUpg or 0) + weaponData.tier) / 3)
    end
    return mats
end

local wepTierTxt = {"I", "II", "III", "IV", "V"}

---@param weaponData PSTAstralWeapon
---@param showModRanges? boolean
function PST:getAstralWepDesc(weaponData, showModRanges)
    local wepTypeData = PST.astralWepData[weaponData.type]
    local tmpDescription = {}

    -- Ancient name
    if weaponData.ancientID ~= nil and wepTypeData.ancients[weaponData.ancientID] then
        table.insert(tmpDescription, {wepTypeData.ancients[weaponData.ancientID].name, PST.kcolors.ANCIENT_ORANGE})
    end

    -- Rarity + type
    local tmpColor = PST.kcolors.WHITE
    local tmpRarity = "Normal"
    if weaponData.rarity == PSTAstralWepRarity.MAGIC then
        tmpColor = PST.kcolors.LIGHTBLUE1
        tmpRarity = "Magic"
    elseif weaponData.rarity == PSTAstralWepRarity.ANCIENT then
        tmpColor = PST.kcolors.ANCIENT_ORANGE
        tmpRarity = "Ancient"
    end
    local tmpType = wepTypeData.name
    table.insert(tmpDescription, {tmpRarity .. " " .. tmpType, tmpColor})

    local function PST_tmpShowImplicit(wepType, implicitRolls)
        local implicitWepTypeData = PST.astralWepData[wepType]
        if implicitWepTypeData then
            local impRolls = {}
            for i, tmpRoll in ipairs(implicitRolls) do
                local tgtRoll = "roll" .. tostring(i)
                impRolls[tgtRoll] = tostring(tmpRoll)
            end
            -- Show max rolls
            if showModRanges then
                local maxRolls = implicitWepTypeData.implicitMod.rollsFunc(50)
                for tmpTgtRoll, tmpMaxRoll in pairs(maxRolls) do
                    impRolls[tmpTgtRoll] = impRolls[tmpTgtRoll] .. " (" .. tostring(tmpMaxRoll) .. ")"
                end
            end

            local targetDesc = implicitWepTypeData.implicitMod.description
            if type(targetDesc) == "table" then
                for _, tmpLine in ipairs(targetDesc) do
                    table.insert(tmpDescription, PST:formatString(tmpLine, impRolls))
                end
            else
                table.insert(tmpDescription, PST:formatString(targetDesc, impRolls))
            end
        end
    end

    local modDisplayed = false
    -- Multi-implicit mod
    if weaponData.multiImplicits and #weaponData.multiImplicits > 0 then
        table.insert(tmpDescription, {"---- Implicits ----", PST.kcolors.GRAY1})

        for _, tmpMod in ipairs(weaponData.multiImplicits) do
            if tmpMod.type and tmpMod.rolls then PST_tmpShowImplicit(tmpMod.type, tmpMod.rolls) end
        end
        modDisplayed = true
    -- Implicit modifier
    elseif weaponData.implicitMod and not wepTypeData.implicitMod.noAncient or (wepTypeData.implicitMod.noAncient and weaponData.rarity ~= PSTAstralWepRarity.ANCIENT) then
        table.insert(tmpDescription, {"---- Implicit ----", PST.kcolors.GRAY1})

        PST_tmpShowImplicit(weaponData.type, weaponData.implicitMod)
        modDisplayed = true
    end

    -- Modifiers
    if weaponData.mods and #weaponData.mods > 0 then
        table.insert(tmpDescription, {"---- Mods (" .. tostring(#weaponData.mods) .. ") ----", PST.kcolors.GRAY1})

        for _, tmpMod in ipairs(weaponData.mods) do
            local tmpModData = PST.astralWepMods[tmpMod.name]
            tmpColor = PST.kcolors.LIGHTBLUE1
            if tmpModData and tmpModData.description then
                local modDesc = tmpModData.description

                local tmpRollList = {}
                if not tmpModData.ancient then
                    for i, tmpRoll in ipairs(tmpMod.rolls) do
                        local tgtRoll = "roll" .. tostring(i)
                        tmpRollList[tgtRoll] = tostring(tmpRoll)
                        -- Show mod ranges
                        if showModRanges then
                            local minRolls = PST:astralWepRoundRolls(tmpModData.rollsFunc(weaponData.tier, {0, 0, 0, 0, 0}))
                            local maxRolls = PST:astralWepRoundRolls(tmpModData.rollsFunc(weaponData.tier, {1, 1, 1, 1, 1}))
                            tmpRollList[tgtRoll] = tmpRollList[tgtRoll] .. " (" .. tostring(minRolls[i]) .. "~" .. tostring(maxRolls[i]) .. ")"
                        end
                    end
                else
                    -- Ancient modifiers
                    tmpColor = PST.kcolors.ANCIENT_ORANGE
                    local ancientUpgrades = weaponData.ancientUpg or 0
                    for i, tmpRoll in ipairs(tmpModData.minRolls) do
                        local tgtRoll = "roll" .. tostring(i)
                        local tmpMathFunc = math.min
                        if tmpModData.upgIncrements[i] < 0 then
                            tmpMathFunc = math.max
                        end
                        tmpRollList[tgtRoll] = tostring(tmpMathFunc(tmpModData.maxRolls[i], tmpRoll + tmpModData.upgIncrements[i] * ancientUpgrades))
                        -- Show max value
                        if showModRanges then
                            tmpRollList[tgtRoll] = tmpRollList[tgtRoll] .. " (" .. tostring(tmpModData.maxRolls[i]) .. ")"
                        end
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

    -- Metamorphic Claw: show chosen modifier while in-game
    local tmpMod = PST:getSnapAstralWepMod("metamorphicClaw")
    if Isaac.IsInGame() and tmpMod and weaponData.type == PSTAstralWepType.GAUNTLET and weaponData.rarity == PSTAstralWepRarity.ANCIENT and
    weaponData.ancientID == 3 then
        local targetMods = PST:getTreeSnapshotMod("ancwep_metaClawMod", nil)
        if targetMods then
            for _, tmpTargetMod in ipairs(targetMods) do
                local tmpModData = PST.astralWepMods[tmpTargetMod]
                if tmpModData then
                    local modDesc = tmpModData.description
                    local tmpRollList = {}
                    for i, tmpRoll in ipairs(tmpModData.minRolls) do
                        local tgtRoll = "roll" .. tostring(i)
                        local tmpMathFunc = math.min
                        if tmpModData.upgIncrements[i] < 0 then
                            tmpMathFunc = math.max
                        end
                        tmpRollList[tgtRoll] = tostring(tmpMathFunc(tmpModData.maxRolls[i], tmpRoll + tmpModData.upgIncrements[i] * tmpMod[1]))
                    end
                    if type(modDesc) == "table" then
                        for _, tmpLine in ipairs(modDesc) do
                            table.insert(tmpDescription, {PST:formatString(tmpLine, tmpRollList), PST.kcolors.PURPLE1})
                        end
                    else
                        table.insert(tmpDescription, {PST:formatString(modDesc, tmpRollList), PST.kcolors.PURPLE1})
                    end
                end
            end
        end
    end

    if modDisplayed then
        table.insert(tmpDescription, "")
    end

    -- Honing level
    if weaponData.honing and weaponData.honing > 0 then
        table.insert(tmpDescription, "Honing: " .. tostring(weaponData.honing) .. "/50")
    end

    -- Weapon tier
    local tmpTierStr = wepTierTxt[weaponData.tier]
    table.insert(tmpDescription, {"Tier " .. tmpTierStr, PST.kcolors["WEP_TIER_" .. tmpTierStr]})

    return tmpDescription
end

-- Holds functions that allow applying/removing ancient weapon modifier stats/items dynamically
local ancientWepStatFuncs = {
    executioner = function(tmpMod, remove)
        PST:addModifiers({ damagePerc = tmpMod[1] * ((remove == true) and -1 or 1) }, true)
    end,
    nimbleTwins = function(tmpMod, remove)
        PST:addModifiers({ tearsPerc = tmpMod[1] * ((remove == true) and -1 or 1) }, true)
    end,
    lostCoralTrident = function(tmpMod, remove, player)
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_NEPTUNUS, ((remove == true) and -1 or 1))
        PST:addModifiers({ damagePerc = -tmpMod[1] * ((remove == true) and -1 or 1) }, true)
    end,
    oceanicMight = function(tmpMod, remove, player)
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_AQUARIUS, ((remove == true) and -1 or 1))
    end,
    mobripper = function(tmpMod, remove)
        PST:addModifiers({ damagePerc = -tmpMod[2] * ((remove == true) and -1 or 1) }, true)
    end,
    berserkerWrath = function(tmpMod, remove)
        PST:addModifiers({ berserkDuration = tmpMod[1] * ((remove == true) and -1 or 1) }, true)
    end,
    stormAdvance = function(tmpMod, remove, player)
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_120_VOLT, ((remove == true) and -1 or 1))
    end,
    quillRain = function(tmpMod, remove, player)
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_SOY_MILK, ((remove == true) and -1 or 1))
    end,
    gildedSeeker = function(tmpMod, remove, player)
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER, ((remove == true) and -1 or 1))
    end,
    glowingMoonblade = function(tmpMod, remove, player)
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_LUNA, ((remove == true) and -1 or 1))
        PST:addModifiers({
            damagePerc = -tmpMod[1] * ((remove == true) and -1 or 1),
            tearsPerc = -tmpMod[1] * ((remove == true) and -1 or 1)
        }, true)
    end,
    glowingSunblade = function(tmpMod, remove, player)
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_SOL, ((remove == true) and -1 or 1))
        PST:addModifiers({
            damagePerc = -tmpMod[1] * ((remove == true) and -1 or 1),
            tearsPerc = -tmpMod[1] * ((remove == true) and -1 or 1)
        }, true)
    end,
    tollingBell = function(tmpMod, remove, player)
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_LEO, ((remove == true) and -1 or 1))
    end
}

-- Ancient weapon mods that apply stats on run beginning, can use this to remove or re-apply if necessary
---@param player EntityPlayer
---@param removeMod? string -- If provided, removes this ancient mod's stat effects
function PST:astralWepApplyAncientStats(player, removeMod)
    if not removeMod then
        for tmpModName, tmpMod in pairs(PST.astralWepMods) do
            if tmpMod.ancient and ancientWepStatFuncs[tmpModName] then
                local plMod = PST:getSnapAstralWepMod(tmpModName)
                if plMod then
                    ancientWepStatFuncs[tmpModName](plMod, false, player)
                end
            end
        end
    elseif ancientWepStatFuncs[removeMod] then
        local plMod = PST:getSnapAstralWepMod(removeMod)
        if plMod then
            ancientWepStatFuncs[removeMod](plMod, true, player)
        end
    end
end

include("scripts.astral_forge.ST_astralforge_forging")