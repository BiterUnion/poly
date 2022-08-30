-- Poly: generated for Factorio 1.1.68 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local Tab = Class:new('Poly.GUI.Tab', FactorioComponent)

function Tab:new(args)
    local tab = FactorioComponent:new(args)
    tab.lua_gui_element_parameters.type = 'tab'
    
    tab.lua_gui_element_parameters.badge_text = args.badge_text
    
    return tab
end

function Tab:get_badge_text()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.badge_text
    else
        return self.lua_gui_element_parameters.badge_text
    end
end
function Tab:set_badge_text(badge_text)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.badge_text = badge_text
    end
    self.lua_gui_element_parameters.badge_text = badge_text
end

return Tab
