-- Poly: generated for Factorio 1.1.67 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local Slider = Class:new('Poly.GUI.Slider', FactorioComponent)

function Slider:new(args)
    local slider = FactorioComponent:new(args)
    slider.lua_gui_element_parameters.type = 'slider'
    
    slider.lua_gui_element_parameters.discrete_slider = args.discrete_slider
    slider.lua_gui_element_parameters.discrete_values = args.discrete_values
    slider.lua_gui_element_parameters.maximum_value = args.maximum_value
    slider.lua_gui_element_parameters.minimum_value = args.minimum_value
    slider.lua_gui_element_parameters.value = args.value
    slider.lua_gui_element_parameters.value_step = args.value_step
    slider.lua_gui_element_delayed_parameters.slider_value = args.slider_value
    
    return slider
end

function Slider:get_slider_value()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.slider_value
    else
        return self.lua_gui_element_delayed_parameters.slider_value
    end
end
function Slider:set_slider_value(slider_value)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.slider_value = slider_value
    end
    self.lua_gui_element_delayed_parameters.slider_value = slider_value
end

return Slider
