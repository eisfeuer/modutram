local Tram = require('modutram.grid_module.Tram')

-- @module modutram.grid_module.TramBidirectionalLeft
local TramBidirectionalLeftClass = {}

function TramBidirectionalLeftClass:new(Tram)
    local TramBidirectionalLeft = Tram
    TramBidirectionalLeft.class = 'TramBidirectionalLeft'

    return TramBidirectionalLeft
end

function TramBidirectionalLeftClass.getParentClass()
    return Tram
end

return TramBidirectionalLeftClass