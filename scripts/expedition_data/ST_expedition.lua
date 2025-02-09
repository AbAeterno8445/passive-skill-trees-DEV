include("scripts.expedition_data.ST_expedition_init")
include("scripts.expedition_data.generators.ST_expedition_generator_main")

function PST:loadExpeditionsData()
    ---- Load Astral Expeditions
	-- Expeditions data number indexes
	local tmpExpeditionsData = { [0] = {} }
	for k, v in pairs(PST.modData.expeditionsData) do
		tmpExpeditionsData[tonumber(k)] = v
	end
	for depth, tmpExpedSave in pairs(tmpExpeditionsData) do
		if depth > 0 then
			PST:loadExpedition(depth, tmpExpedSave)
		end
	end
	PST.modData.expeditionsData = tmpExpeditionsData
end

function PST:expedGetNodeAt(depth, col, row)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition then
        local tmpCol = tmpExpedition.nodes[col]
        if tmpCol then
            local tmpNode = tmpCol[row]
            if tmpNode then return tmpNode end
        end
    end
    return nil
end

---@param depth number
---@param nodeData PSTExpNode
function PST:expedNodeIsObjectiveDone(depth, nodeData)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition and nodeData and tmpExpedition.selectedNode and nodeData.objective then
        return tmpExpedition.selectedNode.objProgress >= nodeData.objective.req
    end
    return false
end

function PST:resetExpedition(depth)
    PST.expeditionsData[depth] = PST:generateExpedition(depth)
    PST:updateExpedAccess(depth)
    return PST.expeditionsData[depth]
end

-- For testing - reset expedition depth and switch to it in the expedition screen menu
function PST:resetExpeditionDebug(depth)
    PST:resetExpedition(depth)
    PST.modData.expedLastDepth = depth
    PST.treeScreen.modules.menuScreensModule.menus[PSTTreeScreenMenu.EXPEDITION].currentDepth = depth
end

-- Add obols to the currently selected/player character
function PST:addCurrentCharObols(amount)
    local currentChar = PST:getCurrentCharData()
    if currentChar then
        if not currentChar.arcaneObols then currentChar.arcaneObols = 0 end
        currentChar.arcaneObols = currentChar.arcaneObols + amount
    end
end

-- Add crimson starcores to the currently selected/played character
function PST:addCurrentCharCrimsonStarcores(amount)
    local currentChar = PST:getCurrentCharData()
    if currentChar then
        if not currentChar.crimsonStarcores then currentChar.crimsonStarcores = 0 end
        currentChar.crimsonStarcores = currentChar.crimsonStarcores + amount
    end
end

-- Add boon to expedition, or upgrade it if already present
function PST:expedAddBoon(depth, boonID)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition and boonID <= #PST.expeditionBoons then
        if not PST:arrHasValue(tmpExpedition.boons, boonID) then
            table.insert(tmpExpedition.boons, boonID)
        elseif not PST:arrHasValue(tmpExpedition.upgradedBoons, boonID) then
            table.insert(tmpExpedition.upgradedBoons, boonID)
        end
    end
end

-- Remove boon from expedition
function PST:expedRemoveBoon(depth, boonID)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition then
        PST:tableRemoveFirst(tmpExpedition.boons, boonID)
        PST:tableRemoveFirst(tmpExpedition.upgradedBoons, boonID)
    end
end

-- Add curse to expedition
function PST:expedAddCurse(depth, curseID)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition and curseID <= #PST.expeditionCurses and not PST:arrHasValue(tmpExpedition.curses, curseID) then
        table.insert(tmpExpedition.curses, curseID)

        -- Dynamic Tree Mode - apply curse
        if Isaac.IsInGame() and PST:getTreeSnapshotMod("isExpedRun") and PST:getTreeSnapshotMod("dynamicMode", false) then
            local runDepth = PST:getTreeSnapshotMod("expedDepth", 1)
            if runDepth == depth then
                local curseData = PST.expeditionCurses[curseID]
                if curseData and curseData.modsFunc then
                    PST:addModifiers(curseData.modsFunc(runDepth), true)
                end
            end
        end
    end
end

-- Remove curse from expedition
function PST:expedRemoveCurse(depth, curseID)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition then
        PST:tableRemoveFirst(tmpExpedition.curses, curseID)

        -- Dynamic Tree Mode - unapply curse
        if Isaac.IsInGame() and PST:getTreeSnapshotMod("isExpedRun") and PST:getTreeSnapshotMod("dynamicMode", false) then
            local runDepth = PST:getTreeSnapshotMod("expedDepth", 1)
            if runDepth == depth then
                local curseData = PST.expeditionCurses[curseID]
                if curseData and curseData.modsFunc then
                    PST:subtractModifiers(curseData.modsFunc(runDepth))
                end
            end
        end
    end
