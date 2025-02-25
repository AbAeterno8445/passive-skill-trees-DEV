local enableSerialization = false

function PST:serializeSave(modData)
    if not enableSerialization then return end

    ---- Serialize data: Tree node allocation
    for tmpTree, treeNodes in pairs(PST.modData.treeNodes) do
        modData.treeNodes[tmpTree] = {}
        for nodeID, allocated in pairs(treeNodes) do
            if allocated == 1 then
                table.insert(modData.treeNodes[tmpTree], tonumber(nodeID))
            end
        end
    end

    ---- Serialize data: Character sidereal tree node allocation
    for tmpChar, tmpCharData in pairs(PST.modData.charData) do
        if modData.charData[tmpChar].siderealNodes then
            modData.charData[tmpChar].siderealNodes = {}
            for nodeID, allocated in pairs(tmpCharData.siderealNodes) do
                if allocated == 1 then
                    table.insert(modData.charData[tmpChar].siderealNodes, tonumber(nodeID))
                end
            end
        end
    end

    ---- Serialize data: Starcursed jewel inventory
    modData.starTreeInventory = {}
    for tmpType, jewels in pairs(PST.modData.starTreeInventory) do
        modData.starTreeInventory[tmpType] = { unid = 0, unidMighty = 0, jewels = {} }
        local unid = 0
        local unidMighty = 0
        for _, tmpJewel in ipairs(jewels) do
            -- Aggregate unidentified jewels into a counter
            if tmpJewel.unidentified then
                if tmpJewel.mighty then unidMighty = unidMighty + 1
                else unid = unid + 1 end
            else
                local tmpEntry = {}

                -- Regular jewels
                if tmpType ~= PSTStarcursedType.ANCIENT then
                    -- 1. Starmight
                    table.insert(tmpEntry, tmpJewel.starmight)

                    -- 2. Modifiers (serialized)
                    local jewelMods = {}
                    if tmpJewel.mods then
                        for modName, tmpModData in pairs(tmpJewel.mods) do
                            local newMod = {}
                            local modSerialName = PST.SCMods[tmpType][modName] ~= nil and PST.SCMods[tmpType][modName].serial or modName
                            -- 2.1. Mod serial number (int) or mod name (string)
                            table.insert(newMod, modSerialName)
                            -- 2.2. List of rolls
                            table.insert(newMod, tmpModData.rolls or {})
                            table.insert(jewelMods, newMod)
                        end
                    end
                    table.insert(tmpEntry, jewelMods)

                    -- 3. Mighty (0 or 1)
                    if tmpJewel.mighty or tmpJewel.equipped then table.insert(tmpEntry, tmpJewel.mighty and 1 or 0) end
                    -- 4. Equipped
                    if tmpJewel.equipped then table.insert(tmpEntry, tmpJewel.equipped) end

                    table.insert(modData.starTreeInventory[tmpType].jewels, tmpEntry)
                -- Ancient jewels
                elseif tmpJewel.name then
                    if tmpJewel.name == "Faded Starpiece" then
                        -- 1. First argument -1 -> Faded Starpiece
                        table.insert(tmpEntry, -1)
                        -- 2. Starmight
                        table.insert(tmpEntry, tmpJewel.starmight)
                        -- 3. Equipped
                        if tmpJewel.equipped then
                            table.insert(tmpEntry, tmpJewel.equipped)
                        end

                        table.insert(modData.starTreeInventory[tmpType].jewels, tmpEntry)
                    else
                        for _, ancData in pairs(PST.SCAncients) do
                            if ancData.name == tmpJewel.name then
                                -- 1. Ancient modifier serial ID
                                table.insert(tmpEntry, ancData.serial)

                                -- 2. Extra jewel attributes (e.g. Cause converter 'status')
                                local extraMods = {}
                                local addedExtra = false
                                for tmpNewMod, modVal in pairs(tmpJewel) do
                                    if tmpNewMod ~= "name" and tmpNewMod ~= "type" and tmpNewMod ~= "equipped" and tmpNewMod ~= "starmight" then
                                        extraMods[tmpNewMod] = modVal
                                        addedExtra = true
                                    end
                                end
                                if addedExtra or tmpJewel.equipped then
                                    table.insert(tmpEntry, extraMods)
                                end

                                -- 3. Equipped
                                if tmpJewel.equipped then
                                    table.insert(tmpEntry, tmpJewel.equipped or "")
                                end

                                table.insert(modData.starTreeInventory[tmpType].jewels, tmpEntry)
                                break
                            end
                        end
                    end
                end
            end
        end
        if unid > 0 then
            modData.starTreeInventory[tmpType].unid = unid
        end
        if tmpType ~= PSTStarcursedType.ANCIENT and unidMighty > 0 then
            modData.starTreeInventory[tmpType].unidMighty = unidMighty
        end
    end

    ---- Serialize data: Astral weapon inventory
    modData.astralWepInventory = {}

    -- Order of modifiers roughly from most to least frequent
    local argOrder = {"tier", "rarity", "implicitMod", "mods", "honing", "equipped", "ancientID", "ancientUpg", "multiImplicits"}

    for _, tmpWep in ipairs(PST.modData.astralWepInventory) do
        local tmpEntry = {}

        -- Figure up to which argument needs to be saved for this weapon
        local addIndex = 0
        for i, arg in ipairs(argOrder) do
            if tmpWep[arg] then addIndex = i end
        end

        for i=1,addIndex do
            local arg = argOrder[i]
            local newArg = tmpWep[arg]
            -- Serialize modifiers
            if arg == "implicitMod" and not tmpWep[arg] then
                newArg = {}
            elseif (arg == "honing" or arg == "ancientUpg") and not tmpWep[arg] then
                newArg = 0
            elseif (arg == "equipped") and not tmpWep[arg] then
                newArg = ""
            elseif arg == "mods" then
                local newModArg = {}
                for _, tmpMod in ipairs(tmpWep.mods) do
                    local newMod = {}
                    local tmpWepModData = PST.astralWepMods[tmpMod.name]
                    ---@type integer|string
                    local modSerial = tmpMod.name
                    if tmpWepModData and tmpWepModData.serial then
                        modSerial = tmpWepModData.serial
                    end
                    table.insert(newMod, modSerial)
                    if tmpMod.rolls then
                        table.insert(newMod, tmpMod.rolls)
                    end
                    table.insert(newModArg, newMod)
                end
                newArg = newModArg
            -- Serialize multi-implicits
            elseif arg == "multiImplicits" then
                local newModArg = {}
                for _, tmpImp in ipairs(tmpWep.multiImplicits) do
                    local newImp = {}
                    table.insert(newImp, tmpImp.type)
                    table.insert(newImp, tmpImp.rolls)
                    table.insert(newModArg, newImp)
                end
                newArg = newModArg
            end
            table.insert(tmpEntry, newArg)
        end

        if not modData.astralWepInventory[tmpWep.type] then
            modData.astralWepInventory[tmpWep.type] = {}
        end
        table.insert(modData.astralWepInventory[tmpWep.type], tmpEntry)
    end

    modData.serialized = true
