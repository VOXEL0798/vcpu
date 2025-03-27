local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__ArrayForEach = ____lualib.__TS__ArrayForEach
local __TS__ArrayFrom = ____lualib.__TS__ArrayFrom
ByteArray = __TS__Class()
ByteArray.name = "ByteArray"
function ByteArray.prototype.____constructor(self)
    self.bytes = {}
    do
        local i = 0
        while i < 65535 / 8 do
            self.bytes[i + 1] = 0
            i = i + 1
        end
    end
end
function ByteArray.prototype.get(self, index)
    local id = bit32.arshift(index, 2)
    local shift = bit32.lshift(
        bit32.band(index, 3),
        3
    )
    return bit32.band(
        bit32.arshift(self.bytes[id + 1], shift),
        255
    )
end
function ByteArray.prototype.set(self, index, value)
    local id = bit32.arshift(index, 2)
    local shift = bit32.lshift(
        bit32.band(index, 3),
        3
    )
    local mask = bit32.lshift(255, shift)
    self.bytes[id + 1] = bit32.bor(
        bit32.band(
            self.bytes[id + 1],
            bit32.bnot(mask)
        ),
        bit32.lshift(
            bit32.band(value, 255),
            shift
        )
    )
end
function ByteArray.prototype.fill(self, index, data)
    do
        local i = 0
        while i < #data do
            self:set(
                index + i,
                bit32.band(data[i + 1], 255)
            )
            i = i + 1
        end
    end
end
function ByteArray.read_byte(self, data, byte)
    return bit32.band(
        data,
        bit32.lshift(255, byte * 8)
    )
end
function ByteArray.TEST(self)
    do
        local tests = {{
            0,
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8
        }, {
            15,
            25,
            64,
            215,
            255,
            249,
            171,
            172,
            205
        }}
        local desc = "\nByteArray get/set byte tests"
        local arr = __TS__New(ByteArray)
        __TS__ArrayForEach(
            tests,
            function(____, _el, id, _ar)
                arr:set(tests[1][id + 1], tests[2][id + 1])
            end
        )
        __TS__ArrayForEach(
            tests,
            function(____, _el, id, _ar)
                assert(
                    arr:get(tests[1][id + 1]) == tests[2][id + 1],
                    (((desc .. "\nexpected: ") .. tostring(tests[2][id + 1])) .. "\nresult: ") .. tostring(arr:get(tests[1][id + 1]))
                )
            end
        )
    end
    do
        do
            local i = 1
            while i < 10 do
                local tests = {{i}, {
                    1,
                    2,
                    3,
                    4,
                    8,
                    9,
                    1,
                    123,
                    253
                }}
                local desc = "\nByteArray fill bytes tests"
                local arr = __TS__New(ByteArray)
                arr:fill(
                    tests[1][1],
                    __TS__ArrayFrom(tests[2])
                )
                do
                    local i = tests[1][1]
                    while i < #tests[2] + tests[1][1] do
                        assert(
                            arr:get(i) == tests[2][i - tests[1][1] + 1],
                            (((desc .. "\nexpected: ") .. tostring(tests[2][i - tests[1][1] + 1])) .. "\nresult: ") .. tostring(arr:get(i))
                        )
                        i = i + 1
                    end
                end
                i = i + 1
            end
        end
    end
end
CPU = __TS__Class()
CPU.name = "CPU"
function CPU.prototype.____constructor(self, program)
    self.active = false
    self.memory = __TS__New(ByteArray)
    self.pc = 0
    self.sp = 65535
    self.bp = 65535 - 255
    self.a = 0
    self.x = 0
    self.y = 0
    do
        local i = 0
        while i < #program do
            self.memory:fill(0, program)
            i = i + 1
        end
    end
end
function CPU.prototype.push(self, data)
end
function CPU.prototype.step(self)
    if self.active == false then
        return
    end
    local cmd = self:fetch_byte()
    repeat
        local ____switch21 = cmd
        local ____cond21 = ____switch21 == 1
        if ____cond21 then
            self.a = ByteArray:read_byte(self.a + 1, 0)
            break
        end
        ____cond21 = ____cond21 or ____switch21 == 2
        if ____cond21 then
            game.print(self.a)
            break
        end
        ____cond21 = ____cond21 or ____switch21 == 3
        if ____cond21 then
            self.pc = 0
            break
        end
        ____cond21 = ____cond21 or ____switch21 == 4
        if ____cond21 then
            self.a = ByteArray:read_byte(
                self.a + self:fetch_byte(),
                0
            )
            break
        end
        do
            break
        end
    until true
end
function CPU.prototype.read_byte(self, address)
    return self.memory:get(address)
end
function CPU.prototype.read_word(self, address)
    return bit32.band(
        bit32.bor(
            self.memory:get(address),
            self.memory:get(address + 1)
        ),
        65535
    )
end
function CPU.prototype.fetch_byte(self)
    self.pc = self.pc + 1
    return self.memory:get(self.pc - 1)
end
function CPU.prototype.fetch_word(self)
    self.pc = self.pc + 2
    return bit32.band(
        bit32.bor(
            self.memory:get(self.pc - 2),
            self.memory:get(self.pc - 1)
        ),
        65535
    )
end
function CPU.tests(self)
    do
    end
end
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
        frame.add({type = "button", name = "cpu-execute"})
    end
)
cpu = __TS__New(CPU, {4, 5, 2, 3})
script.on_event(
    defines.events.on_tick,
    function()
        cpu:step()
    end
)
script.on_event(
    defines.events.on_gui_click,
    function(data)
        game.print("click!")
        if data.element.name ~= "cpu-execute" then
            return
        end
        local exec = data.element
        cpu.active = not cpu.active
    end
)
