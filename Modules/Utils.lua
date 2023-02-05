local utils = {}

function utils.switch(cases, caseIndex)
    local curCase = cases[caseIndex]
    return assert(load('return' .. curCase.tostring()))()
end

return utils
