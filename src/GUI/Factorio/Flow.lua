-- Poly: generated for Factorio 1.1.67 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local Flow = Class:new('Flow', FactorioComponent)

function Flow:new(args)
    local flow = FactorioComponent:new(args)
    flow.lua_gui_element_parameters.type = 'flow'
    
    flow.lua_gui_element_parameters.direction = args.direction
    flow.lua_gui_element_delayed_parameters.drag_target = args.drag_target
    
    return flow
end

function Flow:get_direction()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.direction
    else
        return self.lua_gui_element_parameters.direction
    end
end

function Flow:get_drag_target()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.drag_target
    else
        return self.lua_gui_element_delayed_parameters.drag_target
    end
end
function Flow:set_drag_target(drag_target)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.drag_target = drag_target
    end
    self.lua_gui_element_delayed_parameters.drag_target = drag_target
end

return Flow
