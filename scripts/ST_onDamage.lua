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
            SkillTrees:addTempXP(math.max(1, math.floor(target.MaxHitPoints / 2)), true)
        end
    end
end