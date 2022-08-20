-- Poly: generated for Factorio 1.1.67 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local ScrollPane = Class:new('ScrollPane', FactorioComponent)

function ScrollPane:new(args)
    local scroll_pane = FactorioComponent:new(args)
    scroll_pane.lua_gui_element_parameters.type = 'scroll-pane'
    
    scroll_pane.lua_gui_element_parameters.horizontal_scroll_policy = args.horizontal_scroll_policy
    scroll_pane.lua_gui_element_parameters.vertical_scroll_policy = args.vertical_scroll_policy
    
    return scroll_pane
end

function ScrollPane:get_horizontal_scroll_policy()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.horizontal_scroll_policy
    else
        return self.lua_gui_element_parameters.horizontal_scroll_policy
    end
end
function ScrollPane:set_horizontal_scroll_policy(horizontal_scroll_policy)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.horizontal_scroll_policy = horizontal_scroll_policy
    end
    self.lua_gui_element_parameters.horizontal_scroll_policy = horizontal_scroll_policy
end

function ScrollPane:get_vertical_scroll_policy()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.vertical_scroll_policy
    else
        return self.lua_gui_element_parameters.vertical_scroll_policy
    end
end
function ScrollPane:set_vertical_scroll_policy(vertical_scroll_policy)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.vertical_scroll_policy = vertical_scroll_policy
    end
    self.lua_gui_element_parameters.vertical_scroll_policy = vertical_scroll_policy
end

function ScrollPane:scroll_to_bottom(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.scroll_to_bottom(...)
end

function ScrollPane:scroll_to_element(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.scroll_to_element(...)
end

function ScrollPane:scroll_to_left(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.scroll_to_left(...)
end

function ScrollPane:scroll_to_right(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.scroll_to_right(...)
end

function ScrollPane:scroll_to_top(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.scroll_to_top(...)
end

return ScrollPane
