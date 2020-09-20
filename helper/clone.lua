return function (tableToClone)
    local clonedTable = {}

    for key, value in pairs(tableToClone) do
        clonedTable[key] = value
    end

    return clonedTable
end