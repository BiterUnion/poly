-- require Poly's Class API
local Class = require('__poly__.Class')

-- == Define a new class called ExampleClass ======================================
local ExampleClass = Class:new('examples.ExampleClass')

-- define ExampleClass's "new" function (a.k.a. its constructor)
function ExampleClass:new(param1, param2)
    -- return a new object of this class (metatable is automatically set by Poly)
    return {
        attr1 = param1,
        attr2 = param2
    }
end

-- define a class method, e.g., a setter for attr1
function ExampleClass:set_attr1(attr1)
    self.attr1 = attr1
end

-- create a new object of ExampleClass
local my_example_object = ExampleClass:new(1, 'foo')
-- call class method 'set_attr1' with argument 5 on my_example_object
my_example_object:set_attr1(5)


-- == Define a new class that is derived from ExampleClass ========================
local DerivedClass = Class:new('examples.DerivedClass', ExampleClass)

-- override "new" of ExampleClass
function DerivedClass:new()
    -- call super class constructor
    return ExampleClass:new(2, 'bar')
end

-- create a new object of DerivedClass
local my_derived_object = DerivedClass:new()
-- call inherited class method 'set_attr1' with argument 10 on my_derived_object
my_derived_object:set_attr1(10)
