-- Poly: generated for Factorio 1.1.68 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local Textfield = Class:new('Poly.GUI.Textfield', FactorioComponent)

function Textfield:new(args)
    local textfield = FactorioComponent:new(args)
    textfield.lua_gui_element_parameters.type = 'textfield'
    
    textfield.lua_gui_element_parameters.allow_decimal = args.allow_decimal
    textfield.lua_gui_element_parameters.allow_negative = args.allow_negative
    textfield.lua_gui_element_parameters.clear_and_focus_on_right_click = args.clear_and_focus_on_right_click
    textfield.lua_gui_element_parameters.is_password = args.is_password
    textfield.lua_gui_element_parameters.lose_focus_on_confirm = args.lose_focus_on_confirm
    textfield.lua_gui_element_parameters.numeric = args.numeric
    textfield.lua_gui_element_parameters.text = args.text
    
    return textfield
end

function Textfield:get_allow_decimal()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.allow_decimal
    else
        return self.lua_gui_element_parameters.allow_decimal
    end
end
function Textfield:set_allow_decimal(allow_decimal)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.allow_decimal = allow_decimal
    end
    self.lua_gui_element_parameters.allow_decimal = allow_decimal
end

function Textfield:get_allow_negative()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.allow_negative
    else
        return self.lua_gui_element_parameters.allow_negative
    end
end
function Textfield:set_allow_negative(allow_negative)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.allow_negative = allow_negative
    end
    self.lua_gui_element_parameters.allow_negative = allow_negative
end

function Textfield:get_clear_and_focus_on_right_click()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.clear_and_focus_on_right_click
    else
        return self.lua_gui_element_parameters.clear_and_focus_on_right_click
    end
end
function Textfield:set_clear_and_focus_on_right_click(clear_and_focus_on_right_click)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.clear_and_focus_on_right_click = clear_and_focus_on_right_click
    end
    self.lua_gui_element_parameters.clear_and_focus_on_right_click = clear_and_focus_on_right_click
end

function Textfield:get_is_password()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.is_password
    else
        return self.lua_gui_element_parameters.is_password
    end
end
function Textfield:set_is_password(is_password)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.is_password = is_password
    end
    self.lua_gui_element_parameters.is_password = is_password
end

function Textfield:get_lose_focus_on_confirm()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.lose_focus_on_confirm
    else
        return self.lua_gui_element_parameters.lose_focus_on_confirm
    end
end
function Textfield:set_lose_focus_on_confirm(lose_focus_on_confirm)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.lose_focus_on_confirm = lose_focus_on_confirm
    end
    self.lua_gui_element_parameters.lose_focus_on_confirm = lose_focus_on_confirm
end

function Textfield:get_numeric()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.numeric
    else
        return self.lua_gui_element_parameters.numeric
    end
end
function Textfield:set_numeric(numeric)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.numeric = numeric
    end
    self.lua_gui_element_parameters.numeric = numeric
end

function Textfield:get_text()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.text
    else
        return self.lua_gui_element_parameters.text
    end
end
function Textfield:set_text(text)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.text = text
    end
    self.lua_gui_element_parameters.text = text
end

function Textfield:select(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.select(...)
end

function Textfield:select_all(...)
    assert(self:get_state() == Component.State.Created, 'LuaGuiElement methods can only be called after the component has been created')
    self.lua_gui_element.select_all(...)
end

return Textfield