end

-- Add item to expedition
---@param itemID CollectibleType
function PST:expedAddItem(depth, itemID)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition and not PST:arrHasValue(tmpExpedition.items, itemID) then
        table.insert(tmpExpedition.items, itemID)
    end
end

-- Remove item from expedition
function PST:expedRemoveItem(depth, itemID)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition then
        PST:tableRemoveFirst(tmpExpedition.items, itemID)
    end
end

-- Drop obols at the given position
function PST:expedDropObolsAt(position, amount)
    local tmpAmount = amount
    local obolDrops = {}
    for i=#PST.expedObolDropValues,1,-1 do
        local obolValue = PST.expedObolDropValues[i]
        while tmpAmount >= obolValue or (tmpAmount == 1 and obolValue == 2) do
            table.insert(obolDrops, i)
            tmpAmount = tmpAmount - obolValue
        end
    end
    for _, tmpDrop in ipairs(obolDrops) do
        local obolID = Isaac.GetTrinketIdByName("Arcane Obols " .. tostring(tmpDrop))
        if obolID ~= -1 then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, obolID, position, RandomVector() * 3 * math.random(), nil)
        end
    end
end

-- Returns whether the current run can progress towards the current expedition's objective, based on selected node
function PST:expedCanProgress(depth)
    -- Dynamic tree mode, always progress-able
    if PST:getTreeSnapshotMod("dynamicMode", false) and PST:getTreeSnapshotMod("isExpedRun", false) then
        return true
    end

    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition and PST:getTreeSnapshotMod("isExpedRun", false) and tmpExpedition.selectedNode then
        -- Check snapshot selected node matches current selected node
        if PST:getTreeSnapshotMod("expedSelNodeCol", -1) == tmpExpedition.selectedNode.col and
        PST:getTreeSnapshotMod("expedSelNodeRow", -1) == tmpExpedition.selectedNode.row then
            -- Check snapshot objective type matches
            local selCol = tmpExpedition.nodes[tmpExpedition.selectedNode.col]
            if selCol then
                local selNode = selCol[tmpExpedition.selectedNode.row]
                return selNode and selNode.objective.name == PST:getTreeSnapshotMod("expedSelNodeObjName", "N/A")
            end
        end
    end
    return false
end

-- Add progress to an expedition's current objective, and check for node completion. If in run, show progress text popups
---@param depth number
---@param prog number
---@param objName? string -- If provided, will check whether this objective name matches the currently selected one in the expedition
function PST:expedAddProgress(depth, prog, objName)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition and tmpExpedition.selectedNode then
        local tgtCol = tmpExpedition.nodes[tmpExpedition.selectedNode.col]
        if tgtCol then
            local tgtNode = tgtCol[tmpExpedition.selectedNode.row]
            if tgtNode and tmpExpedition.selectedNode.objProgress <= tgtNode.objective.req and
            (not objName or (objName and tgtNode.objective.name == objName)) then
                local oldVal = tmpExpedition.selectedNode.objProgress
                tmpExpedition.selectedNode.objProgress = math.min(tgtNode.objective.req, tmpExpedition.selectedNode.objProgress + prog)

                -- Expedition objective progress text popups
                if Isaac.IsInGame() and PST.config.expedProgTextThreshold ~= 0 then
                    local newVal = tmpExpedition.selectedNode.objProgress
                    local progTotalSteps = PST.config.expedProgTextThreshold
                    local lastStep = 0
                    for i=1,progTotalSteps do
                        local progThreshold = (i / progTotalSteps)
                        if oldVal / tgtNode.objective.req < progThreshold and newVal / tgtNode.objective.req >= progThreshold then
                            lastStep = i
                        end
                    end
                    if lastStep > 0 then
                        local tmpVal = math.ceil(PST:roundFloat(lastStep / progTotalSteps, -2) * 100)
                        local tmpColor = PST:RGBColor(57, 150, 255)
                        if tmpVal == 100 then
                            tmpColor = PST:RGBColor(80, 255, 255)
                            SFXManager():Play(SoundEffect.SOUND_THUMBSUP, 0.5, 2, false, 1.1)
                        end
                        PST:createFloatTextFX("Expedition objective: " .. tostring(tmpVal) .. "%", Vector.Zero, tmpColor, 0.13, 100, true)
                    end
                end
            end
        end
    end
end

