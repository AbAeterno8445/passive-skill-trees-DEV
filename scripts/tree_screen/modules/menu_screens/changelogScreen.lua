local changelogScreen = {}

---@param tScreen PST.treeScreen
function changelogScreen:Render(tScreen, menuModule)
    tScreen:DrawNodeBox("CHANGELOG (Press Menu Back or Shift + C to close)", PST:getChangelogList(), 8, 8 + menuModule.menuScrollY, true, 1)
end

return changelogScreen