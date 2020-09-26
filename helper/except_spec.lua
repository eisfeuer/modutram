local except = require('modutram.helper.except')

describe('except', function ()
    it ('excludes given values from array', function ()
        local array = {1, 2, 3, 4, 5}
        local result = except(array, {2, 5})
        assert.are.same({1, 3, 4}, result)
        assert.are_not.equal(array, result)
    end)
end)