local Bus = require('modutram.grid_module.Bus')

-- @module modutram.grid_module.BusUpRight
local BusUpRightClass = {}

function BusUpRightClass:new(Bus)
    local BusUpRight = Bus
    BusUpRight.class = 'BusUpRight'

    return BusUpRight
end

function BusUpRightClass.getParentClass()
    return Bus
end

return BusUpRightClass