local floatingTexts = {}
local floatTextDelayDefault = 22
local floatTextDelay = 0
local floatTextQueue = {}

function PST:resetFloatingTexts()
	floatingTexts = {}
	floatTextQueue = {}
end

local miniFont = Font()
miniFont:Load("font/cjk/lanapixel.fnt")

-- Create a floating fading text
---@param text string -- Text to display
---@param position Vector -- Text position
---@param color Color -- Text color
---@param speed number -- How quickly the text rises up in pixels per frame
---@param totalSteps number -- How many frames the text lasts. Used for fading effect
---@param playerRelative boolean -- Whether the text should stick to the player. If true, the position vector becomes relative to the player
function PST:createFloatTextFX(text, position, color, speed, totalSteps, playerRelative)
	if not PST.config.floatingTexts then return end

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

local chroniclerUISprite = Sprite("gfx/items/starcursed_jewels.anm2", true)
chroniclerUISprite:Play("Chronicler UI", true)

-- Rendering function
function PST:Render()
	local screenRatioX = Isaac.GetScreenWidth() / 480
	local screenRatioY = Isaac.GetScreenHeight() / 270

	local room = PST:getRoom()
	local gamePaused = Game():IsPaused()

	-- XP bar
	local hudVisible = Game():GetHUD():IsVisible()
	if PST.config.drawXPbar and hudVisible then
		local charData = PST:getCurrentCharData()
		if charData then
			local barPos = Vector(112 * screenRatioX, Isaac.GetScreenHeight() - 12)
			local barPercent = math.min(1, charData.xp / math.max(1, charData.xpRequired))
			local barScale = Vector(screenRatioX, math.min(1, screenRatioY))

			xpbarSprite.Scale = barScale
			xpbarSprite:Render(barPos)

			if PST.modData.xpObtained > 0 then
				local tempBarPercent = math.min(1, (charData.xp + PST.modData.xpObtained) / math.max(1, charData.xpRequired))
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
		end
	end

	-- Quick wit mod
	local quickWitMod = PST:getTreeSnapshotMod("quickWit", {0, 0})
	local hasQuickWit = quickWitMod[1] ~= 0 or quickWitMod[2] ~= 0

	-- Pause quick wit
	local roomType = room:GetType()
	if hasQuickWit and roomType ~= RoomType.ROOM_BOSS and roomType ~= RoomType.ROOM_BOSSRUSH then
		local quickWitData = PST.specialNodes.quickWit
		if gamePaused then
			if quickWitData.pauseTime == 0 then
				quickWitData.pauseTime = os.clock()
			end
		elseif quickWitData.pauseTime > 0 then
			quickWitData.startTime = quickWitData.startTime + os.clock() - quickWitData.pauseTime
			quickWitData.pauseTime = 0
		end
	end

	-- Ancient starcursed jewel: Chronicler Stone UI
	if hudVisible then
		if PST:SC_getSnapshotMod("chroniclerStone", false) then
			local remaining = math.max(0, PST:getTreeSnapshotMod("SC_chroniclerRooms", 0))
			local tmpColor = KColor(1, 0.6, 0.6, 1)
			if remaining == 0 then
				tmpColor = KColor(0.6, 0.9, 1, 1)
			end

			local drawX = 16 * screenRatioX
			local drawY = Isaac.GetScreenHeight() - 16 * screenRatioY
			chroniclerUISprite:Render(Vector(drawX, drawY))
			miniFont:DrawString(tostring(remaining), drawX + 7 * screenRatioX, drawY - 6 * screenRatioY, tmpColor)
		end
	end

	-- Manage floating texts
    if floatTextDelay > 0 then
        floatTextDelay = floatTextDelay - 1
    elseif floatTextDelay == 0 and #floatTextQueue > 0 then
        table.insert(floatingTexts, floatTextQueue[1])
        table.remove(floatTextQueue, 1)
        floatTextDelay = floatTextDelayDefault
    end

	if #floatingTexts > 0 then
		local player = PST:getPlayer()
        for i = #floatingTexts, 1, -1 do
            local textFX = floatingTexts[i]
            local textX = textFX.position.X
            local textY = textFX.position.Y
            if textFX.playerRelative then
				local worldPos
				if not room:IsMirrorWorld() then
					worldPos = room:WorldToScreenPosition(Vector(player.Position.X, player.Position.Y))
				else
					-- Calculate diametric opposite X if in mirror world
					local newX = room:GetCenterPos().X - (player.Position.X - room:GetCenterPos().X)
					worldPos = room:WorldToScreenPosition(Vector(newX, player.Position.Y))
				end
                textX = worldPos.X + textFX.position.X - string.len(textFX.text) * 3
                textY = worldPos.Y + textFX.position.Y - 40
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