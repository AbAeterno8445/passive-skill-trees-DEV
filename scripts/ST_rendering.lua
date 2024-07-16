local floatingTexts = {}
local floatTextDelayDefault = 30
local floatTextDelay = 0
local floatTextQueue = {}

-- Create a floating fading text
---@param text string -- Text to display
---@param position Vector -- Text position
---@param color Color -- Text color
---@param speed number -- How quickly the text rises up in pixels per frame
---@param totalSteps number -- How many frames the text lasts. Used for fading effect
---@param playerRelative boolean -- Whether the text should stick to the player. If true, the position vector becomes relative to the player
function SkillTrees:createFloatTextFX(text, position, color, speed, totalSteps, playerRelative)
	local tmpText = {
		text = text,
		position = position,
		color = color,
		startAlpha = color.A,
		speed = speed,
		totalSteps = totalSteps,
		playerRelative = playerRelative,
		step = 0
	}
    if floatTextDelay == 0 then
	    table.insert(floatingTexts, tmpText)
        floatTextDelay = floatTextDelayDefault
    else
        table.insert(floatTextQueue, tmpText)
    end
end

-- XP bar setup
local barWidth = 256
local xpbarSprite = Sprite("gfx/ui/skilltrees/xp_bar.anm2", true)
local xpbarFullSprite = Sprite("gfx/ui/skilltrees/xp_bar.anm2", true)
local xpbarTempSprite = Sprite("gfx/ui/skilltrees/xp_bar.anm2", true)
xpbarSprite.Color.A = 0.7
xpbarFullSprite.Color.A = 0.7
xpbarTempSprite.Color.A = 0.7
xpbarSprite:Play("BarEmpty", true)
xpbarFullSprite:Play("BarFull", true)
xpbarTempSprite:Play("BarTemp", true)

-- Rendering function
function SkillTrees:Render()
	local screenRatioX = Isaac.GetScreenWidth() / 480
	local screenRatioY = Isaac.GetScreenHeight() / 270

	-- XP bar
	local charData = SkillTrees:getCurrentCharData()

	local barPos = Vector(112 * screenRatioX, Isaac.GetScreenHeight() - 12)
	local barPercent = math.min(1, charData.xp / math.max(1, charData.xpRequired))
	local barScale = Vector(screenRatioX, math.min(1, screenRatioY))

	xpbarSprite.Scale = barScale
	xpbarSprite:Render(barPos)

	if SkillTrees.modData.xpObtained > 0 then
		local tempBarPercent = math.min(1, (charData.xp + SkillTrees.modData.xpObtained) / math.max(1, charData.xpRequired))
		xpbarTempSprite.Scale = barScale
		xpbarTempSprite:Render(barPos, Vector(barWidth * tempBarPercent, 32), Vector(barWidth, 16))
	end

	if charData.xp > 0 then
		xpbarFullSprite.Scale = barScale
		xpbarFullSprite:Render(barPos, Vector(barWidth * barPercent, 16), Vector(barWidth, 16))
	end

	-- Level text
	local levelStr = "LV " .. charData.level
	Isaac.RenderText(levelStr, barPos.X - (3 + string.len(levelStr) * 8) * screenRatioX, barPos.Y - 6, 1, 1, 1, 0.7)

	-- Manage floating texts
    if floatTextDelay > 0 then
        floatTextDelay = floatTextDelay - 1
    elseif floatTextDelay == 0 and #floatTextQueue > 0 then
        table.insert(floatingTexts, floatTextQueue[1])
        table.remove(floatTextQueue, 1)
        floatTextDelay = floatTextDelayDefault
    end

	if #floatingTexts > 0 then
		local player = Isaac.GetPlayer()
		local room = Game():GetRoom()

        for i = #floatingTexts, 1, -1 do
            local textFX = floatingTexts[i]
            local textX = textFX.position.X
            local textY = textFX.position.Y
            if textFX.playerRelative then
                textX = room:WorldToScreenPosition(Vector(player.Position.X, player.Position.Y)).X + textFX.position.X
                textY = room:WorldToScreenPosition(Vector(player.Position.X, player.Position.Y)).Y + textFX.position.Y
            end

            textY = textY - textFX.step * textFX.speed

            Isaac.RenderText(
                textFX.text,
                textX,
                textY,
                textFX.color.R,
                textFX.color.G,
                textFX.color.B,
                textFX.color.A - textFX.startAlpha * textFX.step / textFX.totalSteps
            )

            textFX.step = textFX.step + 1
            if textFX.step >= textFX.totalSteps then
                table.remove(floatingTexts, i)
            end
		end
    end
end