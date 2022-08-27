-- Poly: generated for Factorio 1.1.67 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local Sprite = Class:new('Poly.GUI.Sprite', FactorioComponent)

function Sprite:new(args)
    local sprite = FactorioComponent:new(args)
    sprite.lua_gui_element_parameters.type = 'sprite'
    
    sprite.lua_gui_element_parameters.resize_to_sprite = args.resize_to_sprite
    sprite.lua_gui_element_parameters.sprite = args.sprite
    
    return sprite
end

function Sprite:get_resize_to_sprite()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.resize_to_sprite
    else
        return self.lua_gui_element_parameters.resize_to_sprite
    end
end
function Sprite:set_resize_to_sprite(resize_to_sprite)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.resize_to_sprite = resize_to_sprite
    end
    self.lua_gui_element_parameters.resize_to_sprite = resize_to_sprite
end

function Sprite:get_sprite()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.sprite
    else
        return self.lua_gui_element_parameters.sprite
    end
end
function Sprite:set_sprite(sprite)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.sprite = sprite
    end
    self.lua_gui_element_parameters.sprite = sprite
end

return Sprite
