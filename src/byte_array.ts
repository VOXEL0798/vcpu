export class ByteArray {
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
