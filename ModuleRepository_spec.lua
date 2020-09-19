local ModuleRepository = require('modutram.ModuleRepository')

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
                type = 'modutram_austria760_tram_up_300cm'
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
                type = 'modutram_austria760_tram_up_300cm'
            }, 'austria760'))
            assert.is_true(ModuleRepository.isModutramItem({
                type = 'modutram_berlin_tramstation_tram_up_300cm'
            }, 'berlin_tramstation'))
        end)
    end)
end)