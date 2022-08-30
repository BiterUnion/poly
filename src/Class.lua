require('__poly__.init_control')

local Helper = require('__poly__.Helper')

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
        -- wrap new function to set metatable
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

function Class:new(class_id, base_class)
    assert(class_id ~= nil, 'missing argument: class_id')
    if self:is_registered_class_id(class_id) then
        assert(false, 'duplicate class id ' .. class_id)
    end
    if base_class ~= nil and not self:is_registered_class(base_class) then
        assert(false, 'base class has to be a previously registered class or nil')
    end
    -- create class table
    local ClassTable
    if base_class ~= nil then
        ClassTable = Helper.deep_copy(base_class)
        ClassTable._Poly.class_id = class_id
    else
        ClassTable = {
            _Poly = {
                class_id = class_id,
                wrapped_functions = {},
                entries = {}
            }
        }
    end
    -- register class as metatable to persist them on save/load
    script.register_metatable(class_id, ClassTable)
    -- set __index metamethod for use in objects
    ClassTable.__index = ClassTable
    -- set class metatable to intercept class definitions
    setmetatable(ClassTable, ClassMetatable)
    -- store class in registered classes
    Class.registered_classes[class_id] = ClassTable
    -- return new class
    return ClassTable
end

function Class:is_registered_class_id(class_id)
    return Class.registered_classes[class_id] ~= nil
end

function Class:is_registered_class(class)
    return type(class) == 'table' and getmetatable(class) == ClassMetatable
            and Class:is_registered_class_id(class._Poly.class_id)
end

function Class:get(class_id)
    assert(Class:is_registered_class_id(class_id), 'no such class: ' .. class_id)
    return Class.registered_classes[class_id]
end

function Class:instance_of(object, class)
    return object and class and object._Poly and object._Poly.class_id == class.class_id
end

return Class
