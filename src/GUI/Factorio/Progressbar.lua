-- Poly: generated for Factorio 1.1.68 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local Progressbar = Class:new('Poly.GUI.Progressbar', FactorioComponent)

function Progressbar:new(args)
    local progressbar = FactorioComponent:new(args)
    progressbar.lua_gui_element_parameters.type = 'progressbar'
    
    progressbar.lua_gui_element_parameters.value = args.value
    
    return progressbar
end

function Progressbar:get_value()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.value
    else
        return self.lua_gui_element_parameters.value
    end
end
function Progressbar:set_value(value)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.value = value
    end
    self.lua_gui_element_parameters.value = value
end

return Progressbar
