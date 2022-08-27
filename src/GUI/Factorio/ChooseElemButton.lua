-- Poly: generated for Factorio 1.1.67 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local ChooseElemButton = Class:new('Poly.GUI.ChooseElemButton', FactorioComponent)

function ChooseElemButton:new(args)
    local choose_elem_button = FactorioComponent:new(args)
    choose_elem_button.lua_gui_element_parameters.type = 'choose-elem-button'
    
    choose_elem_button.lua_gui_element_parameters.achievement = args.achievement
    choose_elem_button.lua_gui_element_parameters.decorative = args.decorative
    choose_elem_button.lua_gui_element_parameters.elem_filters = args.elem_filters
    choose_elem_button.lua_gui_element_parameters.elem_type = args.elem_type
    choose_elem_button.lua_gui_element_parameters.entity = args.entity
    choose_elem_button.lua_gui_element_parameters.equipment = args.equipment
    choose_elem_button.lua_gui_element_parameters.fluid = args.fluid
    choose_elem_button.lua_gui_element_parameters.item = args.item
    choose_elem_button.lua_gui_element_parameters.item-group = args.item-group
    choose_elem_button.lua_gui_element_parameters.recipe = args.recipe
    choose_elem_button.lua_gui_element_parameters.signal = args.signal
    choose_elem_button.lua_gui_element_parameters.technology = args.technology
    choose_elem_button.lua_gui_element_parameters.tile = args.tile
    choose_elem_button.lua_gui_element_delayed_parameters.elem_value = args.elem_value
    choose_elem_button.lua_gui_element_delayed_parameters.locked = args.locked
    
    return choose_elem_button
end

function ChooseElemButton:get_elem_filters()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.elem_filters
    else
        return self.lua_gui_element_parameters.elem_filters
    end
end
function ChooseElemButton:set_elem_filters(elem_filters)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.elem_filters = elem_filters
    end
    self.lua_gui_element_parameters.elem_filters = elem_filters
end

function ChooseElemButton:get_elem_type()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.elem_type
    else
        return self.lua_gui_element_parameters.elem_type
    end
end

function ChooseElemButton:get_elem_value()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.elem_value
    else
        return self.lua_gui_element_delayed_parameters.elem_value
    end
end
function ChooseElemButton:set_elem_value(elem_value)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.elem_value = elem_value
    end
    self.lua_gui_element_delayed_parameters.elem_value = elem_value
end

function ChooseElemButton:get_locked()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.locked
    else
        return self.lua_gui_element_delayed_parameters.locked
    end
end
function ChooseElemButton:set_locked(locked)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.locked = locked
    end
    self.lua_gui_element_delayed_parameters.locked = locked
end

return ChooseElemButton
