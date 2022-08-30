-- Poly: generated for Factorio 1.1.68 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local SpriteButton = Class:new('Poly.GUI.SpriteButton', FactorioComponent)

function SpriteButton:new(args)
    local sprite_button = FactorioComponent:new(args)
    sprite_button.lua_gui_element_parameters.type = 'sprite-button'
    
    sprite_button.lua_gui_element_parameters.clicked_sprite = args.clicked_sprite
    sprite_button.lua_gui_element_parameters.hovered_sprite = args.hovered_sprite
    sprite_button.lua_gui_element_parameters.mouse_button_filter = args.mouse_button_filter
    sprite_button.lua_gui_element_parameters.number = args.number
    sprite_button.lua_gui_element_parameters.show_percent_for_small_numbers = args.show_percent_for_small_numbers
    sprite_button.lua_gui_element_parameters.sprite = args.sprite
    
    return sprite_button
end

function SpriteButton:get_clicked_sprite()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.clicked_sprite
    else
        return self.lua_gui_element_parameters.clicked_sprite
    end
end
function SpriteButton:set_clicked_sprite(clicked_sprite)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.clicked_sprite = clicked_sprite
    end
    self.lua_gui_element_parameters.clicked_sprite = clicked_sprite
end

function SpriteButton:get_hovered_sprite()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.hovered_sprite
    else
        return self.lua_gui_element_parameters.hovered_sprite
    end
end
function SpriteButton:set_hovered_sprite(hovered_sprite)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.hovered_sprite = hovered_sprite
    end
    self.lua_gui_element_parameters.hovered_sprite = hovered_sprite
end

function SpriteButton:get_mouse_button_filter()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.mouse_button_filter
    else
        return self.lua_gui_element_parameters.mouse_button_filter
    end
end
function SpriteButton:set_mouse_button_filter(mouse_button_filter)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.mouse_button_filter = mouse_button_filter
    end
    self.lua_gui_element_parameters.mouse_button_filter = mouse_button_filter
end

function SpriteButton:get_number()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.number
    else
        return self.lua_gui_element_parameters.number
    end
end
function SpriteButton:set_number(number)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.number = number
    end
    self.lua_gui_element_parameters.number = number
end

function SpriteButton:get_show_percent_for_small_numbers()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.show_percent_for_small_numbers
    else
        return self.lua_gui_element_parameters.show_percent_for_small_numbers
    end
end
function SpriteButton:set_show_percent_for_small_numbers(show_percent_for_small_numbers)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.show_percent_for_small_numbers = show_percent_for_small_numbers
    end
    self.lua_gui_element_parameters.show_percent_for_small_numbers = show_percent_for_small_numbers
end

function SpriteButton:get_sprite()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.sprite
    else
        return self.lua_gui_element_parameters.sprite
    end
end
function SpriteButton:set_sprite(sprite)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.sprite = sprite
    end
    self.lua_gui_element_parameters.sprite = sprite
end

return SpriteButton
