local t = require("modutram.types")

local SlotConfigRepository = require("modutram.slot.SlotConfigRepository")

describe("SlotTypeRepository", function ()
    describe("add / get", function ()
        local slotTypesFromModLua = {{
            type = t.TRAM_UP,
            slotType = 'modutram_austria_tram_up_300cm',
            widthInCm = 300,
            namespace = 'austria'
        }, {
            type = t.TRAM_UP,
            slotType = 'modutram_austria_tram_up_300cm',
            widthInCm = 330,
            namespace = 'austria'
        }, {
            type = t.TRAM_UP,
            slotType = 'modutram_austria_tram_up_300cm',
            widthInCm = 300,
            namespace = 'austria'
        }, {
            type = t.TRAM_DOWN,
            slotType = 'modutram_austria_tram_down_300cm',
            widthInCm = 300,
            namespace = 'austria'
        }}

        local slotConfigRepository = SlotConfigRepository:new{}

        for _, slotConfig in pairs(slotTypesFromModLua) do
            slotConfigRepository:add(slotConfig)
        end

        it ("gets slot types by type and width", function ()
            assert.are.same({{
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_300cm',
                widthInCm = 300,
                namespace = 'austria'
            }}, slotConfigRepository:get(t.TRAM_UP, 300))
        end)

        it ("gets slot types by type", function ()
            assert.are.same({
                {
                    type = t.TRAM_UP,
                    slotType = 'modutram_austria_tram_up_300cm',
                    widthInCm = 300,
                    namespace = 'austria'
                }, {
                    type = t.TRAM_UP,
                    slotType = 'modutram_austria_tram_up_300cm',
                    widthInCm = 330,
                    namespace = 'austria'
                }
            }, slotConfigRepository:get(t.TRAM_UP))
        end)
    end)
end)