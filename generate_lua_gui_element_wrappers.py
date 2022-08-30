import os
import urllib.request, json
from pathlib import Path

API_JSON_URL = 'https://lua-api.factorio.com/latest/runtime-api.json'
API_JSON_PATH = Path('runtime-api.json')
WRAPPER_PATH = Path('src/GUI/Factorio/')


def get_named_array_element(json_array, name):
    element = None
    for api_class in json_array:
        if api_class['name'] == name:
            element = api_class
            break
    if element is None:
        raise ValueError(f'{name} not found in array')
    return element


def definition_getter(camel_case_subclass, attribute, delayed, read_only=False):
    attribute_name = attribute['name']
    return f'''function {camel_case_subclass}:get_{attribute_name}()
    if self:get_state() == Component.State.Created then
        return {'Helper.read_only(' if read_only else ''}self.lua_gui_element.{attribute_name}{')' if read_only else ''}
    else
        return {'Helper.read_only(' if read_only else ''}self.{'lua_gui_element_delayed_parameters' if delayed else 'lua_gui_element_parameters'}.{attribute_name}{')' if read_only else ''}
    end
end'''


def definition_setter(camel_case_subclass, attribute, delayed):
    attribute_name = attribute['name']
    return f'''function {camel_case_subclass}:set_{attribute_name}({attribute_name})
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.{attribute_name} = {attribute_name}
    end
    self.{'lua_gui_element_delayed_parameters' if delayed else 'lua_gui_element_parameters'}.{attribute_name} = {attribute_name}
end'''


def definition_method(camel_case_subclass, method):
    method_name = method['name']

    return f'''function {camel_case_subclass}:{method_name}(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    {'return ' if len(method['return_values']) > 0 else ''}self.lua_gui_element.{method_name}(...)
end'''


def create_wrapper(camel_case_subclass, snake_case_subclass, dashed_snake_case_subclass,
                   parameters, attributes, methods,
                   application_version, api_version):
    delayed_parameter_names = []
    for attribute in attributes:
        if attribute['write']:
            delayed_parameter_names.append(attribute['name'])
    for parameter in parameters:
        if parameter['name'] in delayed_parameter_names:
            delayed_parameter_names.remove(parameter['name'])

    def requires():
        return '''local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')'''

    def declaration():
        return f'''local {camel_case_subclass} = Class:new('Poly.GUI.{camel_case_subclass}', FactorioComponent)'''

    def definition_new():
        new = f'''function {camel_case_subclass}:new(args)
    local {snake_case_subclass} = FactorioComponent:new(args)
    {snake_case_subclass}.lua_gui_element_parameters.type = '{dashed_snake_case_subclass}'
    '''
        for parameter in parameters:
            new += f'\n    {snake_case_subclass}.lua_gui_element_parameters.{parameter["name"]} = args.{parameter["name"]}'
        for parameter in delayed_parameter_names:
            new += f'\n    {snake_case_subclass}.lua_gui_element_delayed_parameters.{parameter} = args.{parameter}'
        new += f'''
    
    return {snake_case_subclass}
end'''
        return new

    def definition():
        definition = definition_new()
        for attribute in attributes:
            first = True
            if attribute['read'] and not attribute['name'] == 'style':
                # style should not be read to be able to keep track of modifications
                definition += ('\n\n' if first else '\n') + definition_getter(
                    camel_case_subclass, attribute, attribute['name'] in delayed_parameter_names
                )
                first = False
            if attribute['write'] and not attribute['name'] == 'name':
                # name cannot be changed after instantiation
                definition += ('\n\n' if first else '\n') + definition_setter(
                    camel_case_subclass, attribute, attribute['name'] in delayed_parameter_names
                )
                first = False
        for method in methods:
            definition += '\n\n' + definition_method(camel_case_subclass, method)
        return definition

    return f'''-- Poly: generated for Factorio {application_version} runtime API {api_version}

{requires()}

{declaration()}

{definition()}

return {camel_case_subclass}
'''


