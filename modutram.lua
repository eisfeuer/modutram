local Station = require('modutram.station')

local Modutram = {}

function Modutram.initialize(params, paramsFromModLua, config)
    return Station:new{}
end

return Modutram