PST.config = {
    -- Draw level and XP bar at the bottom of the screen during gameplay
    drawXPbar = true,

    -- Draw floating texts during gameplay (e.g. xp gain, +1 respec, certain node effects, etc.)
    floatingTexts = true,

    -- Draw selected character level info at the bottom of the screen during character selection
    charSelectInfoText = true,

    -- Draw tree opening controls text on pause menu
    drawPauseText = true,

    -- Whether tree mods are applied in challenges
    treeOnChallenges = false,

    -- XP multiplier option
    xpMult = 1,

    -- Make changelog pop up when on new version updates
    changelogPopup = true,

    -- Keybinds for mod actions. Available options:
    -- shift: true, requires shift to be held during keyboard press. If not set or false, key won't fire if shift is pressed
    -- ctrl: true, requires ctrl to be held during keyboard press. If not set or false, key won't fire if ctrl is pressed
    -- actionItem: requires actionItem to be held during controller press
    -- allowShift: allows pressing key while shift is held
    -- allowCtrl: allows pressing key while ctrl is held
    -- allowActionItem: allows triggering action while actionItem is held
    keybinds = {
        openTree = {
            keyboardButton = Keyboard.KEY_V,
            controllerAction = ButtonAction.ACTION_MENULT,
        },
        closeTree = {
            keyboardButton = Keyboard.KEY_ESCAPE,
            controllerAction = ButtonAction.ACTION_MENUBACK
        },
        allocateNode = {
            keyboardButton = Keyboard.KEY_E,
            controllerAction = ButtonAction.ACTION_MENUCONFIRM
        },
        respecNode = {
            keyboardButton = Keyboard.KEY_R,
            controllerAction = ButtonAction.ACTION_MENUCONFIRM,
            actionItem = true
        },
        treePanLeft = {
            keyboardButton = {Keyboard.KEY_A, Keyboard.KEY_LEFT},
            allowShift = true,
            controllerAction = ButtonAction.ACTION_MENULEFT,
            allowActionItem = true
        },
        treePanRight = {
            keyboardButton = {Keyboard.KEY_D, Keyboard.KEY_RIGHT},
            allowShift = true,
            controllerAction = ButtonAction.ACTION_MENURIGHT,
            allowActionItem = true
        },
        treePanUp = {
            keyboardButton = {Keyboard.KEY_W, Keyboard.KEY_UP},
            allowShift = true,
            controllerAction = ButtonAction.ACTION_MENUUP,
            allowActionItem = true
        },
        treePanDown = {
            keyboardButton = {Keyboard.KEY_S, Keyboard.KEY_DOWN},
            allowShift = true,
            controllerAction = ButtonAction.ACTION_MENUDOWN,
            allowActionItem = true
        },
        centerCamera = {
            keyboardButton = Keyboard.KEY_V,
            shift = true,
            controllerAction = ButtonAction.ACTION_MENURT
        },
        panFaster = {
            keyboardButton = {Keyboard.KEY_LEFT_SHIFT, Keyboard.KEY_RIGHT_SHIFT},
            allowShift = true,
            controllerAction = ButtonAction.ACTION_ITEM,
            allowActionItem = true
        },
        switchTree = {
            keyboardButton = Keyboard.KEY_Q,
            controllerAction = ButtonAction.ACTION_MENUTAB
        },
        toggleTreeMods = {
            keyboardButton = Keyboard.KEY_Q,
            shift = true,
            controllerAction = ButtonAction.ACTION_MENUTAB,
            actionItem = true
        },
        toggleHelp = {
            keyboardButton = Keyboard.KEY_H
        },
        toggleHelpController = {
            controllerAction = ButtonAction.ACTION_MAP
        },
        zoomIn = {
            keyboardButton = Keyboard.KEY_Z,
            controllerAction = ButtonAction.ACTION_SHOOTUP,
            actionItem = true
        },
        zoomOut = {
            keyboardButton = Keyboard.KEY_Z,
            shift = true,
            controllerAction = ButtonAction.ACTION_SHOOTDOWN,
            actionItem = true
        },
        toggleTotalMods = {
            keyboardButton = Keyboard.KEY_H,
            shift = true,
            controllerAction = ButtonAction.ACTION_MAP,
            actionItem = true
        },
        toggleChangelog = {
            keyboardButton = Keyboard.KEY_C,
            shift = true,
        }
    }
}

---@enum PSTKeybind
PSTKeybind = {
    OPEN_TREE = "openTree",
    CLOSE_TREE = "closeTree",
    ALLOCATE_NODE = "allocateNode",
    RESPEC_NODE = "respecNode",
    TREE_PAN_LEFT = "treePanLeft",
    TREE_PAN_RIGHT = "treePanRight",
    TREE_PAN_UP = "treePanUp",
    TREE_PAN_DOWN = "treePanDown",
    CENTER_CAMERA = "centerCamera",
    PAN_FASTER = "panFaster",
    SWITCH_TREE = "switchTree",
    TOGGLE_TREE_MODS = "toggleTreeMods",
    TOGGLE_HELP = "toggleHelp",
    TOGGLE_HELP_CONTROLLER = "toggleHelpController",
    ZOOM_IN = "zoomIn",
    ZOOM_OUT = "zoomOut",
    TOGGLE_TOTAL_MODS = "toggleTotalMods",
    TOGGLE_CHANGELOG = "toggleChangelog"
}