-- In-run helper function to add progress to the given objective
function PST:expedAddProgInRun(objName, prog)
    if Isaac.IsInGame() then
        if PST:getTreeSnapshotMod("isExpedRun", false) then
            local expDepth = PST:getTreeSnapshotMod("expedDepth", 0)
            local expData = PST.expeditionsData[expDepth]
            if expData and PST:expedCanProgress(expDepth) then
                PST:expedAddProgress(expDepth, prog, objName)
            end
        end

        -- Ancient Weapon Bounty objective progress
        if PST:isRunSidereal() then
            local charData = PST:getCurrentCharData()
            if charData and charData.ancWepBounty then
                for _, tmpObjective in ipairs(charData.ancWepBounty.objectives) do
                    if tmpObjective.name == objName then
                        tmpObjective.prog = math.min(tmpObjective.req, tmpObjective.prog + prog)
                    end
                end
            end
        end
    end
end

function PST:expedMeetsRequirements(depth)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition then
        -- Selected node
        if not tmpExpedition.selectedNode then return false end
        -- Selected character level requirement
        local currentChar = PST:getCurrentCharData()
        if not currentChar or (currentChar and currentChar.level < PST.expedMinLevel) then return false end
        -- Starmight requirement
        if tmpExpedition.implicits then
            local tmpReq = tmpExpedition.implicits.starmightReq
            if tmpReq and tmpReq > 0 and PST.treeScreen.starcursedTotalMods.totalStarmight < tmpReq then
                return false
            end
        end
        -- Ancient Starcursed Jewel requirement (curse)
        local expCurses = PST:getExpedCurseMods(tmpExpedition)
        if expCurses["curseAncientStars"] then
            local ancientSocketed = PST:SC_getSocketedJewel(PSTStarcursedType.ANCIENT, "1") or PST:SC_getSocketedJewel(PSTStarcursedType.ANCIENT, "2")
            if not ancientSocketed then return false end
        end
        return true
    end
    return false
end

function PST:completeExpedNode(depth, col, row, giveReward)
    local tmpExpedition = PST.expeditionsData[depth]
    local tmpNode = PST:expedGetNodeAt(depth, col, row)
    if tmpExpedition and tmpNode then
        -- Give node reward
        if giveReward then
            -- Expedition attempts
            if tmpNode.rewardType == PSTExpNodeRewardType.ATTEMPTS then
                tmpExpedition.startAttempts = tmpExpedition.startAttempts + tmpNode.rewardData
                tmpExpedition.attempts = tmpExpedition.attempts + tmpNode.rewardData
            -- Boon
            elseif tmpNode.rewardType == PSTExpNodeRewardType.BOON and not PST:arrHasValue(tmpExpedition.boons, tmpNode.rewardData) then
                -- Curse of the Boonless
                if not PST:arrHasValue(tmpExpedition.curses, 22) then
                    PST:expedAddBoon(depth, tmpNode.rewardData)
                end
            -- Exp
            elseif tmpNode.rewardType == PSTExpNodeRewardType.EXP then
                PST:addXP(tmpNode.rewardData, false)
            -- Item
            elseif tmpNode.rewardType == PSTExpNodeRewardType.ITEM and not PST:arrHasValue(tmpExpedition.items, tmpNode.rewardData) then
                PST:expedAddItem(depth, tmpNode.rewardData)
            -- Arcane obols
            elseif tmpNode.rewardType == PSTExpNodeRewardType.OBOLS then
                PST:addCurrentCharObols(tmpNode.rewardData)
            -- Crimson starcore
            elseif tmpNode.rewardType == PSTExpNodeRewardType.C_STARCORE then
                PST:addCurrentCharCrimsonStarcores(1)
            end
            -- Boon upgrade point reward
            if tmpNode.nodeType == PSTExpNodeType.BOONUPGRADE then
                tmpExpedition.boonUpgradePoints = tmpExpedition.boonUpgradePoints + 1
            end
        end

        -- Final node completion
        local resetExped = false
        if tmpNode.nodeType == PSTExpNodeType.FINAL or not tmpExpedition.nodes[col + 1] then
            -- Unlock next depth
            if depth + 1 > PST.modData.expeditionDepth then
                PST.modData.expeditionDepth = depth + 1
            end
            resetExped = true
        end

        tmpNode.nodeType = PSTExpNodeType.COMPLETED
        if tmpExpedition.selectedNode and tmpExpedition.selectedNode.col == col and tmpExpedition.selectedNode.row == row then
            tmpExpedition.selectedNode = nil
        end

        if resetExped then
            PST:resetExpedition(depth)
        else
            PST:updateExpedAccess(depth)
        end
    end
end

