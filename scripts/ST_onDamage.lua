-- On entity damage
function PST:onDamage(target, damage, flag, source)
    local player = target:ToPlayer()
    local room = Game():GetRoom()
    local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)

    -- Player gets hit
    if player then
        -- Cosmic Realignment node
	    if PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON) then
            -- Samson, -0.15 damage when hit, up to -0.9
            if room:GetAliveEnemiesCount() > 0 and cosmicRCache.samsonDmg < 0.9 then
                cosmicRCache.samsonDmg = cosmicRCache.samsonDmg + 0.15
                PST:addModifiers({ damage = -0.15 }, true)
            end
        elseif PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON_B) then
            -- Tainted Samson, -5% all stats when hit, up to -20%
            if room:GetAliveEnemiesCount() > 0 and cosmicRCache.TSamsonBuffer > -20 then
                cosmicRCache.TSamsonBuffer = cosmicRCache.TSamsonBuffer - 5
                PST:save()
                player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
            end
        elseif PST:cosmicRCharPicked(PlayerType.PLAYER_EDEN_B) then
            -- Tainted Eden, shuffle stat reduction
            for stat, _ in pairs(cosmicRCache.TEdenDebuff) do
                cosmicRCache.TEdenDebuff[stat] = 0
            end
            for _=1,6 do
                local tmpStat = PST:getRandomStat()
                cosmicRCache.TEdenDebuff[tmpStat] = cosmicRCache.TEdenDebuff[tmpStat] - 0.1
            end
            local tmpStat = PST:getRandomStat()
            cosmicRCache.TEdenDebuff[tmpStat .. "Perc"] = math.floor(-25 * math.random())
            player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
        end
    else
        local tmpPlayer = Isaac.GetPlayer()
        -- Cosmic Realignment node
        if PST:cosmicRCharPicked(PlayerType.PLAYER_AZAZEL_B) then
            -- Tainted Azazel, -40% damage dealt to enemies far away from you, based on your range stat
            local dist = math.sqrt((tmpPlayer.Position.X - target.Position.X) ^ 2 + (tmpPlayer.Position.Y - target.Position.Y) ^ 2)
            if dist > tmpPlayer.TearRange * 0.4 then
                return { Damage = damage * 0.6 }
            end
        end
    end

    -- Enemy dies
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

        -- Cosmic Realignment node
        if PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON_B) then
            local tmpPlayer = Isaac.GetPlayer()
            -- Tainted Samson, +2% all stats when killing a monster, up to 10%
            if cosmicRCache.TSamsonBuffer < 10 then
                cosmicRCache.TSamsonBuffer = cosmicRCache.TSamsonBuffer + 2
                PST:save()
                tmpPlayer:AddCacheFlags(CacheFlag.CACHE_ALL, true)
            end
        end
    end
end