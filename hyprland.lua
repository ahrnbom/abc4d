-- --- Variables - easily adjust commonly changed settings ---

local mainMod = "SUPER"
local thirdMod = "CTRL + ALT" -- e.g. "MOD5"

local keyboard_layout = "us" -- e.g. "se"
local keyboard_variant = nil -- e.g. "nodeadkeys"
local keyboard_options = nil -- e.g. "lv3:caps_switch"
local monitor_scale = 1.0
local focus_color = "#7c95e6"

local terminal = "kitty"
local menu = "noctalia msg panel-toggle launcher"

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
         col = {
             active_border=focus_color,
             inactive_border=focus_color .. "55",
         },
    },
    decoration = {
        rounding=16,
        inactive_opacity=0.95,
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


-- KEYBINDINGS

-- --- Desktop ---
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("noctalia msg session lock"))

-- --- Application Launches ---
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("flatpak run org.mozilla.firefox"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))

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

-- --- Move Windows to Workspaces (Vertical via Caps Lock + Shift) ---
hl.bind(thirdMod .. " + SHIFT + down", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(thirdMod .. " + SHIFT + up", hl.dsp.window.move({ workspace = "-1" }))

hl.on("hyprland.start", function()
  hl.exec_cmd("noctalia")
end)

hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = monitor_scale,
})