# load API json
if not API_JSON_PATH.exists():
    # download if not exists
    with urllib.request.urlopen(API_JSON_URL) as url:
        api_json = json.loads(url.read().decode())

    # == fix inconsistencies ==
    lua_gui_element_class = get_named_array_element(api_json['classes'], 'LuaGuiElement')

    # -- camel case radiobutton subclass --
    state_attribute = get_named_array_element(lua_gui_element_class['attributes'], 'state')
    assert 'RadioButton' in state_attribute['subclasses']
    state_attribute['subclasses'].remove('RadioButton')
    state_attribute['subclasses'].append('radiobutton')

    # -- camel case checkbox subclass --
    state_attribute = get_named_array_element(lua_gui_element_class['attributes'], 'state')
    assert 'CheckBox' in state_attribute['subclasses']
    state_attribute['subclasses'].remove('CheckBox')
    state_attribute['subclasses'].append('checkbox')

    # -- missing subclasses for mouse_button_filter --
    mouse_button_filter_attribute = get_named_array_element(lua_gui_element_class['attributes'], 'mouse_button_filter')
    assert 'subclasses' not in mouse_button_filter_attribute
    mouse_button_filter_attribute['subclasses'] = ['button', 'sprite-button']

    # -- missing subclasses for clicked_sprite --
    clicked_sprite_attribute = get_named_array_element(lua_gui_element_class['attributes'], 'clicked_sprite')
    assert 'subclasses' not in clicked_sprite_attribute
    clicked_sprite_attribute['subclasses'] = ['sprite-button']

    # -- missing subclasses for entity --
    entity_attribute = get_named_array_element(lua_gui_element_class['attributes'], 'entity')
    assert 'subclasses' not in entity_attribute
    entity_attribute['subclasses'] = ['entity-preview', 'camera', 'minimap']

    # -- missing subclasses for force --
    force_attribute = get_named_array_element(lua_gui_element_class['attributes'], 'force')
    assert 'subclasses' not in force_attribute
    force_attribute['subclasses'] = ['minimap']

    # -- missing subclasses for items --
    items_attribute = get_named_array_element(lua_gui_element_class['attributes'], 'items')
    assert 'subclasses' not in items_attribute
    items_attribute['subclasses'] = ['drop-down', 'list-box']

    # -- missing subclasses for number --
    number_attribute = get_named_array_element(lua_gui_element_class['attributes'], 'number')
    assert 'subclasses' not in number_attribute
    number_attribute['subclasses'] = ['sprite-button']

    # -- missing subclasses for position --
    position_attribute = get_named_array_element(lua_gui_element_class['attributes'], 'position')
    assert 'subclasses' not in position_attribute
    position_attribute['subclasses'] = ['minimap']

    # -- missing subclasses for resize_to_sprite --
    resize_to_sprite_attribute = get_named_array_element(lua_gui_element_class['attributes'], 'resize_to_sprite')
    assert 'subclasses' not in resize_to_sprite_attribute
    resize_to_sprite_attribute['subclasses'] = ['sprite']

    # -- missing subclasses for selected_index --
    selected_index_attribute = get_named_array_element(lua_gui_element_class['attributes'], 'selected_index')
    assert 'subclasses' not in selected_index_attribute
    selected_index_attribute['subclasses'] = ['drop-down', 'list-box']

    # -- missing subclasses for show_percent_for_small_numbers --
    show_percent_for_small_numbers_attribute = get_named_array_element(lua_gui_element_class['attributes'],
                                                                       'show_percent_for_small_numbers')
    assert 'subclasses' not in show_percent_for_small_numbers_attribute
    show_percent_for_small_numbers_attribute['subclasses'] = ['sprite-button']

    # -- missing subclasses for sprite --
    sprite_attribute = get_named_array_element(lua_gui_element_class['attributes'], 'sprite')
    assert 'subclasses' not in sprite_attribute
    sprite_attribute['subclasses'] = ['sprite-button', 'sprite']

    # -- missing subclasses for surface_index --
    surface_index_attribute = get_named_array_element(lua_gui_element_class['attributes'], 'surface_index')
    assert 'subclasses' not in surface_index_attribute
    surface_index_attribute['subclasses'] = ['camera', 'minimap']

    # -- missing subclasses for tabs --
    tabs_attribute = get_named_array_element(lua_gui_element_class['attributes'], 'tabs')
    assert 'subclasses' not in tabs_attribute
    tabs_attribute['subclasses'] = ['tabbed-pane']

    # -- missing subclasses for zoom --
    zoom_attribute = get_named_array_element(lua_gui_element_class['attributes'], 'zoom')
    assert 'subclasses' not in zoom_attribute
    zoom_attribute['subclasses'] = ['camera', 'minimap']

    # -- missing subclasses for add_item --
    add_item_method = get_named_array_element(lua_gui_element_class['methods'], 'add_item')
    assert 'subclasses' not in add_item_method
    add_item_method['subclasses'] = ['drop-down', 'list-box']

    # -- missing subclasses for clear_items --
    clear_items_method = get_named_array_element(lua_gui_element_class['methods'], 'clear_items')
    assert 'subclasses' not in clear_items_method
    clear_items_method['subclasses'] = ['drop-down', 'list-box']

    # -- missing subclasses for get_item --
    get_item_method = get_named_array_element(lua_gui_element_class['methods'], 'get_item')
    assert 'subclasses' not in get_item_method
    get_item_method['subclasses'] = ['drop-down', 'list-box']

    # -- missing subclasses for remove_item --
    remove_item_method = get_named_array_element(lua_gui_element_class['methods'], 'remove_item')
    assert 'subclasses' not in remove_item_method
    remove_item_method['subclasses'] = ['drop-down', 'list-box']

    # -- missing subclasses for set_item --
    set_item_method = get_named_array_element(lua_gui_element_class['methods'], 'set_item')
    assert 'subclasses' not in set_item_method
    set_item_method['subclasses'] = ['drop-down', 'list-box']

    # other inconsistencies:
    # subclass 'sprite' is incorrectly called 'image' in resize_to_sprite's description

    # cache API json in file
    with open(API_JSON_PATH, 'w') as api_json_file:
        json.dump(api_json, api_json_file)