-- Support for Mod Config Menu
function PST:initModConfigMenu()
    if ModConfigMenu == nil then
        return
    end

    -- Draw XP bar setting
    ModConfigMenu.RemoveSetting(PST.modName, nil, "drawXPbar")
    ModConfigMenu.AddSetting(
        PST.modName,
        nil,
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            Attribute = "drawXPbar",
            CurrentSetting = function()
                return PST.config.drawXPbar
            end,
            Display = function()
                return "Draw LVL and XP bar: " .. (PST.config.drawXPbar and "on" or "off")
            end,
            OnChange = function(b)
                PST.config.drawXPbar = b
            end,
            Info = {"Draw level and XP bar at the bottom of the screen", "during gameplay"}
        }
    )
    -- Draw floating texts setting
    ModConfigMenu.RemoveSetting(PST.modName, nil, "floatingTexts")
    ModConfigMenu.AddSetting(
        PST.modName,
        nil,
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            Attribute = "floatingTexts",
            CurrentSetting = function()
                return PST.config.floatingTexts
            end,
            Display = function()
                return "Draw floating texts: " .. (PST.config.floatingTexts and "on" or "off")
            end,
            OnChange = function(b)
                PST.config.floatingTexts = b
            end,
            Info = {"Draw floating texts during gameplay", "(e.g. xp gain, +1 respec, certain node effects, etc.)"}
        }
    )
    -- Draw selected character info setting
    ModConfigMenu.RemoveSetting(PST.modName, nil, "charSelectInfoText")
    ModConfigMenu.AddSetting(
        PST.modName,
        nil,
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            Attribute = "charSelectInfoText",
            CurrentSetting = function()
                return PST.config.charSelectInfoText
            end,
            Display = function()
                return "Draw char select info: " .. (PST.config.charSelectInfoText and "on" or "off")
            end,
            OnChange = function(b)
                PST.config.charSelectInfoText = b
            end,
            Info = {"Draw char info text in character select screen"}
        }
    )
    -- Draw pause menu controls text setting
    ModConfigMenu.RemoveSetting(PST.modName, nil, "drawPauseText")
    ModConfigMenu.AddSetting(
        PST.modName,
        nil,
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            Attribute = "drawPauseText",
            CurrentSetting = function()
                return PST.config.drawPauseText
            end,
            Display = function()
                return "Draw pause menu controls: " .. (PST.config.drawPauseText and "on" or "off")
            end,
            OnChange = function(b)
                PST.config.drawPauseText = b
            end,
            Info = {"Draw pause menu text showing tree opening controls"}
        }
    )
    -- Tree enabled on challenges setting
    ModConfigMenu.RemoveSetting(PST.modName, nil, "treeOnChallenges")
    ModConfigMenu.AddSetting(
        PST.modName,
        nil,
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            Attribute = "treeOnChallenges",
            CurrentSetting = function()
                return PST.config.treeOnChallenges
            end,
            Display = function()
                return "Apply trees on challenges: " .. (PST.config.treeOnChallenges and "on" or "off")
            end,
            OnChange = function(b)
                PST.config.treeOnChallenges = b
            end,
            Info = {"Whether tree node effects are applied in challenges", "Default off"}
        }
    )
    -- Changelog popup on new version setting
    ModConfigMenu.RemoveSetting(PST.modName, nil, "changelogPopup")
    ModConfigMenu.AddSetting(
        PST.modName,
        nil,
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            Attribute = "changelogPopup",
            CurrentSetting = function()
                return PST.config.changelogPopup
            end,
            Display = function()
                return "Changelog popup on update: " .. (PST.config.changelogPopup and "on" or "off")
            end,
            OnChange = function(b)
                PST.config.changelogPopup = b
            end,
            Info = {"Whether to have the changelog pop up in the tree screen when a new update arrives"}
        }
    )

    -- XP multiplier setting
    local xpMultOptions = {}
    for i=-9,20 do
        table.insert(xpMultOptions, 1 + i * 0.1)
    end
    local function getTableIndex(tbl, val)
        for i, v in ipairs(tbl) do
            if tostring(v) == tostring(val) then
                return i
            end
        end
        return 9
    end
    ModConfigMenu.RemoveSetting(PST.modName, nil, "xpMult")
    ModConfigMenu.AddSetting(
        PST.modName,
        nil,
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            Attribute = "xpMult",
            CurrentSetting = function()
                return getTableIndex(xpMultOptions, PST.config.xpMult)
            end,
            Minimum = 1,
            Maximum = #xpMultOptions,
            Display = function()
                return "XP Multiplier: " .. tostring(PST.config.xpMult)
            end,
            OnChange = function(n)
                PST.config.xpMult = xpMultOptions[n]
            end,
            Info = {"XP Multiplier applied to most XP gains", "Default 1"}
        }
    )
end
PST:initModConfigMenu()