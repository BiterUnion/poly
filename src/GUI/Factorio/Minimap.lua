-- Poly: generated for Factorio 1.1.68 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local Minimap = Class:new('Poly.GUI.Minimap', FactorioComponent)

function Minimap:new(args)
    local minimap = FactorioComponent:new(args)
    minimap.lua_gui_element_parameters.type = 'minimap'
    
    minimap.lua_gui_element_parameters.chart_player_index = args.chart_player_index
    minimap.lua_gui_element_parameters.force = args.force
    minimap.lua_gui_element_parameters.position = args.position
    minimap.lua_gui_element_parameters.surface_index = args.surface_index
    minimap.lua_gui_element_parameters.zoom = args.zoom
    minimap.lua_gui_element_delayed_parameters.entity = args.entity
    minimap.lua_gui_element_delayed_parameters.minimap_player_index = args.minimap_player_index
    
    return minimap
end

function Minimap:get_entity()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.entity
    else
        return self.lua_gui_element_delayed_parameters.entity
    end
end
function Minimap:set_entity(entity)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.entity = entity
    end
    self.lua_gui_element_delayed_parameters.entity = entity
end

function Minimap:get_force()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.force
    else
        return self.lua_gui_element_parameters.force
    end
end
function Minimap:set_force(force)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.force = force
    end
    self.lua_gui_element_parameters.force = force
end

function Minimap:get_minimap_player_index()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.minimap_player_index
    else
        return self.lua_gui_element_delayed_parameters.minimap_player_index
    end
end
function Minimap:set_minimap_player_index(minimap_player_index)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.minimap_player_index = minimap_player_index
    end
    self.lua_gui_element_delayed_parameters.minimap_player_index = minimap_player_index
end

function Minimap:get_position()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.position
    else
        return self.lua_gui_element_parameters.position
    end
end
function Minimap:set_position(position)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.position = position
    end
    self.lua_gui_element_parameters.position = position
end

function Minimap:get_surface_index()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.surface_index
    else
        return self.lua_gui_element_parameters.surface_index
    end
end
function Minimap:set_surface_index(surface_index)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.surface_index = surface_index
    end
    self.lua_gui_element_parameters.surface_index = surface_index
end

function Minimap:get_zoom()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.zoom
    else
        return self.lua_gui_element_parameters.zoom
    end
end
function Minimap:set_zoom(zoom)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.zoom = zoom
    end
    self.lua_gui_element_parameters.zoom = zoom
end

return Minimap
