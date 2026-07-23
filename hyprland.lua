-- --- Variables - easily adjust commonly changed settings ---

local mainMod = "SUPER"
local thirdMod = "CTRL + ALT" -- e.g. "MOD5"

local keyboard_layout = "us" -- e.g. "se"
local keyboard_variant = nil -- e.g. "nodeadkeys"
local keyboard_options = nil -- e.g. "lv3:caps_switch"
local monitor_scale = 1.0
local focus_color = "#7c95e6"

local terminal = "kitty"
local ipc = "noctalia msg "

-- --- Vertical Workspace Animations ---
hl.animation({ 
    leaf = "workspaces", 
    enabled = true, 
    speed = 6, 
    bezier = "default", 
    style = "slidevert" 
})

-- --- Touchpad Gestures ---
hl.gesture({ fingers = 4, direction = "vertical", action = "workspace" })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

-- --- General config ---
hl.config({
    general = {
        border_size=4,
        gaps_in = 5,
        gaps_out = 10,
        col = {
            active_border=focus_color,
            inactive_border=focus_color .. "55",
        },
    },
    decoration = {
        rounding=20,
        inactive_opacity=0.95,
        rounding_power = 2,
        
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },
        
        blur = {
            enabled = true,
            size = 3,
            passes = 2,
            vibrancy = 0.1696,
        },
    },
    
    
    
    input = {
        kb_layout = keyboard_layout,
        kb_variant = keyboard_variant,
        numlock_by_default = true,
        follow_mouse = 0,
        kb_options = keyboard_options,
        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.workspace_rule({ workspace = "1", persistent = true })
hl.workspace_rule({ workspace = "2", persistent = true })
hl.workspace_rule({ workspace = "3", persistent = true })
hl.workspace_rule({ workspace = "4", persistent = true })


-- KEYBINDINGS 

-- --- Application Launches ---
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("flatpak run org.mozilla.firefox"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))

-- --- Desktop control ---
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("noctalia msg session lock"))
hl.bind(mainMod .. "+Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. "+S", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
hl.bind("ALT + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"))

-- --- Window Controls ---
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))

hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

hl.bind(thirdMod .. " + down", hl.dsp.focus({ workspace = "+1" }))
hl.bind(thirdMod .. " + up", hl.dsp.focus({ workspace = "-1" }))

-- --- Move Windows to Workspaces ---
hl.bind(thirdMod .. " + SHIFT + down", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(thirdMod .. " + SHIFT + up", hl.dsp.window.move({ workspace = "-1" }))

-- --- Media keys etc ---
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))
hl.bind("Print", hl.dsp.exec_cmd(ipc .. "screenshot-region"))

hl.window_rule({
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size = { 1080, 920 },
})

hl.layer_rule({
    name = "noctalia",
    match = {
        namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
    },
    no_anim = true,
    ignore_alpha = 0.5,
    blur = true,
    blur_popups = true,
})

hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia")
end)

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = monitor_scale,
})