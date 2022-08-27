require('__poly__.GUI.init_control')

local Class = require('__poly__.Class')

local Component = Class:new('Poly.GUI.Component')

Component.State = { Instantiated = 0, Created = 1 }

function Component:new(args)
    local component = {
        _poly = { index_in_parent = nil },
        state = Component.State.Instantiated,
        name = args.name,
        children = {}
    }
    for idx, child in ipairs(args) do
        component.children[idx] = child
        child._poly.index_in_parent = idx
        local child_name = child:get_name()
        if child_name ~= nil then
            if component[child_name] ~= nil then
                error('invalid name ' .. child_name .. ': component already contains property with the same name', 2)
            end
            component[child_name] = child
        end
    end
    return component
end

function Component:create(parent)
    assert(self.state == Component.State.Instantiated, 'invalid component state: create can only be called on instantiated components')
    for _, child in ipairs(self.children) do
        child:create(parent)
    end
    self.state = Component.State.Created
end

function Component:refresh()
    assert(self.state == Component.State.Created, 'invalid component state: refresh can only be called on created components')
    for _, child in ipairs(self.children) do
        child:refresh()
    end
end

function Component:destroy()
    assert(self.state == Component.State.Created, 'invalid component state: destroy can only be called on created components')
    for _, child in ipairs(self.children) do
        child:destroy()
    end
    self.state = Component.State.Instantiated
end

function Component:delete()
    assert(self.state == Component.State.Instantiated, 'invalid component state: delete can only be called on instantiated components')
    for _, child in ipairs(self.children) do
        child:delete()
    end
    self.state = nil
end

function Component:get_state()
    return self.state
end

function Component:get_name()
    return self.name
end

function Component:add_child(child)
    assert(child._poly.index_in_parent == nil, 'child already belongs to another component')
    local idx = #self.children + 1
    self.children[idx] = child
    child._poly.index_in_parent = idx
    local child_name = child:get_name()
    if child_name ~= nil then
        if self[child_name] ~= nil then
            error('invalid name ' .. child_name .. ': component already contains property with the same name', 2)
        end
        self[child_name] = child
    end
end

function Component:get_child(index_or_name)
    if type(index_or_name) == 'string' then
        return self[index_or_name]
    else
        return self.children[index_or_name]
    end
end

function Component:get_children()
    return Poly.read_only(self.children)
end

function Component:remove_child(index_or_name)
    local child = self:get_child(index_or_name)
    if child:get_state() == Component.State.Created then
        child:destroy()
    end
    for idx = child._poly.index_in_parent, #self.children - 1, 1 do
        self.children[idx] = self.children[idx + 1]
        self.children[idx]._poly.index_in_parent = idx
    end
    self.children[#self.children] = nil
    child._poly.index_in_parent = nil
    local child_name = child:get_name()
    if child_name ~= nil then
        self[child_name] = nil
    end
    return child
end

function Component:delete_child(index_or_name)
    local child = self:remove_child(index_or_name)
    child:delete()
end

function Component:clear_children()
    for _, child in ipairs(self.children) do
        local child_name = child:get_name()
        if child_name ~= nil then
            self[child_name] = nil
        end
        if child:get_state() == Component.State.Created then
            child:destroy()
        end
        child:delete()
    end
    self.children = {}
end

return Component