else:
    # load from file
    with open(API_JSON_PATH, 'r') as api_json_file:
        api_json = json.load(api_json_file)

# clear previous wrappers
for file in os.scandir(os.fspath(WRAPPER_PATH)):
    if file.name != 'util.lua':
        os.remove(os.fspath(file))

# get LuaGuiElement class
lua_gui_element_class = get_named_array_element(api_json['classes'], 'LuaGuiElement')

# parse wrapper relevant data
wrapper_data = {}

# get attributes
default_attribute_names = [
    'anchor', 'caption', 'enabled', 'gui', 'ignored_by_interaction', 'index', 'location', 'object_name', 'parent',
    'player_index', 'style', 'tags', 'tooltip', 'type', 'valid', 'visible'
]
default_attributes = []
for attribute in lua_gui_element_class['attributes']:
    # parse subclasses
    if 'subclasses' in attribute:
        for subclass in attribute['subclasses']:
            if subclass not in wrapper_data.keys():
                wrapper_data[subclass] = {
                    'attributes': [],
                    'methods': [],
                    'parameters': []
                }
            wrapper_data[subclass]['attributes'].append(attribute)
    elif attribute['name'] in default_attribute_names:
        default_attributes.append(attribute)
    else:
        print(f'ignored attribute {str(attribute)}')

# get parameters
default_parameters = []
default_delayed_parameter_names = []
for attribute in default_attributes:
    if attribute['write']:
        default_delayed_parameter_names.append(attribute['name'])
for parameter in get_named_array_element(lua_gui_element_class['methods'], 'add')['parameters']:
    if parameter['name'] in default_delayed_parameter_names:
        default_delayed_parameter_names.remove(parameter['name'])
    if parameter['name'] not in ['index', 'style', 'type']:
        default_parameters.append(parameter)
for parameter_group in get_named_array_element(lua_gui_element_class['methods'], 'add')['variant_parameter_groups']:
    subclass = parameter_group['name']
    if subclass not in wrapper_data.keys():
        wrapper_data[subclass] = {
            'attributes': [],
            'methods': [],
            'parameters': []
        }
    for parameter in parameter_group['parameters']:
        wrapper_data[subclass]['parameters'].append(parameter)

