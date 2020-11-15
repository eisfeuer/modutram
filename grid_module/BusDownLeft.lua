local Bus = require('modutram.grid_module.Bus')

-- @module modutram.grid_module.BusDownLeft
local BusDownLeftClass = {}

function BusDownLeftClass:new(Bus)
    local BusDownLeft = Bus
    BusDownLeft.class = 'BusDownLeft'

    return BusDownLeft
end

function BusDownLeftClass.getParentClass()
    return Bus
end

return BusDownLeftClass