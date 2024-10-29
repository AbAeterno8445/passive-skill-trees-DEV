-- Determine crafting costs for the given weapon
---@param weaponData PSTAstralWeapon
function PST:getAstralWepCraftCosts(weaponData)
    local costs = {
        honing = {}, reroll = {}, addition = {}, removal = {},
        imprinting = {}, ancUpgrade = {}, alteration = {}, transmutation = {},
        --ascension = {}
    }
    -- Honing
    costs.honing.mundaneEssence = 3 + math.ceil((weaponData.honing or 0) * 1.2)
    -- Rerolling modifiers
    costs.reroll.mundaneEssence = 6 + weaponData.tier * 2
    costs.reroll.sparkEssence = 2 + weaponData.tier
    costs.reroll.sparkStardust = weaponData.tier
    -- Add missing modifier
    costs.addition.mundaneEssence = 15
    costs.addition.sparkEssence = weaponData.tier
    costs.addition.sparkStardust = 2 + weaponData.tier
    -- Remove random modifier
    costs.removal.mundaneEssence = 15
    costs.removal.sparkEssence = 3 + weaponData.tier
    costs.removal.sparkStardust = weaponData.tier
    -- Imprint modifier into Ancient
    costs.imprinting.sparkEssence = 25
    costs.imprinting.sparkStardust = 20
    costs.imprinting.ancientEssence = 4
    costs.imprinting.ancientStardust = 2
    -- Upgrade Ancient modifiers
    costs.ancUpgrade.mundaneEssence = 8
    costs.ancUpgrade.sparkEssence = 4
    costs.ancUpgrade.sparkStardust = 2
    costs.ancUpgrade.ancientEssence = 1
    costs.ancUpgrade.ancientStardust = 1
    -- Alteration: reroll modifier rolls
    costs.alteration.sparkEssence = 5
    costs.alteration.sparkStardust = 3
    costs.alteration.ancientEssence = 1
    if weaponData.mods and #weaponData.mods >= 2 then
        costs.alteration.sparkEssence = 7
        costs.alteration.sparkStardust = 5
        costs.alteration.ancientStardust = 1
    end
    -- Transmutation: transform normal weapon into magic, adding 1 modifier
    costs.transmutation.mundaneEssence = 20 + weaponData.tier * 5
    costs.transmutation.sparkEssence = 4 + weaponData.tier * 3
    costs.transmutation.sparkStardust = 3 + weaponData.tier * 2
    --[[ Ascension: upgrade the weapon's tier
    costs.ascension.mundaneEssence = 10 * weaponData.tier
    costs.ascension.sparkEssence = 8 * weaponData.tier
    costs.ascension.sparkStardust = 8 * weaponData.tier
    costs.ascension.ancientEssence = 2 * weaponData.tier
    costs.ascension.ancientStardust = 2 * weaponData.tier]]
    return costs
end

---@param weaponData PSTAstralWeapon
function PST:astralWepForgeHone(weaponData)
    if not weaponData.honing then weaponData.honing = 0 end
    if weaponData.honing < 50 then
        weaponData.honing = weaponData.honing + 1
        PST:astralWepUpdateImplicit(weaponData)
        return true
    end
    return false
end

-- Reroll non-implicit modifiers
---@param weaponData PSTAstralWeapon
function PST:astralWepForgeReroll(weaponData)
    weaponData.mods = {}
    PST:astralWepGenerateMagicMods(weaponData)
end

-- Add missing modifier to weapon, if it has only 1
---@param weaponData PSTAstralWeapon
function PST:astralWepForgeAdd(weaponData)
    if weaponData.mods and #weaponData.mods == 1 then
        PST:astralWepAddMod(weaponData)
        return true
    end
    return false
end

-- Remove a random modifier from the weapon, if it has 2
---@param weaponData PSTAstralWeapon
function PST:astralWepForgeRemove(weaponData)
    if weaponData.mods then
        local validMods = {}
        for i, tmpMod in ipairs(weaponData.mods) do
            local modData = PST.astralWepMods[tmpMod.name]
            if not modData.ancient then table.insert(validMods, i) end
        end
        if #validMods >= 2 then
            local randMod = validMods[math.random(#validMods)]
            table.remove(weaponData.mods, randMod)
            return true
        end
    end
    return false
end

-- Imprint a random modifier from target weapon into ancient
---@param weaponData PSTAstralWeapon
---@param targetWeapon PSTAstralWeapon
function PST:astralWepForgeImprint(weaponData, targetWeapon)
    if weaponData.rarity == PSTAstralWepRarity.ANCIENT and targetWeapon.rarity == PSTAstralWepRarity.MAGIC and
    weaponData.mods and #weaponData.mods == 1 and targetWeapon.mods and #targetWeapon.mods == 2 then
        local randMod = targetWeapon.mods[math.random(#targetWeapon.mods)]
        table.insert(weaponData.mods, PST:copyTable(randMod))
        return true
    end
    return false
end

-- Upgrade ancient weapon's unique ancient mods
---@param weaponData PSTAstralWeapon
function PST:astralWepForgeAncUpg(weaponData)
    if not weaponData.mods then return false end
    if not weaponData.ancientUpg then weaponData.ancientUpg = 0 end

    -- Check that the weapon's ancient modifiers still have upgrades available
    local upgradeable = false
    for _, tmpMod in ipairs(weaponData.mods) do
        local modData = PST.astralWepMods[tmpMod.name]
        if modData.ancient then
            for i, tmpRoll in ipairs(modData.minRolls) do
                if tmpRoll + modData.upgIncrements[i] * weaponData.ancientUpg < modData.maxRolls[i] then
                    upgradeable = true
                    break
                end
            end
            if upgradeable then break end
        end
    end
    if upgradeable then
        weaponData.ancientUpg = weaponData.ancientUpg + 1
        return true
    end
    return false
end

-- Reroll values of non-implicit modifiers
---@param weaponData PSTAstralWeapon
function PST:astralWepForgeAlter(weaponData)
    if not weaponData.mods then return false end
    for i, tmpMod in ipairs(weaponData.mods) do
        local rollPercs = {math.random(), math.random(), math.random(), math.random(), math.random()}
        local modRolls = PST.astralWepMods[tmpMod.name].rollsFunc(weaponData.tier, rollPercs)
        local newModRolls = PST:astralWepRoundRolls(modRolls)

        weaponData.mods[i].rolls = newModRolls
    end
    return true
end

-- Turn normal weapon into magic, adding 1 modifier
---@param weaponData PSTAstralWeapon
function PST:astralWepForgeTransmute(weaponData)
    if weaponData.rarity ~= PSTAstralWepRarity.NORMAL then return false end
    weaponData.rarity = PSTAstralWepRarity.MAGIC
    PST:astralWepAddMod(weaponData)
    return true
end