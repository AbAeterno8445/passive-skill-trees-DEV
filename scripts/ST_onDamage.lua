-- On entity damage
function SkillTrees:onDamage(target, damage, flag, source)
	if target:IsVulnerableEnemy() and target:IsActiveEnemy() and target.HitPoints <= damage then
        local addXP = false
		if target.SpawnerType ~= 0 then
			if SkillTrees.modData.spawnKills < 10 then
				SkillTrees.modData.spawnKills = SkillTrees.modData.spawnKills + 1
                addXP = true
			end
		else
            addXP = true
		end

        if addXP then
            local mult = 1
            if target:IsBoss() then
                mult = mult + SkillTrees:getTreeSnapshotMod("xpgainBoss", 0) / 100
            else
                mult = mult + SkillTrees:getTreeSnapshotMod("xpgainNormalMob", 0) / 100
            end
            SkillTrees:addTempXP(math.max(1, math.floor(mult * target.MaxHitPoints / 2)), true)
        end
    end
end