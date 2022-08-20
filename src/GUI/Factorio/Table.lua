-- Poly: generated for Factorio 1.1.67 runtime API 3

local Class = require('__poly__.Class')
local Component = require('__poly__.GUI.Component')
local FactorioComponent = require('__poly__.GUI.Factorio.FactorioComponent')

local Table = Class:new('Table', FactorioComponent)

function Table:new(args)
    local table = FactorioComponent:new(args)
    table.lua_gui_element_parameters.type = 'table'
    
    table.lua_gui_element_parameters.column_count = args.column_count
    table.lua_gui_element_parameters.draw_horizontal_line_after_headers = args.draw_horizontal_line_after_headers
    table.lua_gui_element_parameters.draw_horizontal_lines = args.draw_horizontal_lines
    table.lua_gui_element_parameters.draw_vertical_lines = args.draw_vertical_lines
    table.lua_gui_element_parameters.vertical_centering = args.vertical_centering
    table.lua_gui_element_delayed_parameters.drag_target = args.drag_target
    
    return table
end

function Table:get_column_count()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.column_count
    else
        return self.lua_gui_element_parameters.column_count
    end
end

function Table:get_drag_target()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.drag_target
    else
        return self.lua_gui_element_delayed_parameters.drag_target
    end
end
function Table:set_drag_target(drag_target)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.drag_target = drag_target
    end
    self.lua_gui_element_delayed_parameters.drag_target = drag_target
end

function Table:get_draw_horizontal_line_after_headers()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.draw_horizontal_line_after_headers
    else
        return self.lua_gui_element_parameters.draw_horizontal_line_after_headers
    end
end
function Table:set_draw_horizontal_line_after_headers(draw_horizontal_line_after_headers)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.draw_horizontal_line_after_headers = draw_horizontal_line_after_headers
    end
    self.lua_gui_element_parameters.draw_horizontal_line_after_headers = draw_horizontal_line_after_headers
end

function Table:get_draw_horizontal_lines()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.draw_horizontal_lines
    else
        return self.lua_gui_element_parameters.draw_horizontal_lines
    end
end
function Table:set_draw_horizontal_lines(draw_horizontal_lines)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.draw_horizontal_lines = draw_horizontal_lines
    end
    self.lua_gui_element_parameters.draw_horizontal_lines = draw_horizontal_lines
end

function Table:get_draw_vertical_lines()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.draw_vertical_lines
    else
        return self.lua_gui_element_parameters.draw_vertical_lines
    end
end
function Table:set_draw_vertical_lines(draw_vertical_lines)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.draw_vertical_lines = draw_vertical_lines
    end
    self.lua_gui_element_parameters.draw_vertical_lines = draw_vertical_lines
end

function Table:get_vertical_centering()
    if self:get_state() == Component.State.Created then
        return self.lua_gui_element.vertical_centering
    else
        return self.lua_gui_element_parameters.vertical_centering
    end
end
function Table:set_vertical_centering(vertical_centering)
    if self:get_state() == Component.State.Created then
        self.lua_gui_element.vertical_centering = vertical_centering
    end
    self.lua_gui_element_parameters.vertical_centering = vertical_centering
end

return Table
