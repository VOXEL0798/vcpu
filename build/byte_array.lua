local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__ArrayForEach = ____lualib.__TS__ArrayForEach
local __TS__ArrayFrom = ____lualib.__TS__ArrayFrom
local ____exports = {}
____exports.ByteArray = __TS__Class()
local ByteArray = ____exports.ByteArray
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
        local arr = __TS__New(____exports.ByteArray)
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
                local arr = __TS__New(____exports.ByteArray)
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
return ____exports