function PST:expedLoseAttempt(depth)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition then
        tmpExpedition.attempts = math.max(0, tmpExpedition.attempts - 1)
        if tmpExpedition.attempts == 0 then
            -- All attempts lost, re-generate expedition, marking inaccessible nodes as 'dead', and completed nodes as no longer rewarding (with deathState property)
            local compNodes = {}
            local compCols = {}
            for _, tmpCol in ipairs(tmpExpedition.nodes) do
                for _, tmpNode in ipairs(tmpCol) do
                    if tmpNode.nodeType == PSTExpNodeType.COMPLETED then
                        table.insert(compNodes, tmpNode)
                        if not PST:arrHasValue(compCols, tmpNode.col) then
                            table.insert(compCols, tmpNode.col)
                        end
                    end
                end
            end

            local newExpedition = PST:generateExpedition(depth, tmpExpedition.seed)
            for _, tmpColNum in ipairs(compCols) do
                local tmpCol = newExpedition.nodes[tmpColNum]
                if tmpCol then
                    for _, tmpNode in ipairs(tmpCol) do
                        local completed = false
                        for _, compNode in ipairs(compNodes) do
                            if compNode.col == tmpNode.col and compNode.row == tmpNode.row then
                                tmpNode.rewardType = PSTExpNodeRewardType.NONE
                                completed = true
                                break
                            end
                        end
                        if not completed then
                            tmpNode.deathState = 1
                        end
                    end
                end
            end

            PST.expeditionsData[depth] = newExpedition
            PST:updateExpedAccess(depth)
        end
    end
end

-- Return description for the given expedition node's objective, comparing it to the expedition's selected node's progress
---@param nodeData PSTExpNode
---@param expData PSTExpedition
function PST:getExpNodeObjectiveDesc(nodeData, expData)
    if not nodeData.objective then return {} end

    local tmpDescription = {}
    local objectiveData = PST.expeditionObjectives[nodeData.objective.name]
    if not objectiveData then
        objectiveData = PST.expeditionObjectivesFinal[nodeData.objective.name]
    end
    if objectiveData then
        local tmpColor = PST.kcolors.EXPED_BLUE
        if nodeData.accessible == false then tmpColor = PST.kcolors.GRAY1 end

        local objProgress = 0
        if nodeData.nodeType == PSTExpNodeType.COMPLETED then
            objProgress = nodeData.objective.req
            tmpColor = PST.kcolors.TEAL1
        elseif expData.selectedNode then
            if expData.selectedNode.col == nodeData.col and expData.selectedNode.row == nodeData.row then
                objProgress = expData.selectedNode.objProgress
                if expData.selectedNode.objProgress >= nodeData.objective.req then
                    tmpColor = PST.kcolors.TEAL1
                end
            end
        end

        local progressStr = tostring(objProgress) .. "/" .. tostring(nodeData.objective.req)
        table.insert(tmpDescription, {"Objective:", tmpColor})
        if type(objectiveData.description) == "table" then
            for _, tmpLine in ipairs(objectiveData.description) do
                local formattedLine = PST:formatString(tmpLine, { progress = progressStr })
                table.insert(tmpDescription, {"   " .. formattedLine, tmpColor})
            end
        else
            local formattedLine = PST:formatString(objectiveData.description, { progress = progressStr })
            table.insert(tmpDescription, {"   " .. formattedLine, tmpColor})
        end
    end
    return tmpDescription
end

function PST:getExpedResetCost(depth)
    return math.min(500, depth * 40)
end

