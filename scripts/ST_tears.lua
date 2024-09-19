---@param tear EntityTear
function PST:postFireTear(tear)
    -- Mod: % chance for fired tears to be coin tears from Head of the Keeper
    local tmpMod = PST:getTreeSnapshotMod("coinTearsChance", 0)
    if tmpMod > 0 and tear.Variant ~= TearVariant.COIN and 100 * math.random() < tmpMod then
        tear:ChangeVariant(TearVariant.COIN)
        tear:AddTearFlags(TearFlags.TEAR_GREED_COIN)
    end
end

function PST:onTearDeath(tear)
    -- Starcursed modifier: tear explosion on mob death
    if PST:arrHasValue(PST.specialNodes.SC_exploderTears, tear.InitSeed) then
        local tmpMod = PST:SC_getSnapshotMod("tearExplosionOnDeath", {0, 0})
        if tmpMod[2] > 0 then
            local tmpSpeed = 6
            local tmpColor = Color(1, 0.1, 0.1, 1)
            for i=1,tmpMod[2] do
                local tmpAng = ((2 * math.pi) / tmpMod[2]) * (i - 1)
                local tmpVel = Vector(tmpSpeed * math.cos(tmpAng), tmpSpeed * math.sin(tmpAng))
                local newTear = Game():Spawn(
                    EntityType.ENTITY_PROJECTILE,
                    ProjectileVariant.PROJECTILE_TEAR,
                    tear.Position,
                    tmpVel,
                    tear.SpawnerEntity,
                    0,
                    Random() + 1
                )
                newTear.Color = tmpColor
                newTear:ToProjectile().FallingAccel = 0.45
            end
        end
    end
end