-- Implicit modifiers applied to Astral Expeditions 
function PST:getExpeditionImplicits(depth)
    -- Only implicits starting with "expedImp_" get added to the run snapshot
    local implicits = {}

    -- Starmight requirement
    implicits.starmightReq = math.min(600, depth * 30)
    -- Depths 2+ monster HP
    if depth >= 2 then
        -- Non-boss HP
        implicits.expedImp_mobHP = math.min(25, 4 + (depth - 2) * 2)
        if depth > 15 then
            implicits.expedImp_mobHP = math.min(60, implicits.expedImp_mobHP + math.floor((depth - 15) / 2))
        end

        -- Boss HP
        implicits.expedImp_bossHP = math.min(60, 10 + (depth - 2) * 3)
        if depth > 15 then
            implicits.expedImp_bossHP = math.min(120, implicits.expedImp_bossHP + math.floor((depth - 15) / 2))
        end
    end
    -- Depths 3+ monster speed
    if depth >= 3 then
        implicits.expedImp_mobSpeed = math.min(25, math.floor(depth / 3) * 2)
    end
    -- Depths 4+ chance to receive a curse when entering a floor
    if depth >= 4 then
        implicits.expedImp_floorCurse = math.min(30, depth - 3)
    end
    -- Depths 6+ coin, key, bomb, heart scarcity
    if depth >= 6 then
        implicits.expedImp_pickupScarcity = math.min(25, depth - 3)
    end
    -- Depths 8+ remove random quality 4 items from the pool when starting a run
    if depth >= 8 then
        implicits.expedImp_quality4Remove = math.min(15, math.floor((depth - 6) / 2))
    end
    -- Depths 10 & 20, start with an additional broken heart, and heartbreak can no longer show up
    if depth >= 10 then
        implicits.expedImp_heartbreak = 1
        if depth >= 20 then implicits.expedImp_heartbreak = 2 end
    end
    -- -expedition starting attempts
    local lessAttemptsList = {5, 10, 15, 25, 40}
    for _, tmpThreshold in ipairs(lessAttemptsList) do
        if depth >= tmpThreshold then
            if not implicits.lessAttempts then implicits.lessAttempts = 0 end
            implicits.lessAttempts = implicits.lessAttempts + 1
        end
    end
    -- Depths 15+ boss damage reduction
    if depth >= 15 then
        implicits.expedImp_mobDmgRed = math.min(40, math.floor((depth - 14) * 1.25))
    end
    return implicits
end

-- Include generator versions
include("scripts.expedition_data.generators.ST_expedition_generator_v1")
include("scripts.expedition_data.generators.ST_expedition_generator_v2")
include("scripts.expedition_data.generators.ST_expedition_generator_v3")
include("scripts.expedition_data.generators.ST_uber_generator_v1")
include("scripts.expedition_data.generators.ST_uber_generator_v2")
include("scripts.expedition_data.generators.ST_uber_generator_v3")

PST.expedGeneratorVersion = 3
PST.uberExpedGeneratorVersion = 3

-- List of expedition-altering mods present in the Deep-Space skill tree's nodes (within Star Tree)
local deepSpaceTreeMods = {
    "expedChoiceAdd", "orderGain", "entropicTradeoff", "bringTheOrder", "eldritchExchange"
}

-- Generate expedition, using either the given version or the latest one for generation
function PST:generateExpedition(depth, seed, version, uber, modifiers)
    local expedGenerators = {
        PST.generateExpeditionV1,
        PST.generateExpeditionV2,
        PST.generateExpeditionV3
    }
    local expedVer = version or PST.expedGeneratorVersion
    if uber then
        expedGenerators = {
            PST.generateUberExpeditionV1,
            PST.generateUberExpeditionV2,
            PST.generateUberExpeditionV3
        }
        expedVer = version or PST.uberExpedGeneratorVersion

        -- Add Deep-Space skill tree mods
        if not modifiers then
            modifiers = {}
            for tmpModName, tmpModVal in pairs(PST:getAllTreeMods("starTree")) do
                if PST:arrHasValue(deepSpaceTreeMods, tmpModName) then
                    modifiers[tmpModName] = tmpModVal
                end
            end
        end
    end
    return expedGenerators[expedVer](PST, depth, seed, modifiers)
