local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local EventHandler = require('__poly__.GUI.EventHandler')

local FactorioComponent = Class:new('Poly.GUI.FactorioComponent', Component)

function FactorioComponent:new(args)
    local factorio_component = Component:new(args)
    factorio_component.lua_gui_element = nil
    factorio_component.lua_gui_element_parameters = {
        anchor = args.anchor,
        caption = args.caption,
        enabled = args.enabled,
        ignored_by_interaction = args.ignored_by_interaction,
        name = args.name,
        tags = args.tags,
        tooltip = args.tooltip,
        visible = args.visible
    }
    factorio_component.lua_gui_element_delayed_parameters = {
        location = args.location
    }
    factorio_component.style = args.style
    factorio_component.event_handler_ids = {}
    factorio_component.delete_event_handler = args.delete_event_handler
    if factorio_component.delete_event_handler == nil then
        factorio_component.delete_event_handler = true
    end
    for _, event in ipairs { 'on_gui_checked_state_changed', 'on_gui_click', 'on_gui_closed', 'on_gui_confirmed',
                             'on_gui_elem_changed', 'on_gui_location_changed', 'on_gui_opened',
                             'on_gui_selected_tab_changed', 'on_gui_selection_state_changed',
                             'on_gui_switch_state_changed', 'on_gui_text_changed', 'on_gui_value_changed' } do
        local handler = args[event]
        if handler ~= nil then
            if factorio_component.lua_gui_element_parameters.tags == nil then
                factorio_component.lua_gui_element_parameters.tags = {}
            end
            if factorio_component.lua_gui_element_parameters.tags.Poly == nil then
                factorio_component.lua_gui_element_parameters.tags.Poly = {}
            end
            if type(handler) == 'string' then
                factorio_component.lua_gui_element_parameters.tags.Poly[event] = handler
                if factorio_component.delete_event_handler then
                    factorio_component.event_handler_ids[handler] = true
                end
            else
                factorio_component.lua_gui_element_parameters.tags.Poly[event] = {}
                for idx, id in ipairs(handler) do
                    factorio_component.lua_gui_element_parameters.tags.Poly[event][idx] = id
                    if factorio_component.delete_event_handler then
                        factorio_component.event_handler_ids[id] = true
                    end
                end
            end
        end
    end
    return factorio_component
end

function FactorioComponent:create(parent)
    self.lua_gui_element = parent.add(self.lua_gui_element_parameters)
    if self.style ~= nil then
        Poly.GUI.apply_style(self.lua_gui_element, self.style)
    end
    for k, v in pairs(self.lua_gui_element_delayed_parameters) do
        self.lua_gui_element[k] = v
    end
    Component.create(self, self.lua_gui_element)
end

function FactorioComponent:destroy()
    self.lua_gui_element.destroy()
    Component.destroy(self)
end

function FactorioComponent:delete()
    if self.delete_event_handler then
        for event_handler_id, _ in ipairs(self.event_handler_ids) do
            EventHandler:delete(event_handler_id)
        end
    end
    Component.delete(self)
end

function FactorioComponent:set_style(style)
    if self:get_state() == Component.State.Created then
        Poly.GUI.apply_style(self.lua_gui_element, style)
    end
    if type(style) == 'string' then
        self.style = style
    elseif type(style) == 'table' then
        if style[1] ~= nil then
            self.style = style
        else
            if self.style == nil then
                self.style = {}
            elseif type(self.style) == 'string' then
                self.style = { [1] = self.style }
            end
            for k, v in pairs(style) do
                if k ~= 1 then
                    self.style[k] = v
                end
            end
        end
    end
end

function FactorioComponent:get_tags()
    if self:get_state() == Component.State.Created then
        return Poly.deep_copy(self.lua_gui_element.tags)
    else
        return Poly.deep_copy(self.lua_gui_element_parameters.tags)
    end
