local getIndexOrAddNewTable = require('modutram.helper.getIndexOrAddNewTable')

describe("getIndexOrAddNewTable", function ()
    it ('gets existing index', function ()
        local table = {
            subtable = {}
        }

        assert.are.equal(table.subtable, getIndexOrAddNewTable(table, 'subtable'))
    end)

    it ("creates new table add assigns it to table", function ()
        local table = {}

        local subtable = getIndexOrAddNewTable(table, 'subtable')

        assert.are.same({}, subtable)
        assert.are.equal(subtable, table.subtable)
    end)
end)