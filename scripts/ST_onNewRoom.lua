-- On new room
function SkillTrees:onNewRoom()
	SkillTrees.modData.spawnKills = 0
	SkillTrees.modData.xpObtained = 0
	floatingTexts = {}

	-- First room entry XP reward
	--[[local room = Game():GetRoom()
	local floorNum = Game():GetLevel():GetStage()
	if room:IsFirstVisit() then
		if room:GetType() == RoomType.ROOM_SECRET then
			SkillTrees:addXP(40 + 20 * floorNum)
		elseif room:GetType() == RoomType.ROOM_SUPERSECRET then
			SkillTrees:addXP(50 + 30 * floorNum)
		elseif room:GetType() == RoomType.ROOM_ULTRASECRET then
			SkillTrees:addXP(90 + 50 * floorNum)
		end
	end]]
end