local merge = require('modutram.helper.merge')

describe('merge', function ()
    describe('it merges two tables (record)', function ()
        assert.are.same(
            {a = 1, b = 2, c = 3},
            merge({a = 1, b = 1}, {b = 2, c = 3})
        )
    end)
end)