---@param nodeData PSTExpNode
---@param expData PSTExpedition
function PST:getExpNodeDescription(nodeData, expData)
    local tmpDescription = {}

    -- Objective
    if nodeData.objective and nodeData.objective.name then
        for _, tmpLine in ipairs(PST:getExpNodeObjectiveDesc(nodeData, expData)) do
            table.insert(tmpDescription, tmpLine)
        end
    end

    -- Curse of Shrouding
    local hasShrouding = PST:arrHasValue(expData.curses, 21)

    -- Curse
    if nodeData.curse then
        if not hasShrouding then
            local curseData = PST.expeditionCurses[nodeData.curse]
            if curseData then
                local tmpColor = PST.kcolors.RED3
                if nodeData.accessible == false then tmpColor = PST.kcolors.GRAY1 end
                table.insert(tmpDescription, {"Curse of " .. curseData.name .. ":", tmpColor})
                if type(curseData.description) == "table" then
                    for _, tmpLine in ipairs(curseData.description) do
                        local formattedDesc = PST:formatString(tmpLine, curseData.modsFunc(expData.depth))
                        table.insert(tmpDescription, {"   " .. formattedDesc, tmpColor})
                    end
                else
                    local formattedDesc = PST:formatString(curseData.description, curseData.modsFunc(expData.depth))
                    table.insert(tmpDescription, {"   " .. formattedDesc, tmpColor})
                end
            end
        else
            table.insert(tmpDescription, {"Unknown Curse (Shrouded)", PST.kcolors.PINK1})
        end
    end

    -- Reward
    if nodeData.rewardType ~= PSTExpNodeRewardType.NONE or nodeData.nodeType == PSTExpNodeType.BOONUPGRADE then
        local tmpColor = PST.kcolors.GREEN1
        if nodeData.accessible == false then tmpColor = PST.kcolors.GRAY1 end

        if not hasShrouding then
            table.insert(tmpDescription, {"Reward:", tmpColor})

            -- Reward: Boon
            if nodeData.rewardType == PSTExpNodeRewardType.BOON then
                local boonData = PST.expeditionBoons[nodeData.rewardData]
                if boonData then
                    table.insert(tmpDescription, {"   Gain Boon of " .. boonData.name .. ":", tmpColor})
                    if type(boonData.description) == "table" then
                        for _, tmpLine in ipairs(boonData.description) do
                            local formattedDesc = PST:formatString(tmpLine, boonData.mods)
                            table.insert(tmpDescription, {"      " .. formattedDesc, tmpColor})
                        end
                    else
                        local formattedDesc = PST:formatString(boonData.description, boonData.mods)
                        table.insert(tmpDescription, {"      " .. formattedDesc, tmpColor})
                    end
                end
            -- Reward: Obols
            elseif nodeData.rewardType == PSTExpNodeRewardType.OBOLS then
                table.insert(tmpDescription, {"   " .. tostring(nodeData.rewardData) .. " Arcane Obols", tmpColor})
            -- Reward: Exp
            elseif nodeData.rewardType == PSTExpNodeRewardType.EXP then
                table.insert(tmpDescription, {"   " .. tostring(nodeData.rewardData) .. " EXP", tmpColor})
            -- Reward: Attempts
            elseif nodeData.rewardType == PSTExpNodeRewardType.ATTEMPTS then
                table.insert(tmpDescription, {"   " .. tostring(nodeData.rewardData) .. " Expedition Attempt(s)", tmpColor})
            -- Reward: Item
            elseif nodeData.rewardType == PSTExpNodeRewardType.ITEM then
                local shownItem = false
                local itemCfg = Isaac.GetItemConfig():GetCollectible(nodeData.rewardData)
                if itemCfg then
                    local itemName = Isaac.GetLocalizedString("Items", itemCfg.Name, "en")
                    if itemName ~= "StringTable::InvalidKey" then
                        table.insert(tmpDescription, {"   Add " .. itemName .. " to this Expedition", tmpColor})
                        shownItem = true
                    end
                end
                if not shownItem then
                    table.insert(tmpDescription, {"   Add shown item to this Expedition", tmpColor})
                end
            -- Reward: Crimson starcore
            elseif nodeData.rewardType == PSTExpNodeRewardType.C_STARCORE then
                table.insert(tmpDescription, {"   +1 Crimson Starcore with " .. (PST:getCurrentCharName() or "the current character"), tmpColor})
            end
            -- Boon Upgrade node
            if nodeData.nodeType == PSTExpNodeType.BOONUPGRADE then
                table.insert(tmpDescription, {"   +1 Boon upgrade point", tmpColor})
            end
        else
            local tmpShroudColor = PST.kcolors.PINK1
            if nodeData.accessible == false then tmpShroudColor = tmpColor end
            table.insert(tmpDescription, {"Unknown Reward (Shrouded)", tmpShroudColor})
        end
    end
    -- Completed node
    if nodeData.nodeType == PSTExpNodeType.COMPLETED then
        table.insert(tmpDescription, {"Completed node.", PST.kcolors.TEAL1})
    end

    return tmpDescription
end

---@param expData PSTExpedition
function PST:getExpedCurseMods(expData)
    local curseMods = {}
    for _, curseID in ipairs(expData.curses) do
        local tmpCurse = PST.expeditionCurses[curseID]
        if tmpCurse then
            local tmpMods = tmpCurse.modsFunc(expData.depth)
            for tmpModName, tmpModVal in pairs(tmpMods) do
                if curseMods[tmpModName] == nil then
                    curseMods[tmpModName] = tmpModVal
                elseif type(curseMods[tmpModName]) == "number" then
                    curseMods[tmpModName] = curseMods[tmpModName] + tmpModVal
                end
            end
        end
    end
    return curseMods
end

include("scripts.expedition_data.ST_expedition_save")