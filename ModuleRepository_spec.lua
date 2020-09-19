local ModuleRepository = require('modutram.ModuleRepository')
local t = require('modutram.types')

describe('ModuleRepository', function ()
    describe('isModutramModule', function ()
        it ('checks weather a module belongs to modutram', function ()
            assert.is_false(ModuleRepository.isModutramItem({
                type = 'track_module'
            }))
            assert.is_false(ModuleRepository.isModutramItem({
                type = 'modutram_track'
            }))
            assert.is_false(ModuleRepository.isModutramItem({
                type = 'modutram_austria_tram_up_300cm'
            }))
            assert.is_true(ModuleRepository.isModutramItem({
                type = 'modutram_tram_up_300cm'
            }))
            assert.is_true(ModuleRepository.isModutramItem({
                type = 'modutram_asset'
            }))
            assert.is_true(ModuleRepository.isModutramItem({
                type = 'modutram_asset_bench'
            }))
            assert.is_true(ModuleRepository.isModutramItem({
                type = 'modutram_decoration'
            }))
            assert.is_true(ModuleRepository.isModutramItem({
                type = 'modutram_decoration_clock'
            }))
            assert.is_true(ModuleRepository.isModutramItem({
                type = 'modutram_austria_tram_up_300cm'
            }, 'austria'))
            assert.is_true(ModuleRepository.isModutramItem({
                type = 'modutram_berlin_tramstation_tram_up_300cm'
            }, 'berlin_tramstation'))
        end)
    end)

    describe('convertModule', function ()
        it ('converts module to a table with all necessare information for modutram', function ()
            local result = ModuleRepository.convertModule({
                type = 'modutram_austria_tram_up_300cm'
            }, 'austria')

            assert.are.same({
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_300cm',
                widthInCm = 300,
                namespace = 'austria'
            }, result)

            result = ModuleRepository.convertModule({
                type = 'modutram_austria_asset_bench'
            }, 'austria')

            assert.are.same({
                type = t.ASSET,
                slotType = 'modutram_austria_asset_bench',
                widthInCm = nil,
                namespace = 'austria'
            }, result)

            result = ModuleRepository.convertModule({
                type = 'modutram_asset_bench'
            })

            assert.are.same({
                type = t.ASSET,
                slotType = 'modutram_asset_bench',
                widthInCm = nil,
                namespace = nil
            }, result)
        end)
    end)
end)