local Station = require('modutram.Station')

local Modutram = {}

function Modutram.initialize(params, paramsFromModLua, config)
    local station = Station:new{paramsFromModLua = paramsFromModLua}

    station:registerAllModules(params.modules)

    return station
end

return Modutram