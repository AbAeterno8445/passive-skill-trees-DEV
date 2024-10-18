PST.config = {
    -- Draw level and XP bar at the bottom of the screen during gameplay
    drawXPbar = true,

    -- XP bar scale
    xpbarScale = 1,

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

    -- Toggle Starcursed Jewel drops (0: enable, 1: disable when inventory full, 2: disable all)
    starJewelDrops = 0,

    -- Make changelog pop up when on new version updates
    changelogPopup = true,

    -- Tree description boxes style (0: old, 1: new)
    descriptionBoxStyle = 0,

    -- Tainted Siren: use a singing sound for Manifest Melody instead of the default sound
    tSirenSing = false,

    -- Max amount of backups to keep (if backup dll is present)
    maxBackups = 3,

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

    local function getTableIndex(tbl, val, default)
        for i, v in ipairs(tbl) do
            if tostring(v) == tostring(val) then
                return i
            end
        end
        return default
    end

    -- Draw XP bar setting
    ModConfigMenu.RemoveSetting(PST.modName, "Main", "drawXPbar")
    ModConfigMenu.AddSetting(
        PST.modName,
        "Main",
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
    -- XP bar scale setting
    local xpbarScaleOptions = {1, 0.75, 0.5}
    ModConfigMenu.RemoveSetting(PST.modName, "Main", "xpbarScale")
    ModConfigMenu.AddSetting(
        PST.modName,
        "Main",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            Attribute = "xpbarScale",
            CurrentSetting = function()
                return getTableIndex(xpbarScaleOptions, PST.config.xpbarScale, 1)
            end,
            Minimum = 1,
            Maximum = #xpbarScaleOptions,
            Display = function()
                return "XP bar scale: " .. tostring(PST.config.xpbarScale)
            end,
            OnChange = function(n)
                PST.config.xpbarScale = xpbarScaleOptions[n]
            end,
            Info = {"Drawn XP bar scale/size"}
        }
    )
    -- Draw floating texts setting
    ModConfigMenu.RemoveSetting(PST.modName, "Main", "floatingTexts")
    ModConfigMenu.AddSetting(
        PST.modName,
        "Main",
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
    ModConfigMenu.RemoveSetting(PST.modName, "Main", "charSelectInfoText")
    ModConfigMenu.AddSetting(
        PST.modName,
        "Main",
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
    ModConfigMenu.RemoveSetting(PST.modName, "Main", "drawPauseText")
    ModConfigMenu.AddSetting(
        PST.modName,
        "Main",
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
    ModConfigMenu.RemoveSetting(PST.modName, "Main", "treeOnChallenges")
    ModConfigMenu.AddSetting(
        PST.modName,
        "Main",
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
    ModConfigMenu.RemoveSetting(PST.modName, "Main", "changelogPopup")
    ModConfigMenu.AddSetting(
        PST.modName,
        "Main",
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
    -- Tree description boxes style setting
    local descBoxStyleNames = {"old", "new"}
    ModConfigMenu.RemoveSetting(PST.modName, "Main", "descriptionBoxStyle")
    ModConfigMenu.AddSetting(
        PST.modName,
        "Main",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            Attribute = "descriptionBoxStyle",
            CurrentSetting = function()
                return PST.config.descriptionBoxStyle
            end,
            Minimum = 0,
            Maximum = 1,
            Display = function()
                return "Description Box Style: " .. descBoxStyleNames[PST.config.descriptionBoxStyle + 1]
            end,
            OnChange = function(n)
                PST.config.descriptionBoxStyle = n
            end,
            Info = {"Tree node description box visual style", "New can look better in fullscreen or small resolutions"}
        }
    )

    -- XP multiplier setting
    local xpMultOptions = {}
    for i=-9,20 do
        table.insert(xpMultOptions, 1 + i * 0.1)
    end
    ModConfigMenu.RemoveSetting(PST.modName, "Main", "xpMult")
    ModConfigMenu.AddSetting(
        PST.modName,
        "Main",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            Attribute = "xpMult",
            CurrentSetting = function()
                return getTableIndex(xpMultOptions, PST.config.xpMult, 9)
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

    -- Starcursed jewel drop toggle setting
    local starJewelToggleStr = {"none", "inv full", "all"}
    ModConfigMenu.RemoveSetting(PST.modName, "Main", "starJewelDrops")
    ModConfigMenu.AddSetting(
        PST.modName,
        "Main",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            Attribute = "starJewelDrops",
            CurrentSetting = function()
                return PST.config.starJewelDrops
            end,
            Minimum = 0,
            Maximum = 2,
            Display = function()
                return "Disable Jewel drops: " .. starJewelToggleStr[PST.config.starJewelDrops + 1]
            end,
            OnChange = function(n)
                PST.config.starJewelDrops = n
            end,
            Info = {"Stop Starcursed Jewels from dropping", "Inv full only stops the jewel type for which your inventory is full"}
        }
    )

    ---- MISC SETTINGS ----
    -- Tainted Siren singing toggle
    ModConfigMenu.RemoveSetting(PST.modName, "Misc", "tSirenSing")
    ModConfigMenu.AddSetting(
        PST.modName,
        "Misc",
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            Attribute = "tSirenSing",
            CurrentSetting = function()
                return PST.config.tSirenSing
            end,
            Display = function()
                return "Tainted Siren Singing: " .. (PST.config.tSirenSing and "on" or "off")
            end,
            OnChange = function(b)
                PST.config.tSirenSing = b
            end,
            Info = {"Makes Tainted Siren sing when using Manifest Melody"}
        }
    )
end
PST:initModConfigMenu()