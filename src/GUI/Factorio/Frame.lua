-- Poly: generated for Factorio 1.1.68 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local Frame = Class:new('Poly.GUI.Frame', FactorioComponent)

function Frame:new(args)
    local frame = FactorioComponent:new(args)
    frame.lua_gui_element_parameters.type = 'frame'
    
    frame.lua_gui_element_parameters.direction = args.direction
    frame.lua_gui_element_delayed_parameters.auto_center = args.auto_center
    frame.lua_gui_element_delayed_parameters.drag_target = args.drag_target
    
    return frame
end

function Frame:get_auto_center()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.auto_center
    else
        return self.lua_gui_element_delayed_parameters.auto_center
    end
end
function Frame:set_auto_center(auto_center)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.auto_center = auto_center
    end
    self.lua_gui_element_delayed_parameters.auto_center = auto_center
end

function Frame:get_direction()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.direction
    else
        return self.lua_gui_element_parameters.direction
    end
end

function Frame:get_drag_target()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.drag_target
    else
        return self.lua_gui_element_delayed_parameters.drag_target
    end
end
function Frame:set_drag_target(drag_target)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.drag_target = drag_target
    end
    self.lua_gui_element_delayed_parameters.drag_target = drag_target
end

function Frame:force_auto_center(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.force_auto_center(...)
end

return Frame
