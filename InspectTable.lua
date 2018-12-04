---@class InspectTable
InspectTable = IClass:extend('InspectTable')

InspectTable.MAX_DEPTH = 4

--------

-- TODO:
-- * userdata?

--------

local function sortByName(tbl)
    local result = {}
    for k,v in sortPairs(tbl, function(t, a, b) return t[a].name < t[b].name end) do
        table.insert(result, v)
    end
    return result
end

--------

---@param name string
---@param tbl table
function InspectTable:init(name, tbl)
    name = name or 'empty'
    self.name = name
    self.src = tbl
    self.maxDepthReached = false
    self.error = nil
    self.functions = {}
    self.variables = {}
end

--------

---Get sorted list of functions
---@return table
function InspectTable:getFunctions()
    return sortByName(self.functions)
end

---Get sorted list of variables
---@return table
function InspectTable:getVariables()
    return sortByName(self.variables)
end

---Traverse table for information
---@return boolean
function InspectTable:traverse(depth, maxDepth)
    depth = depth or 1

    -- reset values in case they are set
    self.functions = {}
    self.variables = {}

    -- check variable type
    if type(self.src) ~= 'table' then
        --error('InspectTable:traverse() - Expected table, got: ' .. type(self.src))
        print('-- InspectTable:traverse() - Expected table, got: ' .. type(self.src) .. ' | ' .. self.name)
        print('-- Value: ' .. tostring(self.src))
        return false
    end

    -- check depth
    if maxDepth ~= nil and depth > maxDepth then
        self.maxDepthReached = true
        return
    elseif depth > InspectTable.MAX_DEPTH then
        self.maxDepthReached = true
        return
    end

    -- loop table
    for k,v in pairs(self.src) do
        local t = type(v)

        if t == 'function' then
            table.insert(self.functions, {
                name = k,
                value = 'function'
            })
        elseif t == 'table' then
            local inspect = InspectTable(tostring(k), v)

            -- todo check function return value [priority=low]
            inspect:traverse(depth + 1, maxDepth)

            table.insert(self.variables, {
                name = k,
                value = inspect
            })
        else
            table.insert(self.variables, {
                name = k,
                value = v
            })
        end
    end

    return true
end

--------

function InspectTable:print()
    print(self.name .. ' = {')

    local variables = self:getVariables()
    local functions = self:getFunctions()

    for v=1, #variables do
        local entry = variables[v]
        local name = entry.name
        if type(name) == 'number' then
            name = '[' .. name .. ']'
        end

        if type(entry.value) == 'table' then
            print(tabString(1) .. tostring(name) .. ' = {')

            if entry.value.maxDepthReached then
                print(tabString(2) .. '-- MAX_DEPTH inspect limit')
            else
                entry.value:printAsChildEntry(2)
            end
            if v == #variables then
                print(tabString(1) .. '}')
            else
                print(tabString(1) .. '},')
            end
        elseif type(entry.value) == 'string' then
            if v == #variables then
                print(tabString(1) .. tostring(name) .. ' = \'' .. entry.value .. '\'')
            else
                print(tabString(1) .. tostring(name) .. ' = \'' .. entry.value .. '\',')
            end
        else
            if v == #variables then
                print(tabString(1) .. tostring(name) .. ' = ' .. tostring(entry.value))
            else
                print(tabString(1) .. tostring(name) .. ' = ' .. tostring(entry.value) .. ',')
            end
        end
    end

    print('}')
    if #functions > 0 then
        print('')
    end

    for f=1, #functions do
        local entry = functions[f]
        print('function ' .. self.name .. ':' .. tostring(entry.name) .. '() end')
    end
end

function InspectTable:printAsChildEntry(depth)
    local variables = self:getVariables()
    local functions = self:getFunctions()

    for v=1, #variables do
        local entry = variables[v]
        local name = entry.name
        if type(name) == 'number' then
            name = '[' .. name .. ']'
        end

        if type(entry.value) == 'table' then

            print(tabString(depth) .. tostring(name) .. ' = {')

            if entry.value.maxDepthReached then
                print(tabString(depth) .. ' -- MAX_DEPTH inspect limit')
            else
                entry.value:printAsChildEntry(depth + 1)
            end

            if v == #variables then
                print(tabString(depth) .. '}')
            else
                print(tabString(depth) .. '},')
            end
        elseif type(entry.value) == 'string' then
            if v == #variables and #functions < 1 then
                print(tabString(depth) .. tostring(name) .. ' = \'' .. entry.value .. '\'')
            else
                print(tabString(depth) .. tostring(name) .. ' = \'' .. entry.value .. '\',')
            end
        else
            if v == #variables and #functions < 1 then
                print(tabString(depth) .. tostring(name) .. ' = ' .. tostring(entry.value))
            else
                print(tabString(depth) .. tostring(name) .. ' = ' .. tostring(entry.value) .. ',')
            end
        end
    end

    for f=1, #functions do
        local entry = functions[f]
        local name = entry.name
        if type(name) == 'number' then
            name = '[' .. name .. ']'
        end

        if f == #functions then
            print(tabString(depth) .. tostring(name) .. ' = function() end')
        else
            print(tabString(depth) .. tostring(name) .. ' = function() end,')
        end
    end
end

--------

---@type InspectTable
DebugUtil.InspectTable = InspectTable