end
function FactorioComponent:set_tags(tags)
    if #self.event_handler_ids > 0 then
        if tags.Poly == nil then
            tags.Poly = {}
        end
        for event, handlers in pairs(self.lua_gui_element_parameters.tags.Poly) do
            if type(handlers) == 'string' then
                handlers = { handlers }
            end
            for _, handler in ipairs(handlers) do
                if self.event_handler_ids[handler] then
                    if tags.Poly[event] == nil then
                        tags.Poly[event] = handler
                    elseif type(tags.Poly[event]) == 'string' then
                        tags.Poly[event] = { tags.Poly[event], handler }
                    else
                        tags.Poly[event][#tags.Poly[event] + 1] = handler
                    end
                end
            end
        end
    end
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.tags = tags
    end
    self.lua_gui_element_parameters.tags = tags
end
function FactorioComponent:update_tags(tags)
    if tags == nil then
        return
    end
    if self.lua_gui_element_parameters.tags == nil then
        self:set_tags(tags)
    end
    local function merge(orig_tags, new_tags)
        for k, v in pairs(new_tags) do
            if orig_tags[k] == nil then
                orig_tags[k] = v
            elseif type(orig_tags[k]) == 'table' then
                merge(orig_tags[k], v)
            else
                orig_tags[k] = v
            end
        end
    end
    merge(self.lua_gui_element_parameters.tags, tags)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.tags = self.lua_gui_element_parameters.tags
    end
end
function FactorioComponent:delete_tags(tags)
    if tags == nil or self.lua_gui_element_parameters.tags == nil then
        return
    end
    local function delete(orig_tags, delete_tags)
        for k, v in pairs(delete_tags) do
            if orig_tags[k] ~= nil then
                if type(orig_tags[k]) == 'table' then
                    delete(orig_tags[k], v)
                    if next(orig_tags[k]) == nil then
                        orig_tags[k] = nil
                    end
                else
                    orig_tags[k] = nil
                end
            end
        end
    end
    delete(self.lua_gui_element_parameters.tags, tags)
    if next(self.lua_gui_element_parameters.tags) == nil then
        self.lua_gui_element_parameters.tags = nil
    end
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.tags = self.lua_gui_element_parameters.tags
    end
end

local function add_event_handler(self, event, event_handler)
    if self.lua_gui_element_parameters.tags == nil then
        self.lua_gui_element_parameters.tags = {}
    end
    if self.lua_gui_element_parameters.tags.Poly == nil then
        self.lua_gui_element_parameters.tags.Poly = {}
    end
    if type(event_handler) == 'string' then
        if self.lua_gui_element_parameters.tags.Poly[event] == nil then
            self.lua_gui_element_parameters.tags.Poly[event] = event_handler
        elseif type(self.lua_gui_element_parameters.tags.Poly[event]) == 'string' then
            self.lua_gui_element_parameters.tags.Poly[event] = {
                self.lua_gui_element_parameters.tags.Poly[event],
                event_handler
            }
        else
            self.lua_gui_element_parameters.tags.Poly[event][#self.lua_gui_element_parameters.tags.Poly[event] + 1] = event_handler
        end
        if self.delete_event_handler then
            self.event_handler_ids[event_handler] = true
        end
    else
        if self.lua_gui_element_parameters.tags.Poly[event] == nil then
            self.lua_gui_element_parameters.tags.Poly[event] = {}
        elseif type(self.lua_gui_element_parameters.tags.Poly[event]) == 'string' then
            self.lua_gui_element_parameters.tags.Poly[event] = { self.lua_gui_element_parameters.tags.Poly[event] }
        end
        local num_handlers = #self.lua_gui_element_parameters.tags.Poly[event]
        for idx, id in ipairs(event_handler) do
            self.lua_gui_element_parameters.tags.Poly[event][num_handlers + idx] = id
            if self.delete_event_handler then
                self.event_handler_ids[id] = true
            end
        end
    end
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.tags = self.lua_gui_element_parameters.tags
    end
end

function FactorioComponent:add_on_gui_checked_state_changed(event_handler)
    add_event_handler(self, 'on_gui_checked_state_changed', event_handler)
end
function FactorioComponent:add_on_gui_click(event_handler)
    add_event_handler(self, 'on_gui_click', event_handler)
end
function FactorioComponent:add_on_gui_closed(event_handler)
    add_event_handler(self, 'on_gui_closed', event_handler)
end
function FactorioComponent:add_on_gui_confirmed(event_handler)
    add_event_handler(self, 'on_gui_confirmed', event_handler)
end
function FactorioComponent:add_on_gui_elem_changed(event_handler)
    add_event_handler(self, 'on_gui_elem_changed', event_handler)
end
function FactorioComponent:add_on_gui_location_changed(event_handler)
    add_event_handler(self, 'on_gui_location_changed', event_handler)
end
function FactorioComponent:add_on_gui_opened(event_handler)
    add_event_handler(self, 'on_gui_opened', event_handler)
end
function FactorioComponent:add_on_gui_selected_tab_changed(event_handler)
    add_event_handler(self, 'on_gui_selected_tab_changed', event_handler)
end
function FactorioComponent:add_on_gui_selection_state_changed(event_handler)
    add_event_handler(self, 'on_gui_selection_state_changed', event_handler)
end
function FactorioComponent:add_on_gui_switch_state_changed(event_handler)
    add_event_handler(self, 'on_gui_switch_state_changed', event_handler)
end
function FactorioComponent:add_on_gui_text_changed(event_handler)
    add_event_handler(self, 'on_gui_text_changed', event_handler)
end
function FactorioComponent:add_on_gui_value_changed(event_handler)
    add_event_handler(self, 'on_gui_value_changed', event_handler)
end

function FactorioComponent:get_anchor()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.anchor
    else
        return self.lua_gui_element_parameters.anchor
    end
end
function FactorioComponent:set_anchor(anchor)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.anchor = anchor
    end
    self.lua_gui_element_parameters.anchor = anchor
end

function FactorioComponent:get_caption()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.caption
    else
        return self.lua_gui_element_parameters.caption
    end
end
function FactorioComponent:set_caption(caption)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.caption = caption
    end
    self.lua_gui_element_parameters.caption = caption
end

function FactorioComponent:get_enabled()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.enabled
    else
        return self.lua_gui_element_parameters.enabled
    end
end
function FactorioComponent:set_enabled(enabled)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.enabled = enabled
    end
    self.lua_gui_element_parameters.enabled = enabled
end

function FactorioComponent:get_gui()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.gui
    else
        return self.lua_gui_element_parameters.gui
    end
end

function FactorioComponent:get_ignored_by_interaction()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.ignored_by_interaction
    else
        return self.lua_gui_element_parameters.ignored_by_interaction
    end
end
function FactorioComponent:set_ignored_by_interaction(ignored_by_interaction)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.ignored_by_interaction = ignored_by_interaction
    end
    self.lua_gui_element_parameters.ignored_by_interaction = ignored_by_interaction
end

function FactorioComponent:get_index()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.index
    else
        return self.lua_gui_element_parameters.index
    end
end

function FactorioComponent:get_location()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.location
    else
        return self.lua_gui_element_delayed_parameters.location
    end
end
function FactorioComponent:set_location(location)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.location = location
    end
    self.lua_gui_element_delayed_parameters.location = location
end

function FactorioComponent:get_object_name()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.object_name
    else
        return self.lua_gui_element_parameters.object_name
    end
end

function FactorioComponent:get_parent()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.parent
    else
        return self.lua_gui_element_parameters.parent
    end
end

function FactorioComponent:get_player_index()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.player_index
    else
        return self.lua_gui_element_parameters.player_index
    end
end

function FactorioComponent:get_tags()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.tags
    else
        return self.lua_gui_element_parameters.tags
    end
end

function FactorioComponent:get_tooltip()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.tooltip
    else
        return self.lua_gui_element_parameters.tooltip
    end
end
function FactorioComponent:set_tooltip(tooltip)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.tooltip = tooltip
    end
    self.lua_gui_element_parameters.tooltip = tooltip
end

function FactorioComponent:get_type()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.type
    else
        return self.lua_gui_element_parameters.type
    end
end

function FactorioComponent:get_valid()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.valid
    else
        return self.lua_gui_element_parameters.valid
    end
end

function FactorioComponent:get_visible()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.visible
    else
        return self.lua_gui_element_parameters.visible
    end
end
function FactorioComponent:set_visible(visible)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.visible = visible
    end
    self.lua_gui_element_parameters.visible = visible
end

function FactorioComponent:bring_to_front(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.bring_to_front(...)
end

function FactorioComponent:focus(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.focus(...)
end

function FactorioComponent:get_mod(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    return self.lua_gui_element.get_mod(...)
end

function FactorioComponent:help(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    return self.lua_gui_element.help(...)
end

return FactorioComponent