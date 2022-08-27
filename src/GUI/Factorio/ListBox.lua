-- Poly: generated for Factorio 1.1.67 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local ListBox = Class:new('Poly.GUI.ListBox', FactorioComponent)

function ListBox:new(args)
    local list_box = FactorioComponent:new(args)
    list_box.lua_gui_element_parameters.type = 'list-box'
    
    list_box.lua_gui_element_parameters.items = args.items
    list_box.lua_gui_element_parameters.selected_index = args.selected_index
    
    return list_box
end

function ListBox:get_items()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.items
    else
        return self.lua_gui_element_parameters.items
    end
end
function ListBox:set_items(items)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.items = items
    end
    self.lua_gui_element_parameters.items = items
end

function ListBox:get_selected_index()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.selected_index
    else
        return self.lua_gui_element_parameters.selected_index
    end
end
function ListBox:set_selected_index(selected_index)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.selected_index = selected_index
    end
    self.lua_gui_element_parameters.selected_index = selected_index
end

function ListBox:add_item(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.add_item(...)
end

function ListBox:clear_items(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.clear_items(...)
end

function ListBox:get_item(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    return self.lua_gui_element.get_item(...)
end

function ListBox:remove_item(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.remove_item(...)
end

function ListBox:scroll_to_item(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.scroll_to_item(...)
end

function ListBox:set_item(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.set_item(...)
end

return ListBox
