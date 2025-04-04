import { CPU, INST } from "./cpu"

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
    frame.add({ type: "checkbox", name: "cpu-execute", state: false })
})

let CODE = [
    INST.LDA_ZP, 0xF1,
    INST.ADC_IM, 0x40,
    INST.STA_ZP, 0xF1,
    INST.BVS, 0x0, 0x0,
    INST.CLD,
    INST.CLV,
    INST.LDA_ZPX, 0xF2,
    INST.ADC_IM, 0x1,
    INST.STA_ZP, 0xF2,
    INST.CLD,
    INST.CLV,
    INST.JMP_ABS, 0x0, 0x0,
]

let cpu = new CPU(CODE);
script.on_event(defines.events.on_tick, () => {
    cpu.step()
    //Object.keys(INST).forEach(element => {
    //    game.print(INST[element])
    //});
})

script.on_event(defines.events.on_gui_click, (data) => {
    switch (data.element.name) {
        case "cpu-execute": {
            let exec = data.element
            cpu.active = exec.state as boolean
        } break;

        case "cpu-close-window": {
            data.element.parent.parent.destroy()
        } break;
    }
})
/*
script.on_event(defines.events.on_gui_click, (data) => {
    if (data.element.name != "cpu-close-window") { return }
})

*/