end

function PST:deserializeData(loadedData)
    if not enableSerialization then return end
    if not loadedData.serialized then return end

    -- Deserialize: Tree node allocation
    for tmpTree, treeNodes in pairs(loadedData.treeNodes) do
        local tmpAlloc = {}
        for _, tmpNodeID in ipairs(treeNodes) do
            tmpAlloc[tostring(tmpNodeID)] = 1
        end
        loadedData.treeNodes[tmpTree] = tmpAlloc
    end

    -- Deserialize: Character sidereal tree node allocation
    for _, tmpCharData in pairs(loadedData.charData) do
        if tmpCharData.siderealNodes then
            local tmpAlloc = {}
            for _, tmpNodeID in ipairs(tmpCharData.siderealNodes) do
                tmpAlloc[tostring(tmpNodeID)] = 1
            end
            tmpCharData.siderealNodes = tmpAlloc
        end
    end

    -- Deserialize: Starcursed jewel inventory
    for tmpType, jewelData in pairs(loadedData.starTreeInventory) do
        local tmpInv = {}
        -- Process saved jewels
        if jewelData.jewels then
            for _, tmpJewelSave in ipairs(jewelData.jewels) do
                local newJewel = {}
                -- Regular jewels
                if tmpType ~= PSTStarcursedType.ANCIENT then
                    newJewel.type = tmpType
                    -- 1. Starmight
                    newJewel.starmight = tmpJewelSave[1]

                    -- 2. Modifiers
                    newJewel.mods = {}
                    for _, tmpMod in ipairs(tmpJewelSave[2]) do
                        local tmpModName
                        for SCModName, SCMod in pairs(PST.SCMods[tmpType]) do
                            if (type(tmpMod[1]) == "number" and SCMod.serial and SCMod.serial == tmpMod[1]) or
                            (type(tmpMod[1]) == "string") and SCModName == tmpMod[1] then
                                tmpModName = SCModName
                                break
                            end
                        end
                        if tmpModName then
                            newJewel.mods[tmpModName] = { rolls = tmpMod[2] }
                        end
                    end

                    -- 3. Mighty
                    if #tmpJewelSave >= 3 and tmpJewelSave[3] == 1 then
                        newJewel.mighty = true
                    end
                    -- 4. Equipped
                    if #tmpJewelSave >= 4 and tmpJewelSave[4] then
                        newJewel.equipped = tmpJewelSave[4]
                    end
                -- Ancient jewels
                else
                    newJewel.type = PSTStarcursedType.ANCIENT
                    if tmpJewelSave[1] == -1 then
                        -- Faded starpiece
                        newJewel.name = "Faded Starpiece"
                        newJewel.spriteFrame = 10
                        newJewel.starmight = tmpJewelSave[2]
                        if #tmpJewelSave >= 3 and tmpJewelSave[3] then
                            newJewel.equipped = tmpJewelSave[3]
                        end
                    else
                        newJewel.starmight = 0
                        -- Ancient name
                        local tmpSerial = tmpJewelSave[1]
                        for _, SCMod in pairs(PST.SCAncients) do
                            if SCMod.serial == tmpSerial then
                                newJewel.name = SCMod.name
                                break
                            end
                        end
                        -- Extra jewel attributes
                        if #tmpJewelSave >= 2 and tmpJewelSave[2] and #tmpJewelSave[2] > 0 then
                            for k, v in pairs(tmpJewelSave[2]) do
                                newJewel[k] = v
                            end
                        end
                        -- Equipped
                        if #tmpJewelSave >= 3 and tmpJewelSave[3] then
                            newJewel.equipped = tmpJewelSave[3]
                        end
                    end
                end
                table.insert(tmpInv, newJewel)
            end
        end
        -- Regenerate unidentified jewels
        if jewelData.unid then
            for _=1,jewelData.unid do
                table.insert(tmpInv, {
                    type = tmpType,
                    unidentified = true,
                    starmight = 0,
                    mods = {}
                })
            end
        end
        if jewelData.unidMighty then
            for _=1,jewelData.unidMighty do
                table.insert(tmpInv, {
                    type = tmpType,
                    unidentified = true,
                    starmight = 0,
                    mods = {},
                    mighty = true
                })
            end
        end
        loadedData.starTreeInventory[tmpType] = tmpInv
    end

    -- Deserialize: Astral weapon inventory
    local wepInv = {}
    local argOrder = {"tier", "rarity", "implicitMod", "mods", "honing", "equipped", "ancientID", "ancientUpg", "multiImplicits"}
    for tmpType, weaponList in pairs(loadedData.astralWepInventory) do
        for _, tmpWeapon in ipairs(weaponList) do
            local newWeapon = {}
            newWeapon.type = tonumber(tmpType)
            for i, arg in ipairs(argOrder) do
                if #tmpWeapon >= i then
                    local newArg = tmpWeapon[i]
                    -- Deserialize weapon modifiers
                    if arg == "mods" then
                        local newModList = {}
                        -- Mod serial/name
                        for _, tmpWepMod in ipairs(newArg) do
                            for tmpModName, tmpModData in pairs(PST.astralWepMods) do
                                if (type(tmpWepMod[1]) == "number" and tmpModData.serial and tmpModData.serial == tmpWepMod[1]) or
                                (type(tmpWepMod[1]) == "string" and tmpModName == tmpWepMod[1]) then
                                    local newMod = { name = tmpModName }
                                    if tmpWepMod[2] then
                                        newMod.rolls = tmpWepMod[2]
                                    end
                                    table.insert(newModList, newMod)
                                    break
                                end
                            end
                        end
                        newArg = newModList
                    -- Deserialize multi-implicits
                    elseif arg == "multiImplicits" then
                        local newMod = {}
                        for _, tmpImp in ipairs(newArg) do
                            table.insert(newMod, { type = tmpImp[1], rolls = tmpImp[2] })
                        end
                        newArg = newMod
                    end
                    -- Modifier exclusions
                    local exclude = false
                    if arg == "honing" and newArg == 0 then exclude = true
                    elseif arg == "equipped" and newArg == "" then exclude = true
                    elseif arg == "implicitMod" and #newArg == 0 then exclude = true end

                    if not exclude then
                        newWeapon[arg] = newArg
                    end
                end
            end
            table.insert(wepInv, newWeapon)
        end
    end
    loadedData.astralWepInventory = wepInv
end