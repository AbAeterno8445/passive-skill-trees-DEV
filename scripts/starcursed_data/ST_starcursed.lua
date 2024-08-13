include("scripts.starcursed_data.ST_starcursed_init")

---@enum PSTStarcursedType
PSTStarcursedType = {
    AZURE = "Azure",
    CRIMSON = "Crimson",
    VIRIDIAN = "Viridian",
    ANCIENT = "Ancient"
}

-- Adds an unidentified starcursed jewel with the given properties to the Star Tree inventory
---@param type PSTStarcursedType Jewel type
function PST:SC_addJewel(type)
    local newJewel = {
        type = type,
        unidentified = true,
        mods = {},
        fading = 0,
        mighty = false,
        starmight = 0
    }
    table.insert(PST.modData.starTreeInventory, newJewel)
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
        if jewel.mods[mod] == nil or not exclusive then
            totalWeight = totalWeight + modData.weight
            availableMods = availableMods + 1
        end
    end
    -- No more rollable mods
    if availableMods == 0 and not exclusive then
        return
    end

    local tmpWeight = math.random(totalWeight)
    while tmpWeight > 0 do
        for mod, modData in pairs(PST.SCMods[jewel.type]) do
            tmpWeight = tmpWeight - modData.weight
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

                jewel.starmight = jewelData.starmightCalc(table.unpack(tmpRolls))
                jewel.mods[mod].description = string.format(jewelData.description, table.unpack(tmpRolls))
                jewel.mods[mod].rolls = tmpRolls
                break
            end
        end
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