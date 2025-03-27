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

class CPU {
    active: boolean

    pc: number
    sp: number
    bp: number

    a: number
    x: number
    y: number

    memory: ByteArray

    constructor(program: Array<number>) {
        this.active = false
        this.memory = new ByteArray()
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

    }

    step() {
        if (this.active == false) {
            return
        }
        let cmd = this.fetch_byte()
        switch (cmd) {
            case 0x1:
                this.a = ByteArray.read_byte(this.a + 1, 0)
                break;
            case 0x2:
                game.print(this.a)
                break;
            case 0x3:
                this.pc = 0;
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

let cpu = new CPU([0x4, 5, 0x2, 0x3]);
script.on_event(defines.events.on_tick, () => {
    cpu.step()
    //game.print(0b1001 & 0b1100)
})

script.on_event(defines.events.on_gui_click, (data) => {
    game.print("click!")
    if (data.element.name != "cpu-execute") { return }
    let exec = data.element
    cpu.active = !cpu.active
    //
    //    if (type(exec.state) == "boolean") {
    //  }
})

script.on_event(defines.events.on_gui_click, (data) => {
    if (data.element.name != "cpu-close-window") { return }
    data.element.parent.parent.destroy()
})