# get methods
default_method_names = ['bring_to_front', 'focus', 'get_mod', 'help']
default_methods = []
for method in lua_gui_element_class['methods']:
    if 'subclasses' in method:
        for subclass in method['subclasses']:
            if subclass not in wrapper_data.keys():
                wrapper_data[subclass] = {
                    'attributes': [],
                    'methods': [],
                    'parameters': []
                }
            wrapper_data[subclass]['methods'].append(method)
    elif method['name'] in default_method_names:
        default_methods.append(method)
    else:
        print(f'ignored method {str(method)}')
# TODO: fix implementation for add_item? Add items to state?
# TODO: fix slider attributes: get/set_slider_discrete_slider etc.


# create FactorioComponent
with open(WRAPPER_PATH / 'FactorioComponent.lua', 'w') as wrapper_file:
    wrapper_file.write(f'''local Class = require('__poly__.Class')
local Helper = require('__poly__.Helper')
local Component = require('__poly__.GUI.Component')
local EventHandler = require('__poly__.GUI.EventHandler')

local FactorioComponent = Class:new('FactorioComponent', Component)

function FactorioComponent:new(args)
    local factorio_component = Component:new(args)
    factorio_component.lua_gui_element = nil
    factorio_component.lua_gui_element_parameters = {{
        {f',{chr(10)}        '.join([f'{p["name"]} = args.{p["name"]}' for p in default_parameters])}
    }}
    factorio_component.lua_gui_element_delayed_parameters = {{
        {f',{chr(10)}        '.join([f'{p} = args.{p}' for p in default_delayed_parameter_names])}
    }}
    factorio_component.style = args.style
    factorio_component.event_handler_ids = {{}}
    factorio_component.delete_event_handler = args.delete_event_handler
    if factorio_component.delete_event_handler == nil then
        factorio_component.delete_event_handler = true
    end
    for _, event in ipairs {{ 'on_gui_checked_state_changed', 'on_gui_click', 'on_gui_closed', 'on_gui_confirmed',
                             'on_gui_elem_changed', 'on_gui_location_changed', 'on_gui_opened',
                             'on_gui_selected_tab_changed', 'on_gui_selection_state_changed',
                             'on_gui_switch_state_changed', 'on_gui_text_changed', 'on_gui_value_changed' }} do
        local handler = args[event]
        if handler ~= nil then
            if factorio_component.lua_gui_element_parameters.tags == nil then
                factorio_component.lua_gui_element_parameters.tags = {{}}
            end
            if factorio_component.lua_gui_element_parameters.tags.Poly == nil then
                factorio_component.lua_gui_element_parameters.tags.Poly = {{}}
            end
            if type(handler) == 'string' then
                factorio_component.lua_gui_element_parameters.tags.Poly[event] = handler
                if factorio_component.delete_event_handler then
                    factorio_component.event_handler_ids[handler] = true
                end
            else
                factorio_component.lua_gui_element_parameters.tags.Poly[event] = {{}}
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
        Helper.apply_style(self.lua_gui_element, self.style)
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
        Helper.apply_style(self.lua_gui_element, style)
    end
    if type(style) == 'string' then
        self.style = style
    elseif type(style) == 'table' then
        if style[1] ~= nil then
            self.style = style
        else
            if self.style == nil then
                self.style = {{}}
            elseif type(self.style) == 'string' then
                self.style = {{ [1] = self.style }}
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
        return Helper.deep_copy(self.lua_gui_element.tags)
    else
        return Helper.deep_copy(self.lua_gui_element_parameters.tags)
    end
end
function FactorioComponent:set_tags(tags)
    if #self.event_handler_ids > 0 then
        if tags.Poly == nil then
            tags.Poly = {{}}
        end
        for event, handlers in pairs(self.lua_gui_element_parameters.tags.Poly) do
            if type(handlers) == 'string' then
                handlers = {{ handlers }}
            end
            for _, handler in ipairs(handlers) do
                if self.event_handler_ids[handler] then
                    if tags.Poly[event] == nil then
                        tags.Poly[event] = handler
                    elseif type(tags.Poly[event]) == 'string' then
                        tags.Poly[event] = {{ tags.Poly[event], handler }}
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
        self.lua_gui_element_parameters.tags = {{}}
    end
    if self.lua_gui_element_parameters.tags.Poly == nil then
        self.lua_gui_element_parameters.tags.Poly = {{}}
    end
    if type(event_handler) == 'string' then
        if self.lua_gui_element_parameters.tags.Poly[event] == nil then
            self.lua_gui_element_parameters.tags.Poly[event] = event_handler
        elseif type(self.lua_gui_element_parameters.tags.Poly[event]) == 'string' then
            self.lua_gui_element_parameters.tags.Poly[event] = {{
                self.lua_gui_element_parameters.tags.Poly[event],
                event_handler
            }}
        else
            self.lua_gui_element_parameters.tags.Poly[event][#self.lua_gui_element_parameters.tags.Poly[event] + 1] = event_handler
        end
        if self.delete_event_handler then
            self.event_handler_ids[event_handler] = true
        end
    else
        if self.lua_gui_element_parameters.tags.Poly[event] == nil then
            self.lua_gui_element_parameters.tags.Poly[event] = {{}}
        elseif type(self.lua_gui_element_parameters.tags.Poly[event]) == 'string' then
            self.lua_gui_element_parameters.tags.Poly[event] = {{ self.lua_gui_element_parameters.tags.Poly[event] }}
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
''')

    for event in ['on_gui_checked_state_changed', 'on_gui_click', 'on_gui_closed', 'on_gui_confirmed',
                  'on_gui_elem_changed', 'on_gui_location_changed', 'on_gui_opened', 'on_gui_selected_tab_changed',
                  'on_gui_selection_state_changed', 'on_gui_switch_state_changed', 'on_gui_text_changed',
                  'on_gui_value_changed']:
        wrapper_file.write(f'''
function FactorioComponent:add_{event}(event_handler)
    add_event_handler(self, '{event}', event_handler)
end''')

    for attribute in default_attributes:
        first = True
        if attribute['read']:
            if attribute['name'] in ['style']:
                # skip some getters
                continue
            wrapper_file.write(('\n\n' if first else '\n') + definition_getter(
                'FactorioComponent', attribute, attribute['name'] in default_delayed_parameter_names
            ))
            first = False
        if attribute['write']:
            if attribute['name'] in ['name', 'style', 'tags']:
                # skip some setters
                continue
            wrapper_file.write(('\n\n' if first else '\n') + definition_setter(
                'FactorioComponent', attribute, attribute['name'] in default_delayed_parameter_names
            ))
            first = False

    for method in default_methods:
        wrapper_file.write('\n\n' + definition_method('FactorioComponent', method))

    wrapper_file.write('\n\nreturn FactorioComponent')

