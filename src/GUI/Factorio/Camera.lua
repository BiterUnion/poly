-- Poly: generated for Factorio 1.1.68 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local Camera = Class:new('Poly.GUI.Camera', FactorioComponent)

function Camera:new(args)
    local camera = FactorioComponent:new(args)
    camera.lua_gui_element_parameters.type = 'camera'
    
    camera.lua_gui_element_parameters.position = args.position
    camera.lua_gui_element_parameters.surface_index = args.surface_index
    camera.lua_gui_element_parameters.zoom = args.zoom
    camera.lua_gui_element_delayed_parameters.entity = args.entity
    
    return camera
end

function Camera:get_entity()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.entity
    else
        return self.lua_gui_element_delayed_parameters.entity
    end
end
function Camera:set_entity(entity)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.entity = entity
    end
    self.lua_gui_element_delayed_parameters.entity = entity
end

function Camera:get_surface_index()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.surface_index
    else
        return self.lua_gui_element_parameters.surface_index
    end
end
function Camera:set_surface_index(surface_index)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.surface_index = surface_index
    end
    self.lua_gui_element_parameters.surface_index = surface_index
end

function Camera:get_zoom()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.zoom
    else
        return self.lua_gui_element_parameters.zoom
    end
end
function Camera:set_zoom(zoom)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.zoom = zoom
    end
    self.lua_gui_element_parameters.zoom = zoom
end

return Camera
