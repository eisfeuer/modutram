local Station = require('modutram.station')

describe('Station', function ()
    describe('bindToResults', function ()
        it('binds empty station to results', function ()
            local station = Station:new{}

            local result = {}

            station:bindToResult(result)

            assert.are.same({{
                id = 'asset/icon/marker_question.mdl',
                transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
            }}, result.models)
        end)
    end)
end)