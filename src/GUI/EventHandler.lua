require('__poly__.GUI.init_control')

local Class = require('__poly__.Class')

if global.poly.event_handler == nil then
    global.poly.event_handler = {}
end

local EventHandler = Class:new('EventHandler')

function EventHandler:register(handler_table, function_name, ...)
    local handler_type
    if handler_table ~= nil and Class:is_registered_class(handler_table) then
        handler_table = handler_table._Poly.class_name
    end
    local event_handler = {
        id = Poly.uuid(),
        handler_type = handler_type,
        handler_table = handler_table,
        function_name = function_name,
        args = { ... }
    }
    event_handler.num_args = #event_handler.args
    global.poly.event_handler[event_handler.id] = event_handler
    return event_handler.id
end

function EventHandler:call(event_handler_id, event)
    local event_handler = global.poly.event_handler[event_handler_id]
    event_handler.args[event_handler.num_args + 1] = event
    if event_handler.handler_table == nil then
        _G[event_handler.function_name](table.unpack(event_handler.args))
    else
        local handler_table = event_handler.handler_table
        if type(handler_table) == 'string' then
            handler_table = Class:get(event_handler.handler_table)
        end
        handler_table[event_handler.function_name](handler_table, table.unpack(event_handler.args))
    end
end

function EventHandler:delete(event_handler_spec)
    if type(event_handler_spec) == 'string' then
        global.poly.event_handler[event_handler_spec] = nil
    elseif type(event_handler_spec) == 'table' then
        if event_handler_spec.object_name == 'LuaGuiElement' then
            local tags = event_handler_spec.tags
            event_handler_spec = {}
            if tags.Poly ~= nil then
                for k, v in pairs(tags.Poly) do
                    if v == 'string' then
                        event_handler_spec[#event_handler_spec + 1] = v
                    else
                        for _, event_handler_id in ipairs(v) do
                            event_handler_spec[#event_handler_spec + 1] = event_handler_id
                        end
                    end
                end
            end
        end
        for _, event_handler_id in ipairs(event_handler_spec) do
            global.poly.event_handler[event_handler_id] = nil
        end
    else
        assert(false, 'event_handler_spec has to be an event handler id, an array of ids, or a LuaGuiElement')
    end
end

local event_id_to_name = {
    [defines.events.on_gui_checked_state_changed] = 'on_gui_checked_state_changed',
    [defines.events.on_gui_click] = 'on_gui_click',
    [defines.events.on_gui_closed] = 'on_gui_closed',
    [defines.events.on_gui_confirmed] = 'on_gui_confirmed',
    [defines.events.on_gui_elem_changed] = 'on_gui_elem_changed',
    [defines.events.on_gui_location_changed] = 'on_gui_location_changed',
    [defines.events.on_gui_opened] = 'on_gui_opened',
    [defines.events.on_gui_selected_tab_changed] = 'on_gui_selected_tab_changed',
    [defines.events.on_gui_selection_state_changed] = 'on_gui_selection_state_changed',
    [defines.events.on_gui_switch_state_changed] = 'on_gui_switch_state_changed',
    [defines.events.on_gui_text_changed] = 'on_gui_text_changed',
    [defines.events.on_gui_value_changed] = 'on_gui_value_changed'
}
local function handle_gui_event(event)
    if event.element and event.element.tags then
        local tags = event.element.tags
        if tags.Poly ~= nil then
            local event_name = event_id_to_name[event.name]
            local event_handler_ids = tags.Poly[event_name]
            if event_handler_ids ~= nil then
                if type(event_handler_ids) == 'string' then
                    event_handler_ids = { event_handler_ids }
                end
                for _, event_handler_id in ipairs(event_handler_ids) do
                    EventHandler:call(event_handler_id, event)
                end
            end
        end
    end
end
script.on_event({ defines.events.on_gui_checked_state_changed,
                  defines.events.on_gui_click,
                  defines.events.on_gui_closed,
                  defines.events.on_gui_confirmed,
                  defines.events.on_gui_elem_changed,
                  defines.events.on_gui_location_changed,
                  defines.events.on_gui_opened,
                  defines.events.on_gui_selected_tab_changed,
                  defines.events.on_gui_selection_state_changed,
                  defines.events.on_gui_switch_state_changed,
                  defines.events.on_gui_text_changed,
                  defines.events.on_gui_value_changed }, function(event)
    handle_gui_event(event)
end)

return EventHandler
