return function (affectedTable)
    local result = {}

    for key, _ in pairs(affectedTable) do
        table.insert(result, key)
    end

    return result
end