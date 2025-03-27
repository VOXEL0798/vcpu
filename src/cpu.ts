import { ByteArray } from "./byte_array"

export enum INST {
    LDA_IM = 0xA9,
    LDA_ZP = 0xA5,
    LDA_ZPX = 0xB5,
    LDA_ABS = 0xAD,
    LDA_ABSX = 0xBD,
    LDA_ABSY = 0xB9,

    DEC_ZP = 0xC6,
    DEC_ZPX = 0xD6,
    DEC_ABS = 0xCE,
    DEC_ABSX = 0xDE,

    INX_IMP = 0xE8,
    INY_IMP = 0xC8,

    JMP_ABS = 0x4C,
    JMP_IND = 0x6C,

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

    step() {
        if (this.active == false) {
            return
        }
        let cmd = this.fetch_byte()

        switch (cmd) {
            case 0xFF: {
                game.print(this.memory.get(0xf1) + " " + this.memory.get(0xf2))
            } break;
            case INST.LDA_IM: {
                let data = this.fetch_byte()
                this.a = data
                this.flags.N = (data & 0b10000000) > 0
                this.flags.Z = data == 0
            } break;

            case INST.LDA_ZP: {
                let data = this.fetch_byte()
                data = this.read_byte(data)
                this.a = data
                this.flags.N = (data & 0b10000000) > 0
                this.flags.Z = data == 0
            } break;

            case INST.INX_IMP: {
                this.x = ByteArray.read_byte(this.x + 1, 0)
                this.flags.N = (this.x & 0b10000000) > 0
            } break;

            case INST.INY_IMP: {
                this.y = ByteArray.read_byte(this.y + 1, 0)
                this.flags.N = (this.y & 0b10000000) > 0
            } break;

            case INST.JMP_ABS: {
                this.pc = this.fetch_word()
            } break;

            case INST.JMP_IND: {
                let addr = this.fetch_word()
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
                this.a = ByteArray.read_byte(sum, 0)
                this.flags.Z = this.a == 0
                this.flags.N = (this.a & 0x80) != 0
            } break;

            case INST.ADC_IM: {
                let value = this.fetch_byte()
                let carry = this.flags.C ? 1 : 0
                let sum = (this.a + value + carry) & 0xFFFF
                this.flags.C = sum > 0xFF
                let overflow = (ByteArray.read_byte(this.a ^ sum, 0) & ByteArray.read_byte(value ^ sum, 0)) != 0
                //this.flags.V = overflow
                this.flags.V = sum > 255
                this.a = ByteArray.read_byte(sum, 0)
                this.flags.Z = this.a == 0
                this.flags.N = (this.a & 0x80) != 0
            } break;

            case INST.BCC: {
                if (!this.flags.C) {
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

            case INST.ADC_ZPX: {
                let value = this.fetch_byte()
                value = (this.read_byte(value) + this.x)
                let carry = this.flags.C ? 1 : 0
                let sum = (this.a + value + carry) & 0xFFFF

                this.flags.C = sum > 0xFF00
                let overflow = (ByteArray.read_byte(this.a ^ sum, 0) & ByteArray.read_byte(value ^ sum, 0)) != 0
                this.flags.V = overflow
                this.a = ByteArray.read_byte(sum, 0)
                this.flags.Z = this.a == 0
                this.flags.N = (this.a & 0x80) != 0
            } break;

            case INST.ADC_IM: {
                let value = this.fetch_byte()
                let carry = this.flags.C ? 1 : 0
                let sum = this.a + value + carry

                this.flags.C = sum > 0xFF

                let overflow = (ByteArray.read_byte(this.a ^ sum, 0) & ByteArray.read_byte(value ^ sum, 0)) != 0
                this.flags.V = overflow
                this.a = ByteArray.read_byte(sum, 0)
                this.flags.Z = this.a == 0
                this.flags.N = (this.a & 0x80) != 0
            } break;

            case INST.LDA_IM: {
                this.a = this.fetch_byte()
                this.flags.N = (this.a & 0x80) != 0
                this.flags.Z = this.a == 0
            } break;

            case INST.LDA_ZP: {
                this.a = this.fetch_byte()
                this.a = this.read_byte(this.a)
                this.flags.N = (this.a & 0x80) != 0
                this.flags.Z = this.a == 0
            } break;

            case INST.INX_IMP: {
                this.x = ByteArray.read_byte(this.x + 1, 0)
                this.flags.N = (this.x & 0x80) != 0
                this.flags.Z = this.x == 0
            } break;

            case INST.INY_IMP: {
                this.y = ByteArray.read_byte(this.y + 1, 0)
                this.flags.N = (this.y & 0x80) != 0
                this.flags.Z = this.y == 0
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

    static tests() {
        {

        }
    }

    static inst_add() {
        let tb = CPU.INST_TABLE

    }

    static INST_TABLE: {}
}

