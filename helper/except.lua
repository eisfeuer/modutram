local find = require('modutram.helper.find')

return function (originalTable, excludes)
    local result = {}

    for _, value in pairs(originalTable) do
        if not find(excludes, value) then
            table.insert(result, value)
        end
    end

    return result
end