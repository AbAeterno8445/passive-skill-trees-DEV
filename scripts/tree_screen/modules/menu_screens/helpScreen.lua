local helpButtonCols = 6

local helpScreen = {
    currentPage = 0,
    selectedButton = 1,

    helpButtonSprite = Sprite("gfx/ui/skilltrees/helpmenu/help_button.anm2", true),
    helpScreenSprite = Sprite("gfx/ui/skilltrees/helpmenu/help_screens.anm2", true),

    pages = {
        "1.1", "1.2", "1.3", "1.4",
        "2.1", "2.2",
        "3.1", "3.2",
        "4.1", "4.2", "4.3",
        "5.1", "5.2", "5.3", "5.4", "5.5", "5.6", "5.7"
    },
    helpButtons = {
        {
            title = "Intro",
            number = 1,
            iconID = 0,
            targetPage = "1.1"
        },
        {
            title = "Controls",
            number = 2,
            iconID = 1,
            targetPage = "2.1"
        },
        {
            title = "Data Safety",
            number = 3,
            iconID = 2,
            targetPage = "3.1"
        },
        {
            title = "Nodes/Respecs",
            number = 4,
            iconID = 3,
            targetPage = "4.1"
        },
        {
            title = "Star Tree",
            number = 5,
            iconID = 4,
            targetPage = "5.1"
        }
    }
}

-- Init
helpScreen.helpScreenSprite:Play("Default", true)

function helpScreen:GetMenuPos()
    local screenScale = 1 / Isaac.GetScreenPointScale()
    return Vector(
        math.max(0, (Isaac.GetScreenWidth() - 470 * screenScale) / 2),
        math.max(0, (Isaac.GetScreenHeight() - 280 * screenScale) / 2)
    )
end

function helpScreen:GetMenuScale()
    local screenScale = 1 / Isaac.GetScreenPointScale()
    return Vector(screenScale, screenScale)
end

---@param targetPage number
function helpScreen:SwitchPage(targetPage)
    self.currentPage = targetPage
    if self.currentPage == 0 then
        self.helpScreenSprite:ReplaceSpritesheet(0, "gfx/ui/skilltrees/helpmenu/screens/help_main.png", true)
    else
        local tPage = self.pages[self.currentPage]
        if tPage then
            self.helpScreenSprite:ReplaceSpritesheet(0, "gfx/ui/skilltrees/helpmenu/screens/help" .. tPage .. ".png", true)
        else
            self:SwitchPage(0)
        end
    end
end

function helpScreen:OnOpen()
    SFXManager():Play(SoundEffect.SOUND_PAPER_IN)
    self.helpScreenSprite.Scale = self:GetMenuScale()
    self.helpButtonSprite.Scale = self:GetMenuScale()
end

function helpScreen:OnClose(menuScreensModule)
    if self.currentPage ~= 0 then
        SFXManager():Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12, 0.5)
        self:SwitchPage(0)
    else
        SFXManager():Play(SoundEffect.SOUND_PAPER_OUT, 0.5)
        menuScreensModule:CloseMenu()
    end
end

function helpScreen:OnInput()
    if self.currentPage == 0 then
        -- Menu buttons selection
        if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT) then
            self.selectedButton = self.selectedButton - 1
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT) then
            self.selectedButton = self.selectedButton + 1
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_UP) then
            self.selectedButton = self.selectedButton - helpButtonCols
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_DOWN) then
            self.selectedButton = self.selectedButton + helpButtonCols
        end
        self.selectedButton = math.max(1, math.min(#self.helpButtons, self.selectedButton))

        -- Button press
        if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
            local selButton = self.helpButtons[self.selectedButton]
            if selButton then
                for i, page in ipairs(self.pages) do
                    if page == selButton.targetPage then
                        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                        self:SwitchPage(i)
                        break
                    end
                end
            end
        end
    else
        -- Page switching
        local targetPage = self.currentPage
        if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT) then
            targetPage = targetPage - 1
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT) then
            targetPage = targetPage + 1
        end
        targetPage = math.max(1, math.min(#self.pages, targetPage))
        if targetPage ~= self.currentPage then
            SFXManager():Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12, 0.5)
            self:SwitchPage(targetPage)
        end
    end
end

---@param tScreen PST.treeScreen
function helpScreen:Render(tScreen)
    if tScreen.resized then
        self.helpScreenSprite.Scale = self:GetMenuScale()
        self.helpButtonSprite.Scale = self:GetMenuScale()
    end

    local renderPos = self:GetMenuPos()
    self.helpScreenSprite:Render(renderPos)

    if self.currentPage == 0 then
        -- Main help page buttons
        for i, tmpButton in ipairs(self.helpButtons) do
            local screenScale = 1 / Isaac.GetScreenPointScale()

            local buttonX = renderPos.X + (16 + ((i - 1) % helpButtonCols) * (456 / helpButtonCols)) * screenScale
            local buttonY = renderPos.Y + (62 + math.floor((i - 1) / helpButtonCols) * 80) * screenScale
            local buttonFrame = 0
            if self.selectedButton == i then buttonFrame = 1 end
            self.helpButtonSprite:SetFrame("Default", buttonFrame)
            self.helpButtonSprite:Render(Vector(buttonX, buttonY))

            -- Icon
            if tmpButton.iconID ~= nil then
                self.helpButtonSprite:SetFrame("Icons", tmpButton.iconID)
                self.helpButtonSprite:Render(Vector(buttonX + 3 * screenScale, buttonY + 3 * screenScale))
            end

            -- Draw help category number
            local textScale = Vector(screenScale, screenScale)
            local numPosX = buttonX + (19 - PST.luaminiFont:GetStringWidth(tostring(tmpButton.number)) / 2) * screenScale
            local numPosY = buttonY + 33 * screenScale
            PST.luaminiFont:DrawStringScaled(tostring(tmpButton.number), numPosX, numPosY, textScale.X, textScale.Y, KColor(1, 1, 1, 1))

            -- Draw title
            local titlePosX = buttonX + (19 - PST.miniFont:GetStringWidth(tmpButton.title) / 2) * screenScale
            local titlePosY = buttonY + 50 * screenScale
            PST.miniFont:DrawStringScaled(tmpButton.title, titlePosX, titlePosY, textScale.X, textScale.Y, KColor(1, 1, 1, 1))
        end
    else
        -- Decor icons for pages
        local pageName = self.pages[self.currentPage]
        if pageName then
            local buttonID = tonumber(pageName:sub(1, 1))
            if buttonID then
                local tmpButton = self.helpButtons[buttonID]
                if tmpButton and tmpButton.iconID then
                    local menuScale = self:GetMenuScale()
                    self.helpButtonSprite.Scale = menuScale * 0.82
                    self.helpButtonSprite:SetFrame("Icons", tmpButton.iconID)
                    self.helpButtonSprite:Render(renderPos)
                    self.helpButtonSprite:Render(Vector(renderPos.X + 454 * menuScale.X, renderPos.Y))
                    self.helpButtonSprite.Scale = menuScale
                end
            end
        end
    end
end

return helpScreen