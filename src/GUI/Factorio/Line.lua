-- Poly: generated for Factorio 1.1.68 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local Line = Class:new('Poly.GUI.Line', FactorioComponent)

function Line:new(args)
    local line = FactorioComponent:new(args)
    line.lua_gui_element_parameters.type = 'line'
    
    line.lua_gui_element_parameters.direction = args.direction
    
    return line
end

function Line:get_direction()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.direction
    else
        return self.lua_gui_element_parameters.direction
    end
end

return Line
