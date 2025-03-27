local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____cpu = require("cpu")
local CPU = ____cpu.CPU
script.on_event(
    defines.events.on_player_created,
    function()
        local player = game.players[1]
        local frame = player.gui.screen.add({type = "frame", name = "my_frame", direction = "vertical"})
        local flow_widget = frame.add({type = "flow", name = "drag_widget"})
        local drag_widget = flow_widget.add({type = "empty-widget", name = "drag_widget", style = "draggable_space"})
        local close = flow_widget.add({type = "sprite-button", name = "cpu-close-window", sprite = "utility/close", style = "frame_action_button"})
        close.style.left_margin = 4
        drag_widget.drag_target = frame
        drag_widget.style.horizontally_stretchable = true
        drag_widget.style.height = 20
        drag_widget.style.margin = {0, 0, 4, 0}
        frame.auto_center = true
        local tb = frame.add({type = "text-box", name = "cpu-code"})
        tb.style.height = 20 * 20 + 8
        frame.add({type = "checkbox", name = "cpu-execute", state = false})
    end
)
local cpu = __TS__New(CPU, {
    165,
    241,
    105,
    1,
    133,
    241,
    255,
    80,
    0,
    0,
    216,
    184,
    165,
    242,
    105,
    1,
    133,
    242,
    216,
    184,
    255,
    76,
    0,
    0
})
script.on_event(
    defines.events.on_tick,
    function()
        do
            local index = 0
            while index < 150 do
                cpu:step()
                index = index + 1
            end
        end
    end
)
script.on_event(
    defines.events.on_gui_click,
    function(data)
        if data.element.name ~= "cpu-execute" then
            return
        end
        local exec = data.element
        cpu.active = exec.state
    end
)
return ____exports
