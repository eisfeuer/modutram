local map = require("modutram.helper.map")

describe("map", function ()
    it("maps array like tables", function ()
        local originalTable = {1, 2, 3}

        local mappedTable = map(originalTable, function (value)
            return value + 1
        end)

        assert.are.same({1, 2, 3}, originalTable)
        assert.are.same({2, 3, 4}, mappedTable)
    end)
end)