local t = require("modutram.types")

local SlotConfigRepository = require("modutram.slot.SlotConfigRepository")

describe("SlotTypeRepository", function ()
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

    describe("add / get", function ()
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

    describe("getAll", function ()
        it ("returns all slot configs contained in the repository", function ()
            local slotConfigRepository = SlotConfigRepository.makeWithParams(slotTypesFromModLua)

            local expected = {{
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
                type = t.TRAM_DOWN,
                slotType = 'modutram_austria_tram_down_300cm',
                widthInCm = 300,
                namespace = 'austria'
            }}

            assert.are.same(expected, slotConfigRepository:getAll())
        end)
    end)

    describe("makeWithParams", function ()
        it ("creates a SlotConfigRepository instance including all slot configs from the postRunFn()", function ()
            local slotConfigRepository = SlotConfigRepository.makeWithParams(slotTypesFromModLua)

            assert.are.same({{
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_300cm',
                widthInCm = 300,
                namespace = 'austria'
            }}, slotConfigRepository:get(t.TRAM_UP, 300))
        end)
        
    end)
end)