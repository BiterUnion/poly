-- Poly: generated for Factorio 1.1.68 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local Label = Class:new('Poly.GUI.Label', FactorioComponent)

function Label:new(args)
    local label = FactorioComponent:new(args)
    label.lua_gui_element_parameters.type = 'label'
    
    label.lua_gui_element_delayed_parameters.drag_target = args.drag_target
    
    return label
end

function Label:get_drag_target()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.drag_target
    else
        return self.lua_gui_element_delayed_parameters.drag_target
    end
end
function Label:set_drag_target(drag_target)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.drag_target = drag_target
    end
    self.lua_gui_element_delayed_parameters.drag_target = drag_target
end

return Label
