local optional = require('modutram.helper.optional')

describe('optional', function ()
    it('returns value', function ()
        local aTable = { cat = 'meow' }

        assert.are.equal('meow', optional(aTable).cat)
    end)

    it ('returns nil when table does not exists', function ()
        assert.is_nil(optional(nil).cat)
    end)
end)