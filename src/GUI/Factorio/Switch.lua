-- Poly: generated for Factorio 1.1.67 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local Switch = Class:new('Poly.GUI.Switch', FactorioComponent)

function Switch:new(args)
    local switch = FactorioComponent:new(args)
    switch.lua_gui_element_parameters.type = 'switch'
    
    switch.lua_gui_element_parameters.allow_none_state = args.allow_none_state
    switch.lua_gui_element_parameters.left_label_caption = args.left_label_caption
    switch.lua_gui_element_parameters.left_label_tooltip = args.left_label_tooltip
    switch.lua_gui_element_parameters.right_label_caption = args.right_label_caption
    switch.lua_gui_element_parameters.right_label_tooltip = args.right_label_tooltip
    switch.lua_gui_element_parameters.switch_state = args.switch_state
    
    return switch
end

function Switch:get_allow_none_state()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.allow_none_state
    else
        return self.lua_gui_element_parameters.allow_none_state
    end
end
function Switch:set_allow_none_state(allow_none_state)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.allow_none_state = allow_none_state
    end
    self.lua_gui_element_parameters.allow_none_state = allow_none_state
end

function Switch:get_left_label_caption()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.left_label_caption
    else
        return self.lua_gui_element_parameters.left_label_caption
    end
end
function Switch:set_left_label_caption(left_label_caption)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.left_label_caption = left_label_caption
    end
    self.lua_gui_element_parameters.left_label_caption = left_label_caption
end

function Switch:get_left_label_tooltip()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.left_label_tooltip
    else
        return self.lua_gui_element_parameters.left_label_tooltip
    end
end
function Switch:set_left_label_tooltip(left_label_tooltip)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.left_label_tooltip = left_label_tooltip
    end
    self.lua_gui_element_parameters.left_label_tooltip = left_label_tooltip
end

function Switch:get_right_label_caption()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.right_label_caption
    else
        return self.lua_gui_element_parameters.right_label_caption
    end
end
function Switch:set_right_label_caption(right_label_caption)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.right_label_caption = right_label_caption
    end
    self.lua_gui_element_parameters.right_label_caption = right_label_caption
end

function Switch:get_right_label_tooltip()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.right_label_tooltip
    else
        return self.lua_gui_element_parameters.right_label_tooltip
    end
end
function Switch:set_right_label_tooltip(right_label_tooltip)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.right_label_tooltip = right_label_tooltip
    end
    self.lua_gui_element_parameters.right_label_tooltip = right_label_tooltip
end

function Switch:get_switch_state()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.switch_state
    else
        return self.lua_gui_element_parameters.switch_state
    end
end
function Switch:set_switch_state(switch_state)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.switch_state = switch_state
    end
    self.lua_gui_element_parameters.switch_state = switch_state
end

return Switch
