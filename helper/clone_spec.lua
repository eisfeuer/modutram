local clone = require('modutram.helper.clone')

describe('clone', function ()
    it('clones a table', function ()
        local table = {a = 1, b = 2}

        local clonedTable = clone(table)

        assert.are.same(table, clonedTable)
        assert.are_not.equal(table, clonedTable)
    end)
end)