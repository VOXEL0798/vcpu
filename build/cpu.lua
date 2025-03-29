local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____byte_array = require("byte_array")
local ByteArray = ____byte_array.ByteArray
____exports.INST = INST or ({})
____exports.INST.LDA_IM = 169
____exports.INST[____exports.INST.LDA_IM] = "LDA_IM"
____exports.INST.LDA_ZP = 165
____exports.INST[____exports.INST.LDA_ZP] = "LDA_ZP"
____exports.INST.LDA_ZPX = 181
____exports.INST[____exports.INST.LDA_ZPX] = "LDA_ZPX"
____exports.INST.LDA_ABS = 173
____exports.INST[____exports.INST.LDA_ABS] = "LDA_ABS"
____exports.INST.LDA_ABSX = 189
____exports.INST[____exports.INST.LDA_ABSX] = "LDA_ABSX"
____exports.INST.LDA_ABSY = 185
____exports.INST[____exports.INST.LDA_ABSY] = "LDA_ABSY"
____exports.INST.LDA_INDX = 161
____exports.INST[____exports.INST.LDA_INDX] = "LDA_INDX"
____exports.INST.LDA_INDY = 177
____exports.INST[____exports.INST.LDA_INDY] = "LDA_INDY"
____exports.INST.DEC_ZP = 198
____exports.INST[____exports.INST.DEC_ZP] = "DEC_ZP"
____exports.INST.DEC_ZPX = 214
____exports.INST[____exports.INST.DEC_ZPX] = "DEC_ZPX"
____exports.INST.DEC_ABS = 206
____exports.INST[____exports.INST.DEC_ABS] = "DEC_ABS"
____exports.INST.DEC_ABSX = 222
____exports.INST[____exports.INST.DEC_ABSX] = "DEC_ABSX"
____exports.INST.INX_IMP = 232
____exports.INST[____exports.INST.INX_IMP] = "INX_IMP"
____exports.INST.INY_IMP = 200
____exports.INST[____exports.INST.INY_IMP] = "INY_IMP"
____exports.INST.INC_ZP = 230
____exports.INST[____exports.INST.INC_ZP] = "INC_ZP"
____exports.INST.INC_ZPX = 246
____exports.INST[____exports.INST.INC_ZPX] = "INC_ZPX"
____exports.INST.INC_ABS = 238
____exports.INST[____exports.INST.INC_ABS] = "INC_ABS"
____exports.INST.INC_ABSX = 254
____exports.INST[____exports.INST.INC_ABSX] = "INC_ABSX"
____exports.INST.JMP_ABS = 76
____exports.INST[____exports.INST.JMP_ABS] = "JMP_ABS"
____exports.INST.JMP_IND = 108
____exports.INST[____exports.INST.JMP_IND] = "JMP_IND"
____exports.INST.ADC_IM = 105
____exports.INST[____exports.INST.ADC_IM] = "ADC_IM"
____exports.INST.ADC_ZP = 101
____exports.INST[____exports.INST.ADC_ZP] = "ADC_ZP"
____exports.INST.ADC_ZPX = 117
____exports.INST[____exports.INST.ADC_ZPX] = "ADC_ZPX"
____exports.INST.ADC_ABS = 109
____exports.INST[____exports.INST.ADC_ABS] = "ADC_ABS"
____exports.INST.ADC_ABSX = 125
____exports.INST[____exports.INST.ADC_ABSX] = "ADC_ABSX"
____exports.INST.ADC_ABSY = 121
____exports.INST[____exports.INST.ADC_ABSY] = "ADC_ABSY"
____exports.INST.BCC = 144
____exports.INST[____exports.INST.BCC] = "BCC"
____exports.INST.BCS = 176
____exports.INST[____exports.INST.BCS] = "BCS"
____exports.INST.BEQ = 240
____exports.INST[____exports.INST.BEQ] = "BEQ"
____exports.INST.BMI = 48
____exports.INST[____exports.INST.BMI] = "BMI"
____exports.INST.BNE = 208
____exports.INST[____exports.INST.BNE] = "BNE"
____exports.INST.BPL = 16
____exports.INST[____exports.INST.BPL] = "BPL"
____exports.INST.BVC = 80
____exports.INST[____exports.INST.BVC] = "BVC"
____exports.INST.BVS = 112
____exports.INST[____exports.INST.BVS] = "BVS"
____exports.INST.CLC = 24
____exports.INST[____exports.INST.CLC] = "CLC"
____exports.INST.CLV = 184
____exports.INST[____exports.INST.CLV] = "CLV"
____exports.INST.CLD = 216
____exports.INST[____exports.INST.CLD] = "CLD"
____exports.INST.STA_ZP = 133
____exports.INST[____exports.INST.STA_ZP] = "STA_ZP"
____exports.INST.TAX_IMP = 170
____exports.INST[____exports.INST.TAX_IMP] = "TAX_IMP"
____exports.INST.TAY_IMP = 168
____exports.INST[____exports.INST.TAY_IMP] = "TAY_IMP"
____exports.INST.TSX_IMP = 186
____exports.INST[____exports.INST.TSX_IMP] = "TSX_IMP"
____exports.INST.TXA_IMP = 138
____exports.INST[____exports.INST.TXA_IMP] = "TXA_IMP"
____exports.Flags = __TS__Class()
local Flags = ____exports.Flags
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
____exports.CPU = __TS__Class()
local CPU = ____exports.CPU
CPU.name = "CPU"
function CPU.prototype.____constructor(self, program)
    self.active = false
    self.memory = __TS__New(ByteArray)
    self.flags = __TS__New(____exports.Flags)
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
function CPU.prototype.set_lda_status(self, register)
    self.flags.N = bit32.band(register, 128) > 0
    self.flags.Z = register == 0
