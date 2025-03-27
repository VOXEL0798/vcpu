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
INST = INST or ({})
INST.LDA_IM = 169
INST[INST.LDA_IM] = "LDA_IM"
INST.LDA_ZP = 165
INST[INST.LDA_ZP] = "LDA_ZP"
INST.LDA_ZPX = 181
INST[INST.LDA_ZPX] = "LDA_ZPX"
INST.LDA_ABS = 173
INST[INST.LDA_ABS] = "LDA_ABS"
INST.LDA_ABSX = 189
INST[INST.LDA_ABSX] = "LDA_ABSX"
INST.LDA_ABSY = 185
INST[INST.LDA_ABSY] = "LDA_ABSY"
INST.DEC_ZP = 198
INST[INST.DEC_ZP] = "DEC_ZP"
INST.DEC_ZPX = 214
INST[INST.DEC_ZPX] = "DEC_ZPX"
INST.DEC_ABS = 206
INST[INST.DEC_ABS] = "DEC_ABS"
INST.DEC_ABSX = 222
INST[INST.DEC_ABSX] = "DEC_ABSX"
INST.INX_IMP = 232
INST[INST.INX_IMP] = "INX_IMP"
INST.INY_IMP = 200
INST[INST.INY_IMP] = "INY_IMP"
INST.JMP_ABS = 76
INST[INST.JMP_ABS] = "JMP_ABS"
INST.JMP_IND = 108
INST[INST.JMP_IND] = "JMP_IND"
INST.ADC_IM = 105
INST[INST.ADC_IM] = "ADC_IM"
INST.ADC_ZP = 101
INST[INST.ADC_ZP] = "ADC_ZP"
INST.ADC_ZPX = 117
INST[INST.ADC_ZPX] = "ADC_ZPX"
INST.ADC_ABS = 109
INST[INST.ADC_ABS] = "ADC_ABS"
INST.ADC_ABSX = 125
INST[INST.ADC_ABSX] = "ADC_ABSX"
INST.ADC_ABSY = 121
INST[INST.ADC_ABSY] = "ADC_ABSY"
Flags = __TS__Class()
Flags.name = "Flags"
function Flags.prototype.____constructor(self)
    self.N = false
    self.V = false
    self.B = false
    self.D = false
    self.I = false
    self.Z = false
    self.C = false
end
CPU = __TS__Class()
CPU.name = "CPU"
function CPU.prototype.____constructor(self, program)
    self.active = false
    self.memory = __TS__New(ByteArray)
    self.flags = __TS__New(Flags)
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
    self.memory:set(self.sp, data)
    if self.sp > self.bp then
        self.sp = self.sp - 1
    end
end
function CPU.prototype.pop(self)
    local value = self.memory:get(self.sp)
    if self.sp < 65535 then
        self.sp = self.sp + 1
    end
    return value
end
function CPU.prototype.step(self)
    if self.active == false then
        return
    end
    local cmd = self:fetch_byte()
    repeat
        local ____switch25 = cmd
        local data, addr, value, carry, sum, overflow
        local ____cond25 = ____switch25 == INST.LDA_IM
        if ____cond25 then
            data = self:fetch_byte()
            self.a = data
            self.flags.N = bit32.band(data, 128) > 0
            self.flags.Z = data == 0
            break
        end
        ____cond25 = ____cond25 or ____switch25 == INST.INX_IMP
        if ____cond25 then
            self.x = ByteArray:read_byte(self.x + 1, 0)
            self.flags.N = bit32.band(self.x, 128) > 0
            break
        end
        ____cond25 = ____cond25 or ____switch25 == INST.INY_IMP
        if ____cond25 then
            self.y = ByteArray:read_byte(self.y + 1, 0)
            self.flags.N = bit32.band(self.y, 128) > 0
            break
        end
        ____cond25 = ____cond25 or ____switch25 == INST.JMP_ABS
        if ____cond25 then
            self.pc = self:fetch_word()
            break
        end
        ____cond25 = ____cond25 or ____switch25 == INST.JMP_IND
        if ____cond25 then
            addr = self:fetch_word()
            self.pc = self:read_word(addr)
            break
        end
        ____cond25 = ____cond25 or ____switch25 == INST.ADC_ZP
        if ____cond25 then
            value = self:fetch_byte()
            value = self:read_byte(value)
            carry = self.flags.C and 1 or 0
            sum = self.a + value + carry
            self.flags.C = sum > 255
            overflow = bit32.band(
                ByteArray:read_byte(
                    bit32.bxor(self.a, sum),
                    0
                ),
                ByteArray:read_byte(
                    bit32.bxor(value, sum),
                    0
                )
            ) ~= 0
            self.flags.V = overflow
            self.a = ByteArray:read_byte(sum, 0)
            self.flags.Z = self.a == 0
            self.flags.N = bit32.band(self.a, 128) ~= 0
            game.print(self.a)
            break
        end
        ____cond25 = ____cond25 or ____switch25 == 4
        if ____cond25 then
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
cpu = __TS__New(CPU, {
    INST.ADC_ZP,
    5,
    INST.JMP_ABS,
    0,
    0,
    241
})
script.on_event(
    defines.events.on_tick,
    function()
        cpu:step()
    end
)
script.on_event(
    defines.events.on_gui_click,
    function(data)
        if data.element.name ~= "cpu-execute" then
            return
        end
        local exec = data.element
        cpu.active = not cpu.active
    end
)
