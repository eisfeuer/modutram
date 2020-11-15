local Bus = require('modutram.grid_module.Bus')

-- @module modutram.grid_module.BusUpLeft
local BusUpLeftClass = {}

function BusUpLeftClass:new(Bus)
    local BusUpLeft = Bus
    BusUpLeft.class = 'BusUpLeft'

    return BusUpLeft
end

function BusUpLeftClass.getParentClass()
    return Bus
end

return BusUpLeftClass