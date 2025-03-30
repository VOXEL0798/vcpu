import { ByteArray } from "./byte_array"

export enum INST {
    LDA_IM = 0xA9,
    LDA_ZP = 0xA5,
    LDA_ZPX = 0xB5,
    LDA_ABS = 0xAD,
    LDA_ABSX = 0xBD,
    LDA_ABSY = 0xB9,
    LDA_INDX = 0xA1,
    LDA_INDY = 0xB1,

    DEC_ZP = 0xC6,
    DEC_ZPX = 0xD6,
    DEC_ABS = 0xCE,
    DEC_ABSX = 0xDE,

    INX_IMP = 0xE8,
    INY_IMP = 0xC8,
    INC_ZP = 0xE6,
    INC_ZPX = 0xF6,
    INC_ABS = 0xEE,
    INC_ABSX = 0xFE,

    JMP_ABS = 0x4C,
    JMP_IND = 0x6C,
    JSR_ABS = 0x20,

    ADC_IM = 0x69,
    ADC_ZP = 0x65,
    ADC_ZPX = 0x75,
    ADC_ABS = 0x6D,
    ADC_ABSX = 0x7D,
    ADC_ABSY = 0x79,

    BCC = 0x90,
    BCS = 0xB0,
    BEQ = 0xF0,
    BMI = 0x30,
    BNE = 0xD0,
    BPL = 0x10,
    BVC = 0x50,
    BVS = 0x70,

    CLC = 0x18,
    CLV = 0xB8,
    CLD = 0xD8,

    STA_ZP = 0x85,

    TAX_IMP = 0xAA,
    TAY_IMP = 0xA8,
    TSX_IMP = 0xBA,
    TXA_IMP = 0x8A,
    TXS_IMP = 0x9A,
    TYA_IMP = 0x98,

    RTS_IMP = 0x60,

    PHA_IMP = 0x48,
    PHP_IMP = 0x08,
    PLA_IMP = 0x68,
    PLP_IMP = 0x28,
}

export class Flags {
    N: boolean
    V: boolean
    B: boolean
    D: boolean
    I: boolean
    Z: boolean
    C: boolean

    constructor() {
        this.N = false
        this.V = false
        this.B = false
        this.D = false
        this.I = false
        this.Z = false
        this.C = false
    }
}

export class CPU {
    active: boolean

    pc: number
    sp: number
    bp: number

    a: number
    x: number
    y: number

    memory: ByteArray
    flags: Flags

    constructor(program: Array<number>) {
        this.active = false
        this.memory = new ByteArray()
        this.flags = new Flags()
        this.pc = 0
        this.sp = 0xFFFF
        this.bp = 0xFFFF - 0xFF
        this.a = 0
        this.x = 0
        this.y = 0

        for (let i = 0; i < program.length; i++) {
            this.memory.fill(0, program)
        }
    }

    push(data: number) {
        this.memory.set(this.sp, data)
        if (this.sp > this.bp) {
            this.sp--
        }
    }

    pop(): number {
        let value = this.memory.get(this.sp)
        if (this.sp < 0xFFFF) {
            this.sp++
        }
        return value
    }

    set_NZ_status(register: number) {
        this.flags.N = (register & 0b10000000) > 0
        this.flags.Z = register == 0
    }

