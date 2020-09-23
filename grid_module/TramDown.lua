local Tram = require('modutram.grid_module.Tram')

-- @module modutram.grid_module.TramDown
local TramDownClass = {}

function TramDownClass:new(Tram)
    TramDown = Tram
    TramDown.class = 'TramDown'

    return TramDown
end

function TramDownClass.getParentClass()
    return Tram
end

return TramDownClass