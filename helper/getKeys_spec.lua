local find = require("modutram.helper.find")

local getKeys = require("modutram.helper.getKeys")

describe("getKeys", function ()
    it ("returns array with keys from an table", function ()
        local table = {
            a = 1,
            b = 2,
            c = 3
        }

        local result = getKeys(table)

        assert.are.equal(3, #result)

        assert.are_not.equal(nil, find(result, 'a'))
        assert.are_not.equal(nil, find(result, 'b'))
        assert.are_not.equal(nil, find(result, 'c'))

        assert.are_not.equal(table, result)
    end)
end)