class ByteArray {
    bytes: Array<number>
    constructor() {
        this.bytes = new Array<number>()
        for (let i: number = 0; i < 0xFFFF / 8; i++) {
            this.bytes[i] = 0
        }
    }

    get(index: number): number {
        const id = index >> 2;
        const shift = (index & 3) << 3;
        return (this.bytes[id] >> shift) & 0xff;
    }

    set(index: number, value: number) {
        const id = index >> 2;
        const shift = (index & 3) << 3;
        const mask = 0xff << shift;
        this.bytes[id] = (this.bytes[id] & ~mask) | ((value & 0xff) << shift);
    }

    fill(index: number, data: Array<number>) {
        for (let i: number = 0; i < data.length; i++) {
            this.set(index + i, data[i] & 0xFF)
        }
    }

    static read_byte(data: number, byte: number) {
        return data & (0xff << (byte * 8))
    }

    static TEST() {
        {
            let tests = [
                [0, 1, 2, 3, 4, 5, 6, 7, 8],
                [0xF, 0x19, 0x40, 0xD7, 0xFF, 0xF9, 0xAB, 0xAC, 0xCD]
            ]

            let desc: string = "\nByteArray get/set byte tests"
            let arr: ByteArray = new ByteArray()

            tests.forEach((_el, id, _ar) => {
                arr.set(tests[0][id], tests[1][id])
            });

            tests.forEach((_el, id, _ar) => {
                assert(arr.get(tests[0][id]) == tests[1][id], desc + "\nexpected: " + tests[1][id] + "\nresult: " + arr.get(tests[0][id]))
            });
        }


        {
            for (let i: number = 1; i < 10; i++) {
                let tests = [
                    [i],
                    [1, 2, 3, 4, 8, 9, 1, 123, 253]
                ]

                let desc: string = "\nByteArray fill bytes tests"
                let arr: ByteArray = new ByteArray()
                arr.fill(tests[0][0], Array.from(tests[1]))
                for (let i: number = tests[0][0]; i < tests[1].length + tests[0][0]; i++) {
                    assert(arr.get(i) == tests[1][i - tests[0][0]], desc + "\nexpected: " + tests[1][i - tests[0][0]] + "\nresult: " + arr.get(i))
                }
            }
        }
    }
}


enum INST {
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
}

class Flags {
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

class CPU {
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
            case INST.LDA_IM:
                let data = this.fetch_byte()
                this.a = data
                this.flags.N = (data & 0b10000000) > 0
                this.flags.Z = data == 0
                break;

            case INST.INX_IMP:
                this.x = ByteArray.read_byte(this.x + 1, 0)
                this.flags.N = (this.x & 0b10000000) > 0
                break;

            case INST.INY_IMP:
                this.y = ByteArray.read_byte(this.y + 1, 0)
                this.flags.N = (this.y & 0b10000000) > 0
                break;

            case INST.JMP_ABS:
                this.pc = this.fetch_word()
                break;

            case INST.JMP_IND:
                let addr = this.fetch_word()
                this.pc = this.read_word(addr)
                break;

            case INST.ADC_ZP:
                {
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
                    game.print(this.a)
                }
                break;

            case INST.ADC_ZPX:
                {
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
                    game.print(this.a)
                }
                break;

            case INST.ADC_IM:
                {
                    let value = this.fetch_byte()
                    let carry = this.flags.C ? 1 : 0
                    let sum = this.a + value + carry

                    this.flags.C = sum > 0xFF

                    let overflow = (ByteArray.read_byte(this.a ^ sum, 0) & ByteArray.read_byte(value ^ sum, 0)) != 0
                    this.flags.V = overflow
                    this.a = ByteArray.read_byte(sum, 0)
                    this.flags.Z = this.a == 0
                    this.flags.N = (this.a & 0x80) != 0
                }
                break;

            case 0x4:
                this.a = ByteArray.read_byte(this.a + this.fetch_byte(), 0)
                break;

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
}

script.on_event(defines.events.on_player_created, () => {
    let player = game.players[1]
    const frame = player.gui.screen.add({
        type: "frame",
        name: "my_frame",
        direction: "vertical"
    });

    // Добавляем пустой виджет для перетаскивания
    const flow_widget = frame.add({
        type: "flow",
        name: "drag_widget",
    });

    const drag_widget = flow_widget.add({
        type: "empty-widget",
        name: "drag_widget",
        style: "draggable_space"
    });

    const close = flow_widget.add({
        type: "sprite-button",
        name: "cpu-close-window",
        sprite: "utility/close",
        style: "frame_action_button",
    })

    close.style.left_margin = 4
    drag_widget.drag_target = frame;

    drag_widget.style.horizontally_stretchable = true;
    drag_widget.style.height = 20; // Достаточно места для удобного захвата
    drag_widget.style.margin = [0, 0, 4, 0]; // Немного отступа снизу

    // Центрируем окно на экране
    frame.auto_center = true;
    let tb = frame.add({ type: "text-box", name: "cpu-code" })
    tb.style.height = (20 * 20) + 8
    frame.add({ type: "button", name: "cpu-execute" })
})

let cpu = new CPU([INST.ADC_ZP, 5, INST.JMP_ABS, 0x0, 0x0, 0xF1]);
script.on_event(defines.events.on_tick, () => {
    cpu.step()
    //game.print(0b1001 & 0b1100)
})

script.on_event(defines.events.on_gui_click, (data) => {
    if (data.element.name != "cpu-execute") { return }
    let exec = data.element
    cpu.active = !cpu.active
})
/*
script.on_event(defines.events.on_gui_click, (data) => {
    if (data.element.name != "cpu-close-window") { return }
    data.element.parent.parent.destroy()
})

*/
