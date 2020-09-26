return function (originalTable, callable)
    local mappedTable = {}

    for _, value in pairs(originalTable) do
        table.insert(mappedTable, callable(value))
    end

    return mappedTable
end