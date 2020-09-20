local Config = require('modutram.Config')

local Station = {}

function Station:new(o)
    o = o or {}

    o.config = Config:new(o.config)

    setmetatable(o, self)
    self.__index = self
    return o
end

function Station:bindToResult(result)
    result.models = result.models or {}

    if #result.models == 0 then
        table.insert(result.models, {
            id = 'asset/icon/marker_question.mdl',
            transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
        })
    end
end

return Station