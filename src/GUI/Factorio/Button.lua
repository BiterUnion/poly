-- Poly: generated for Factorio 1.1.67 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local Button = Class:new('Poly.GUI.Button', FactorioComponent)

function Button:new(args)
    local button = FactorioComponent:new(args)
    button.lua_gui_element_parameters.type = 'button'
    
    button.lua_gui_element_parameters.mouse_button_filter = args.mouse_button_filter
    
    return button
end

function Button:get_mouse_button_filter()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.mouse_button_filter
    else
        return self.lua_gui_element_parameters.mouse_button_filter
    end
end
function Button:set_mouse_button_filter(mouse_button_filter)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.mouse_button_filter = mouse_button_filter
    end
    self.lua_gui_element_parameters.mouse_button_filter = mouse_button_filter
end

return Button