end

-- Update nodes' accessibility in expedition
function PST:updateExpedAccess(depth, uber)
    local tmpExpedition = PST.expeditionsData[depth]
    if uber then
        tmpExpedition = PST.uberExpeditionsData[depth]
    end
    if tmpExpedition then
        -- Set all incomplete nodes as inaccessible, and track completed nodes
        local completed = 0
        local completedCols = {}
        for col, tmpCol in ipairs(tmpExpedition.nodes) do
            for _, tmpNode in ipairs(tmpCol) do
                if tmpNode.nodeType ~= PSTExpNodeType.COMPLETED and tmpNode.nodeType ~= PSTExpNodeType.ASTROLABE and
                tmpNode.nodeType ~= PSTExpNodeType.FINAL then
                    tmpNode.accessible = false
                elseif tmpNode.nodeType == PSTExpNodeType.COMPLETED then
                    completed = completed + 1
                    table.insert(completedCols, col)
                    tmpNode.accessible = nil
                end
                tmpNode.selectable = nil
                tmpNode.queuable = nil
            end
        end

        if completed == 0 then
            -- No completed nodes, set everything back to accessible
            for col, tmpCol in ipairs(tmpExpedition.nodes) do
                for _, tmpNode in ipairs(tmpCol) do
                    if not tmpNode.deathState then
                        tmpNode.accessible = nil
                        if col == 2 then
                            -- Selectable nodes after astrolabe
                            tmpNode.selectable = true
                        end
                    end
                end
            end
        else
            -- Travel through completed nodes, setting connected nodes as accessible
            local nodeCheckList = {}
            for col, tmpCol in ipairs(tmpExpedition.nodes) do
                for row, tmpNode in ipairs(tmpCol) do
                    local isCheckNode = false
                    for _, tmpCheck in ipairs(nodeCheckList) do
                        if tmpCheck[1] == col and tmpCheck[2] == row then
                            isCheckNode = true
                            break
                        end
                    end
                    if tmpNode.nodeType ~= PSTExpNodeType.ASTROLABE and (tmpNode.nodeType == PSTExpNodeType.COMPLETED or isCheckNode) then
                        tmpNode.accessible = nil
                        if not PST:arrHasValue(completedCols, col + 1) then
                            for _, adjNode in ipairs(tmpNode.connections) do
                                local targetNode = tmpExpedition.nodes[col + 1][adjNode]
                                if targetNode then
                                    if tmpNode.nodeType == PSTExpNodeType.COMPLETED then
                                        targetNode.selectable = true
                                    end
                                    table.insert(nodeCheckList, {col + 1, adjNode})
                                end
                            end
                        end
                    end
                end
            end
        end

        -- Queuable nodes if a selected node is present
        local lastQueueNode = nil
        if tmpExpedition.selectedNode and tmpExpedition.selectedNode.col < #tmpExpedition.nodes then
            local selCol = tmpExpedition.selectedNode.col
            local selRow = tmpExpedition.selectedNode.row
            lastQueueNode = tmpExpedition.nodes[selCol][selRow]

            if tmpExpedition.nodeQueue and #tmpExpedition.nodeQueue > 0 then
                local queuePos = tmpExpedition.nodeQueue[#tmpExpedition.nodeQueue]
                lastQueueNode = tmpExpedition.nodes[queuePos[1]][queuePos[2]]
            end
        end
        if lastQueueNode then
            for _, adjNode in ipairs(lastQueueNode.connections) do
                local targetNode = tmpExpedition.nodes[lastQueueNode.col + 1][adjNode]
                if targetNode and targetNode.nodeType ~= PSTExpNodeType.REWARD then
                    targetNode.queuable = true
                end
            end
        end
    end
end