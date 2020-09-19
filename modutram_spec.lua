local Modutram = require('modutram.modutram')

describe('modutram', function ()
    describe('initialize', function ()
        it('initializes the modular tram station', function ()
            local result = {}

            Modutram.initialize({}, {}):bindToResult(result)

            assert.are.same({{
                id = 'asset/icon/marker_question.mdl',
                transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
            }}, result.models)
        end)
    end)
end)