require('__poly__.init_control')

local Class = {
    registered_classes = {}
}

local ClassMetatable = {}
function ClassMetatable.__newindex(ClassTable, k, v)
    assert(k ~= '_Poly', '"_Poly" is a reserved keyword and cannot be used as a class identifier')
    if k == 'new' then
        if type(v) ~= 'function' then
            assert(false, 'constructor "new" has to be a function')
        end
        -- wrap new function to set metatable and class name
        ClassTable._Poly.wrapped_functions.new = v
        v = function(self, ...)
            local object = self._Poly.wrapped_functions.new(self, ...)
            setmetatable(object, self)
            return object
        end
    end
    ClassTable._Poly.entries[k] = v
end
function ClassMetatable.__index(ClassTable, k)
    return ClassTable._Poly.entries[k]
end

function Class:new(class_name, base_class)
    assert(class_name ~= nil, 'missing argument: class_name')
    if self:is_registered_class_name(class_name) then
        assert(false, 'duplicate class name ' .. class_name)
    end
    if base_class ~= nil and not self:is_registered_class(base_class) then
        assert(false, 'base class has to be a previously registered class or nil')
    end
    -- create class table
    local ClassTable
    if base_class ~= nil then
        ClassTable = Poly.deep_copy(base_class)
        ClassTable._Poly.class_name = class_name
    else
        ClassTable = {
            _Poly = {
                class_name = class_name,
                wrapped_functions = {},
                entries = {}
            }
        }
    end
    -- register class as metatable to persist them on save/load
    script.register_metatable(class_name, ClassTable)
    -- set __index metamethod for use in objects
    ClassTable.__index = ClassTable
    -- set class metatable to intercept class definitions
    setmetatable(ClassTable, ClassMetatable)
    -- store class in registered classes
    Class.registered_classes[class_name] = ClassTable
    -- return new class
    return ClassTable
end

function Class:is_registered_class_name(class_name)
    return Class.registered_classes[class_name] ~= nil
end

function Class:is_registered_class(class)
    return type(class) == 'table' and getmetatable(class) == ClassMetatable
            and Class:is_registered_class_name(class._Poly.class_name)
end

function Class:get(class_name)
    assert(Class:is_registered_class_name(class_name), 'no such class: ' .. class_name)
    return Class.registered_classes[class_name]
end

return Class
