local Bus = require('modutram.grid_module.Bus')

-- @module modutram.grid_module.BusDownRight
local BusDownRightClass = {}

function BusDownRightClass:new(Bus)
    local BusDownRight = Bus
    BusDownRight.class = 'BusDownRight'

    return BusDownRight
end

function BusDownRightClass.getParentClass()
    return Bus
end

return BusDownRightClass