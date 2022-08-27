-- Poly: generated for Factorio 1.1.68 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local DropDown = Class:new('Poly.GUI.DropDown', FactorioComponent)

function DropDown:new(args)
    local drop_down = FactorioComponent:new(args)
    drop_down.lua_gui_element_parameters.type = 'drop-down'
    
    drop_down.lua_gui_element_parameters.items = args.items
    drop_down.lua_gui_element_parameters.selected_index = args.selected_index
    
    return drop_down
end

function DropDown:get_items()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.items
    else
        return self.lua_gui_element_parameters.items
    end
end
function DropDown:set_items(items)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.items = items
    end
    self.lua_gui_element_parameters.items = items
end

function DropDown:get_selected_index()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.selected_index
    else
        return self.lua_gui_element_parameters.selected_index
    end
end
function DropDown:set_selected_index(selected_index)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.selected_index = selected_index
    end
    self.lua_gui_element_parameters.selected_index = selected_index
end

function DropDown:add_item(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.add_item(...)
end

function DropDown:clear_items(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.clear_items(...)
end

function DropDown:get_item(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    return self.lua_gui_element.get_item(...)
end

function DropDown:remove_item(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.remove_item(...)
end

function DropDown:set_item(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.set_item(...)
end

return DropDown
