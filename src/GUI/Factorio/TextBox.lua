-- Poly: generated for Factorio 1.1.67 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local TextBox = Class:new('TextBox', FactorioComponent)

function TextBox:new(args)
    local text_box = FactorioComponent:new(args)
    text_box.lua_gui_element_parameters.type = 'text-box'
    
    text_box.lua_gui_element_parameters.clear_and_focus_on_right_click = args.clear_and_focus_on_right_click
    text_box.lua_gui_element_parameters.text = args.text
    text_box.lua_gui_element_delayed_parameters.read_only = args.read_only
    text_box.lua_gui_element_delayed_parameters.selectable = args.selectable
    text_box.lua_gui_element_delayed_parameters.word_wrap = args.word_wrap
    
    return text_box
end

function TextBox:get_clear_and_focus_on_right_click()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.clear_and_focus_on_right_click
    else
        return self.lua_gui_element_parameters.clear_and_focus_on_right_click
    end
end
function TextBox:set_clear_and_focus_on_right_click(clear_and_focus_on_right_click)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.clear_and_focus_on_right_click = clear_and_focus_on_right_click
    end
    self.lua_gui_element_parameters.clear_and_focus_on_right_click = clear_and_focus_on_right_click
end

function TextBox:get_read_only()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.read_only
    else
        return self.lua_gui_element_delayed_parameters.read_only
    end
end
function TextBox:set_read_only(read_only)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.read_only = read_only
    end
    self.lua_gui_element_delayed_parameters.read_only = read_only
end

function TextBox:get_selectable()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.selectable
    else
        return self.lua_gui_element_delayed_parameters.selectable
    end
end
function TextBox:set_selectable(selectable)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.selectable = selectable
    end
    self.lua_gui_element_delayed_parameters.selectable = selectable
end

function TextBox:get_text()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.text
    else
        return self.lua_gui_element_parameters.text
    end
end
function TextBox:set_text(text)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.text = text
    end
    self.lua_gui_element_parameters.text = text
end

function TextBox:get_word_wrap()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.word_wrap
    else
        return self.lua_gui_element_delayed_parameters.word_wrap
    end
end
function TextBox:set_word_wrap(word_wrap)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.word_wrap = word_wrap
    end
    self.lua_gui_element_delayed_parameters.word_wrap = word_wrap
end

function TextBox:scroll_to_bottom(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.scroll_to_bottom(...)
end

function TextBox:scroll_to_left(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.scroll_to_left(...)
end

function TextBox:scroll_to_right(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.scroll_to_right(...)
end

function TextBox:scroll_to_top(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.scroll_to_top(...)
end

function TextBox:select(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.select(...)
end

function TextBox:select_all(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.select_all(...)
end

return TextBox