end
function CPU.prototype.step(self)
    if self.active == false then
        return
    end
    local cmd = self:fetch_byte()
    game.print(bit32.bor(
        self.memory:get(241),
        bit32.lshift(
            self.memory:get(242),
            8
        )
    ))
    repeat
        local ____switch12 = cmd
        local ____cond12 = ____switch12 == 255
        if ____cond12 then
            do
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.LDA_IM
        if ____cond12 then
            do
                local data = self:fetch_byte()
                self.a = data
                self:set_lda_status(self.a)
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.LDA_ZP
        if ____cond12 then
            do
                local data = self:fetch_byte()
                self.a = self:read_byte(data)
                self:set_lda_status(self.a)
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.LDA_ZPX
        if ____cond12 then
            do
                local data = self:fetch_byte()
                self.a = self:read_byte(bit32.band(data + self.x, 255))
                self:set_lda_status(self.a)
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.LDA_ABS
        if ____cond12 then
            do
                local data = self:fetch_word()
                self.a = self:read_byte(data)
                self:set_lda_status(self.a)
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.LDA_ABSX
        if ____cond12 then
            do
                local data = self:fetch_word()
                self.a = self:read_byte(bit32.band(data + self.x, 255))
                self:set_lda_status(self.a)
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.LDA_ABSY
        if ____cond12 then
            do
                local data = self:fetch_word()
                self.a = self:read_byte(data + self.y)
                self:set_lda_status(self.a)
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.LDA_INDX
        if ____cond12 then
            do
                local zp_addr = self:fetch_byte()
                local eff_addr = bit32.band(zp_addr + self.x, 255)
                local low = self:read_byte(eff_addr)
                local high = self:read_byte(bit32.band(eff_addr + 1, 255))
                local target_addr = bit32.bor(
                    bit32.lshift(high, 8),
                    low
                )
                self.a = self:read_byte(target_addr)
                self:set_lda_status(self.a)
                break
            end
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.LDA_INDY
        if ____cond12 then
            do
                local zp_addr = self:fetch_byte()
                local low = self:read_byte(zp_addr)
                local high = self:read_byte(bit32.band(zp_addr + 1, 255))
                local base_addr = bit32.bor(
                    bit32.lshift(high, 8),
                    low
                )
                local target_addr = base_addr + self.y
                self.a = self:read_byte(target_addr)
                self:set_lda_status(self.a)
                break
            end
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.INX_IMP
        if ____cond12 then
            do
                self.x = ByteArray:read_byte(self.x + 1, 0)
                self.flags.N = bit32.band(self.x, 128) > 0
                self.flags.Z = self.x == 0
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.INY_IMP
        if ____cond12 then
            do
                self.y = ByteArray:read_byte(self.y + 1, 0)
                self.flags.N = bit32.band(self.y, 128) > 0
                self.flags.Z = self.y == 0
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.INC_ZP
        if ____cond12 then
            do
                local addr_zp = self:fetch_byte()
                local byte = self:read_byte(addr_zp)
                self.memory:set(
                    addr_zp,
                    bit32.band(byte + 1, 255)
                )
                self.flags.N = bit32.band(byte, 128) > 0
                self.flags.Z = byte == 0
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.INC_ZPX
        if ____cond12 then
            do
                local addr_zp = self:fetch_byte()
                local byte = self:read_byte(bit32.band(addr_zp + self.x, 255))
                self.memory:set(
                    addr_zp,
                    bit32.band(byte + 1, 255)
                )
                self.flags.N = bit32.band(byte, 128) > 0
                self.flags.Z = byte == 0
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.INC_ABS
        if ____cond12 then
            do
                local addr = self:fetch_word()
                local byte = self:read_byte(addr)
                self.memory:set(
                    addr,
                    bit32.band(byte + 1, 255)
                )
                self.flags.N = bit32.band(byte, 128) > 0
                self.flags.Z = byte == 0
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.INC_ABSX
        if ____cond12 then
            do
                local addr = self:fetch_word()
                local byte = self:read_byte(addr + self.x)
                self.memory:set(
                    addr,
                    bit32.band(byte + 1, 255)
                )
                self.flags.N = bit32.band(byte, 128) > 0
                self.flags.Z = byte == 0
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.DEC_ZP
        if ____cond12 then
            do
                local addr_zp = self:fetch_byte()
                local byte = self:read_byte(addr_zp)
                self.memory:set(
                    addr_zp,
                    bit32.band(byte - 1, 255)
                )
                self.flags.N = bit32.band(byte, 128) > 0
                self.flags.Z = byte == 0
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.DEC_ZPX
        if ____cond12 then
            do
                local addr_zp = self:fetch_byte()
                local byte = self:read_byte(bit32.band(addr_zp + self.x, 255))
                self.memory:set(
                    addr_zp,
                    bit32.band(byte - 1, 255)
                )
                self.flags.N = bit32.band(byte, 128) > 0
                self.flags.Z = byte == 0
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.DEC_ABS
        if ____cond12 then
            do
                local addr = self:fetch_word()
                local byte = self:read_byte(addr)
                self.memory:set(
                    addr,
                    bit32.band(byte - 1, 255)
                )
                self.flags.N = bit32.band(byte, 128) > 0
                self.flags.Z = byte == 0
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.DEC_ABSX
        if ____cond12 then
            do
                local addr = self:fetch_word()
                local byte = self:read_byte(addr + self.x)
                self.memory:set(
                    addr,
                    bit32.band(byte - 1, 255)
                )
                self.flags.N = bit32.band(byte, 128) > 0
                self.flags.Z = byte == 0
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.JMP_ABS
        if ____cond12 then
            do
                self.pc = self:fetch_word()
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.JMP_IND
        if ____cond12 then
            do
                local addr = self:fetch_word()
                self.pc = self:read_word(addr)
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.ADC_ZP
        if ____cond12 then
            do
                local value = self:fetch_byte()
                value = self:read_byte(value)
                local carry = self.flags.C and 1 or 0
                local sum = bit32.band(self.a + value + carry, 65535)
                self.flags.C = sum > 255
                local overflow = bit32.band(
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
                self.a = bit32.band(sum, 255)
                self.flags.Z = self.a == 0
                self.flags.N = bit32.band(self.a, 128) ~= 0
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.ADC_IM
        if ____cond12 then
            do
                local value = self:fetch_byte()
                local carry = self.flags.C and 1 or 0
                local sum = bit32.band(self.a + value + carry, 65535)
                self.flags.C = sum > 255
                local overflow = bit32.band(
                    ByteArray:read_byte(
                        bit32.bxor(self.a, sum),
                        0
                    ),
                    ByteArray:read_byte(
                        bit32.bxor(value, sum),
                        0
                    )
                ) ~= 0
                self.flags.V = sum > 255
                self.a = bit32.band(sum, 255)
                self.flags.Z = self.a == 0
                self.flags.N = bit32.band(self.a, 128) ~= 0
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.BCC
        if ____cond12 then
            do
                if not self.flags.C then
                    self.pc = self:fetch_word() + 1
                end
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.BVS
        if ____cond12 then
            do
                if self.flags.V then
                    self.pc = self:fetch_word() + 1
                end
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.BVC
        if ____cond12 then
            do
                if not self.flags.V then
                    self.pc = self:fetch_word() + 1
                end
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.BNE
        if ____cond12 then
            do
                if not self.flags.Z then
                    self.pc = self:fetch_word() + 1
                end
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.ADC_ZPX
        if ____cond12 then
            do
                local value = self:fetch_byte()
                value = self:read_byte(value) + self.x
                local carry = self.flags.C and 1 or 0
                local sum = bit32.band(self.a + value + carry, 65535)
                self.flags.C = sum > 255
                local overflow = bit32.band(
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
                self.a = bit32.band(sum, 255)
                self.flags.Z = self.a == 0
                self.flags.N = bit32.band(self.a, 128) ~= 0
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.ADC_IM
        if ____cond12 then
            do
                local value = self:fetch_byte()
                local carry = self.flags.C and 1 or 0
                local sum = self.a + value + carry
                self.flags.C = sum > 255
                local overflow = bit32.band(
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
                self.a = bit32.band(sum, 255)
                self.flags.Z = self.a == 0
                self.flags.N = bit32.band(self.a, 128) ~= 0
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.INX_IMP
        if ____cond12 then
            do
                self.x = bit32.band(self.x + 1, 255)
                self.flags.N = bit32.band(self.x, 128) ~= 0
                self.flags.Z = self.x == 0
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.INY_IMP
        if ____cond12 then
            do
                self.y = bit32.band(self.y + 1, 255)
                self.flags.N = bit32.band(self.y, 128) ~= 0
                self.flags.Z = self.y == 0
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.CLV
        if ____cond12 then
            do
                self.flags.V = false
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.CLD
        if ____cond12 then
            do
                self.flags.B = false
                self.flags.C = false
                self.flags.D = false
            end
            break
        end
        ____cond12 = ____cond12 or ____switch12 == ____exports.INST.STA_ZP
        if ____cond12 then
            do
                self.memory:set(
                    self:fetch_byte(),
                    self.a
                )
            end
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
function CPU.inst_add(self)
    local tb = ____exports.CPU.INST_TABLE
end
return ____exports
