local sfx = SFXManager()

-- Get current char name (different to EntityPlayer's GetName() func as it uses a custom name table)
function SkillTrees:getCurrentCharName()
	return SkillTrees.charNames[1 + Isaac.GetPlayer():GetPlayerType()]
end

-- Add temporary XP (gets converted to normal xp once room is cleared)
---@param xp number Amount of XP to add
---@param showText? boolean Whether to display the +xp floating text
function SkillTrees:addTempXP(xp, showText)
    local xpMult = 1 + SkillTrees:getTreeSnapshotMod("xpgain", 0) / 100

	-- Extra challenge room XP gain mod
	local room = Game():GetRoom()
	if room:GetType() == RoomType.ROOM_CHALLENGE then
		xpMult = xpMult + SkillTrees:getTreeSnapshotMod("challengeXPgain", 0) / 100
	end

	-- Quick wit mod
	local quickWitMod = SkillTrees:getTreeSnapshotMod("quickWit", {0, 0})
	local quickWitTime = SkillTrees.specialNodes.quickWit.startTime
	if quickWitTime ~= 0 then
		local timeDiff = os.clock() - quickWitTime
		local quickWitMult = quickWitMod[1] / 100
		if timeDiff > 8 then
			local tmpProgress = math.abs(quickWitMod[2] - quickWitMod[1]) * ((timeDiff - 8) / 10)
			quickWitMult = (math.max(quickWitMod[2], quickWitMod[1] - tmpProgress)) / 100
		end
		xpMult = xpMult + quickWitMult
	end

	local xpGain = xp * xpMult
	SkillTrees.modData.xpObtained = SkillTrees.modData.xpObtained + xpGain
	if showText then
        local xpStr = string.format("+%.2f xp", xpGain)
        if xpGain % 1 == 0 then
            xpStr = string.format("+%d xp", xpGain)
        end
		SkillTrees:createFloatTextFX(xpStr, Vector(0, 0), Color(0.58, 0, 0.83, 0.7), 0.14, 60, true)
	end
end

-- Add XP
---@param xp number Amount of XP to add
---@param showText? boolean Whether to display the +xp floating text
function SkillTrees:addXP(xp, showText)
	local charData = SkillTrees:getCurrentCharData()
	charData.xp = math.max(0, charData.xp + xp)
	if showText then
        local xpStr = string.format("+%.2f xp", xp)
        if xp % 1 == 0 then
            xpStr = string.format("+%d xp", xp)
        end
		SkillTrees:createFloatTextFX(xpStr, Vector(0, 0), Color(0.58, 0, 0.83, 0.7), 0.14, 60, true)
	end

	-- Level up
	if charData.xp >= charData.xpRequired then
		local currentChar = SkillTrees:getCurrentCharName()

		sfx:Play(SoundEffect.SOUND_CHOIR_UNLOCK)
		charData.level = charData.level + 1
		charData.skillPoints = SkillTrees.modData.charData[currentChar].skillPoints + 1
		SkillTrees.modData.skillPoints = SkillTrees.modData.skillPoints + 1

		local xpRemaining = charData.xp - charData.xpRequired

		-- Next level xp requirement formula
		charData.xpRequired = math.ceil(SkillTrees.startXPRequired * (charData.level ^ 1.1))

		-- Add overflowing xp to next level, capped at 50%
		charData.xp = math.min(math.floor(charData.xpRequired * 0.5), xpRemaining)

		SkillTrees:createFloatTextFX("Level up!", Vector(0, 0), Color(1, 1, 1, 0.7), 0.17, 100, true)
	end
end

-- Get tree modifier (pre-run tree)
---@return any
function SkillTrees:getTreeMod(modName, default)
	if SkillTrees.modData.treeMods[modName] == nil then
		return default
	end
	return SkillTrees.modData.treeMods[modName]
end

-- Get current snapshot tree modifier
---@return any
function SkillTrees:getTreeSnapshotMod(modName, default)
    if SkillTrees.modData.treeModSnapshot == nil then
        return default
    end
    return SkillTrees.modData.treeModSnapshot[modName]
end