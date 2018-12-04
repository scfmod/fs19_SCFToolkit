---@class IClass
IClass = log30_Class('IClass')

getmetatable(IClass).__tostring = function(t)
    return "IClass <" .. (t.name or 'unknown') .. ">"
end