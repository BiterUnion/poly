.. include:: /substitutions.rst

Class Mechanism
===============

|Framework| uses `Lua metatables to simulate a class mechanism <https://www.lua.org/pil/16.1.html>`_. The following example class illustrates |Framework's| Class API:

.. literalinclude:: ../../test_mod/src/examples/class_mechanism.lua
   :language: lua
   :linenos:

Some additional notes on the Class API:

* The class method ``new`` is a special member function. It is the classes constructor and, if defined, has to return a new instance of the class. It can optionally take arguments. You do *not* have to set instance's metatable yourself, |Framework| takes care of that for you.
* To make the class mechanism work, all calls to member and static member functions of a class have to use the colon notation, e.g., ``ExampleClass:new(1, 'foo')`` and ``my_example_object:set_attr1(5)``. Definitions of class methods have to use the colon notation as well, e.g., ``function ExampleClass:set_attr1(attr1) ...``.
* The ``Class:new`` function takes an optional second argument ``base_class``. This allows for class inheritance, when passing another previously defined class. The derived class provides all functions of the base class. Defining functions in the derived class overrides the corresponding function in the base class. Note that when overriding the ``new`` function, you are responsible for correctly initializing the base class object, e.g., by calling the base class constructor.
* |Framework| may persist class instances in Factorio's ``global`` table, e.g. for event handling, so it is generally a good idea to only store compatible types in class instances, e.g. numbers, strings, LuaGuiElements, and *not* functions, for example.
