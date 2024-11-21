-- Ancient Weapon Bounty generation/reroll obol cost
PST.ancWepBountyObolCost = 250

-- Generate a new ancient weapon bounty
---@param baseDepth number
---@param weaponType PSTAstralWepType
function PST:ancWepBountyGenerate(baseDepth, weaponType)
    local baseColumn = 15
    local newBounty = {
        objectives = {},
        rewardWepType = weaponType,
        rewardWepAncient = 0
    }
    -- Pick objectives
    local pickedObjectives = {}
    for _=1,4 do
        -- Check for min/max depth requirement
        local tmpObjectiveName = PST.expeditionObjectiveList[math.random(#PST.expeditionObjectiveList)]
        local tmpObjective = PST.expeditionObjectives[tmpObjectiveName]
        local failsafe = 0
        while ((tmpObjective.minDepth and baseDepth < tmpObjective.minDepth) or (tmpObjective.maxDepth and baseDepth > tmpObjective.maxDepth) or PST:arrHasValue(pickedObjectives, tmpObjectiveName))
        and failsafe < 300 do
            tmpObjectiveName = PST.expeditionObjectiveList[math.random(#PST.expeditionObjectiveList)]
            tmpObjective = PST.expeditionObjectives[tmpObjectiveName]
            failsafe = failsafe + 1
        end
        if failsafe < 300 then
            table.insert(pickedObjectives, tmpObjectiveName)
            table.insert(newBounty.objectives, {
                name = tmpObjectiveName,
                req = tmpObjective.reqFunc(baseDepth, baseColumn),
                prog = 0
            })
        end
    end
    -- Add final objective
    local tmpObjectiveName = PST.expeditionObjectiveFinalList[math.random(#PST.expeditionObjectiveFinalList)]
    local tmpObjective = PST.expeditionObjectivesFinal[tmpObjectiveName]
    table.insert(newBounty.objectives, {
        name = tmpObjectiveName,
        req = tmpObjective.reqFunc(baseDepth, baseColumn),
        prog = 0
    })

    -- Pick specific ancient
    local wepTypeData = PST.astralWepData[newBounty.rewardWepType]
    if wepTypeData and #wepTypeData.ancients > 0 then
        newBounty.rewardWepAncient = math.random(#wepTypeData.ancients)
    else
        return nil
    end
    return newBounty
end

-- Attempt to generate a new ancient weapon bounty for the current character
---@param spendObols boolean
---@param weaponType PSTAstralWepType
function PST:ancWepBountyCharGenerate(spendObols, weaponType)
    local charData = PST:getCurrentCharData()
    if charData then
        if not spendObols or (spendObols and charData.arcaneObols and charData.arcaneObols >= PST.ancWepBountyObolCost) or PST.debugOptions.freeBounties then
            if spendObols and not PST.debugOptions.freeBounties then
                charData.arcaneObols = charData.arcaneObols - PST.ancWepBountyObolCost
            end
            local baseDepth = 5 + (charData.compBounties or 0)
            local newBounty = PST:ancWepBountyGenerate(baseDepth, weaponType)
            if newBounty then
                charData.ancWepBounty = newBounty
                return true
            end
        end
    end
    return false
end

function PST:ancWepBountyCharCanComplete()
    local charData = PST:getCurrentCharData()
    if charData and charData.ancWepBounty then
        -- Verify objective completion
        local completed = true
        for _, tmpObjective in ipairs(charData.ancWepBounty.objectives) do
            if tmpObjective.prog < tmpObjective.req then
                completed = false
                break
            end
        end
        return completed
    end
    return false
end

-- Attempt to complete the current character's current ancient weapon bounty
function PST:ancWepBountyCharComplete()
    local charData = PST:getCurrentCharData()
    if charData and charData.ancWepBounty then
        if not charData.compBounties then charData.compBounties = 0 end
        charData.compBounties = charData.compBounties + 1

        -- Reward ancient weapon
        if charData.ancWepBounty.rewardWepType ~= -1 and charData.ancWepBounty.rewardWepAncient then
            local wepTypeData = PST.astralWepData[charData.ancWepBounty.rewardWepType]
            if wepTypeData then
                local ancientData = wepTypeData.ancients[charData.ancWepBounty.rewardWepAncient]
                if ancientData then
                    PST:astralWepTrinketPickup("Astral weapon: " .. ancientData.name)
                end
            end
        end

        charData.ancWepBounty = nil
        return true
    end
    return false
end

-- Return the current character's current ancient weapon bounty
function PST:ancWepBountyCharGet()
    local charData = PST:getCurrentCharData()
    if charData then return charData.ancWepBounty end
    return nil
end