    step() {
        if (this.active == false) {
            return
        }
        let cmd = this.fetch_byte()

        game.print(this.memory.get(0xf1) | this.memory.get(0xf2) << 8)
        switch (cmd) {
            case 0xFF: {
            } break;

            case INST.LDA_IM: {
                let data = this.fetch_byte()
                this.a = data
                this.set_NZ_status(this.a)
            } break;

            case INST.LDA_ZP: {
                let data = this.fetch_byte()
                this.a = this.read_byte(data)
                this.set_NZ_status(this.a)
            } break;

            case INST.LDA_ZPX: {
                let data = this.fetch_byte()
                this.a = this.read_byte((data + this.x) & 0xFF)
                this.set_NZ_status(this.a)
            } break;

            case INST.LDA_ABS: {
                let data = this.fetch_word()
                this.a = this.read_byte(data)
                this.set_NZ_status(this.a)
            } break;

            case INST.LDA_ABSX: {
                let data = this.fetch_word()
                this.a = this.read_byte((data + this.x) & 0xFF)
                this.set_NZ_status(this.a)
            } break;

            case INST.LDA_ABSY: {
                let data = this.fetch_word()
                this.a = this.read_byte(data + this.y)
                this.set_NZ_status(this.a)
            } break;

            case INST.LDA_INDX: {
                const zp_addr = this.fetch_byte();  // Читаем адрес zero page (например, $20)
                const eff_addr = (zp_addr + this.x) & 0xFF;  // Добавляем X (с обрезкой)
                const low = this.read_byte(eff_addr);  // Читаем младший байт адреса
                const high = this.read_byte((eff_addr + 1) & 0xFF);  // Читаем старший байт
                const target_addr = (high << 8) | low;  // Формируем 16-битный адрес
                this.a = this.read_byte(target_addr);  // Загружаем значение в A
                this.set_NZ_status(this.a);  // Устанавливаем флаги
                break;
            }

            case INST.LDA_INDY: {
                const zp_addr = this.fetch_byte();
                const low = this.read_byte(zp_addr);
                const high = this.read_byte((zp_addr + 1) & 0xFF);
                const base_addr = (high << 8) | low;
                const target_addr = base_addr + this.y;
                this.a = this.read_byte(target_addr);
                this.set_NZ_status(this.a);
                break;
            }

            case INST.INX_IMP: {
                this.x = (this.x + 1) & 0xFF
                this.set_NZ_status(this.x)
            } break;

            case INST.INY_IMP: {
                this.y = (this.y + 1) & 0xFF
                this.set_NZ_status(this.y)
            } break;

            case INST.INC_ZP: {
                let addr_zp = this.fetch_byte()
                let byte = this.read_byte(addr_zp)
                this.memory.set(addr_zp, (byte + 1) & 0xFF)
                this.set_NZ_status(this.memory.get(addr_zp))
            } break;

            case INST.INC_ZPX: {
                let addr_zp = this.fetch_byte()
                let byte = this.read_byte((addr_zp + this.x) & 0xFF)
                this.memory.set(addr_zp, (byte + 1) & 0xFF)
                this.set_NZ_status(this.memory.get(addr_zp))
            } break;

            case INST.INC_ABS: {
                let addr = this.fetch_word()
                let byte = this.read_byte(addr)
                this.memory.set(addr, (byte + 1) & 0xFF)
                this.set_NZ_status(this.memory.get(addr))
            } break;

            case INST.INC_ABSX: {
                let addr = this.fetch_word()
                let byte = this.read_byte(addr + this.x)
                this.memory.set(addr, (byte + 1) & 0xFF)
                this.set_NZ_status(this.memory.get(addr))
            } break;

            case INST.DEC_ZP: {
                let addr_zp = this.fetch_byte()
                let byte = this.read_byte(addr_zp)
                this.memory.set(addr_zp, (byte - 1) & 0xFF)
                this.set_NZ_status(this.memory.get(addr_zp))
            } break;


            case INST.DEC_ZPX: {
                let addr_zp = this.fetch_byte()
                let byte = this.read_byte((addr_zp + this.x) & 0xFF)
                this.memory.set(addr_zp, (byte - 1) & 0xFF)
                this.set_NZ_status(this.memory.get(addr_zp))
            } break;


            case INST.DEC_ABS: {
                let addr = this.fetch_word()
                let byte = this.read_byte(addr)
                this.memory.set(addr, (byte - 1) & 0xFF)
                this.set_NZ_status(this.memory.get(addr))
            } break;


            case INST.DEC_ABSX: {
                let addr = this.fetch_word()
                let byte = this.read_byte(addr + this.x)
                this.memory.set(addr, (byte - 1) & 0xFF)
                this.set_NZ_status(this.memory.get(addr))
            } break;

            case INST.JMP_ABS: {
                this.pc = this.fetch_word()
            } break;

            case INST.JMP_IND: {
                let addr = this.fetch_word()
                this.pc = this.read_word(addr)
            } break;

            case INST.JSR_ABS: {
                let addr = this.fetch_word()
                this.push(this.pc)
                this.pc = this.read_word(addr)
            } break;

            case INST.ADC_ZP: {
                let value = this.fetch_byte()
                value = this.read_byte(value)
                let carry = this.flags.C ? 1 : 0
                let sum = (this.a + value + carry) & 0xFFFF
                this.flags.C = sum > 0xFF
                let overflow = (ByteArray.read_byte(this.a ^ sum, 0) & ByteArray.read_byte(value ^ sum, 0)) != 0
                this.flags.V = overflow
                this.a = sum & 0xFF
                this.set_NZ_status(this.a)
            } break;

            case INST.ADC_IM: {
                let value = this.fetch_byte()
                let carry = this.flags.C ? 1 : 0
                let sum = (this.a + value + carry) & 0xFFFF
                this.flags.C = sum > 0xFF
                let overflow = (ByteArray.read_byte(this.a ^ sum, 0) & ByteArray.read_byte(value ^ sum, 0)) != 0
                //this.flags.V = overflow
                this.flags.V = sum > 255
                this.a = sum & 0xFF
                this.set_NZ_status(this.a)
            } break;

            case INST.BCC: {
                if (!this.flags.C) {
                    this.pc = this.fetch_word() + 1
                }
            } break;

            case INST.BCS: {
                if (this.flags.C) {
                    this.pc = this.fetch_word() + 1
                }
            } break;

            case INST.BEQ: {
                if (this.flags.Z) {
                    this.pc = this.fetch_word() + 1
                }
            } break;

            case INST.BMI: {
                if (this.flags.N) {
                    this.pc = this.fetch_word() + 1
                }
            } break;

            case INST.BVS: {
                if (this.flags.V) {
                    this.pc = this.fetch_word() + 1
                }
            } break;

            case INST.BVC: {
                if (!this.flags.V) {
                    this.pc = this.fetch_word() + 1
                }
            } break;

            case INST.BNE: {
                if (!this.flags.Z) {
                    this.pc = this.fetch_word() + 1
                }
            } break;

            case INST.BPL: {
                if (!this.flags.N) {
                    this.pc = this.fetch_word() + 1
                }
            } break;

            case INST.ADC_ZPX: {
                let value = this.fetch_byte()
                value = (this.read_byte(value) + this.x)
                let carry = this.flags.C ? 1 : 0
                let sum = (this.a + value + carry) & 0xFFFF

                this.flags.C = sum > 0xFF
                let overflow = (ByteArray.read_byte(this.a ^ sum, 0) & ByteArray.read_byte(value ^ sum, 0)) != 0
                this.flags.V = overflow
                this.a = sum & 0xFF
                this.set_NZ_status(this.a)
            } break;

            case INST.ADC_IM: {
                let value = this.fetch_byte()
                let carry = this.flags.C ? 1 : 0
                let sum = this.a + value + carry

                this.flags.C = sum > 0xFF
                let overflow = (ByteArray.read_byte(this.a ^ sum, 0) & ByteArray.read_byte(value ^ sum, 0)) != 0
                this.flags.V = overflow
                this.a = sum & 0xFF
                this.set_NZ_status(this.a)
            } break;

            case INST.INX_IMP: {
                this.x = (this.x + 1) & 0xFF
                this.set_NZ_status(this.x)
            } break;

            case INST.INY_IMP: {
                this.y = (this.y + 1) & 0xFF
                this.set_NZ_status(this.y)
            } break;

            case INST.CLV: {
                this.flags.V = false
            } break;

            case INST.CLD: {
                this.flags.B = false
                this.flags.C = false
                this.flags.D = false
            } break;

            case INST.STA_ZP: {
                this.memory.set(this.fetch_byte(), this.a)
            } break;

            case INST.TAX_IMP: {
                this.x = this.a
                this.set_NZ_status(this.x)
            } break;

            case INST.TAY_IMP: {
                this.y = this.a
                this.set_NZ_status(this.y)
            } break;

            case INST.TSX_IMP: {
                this.x = this.sp
                this.set_NZ_status(this.x)
            } break;

            case INST.TXA_IMP: {
                this.x = this.sp
                this.set_NZ_status(this.x)
            } break;

            case INST.RTS_IMP: {
                this.pc = this.pop()
            } break;

            case INST.PLA_IMP: {
                this.a = this.pop()
                this.set_NZ_status(this.a)
            } break;

            case INST.PHA_IMP: {
                this.push(this.a)
            } break;

            default:
                break;
        }
    }

    read_byte(address: number): number {
        return this.memory.get(address)
    }

    read_word(address: number): number {
        return (this.memory.get(address) | this.memory.get(address + 1)) & 0xFFFF
    }

    fetch_byte(): number {
        this.pc += 1
        return this.memory.get(this.pc - 1)
    }

    fetch_word(): number {
        this.pc += 2
        return (this.memory.get(this.pc - 2) | this.memory.get(this.pc - 1)) & 0xFFFF
    }

    static INST_TABLE: {}
}

