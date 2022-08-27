-- Poly: generated for Factorio 1.1.67 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local Checkbox = Class:new('Poly.GUI.Checkbox', FactorioComponent)

function Checkbox:new(args)
    local checkbox = FactorioComponent:new(args)
    checkbox.lua_gui_element_parameters.type = 'checkbox'
    
    checkbox.lua_gui_element_parameters.state = args.state
    
    return checkbox
end

function Checkbox:get_state()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.state
    else
        return self.lua_gui_element_parameters.state
    end
end
function Checkbox:set_state(state)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.state = state
    end
    self.lua_gui_element_parameters.state = state
end

return Checkbox
