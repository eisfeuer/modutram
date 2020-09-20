local clone = require('modutram.helper.clone')

return function (a, b)
    local merged = clone(a)

    for key, value in pairs(b) do
        merged[key] = value
    end

    return merged
end