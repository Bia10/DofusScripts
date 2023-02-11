local utils = {}

function utils.getValueFromKey(table, key)
    for _, value in ipairs(key) do
        if string.find(string.upper(key), string.upper(value)) then
            return table[value]
        end
    end
    return false
end

function utils.tablePrint(table, indent)
    if not indent then indent = 0 end
    for key, value in pairs(table) do
        local formatting = string.rep("  ", indent) .. key .. ": "
        if type(value) == "table" then
            print(formatting)
            utils.tablePrint(value, indent + 1)
        elseif type(value) == 'boolean' then
            print(formatting .. tostring(value))
        elseif type(value) == "function" then
            print(formatting .. tostring(value))
        else
            print(formatting .. value)
        end
    end
end

function utils.firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

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
    return assert(load('return' .. curCase.tostring()))
end

return utils