# create type wrappers
for subclass, data in wrapper_data.items():
    # format subclass name
    camel_case_subclass = subclass
    if subclass[0] == subclass[0].lower():
        # capitalize first letter
        camel_case_subclass = camel_case_subclass[0].upper() + camel_case_subclass[1:]
        # remove dashes and capitalize following letters
        for i in range(len(camel_case_subclass) - 1, -1, -1):
            if camel_case_subclass[i] == '-':
                camel_case_subclass = camel_case_subclass[:i] + camel_case_subclass[
                    i + 1].upper() + camel_case_subclass[i + 2:]
    snake_case_subclass = camel_case_subclass[0].lower() + camel_case_subclass[1:]
    # insert underscore before uppercase letters and make them lowercase
    i = 1
    while i < len(snake_case_subclass):
        if snake_case_subclass[i] == snake_case_subclass[i].upper():
            snake_case_subclass = snake_case_subclass[:i] + '_' + snake_case_subclass[i].lower() + snake_case_subclass[
                                                                                                   i + 1:]
            i += 1  # skip inserted underscore
        i += 1
    dashed_snake_case_subclass = snake_case_subclass.replace('_', '-')

    # create wrapper file
    with open(WRAPPER_PATH / (camel_case_subclass + '.lua'), 'w') as wrapper_file:
        wrapper_file.write(create_wrapper(camel_case_subclass, snake_case_subclass, dashed_snake_case_subclass,
                                          data['parameters'],
                                          data['attributes'],
                                          data['methods'],
                                          api_json['application_version'], api_json['api_version']))
