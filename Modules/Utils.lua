local utils = {}

function utils.GetArgs(func)
    local args = {}
    for i = 1, debug.getinfo(func).nparams, 1 do
        table.insert(args, i, debug.getlocal(func));
    end
    return args;
end

function utils.IsTableEmpty(table)
    -- localize next(), implies lookup in array of locals vs lookup in hashtable of globals
    local nextFunc = next
    -- check if value of element at initial index is not found
    return nextFunc(table) == nil
end

function utils.switch(cases, caseIndex)
    local curCase = cases[caseIndex]
    return assert(load('return' .. curCase.tostring()))()
end

return utils
