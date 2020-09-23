local Bus = require('modutram.grid_module.Bus')

-- @module modutram.grid_module.BusUp
local BusUpClass = {}

function BusUpClass:new(Bus)
    local BusUp = Bus
    BusUp.class = 'BusUp'

    return BusUp
end

function BusUpClass.getParentClass()
    return Bus
end

return BusUpClass