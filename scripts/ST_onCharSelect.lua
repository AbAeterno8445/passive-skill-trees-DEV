-- On selecting a character in menu (uses completion mark render callback)
function SkillTrees:onCharSelect(_, _, _, charID)
	if MenuManager.GetActiveMenu() == MainMenuType.CHARACTER then
        local charName = SkillTrees.charNames[1 + charID]
		SkillTrees:charInit(charName)
        SkillTrees.selectedMenuChar = charID
	end
end