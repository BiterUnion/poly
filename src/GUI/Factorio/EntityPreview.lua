-- Poly: generated for Factorio 1.1.67 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local EntityPreview = Class:new('EntityPreview', FactorioComponent)

function EntityPreview:new(args)
    local entity_preview = FactorioComponent:new(args)
    entity_preview.lua_gui_element_parameters.type = 'entity-preview'
    
    entity_preview.lua_gui_element_delayed_parameters.entity = args.entity
    
    return entity_preview
end

function EntityPreview:get_entity()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.entity
    else
        return self.lua_gui_element_delayed_parameters.entity
    end
end
function EntityPreview:set_entity(entity)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.entity = entity
    end
    self.lua_gui_element_delayed_parameters.entity = entity
end

return EntityPreview
