local find = require('modutram.helper.find')

describe('find', function ()
    it ('finds value in a table', function ()
        local table1 = { 2, 4, 6, 8 }
        local table2 = { a = 1, b = 2, c = 3}

        assert.are.equal(2, find(table1, 4))
        assert.are.equal('b', find(table2, 2))

        assert.is_nil(find(table1, 7))
        assert.is_nil(find(table2, 6))
    end)
end)