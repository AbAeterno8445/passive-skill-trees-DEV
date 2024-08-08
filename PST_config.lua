PST.config = {
    drawXPbar = true, -- Draw level and XP bar at the bottom of the screen during gameplay
    floatingTexts = true, -- Draw floating texts during gameplay (e.g. xp gain, +1 respec, certain node effects, etc.)
    charSelectInfoText = true, -- Draw selected character level info at the bottom of the screen during character selection
    -- Keybinds for mod actions. Available options:
    -- shift: true, requires shift to be held during keyboard press. If not set or false, key won't fire if shift is pressed
    -- ctrl: true, requires ctrl to be held during keyboard press. If not set or false, key won't fire if ctrl is pressed
    -- actionItem: requires actionItem to be held during controller press.
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
    ZOOM_OUT = "zoomOut"
}