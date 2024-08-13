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
function PST:SC_addJewel(jewelType)
    local newJewel = {
        type = jewelType,
        unidentified = true,
        mods = {},
        fading = 0,
        mighty = false,
        starmight = 0
    }
    table.insert(PST.modData.starTreeInventory[jewelType], newJewel)
    return newJewel
end

-- Add a single random modifier to a jewel, based on rollable modifiers for its type
---@param jewel any Jewel originally created with PST:SC_addJewel.
---@param exclusive? boolean Whether to check if rolled mod is already on the jewel.
function PST:SC_addModToJewel(jewel, exclusive)
    if not PST.SCMods[jewel.type] then return end

    local totalWeight = 0
    local availableMods = 0
    for mod, modData in pairs(PST.SCMods[jewel.type]) do
        if (jewel.mods[mod] == nil or not exclusive) and (not modData.mightyOnly or (modData.mightyOnly and jewel.mighty)) then
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
            if not modData.mightyOnly or (modData.mightyOnly and jewel.mighty) then
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
                end

                local jewelData = PST.SCMods[jewel.type][mod]

                jewel.mods[mod] = {}
                local tmpRolls = {}
                local rollTable = jewelData.rolls
                if jewel.mighty then
                    rollTable = jewelData.mightyRolls
                end
                for _, rollRange in ipairs(rollTable) do
                    local roll = rollRange[1] + (math.random(math.abs(rollRange[2] - rollRange[1] + 1) - 1))
                    table.insert(tmpRolls, roll)
                end

                jewel.starmight = jewel.starmight + math.ceil(jewelData.starmightCalc(table.unpack(tmpRolls)))
                jewel.mods[mod].description = string.format(jewelData.description, table.unpack(tmpRolls))
                jewel.mods[mod].rolls = tmpRolls
                break
            else
                failsafe = failsafe + 1
            end
        end
    end
    if failsafe >= 1000 then
        Console.PrintWarning("Passive Skill Trees: warning, reached failsafe while identifying jewel.")
    end
end

function PST:SC_identifyJewel(jewel)
    if not jewel.unidentified then
        return false
    end

    if jewel.type ~= PSTStarcursedType.ANCIENT then
        for _=1,2 do
            PST:SC_addModToJewel(jewel, true)
        end
    end

    jewel.unidentified = false
    return true
end

function PST:SC_isStarTreeUnlocked()
    -- Require at least one character at level 40 to unlock star tree
    for _, charData in pairs(PST.modData.charData) do
        if charData.level >= 40 then
            return true
        end
    end
    return false
end

function PST:SC_wipeInventories()
    PST.modData.starTreeInventory = {
        Crimson = {},
        Azure = {},
        Viridian = {},
        Ancient = {}
    }
    PST:save()
end