-- On entity damage
function PST:onDamage(target, damage, flag, source)
    local player = target:ToPlayer()
    -- Player gets hit
    if player then
        -- Cosmic Realignment node
        local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
	    if PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON) then
            -- Samson, -0.15 damage when hit, up to -0.9
            if cosmicRCache.samsonDmg < 0.9 then
                cosmicRCache.samsonDmg = cosmicRCache.samsonDmg + 0.15
                PST:addModifiers({ damage = -0.15 }, true)
            end
        end
    end

    -- Enemy kill
	if target:IsVulnerableEnemy() and target:IsActiveEnemy() and target.HitPoints <= damage then
        local addXP = false
		if target.SpawnerType ~= 0 then
			if PST.modData.spawnKills < 10 then
				PST.modData.spawnKills = PST.modData.spawnKills + 1
                addXP = true
			end
		else
            addXP = true
		end

        if addXP then
            local mult = 1
            if target:IsBoss() then
                mult = mult + PST:getTreeSnapshotMod("xpgainBoss", 0) / 100
            else
                mult = mult + PST:getTreeSnapshotMod("xpgainNormalMob", 0) / 100
            end
            PST:addTempXP(math.max(1, math.floor(mult * target.MaxHitPoints / 2)), true)
        end
    end
end