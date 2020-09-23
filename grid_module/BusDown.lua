local Bus = require('modutram.grid_module.Bus')

-- @module modutram.grid_module.BusDown
local BusDownClass = {}

function BusDownClass:new(Bus)
    local BusDown = Bus
    BusDown.class = 'BusDown'

    return BusDown
end

function BusDownClass.getParentClass()
    return Bus
end

return BusDownClass